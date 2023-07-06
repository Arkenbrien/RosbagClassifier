function per_area_score_plot(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_sr_score, Manual_Classfied_Areas, options)

    disp('Entered per_area_score_plot.m')

    %% Var Init
    
    % Legend Stuff
    h2 = [];
    
    % How big is fig
    fig_size_array = [10 10 1000 1000];
    
    test_legend = {};
    
    
    %% Plotting the MCAs
    test_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize', 48);
    
    MCA_plotter(Manual_Classfied_Areas, options.max_h, options)
    
    axis('equal')
    axis off
%     view([-pi/2 0 90])
    view([0 0 90])

    hold all
    
    ax3 = gca;
    ax3.Clipping = 'off';
    
%     % Legend
%     h2(1) = plot(NaN,NaN,'s', 'Color', [0.75, 0.00, 0.00], 'MarkerSize', options.legend_marker_size, 'LineWidth', options.legend_line_width);
%     h2(2) = plot(NaN,NaN,'s', 'Color', [0.50, 0.50, 0.00], 'MarkerSize', options.legend_marker_size, 'LineWidth', options.legend_line_width);
%     h2(3) = plot(NaN,NaN,'s', 'Color', [0.75 ,0.25, 0.75], 'MarkerSize', options.legend_marker_size, 'LineWidth', options.legend_line_width);
%     h2(4) = plot(NaN,NaN,'s', 'Color', [0.25, 0.25, 0.25], 'MarkerSize', options.legend_marker_size, 'LineWidth', options.legend_line_width);
%     l = legend(h2, {'\color[rgb]{0.75, 0.00, 0.00} Gravel',...
%                     '\color[rgb]{0.50, 0.50, 0.00} Asphalt',...
%                     '\color[rgb]{0.75, 0.25, 0.75} Non Road',...
%                     '\color[rgb]{0.25, 0.25, 0.25} Side of Road'},...
%                     'FontSize', options.legend_font_size ,...
%                     'FontWeight', 'bold',... 
%                     'LineWidth', 4,...
%                     'FontName', options.font_type);
%     l.Interpreter = 'tex';
    
    xlim([-200 200]); ylim([-200 200])
    
    
    %% Gravel Area
    
%         % MCA plot area options
%     options.mca_grav_bool           = 1;
%     options.mca_asph_bool           = 0;
%     options.mca_unkn_bool           = 0;
%     options.mca_sor_bool            = 0;
%     options.mca_gras_bool           = 0;
%     options.mca_road_bool           = 0;
    
    hold all
    
    if options.mca_grav_bool

        for grav_area_idx = 1:length(tot_in_grav_score)

            % Grabbing values
            asph_pc     = tot_in_grav_score{grav_area_idx}.tot_asph_in_grav_score;
            unkn_pc     = tot_in_grav_score{grav_area_idx}.tot_unkn_in_grav_score;
            grav_pc     = tot_in_grav_score{grav_area_idx}.tot_grav_in_grav_score;
            loc         = tot_in_grav_score{grav_area_idx}.avg_loc;

            % Making the text to be printed
            txt = sprintf('Asph %0.2f\nGrav %0.2f\nUnkn %0.2f', asph_pc, grav_pc, unkn_pc);
%             txt = sprintf('Asph %0.2f\nGrav %0.2f', asph_pc, grav_pc);
            text(loc(1), loc(2), txt, 'Color', [0.75, 0.00, 0.00], 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 48, 'FontName', options.font_type);
            
            

        end
        
        h2(1) = plot(NaN,NaN,'s', 'Color', [0.75, 0.00, 0.00], 'MarkerSize', options.legend_marker_size, 'LineWidth', options.legend_line_width);
        test_legend = [test_legend; '\color[rgb]{0.75, 0.00, 0.00} Gravel'];
        
    else
        
        disp('No gravel areas to plot!')
        
    end
    
    %% Asphalt Area
    
    hold all
    
    if  options.mca_asph_bool
        
        for asph_area_idx = 1:length(tot_in_asph_score)

            asph_pc     = tot_in_asph_score{asph_area_idx}.tot_asph_in_asph_score;
            unkn_pc     = tot_in_asph_score{asph_area_idx}.tot_unkn_in_asph_score;
            grav_pc     = tot_in_asph_score{asph_area_idx}.tot_grav_in_asph_score;
            loc         = tot_in_asph_score{asph_area_idx}.avg_loc;

            % Making the text to be printed
            txt = sprintf('Asph %0.2f\nGrav %0.2f\nUnkn %0.2f', asph_pc, grav_pc, unkn_pc);
