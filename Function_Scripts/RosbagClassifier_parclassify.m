function RosbagClassifier_parclassify(cloud, chan_idxs, CLASSIFICATION_STACK_FOLDER, xyz_cloud_2, xyz_cloud_5, arc_idx, chan_2_rdf, chan_5_rdf)

    %% quick and dirty var assignment
    if any(arc_idx == 1:3)
        
        xyz_cloud   = xyz_cloud_2;
        Mdl = chan_2_rdf.Mdl;
        
        if arc_idx == 1
            area_idx    = chan_idxs.chan_2_left_idxs;
            area_name   = "/LEFT_2_";
        elseif arc_idx == 2
            area_idx    = chan_idxs.chan_2_cent_idxs;
            area_name   = "/CENT_2_";
        elseif arc_idx == 3
            area_idx    = chan_idxs.chan_2_rite_idxs;
            area_name   = "/RIGHT_2_";
        end
        
    elseif any(arc_idx == 4:6)
        
        xyz_cloud   = xyz_cloud_5;
        Mdl         = chan_5_rdf.Mdl;
        
        if arc_idx == 4
            area_idx    = chan_idxs.chan_5_left_idxs;
            area_name   = "/LEFT_5_";
        elseif arc_idx == 5
            area_idx    = chan_idxs.chan_5_cent_idxs;
            area_name   = "/CENT_5_";
        elseif arc_idx == 6
            area_idx    = chan_idxs.chan_5_rite_idxs;
            area_name   = "/RIGHT_5_";
        end
        
    end
     
    % Getting Features
    table_export = get_feats_2(xyz_cloud(area_idx,:),[]);

    % Classification
    [Yfit, scores, stdevs]              = predict(Mdl, table_export);

    %Creates pcd file name
    n_strPadded             = sprintf('%08d', cloud);
    Classification_FileName = string(CLASSIFICATION_STACK_FOLDER) + string(area_name) + string(n_strPadded) + ".mat";

    % Saves (REDUNDANCY IS GOOD REDUNDANCY IS GOOD REDUNDANCY IS GOOD)
    RosbagClassifier_parsave(Classification_FileName,...
                             Yfit,... 
                             scores,...
                             stdevs,...
                             xyz_cloud(area_idx,:))
    
end
        