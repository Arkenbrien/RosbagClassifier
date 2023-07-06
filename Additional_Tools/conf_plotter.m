%% conf plotter

clear all
close all
clc

%% VAR INIT

num_chans = 3;

x_y_z_path = [];

% Chan 2
Grav_Avg_Append_Array_2 = []; Asph_Avg_Append_Array_2 = []; Unkn_Avg_Append_Array_2 = [];

% Chan 3
Grav_Avg_Append_Array_3 = []; Asph_Avg_Append_Array_3 = []; Unkn_Avg_Append_Array_3 = [];

% Chan 4
Grav_Avg_Append_Array_4 = []; Asph_Avg_Append_Array_4 = []; Unkn_Avg_Append_Array_4 = [];

% Chan 2
Grav_CT_Append_Array_2 = []; Asph_CT_Append_Array_2 = []; Unkn_CT_Append_Array_2 = [];

% Chan 3
Grav_CT_Append_Array_3 = []; Asph_CT_Append_Array_3 = []; Unkn_CT_Append_Array_3 = [];

% Chan 4
Grav_CT_Append_Array_4 = []; Asph_CT_Append_Array_4 = []; Unkn_CT_Append_Array_4 = [];


%% Options

% RANGE SETTINGS
grav_conf_lowbound = 0.95;
unkn_conf_lowbound = 0.95;
asph_conf_lowbound = 0.90;

% RANSAC SETTINGS
% grav_conf_lowbound = 0.75;
% unkn_conf_lowbound = 0.95;
% asph_conf_lowbound = 0.75;

% MLS SETTINGS
% grav_conf_lowbound = 0.95;
% unkn_conf_lowbound = 0.60;
% asph_conf_lowbound = 0.90;

% NONE SETTINGS
% grav_conf_lowbound = 0;
% unkn_conf_lowbound = 0;
% asph_conf_lowbound = 0;

options                         = struct();
options                         = get_plot_options();
options.plot_ani                = 0;
options.save_anim_bool          = 0;
options.auto_road_guesser_bool  = 1;
options.plot_area_results_bool  = 1;

options.rosbag_number           = 6;

dot_bool                        = 0;
grey_dots_bool                  = 0;
size_altered_bool               = 0;
seperate_bool                   = 0;
all_conf_bool                   = 0;
sep_dot_fig                     = 0;

%% Load file & data

% load('1686055798.6768_rm_db_4_range_Results_Export.mat')
% [matfile, matfolder, ~] = uigetfile('*Results_Export.mat','Get Results');

% mat_file = 'rm_db_1_range_1687537308.5231_Results_Export.mat';
% load(mat_file)
% disp(mat_file)

if options.rosbag_number == 1
    mat_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Range_Results/final2/rm_db_1_range_1687537308.5231_Results_Export.mat';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_1_truth_areas_v3.mat';
elseif options.rosbag_number == 2
    mat_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Range_Results/final2/rm_db_2_range_1687537369.4199_Results_Export.mat';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_2_truth_areas_v3.mat';
elseif options.rosbag_number == 3
    mat_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Range_Results/final2/rm_db_3_range_1687537522.7887_Results_Export.mat';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_3_truth_areas_v3.mat';
elseif options.rosbag_number == 4 % NOTE; 1156.8 feet traveled in rm_db_4 338.01 avg sec per scan, 463 clouds in the file
    mat_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Range_Results/final2/rm_db_4_range_1687537686.5371_Results_Export.mat';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_4_truth_areas_v3.mat';
elseif options.rosbag_number == 6
    mat_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Range_Results/final2/rm_db_6_range_1687537932.853_Results_Export.mat';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_6_truth_areas_v3.mat';
end

load(roi_file)
load(mat_file)
disp(mat_file)

%% Get path_coord if exists

if isfield(Results_Export, 'path_coord')
    
    for idx = 1:length(Results_Export.path_coord)
        
        x_y_z_path(idx,:) = Results_Export.path_coord{idx};
        
    end
    
    x_y_z_path = x_y_z_path * rotz(-90);
    
end


%% Select the data

load_result_bar = waitbar(0, "Loading Files...");

