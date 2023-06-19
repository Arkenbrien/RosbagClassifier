function auto_road_guesser(Avg_Arrays, Manual_Classfied_Areas, options, tform)
    
    %% VAR INIT
    
    clear left_area_export cent_area_export right_area_export
    
    face_alpha_value                    = 0.15;
    
    area_guess_opts.c2g_min             = 0.25;
    area_guess_opts.c2a_min             = 0.25;
    
    area_guess_opts.c3g_min             = 0.25;
    area_guess_opts.c3a_min             = 0.25;
    
    area_guess_opts.c4g_min             = 0.45;
    area_guess_opts.c4a_min             = 0.25;
    
    area_guess_opts.d43_32_ratio_max    = 1.25;
    area_guess_opts.d23_min             = 0;
    area_guess_opts.d34_min             = 0;
    
    area_guess_opts.stdv                = 1;
    area_guess_opts.animate             = 1;
    
    area_guess_opts.close_threshold     = 1;
    area_guess_opts.far_threshold       = 3;

    
    road_check_areas = get_road_check_areas();
    
    
    %% Per Tform Check Areas
    
    for tform_idx = 1:length(tform)
        
        % Process...
        % For each area
        % Get num points for each terrain class in area
        % Get percentage distribution for each channel
        % Logic for if the stuff is kosher
        % Save the area is kosher
        % Plot areas

        %% Transform the road_check_areas
        
        tformed_l = [road_check_areas.lx', road_check_areas.ly', road_check_areas.h'] * tform{tform_idx}.Rotation + tform{tform_idx}.Translation;
        tformed_c = [road_check_areas.cx', road_check_areas.cy', road_check_areas.h'] * tform{tform_idx}.Rotation + tform{tform_idx}.Translation;
        tformed_r = [road_check_areas.rx', road_check_areas.ry', road_check_areas.h'] * tform{tform_idx}.Rotation + tform{tform_idx}.Translation;
        tformed_origin = [0, 0, 0] * tform{tform_idx}.Rotation + tform{tform_idx}.Translation;
        
        %% Get the Result
        
        left_area_export{tform_idx} = check_areas(Avg_Arrays, tformed_l, tformed_origin, area_guess_opts);
        cent_area_export{tform_idx} = check_areas(Avg_Arrays, tformed_c, tformed_origin, area_guess_opts);
        right_area_export{tform_idx} = check_areas(Avg_Arrays, tformed_r, tformed_origin, area_guess_opts);        
        
    end
    
    
    %% Animate
    
    if options.plot_ani
        
        animate_road_guess(left_area_export, cent_area_export, right_area_export, options)
        
    end
    
    
    %% Plot the areas
    close all
    plot_road_guess(left_area_export, cent_area_export, right_area_export, Manual_Classfied_Areas, Avg_Arrays, options)
    
    
    %% Diag test
    
%     auto_road_test_plot(left_area_export, cent_area_export, right_area_export, options)

    
end

