%% ===================================================================== %%
%  PCD Stack Classifier Result Plotter
%  Plots the results from the stack classifier
%  Created on 11/18/2022
%  By Rhett Huston
%  =====================================================================  %

clear all;
close all;
clc;

%% Requesting user for file

root_dir = uigetdir();

%% Loading Export Location

RESULT_EXPORT_FOLDER = string(root_dir) + "/RESULT_EXPORT";

Save_All_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/ALL_RESULTS.mat";
Save_Avg_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/AVG_RESULTS.mat";

MANUAL_CLASSIFICATION_FILE = string(root_dir) + "/MANUAL_CLASSIFICATION/MANUAL_CLASSIFICATION.mat";

load(Save_All_Results_Filename);
load(Save_Avg_Results_Filename);

if exist(MANUAL_CLASSIFICATION_FILE) == 2
    
    % Do Something
    
    load(MANUAL_CLASSIFICATION_FILE)
    
end

%% Creating Image Export Location

IMAGE_EXPORT_FOLDER = string(root_dir) + "/IMAGE_EXPORT";

if ~exist(IMAGE_EXPORT_FOLDER, 'dir')
    
    mkdir(IMAGE_EXPORT_FOLDER);
    
end

addpath(IMAGE_EXPORT_FOLDER);

%% Creating result structs

% All
Grav_All_Append_Array = RESULTS_ALL.grav;
Chip_All_Append_Array = RESULTS_ALL.chip;
Foli_All_Append_Array = RESULTS_ALL.foli;
Gras_All_Append_Array = RESULTS_ALL.gras;


% Avg
Grav_Avg_Append_Array = RESULTS_AVG.grav;
Chip_Avg_Append_Array = RESULTS_AVG.chip;
Foli_Avg_Append_Array = RESULTS_AVG.foli;
Gras_Avg_Append_Array = RESULTS_AVG.gras;

if  isfield(RESULTS_ALL, 'quadrant_rate')
    
    quadrant_rate         = RESULTS_ALL.quadrant_rate;
    
end


%% Timing Math

if  isfield(RESULTS_ALL, 'quadrant_rate')
    
    move_avg_size = 50;
    
    max_time            = max(quadrant_rate); %s
    min_time            = min(quadrant_rate); %s
    
    max_Hz              = 1 / min(quadrant_rate); %Hz
    min_Hz              = 1 / max(quadrant_rate); %Hz
    
    quadrant_rate_Hz    =  quadrant_rate.^(-1);
    
    Move_mean_time      = movmean(quadrant_rate, move_avg_size);
    Move_mean_Hz        = movmean(quadrant_rate_Hz, move_avg_size);
    
    overall_avg_time    = mean(quadrant_rate);
    overall_avg_Hz      = mean(quadrant_rate_Hz);
    
end

%% Plotting Results

result_all_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1500 1500])

hold all

plot3(Grav_All_Append_Array(:,1), Grav_All_Append_Array(:,2), Grav_All_Append_Array(:,3), 'c.', 'MarkerSize', 3.5)
plot3(Chip_All_Append_Array(:,1), Chip_All_Append_Array(:,2), Chip_All_Append_Array(:,3), 'k.', 'MarkerSize', 3.5)
plot3(Foli_All_Append_Array(:,1), Foli_All_Append_Array(:,2), Foli_All_Append_Array(:,3), 'm.', 'MarkerSize', 3.5)
plot3(Gras_All_Append_Array(:,1), Gras_All_Append_Array(:,2), Gras_All_Append_Array(:,3), 'g.', 'MarkerSize', 3.5)

axis('equal')
axis off
view([0 0 90])

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4, 'Location', 'best' );
l.Interpreter = 'tex';

hold off

result_avg_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1500 1500])

hold all

plot3(Grav_Avg_Append_Array(:,1), Grav_Avg_Append_Array(:,2), Grav_Avg_Append_Array(:,3), 'c.', 'MarkerSize', 3.5)
plot3(Chip_Avg_Append_Array(:,1), Chip_Avg_Append_Array(:,2), Chip_Avg_Append_Array(:,3), 'k.', 'MarkerSize', 3.5)
plot3(Foli_Avg_Append_Array(:,1), Foli_Avg_Append_Array(:,2), Foli_Avg_Append_Array(:,3), 'm.', 'MarkerSize', 3.5)
plot3(Gras_Avg_Append_Array(:,1), Gras_Avg_Append_Array(:,2), Gras_Avg_Append_Array(:,3), 'g.', 'MarkerSize', 3.5)

axis('equal')
axis off
view([0 0 90])

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

hold off

%% Classification Rate Time

if  isfield(RESULTS_ALL, 'quadrant_rate')
    
    rate_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 400 1000])
    
    hold on
    
    plot(quadrant_rate, 'b')
    plot(Move_mean_time, 'r', 'LineWidth', 3)
    plot([0,length(quadrant_rate)], [overall_avg_time, overall_avg_time], 'k--', 'LineWidth', 3)
    
    hold off
    
    xlabel('Quadrant')
    ylabel('Time (s)')
    
    ylim([ min_time max_time])
    l = legend({'Time (s)','Moving Avg (s)', sprintf('Average: %0.2f (s)', overall_avg_time)}, 'FontSize', 25, 'FontWeight', 'bold', 'LineWidth', 4);
    
    xlim([200 2000])
    
    hold off
    
