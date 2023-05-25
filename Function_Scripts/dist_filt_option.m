function dist_filt_out = dist_filt_option() 

    %% INCOMLPLETED PLEASE DON'T USE THIS YET!

    %% Classification Area 2

    % Classify using slightly different function so that the distances can be exploited
    classify_fun_out_2c{cloud} = classify_fun_No_Save(xyz_cloud_2, chan_2_c_bounds, chan_2_c_rdf, tform, cloud, options, conf_filt_bool, "2c");
    classify_fun_out_3c{cloud} = classify_fun_No_Save(xyz_cloud_3, chan_3_c_bounds, chan_3_c_rdf, tform, cloud, options, conf_filt_bool, "3c");
    classify_fun_out_4c{cloud} = classify_fun_No_Save(xyz_cloud_4, chan_4_c_bounds, chan_4_c_rdf, tform, cloud, options, conf_filt_bool, "4c");

    classify_fun_out_2l{cloud} = classify_fun_No_Save(xyz_cloud_2, chan_2_l_bounds, chan_2_l_rdf, tform, cloud, options, conf_filt_bool, "2l");
    classify_fun_out_3l{cloud} = classify_fun_No_Save(xyz_cloud_3, chan_3_l_bounds, chan_3_l_rdf, tform, cloud, options, conf_filt_bool, "3l");
    classify_fun_out_4l{cloud} = classify_fun_No_Save(xyz_cloud_4, chan_4_l_bounds, chan_4_l_rdf, tform, cloud, options, conf_filt_bool, "4l");

    classify_fun_out_2r{cloud} = classify_fun_No_Save(xyz_cloud_2, chan_2_r_bounds, chan_2_r_rdf, tform, cloud, options, conf_filt_bool, "2r");
    classify_fun_out_3r{cloud} = classify_fun_No_Save(xyz_cloud_3, chan_3_r_bounds, chan_3_r_rdf, tform, cloud, options, conf_filt_bool, "3r");
    classify_fun_out_4r{cloud} = classify_fun_No_Save(xyz_cloud_4, chan_4_r_bounds, chan_4_r_rdf, tform, cloud, options, conf_filt_bool, "4r");


    %% Getting distance between points

    % Mean Points
    c_2_mean = [mean(xyz_cloud_2(classify_fun_out_2c{cloud}.arc_idx_2c,1)), mean(xyz_cloud_2(classify_fun_out_2c{cloud}.arc_idx_2c,2)), mean(xyz_cloud_2(classify_fun_out_2c{cloud}.arc_idx_2c,3))];
    c_3_mean = [mean(xyz_cloud_3(classify_fun_out_3c{cloud}.arc_idx_3c,1)), mean(xyz_cloud_3(classify_fun_out_3c{cloud}.arc_idx_3c,2)), mean(xyz_cloud_3(classify_fun_out_3c{cloud}.arc_idx_3c,3))];
    c_4_mean = [mean(xyz_cloud_4(classify_fun_out_4c{cloud}.arc_idx_4c,1)), mean(xyz_cloud_4(classify_fun_out_4c{cloud}.arc_idx_4c,2)), mean(xyz_cloud_4(classify_fun_out_4c{cloud}.arc_idx_4c,3))];

    l_2_mean = [mean(xyz_cloud_2(classify_fun_out_2l{cloud}.arc_idx_2l,1)), mean(xyz_cloud_2(classify_fun_out_2l{cloud}.arc_idx_2l,2)), mean(xyz_cloud_2(classify_fun_out_2l{cloud}.arc_idx_2l,3))];
    l_3_mean = [mean(xyz_cloud_3(classify_fun_out_3l{cloud}.arc_idx_3l,1)), mean(xyz_cloud_3(classify_fun_out_3l{cloud}.arc_idx_3l,2)), mean(xyz_cloud_3(classify_fun_out_3l{cloud}.arc_idx_3l,3))];
    l_4_mean = [mean(xyz_cloud_4(classify_fun_out_4l{cloud}.arc_idx_4l,1)), mean(xyz_cloud_4(classify_fun_out_4l{cloud}.arc_idx_4l,2)), mean(xyz_cloud_4(classify_fun_out_4l{cloud}.arc_idx_4l,3))];

    r_2_mean = [mean(xyz_cloud_2(classify_fun_out_2r{cloud}.arc_idx_2r,1)), mean(xyz_cloud_2(classify_fun_out_2r{cloud}.arc_idx_2r,2)), mean(xyz_cloud_2(classify_fun_out_2r{cloud}.arc_idx_2r,3))];
    r_3_mean = [mean(xyz_cloud_3(classify_fun_out_3r{cloud}.arc_idx_3r,1)), mean(xyz_cloud_3(classify_fun_out_3r{cloud}.arc_idx_3r,2)), mean(xyz_cloud_3(classify_fun_out_3r{cloud}.arc_idx_3r,3))];
    r_4_mean = [mean(xyz_cloud_4(classify_fun_out_4r{cloud}.arc_idx_4r,1)), mean(xyz_cloud_4(classify_fun_out_4r{cloud}.arc_idx_4r,2)), mean(xyz_cloud_4(classify_fun_out_4r{cloud}.arc_idx_4r,3))];

    % center 
    c_23_dist{cloud} = sqrt( (c_2_mean(1) - c_3_mean(1))^2 + (c_2_mean(2) - c_3_mean(2))^2 + (c_2_mean(3) - c_3_mean(3))^2);
    c_34_dist{cloud} = sqrt( (c_4_mean(1) - c_3_mean(1))^2 + (c_4_mean(2) - c_3_mean(2))^2 + (c_4_mean(3) - c_3_mean(3))^2);

    % left 
    l_23_dist{cloud} = sqrt( (c_2_mean(1) - c_3_mean(1))^2 + (c_2_mean(2) - c_3_mean(2))^2 + (c_2_mean(3) - c_3_mean(3))^2);
    l_34_dist{cloud} = sqrt( (c_4_mean(1) - c_3_mean(1))^2 + (c_4_mean(2) - c_3_mean(2))^2 + (c_4_mean(3) - c_3_mean(3))^2);

    % right 
    r_23_dist{cloud} = sqrt( (c_2_mean(1) - c_3_mean(1))^2 + (c_2_mean(2) - c_3_mean(2))^2 + (c_2_mean(3) - c_3_mean(3))^2);
    r_34_dist{cloud} = sqrt( (c_4_mean(1) - c_3_mean(1))^2 + (c_4_mean(2) - c_3_mean(2))^2 + (c_4_mean(3) - c_3_mean(3))^2);

    %% Consecutive point logic

    % Center
    if ~isequal(classify_fun_out_2c{cloud}.Yfit, classify_fun_out_3c{cloud}.Yfit) && c_23_dist{cloud} <= min_dist_23 || ~isequal(classify_fun_out_2c{cloud}.Yfit, classify_fun_out_3c{cloud}.Yfit) && c_23_dist{cloud} >= max_dist_23

        Yfit_2c = categorical("unknown");
        Yfit_3c = categorical("unknown");

    end

    if ~isequal(classify_fun_out_3c{cloud}.Yfit, classify_fun_out_4c{cloud}.Yfit) && c_34_dist{cloud} <= min_dist_34 || ~isequal(classify_fun_out_3c{cloud}.Yfit, classify_fun_out_4c{cloud}.Yfit) && c_23_dist{cloud} >= max_dist_34

        Yfit_3c = categorical("unknown");
        Yfit_4c = categorical("unknown");

    end

    % Left
    if ~isequal(classify_fun_out_2l{cloud}.Yfit, classify_fun_out_3l{cloud}.Yfit) && l_23_dist{cloud} <= min_dist_23 || ~isequal(classify_fun_out_2l{cloud}.Yfit, classify_fun_out_3l{cloud}.Yfit) && l_23_dist{cloud} >= max_dist_23

        Yfit_2l = categorical("unknown");
        Yfit_3l = categorical("unknown");

    end

    if ~isequal(classify_fun_out_3l{cloud}.Yfit, classify_fun_out_4l{cloud}.Yfit) && l_34_dist{cloud} <= min_dist_34 || ~isequal(classify_fun_out_3l{cloud}.Yfit, classify_fun_out_4l{cloud}.Yfit) && l_23_dist{cloud} >= max_dist_34

        Yfit_3l = categorical("unknown");
        Yfit_4l = categorical("unknown");

    end

    % Right
    if ~isequal(classify_fun_out_2r{cloud}.Yfit, classify_fun_out_3r{cloud}.Yfit) && r_23_dist{cloud} <= min_dist_23 || ~isequal(classify_fun_out_2r{cloud}.Yfit, classify_fun_out_3r{cloud}.Yfit) && r_23_dist{cloud} >= max_dist_23

        Yfit_2c = categorical("unknown");
        Yfit_3c = categorical("unknown");

    end

    if ~isequal(classify_fun_out_3r{cloud}.Yfit, classify_fun_out_4r{cloud}.Yfit) && r_34_dist{cloud} <= min_dist_34 || ~isequal(classify_fun_out_3r{cloud}.Yfit, classify_fun_out_4r{cloud}.Yfit) && r_23_dist{cloud} >= max_dist_34

        Yfit_3r = categorical("unknown");
        Yfit_4r = categorical("unknown");

    end

    %% Saving the Data for the above area

    RosbagClassifier_parsave_tform(classify_fun_out_2c.Classification_FileName_2c, Yfit_2c, [], [], xyz_cloud_2(arc_idx_2c,:), tform);
    RosbagClassifier_parsave_tform(classify_fun_out_3c.Classification_FileName_3c, Yfit_3c, [], [], xyz_cloud_3(arc_idx_3c,:), tform);
    RosbagClassifier_parsave_tform(classify_fun_out_4c.Classification_FileName_4c, Yfit_4c, [], [], xyz_cloud_4(arc_idx_4c,:), tform);

    RosbagClassifier_parsave_tform(classify_fun_out_2l.Classification_FileName_2l, Yfit_2l, [], [], xyz_cloud_2(arc_idx_2l,:), tform);
    RosbagClassifier_parsave_tform(classify_fun_out_3l.Classification_FileName_3l, Yfit_3l, [], [], xyz_cloud_3(arc_idx_3l,:), tform);
    RosbagClassifier_parsave_tform(classify_fun_out_4l.Classification_FileName_4l, Yfit_4l, [], [], xyz_cloud_4(arc_idx_4l,:), tform);

    RosbagClassifier_parsave_tform(classify_fun_out_2r.Classification_FileName_2r, Yfit_2r, [], [], xyz_cloud_2(arc_idx_2r,:), tform);
    RosbagClassifier_parsave_tform(classify_fun_out_3r.Classification_FileName_3r, Yfit_3r, [], [], xyz_cloud_3(arc_idx_3r,:), tform);
    RosbagClassifier_parsave_tform(classify_fun_out_4r.Classification_FileName_4r, Yfit_4r, [], [], xyz_cloud_4(arc_idx_4r,:), tform);
    
end