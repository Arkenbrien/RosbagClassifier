function diag_out = classify_fun(xyz_cloud, chan_bounds, chan_rdf, tform, cloud, export_dir, DvG, chan_area)
    
%% Temp Debug

% chan_bounds = chan_2_c_bounds;
% xyz_cloud = xyz_cloud_2;
% chan_rdf = chan_2_rdf;
% xy_roi = Manual_Classfied_Areas.asph
% classify_fun(xyz_cloud_3, chan_3_r_bounds, chan_3_rdf, tform, cloud, export_dir, "3r")
% chan_bounds = chan_3_r_bounds;
% xyz_cloud = xyz_cloud_3;
% chan_rdf = chan_3_rdf;
% chan_area = "3c";
% cloud = 1;
% xy_roi = Manual_Classfied_Areas.asph

%% Init

    diag_out = [0 0 0];
    
    %% Classification Function

    % Find points in the arc
    arc_idx = find((atan2(xyz_cloud(:,1), xyz_cloud(:,2))) > chan_bounds(1) & (atan2(xyz_cloud(:,1), xyz_cloud(:,2))) <  chan_bounds(2));
    
    if ~isempty(arc_idx)

        % Apply Transformation
        xyz_cloud(:,1:3)      = xyz_cloud(:,1:3) * tform.Rotation + tform.Translation;

        % Grab Data
        chan_feat_table   = get_feats_2(xyz_cloud(arc_idx,:));
        
        [Yfit, scores]  = chan_rdf.Mdl.ClassificationEnsemble.predict(chan_feat_table);
        
        % Diag
        if isequal((Yfit), 'gravel') % && contains(chan_area, "2")
            
            diag_out = scores;
                        
        end


        if isequal((Yfit), 'gravel') && contains(chan_area, "2") && scores(3) < 0.95 
                        
            Yfit = categorical("unknown");
            
        end
        
        if isequal((Yfit), 'gravel') && contains(chan_area, "3") && scores(1) > 0.22 && scores(2) < 0.20 && scores(3) < 0.60 % asph gras grav
                        
            Yfit = categorical("unknown");
            
        end
        
        if isequal((Yfit), 'gravel') && contains(chan_area, "4") && scores(3) < 0.90 
            
            Yfit = categorical("unknown");
            
        end
% 
%         if isequal((Yfit), 'gravel')
%             
%             % sssssssssssssss
%             [Yfit, scores]  = DvG.DvG.c2.ClassificationEnsemble.predict(chan_feat_table);
%             
%             if scores(1) < 0.99
%                 
%                 Yfit = categorical("gravel");
%                 
%             end
%             
%         end
% 


        % For the purpose of this work, grass is to be classified as
        % Unknown, simply because I'm not concerned about whether or not I
        % can detect a grassy area, only seperate it from the two pavement
        % types.
        if isequal((Yfit), 'grass') % && contains(chan_area, "2") || isequal((Yfit), 'grass') && contains(chan_area, "4")
            
            Yfit = categorical("unknown");
            
        end

        %Creates pcd file name
        n_strPadded             = sprintf('%08d', cloud);
        Classification_FileName = string(export_dir) + "/" + string(chan_area) + "_" + string(cloud) + "_" + string(n_strPadded) + ".mat";

        % Saves it
        RosbagClassifier_parsave(Classification_FileName, Yfit, [], [], xyz_cloud(arc_idx,:), tform);
        
    end

end