end

%% Classification Rate Hz

if  isfield(RESULTS_ALL, 'quadrant_rate')
    
    hz_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 400 1000])
    
    hold all
    
    plot(quadrant_rate_Hz, 'b')
    plot(Move_mean_Hz, 'r', 'LineWidth', 3)
    plot([0,length(quadrant_rate)], [overall_avg_Hz, overall_avg_Hz], 'k--', 'LineWidth', 3)
    
    
    xlabel('Quadrant')
    ylabel('Hz')
    
    l = legend({'Time (s)','Moving Avg (s)', sprintf('Average: %0.2f (Hz)', overall_avg_Hz)}, 'FontSize', 25, 'FontWeight', 'bold', 'LineWidth', 4);
    
    xlim([200 2000])
    
    hold off
    
end

%% Manual Classification Areas

if exist(MANUAL_CLASSIFICATION_FILE, 'dir') == 2
    
    Combined_Pcd_File = string(root_dir) + "/COMPILED_PCD/COMPILED_PCD.pcd";
    
    ptCloudSource = pcread(Combined_Pcd_File);
    
    ptCloudSource_figure = figure('Name','pcd','NumberTitle','off');
    pcshow(ptCloudSource)
    axis equal
    view([0 0 90])
    set(gcf,'color','white')
    hold all
    
    if isfield(Manual_Classfied_Areas, 'foli')
        
        for area_idx = 1:length(Manual_Classfied_Areas.foli)
            
            xy_roi = Manual_Classfied_Areas.foli_roi{area_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            p_foli(area_idx) = plot(pgon,'FaceColor','magenta','FaceAlpha',0.75);
            
        end
        
    end
    
    
    if isfield(Manual_Classfied_Areas, 'grav')
        
        for area_idx = 1:length(Manual_Classfied_Areas.grav)
            
            xy_roi = Manual_Classfied_Areas.grav{area_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            p_grav(area_idx) = plot(pgon,'FaceColor','red','FaceAlpha',0.75);
            
        end
        
    end
    
    if isfield(Manual_Classfied_Areas, 'gras')
        
        for area_idx = 1:length(Manual_Classfied_Areas.gras)
            
            xy_roi = Manual_Classfied_Areas.gras{area_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            p_gras(area_idx) = plot(pgon,'FaceColor','green','FaceAlpha',0.75);
            
        end
        
    end
    
    if isfield(Manual_Classfied_Areas, 'chip')
        
        for area_idx = 1:length(Manual_Classfied_Areas.chip)
            
            xy_roi = Manual_Classfied_Areas.chip{area_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            p_chip(area_idx) = plot(pgon,'FaceColor','black','FaceAlpha',0.75);
            
        end
        
    end
    
    if isfield(Manual_Classfied_Areas, 'non_road_roi')
        
        for area_idx = 1:length(Manual_Classfied_Areas.non_road_roi)
            
            xy_roi = Manual_Classfied_Areas.non_road_roi{area_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            p_non_road(area_idx) = plot(pgon,'FaceColor',[1.00, 0.65, 0.30],'FaceAlpha',0.75);
            
        end
        
    end
    
    if isfield(Manual_Classfied_Areas, 'road_roi')
        
        for area_idx = 1:length(Manual_Classfied_Areas.road_roi)
            
            xy_roi = Manual_Classfied_Areas.road_roi{area_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            p_road(area_idx) = plot(pgon,'FaceColor',[0.58, 0.50, 1.00],'FaceAlpha',0.75);
            
        end
        
    end

    view([0 0 90])
    
    axis off
    
    hold off
    
    l = legend([p_grav(1), p_non_road(1)],{'\color{red} Gravel','\color[rgb]{1.00, 0.65, 0.30} Side of Road'});
    l.Interpreter = 'tex';
    l.Box = 'on';
    l.Color = 'white';
    l.AutoUpdate = 'off';
    l.LineWidth = 2;
    l.FontWeight = 'bold';
    l.FontSize = 36;
    
end

%% Saving Figures

try
    
    saveas(result_all_fig, string(IMAGE_EXPORT_FOLDER) + '/result_all_fig.png', 'png');
    saveas(result_avg_fig, string(IMAGE_EXPORT_FOLDER) + '/result_avg_fig.png', 'png');
    
end

try
    saveas(rate_results_fig, string(IMAGE_EXPORT_FOLDER) + '/rate_results_fig.png', 'png');
    saveas(hz_results_fig, string(IMAGE_EXPORT_FOLDER) + '/hz_results_fig.png', 'png');
    
catch
    
    disp('No timing data to plot')
    
end

try
    
    saveas(ptCloudSource_figure, string(IMAGE_EXPORT_FOLDER) + '/ptCloudSource_figure.png', 'png');
    
catch
    
    disp('No Manual Classified areas to plot')
    
end

%% End Program

disp('End Program')



