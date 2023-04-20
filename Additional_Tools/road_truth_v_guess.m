%% Workspace Init

clear all
close all
format compact
clc

%% Options


%% Var Init


%% Loading classified results
% Ask user for location of classified results
[figfile, figfolder, ~] = uigetfile('*.fig','Get fig');

addpath(string(figfolder));

disp('Loading fig...')

fig = open(figfile);
axis equal
view([0 0 90])

Filename = string(figfolder) + string(figfile) + ".mat";

% axis on
hold all
% delete(legend)

%% Loading the two manual classified areas

truth_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Delete/rm_db_2_ALL.mat';

truth = load(truth_file);

guess_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Delete/rm_db_2_avg_results_to_classify.fig.mat';

guess = load(guess_file);

%% Plot the two

MCA_plotter(truth.Manual_Classfied_Areas)

MCA_plotter_AltColor(guess.Manual_Classfied_Areas)

%% Legend Update

hold all
h(1) = plot(NaN,NaN,'oc');
h(2) = plot(NaN,NaN,'ok');
h(3) = plot(NaN,NaN,'or');
h(4) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.75,0.00,0.00]); %MCA Grav
h(5) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.50,0.50,0.00]); %MCA Asph
h(6) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.00,0.75,0.00]); %MCAAlt Grav
h(7) = scatter(NaN,NaN, 'Marker', 's', 'MarkerFaceColor', [0.00,0.50,0.50]); %MCAAlt Asph

l = legend(h,  {'\color{cyan} Gravel',...
                '\color{black} Asphalt',...
                '\color{red} Unkn',...
                '\color[rgb]{0.75,0.00,0.00} True Grav',...
                '\color[rgb]{0.50,0.50,0.00} True Asph',...
                '\color[rgb]{0.00,0.75,0.00} Guess Grav',...
                '\color[rgb]{0.00,0.50,0.50} Guess Asph'},...
                'FontSize', 36,... 
                'FontWeight', 'bold',...
                'LineWidth', 4);
l.Interpreter = 'tex';







