%==========================================================================
%                               Rhett Huston
%
%                      FILE CREATION DATE: 08/03/2022
%
%                    Verification_Scoring_Mega_Program
%
% This program looks at the validation results and makes a bunch of pretty
% plots. Only looks at overall results - does not yet look at individual
% feature results for feature scoring. 
%==========================================================================

clear all; close all; clc;
% How program works:

% Load each folder contents
% Grab: Result 
% Grab: Tree Options
% Create: Plots. To start, just the accuracy to ensure program
% functionality
% Grab the individual folders and export the desired contents to a big ole
% array. Insert function to count stuff? Idk.
% Initiate variables: Overall scores!

%% OPTIONS

% make trend line
move_avg_plt_bool   = 1;

% Close all when done
close_at_end_bool   = 0;

% Save stuff at end
save_plt_bool       = 1;

% Show minimum value
show_min_bool       = 1;

% Min/Max Values for number of trees
x_limit             = [0, 300];

% how many types per road/non-road
num_non_road_types = 1;
num_road_types = 2;
 
%% Var Init

% Score Arrays Init
opt_array               = [];
overall_err_array       = [];
grav_err_array          = [];
asph_err_array          = [];
gras_err_array          = [];
overall_false_pos_array = [];
overall_false_neg_array = [];
asph_false_neg_array    = [];
grav_false_neg_array    = [];
gras_false_pos_array    = [];

% Size of figures
fig_size_array          = [10 10 3500 1600];

% Minimum change in error before determining early stopping point
min_err_val             = .30;

% Minimum percent to minimum error
within_spec_val         = 0.10;

% Moving Average Distance
move_avg_dist           = 15;

%% Grabs the folder with the results

% Grabs the folder
results_folder = uigetdir('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/RDFs/', 'Grab results folder');
% results_folder = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/DECISION_TREES/Week_Ov_01_28_2023/Test_03_All_1000D_Results';

% Puts folder names in a list
results_files = [dir(fullfile(results_folder,'/*.mat'))];

% Filenames
[results_filepath, results_name, ~] = fileparts(results_folder);
% 
% Size of test database
load(results_files(1).name)
size_tester_table       = RDF_RESULTS.Test_Size ;
num_terrain = size_tester_table(1) / 3;


%% Grab training error

rdf_folder_start = results_name(1:end-8);
rdf_folder_start = string(results_filepath) + '/' + rdf_folder_start;

rdf_origins  = [dir(fullfile(rdf_folder_start,'/*.mat'))];

