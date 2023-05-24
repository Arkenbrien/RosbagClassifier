function plot_class_rate_fun(classify_fun_out_2c, classify_fun_out_3c, classify_fun_out_4c, classify_fun_out_2l, classify_fun_out_3l, classify_fun_out_4l, classify_fun_out_2r, classify_fun_out_3r, classify_fun_out_4r, options)
    
    %% VAR INIT
    
    time_avg_array = []; time_sum_array= [];
    
    alpha = 0.1;
    
    alpha_marker = '--';
    
    
    %% Get all the diags out
    
    time_2c = get_classify_fun_time(classify_fun_out_2c);
    time_3c = get_classify_fun_time(classify_fun_out_3c);
    time_4c = get_classify_fun_time(classify_fun_out_4c);
    
    time_2l = get_classify_fun_time(classify_fun_out_2l);
    time_3l = get_classify_fun_time(classify_fun_out_3l);
    time_4l = get_classify_fun_time(classify_fun_out_4l);
    
    time_2r = get_classify_fun_time(classify_fun_out_2r);
    time_3r = get_classify_fun_time(classify_fun_out_3r);
    time_4r = get_classify_fun_time(classify_fun_out_4r);
    
    % Append to Array
    time_array = [time_2c, time_3c, time_4c, time_2l, time_3l, time_4l, time_2r, time_3r, time_4r];
    
    % Get average/sum of array
    for time_row_idx = 1:height(time_array)
        
        time_avg_array = [time_avg_array; mean(time_array(time_row_idx,:))];
        time_sum_array = [time_sum_array; sum(time_array(time_row_idx,:))];
        
    end
    
    average_time_sum    = mean(time_sum_array);
    average_avg         = mean(time_avg_array);
    
    classify_time_avg_all_fig = figure('DefaultAxesFontSize', options.axis_font_size);
    plot(time_avg_array*1000, 'r');
    l = legend({sprintf('Per-Arc Classification Time (Average: %2.2f ms)', average_avg*1000)}, 'FontSize', options.legend_font_size, 'FontWeight', 'bold', 'LineWidth', options.legend_line_width);
    xlim([0 length(time_avg_array)]);
    xlabel('Instance');
    ylabel('Time (ms)');

    classify_time_sum_all_fig = figure('DefaultAxesFontSize', options.axis_font_size);
    plot(time_sum_array*1000, 'r');
    l = legend({sprintf('Per-Scan Classification Time (Average: %2.2f ms)', average_time_sum*1000)}, 'FontSize', options.legend_font_size, 'FontWeight', 'bold', 'LineWidth', options.legend_line_width);
    xlim([0 length(time_sum_array)]);
    xlabel('Instance');
    ylabel('Time (ms)');
    

end