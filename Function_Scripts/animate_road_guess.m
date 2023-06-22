function animate_road_guess(left_area_export, cent_area_export, right_area_export, options)

    %% VAR INIT
    
    dt = 0.05;
    text_x_buffer = 20;
    text_y_buffer = 2;
    save_anim_bool = 1;
    font_size = 24;
    
    
    %% Figure Setup
    
    road_guess_anim_fig = figure('Position', [10 10 3500/2 1600], 'DefaultAxesFontSize', options.axis_font_size);
    axis('equal')
    axis off
    view([45 0 45])
    x_min = mean(cent_area_export{1}.area(:,1)) - 5;
    x_max = mean(cent_area_export{1}.area(:,1)) + 15;
    y_min = mean(cent_area_export{1}.area(:,2)) - 20;
    y_max = mean(cent_area_export{1}.area(:,2)) + 20;
    hold all
    
    text_origin_x = linspace((x_min + text_x_buffer), (x_max - text_x_buffer), 3);
    text_origin_y = y_max - text_y_buffer;
    
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

    if options.save_anim_bool
        
        animation_filename = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/ANIMATIONS/" +... 
                            string(options.rosbag_number) +...
                            string(options.reference_point) + "_" +...                            
                            floor(posixtime(datetime('now'))) +... 
                            ".avi";
        
        video = VideoWriter(animation_filename, 'Motion JPEG AVI');
        video.FrameRate = 10;
        open(video)
        
    end
    


    
    %% Initial Plot
    
    l_g_points = scatter3(left_area_export{1}.grav_points(:,1), left_area_export{1}.grav_points(:,2), left_area_export{1}.grav_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'c', 'MarkerEdgeColor', 'c');
    l_a_points = scatter3(left_area_export{1}.asph_points(:,1), left_area_export{1}.asph_points(:,2), left_area_export{1}.asph_points(:,3), 69, 'Marker', 's', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
    l_u_points = scatter3(left_area_export{1}.unkn_points(:,1), left_area_export{1}.unkn_points(:,2), left_area_export{1}.unkn_points(:,3), 100, 'Marker', 'x', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineWidth', 2);
    l_patches = patch(left_area_export{1}.area(:,1), left_area_export{1}.area(:,2), left_area_export{1}.area(:,3), 'b', 'FaceAlpha', 0, 'EdgeColor', to_color_l);
    
    c_g_points = scatter3(cent_area_export{1}.grav_points(:,1), cent_area_export{1}.grav_points(:,2), cent_area_export{1}.grav_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'c', 'MarkerEdgeColor', 'c');
    c_a_points = scatter3(cent_area_export{1}.asph_points(:,1), cent_area_export{1}.asph_points(:,2), cent_area_export{1}.asph_points(:,3), 69, 'Marker', 's', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
    c_u_points = scatter3(cent_area_export{1}.unkn_points(:,1), cent_area_export{1}.unkn_points(:,2), cent_area_export{1}.unkn_points(:,3), 100, 'Marker', 'x', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineWidth', 2);
    c_patches = patch(cent_area_export{1}.area(:,1), cent_area_export{1}.area(:,2), cent_area_export{1}.area(:,3), 'b', 'FaceAlpha', 0, 'EdgeColor', to_color_c);
    
    r_g_points = scatter3(right_area_export{1}.grav_points(:,1), right_area_export{1}.grav_points(:,2), right_area_export{1}.grav_points(:,3), 69, 'Marker', 'o', 'MarkerFaceColor', 'c', 'MarkerEdgeColor', 'c');
    r_a_points = scatter3(right_area_export{1}.asph_points(:,1), right_area_export{1}.asph_points(:,2), right_area_export{1}.asph_points(:,3), 69, 'Marker', 's', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
    r_u_points = scatter3(right_area_export{1}.unkn_points(:,1), right_area_export{1}.unkn_points(:,2), right_area_export{1}.unkn_points(:,3), 100, 'Marker', 'x', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineWidth', 2);
    r_patches = patch(right_area_export{1}.area(:,1), right_area_export{1}.area(:,2), right_area_export{1}.area(:,3), 'b', 'FaceAlpha', 0, 'EdgeColor', to_color_r);

%     l_line_2 = plot([left_area_export{1}.origin(1), left_area_export{1}.c2_loc(1)], [left_area_export{1}.origin(2), left_area_export{1}.c2_loc(2)]);

    text_l = text(text_origin_x(1), text_origin_y, '', 'FontSize', font_size);
    text_c = text(text_origin_x(2), text_origin_y, '', 'FontSize', font_size);
    text_r = text(text_origin_x(3), text_origin_y, '', 'FontSize', font_size);
    
    text_l.String = sprintf('LEFT\nG: %.2f\nA: %.2f\nU: %.2f',... 
                            left_area_export{1}.tot_percent(1),... 
                            left_area_export{1}.tot_percent(2),... 
                            left_area_export{1}.tot_percent(3));
    text_c.String = sprintf('CENT\nG: %.2f\nA: %.2f\nU: %.2f',... 
                            cent_area_export{1}.tot_percent(1),... 
                            cent_area_export{1}.tot_percent(2),... 
                            cent_area_export{1}.tot_percent(3));
    text_r.String = sprintf('RIGHT\nG: %.2f\nA: %.2f\nU: %.2f',... 
                            right_area_export{1}.tot_percent(1),... 
                            right_area_export{1}.tot_percent(2),... 
                            right_area_export{1}.tot_percent(3));
    
    time = linspace(0,1,length(cent_area_export));
    
    
    %% Animation
    
    for t = 2:1:length(time)
        
        if isequal(left_area_export{t}.clas, 'gravel')
            to_color_l = 'c';
            to_fa_l = 0.5;
        elseif isequal(left_area_export{t}.clas, 'asphalt')
            to_color_l = 'k';
            to_fa_l = 0.5;
        elseif isequal(left_area_export{t}.clas, 'unknown')
            to_color_l = 'r';
            to_fa_l = 0.5;
        end

        if isequal(cent_area_export{t}.clas, 'gravel')
            to_color_c = 'c';
            to_fa_c = 0.5;
        elseif isequal(cent_area_export{t}.clas, 'asphalt')
            to_color_c = 'k';
            to_fa_c = 0.5;
        elseif isequal(cent_area_export{t}.clas, 'unknown')
            to_color_c = 'r';
            to_fa_c = 0.5;
        end

        if isequal(right_area_export{t}.clas, 'gravel')
            to_color_r = 'c';
            to_fa_r = 0.5;
        elseif isequal(right_area_export{t}.clas, 'asphalt')
            to_color_r = 'k';
            to_fa_r = 0.5;
        elseif isequal(right_area_export{t}.clas, 'unknown')
            to_color_r = 'r';
            to_fa_r = 0.5;
        end
                
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
        
%         set(l_line_2, 'XDATA', [left_area_export{t}.origin(1), left_area_export{t}.c2_loc(1)], 'YDATA', [left_area_export{t}.origin(2), left_area_export{t}.c2_loc(2)])

        axis('equal')
        axis off
        view([0 0 90])
        x_min = mean(cent_area_export{t}.area(:,1)) - 30;
        x_max = mean(cent_area_export{t}.area(:,1)) + 30;
        y_min = mean(cent_area_export{t}.area(:,2)) - 30;
        y_max = mean(cent_area_export{t}.area(:,2)) + 30;
        text_origin_x = linspace((x_min + text_x_buffer), (x_max - text_x_buffer), 3);
        text_origin_y = y_max - text_y_buffer;

        text_l.String = sprintf('LEFT\nG: %.2f\nA: %.2f\nU: %.2f',... 
                                left_area_export{t}.tot_percent(1),... 
                                left_area_export{t}.tot_percent(2),... 
                                left_area_export{t}.tot_percent(3));
        text_c.String = sprintf('CENT\nG: %.2f\nA: %.2f\nU: %.2f',... 
                                cent_area_export{t}.tot_percent(1),... 
                                cent_area_export{t}.tot_percent(2),... 
                                cent_area_export{t}.tot_percent(3));
        text_r.String = sprintf('RIGHT\nG: %.2f\nA: %.2f\nU: %.2f',... 
                                right_area_export{t}.tot_percent(1),... 
                                right_area_export{t}.tot_percent(2),... 
                                right_area_export{t}.tot_percent(3));
                        
        text_l.Position = [text_origin_x(1), text_origin_y];
        text_c.Position = [text_origin_x(2), text_origin_y];
        text_r.Position = [text_origin_x(3), text_origin_y];
        
        xlim([x_min x_max])
        ylim([y_min y_max])
%         xlim([10 3500])
%         ylim([10 1600])
        % Update the plot
        drawnow;
        pause(dt)
        
        if options.save_anim_bool
            writeVideo(video, getframe(road_guess_anim_fig));
        end
        
    end
    
    if options.save_anim_bool
        close(video);
    end
    
    disp('Animation Saved')
    
end

