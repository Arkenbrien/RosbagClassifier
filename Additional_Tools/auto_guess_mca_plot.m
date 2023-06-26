% auto_guess_mca_plot

options = get_plot_options();

% load fig first yo

% roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_1_truth_areas_v3.mat';
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_2_truth_areas_v3.mat';
roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_3_truth_areas_v3.mat';
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_4_truth_areas_v3.mat';
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_6_truth_areas_v3.mat';

load(roi_file)

MCA_plotter(Manual_Classfied_Areas, 0, options)

%% Gravel area 

% h(1) = plot(NaN,NaN,'s', 'Color', [0.75,0.00,0.00], 'MarkerFaceColor', [0.75,0.00,0.00], 'MarkerSize', 30, 'LineWidth', 3);
% h(2) = plot(NaN,NaN,'s', 'Color', [0.00,0.00,0.00], 'MarkerFaceColor', [0.00,0.00,0.00], 'MarkerSize', 30, 'LineWidth', 3);
% h(3) = plot(NaN,NaN,'s', 'Color', [0.00,1.00,1.00], 'MarkerFaceColor', [0.00,1.00,1.00], 'MarkerSize', 30, 'LineWidth', 3);
% h(4) = plot(NaN,NaN,'s', 'Color', [1.00,0.00,0.00], 'MarkerFaceColor', [1.00,0.00,0.00], 'MarkerSize', 30, 'LineWidth', 3);
% h(5) = plot(NaN,NaN,'--', 'Color', [0.00, 0.53, 1.00], 'MarkerSize', 30, 'LineWidth', 3);
% l = legend(h,  {'\color[rgb]{0.75,0.00,0.00} True Grav',...
%                 '\color[rgb]{0.00,0.00,0.00} Guess Asph',...
%                 '\color[rgb]{0.00,1.00,1.00} Guess Grav',...
%                 '\color[rgb]{1.00,0.00,0.00} Guess Unkn',...
%                 '\color[rgb]{0.00, 0.53, 1.00} Path'},...
%                 'FontSize', 56,... 
%                 'FontWeight', 'bold',...
%                 'LineWidth', 4);
% l.Interpreter = 'tex';

%% unknown area

% no unknown guess in rmdb3

h(1) = plot(NaN,NaN,'s', 'Color', [0.75, 0.25, 0.75], 'MarkerFaceColor', [0.75, 0.25, 0.75], 'MarkerSize', 30, 'LineWidth', 3);
h(2) = plot(NaN,NaN,'s', 'Color', [0.00,0.00,0.00], 'MarkerFaceColor', [0.00,0.00,0.00], 'MarkerSize', 30, 'LineWidth', 3);
h(3) = plot(NaN,NaN,'s', 'Color', [0.00,1.00,1.00], 'MarkerFaceColor', [0.00,1.00,1.00], 'MarkerSize', 30, 'LineWidth', 3);
h(4) = plot(NaN,NaN,'--', 'Color', [0.00, 0.53, 1.00], 'MarkerSize', 30, 'LineWidth', 3);
l = legend(h,  {'\color[rgb]{0.75, 0.25, 0.75} True Unkn',...
                '\color[rgb]{0.00,0.00,0.00} Guess Asph',...
                '\color[rgb]{0.00,1.00,1.00} Guess Grav',...
                '\color[rgb]{0.00, 0.53, 1.00} Path'},...
                'FontSize', 56,... 
                'FontWeight', 'bold',...
                'LineWidth', 4);
l.Interpreter = 'tex';


