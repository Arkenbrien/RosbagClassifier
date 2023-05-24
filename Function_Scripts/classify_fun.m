function diag_out = classify_fun(xyz_cloud, chan_bounds, chan_rdf, tform, cloud, options, chan_area)
    
    %% Temp Debug

%     chan_bounds = chan_2_c_bounds;
%     xyz_cloud = xyz_cloud_2;
%     chan_rdf = chan_2_c_rdf;
    % xy_roi = Manual_Classfied_Areas.asph
    % classify_fun(xyz_cloud_3, chan_3_r_bounds, chan_3_rdf, tform, cloud, export_dir, "3r")
    % chan_bounds = chan_3_r_bounds;
    % xyz_cloud = xyz_cloud_3;
    % chan_rdf = chan_3_rdf;
    % chan_area = "3c";
    % cloud = 1;
    % xy_roi = Manual_Classfied_Areas.asph
    
    
    %% Classification Function

    % Find points in the arc
    arc_idx = find((atan2(xyz_cloud(:,1), xyz_cloud(:,2))) > chan_bounds(1) & (atan2(xyz_cloud(:,1), xyz_cloud(:,2))) <  chan_bounds(2));
    
    if ~isempty(arc_idx) && length(arc_idx) >= 4

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
        
%         if scores(2) > 0.2
%             
%             Yfit = categorical("unknown");
%             
%         end

        if options.conf_filt_bool
            
            if options.reference_point == "range" || options.reference_point == "mls"

                if isequal((Yfit), 'gravel') && contains(chan_area, "2") && scores(3) < options.c2gravconfupbound && scores(2) > options.c2unknconflwbound

                    Yfit = categorical("unknown");

                end

                if isequal((Yfit), 'gravel') && contains(chan_area, "3") && scores(3) < options.c3asphconfupbound  % asph gras grav

                    Yfit = categorical("unknown");

                end

                if isequal((Yfit), 'gravel') && contains(chan_area, "4") && scores(3) < options.c4gravconfupbound

                    Yfit = categorical("unknown");

                end
                
            elseif options.reference_point == "ransac"
                
                % Do Something
                if isequal((Yfit), 'grass') && contains(chan_area, "2") && scores(2) < options.c2unknconfupbound && scores(3) > options.c2gravconflwbound

                    Yfit = categorical("gravel");

                end
                
                % Do Something
                if isequal((Yfit), 'grass') && contains(chan_area, "3") && scores(2) < options.c3unknconfupbound && scores(3) > options.c3gravconflwbound

                    Yfit = categorical("gravel");

                end
                
                % Do Something
                if isequal((Yfit), 'grass') && contains(chan_area, "4") && scores(2) < options.c4unknconfupbound && scores(3) > options.c4gravconflwbound

                    Yfit = categorical("gravel");

                end
                
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
        
        diag_out.Yfit = Yfit;
        
        diag_out.points = xyz_cloud(arc_idx,:);
        
        diag_out.scores = scores;

        %Creates pcd file name
        n_strPadded             = sprintf('%08d', cloud);
        Classification_FileName = string(options.export_dir) + "/" + string(chan_area) + "_" + string(cloud) + "_" + string(n_strPadded) + ".mat";

        % Saves it
        RosbagClassifier_parsave(Classification_FileName, Yfit, [], [], xyz_cloud(arc_idx,:), tform);
        
        
    else
                
        diag_out.classify_time = 0;
        
        diag_out.Yfit = [];
        
    end

end