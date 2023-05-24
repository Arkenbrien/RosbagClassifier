%% Workspace Init

clear all
close all
format compact
clc

%% Options


%% Var Init

fig_size_array                  = [10 10 3500 1600];

% figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
% hold all

%% Loading classified results

% fig_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/MLS_Results/rm_db_4_avg_results.fig';
% fig_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/raw_classification_results_v3.fig';

% fig = open(fig_file);
% axis equal
% view([0 0 90])

% Filename = string(figfolder) + string(figfile) + ".mat";

% axis on
% hold on
% delete(legend)

%% Loading point cloud

% Ask user for location of pcd
% [pcfile, pcfolder, ~] = uigetfile('/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/*.pcd','Get PCD');
[pcfile, pcfolder, ~] = uigetfile('/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/*.pcd','Get PCD');

addpath(string(pcfolder));

disp('Loading PCD...')
ptCloudSource = pcread(pcfile);

max_h = max(ptCloudSource.Location(:,3));


%%

ptCloudSource_figure = figure('Name','pcd','NumberTitle','off');
pcshow(ptCloudSource)%, 'MarkerFaceAlpha', 0.02, 'MarkerEdgeAlpha', 0.02);
% scatter3(ptCloudSource.Location(:,1), ptCloudSource.Location(:,2), ptCloudSource.Location(:,3), 'Marker', 'o','MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue', 'MarkerFaceAlpha', 0.02, 'MarkerEdgeAlpha', 0.02);
axis equal
view([0 0 90])


%% Loading the things

truth_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/rm_db_2_where_training_area.mat';

truth = load(truth_file);

guess_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/rm_db_2_truth_areas_v3.mat';

guess = load(guess_file);

%% Plot the two

hold on

MCA_plotter(truth.Manual_Classfied_Areas, max_h)

hold on

MCA_plotter_AltColor(guess.Manual_Classfied_Areas, max_h)

%% Legend Update

% hold on
% 
% h(1) = plot(NaN,NaN,'oc', 'LineWidth', 20);
% h(2) = plot(NaN,NaN,'ok', 'LineWidth', 20);
% h(3) = plot(NaN,NaN,'or', 'LineWidth', 20);
% h(4) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.75,0.00,0.00], 'MarkerEdgeColor', [0.75,0.00,0.00], 'LineWidth', 20); %MCA Grav
% h(5) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.50,0.50,0.00], 'MarkerEdgeColor', [0.50,0.50,0.00], 'LineWidth', 20); %MCA Asph
% h(6) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.75,0.25,0.75], 'MarkerEdgeColor', [0.75,0.25,0.75], 'LineWidth', 20); %MCA Unknown
% h(7) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.00,0.75,0.00], 'MarkerEdgeColor', [0.00,0.75,0.00], 'LineWidth', 20); %MCAAlt Grav
% h(8) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.00,0.50,0.50], 'MarkerEdgeColor', [0.00,0.50,0.50], 'LineWidth', 20); %MCAAlt Asph
% 
% l = legend(h,  {'\color{cyan} Gravel',...
%                 '\color{black} Asphalt',...
%                 '\color{red} Unkn',...
%                 '\color[rgb]{0.75,0.00,0.00} True Grav',...
%                 '\color[rgb]{0.50,0.50,0.00} True Asph',...
%                 '\color[rgb]{0.75,0.25,0.75} Unkn',...
%                 '\color[rgb]{0.00,0.75,0.00} Guess Grav',...
%                 '\color[rgb]{0.00,0.50,0.50} Guess Asph'},...
%                 'FontSize', 36,... 
%                 'FontWeight', 'bold',...
%                 'LineWidth', 4);
% l.Interpreter = 'tex';

% just the uuuuuh I forget. Oh yeah the truth areas, no guessing
% l = legend(h,  {'\color{cyan} Gravel',...
%                 '\color{black} Asphalt',...
%                 '\color{red} Unkn',...
%                 '\color[rgb]{0.75,0.00,0.00} Grav',...
%                 '\color[rgb]{0.50,0.50,0.00} Asph',...
%                 '\color[rgb]{0.75,0.25,0.75} Unkn'},...
%                 'FontSize', 36,... 
%                 'FontWeight', 'bold',...
%                 'LineWidth', 4);
% l.Interpreter = 'tex';


%% Legend Update JUST for comparing training vs testing areas

hold on

h(1) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.75,0.00,0.00], 'MarkerEdgeColor', [0.75,0.00,0.00], 'LineWidth', 20); %MCA Grav
h(2) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.50,0.50,0.00], 'MarkerEdgeColor', [0.50,0.50,0.00], 'LineWidth', 20); %MCA Asph
h(3) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.75,0.25,0.75], 'MarkerEdgeColor', [0.75,0.25,0.75], 'LineWidth', 20); %MCA Unkn
h(4) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.00,0.75,0.00], 'MarkerEdgeColor', [0.00,0.75,0.00], 'LineWidth', 20); %MCAAlt Grav
h(5) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.00,0.50,0.50], 'MarkerEdgeColor', [0.00,0.50,0.50], 'LineWidth', 20); %MCAAlt Asph
h(6) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [1.00,0.40,0.10], 'MarkerEdgeColor', [1.00,0.40,0.10], 'LineWidth', 20); %MCAAlt Unkn

l = legend(h,  {'\color[rgb]{0.75,0.00,0.00} Train Grav',...
                '\color[rgb]{0.50,0.50,0.00} Train Asph',...
                '\color[rgb]{0.75,0.25,0.75} Train Unkn',...
                '\color[rgb]{0.00,0.75,0.00} Test Grav',...
                '\color[rgb]{0.00,0.50,0.50} Test Asph',...
                '\color[rgb]{1.00,0.40,0.10} Test Unkn'},...
                'FontSize', 36,... 
                'FontWeight', 'bold',...
                'LineWidth', 4);
l.Interpreter = 'tex';

%% more formatting

view([0 0 90])

xlim([min(ptCloudSource.Location(:,1)) max(ptCloudSource.Location(:,1))]);
ylim([min(ptCloudSource.Location(:,2)) max(ptCloudSource.Location(:,2))]);

ax2 = gca;
ax2.Clipping = 'on';

set(gcf, 'Color', 'white'); % Set the figure background color to white
set(gca, 'Color', 'white'); % Set the axes background color to white
set(gca, 'Box', 'on'); % Add a border around the axes
axis off
% Get the legend object
legendObj = findobj(gcf, 'Type', 'Legend');

% Set the legend background color to white
set(legendObj, 'Color', 'white');







