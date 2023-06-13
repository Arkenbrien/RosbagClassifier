function animate_road_guess(left_area_export, cent_area_export, right_area_export, options)
    close all
    road_guess_anim_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    axis('equal')
    axis off
    view([0 0 90])
    x_min = mean(cent_area_export{1}.area(:,1)) - 5;
    x_max = mean(cent_area_export{1}.area(:,1)) + 15;
    y_min = mean(cent_area_export{1}.area(:,2)) - 20;
    y_max = mean(cent_area_export{1}.area(:,2)) + 20;
    hold all
    
    if isequal(left_area_export{1}.clas, 'gravel')
        to_color_l = 'c';
    elseif isequal(left_area_export{1}.clas, 'asphalt')
        to_color_l = 'k';
    elseif isequal(left_area_export{1}.clas, 'unknown')
        to_color_l = 'r';
    end
    
    if isequal(cent_area_export{1}.clas, 'gravel')
        to_color_c = 'c';
    elseif isequal(cent_area_export{1}.clas, 'asphalt')
        to_color_c = 'k';
    elseif isequal(cent_area_export{1}.clas, 'unknown')
        to_color_c = 'r';
    end
    
    if isequal(right_area_export{1}.clas, 'gravel')
        to_color_r = 'c';
    elseif isequal(right_area_export{1}.clas, 'asphalt')
        to_color_r = 'k';
    elseif isequal(right_area_export{1}.clas, 'unknown')
        to_color_r = 'r';
    end
    
    xlim([x_min x_max])
    ylim([y_min y_max])
    animation_filename = "animation_" + floor(posixtime(datetime('now'))) + ".avi";
    video = VideoWriter(animation_filename, 'Uncompressed AVI');
    video.FrameRate = 10;
    open(video)
    dt = 0.05;
    
    l_g_points = scatter3(left_area_export{1}.grav_points(:,1), left_area_export{1}.grav_points(:,2), left_area_export{1}.grav_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'c');
    l_a_points = scatter3(left_area_export{1}.asph_points(:,1), left_area_export{1}.asph_points(:,2), left_area_export{1}.asph_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'k');
    l_u_points = scatter3(left_area_export{1}.unkn_points(:,1), left_area_export{1}.unkn_points(:,2), left_area_export{1}.unkn_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'r');
    l_patches = patch(left_area_export{1}.area(:,1), left_area_export{1}.area(:,2), left_area_export{1}.area(:,3), 'b', 'FaceAlpha', 0, 'EdgeColor', to_color_l);
    
    c_g_points = scatter3(cent_area_export{1}.grav_points(:,1), cent_area_export{1}.grav_points(:,2), cent_area_export{1}.grav_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'c');
    c_a_points = scatter3(cent_area_export{1}.asph_points(:,1), cent_area_export{1}.asph_points(:,2), cent_area_export{1}.asph_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'k');
    c_u_points = scatter3(cent_area_export{1}.unkn_points(:,1), cent_area_export{1}.unkn_points(:,2), cent_area_export{1}.unkn_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'r');
    c_patches = patch(cent_area_export{1}.area(:,1), cent_area_export{1}.area(:,2), cent_area_export{1}.area(:,3), 'b', 'FaceAlpha', 0, 'EdgeColor', to_color_c);
    
    r_g_points = scatter3(right_area_export{1}.grav_points(:,1), right_area_export{1}.grav_points(:,2), right_area_export{1}.grav_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'c');
    r_a_points = scatter3(right_area_export{1}.asph_points(:,1), right_area_export{1}.asph_points(:,2), right_area_export{1}.asph_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'k');
    r_u_points = scatter3(right_area_export{1}.unkn_points(:,1), right_area_export{1}.unkn_points(:,2), right_area_export{1}.unkn_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'r');
    r_patches = patch(right_area_export{1}.area(:,1), right_area_export{1}.area(:,2), right_area_export{1}.area(:,3), 'b', 'FaceAlpha', 0, 'EdgeColor', to_color_r);
    
    time = linspace(0,1,length(cent_area_export));
    
    for t = 2:1:length(time)
        
        if isequal(left_area_export{t}.clas, 'gravel')
            to_color_l = 'c';
            to_fa_l = 0.5;
        elseif isequal(left_area_export{t}.clas, 'asphalt')
            to_color_l = 'k';
            to_fa_l = 0.5;
        elseif isequal(left_area_export{t}.clas, 'unknown')
            to_color_l = 'r';
            to_fa_l = 0;
        end

        if isequal(cent_area_export{t}.clas, 'gravel')
            to_color_c = 'c';
            to_fa_c = 0.5;
        elseif isequal(cent_area_export{t}.clas, 'asphalt')
            to_color_c = 'k';
            to_fa_c = 0.5;
        elseif isequal(cent_area_export{t}.clas, 'unknown')
            to_color_c = 'r';
            to_fa_c = 0;
        end

        if isequal(right_area_export{t}.clas, 'gravel')
            to_color_r = 'c';
            to_fa_r = 0.5;
        elseif isequal(right_area_export{t}.clas, 'asphalt')
            to_color_r = 'k';
            to_fa_r = 0.5;
        elseif isequal(right_area_export{t}.clas, 'unknown')
            to_color_r = 'r';
            to_fa_r = 0;
        end
        