for idx2 = 1:length(Results_Export.c2)
    
    xyzi = Results_Export.c2{idx2}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c2{idx2}.scores];
    
    % Channel 2
    if isequal(Results_Export.c2{idx2}.Yfit, 'asphalt')
        %         Asph_All_Append_Array_2             = [Asph_All_Append_Array_2; xyzi];
        Asph_Avg_Append_Array_2             = [Asph_Avg_Append_Array_2; avg_xyzi];
    end
    
    if isequal(Results_Export.c2{idx2}.Yfit, 'unknown')
        %         Unkn_All_Append_Array_2             = [Unkn_All_Append_Array_2; xyzi];
        Unkn_Avg_Append_Array_2             = [Unkn_Avg_Append_Array_2; avg_xyzi];
    end
    
    if isequal(Results_Export.c2{idx2}.Yfit, 'gravel')
        %         Grav_All_Append_Array_2             = [Grav_All_Append_Array_2; xyzi];
        Grav_Avg_Append_Array_2             = [Grav_Avg_Append_Array_2; avg_xyzi];
    end
    
end

waitbar(1/num_chans, load_result_bar, sprintf('Channel %d out of %d', 1, num_chans))

for idx3 = 1:length(Results_Export.c3)
    
    xyzi = Results_Export.c3{idx3}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c3{idx3}.scores];
    
    % Channel 3
    if isequal(Results_Export.c3{idx3}.Yfit, 'asphalt')
        %         Asph_All_Append_Array_3             = [Asph_All_Append_Array_3; xyzi];
        Asph_Avg_Append_Array_3             = [Asph_Avg_Append_Array_3; avg_xyzi];
    end
    
    if isequal(Results_Export.c3{idx3}.Yfit, 'unknown')
        %         Unkn_All_Append_Array_3             = [Unkn_All_Append_Array_3; xyzi];
        Unkn_Avg_Append_Array_3             = [Unkn_Avg_Append_Array_3; avg_xyzi];
    end
    
    if isequal(Results_Export.c3{idx3}.Yfit, 'gravel')
        %         Grav_All_Append_Array_3             = [Grav_All_Append_Array_3; xyzi];
        Grav_Avg_Append_Array_3             = [Grav_Avg_Append_Array_3; avg_xyzi];
    end
    
end

waitbar(2/num_chans, load_result_bar, sprintf('Channel %d out of %d', 2, num_chans))

for idx4 = 1:length(Results_Export.c4)
    
    xyzi = Results_Export.c4{idx4}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c4{idx4}.scores];
    
    % Channel 4
    if isequal(Results_Export.c4{idx4}.Yfit, 'asphalt')
        %         Asph_All_Append_Array_4             = [Asph_All_Append_Array_4; xyzi];
        Asph_Avg_Append_Array_4             = [Asph_Avg_Append_Array_4; avg_xyzi];
    end
    
    if isequal(Results_Export.c4{idx4}.Yfit, 'unknown')
        %         Unkn_All_Append_Array_4             = [Unkn_All_Append_Array_4; xyzi];
        Unkn_Avg_Append_Array_4             = [Unkn_Avg_Append_Array_4; avg_xyzi];
    end
    
    if isequal(Results_Export.c4{idx4}.Yfit, 'gravel')
        %         Grav_All_Append_Array_4             = [Grav_All_Append_Array_4; xyzi];
        Grav_Avg_Append_Array_4             = [Grav_Avg_Append_Array_4; avg_xyzi];
    end
    
end

waitbar(3/num_chans, load_result_bar, sprintf('Channel %d out of %d', 3, num_chans))

delete(load_result_bar)

load_result_bar = waitbar(0, "Loading Files...");

for idx2 = 1:length(Results_Export.c2)
    
    xyzi = Results_Export.c2{idx2}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c2{idx2}.scores];
    
    % Channel 2
    if isequal(Results_Export.c2{idx2}.Yfit, 'asphalt') && Results_Export.c2{idx2}.scores(1) > asph_conf_lowbound
        %         Asph_All_Append_Array_2             = [Asph_All_Append_Array_2; xyzi];
        Asph_CT_Append_Array_2             = [Asph_CT_Append_Array_2; avg_xyzi];
    end
    
    if isequal(Results_Export.c2{idx2}.Yfit, 'unknown') && Results_Export.c2{idx2}.scores(2) > unkn_conf_lowbound
        %         Unkn_All_Append_Array_2             = [Unkn_All_Append_Array_2; xyzi];
        Unkn_CT_Append_Array_2             = [Unkn_CT_Append_Array_2; avg_xyzi];
    end
    
    if isequal(Results_Export.c2{idx2}.Yfit, 'gravel') && Results_Export.c2{idx2}.scores(3) > grav_conf_lowbound
        %         Grav_All_Append_Array_2             = [Grav_All_Append_Array_2; xyzi];
        Grav_CT_Append_Array_2             = [Grav_CT_Append_Array_2; avg_xyzi];
    end
    