%             txt = sprintf('Asph %0.2f\nGrav %0.2f', asph_pc, grav_pc);
            text(loc(1), loc(2), txt, 'Color', [0.50,0.50,0.00], 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 48, 'FontName', options.font_type);

        end
        
        h2(2) = plot(NaN,NaN,'s', 'Color', [0.50, 0.50, 0.00], 'MarkerSize', options.legend_marker_size, 'LineWidth', options.legend_line_width);
        test_legend = [test_legend; '\color[rgb]{0.50, 0.50, 0.00} Asphalt'];
    
    else
            
        disp('No Asphalt Areas to plot!')
        
    end
            
    %% Side of Road
    
    hold all
    
    if options.mca_sor_bool

        for sr_area_idx = 1:length(tot_in_sr_score)

            asph_pc     = tot_in_sr_score{sr_area_idx}.tot_asph_in_sr_score;
            unkn_pc     = tot_in_sr_score{sr_area_idx}.tot_unkn_in_sr_score;
            grav_pc     = tot_in_sr_score{sr_area_idx}.tot_grav_in_sr_score;
            loc         = tot_in_sr_score{sr_area_idx}.avg_loc;

            % Making the text to be printed
            txt = sprintf('Asph %0.2f\nGrav %0.2f\nUnkn %0.2f', asph_pc, grav_pc, unkn_pc);
%             txt = sprintf('Asph %0.2f\nGrav %0.2f', asph_pc, grav_pc);
            text(loc(1), loc(2), txt, 'Color', [0.25, 0.25, 0.25], 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 48, 'FontName', options.font_type);


        end
        
        h2(4) = plot(NaN,NaN,'s', 'Color', [0.25, 0.25, 0.25], 'MarkerSize', options.legend_marker_size, 'LineWidth', options.legend_line_width);
        test_legend = [test_legend; '\color[rgb]{0.25, 0.25, 0.25} Side of Road'];
        
    else
        
        disp('No OR areas to plot!')
        
    end
    
    %% Non Road
    
    hold all
    
    if options.mca_unkn_bool

        for nr_area_idx = 1:length(tot_in_nr_score)

            asph_pc     = tot_in_nr_score{nr_area_idx}.tot_asph_in_nr_score;
            unkn_pc     = tot_in_nr_score{nr_area_idx}.tot_unkn_in_nr_score;
            grav_pc     = tot_in_nr_score{nr_area_idx}.tot_grav_in_nr_score;
            loc         = tot_in_nr_score{nr_area_idx}.avg_loc;

            % Making the text to be printed
            txt = sprintf('Asph %0.2f\nGrav %0.2f\nUnkn %0.2f', asph_pc, grav_pc, unkn_pc);
%             txt = sprintf('Asph %0.2f\nGrav %0.2f', asph_pc, grav_pc);
            text(loc(1), loc(2), txt, 'Color', [0.50, 0.50, 1.00], 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 48, 'FontName', options.font_type);
            
            

        end
        
        h2(3) = plot(NaN,NaN,'s', 'Color', [0.75 ,0.25, 0.75], 'MarkerSize', options.legend_marker_size, 'LineWidth', options.legend_line_width);
        test_legend = [test_legend; '\color[rgb]{0.75, 0.25, 0.75} Non Road'];
    
    else
        
        disp('No OR areas to plot!')
        
    end
    
    %% Legend
    
        % Legend

    l = legend(h2,  test_legend,...
                    'FontSize', options.legend_font_size ,...
                    'FontWeight', 'bold',... 
                    'LineWidth', 4,...
                    'FontName', options.font_type);
    l.Interpreter = 'tex';
    
    %% End Script
    
    disp('Completed per_area_score_plot.m')

    
    
end