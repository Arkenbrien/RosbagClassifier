function auto_road_guesser(Avg_Arrays, Manual_Classfied_Areas, options, tform)
    
    %% VAR INIT

    face_alpha_value = 0.15;
    
    area_guess_opts.c2g_min = 0.25;
    area_guess_opts.c2a_min = 0.25;
    
    area_guess_opts.c3g_min = 0.25;
    area_guess_opts.c3a_min = 0.25;
    
    area_guess_opts.c4g_min = 0.25;
    area_guess_opts.c4a_min = 0.25;
    
    area_guess_opts.stdv = 1;
    
    area_guess_opts.animate = 1;
    
    clear left_area_export cent_area_export right_area_export
    
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

        %% Get the Result
        
        left_area_export{tform_idx} = check_areas(Avg_Arrays, tformed_l, area_guess_opts);
        cent_area_export{tform_idx} = check_areas(Avg_Arrays, tformed_c, area_guess_opts);
        right_area_export{tform_idx} = check_areas(Avg_Arrays, tformed_r, area_guess_opts);
        
        
    end
    
    
    %% Plot the areas
    
    plot_road_guess(left_area_export, cent_area_export, right_area_export, Manual_Classfied_Areas, Avg_Arrays, options)


    %% Animate
    
    if area_guess_opts.animate
        
        animate_road_guess(left_area_export, cent_area_export, right_area_export, options)
        
    end
    
    
    %% Diag test
    
%     auto_road_test_plot(left_area_export, cent_area_export, right_area_export, options)

    
end