function plot_rate_fun(pcd_class_rate_rate, plane_proj_toc, options)

    time_extract        = cell2mat(pcd_class_rate_rate);
    plane_proj_te       = cell2mat(plane_proj_toc);

    pcd_class_rate_Hz   =  time_extract.^(-1);
    plane_proj_rate_Hz  = plane_proj_te.^(-1);

    Move_mean_time      = movmean(time_extract, options.move_avg_size);
    Move_mean_Hz        = movmean(pcd_class_rate_Hz, options.move_avg_size);
    
    Move_mean_time_ppte = movmean(plane_proj_te, options.move_avg_size);
    Move_mean_Hz_ppte   = movmean(plane_proj_rate_Hz, options.move_avg_size);

    %% What
    
    rate_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500]);

    hold on

    plot(time_extract, 'b')
    plot(Move_mean_time, 'r', 'LineWidth', 3)

    l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';

    hold off
    % axis('equal')

    xlabel('360 Scan')
    ylabel('Time (s)')

    hold off

    
    %% Classification Rate Hz

    hz_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500]);

    hold all

    plot(pcd_class_rate_Hz, 'b')
    plot(Move_mean_Hz, 'r', 'LineWidth', 3)

    xlabel('360 Scan')
    ylabel('Hz')

    l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4, 'Location', 'southeast');
    l.Interpreter = 'tex';

    hold off
    
    
    %% Plane Project Time
    
    plane_proj_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500]);
    
    hold all
    
    plot(plane_proj_rate_Hz, 'b')
    plot(Move_mean_Hz_ppte, 'r', 'LineWidth', 3)
    
    xlabel('360 Scan')
    ylabel('Hz')

    l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4, 'Location', 'southeast');
    l.Interpreter = 'tex';
    
    hold off
    
    
end