% Sorting by creation time (largest is always created last)
[~,index] = sortrows([rdf_origins.bytes].'); 
rdf_origins = rdf_origins(index(end:-1:1)); 
clear index

load(rdf_origins(1).name)

training_error = oobError(Mdl) * 100;


%% Loops through each item in list and does stuff

disp('Loading Stuff')

len_res_files = length(results_files);

file_bar = waitbar(0, sprintf('File %d out of %d', 0, len_res_files));

for file_idx = 1:len_res_files
        
    if  strfind(results_files(file_idx).name,'RDF_RESULT') > 0
        
        load(results_files(file_idx).name)
        
        %% Getting overall result table
        RDF_CONF_MAT = RDF_RESULTS.conf_mat;
        RDF_CONF_MAT = RDF_CONF_MAT.NormalizedValues;
        
%             {'asphalt'}   1,1
%             {'grass'}     2,2
%             {'gravel'}    3,3
        
        %% Getting the error 
        
        overall_err_array       = [overall_err_array; (RDF_RESULTS.NumTrees) (1 - RDF_RESULTS.Overall_Acc)];
        grav_err_array          = [grav_err_array; (RDF_RESULTS.NumTrees) (1 - RDF_CONF_MAT(3,3) / num_terrain)];
        asph_err_array          = [asph_err_array; (RDF_RESULTS.NumTrees) (1 - RDF_CONF_MAT(1,1) / num_terrain)];
        gras_err_array          = [gras_err_array; (RDF_RESULTS.NumTrees) (1 - RDF_CONF_MAT(2,2) / num_terrain)];
        
        
        %% False positive / negative calc
        
        % overall stuff
        overall_false_pos_val   = (RDF_CONF_MAT(1,2) + RDF_CONF_MAT(3,2) / (num_terrain * num_non_road_types));
        overall_false_neg_val   = (RDF_CONF_MAT(2,1) + RDF_CONF_MAT(2,3) / (num_terrain * num_road_types));
        
        overall_false_pos_array = [overall_false_pos_array; (RDF_RESULTS.NumTrees) overall_false_pos_val]; 
        overall_false_neg_array = [overall_false_neg_array; (RDF_RESULTS.NumTrees) overall_false_neg_val];
        
        % individual stuff
        asph_false_neg_array    = [asph_false_neg_array; (RDF_RESULTS.NumTrees) (RDF_CONF_MAT(2,1) / (num_terrain))];
        grav_false_neg_array    = [grav_false_neg_array; (RDF_RESULTS.NumTrees) (RDF_CONF_MAT(2,3) / (num_terrain))];
        gras_false_pos_array    = [gras_false_pos_array; (RDF_RESULTS.NumTrees) (RDF_CONF_MAT(1,2) + RDF_CONF_MAT(3,2) / (num_terrain))];   
        
        %% Timing Data
        
        
        
    end
    
    clear Mdl_Options RDF_RESULTS
    
    waitbar(file_idx/len_res_files, file_bar, sprintf('File %d out of %d', file_idx, len_res_files))
    
end

close(file_bar)

disp('Stuff Loaded')

%% Sorting the stuff

disp('Sorting Stuff')

overall_err_array       = sortrows(overall_err_array, 1);
grav_err_array          = sortrows(grav_err_array, 1);
asph_err_array          = sortrows(asph_err_array, 1);
gras_err_array          = sortrows(gras_err_array, 1);

overall_false_pos_array = sortrows(overall_false_pos_array, 1);
overall_false_neg_array = sortrows(overall_false_neg_array, 1);

gras_false_pos_array    = sortrows(gras_false_pos_array, 1);
asph_false_neg_array    = sortrows(asph_false_neg_array, 1);
grav_false_neg_array    = sortrows(grav_false_neg_array, 1);

%% Fixing the Mafs

disp('Fixing Math as needed')

overall_err_array(:,2)  = overall_err_array(:,2) * 100;
grav_err_array(:,2)     = (grav_err_array(:,2)) * 100;
asph_err_array(:,2)     = (asph_err_array(:,2)) * 100; 
gras_err_array(:,2)     = (gras_err_array(:,2)) * 100; 
% overall_false_pos_array = overall_false_pos_array * 100; 
% overall_false_neg_array = overall_false_neg_array * 100; 
% gras_false_pos_array    = gras_false_pos_array * 100; 
asph_false_neg_array(:,2)    = asph_false_neg_array(:,2) * 100; 
grav_false_neg_array(:,2)    = grav_false_neg_array(:,2) * 100; 

%% Moving Averages

disp('Calculating Moving Averages')

mv_avg_overall_err_array        = movmean(overall_err_array(:,2), move_avg_dist);
mv_avg_grav_err_array           = movmean(grav_err_array(:,2), move_avg_dist);
mv_avg_asph_err_array           = movmean(asph_err_array(:,2), move_avg_dist);
mv_avg_gras_err_array           = movmean(gras_err_array(:,2), move_avg_dist);
mv_avg_overall_false_pos_array  = movmean(overall_false_pos_array(:,2), move_avg_dist);
mv_avg_overall_false_neg_array  = movmean(overall_false_neg_array(:,2), move_avg_dist);
mv_avg_gras_false_pos_array     = movmean(gras_false_pos_array(:,2), move_avg_dist);
mv_avg_asph_false_neg_array     = movmean(asph_false_neg_array(:,2), move_avg_dist);
mv_avg_grav_false_neg_array     = movmean(grav_false_neg_array(:,2), move_avg_dist);

%% Okay now we can plot the overall error results

disp('Plotting Error Results')

close all

%% Error Subplot

% tiled layout FTW lol, way better than subplot
tile_plt_err = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
t = tiledlayout(2,4);

    % Grav
    nexttile
        plot(grav_err_array(:,1), grav_err_array(:,2),'b', 'LineWidth', 3)
        title('Gravel');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool
        
            hold on
            plot(grav_err_array(:,1), mv_avg_grav_err_array,'r', 'LineWidth', 1.5)
            hold off
        
        end
        
        if show_min_bool

            [min_val, idx]  = min(grav_err_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(grav_err_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
        
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)
    
    % Asph
    nexttile
        plot(asph_err_array(:,1), asph_err_array(:,2),'b', 'LineWidth', 3)
        title('Asphalt');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool

            hold on
            plot(asph_err_array(:,1), mv_avg_asph_err_array,'r', 'LineWidth', 1.5)
            hold off

        end
        
        if show_min_bool

            [min_val, idx]  = min(asph_err_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(asph_err_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
        
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)
        
        
    % Grass
    nexttile(5,[1,2])
        plot(gras_err_array(:,1), gras_err_array(:,2),'b', 'LineWidth', 3)
        title('Grass');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool
        
            hold on
            plot(gras_err_array(:,1), mv_avg_gras_err_array,'r', 'LineWidth', 1.5)
            hold off
        
        end
        
        if show_min_bool

            [min_val, idx]  = min(gras_err_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(gras_err_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
        
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)
    
    % Overall
    nexttile(3,[2 2]);
        plot(overall_err_array(:,1), overall_err_array(:,2),'b', 'LineWidth', 3)
        title('Overall');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool
        
            hold on
            plot(overall_err_array(:,1), mv_avg_overall_err_array,'r', 'LineWidth', 1.5)
            hold off
        
        end
        
        if show_min_bool

            [min_val, idx]  = min(overall_err_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(overall_err_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
        
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)

t.TileSpacing = 'compact';
t.Padding = 'compact';

%% False Pos/Neg Subplot

disp('Plotting Pos/Neg')

tile_plt_false = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
t = tiledlayout(2,4);
        
    % Grav
    nexttile
        plot(grav_false_neg_array(:,1), grav_false_neg_array(:,2),'b', 'LineWidth', 3)
        title('Gravel');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool
        
            hold on
            plot(grav_false_neg_array(:,1), mv_avg_grav_false_neg_array,'r', 'LineWidth', 1.5)
            hold off
        
        end
        
        if show_min_bool

            [min_val, idx]  = min(grav_false_neg_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(grav_false_neg_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
        
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)
        
    % asph
    nexttile
        plot(asph_false_neg_array(:,1), asph_false_neg_array(:,2),'b', 'LineWidth', 3)
        title('Asphalt');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool

            hold on
            plot(asph_false_neg_array(:,1), mv_avg_asph_false_neg_array,'r', 'LineWidth', 1.5)
            hold off
        
        end
        
        if show_min_bool

            [min_val, idx]  = min(asph_false_neg_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(asph_false_neg_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
        
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)
        
    % Grass
    nexttile(5,[1,2])
        plot(gras_false_pos_array(:,1), gras_false_pos_array(:,2),'b', 'LineWidth', 3)
        title('Grass');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool

            hold on
            plot(gras_false_pos_array(:,1), mv_avg_gras_false_pos_array,'r', 'LineWidth', 1.5)
            hold off

        end
        
        if show_min_bool

            [min_val, idx]  = min(gras_false_pos_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(gras_false_pos_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
        
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)
        
    % Overall neg
    nexttile(3,[1 2]);
        plot(overall_false_neg_array(:,1), overall_false_neg_array(:,2),'b', 'LineWidth', 3)
        title('Overall False Neg');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool

            hold on
            plot(overall_false_neg_array(:,1), mv_avg_overall_false_neg_array,'r', 'LineWidth', 1.5)
            hold off

        end
        
        if show_min_bool

            [min_val, idx]  = min(overall_false_neg_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(overall_false_neg_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
        
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)
        
    % Overall pos
    nexttile(7,[1 2]);
        plot(overall_false_pos_array(:,1), overall_false_pos_array(:,2),'b', 'LineWidth', 3)
        title('Overall False Pos');
        xlabel('Num Trees')
        ylabel('Error %')
        
        if move_avg_plt_bool

            hold on
            plot(overall_false_pos_array(:,1), mv_avg_overall_false_pos_array,'r', 'LineWidth', 1.5)
            hold off

        end
        
        if show_min_bool

            [min_val, idx]  = min(overall_false_pos_array(:,2));
            txt             = '\leftarrow ' + string(min_val);
%             text(overall_false_pos_array(idx,1), min_val, txt,'FontSize',14,'FontWeight','bold')

        end
    
        grid on
        
        legend(sprintf('Error %% (Min: %0.1f)', min_val), 'Moving Avg', 'Location', 'best')
        xlim(x_limit)

t.TileSpacing = 'compact';
t.Padding = 'compact';

hold off

%% Train vs Test (validation) Error

disp('Plotting Training vs Testing Error')

tt_err_plot2 = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);

hold all

plot((1:1:length(training_error)), training_error, 'k', 'LineWidth', 3)
% plot(overall_err_array(:,1), mv_avg_overall_err_array,'r', 'LineWidth', 3)
plot(overall_err_array(:,1), overall_err_array(:,2),'r', 'LineWidth', 3)

legend({'Training Error', 'Validation Error'}, 'FontSize', 48)
xlim(x_limit)
xlabel('Number of Trees')
ylabel('Error (%)')
grid on
hold off

%% Early Stoping Earliest Settling Point

disp('Plotting Early Stoping Point')

[min_val, idx]  = min(overall_err_array(:,2));

for err_idx = 2:1:length(overall_err_array)
    
    diff = abs(mv_avg_overall_err_array(err_idx) - mv_avg_overall_err_array(err_idx-1));
    avg  = (mv_avg_overall_err_array(err_idx) + mv_avg_overall_err_array(err_idx-1)) / 2;
    
    % Calculate percent difference
    percent_diff(err_idx-1) = diff / avg * 100;
    
end

% Finding where percent_diff < 0.01
min_err_val = .275;

% Where within X % of minimum error
percent_diff_to_min_err = 10.0;

% sub_error_instance = percent_diff < min_err_val;
min_err_val_found_idx = find(percent_diff < min_err_val);

%% Plotting Early Stoping Earliest Settling Point

try

    err_plot = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);

    hold all

    % plot(overall_err_array(:,1), overall_err_array(:,2),'k', 'LineWidth', 3)

    % Vertical Line
    x_vert_coords = [overall_err_array(min_err_val_found_idx(1),1), overall_err_array(min_err_val_found_idx(1),1)];
    y_vert_coords = [0 max(overall_err_array(:,2))+1];
    plot(x_vert_coords, y_vert_coords, '--r', 'LineWidth', 3)

    % Horizontal Line
    x_horz_coords = [0 max(overall_err_array(:,1))];
    y_horz_coords = [mv_avg_overall_err_array(min_err_val_found_idx(1)) mv_avg_overall_err_array(min_err_val_found_idx(1))];
    plot(x_horz_coords, y_horz_coords, '--g', 'LineWidth', 3)

    % Moving Avg
    plot(overall_err_array(:,1), mv_avg_overall_err_array,'r', 'LineWidth', 1.5)

    % Percent Diff
    % plot(overall_err_array(2:end,1), percent_diff*100, 'm')

    xlabel('Num Trees')
    ylabel('Error %')
    ylim([(min(overall_err_array(:,2)) - 1) (max(overall_err_array(:,2)) + 1)])
    grid on
    ylim([min(mv_avg_overall_err_array) - 1, max(mv_avg_overall_err_array) + 1])
    legend(sprintf('Early Stopping Point: %i Trees', overall_err_array(min_err_val_found_idx(1),1)),...
        sprintf('Error @ Stop Point: %1.2f%% (Min: %0.1f)', mv_avg_overall_err_array(min_err_val_found_idx(1)), min_val),...
        'Moving Avg')
    xlim(x_limit)
    
    hold off

    saveas(err_plot, string(results_folder) + '/early_stopping.png', 'png');
    
    Score_Results.early_stopping_tree       = overall_err_array(min_err_val_found_idx(1),1);
    Score_Results.early_stopping_error      = mv_avg_overall_err_array(min_err_val_found_idx(1));
    
catch
    
    disp('ERROR - DOES NOT SETTLE')
    
end


%% Plotting Early Stoping 2nd Earliest Settling Point

try

    err_plot_2 = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);

    hold all

    % plot(overall_err_array(:,1), overall_err_array(:,2),'k', 'LineWidth', 3)

    % Vertical Line
    x_vert_coords = [overall_err_array(min_err_val_found_idx(4),1), overall_err_array(min_err_val_found_idx(4),1)];
    y_vert_coords = [0 max(overall_err_array(:,2))+1];
    plot(x_vert_coords, y_vert_coords, '--r', 'LineWidth', 3)

    % Horizontal Line
    x_horz_coords = [0 max(overall_err_array(:,1))];
    y_horz_coords = [mv_avg_overall_err_array(min_err_val_found_idx(4)) mv_avg_overall_err_array(min_err_val_found_idx(4))];
    plot(x_horz_coords, y_horz_coords, '--g', 'LineWidth', 3)

    % Moving Avg
    plot(overall_err_array(:,1), mv_avg_overall_err_array,'r', 'LineWidth', 1.5)

    % Percent Diff
    % plot(overall_err_array(2:end,1), percent_diff*100, 'm')

    xlabel('Num Trees')
    ylabel('Error %')
    ylim([(min(overall_err_array(:,2)) - 1) (max(overall_err_array(:,2)) + 1)])
    grid on
    ylim([min(mv_avg_overall_err_array) - 1, max(mv_avg_overall_err_array) + 1])
    legend(sprintf('Early Stopping Point: %i Trees', overall_err_array(min_err_val_found_idx(4),1)),...
        sprintf('Error @ Stop Point: %1.2f%% (Min: %0.1f)', mv_avg_overall_err_array(min_err_val_found_idx(4)), min_val),...
        'Moving Avg')
    xlim(x_limit)
    
    hold off

    saveas(err_plot_2, string(results_folder) + '/second_early_stopping.png', 'png');
    
    Score_Results.second_early_stopping_tree       = overall_err_array(min_err_val_found_idx(4),1);
    Score_Results.second_early_stopping_error      = mv_avg_overall_err_array(min_err_val_found_idx(4));
    
catch
    
    disp('ERROR - DOES NOT SETTLE')
    
end


%% Early Stop If Within X% of minimum mv_avg_overall_err_array

disp('Plotting Early Stoping Point within x% of minimum mv_avg')

% What if the early stopping was within X% of the minimum mv_avg?

% Initilizing the array
test_err(:,1)           = [mv_avg_overall_err_array];

% Finding the minimum value
[min_val, min_idx]          = min(mv_avg_overall_err_array);
[max_val, max_idx]          = max(mv_avg_overall_err_array);

% Calculating the fudge value
min_val_fudge           = 0.1 * (max_val - min_val);

% Calculating the minimum value to determine the early stoppin condition
min_accept_val          = min_val + min_val_fudge;

% Calculate percent difference between points in the array and fudged
% minimum value.
mv_avg_diff_to_min      = (abs(test_err(:,1) - min_accept_val)) ./ ((test_err(:,1) + min_accept_val) / 2) * 100;

% Checks to see if the difference is a desired percentage from the fudged
% minimum value.
within_spec_bool        = abs(mv_avg_diff_to_min) < within_spec_val;

percent_diff(1)         = 0;

for err_idx = 2:1:length(overall_err_array)
    
    diff = abs(mv_avg_overall_err_array(err_idx) - mv_avg_overall_err_array(err_idx-1));
    avg  = (mv_avg_overall_err_array(err_idx) + mv_avg_overall_err_array(err_idx-1)) / 2;
    
    % Calculate percent difference
    percent_diff(err_idx) = diff / avg * 100;
    
end

test_err(:,2)           = within_spec_bool';

test_err(:,3)           = percent_diff';

test_err(:,4)           = mv_avg_diff_to_min;

min_err_val_found_idx_test = find(test_err(:,3) < min_err_val & test_err(:,2) == 1, 1);

%% Plotting Early Stop If Within X% of minimum mv_avg_overall_err_array 

try
    
    err_plot_exp = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);

    hold all

    % Vertical Line
    x_vert_coords = [overall_err_array(min_err_val_found_idx_test,1), overall_err_array(min_err_val_found_idx_test,1)];
    y_vert_coords = [0 max(overall_err_array(:,2))+1];
    plot(x_vert_coords, y_vert_coords, '--r', 'LineWidth', 3)

    % Horizontal Line
    x_horz_coords = [0 max(overall_err_array(:,1))];
    y_horz_coords = [mv_avg_overall_err_array(min_err_val_found_idx_test) mv_avg_overall_err_array(min_err_val_found_idx_test)];
    plot(x_horz_coords, y_horz_coords, '--g', 'LineWidth', 3)

    % Moving Avg
    plot(overall_err_array(:,1), mv_avg_overall_err_array,'r', 'LineWidth', 1.5)

    % Formatting
    xlabel('Num Trees')
    ylabel('Error %')
    ylim([(min(overall_err_array(:,2)) - 1) (max(overall_err_array(:,2)) + 1)])
    grid on
    ylim([min(mv_avg_overall_err_array) - 1, max(mv_avg_overall_err_array) + 1])
    legend(sprintf('Early Stopping Point: %i Trees', overall_err_array(min_err_val_found_idx_test,1)),...
        sprintf('Error @ Stop Point: %1.2f%% (Min: %0.1f)', mv_avg_overall_err_array(min_err_val_found_idx_test), min_val),...
        'Moving Avg')
    xlim(x_limit)
    
    % Save Figure
    saveas(err_plot_exp, string(results_folder) + '/early_stopping_exp.png', 'png');
        
    Score_Results.early_stopping_min_tree   = overall_err_array(min_err_val_found_idx_test,1);
    Score_Results.early_stopping_min_error  = mv_avg_overall_err_array(min_err_val_found_idx_test(1));
    
    hold off
    
catch
    
    disp('ERROR - DOES NOT CONVERGE OR CONVERGES IN FIRST CONVERGENCE TEST METHOD!')
    delete(err_plot_exp)
    
end

%% Saving (some of) the plots
% early stopping save in their sections because at some points they may not
% converge or settle so the plots are not generated.

disp('Saving Plots')

if save_plt_bool


    try

        saveas(overall_plt, string(results_folder) + '/overall_plt.png', 'png');
        saveas(chip_plt, string(results_folder) + '/asph_plt.png', 'png');
        saveas(gras_plt, string(results_folder) + '/gras_plt.png', 'png');
        saveas(foli_plt, string(results_folder) + '/foli_plt.png', 'png');
        saveas(grav_plt, string(results_folder) + '/grav_plt.png', 'png');
        saveas(overall_false_pos_plt, string(results_folder) + '/overall_false_pos_plt.png', 'png');
        saveas(overall_false_neg_plt, string(results_folder) + '/overall_false_neg_plt.png', 'png');
        saveas(gras_false_pos_plt, string(results_folder) + '/gras_false_pos_plt.png', 'png');
        saveas(foli_false_pos_plt, string(results_folder) + '/foli_false_pos_plt.png', 'png');
        saveas(chip_false_neg_plt, string(results_folder) + '/asph_false_neg_array.png', 'png');
        saveas(grav_false_neg_plt, string(results_folder) + '/grav_false_neg_array.png', 'png');
        saveas(tt_err_plot, string(results_folder) + '/training_vs_verification_err.png', 'png');

    catch

        disp('ERROR - MISSING PLOTERINOS')


    end

    try
        
        saveas(tile_plt_err, string(results_folder) + '/err_sub_plot.png', 'png');
        saveas(tile_plt_false, string(results_folder) + '/false_pos_neg_sub_plot.png', 'png');
        
    catch
        
        disp('ERROR - MISSING PLOTERINOS')
        
    end
    
end

%% Save the Results as .mat file for easy comparison later

disp('Exporting results to results folder')

export_dir = string(results_filepath) + '/Results_Folder';

if not(isfolder(export_dir))
    mkdir(export_dir)
end

addpath(export_dir)

% Struct Maker
Score_Results.overall_err_array					= overall_err_array;
Score_Results.grav_err_array          			= grav_err_array;
Score_Results.asph_err_array          			= asph_err_array;
Score_Results.gras_err_array          			= gras_err_array;
Score_Results.overall_false_pos_array			= overall_false_pos_array;
Score_Results.overall_false_neg_array			= overall_false_neg_array;
Score_Results.gras_false_pos_array    			= gras_false_pos_array;
Score_Results.asph_false_neg_array    			= asph_false_neg_array;
Score_Results.grav_false_neg_array    			= grav_false_neg_array;
Score_Results.mv_avg_overall_err_array        	= mv_avg_overall_err_array;
Score_Results.mv_avg_grav_err_array           	= mv_avg_grav_err_array;
Score_Results.mv_avg_asph_err_array           	= mv_avg_asph_err_array;
Score_Results.mv_avg_gras_err_array           	= mv_avg_gras_err_array;
Score_Results.mv_avg_overall_false_pos_array  	= mv_avg_overall_false_pos_array;
Score_Results.mv_avg_overall_false_neg_array  	= mv_avg_overall_false_neg_array;
Score_Results.mv_avg_gras_false_pos_array     	= mv_avg_gras_false_pos_array;
Score_Results.mv_avg_asph_false_neg_array     	= mv_avg_asph_false_neg_array;
Score_Results.mv_avg_grav_false_neg_array     	= mv_avg_grav_false_neg_array;
Score_Results.training_error                    = training_error;

Filename = export_dir + '/' + string(results_name) + '_Score_Results.mat';

save(Filename, 'Score_Results')

%% Cleanup

if close_at_end_bool
    
    close all
    
end

disp('End Program!')