%         fprintf("\nL: %s  C: %s  R: %s\n", to_color_l, to_color_c, to_color_c)
        
        set(r_g_points, 'XData', right_area_export{t}.grav_points(:,1), 'YData',  right_area_export{t}.grav_points(:,2), 'ZData', right_area_export{t}.grav_points(:,3));
        set(r_a_points, 'XData', right_area_export{t}.asph_points(:,1), 'YData',  right_area_export{t}.asph_points(:,2), 'ZData', right_area_export{t}.asph_points(:,3));
        set(r_u_points, 'XData', right_area_export{t}.unkn_points(:,1), 'YData',  right_area_export{t}.unkn_points(:,2), 'ZData', right_area_export{t}.unkn_points(:,3));
        set(r_patches, 'XData', right_area_export{t}.area(:,1), 'YData', right_area_export{t}.area(:,2), 'ZData', right_area_export{t}.area(:,3), 'FaceAlpha', to_fa_l, 'EdgeColor', string(to_color_r), 'FaceColor', string(to_color_r));
        
        set(c_g_points, 'XData', cent_area_export{t}.grav_points(:,1), 'YData',  cent_area_export{t}.grav_points(:,2), 'ZData', cent_area_export{t}.grav_points(:,3));
        set(c_a_points, 'XData', cent_area_export{t}.asph_points(:,1), 'YData',  cent_area_export{t}.asph_points(:,2), 'ZData', cent_area_export{t}.asph_points(:,3));
        set(c_u_points, 'XData', cent_area_export{t}.unkn_points(:,1), 'YData',  cent_area_export{t}.unkn_points(:,2), 'ZData', cent_area_export{t}.unkn_points(:,3));
        set(c_patches, 'XData', cent_area_export{t}.area(:,1), 'YData', cent_area_export{t}.area(:,2), 'ZData', cent_area_export{t}.area(:,3), 'FaceAlpha', to_fa_c, 'EdgeColor', string(to_color_c), 'FaceColor', string(to_color_c));
        
        set(l_g_points, 'XData', left_area_export{t}.grav_points(:,1), 'YData',  left_area_export{t}.grav_points(:,2), 'ZData', left_area_export{t}.grav_points(:,3));
        set(l_a_points, 'XData', left_area_export{t}.asph_points(:,1), 'YData',  left_area_export{t}.asph_points(:,2), 'ZData', left_area_export{t}.asph_points(:,3));
        set(l_u_points, 'XData', left_area_export{t}.unkn_points(:,1), 'YData',  left_area_export{t}.unkn_points(:,2), 'ZData', left_area_export{t}.unkn_points(:,3));
        set(l_patches, 'XData', left_area_export{t}.area(:,1), 'YData', left_area_export{t}.area(:,2), 'ZData', left_area_export{t}.area(:,3), 'FaceAlpha', to_fa_r, 'EdgeColor', string(to_color_l), 'FaceColor', string(to_color_l));
        
        axis('equal')
        axis off
        view([0 0 90])
        x_min = mean(cent_area_export{t}.area(:,1)) - 30;
        x_max = mean(cent_area_export{t}.area(:,1)) + 30;
        y_min = mean(cent_area_export{t}.area(:,2)) - 30;
        y_max = mean(cent_area_export{t}.area(:,2)) + 30;
        xlim([x_min x_max])
        ylim([y_min y_max])
        % Update the plot
        drawnow;
        pause(dt)
        
        writeVideo(video, getframe(road_guess_anim_fig));
        
    end
    
    close(video);
    
end