end

waitbar(1/num_chans, load_result_bar, sprintf('Channel %d out of %d', 1, num_chans))

for idx3 = 1:length(Results_Export.c3)
    
    xyzi = Results_Export.c3{idx3}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c3{idx3}.scores];
    
    % Channel 3
    if isequal(Results_Export.c3{idx3}.Yfit, 'asphalt') && Results_Export.c3{idx3}.scores(1) > asph_conf_lowbound
        %         Asph_All_Append_Array_3             = [Asph_All_Append_Array_3; xyzi];
        Asph_CT_Append_Array_3             = [Asph_CT_Append_Array_3; avg_xyzi];
    end
    
    if isequal(Results_Export.c3{idx3}.Yfit, 'unknown') && Results_Export.c3{idx3}.scores(2) > unkn_conf_lowbound
        %         Unkn_All_Append_Array_3             = [Unkn_All_Append_Array_3; xyzi];
        Unkn_CT_Append_Array_3             = [Unkn_CT_Append_Array_3; avg_xyzi];
    end
    
    if isequal(Results_Export.c3{idx3}.Yfit, 'gravel') && Results_Export.c3{idx3}.scores(3) > grav_conf_lowbound
        %         Grav_All_Append_Array_3             = [Grav_All_Append_Array_3; xyzi];
        Grav_CT_Append_Array_3             = [Grav_CT_Append_Array_3; avg_xyzi];
    end
    
end

waitbar(2/num_chans, load_result_bar, sprintf('Channel %d out of %d', 2, num_chans))

for idx4 = 1:length(Results_Export.c4)
    
    xyzi = Results_Export.c4{idx4}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c4{idx4}.scores];
    
    % Channel 4
    if isequal(Results_Export.c4{idx4}.Yfit, 'asphalt') && Results_Export.c4{idx4}.scores(1) > asph_conf_lowbound
        %         Asph_All_Append_Array_4             = [Asph_All_Append_Array_4; xyzi];
        Asph_CT_Append_Array_4             = [Asph_CT_Append_Array_4; avg_xyzi];
    end
    
    if isequal(Results_Export.c4{idx4}.Yfit, 'unknown') && Results_Export.c4{idx4}.scores(2) > unkn_conf_lowbound
        %         Unkn_All_Append_Array_4             = [Unkn_All_Append_Array_4; xyzi];
        Unkn_CT_Append_Array_4             = [Unkn_CT_Append_Array_4; avg_xyzi];
    end
    
    if isequal(Results_Export.c4{idx4}.Yfit, 'gravel') && Results_Export.c4{idx4}.scores(3) > grav_conf_lowbound
        %         Grav_All_Append_Array_4             = [Grav_All_Append_Array_4; xyzi];
        Grav_CT_Append_Array_4             = [Grav_CT_Append_Array_4; avg_xyzi];
    end
    
end

waitbar(3/num_chans, load_result_bar, sprintf('Channel %d out of %d', 3, num_chans))

delete(load_result_bar)

%% Making a struct for the individual terrain conf plots

All_Avg_Array = [Asph_Avg_Append_Array_2;...
    Asph_Avg_Append_Array_3;...
    Asph_Avg_Append_Array_4;...
    Grav_Avg_Append_Array_2;...
    Grav_Avg_Append_Array_3;...
    Grav_Avg_Append_Array_4;...
    Unkn_Avg_Append_Array_2;...
    Unkn_Avg_Append_Array_3;...
    Unkn_Avg_Append_Array_4];

options.max_h = max(All_Avg_Array(:,3));

%% Plot animation/road guess

