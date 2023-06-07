function plot_avg_class_confs_results_fun(Avg_Arrays, Manual_Classfied_Areas, options)
    
    %% VAR INIT
    
    All_Avg_Array = [Avg_Arrays.grav2; Avg_Arrays.asph2; Avg_Arrays.unkn2; Avg_Arrays.grav3; Avg_Arrays.asph3; Avg_Arrays.unkn3; Avg_Arrays.grav4; Avg_Arrays.asph4; Avg_Arrays.unkn4];
    
    %% Getting Limits
    
    try
    
        x_min_lim = min(All_Avg_Array(:,1)) - 5;
        x_max_lim = max(All_Avg_Array(:,1)) + 5;

        y_min_lim = min(All_Avg_Array(:,2)) - 5;
        y_max_lim = max(All_Avg_Array(:,2)) + 5;

        z_min_lim = min(All_Avg_Array(:,3)) - 5;
        z_max_lim = max(All_Avg_Array(:,3)) + 5;
    
    catch

        x_min_lim = -100;
        x_max_lim = 100;
        y_min_lim = -100;
        y_max_lim = 100;
        z_min_lim = -20;
        z_max_lim = 20;
        
    end

    options.max_h = z_max_lim;
    
    %% Plotting Asphalt Confs
    
    asph_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,5)+0.01)*1000), 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 0.25, 'MarkerEdgeColor', 'k') 
    hold on
    MCA_plotter(Manual_Classfied_Areas, z_max_lim)
    axis('equal')
    axis off
    view([0 0 90])
    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);
    hold on
    h = plot(NaN,NaN,'ok', 'LineWidth', 25);
    hold off
    l = legend(h, {'\color{black} Asphalt'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    ax2 = gca;
    ax2.Clipping = 'off';
    
    
    %% Plotting Grass (UNKNOWN) Confs
    
    unkn_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,6)+0.01)*1000), 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.25, 'MarkerEdgeColor', 'r')
    hold on
    MCA_plotter(Manual_Classfied_Areas, z_max_lim)
    axis('equal')
    axis off
    view([0 0 90])
    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);
    hold on
    h = plot(NaN,NaN,'or', 'LineWidth', 25);
    l = legend(h, {'\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    hold off
    ax2 = gca;
    ax2.Clipping = 'off';
    
    
    %% Plotting Gravel Confs
    
    grav_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,7)+0.01)*1000), 'MarkerFaceColor', 'c', 'MarkerFaceAlpha', 0.25, 'MarkerEdgeColor', 'c')
    hold on

    MCA_plotter(Manual_Classfied_Areas, z_max_lim)
    axis('equal')
    axis off
    view([0 0 90])
    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);
    hold on
    h = plot(NaN,NaN,'oc', 'LineWidth', 25);
    l = legend(h, {'\color{cyan} Gravel'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    hold off
    ax2 = gca;
    ax2.Clipping = 'off';
    
    
    %% Plotting all Confs
    
    all_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    hold all
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,7)+0.01)*10000), 'MarkerFaceColor', 'c', 'MarkerFaceAlpha', 0.25, 'MarkerEdgeColor', 'c')
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,5)+0.01)*10000), 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 0.25, 'MarkerEdgeColor', 'k') 
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,6)+0.01)*10000), 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.25, 'MarkerEdgeColor', 'r')
    MCA_plotter(Manual_Classfied_Areas, z_max_lim)
    hold off
    axis('equal')
    axis off
    view([0 0 90])
    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);
    hold on
    h(1) = plot(NaN,NaN,'oc', 'LineWidth', 25);
    h(2) = plot(NaN,NaN,'ok', 'LineWidth', 25);
    h(3) = plot(NaN,NaN,'or', 'LineWidth', 25);
    l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    l.Interpreter = 'tex';
    hold off
    ax2 = gca;
    ax2.Clipping = 'off';

    
end