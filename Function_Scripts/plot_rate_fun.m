function plot_rate_fun(pcd_class_rate_rate, options)

    time_extract        = cell2mat(pcd_class_rate_rate);

    max_time            = max(time_extract); %s
    min_time            = min(time_extract); %s

    max_Hz              = 1 / min(time_extract); %Hz
    min_Hz              = 1 / max(time_extract); %Hz

    pcd_class_rate_Hz    =  time_extract.^(-1);

    Move_mean_time      = movmean(time_extract, options.move_avg_size);
    Move_mean_Hz        = movmean(pcd_class_rate_Hz, options.move_avg_size);

    rate_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10  1400 500]);

    hold on

    plot(time_extract, 'b')
    plot(Move_mean_time, 'r', 'LineWidth', 3)

    l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';

    hold off
    % axis('equal')

    xlabel('360 Scan')
    ylabel('Time (s)')

    %     ylim([min_time max_time])

    hold off

    % Classification Rate Hz

    hz_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500]);

    hold all

    plot(pcd_class_rate_Hz, 'b')
    plot(Move_mean_Hz, 'r', 'LineWidth', 3)

    % axis('equal')

    xlabel('360 Scan')
    ylabel('Hz')

     l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4, 'Location', 'southeast');
        l.Interpreter = 'tex';

    hold off
    
end