if options.auto_road_guesser_bool
    
    % Var Init
    
    Avg_Arrays.grav2 = Grav_CT_Append_Array_2;
    Avg_Arrays.grav3 = Grav_CT_Append_Array_3;
    Avg_Arrays.grav4 = Grav_CT_Append_Array_4;
    
    Avg_Arrays.asph2 = Asph_CT_Append_Array_2;
    Avg_Arrays.asph3 = Asph_CT_Append_Array_3;
    Avg_Arrays.asph4 = Asph_CT_Append_Array_4;
    
    Avg_Arrays.unkn2 = Unkn_CT_Append_Array_2;
    Avg_Arrays.unkn3 = Unkn_CT_Append_Array_3;
    Avg_Arrays.unkn4 = Unkn_CT_Append_Array_4;
    
    x_y_z_path = [];
    tform_array = [];
    
    options.mca_plot = 0;
    options.plot_avg_in_ani_bool = 0;
    
    % Get the path    
    for idx = 1:length(Results_Export.path_coord)
        x_y_z_path(:,idx) = Results_Export.path_coord{idx};
    end

    % Animate
    auto_road_guesser(Avg_Arrays, Manual_Classfied_Areas, Results_Export.path_coord, options, Results_Export.tform)
    
end

%% Plot Area Scores

if options.plot_area_results_bool
    
    class_score_function_test(Avg_Arrays, Manual_Classfied_Areas, options)
    
end


%%  Plot the data - just the dots

