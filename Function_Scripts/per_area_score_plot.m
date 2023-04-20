function per_area_score_plot(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score, Manual_Classfied_Areas)

    disp('Entered per_area_score_plot.m')

    %% Var Init
    
    % Legend Stuff
    h2 = zeros(1,3);
    
    % How big is fig
    fig_size_array = [10 10 1000 1000];
    
    
    %% Plotting the MCAs
    test_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
    
    MCA_plotter(Manual_Classfied_Areas)
    
    axis('equal')
    axis off
%     view([-pi/2 0 90])
    view([pi 0 90])

    hold all
    
    ax3 = gca;
    ax3.Clipping = 'off';
    
    % Legend
    h2(1) = plot(NaN,NaN,'s', 'Color', [0.75, 0.00, 0.00]);
    h2(2) = plot(NaN,NaN,'s', 'Color', [0.50, 0.50, 0.00]);
    h2(3) = plot(NaN,NaN,'s', 'Color', [0.50, 0.50, 1.00]);
    l = legend(h2, {'\color[rgb]{0.75,0.00,0.00} Gravel',...
                    '\color[rgb]{0.50,0.50,0.00} Asphalt'},...
                    'FontSize', 28,...
                    'FontWeight', 'bold',... 
                    'LineWidth', 4);
    l.Interpreter = 'tex';
    
    %% Gravel Area
    
    hold all
    
    try

        for grav_area_idx = 1:length(tot_in_grav_score)

            % Grabbing values
            asph_pc     = tot_in_grav_score{grav_area_idx}.tot_asph_in_grav_score;
            unkn_pc     = tot_in_grav_score{grav_area_idx}.tot_unkn_in_grav_score;
            grav_pc     = tot_in_grav_score{grav_area_idx}.tot_grav_in_grav_score;
            loc         = tot_in_grav_score{grav_area_idx}.avg_loc;

            % Making the text to be printed
            txt = sprintf('Asph %0.2f\nGrav %0.2f\nUnkn %0.2f', asph_pc, grav_pc, unkn_pc);
%             txt = sprintf('Asph %0.2f\nGrav %0.2f', asph_pc, grav_pc);
            text(loc(1), loc(2), txt, 'Color', [0.75,0.00,0.00], 'FontWeight', 'bold', 'FontSize', 14);

        end
        
    catch
        
        disp('No gravel areas to plot!')
        
    end
    
    %% Asphalt Area
    
    hold all
    
    try
        for asph_area_idx = 1:length(tot_in_asph_score)

            asph_pc     = tot_in_asph_score{asph_area_idx}.tot_asph_in_asph_score;
            unkn_pc     = tot_in_asph_score{asph_area_idx}.tot_unkn_in_asph_score;
            grav_pc     = tot_in_asph_score{asph_area_idx}.tot_grav_in_asph_score;
            loc         = tot_in_asph_score{asph_area_idx}.avg_loc;

            % Making the text to be printed
            txt = sprintf('Asph %0.2f\nGrav %0.2f\nUnkn %0.2f', asph_pc, grav_pc, unkn_pc);
%             txt = sprintf('Asph %0.2f\nGrav %0.2f', asph_pc, grav_pc);
            text(loc(1), loc(2), txt, 'Color', [0.50,0.50,0.00], 'FontWeight', 'bold', 'FontSize', 14);

        end
    
    catch
            
        disp('No Asphalt Areas to plot!')
        
    end
            
    %% Other Pavement
    
    hold all
    
    try

        for or_area_idx = 1:length(tot_in_or_score)

            asph_pc     = tot_in_or_score{or_area_idx}.tot_asph_in_or_score;
            unkn_pc     = tot_in_or_score{or_area_idx}.tot_unkn_in_or_score;
            grav_pc     = tot_in_or_score{or_area_idx}.tot_grav_in_or_score;
            loc         = tot_in_or_score{or_area_idx}.avg_loc;

            % Making the text to be printed
            txt = sprintf('Asph %0.2f\nGrav %0.2f\nUnkn %0.2f', asph_pc, grav_pc, unkn_pc);
%             txt = sprintf('Asph %0.2f\nGrav %0.2f', asph_pc, grav_pc);
            text(loc(1), loc(2), txt, 'Color', [0.50, 0.50, 1.00], 'FontWeight', 'bold', 'FontSize', 14);

        end
    
    catch
        
        disp('No OR areas to plot!')
        
    end
    
    %% End Script
    
    disp('Completed per_area_score_plot.m')

    
    
end