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
    if ~options.plot_ani
        result_avg_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    end
    
    hold all
    
     % Channel 2
    try
        plot3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'Linewidth', options.gravlinewidth, 'MarkerFaceColor', options.grav_col, 'MarkerEdgeColor', options.grav_col)
    catch
        disp('No Grav Data on Chan 2!')
    end

    try   
        plot3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'Linewidth', options.asphlinewidth, 'MarkerFaceColor', options.asph_col, 'MarkerEdgeColor', options.asph_col)
    catch
        disp('No Asph Data on Chan 2!')
    end

    try
        plot3(Unkn_Avg_Append_Array_2(:,1), Unkn_Avg_Append_Array_2(:,2), Unkn_Avg_Append_Array_2(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'Linewidth', options.unknlinewidth, 'MarkerFaceColor', options.unkn_col, 'MarkerEdgeColor', options.unkn_col)
    catch
        disp('No Unkn Data on Chan 2!')
    end


    % Channel 3
    try
        plot3(Grav_Avg_Append_Array_3(:,1), Grav_Avg_Append_Array_3(:,2), Grav_Avg_Append_Array_3(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'Linewidth', options.gravlinewidth, 'MarkerFaceColor', options.grav_col, 'MarkerEdgeColor', options.grav_col)
    catch
        disp('No Grav Data on Chan 3!')
    end

    try   
        plot3(Asph_Avg_Append_Array_3(:,1), Asph_Avg_Append_Array_3(:,2), Asph_Avg_Append_Array_3(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'Linewidth', options.asphlinewidth, 'MarkerFaceColor', options.asph_col, 'MarkerEdgeColor', options.asph_col)
    catch
        disp('No Asph Data on Chan 3!')
    end

    try
        plot3(Unkn_Avg_Append_Array_3(:,1), Unkn_Avg_Append_Array_3(:,2), Unkn_Avg_Append_Array_3(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'Linewidth', options.unknlinewidth, 'MarkerFaceColor', options.unkn_col, 'MarkerEdgeColor', options.unkn_col)
    catch
        disp('No Unkn Data on Chan 3!')
    end

    % Channel 4
    try
        plot3(Grav_Avg_Append_Array_4(:,1), Grav_Avg_Append_Array_4(:,2), Grav_Avg_Append_Array_4(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'Linewidth', options.gravlinewidth, 'MarkerFaceColor', options.grav_col, 'MarkerEdgeColor', options.grav_col)
    catch
        disp('No Grav Data on Chan 4!')
    end

    try   
        plot3(Asph_Avg_Append_Array_4(:,1), Asph_Avg_Append_Array_4(:,2), Asph_Avg_Append_Array_4(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'Linewidth', options.asphlinewidth, 'MarkerFaceColor', options.asph_col, 'MarkerEdgeColor', options.asph_col)
    catch
        disp('No Asph Data on Chan 4!')
    end

    try
        plot3(Unkn_Avg_Append_Array_4(:,1), Unkn_Avg_Append_Array_4(:,2), Unkn_Avg_Append_Array_4(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'Linewidth', options.unknlinewidth, 'MarkerFaceColor', options.unkn_col, 'MarkerEdgeColor', options.unkn_col)
    catch
        disp('No Unkn Data on Chan 4!')
    end

    if options.mca_plot
    
        MCA_plotter(Manual_Classfied_Areas, options.max_h, options)
        
    end

    plot3(x_y_z_path(:,1), x_y_z_path(:,2), x_y_z_path(:,3)+10, options.x_y_z_path_sym, 'Color', options.x_y_z_path_color, 'LineWidth', options.x_y_z_path_linewidth);

    axis('equal')
    axis off
    view([0 0 90])

    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);
    zlim([z_min_lim z_max_lim]);

    if options.mca_plot
            
        h(1) = plot(NaN,NaN,'s', 'Color', 'k', 'MarkerFaceColor', [1.00, 0.00, 0.00], 'MarkerSize', 30, 'LineWidth', 1);
        h(2) = plot(NaN,NaN,'s', 'Color', 'k', 'MarkerFaceColor', [0.50, 0.50, 0.00], 'MarkerSize', 30, 'LineWidth', 1);
        h(3) = plot(NaN,NaN,'s', 'Color', 'k', 'MarkerFaceColor', [0.75 ,0.25, 0.75], 'MarkerSize', 30, 'LineWidth', 1);

        h(4) = plot(NaN,NaN,options.h_grav_sym, 'LineWidth', options.h_grav_size);
        h(5) = plot(NaN,NaN,options.h_asph_sym, 'LineWidth', options.h_asph_size);
        h(6) = plot(NaN,NaN,options.h_unkn_sym, 'LineWidth', options.h_unkn_size);
        h(7) = plot(NaN,NaN,options.h_path_sym, 'Color', options.h_path_col, 'LineWidth', options.h_path_linewidth);

        l = legend(h,  {'\color[rgb]{1.00, 0.00, 0.00} Grav Area',...
                        '\color[rgb]{0.50, 0.50, 0.00} Asph Area',...
                        '\color[rgb]{0.75, 0.25, 0.75} Unkn Area',...
                        '\color{cyan} Grav',...
                        '\color{black} Asph',...
                        '\color{red} Unkn',...
                        '\color[rgb]{0.00, 0.53, 1.00} Path'},...
                        'FontSize', 56,... 
                        'FontWeight', 'bold',...
                        'LineWidth', 4);
        l.Interpreter = 'tex';
        
        
    else

        h(1) = plot(NaN,NaN,options.h_grav_sym, 'LineWidth', options.h_grav_size);
        h(2) = plot(NaN,NaN,options.h_asph_sym, 'LineWidth', options.h_asph_size);
        h(3) = plot(NaN,NaN,options.h_unkn_sym, 'LineWidth', options.h_unkn_size);
        h(4) = plot(NaN,NaN,options.h_path_sym, 'Color', options.h_path_col, 'LineWidth', options.h_path_linewidth);
        l       = legend(h, {'\color{cyan} Gravel',...
                             '\color{black} Asphalt',...
                             '\color{red} Unkn',...
                             '\color[rgb]{0.00, 0.53, 1.00} Path'},... 
                             'FontSize', options.legend_font_size,... 
                             'FontWeight',... 
                             'bold',... 
                             'LineWidth', 4);
        l.Interpreter = 'tex';

    end
    
    
    ax = gca;
    ax.Clipping = 'off';
    
    
end

