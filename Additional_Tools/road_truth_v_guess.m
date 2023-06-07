%% Workspace Init

clear all
close all
format compact
clc

%% Options

% Truth Area
truth_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_1_truth_areas_v3.mat';

% RANGE
fig_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/Range_Results/rm_db_1_raw_for_tvg.fig';
% guess_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/Range_Results/all_results_man_class/rm_db_6_MANUALLY_CLASSIFIED.mat';
guess_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/Range_Results/conf_filt_man_class/rm_db_1_MANUALLY_CLASSIFIED.mat';

% RANGE LCR
% fig_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/Range_lcr_Results/db_3_raw.fig';
% guess_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/Range_lcr_Results/db_3_raw_MANUALLY_CLASSIFIED.mat';

% RANSAC
% fig_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/RANSAC_Results/db_1_truth_v_guess.fig';
% guess_file =  '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/RANSAC_Results/rm_db_1_MANUALLY_CLASSIFIED.mat';

% MLS
% fig_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/MLS_Results/db_6_raw_for_tvg.fig';
% guess_file =  '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump/MLS_Results/db_6_MANUALLY_CLASSIFIED.mat';

%% Var Init

fig_size_array                  = [10 10 3500 1600];

% figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
% hold all

%% Loading classified results



fig = open(fig_file);
axis equal
view([0 0 90])

% Filename = string(figfile) + ".mat";

axis off
hold on
delete(legend)

max_h = 0;

%% Loading point cloud

% % Ask user for location of pcd
% % [pcfile, pcfolder, ~] = uigetfile('/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/*.pcd','Get PCD');
% [pcfile, pcfolder, ~] = uigetfile('/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/*.pcd','Get PCD');
% 
% addpath(string(pcfolder));
% 
% disp('Loading PCD...')
% ptCloudSource = pcread(pcfile);
% 
% max_h = max(ptCloudSource.Location(:,3));


%%

% ptCloudSource_figure = figure('Name','pcd','NumberTitle','off');
% pcshow(ptCloudSource)%, 'MarkerFaceAlpha', 0.02, 'MarkerEdgeAlpha', 0.02);
% % scatter3(ptCloudSource.Location(:,1), ptCloudSource.Location(:,2), ptCloudSource.Location(:,3), 'Marker', 'o','MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue', 'MarkerFaceAlpha', 0.02, 'MarkerEdgeAlpha', 0.02);
% axis equal
% view([0 0 90])


%% Loading the things

truth = load(truth_file);

guess = load(guess_file);

%% Plot the two

hold on

MCA_plotter(truth.Manual_Classfied_Areas, max_h)

hold on

MCA_plotter_AltColor(guess.Manual_Classfied_Areas, max_h)

%% Legend Update

hold on

h(1) = plot(NaN,NaN,'oc', 'LineWidth', 20);
h(2) = plot(NaN,NaN,'ok', 'LineWidth', 20);
h(3) = plot(NaN,NaN,'or', 'LineWidth', 20);
h(4) = plot(NaN,NaN,'s', 'Color', [0.75,0.00,0.00], 'MarkerFaceColor', [0.75,0.00,0.00], 'MarkerSize', 30, 'LineWidth', 3); %MCA Grav
% h(5) = plot(NaN,NaN,'s', 'Color', [0.50,0.50,0.00], 'MarkerFaceColor', [0.50,0.50,0.00], 'MarkerSize', 30, 'LineWidth', 3); %MCA Asph
% h(6) = plot(NaN,NaN,'s', 'Color', [0.75,0.25,0.75], 'MarkerFaceColor', [0.75,0.25,0.75], 'MarkerSize', 30, 'LineWidth', 3); %MCA Unknown
h(5) = plot(NaN,NaN,'s', 'Color', [0.00,0.75,0.00], 'MarkerFaceColor', [0.00,0.75,0.00], 'MarkerSize', 30, 'LineWidth', 3); %MCAAlt Grav
% h(8) = plot(NaN,NaN,'s', 'Color', [0.00,0.50,0.50], 'MarkerFaceColor', [0.00,0.50,0.50], 'MarkerSize', 30, 'LineWidth', 3); %MCAAlt Asph

% l = legend(h,  {'\color{cyan} Gravel',...
%                 '\color{black} Asphalt',...
%                 '\color{red} Unkn',...
%                 '\color[rgb]{0.75,0.00,0.00} True Grav',...
%                 '\color[rgb]{0.50,0.50,0.00} True Asph',...
%                 '\color[rgb]{0.75,0.25,0.75} Unkn',...
%                 '\color[rgb]{0.00,0.75,0.00} Guess Grav',...
%                 '\color[rgb]{0.00,0.50,0.50} Guess Asph'},...
%                 'FontSize', 56,... 
%                 'FontWeight', 'bold',...
%                 'LineWidth', 4);
% l.Interpreter = 'tex';

l = legend(h,  {'\color{cyan} Gravel',...
                '\color{black} Asphalt',...
                '\color{red} Unkn',...
                '\color[rgb]{0.75,0.00,0.00} True Grav',...
                '\color[rgb]{0.00,0.75,0.00} Guess Grav'},...
                'FontSize', 56,... 
                'FontWeight', 'bold',...
                'LineWidth', 4);
l.Interpreter = 'tex';

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
% 
% hold on
% 
% h(1) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.75,0.00,0.00], 'MarkerEdgeColor', [0.75,0.00,0.00], 'LineWidth', 20); %MCA Grav
% h(2) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.50,0.50,0.00], 'MarkerEdgeColor', [0.50,0.50,0.00], 'LineWidth', 20); %MCA Asph
% h(3) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.75,0.25,0.75], 'MarkerEdgeColor', [0.75,0.25,0.75], 'LineWidth', 20); %MCA Unkn
% h(4) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.00,0.75,0.00], 'MarkerEdgeColor', [0.00,0.75,0.00], 'LineWidth', 20); %MCAAlt Grav
% h(5) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.00,0.50,0.50], 'MarkerEdgeColor', [0.00,0.50,0.50], 'LineWidth', 20); %MCAAlt Asph
% h(6) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [1.00,0.40,0.10], 'MarkerEdgeColor', [1.00,0.40,0.10], 'LineWidth', 20); %MCAAlt Unkn
% 
% l = legend(h,  {'\color[rgb]{0.75,0.00,0.00} Train Grav',...
%                 '\color[rgb]{0.50,0.50,0.00} Train Asph',...
%                 '\color[rgb]{0.75,0.25,0.75} Train Unkn',...
%                 '\color[rgb]{0.00,0.75,0.00} Test Grav',...
%                 '\color[rgb]{0.00,0.50,0.50} Test Asph',...
%                 '\color[rgb]{1.00,0.40,0.10} Test Unkn'},...
%                 'FontSize', 36,... 
%                 'FontWeight', 'bold',...
%                 'LineWidth', 4);
% l.Interpreter = 'tex';

%% more formatting

view([0 0 90])

% xlim([min(ptCloudSource.Location(:,1)) max(ptCloudSource.Location(:,1))]);
% ylim([min(ptCloudSource.Location(:,2)) max(ptCloudSource.Location(:,2))]);

ax2 = gca;
ax2.Clipping = 'off';
% 
% set(gcf, 'Color', 'white'); % Set the figure background color to white
% set(gca, 'Color', 'white'); % Set the axes background color to white
% set(gca, 'Box', 'on'); % Add a border around the axes
% axis off
% Get the legend object
% legendObj = findobj(gcf, 'Type', 'Legend');

% Set the legend background color to white
% set(legendObj, 'Color', 'white');







