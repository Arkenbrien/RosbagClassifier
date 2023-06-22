function plot_avg_class_results_fun(Avg_Arrays, Manual_Classfied_Areas, path_coord, options)
    
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
    
    c2_grav_sym = 'co';
    c2_asph_sym = 'ks';
    c2_unkn_sym = 'rx';
    
    c3_grav_sym = 'co';
    c3_asph_sym = 'ks';
    c3_unkn_sym = 'rx';
    
    c4_grav_sym = 'co';
    c4_asph_sym = 'ks';
    c4_unkn_sym = 'rx';
    
    h1_sym      = 'co';
    h2_sym      = 'ks';
    h3_sym      = 'rx';
    h4_sym      = '--';
    h4_col      = [0.00, 0.53, 1.00];
    
    x_y_z_path_sym = 'b--';
    x_y_z_path_linewidth = 20;
    x_y_z_path_color = [0.00, 0.53, 1.00];

    x_y_z_path = [];


    %% Getting the path 
    
    for idx = 1:length(path_coord)
        
        x_y_z_path = [x_y_z_path; path_coord{idx}];
        
    end
    
    x_y_z_path = x_y_z_path * rotz(-90);
    
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
        plot3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), c2_grav_sym, 'MarkerSize', options.gravmarkersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Grav Data on Chan 2!')
    end

    try   
        plot3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), c2_asph_sym, 'MarkerSize', options.asphmarkersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Asph Data on Chan 2!')
    end

    try
        plot3(Unkn_Avg_Append_Array_2(:,1), Unkn_Avg_Append_Array_2(:,2), Unkn_Avg_Append_Array_2(:,3), c2_unkn_sym, 'MarkerSize', options.unknmarkersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Unkn Data on Chan 2!')
    end


    % Channel 3
    try
        plot3(Grav_Avg_Append_Array_3(:,1), Grav_Avg_Append_Array_3(:,2), Grav_Avg_Append_Array_3(:,3), c3_grav_sym, 'MarkerSize', options.gravmarkersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Grav Data on Chan 3!')
    end

    try   
        plot3(Asph_Avg_Append_Array_3(:,1), Asph_Avg_Append_Array_3(:,2), Asph_Avg_Append_Array_3(:,3), c3_asph_sym, 'MarkerSize', options.asphmarkersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Asph Data on Chan 3!')
    end

    try
        plot3(Unkn_Avg_Append_Array_3(:,1), Unkn_Avg_Append_Array_3(:,2), Unkn_Avg_Append_Array_3(:,3), c3_unkn_sym, 'MarkerSize', options.unknmarkersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Unkn Data on Chan 3!')
    end

    % Channel 4
    try
        plot3(Grav_Avg_Append_Array_4(:,1), Grav_Avg_Append_Array_4(:,2), Grav_Avg_Append_Array_4(:,3), c4_grav_sym, 'MarkerSize', options.gravmarkersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Grav Data on Chan 4!')
    end

    try   
        plot3(Asph_Avg_Append_Array_4(:,1), Asph_Avg_Append_Array_4(:,2), Asph_Avg_Append_Array_4(:,3), c4_asph_sym, 'MarkerSize', options.asphmarkersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Asph Data on Chan 4!')
    end

    try
        plot3(Unkn_Avg_Append_Array_4(:,1), Unkn_Avg_Append_Array_4(:,2), Unkn_Avg_Append_Array_4(:,3), c4_unkn_sym, 'MarkerSize', options.unknmarkersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Unkn Data on Chan 4!')
    end

%      MCA_plotter(Manual_Classfied_Areas, options.max_h)

    plot3(x_y_z_path(:,1), x_y_z_path(:,2), x_y_z_path(:,3)+10, x_y_z_path_sym, 'Color', x_y_z_path_color, 'LineWidth', x_y_z_path_linewidth);

    axis('equal')
    axis off
    view([0 0 90])

    % MCA_plotter(Manual_Classfied_Areas, options.max_h)

    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);
    zlim([z_min_lim z_max_lim]);

    h(1) = plot(NaN,NaN,h1_sym, 'LineWidth', 25);
    h(2) = plot(NaN,NaN,h2_sym, 'LineWidth', 25);
    h(3) = plot(NaN,NaN,h3_sym, 'LineWidth', 40);
    h(4) = plot(NaN,NaN,h4_sym, 'Color', h4_col, 'LineWidth', 8);
    l       = legend(h, {'\color{cyan} Gravel',...
                         '\color{black} Asphalt',...
                         '\color{red} Unkn',...
                         '\color[rgb]{0.00, 0.53, 1.00} Path'},... 
                         'FontSize', 36,... 
                         'FontWeight',... 
                         'bold',... 
                         'LineWidth', 4);
    l.Interpreter = 'tex';

    ax = gca;
    ax.Clipping = 'off';
    
    
end

