function [diag_out] = classify_fun_No_Save(xyz_cloud, chan_bounds, chan_rdf, tform, cloud, options, conf_filt_bool, chan_area)
    
    %% Temp Debug
    % chan_bounds = chan_3_r_bounds;
    % xyz_cloud = xyz_cloud_3;
    % chan_rdf = chan_3_rdf;
    % chan_area = "2c";
    % cloud = 1;
    % xy_roi = Manual_Classfied_Areas.asph

    %% Init

    diag_out = [0 0 0];
    Classification_FileName = "";
    Yfit = categorical("unknown");
    
    export_dir = string(options.export_dir );
    
    
    %% Classification Function

    % Find points in the arc
    arc_idx = find((atan2(xyz_cloud(:,1), xyz_cloud(:,2))) > chan_bounds(1) & (atan2(xyz_cloud(:,1), xyz_cloud(:,2))) <  chan_bounds(2));
    
    if ~isempty(arc_idx)

        % Apply Transformation
        xyz_cloud(:,1:3)      = xyz_cloud(:,1:3) * tform.Rotation + tform.Translation;

        % Grab Data
        if options.reference_point == "range"

            chan_feat_table   = get_RANGE_feats_2(xyz_cloud(arc_idx,:));

        elseif options.reference_point == "ransac"

            chan_feat_table   = get_RANSAC_feats_2(xyz_cloud(arc_idx,:), options);

        elseif options.reference_point == "mls" 

            chan_feat_table   = get_MLS_feats_2(xyz_cloud(arc_idx,:));

        end
        
        classify_time_start = tic;
        
        [Yfit, scores]  = chan_rdf.Mdl.ClassificationEnsemble.predict(chan_feat_table);
        
%         [Yfit, scores, ~]  = chan_rdf.Mdl.predict(chan_feat_table);
        
        % Diag out
        if isequal((Yfit), {'gravel'})
            
            diag_out = scores;
                        
        end
        
            if  conf_filt_bool

            if isequal((Yfit), 'gravel') && contains(chan_area, "2") && scores(3) < 0.80 && scores(2) > 0.10

                Yfit = categorical("unknown");

            end

            if isequal((Yfit), 'gravel') && contains(chan_area, "3") && scores(3) < 0.80 && scores(2) > 0.10

                Yfit = categorical("unknown");

            end

            if isequal((Yfit), 'gravel') && contains(chan_area, "4") && scores(3) < 0.80 && scores(2) > 0.10

                Yfit = categorical("unknown");

            end
        
        end

        % For the purpose of this work, grass is to be classified as
        % Unknown, simply because I'm not concerned about whether or not I
        % can detect a grassy area, only seperate it from the two pavement
        % types.
        if isequal((Yfit), 'grass') % && contains(chan_area, "2") || isequal((Yfit), 'grass') && contains(chan_area, "4")
            
            Yfit = categorical("unknown");
            
        end
        
        classify_time_end = toc(classify_time_start);
        
        diag_out.classify_time = classify_time_end;

        %Creates pcd file name
        n_strPadded             = sprintf('%08d', cloud);
        diag_out.Classification_FileName = string(export_dir) + "/" + string(chan_area) + "_" + string(cloud) + "_" + string(n_strPadded) + ".mat";
        
        % Other Things go Out Here
        diag_out.Yfit = Yfit;
        diag_out.arc_idx = arc_idx;
        
        
        % Saves it
%         RosbagClassifier_parsave(Classification_FileName, Yfit, [], [], xyz_cloud(arc_idx,:), tform);

    else
        
        disp('oops')
      
    end
    
    

end