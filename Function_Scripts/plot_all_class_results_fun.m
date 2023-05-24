function plot_all_class_results_fun(All_Arrays, options)
    
    %% VAR INIT

    Grav_All_Append_Array_2 = All_Arrays.grav2;
    Asph_All_Append_Array_2 = All_Arrays.asph2;
    Unkn_All_Append_Array_2 = All_Arrays.unkn2;

    Grav_All_Append_Array_3 = All_Arrays.grav3;
    Asph_All_Append_Array_3 = All_Arrays.asph3;
    Unkn_All_Append_Array_3 = All_Arrays.unkn3;

    Grav_All_Append_Array_4 = All_Arrays.grav4;
    Asph_All_Append_Array_4 = All_Arrays.asph4;
    Unkn_All_Append_Array_4 = All_Arrays.unkn4;
    
    %% Getting Limits
    
    try
    
        x_min_lim = min([Grav_All_Append_Array_2(:,1); Asph_All_Append_Array_2(:,1); Unkn_All_Append_Array_2(:,1)]) - 5;
        x_max_lim = max([Grav_All_Append_Array_2(:,1); Asph_All_Append_Array_2(:,1); Unkn_All_Append_Array_2(:,1)]) + 5;

        y_min_lim = min([Grav_All_Append_Array_2(:,2); Asph_All_Append_Array_2(:,2); Unkn_All_Append_Array_2(:,2)]) - 5;
        y_max_lim = max([Grav_All_Append_Array_2(:,2); Asph_All_Append_Array_2(:,2); Unkn_All_Append_Array_2(:,2)]) + 5;

        z_min_lim = min([Grav_All_Append_Array_2(:,3); Asph_All_Append_Array_2(:,3); Unkn_All_Append_Array_2(:,3)]) - 5;
        z_max_lim = max([Grav_All_Append_Array_2(:,3); Asph_All_Append_Array_2(:,3); Unkn_All_Append_Array_2(:,3)]) + 5;
    
    catch

        x_min_lim = -100;
        x_max_lim = 100;
        y_min_lim = -100;
        y_max_lim = 100;
        z_min_lim = -20;
        z_max_lim = 20;
        
    end

    options.max_h = z_max_lim;
    
    %% Plotting
    
    % All points
    result_all_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);

    hold all

    % Channel 2
    try
        plot3(Grav_All_Append_Array_2(:,1), Grav_All_Append_Array_2(:,2), Grav_All_Append_Array_2(:,3), 'c.', 'MarkerSize', options.c2markersize)
    catch
        disp('No Grav Data on Chan 2!')
    end

    try
        plot3(Asph_All_Append_Array_2(:,1), Asph_All_Append_Array_2(:,2), Asph_All_Append_Array_2(:,3), 'k.', 'MarkerSize', options.c2markersize)
    catch
        disp('No Asph Dataon Chan 2!')
    end

    % try
    %     plot3(Gras_All_Append_Array_2(:,1), Gras_All_Append_Array_2(:,2), Gras_All_Append_Array_2(:,3), 'g.', 'MarkerSize', options.c2markersize)
    % catch
    %     disp('No Gras Dataon Chan 2!')
    % end

    try
        plot3(Unkn_All_Append_Array_2(:,1), Unkn_All_Append_Array_2(:,2), Unkn_All_Append_Array_2(:,3), 'r.', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 2!')
    end

    % Channel 3
    try
        plot3(Grav_All_Append_Array_3(:,1), Grav_All_Append_Array_3(:,2), Grav_All_Append_Array_3(:,3), 'c^', 'MarkerSize', 10)
    catch
        disp('No Grav Data on Chan 3!')
    end

    try
        plot3(Asph_All_Append_Array_3(:,1), Asph_All_Append_Array_3(:,2), Asph_All_Append_Array_3(:,3), 'k^', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 3!')
    end

    % try
    %     plot3(Gras_All_Append_Array_3(:,1), Gras_All_Append_Array_3(:,2), Gras_All_Append_Array_3(:,3), 'g^', 'MarkerSize', 10)
    % catch
    %     disp('No Gras Dataon Chan 3!')
    % end

    try
        plot3(Unkn_All_Append_Array_3(:,1), Unkn_All_Append_Array_3(:,2), Unkn_All_Append_Array_3(:,3), 'r^', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 3!')
    end

    % Channel 4
    try
        plot3(Grav_All_Append_Array_4(:,1), Grav_All_Append_Array_4(:,2), Grav_All_Append_Array_4(:,3), 'cv', 'MarkerSize', 10)
    catch
        disp('No Grav Data on Chan 4!')
    end

    try
        plot3(Asph_All_Append_Array_4(:,1), Asph_All_Append_Array_4(:,2), Asph_All_Append_Array_4(:,3), 'kv', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 4!')
    end

    % try
    %     plot3(Gras_All_Append_Array_4(:,1), Gras_All_Append_Array_4(:,2), Gras_All_Append_Array_4(:,3), 'gv', 'MarkerSize', 10)
    % catch
    %     disp('No Gras Dataon Chan 4!')
    % end

    try
        plot3(Unkn_All_Append_Array_4(:,1), Unkn_All_Append_Array_4(:,2), Unkn_All_Append_Array_4(:,3), 'rv', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 4!')
    end

    % Channel 5
    try
        plot3(Grav_All_Append_Array_5(:,1), Grav_All_Append_Array_5(:,2), Grav_All_Append_Array_5(:,3), 'cx', 'MarkerSize', 10)
    catch
        disp('No Grav Data on Chan 5!')
    end

    try
        plot3(Asph_All_Append_Array_5(:,1), Asph_All_Append_Array_5(:,2), Asph_All_Append_Array_5(:,3), 'kx', 'MarkerSize', 10)
    catch
        disp('No Asph Data on Chan 5!')
    end

    % try
    %     plot3(Gras_All_Append_Array_5(:,1), Gras_All_Append_Array_5(:,2), Gras_All_Append_Array_5(:,3), 'gx', 'MarkerSize', 10)
    % catch
    %     disp('No Gras Data on Chan 5!')
    % end

    try
        plot3(Unkn_All_Append_Array_5(:,1), Unkn_All_Append_Array_5(:,2), Unkn_All_Append_Array_5(:,3), 'rx', 'MarkerSize', 10)
    catch
        disp('No Asph Data on Chan 5!')
    end

    axis('equal')
    axis off
    view([pi/2 0 90])

    % MCA_plotter(Manual_Classfied_Areas, options.max_h)

    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);
    zlim([z_min_lim z_max_lim]);

    h(1) = plot(NaN,NaN,'oc');
    h(2) = plot(NaN,NaN,'ok');
    h(3) = plot(NaN,NaN,'or');
    l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{red} Unkn'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';

    ax = gca;
    ax.Clipping = 'off';
    
    
    
    
    
end



