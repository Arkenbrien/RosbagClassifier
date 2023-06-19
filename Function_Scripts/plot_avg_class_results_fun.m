function plot_avg_class_results_fun(Avg_Arrays, Manual_Classfied_Areas, options)
    
    %% VAR INIT

    Grav_Avg_Append_Array_2 = Avg_Arrays.grav2;
    Asph_Avg_Append_Array_2 = Avg_Arrays.asph2;
    Unkn_Avg_Append_Array_2 = Avg_Arrays.unkn2;

    Grav_Avg_Append_Array_3 = Avg_Arrays.grav3;
    Asph_Avg_Append_Array_3 = Avg_Arrays.asph3;
    Unkn_Avg_Append_Array_3 = Avg_Arrays.unkn3;

    Grav_Avg_Append_Array_4 = Avg_Arrays.grav4;
    Asph_Avg_Append_Array_4 = Avg_Arrays.asph4;
    Unkn_Avg_Append_Array_4 = Avg_Arrays.unkn4;
        
    %% Getting Limits
    
    try
    
        x_min_lim = min([Grav_Avg_Append_Array_2(:,1); Asph_Avg_Append_Array_2(:,1); Unkn_Avg_Append_Array_2(:,1)]) - 5;
        x_max_lim = max([Grav_Avg_Append_Array_2(:,1); Asph_Avg_Append_Array_2(:,1); Unkn_Avg_Append_Array_2(:,1)]) + 5;

        y_min_lim = min([Grav_Avg_Append_Array_2(:,2); Asph_Avg_Append_Array_2(:,2); Unkn_Avg_Append_Array_2(:,2)]) - 5;
        y_max_lim = max([Grav_Avg_Append_Array_2(:,2); Asph_Avg_Append_Array_2(:,2); Unkn_Avg_Append_Array_2(:,2)]) + 5;

        z_min_lim = min([Grav_Avg_Append_Array_2(:,3); Asph_Avg_Append_Array_2(:,3); Unkn_Avg_Append_Array_2(:,3)]) - 5;
        z_max_lim = max([Grav_Avg_Append_Array_2(:,3); Asph_Avg_Append_Array_2(:,3); Unkn_Avg_Append_Array_2(:,3)]) + 5;
    
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
    if options.plot_avg_bool
        result_avg_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    end
    
    hold all
    
     % Channel 2
    try
        plot3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), 'co', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Grav Data on Chan 2!')
    end

    try   
        plot3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), 'ko', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Asph Data on Chan 2!')
    end

    try
        plot3(Unkn_Avg_Append_Array_2(:,1), Unkn_Avg_Append_Array_2(:,2), Unkn_Avg_Append_Array_2(:,3), 'ro', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Unkn Data on Chan 2!')
    end


    % Channel 3
    try
        plot3(Grav_Avg_Append_Array_3(:,1), Grav_Avg_Append_Array_3(:,2), Grav_Avg_Append_Array_3(:,3), 'co', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Grav Data on Chan 3!')
    end

    try   
        plot3(Asph_Avg_Append_Array_3(:,1), Asph_Avg_Append_Array_3(:,2), Asph_Avg_Append_Array_3(:,3), 'ko', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Asph Data on Chan 3!')
    end

    try
        plot3(Unkn_Avg_Append_Array_3(:,1), Unkn_Avg_Append_Array_3(:,2), Unkn_Avg_Append_Array_3(:,3), 'ro', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Unkn Data on Chan 3!')
    end

    % Channel 4
    try
        plot3(Grav_Avg_Append_Array_4(:,1), Grav_Avg_Append_Array_4(:,2), Grav_Avg_Append_Array_4(:,3), 'co', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Grav Data on Chan 4!')
    end

    try   
        plot3(Asph_Avg_Append_Array_4(:,1), Asph_Avg_Append_Array_4(:,2), Asph_Avg_Append_Array_4(:,3), 'ko', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Asph Data on Chan 4!')
    end

    try
        plot3(Unkn_Avg_Append_Array_4(:,1), Unkn_Avg_Append_Array_4(:,2), Unkn_Avg_Append_Array_4(:,3), 'ro', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Unkn Data on Chan 4!')
    end

     MCA_plotter(Manual_Classfied_Areas, options.max_h)

    axis('equal')
    axis off
    view([0 0 90])

    hold on
    
    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);

    h(1) = plot(NaN,NaN,'oc', 'LineWidth', 25);
    h(2) = plot(NaN,NaN,'ok', 'LineWidth', 25);
    h(3) = plot(NaN,NaN,'or', 'LineWidth', 25);
    l = legend(h, {'\color{cyan} Grav','\color{black} Asph','\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';

    ax2 = gca;
    ax2.Clipping = 'off';
    
    
end