if dot_bool
    
    if sep_dot_fig
        dot_figure = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    end
    
    if grey_dots_bool
        
        hold on

        try
            plot3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.gravlinewidth)
        catch
            disp('No Grav Data on Chan 2!')
        end
        try
            plot3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.asphlinewidth)
        catch
            disp('No Asph Data on Chan 2!')
        end
        try
            plot3(Unkn_Avg_Append_Array_2(:,1), Unkn_Avg_Append_Array_2(:,2), Unkn_Avg_Append_Array_2(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.unknlinewidth)
        catch
            disp('No Unkn Data on Chan 2!')
        end

        % Channel 3
        try
            plot3(Grav_Avg_Append_Array_3(:,1), Grav_Avg_Append_Array_3(:,2), Grav_Avg_Append_Array_3(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.gravlinewidth)
        catch
            disp('No Grav Data on Chan 3!')
        end

        try
            plot3(Asph_Avg_Append_Array_3(:,1), Asph_Avg_Append_Array_3(:,2), Asph_Avg_Append_Array_3(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.asphlinewidth)
        catch
            disp('No Asph Data on Chan 3!')
        end

        try
            plot3(Unkn_Avg_Append_Array_3(:,1), Unkn_Avg_Append_Array_3(:,2), Unkn_Avg_Append_Array_3(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.unknlinewidth)
        catch
            disp('No Unkn Data on Chan 3!')
        end

        % Channel 4
        try
            plot3(Grav_Avg_Append_Array_4(:,1), Grav_Avg_Append_Array_4(:,2), Grav_Avg_Append_Array_4(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.gravlinewidth)
        catch
            disp('No Grav Data on Chan 4!')
        end

        try
            plot3(Asph_Avg_Append_Array_4(:,1), Asph_Avg_Append_Array_4(:,2), Asph_Avg_Append_Array_4(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.asphlinewidth)
        catch
            disp('No Asph Data on Chan 4!')
        end

        try
            plot3(Unkn_Avg_Append_Array_4(:,1), Unkn_Avg_Append_Array_4(:,2), Unkn_Avg_Append_Array_4(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'MarkerFaceColor', options.grey_col, 'MarkerEdgeColor', options.grey_col, 'LineWidth', options.unknlinewidth)
        catch
            disp('No Unkn Data on Chan 4!')
        end
        
    end
    
    % Channel 2
    hold all
    try
        plot3(Grav_CT_Append_Array_2(:,1), Grav_CT_Append_Array_2(:,2), Grav_CT_Append_Array_2(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'MarkerFaceColor', options.grav_col, 'MarkerEdgeColor', options.grav_col, 'LineWidth', options.gravlinewidth)
    catch
        disp('No Grav Data on Chan 2!')
    end
    try
        plot3(Asph_CT_Append_Array_2(:,1), Asph_CT_Append_Array_2(:,2), Asph_CT_Append_Array_2(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'MarkerFaceColor', options.asph_col, 'MarkerEdgeColor', options.asph_col, 'LineWidth', options.asphlinewidth)
    catch
        disp('No Asph Data on Chan 2!')
    end
    try
        plot3(Unkn_CT_Append_Array_2(:,1), Unkn_CT_Append_Array_2(:,2), Unkn_CT_Append_Array_2(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'MarkerFaceColor', options.unkn_col, 'MarkerEdgeColor', options.unkn_col, 'LineWidth', options.unknlinewidth)
    catch
        disp('No Unkn Data on Chan 2!')
    end
    
    % Channel 3
    try
        plot3(Grav_CT_Append_Array_3(:,1), Grav_CT_Append_Array_3(:,2), Grav_CT_Append_Array_3(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'MarkerFaceColor', options.grav_col, 'MarkerEdgeColor', options.grav_col, 'LineWidth', options.gravlinewidth)
    catch
        disp('No Grav Data on Chan 3!')
    end
    
    try
        plot3(Asph_CT_Append_Array_3(:,1), Asph_CT_Append_Array_3(:,2), Asph_CT_Append_Array_3(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'MarkerFaceColor', options.asph_col, 'MarkerEdgeColor', options.asph_col, 'LineWidth', options.asphlinewidth)
    catch
        disp('No Asph Data on Chan 3!')
    end
    
    try
        plot3(Unkn_CT_Append_Array_3(:,1), Unkn_CT_Append_Array_3(:,2), Unkn_CT_Append_Array_3(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'MarkerFaceColor', options.unkn_col, 'MarkerEdgeColor', options.unkn_col, 'LineWidth', options.unknlinewidth)
    catch
        disp('No Unkn Data on Chan 3!')
    end
    
    % Channel 4
    try
        plot3(Grav_CT_Append_Array_4(:,1), Grav_CT_Append_Array_4(:,2), Grav_CT_Append_Array_4(:,3), options.grav_sym, 'MarkerSize', options.gravmarkersize, 'MarkerFaceColor', options.grav_col, 'MarkerEdgeColor', options.grav_col, 'LineWidth', options.gravlinewidth)
    catch
        disp('No Grav Data on Chan 4!')
    end
    
    try
        plot3(Asph_CT_Append_Array_4(:,1), Asph_CT_Append_Array_4(:,2), Asph_CT_Append_Array_4(:,3), options.asph_sym, 'MarkerSize', options.asphmarkersize, 'MarkerFaceColor', options.asph_col, 'MarkerEdgeColor', options.asph_col, 'LineWidth', options.asphlinewidth)
    catch
        disp('No Asph Data on Chan 4!')
    end
    
    try
        plot3(Unkn_CT_Append_Array_4(:,1), Unkn_CT_Append_Array_4(:,2), Unkn_CT_Append_Array_4(:,3), options.unkn_sym, 'MarkerSize', options.unknmarkersize, 'MarkerFaceColor', options.unkn_col, 'MarkerEdgeColor', options.unkn_col, 'LineWidth', options.unknlinewidth)
    catch
        disp('No Unkn Data on Chan 4!')
    end
    
    
    
    axis('equal')
    axis off
    view([0 0 90])
    
    hold on
    
    % MCA_plotter(Manual_Classfied_Areas, z_max_lim)
    
    % xlim([x_min_lim x_max_lim]);
    % ylim([y_min_lim y_max_lim]);

    if ~isempty(x_y_z_path)
        
        plot3(x_y_z_path(:,1), x_y_z_path(:,2), x_y_z_path(:,3)+10, options.x_y_z_path_sym, 'Color', options.x_y_z_path_color, 'LineWidth', options.x_y_z_path_linewidth);
        
        h(1) = plot(NaN,NaN,options.grav_sym, 'MarkerFaceColor', options.grav_col, 'MarkerEdgeColor', options.grav_col ,'LineWidth', options.gravlinewidth, 'MarkerSize', options.gravmarkersize);
        h(2) = plot(NaN,NaN,options.asph_sym, 'MarkerFaceColor', options.asph_col, 'MarkerEdgeColor', options.asph_col, 'LineWidth', options.asphlinewidth, 'MarkerSize', options.asphmarkersize);
        h(3) = plot(NaN,NaN,options.unkn_sym, 'MarkerFaceColor', options.unkn_col, 'MarkerEdgeColor', options.unkn_col, 'LineWidth', options.unknlinewidth, 'MarkerSize', options.unknmarkersize);
        h(4) = plot(NaN,NaN,options.h_path_sym, 'Color', options.h_path_col, 'LineWidth', options.h_path_linewidth);
        l       = legend(h, {'\color{cyan} Gravel',...
                             '\color{black} Asphalt',...
                             '\color{red} Unkn',...
                             '\color[rgb]{0.00, 0.53, 1.00} Path'},... 
                             'FontSize', options.legend_font_size,... 
                             'FontWeight',... 
                             'bold',... 
                             'LineWidth', 4);
        l.Interpreter = 'tex';
        
    elseif isempty(x_y_z_path)
        
        h(1) = plot(NaN,NaN,options.h1_sym, 'LineWidth', options.h1_size);
        h(2) = plot(NaN,NaN,options.h2_sym, 'LineWidth', options.h2_size);
        h(3) = plot(NaN,NaN,options.h3_sym, 'LineWidth', options.h3_size);
        l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
        l.Interpreter = 'tex';
        
    else
        
        warning('Uh oh')
        
    end
    
    ax2 = gca;
    ax2.Clipping = 'off';
    
end

%%  Plot the data - Size-altered



if size_altered_bool
    
    scatter_figure = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    
    % Channel 2
    hold all
    try
        scatter3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), 'filled', 'SizeData', ((Grav_Avg_Append_Array_2(:,7)+0.01)*options.scale_factor), 'MarkerFaceColor', options.grav_col , 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'c')
    catch
        disp('No Grav Data on Chan 2!')
    end
    try
        scatter3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), 'filled', 'SizeData', ((Asph_Avg_Append_Array_2(:,5)+0.01)*options.scale_factor), 'MarkerFaceColor', options.asph_col , 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'k')
    catch
        disp('No Asph Data on Chan 2!')
    end
    try
        scatter3(Unkn_Avg_Append_Array_2(:,1), Unkn_Avg_Append_Array_2(:,2), Unkn_Avg_Append_Array_2(:,3), 'filled', 'SizeData', ((Unkn_Avg_Append_Array_2(:,6)+0.01)*options.scale_factor), 'MarkerFaceColor', options.unkn_col, 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'r')
    catch
        disp('No Unkn Data on Chan 2!')
    end
    
    % Channel 3
    try
        scatter3(Grav_Avg_Append_Array_3(:,1), Grav_Avg_Append_Array_3(:,2), Grav_Avg_Append_Array_3(:,3), 'filled', 'SizeData', ((Grav_Avg_Append_Array_3(:,7)+0.01)*options.scale_factor), 'MarkerFaceColor', options.grav_col , 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'c')
    catch
        disp('No Grav Data on Chan 3!')
    end
    
    try
        scatter3(Asph_Avg_Append_Array_3(:,1), Asph_Avg_Append_Array_3(:,2), Asph_Avg_Append_Array_3(:,3), 'filled', 'SizeData', ((Asph_Avg_Append_Array_3(:,5)+0.01)*options.scale_factor), 'MarkerFaceColor', options.asph_col, 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'k')
    catch
        disp('No Asph Data on Chan 3!')
    end
    
    try
        scatter3(Unkn_Avg_Append_Array_3(:,1), Unkn_Avg_Append_Array_3(:,2), Unkn_Avg_Append_Array_3(:,3), 'filled', 'SizeData', ((Unkn_Avg_Append_Array_3(:,6)+0.01)*options.scale_factor), 'MarkerFaceColor', options.unkn_col, 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'r')
    catch
        disp('No Unkn Data on Chan 3!')
    end
    
    % Channel 4
    try
        scatter3(Grav_Avg_Append_Array_4(:,1), Grav_Avg_Append_Array_4(:,2), Grav_Avg_Append_Array_4(:,3), 'filled', 'SizeData', ((Grav_Avg_Append_Array_4(:,7)+0.01)*options.scale_factor), 'MarkerFaceColor', options.grav_col , 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'c')
    catch
        disp('No Grav Data on Chan 4!')
    end
    
    try
        scatter3(Asph_Avg_Append_Array_4(:,1), Asph_Avg_Append_Array_4(:,2), Asph_Avg_Append_Array_4(:,3), 'filled', 'SizeData', ((Asph_Avg_Append_Array_4(:,5)+0.01)*options.scale_factor), 'MarkerFaceColor', options.asph_col, 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'k')
    catch
        disp('No Asph Data on Chan 4!')
    end
    
    try
        scatter3(Unkn_Avg_Append_Array_4(:,1), Unkn_Avg_Append_Array_4(:,2), Unkn_Avg_Append_Array_4(:,3), 'filled', 'SizeData', ((Unkn_Avg_Append_Array_4(:,6)+0.01)*options.scale_factor), 'MarkerFaceColor', options.unkn_col, 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'r')
    catch
        disp('No Unkn Data on Chan 4!')
    end
    
    axis('equal')
    axis off
    view([0 0 90])
    
    hold on
    
    % MCA_plotter(Manual_Classfied_Areas, z_max_lim)
    
    % xlim([x_min_lim x_max_lim]);
    % ylim([y_min_lim y_max_lim]);
    
    h(1) = plot(NaN,NaN,'oc', 'LineWidth', 25);
    h(2) = plot(NaN,NaN,'ok', 'LineWidth', 25);
    h(3) = plot(NaN,NaN,'or', 'LineWidth', 25);
    l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    
    ax2 = gca;
    ax2.Clipping = 'off';
    
end

%%



if seperate_bool
    
    %% Plotting Asphalt Confs
    
    asph_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,5)+0.01)*options.scale_factor), 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'k')
    hold on
    axis('equal')
    axis off
    view([0 0 90])
    hold on
    h = plot(NaN,NaN,'ok', 'LineWidth', 25);
    hold off
    l = legend(h, {'\color{black} Asphalt'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    ax2 = gca;
    ax2.Clipping = 'off';
    
    
    %% Plotting Grass (UNKNOWN) Confs
    
    unkn_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,6)+0.01)*options.scale_factor), 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'r')
    hold on
    axis('equal')
    axis off
    view([0 0 90])
    hold on
    h = plot(NaN,NaN,'or', 'LineWidth', 25);
    l = legend(h, {'\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    hold off
    ax2 = gca;
    ax2.Clipping = 'off';
    
    
    %% Plotting Gravel Confs
    
    grav_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,7)+0.01)*options.scale_factor), 'MarkerFaceColor', 'c', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'c')
    hold on
    axis('equal')
    axis off
    view([0 0 90])
    hold on
    h = plot(NaN,NaN,'oc', 'LineWidth', 25);
    l = legend(h, {'\color{cyan} Gravel'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    hold off
    ax2 = gca;
    ax2.Clipping = 'off';
    
end


%% Plotting All Confs


if all_conf_bool
    
    all_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    hold on
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'SizeData', (((All_Avg_Array(:,7)+0.01)*options.scale_factor)*1.25), 'Marker', 'square', 'MarkerEdgeColor', 'c', 'LineWidth', options.linewidth)
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'SizeData', ((All_Avg_Array(:,6)+0.01)*options.scale_factor), 'Marker', 'o', 'MarkerEdgeColor', 'r', 'LineWidth', options.linewidth)
    scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'SizeData', ((All_Avg_Array(:,5)+0.01)*options.scale_factor), 'Marker', 'diamond', 'MarkerEdgeColor', 'k', 'LineWidth', options.linewidth)
    axis('equal')
    axis off
    view([0 0 90])
    h(1) = plot(NaN,NaN,'c', 'LineWidth', 2, 'Marker', 'square', 'MarkerSize',50, 'LineStyle', 'none');
    h(2) = plot(NaN,NaN,'r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize',50, 'LineStyle', 'none');
    h(3) = plot(NaN,NaN,'k', 'LineWidth', 2, 'Marker', 'diamond', 'MarkerSize',50, 'LineStyle', 'none');
    legendLabels = {'\color{cyan}Grav', '\color{red}Unkn', '\color{black}Asph'};
    legendLabels = cellfun(@(label) sprintf('\x2005%s', label), legendLabels, 'UniformOutput', false);
    l = legend(h, legendLabels, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';
    % Increase the size of the legend box
    legendPos = l.Position;  % Get the current position of the legend
    legendPos(3) = legendPos(3) * 1.25;  % Increase the width of the legend box
    l.Position = legendPos;  % Set the new position for the legend
    hold off
    ax2 = gca;
    ax2.Clipping = 'off';
    
end

%% End Program

disp('End Program')

