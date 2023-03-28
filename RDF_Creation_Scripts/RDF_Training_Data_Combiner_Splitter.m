%% Clearing Workspace
clear all
close all
clc

disp(':D')

%% Options

% Which ring to grab: 1-9 = '_#.csv', 10+ = '_##.csv'
ring_search_string = '_5.csv';

% Which percent is going to the train array
train_percent = 0.7;

% Which reference point
% RANGE from LiDAR Point of origin
range_bool  = 0;
% Height from RANSAC projected plane
ransac_bool = 1;
% Height from MLS projected plane
mls_bool    = 0;

%% Var Init

asph_data_files = []; gras_data_files = []; grav_data_files = [];
asph_table = table(); gras_table = table(); grav_table = table();

% Time of Run
time_now                = datetime("now","Format","uuuuMMddhhmmss");
time_now                = datestr(time_now,'yyyyMMddhhmmss');

%% Export dir

export_dir = uigetdir('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA', 'Select or create export ROOT directory');
export_dir = export_dir + "/" + string(time_now);

if ~exist(export_dir,'dir')
    mkdir(export_dir)
end

addpath(export_dir)


%% Training Data Directories
% 
% asph_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/CSV_Export/Asph_Feat_Extract';
% gras_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/CSV_Export/Gras_Feat_Extract';
% grav_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/CSV_Export/Grav_Feat_Extract';


asph_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/CSV_Export/RANSAC_Feat_Extract/Asph';
gras_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/CSV_Export/RANSAC_Feat_Extract/Grav';
grav_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/CSV_Export/RANSAC_Feat_Extract/Gras';


%% Load dir

% Set as struct
asph_data_files              = [asph_data_files; dir(fullfile(asph_dir,'/*.csv'))]; 
gras_data_files              = [gras_data_files; dir(fullfile(gras_dir,'/*.csv'))]; 
grav_data_files              = [grav_data_files; dir(fullfile(grav_dir,'/*.csv'))]; 


%% Select all files with same ring

% Set as table for easy searching
asph_cell = struct2cell(asph_data_files);
gras_cell = struct2cell(gras_data_files);
grav_cell = struct2cell(grav_data_files);

% Transposing for ease of viewing
asph_cell = asph_cell';
gras_cell = gras_cell';
grav_cell = grav_cell';

% Search for string in row
asph_match_idx = count(string(asph_cell), ring_search_string);
gras_match_idx = count(string(gras_cell), ring_search_string);
grav_match_idx = count(string(grav_cell), ring_search_string);

% Find index of matching cells
asph_match_idx = find(asph_match_idx(:,1));
gras_match_idx = find(gras_match_idx(:,1));
grav_match_idx = find(grav_match_idx(:,1));


%% Load all csv files into single file

% Asphalt
for asph_idx = 1:length(asph_match_idx)
    
    if range_bool
        data_to_apphend = ring_train_data_csv_import_w_cat(asph_data_files(asph_match_idx(asph_idx)).name);
    elseif ransac_bool
        data_to_apphend = ring_ransac_train_data_csv_import_w_cat(asph_data_files(asph_match_idx(asph_idx)).name);
    elseif mls_bool
%         data_to_apphend = ring_mls_train_data_csv_import_w_cat(asph_data_files(asph_match_idx(asph_idx)).name);
    end
    
    asph_table = [asph_table; data_to_apphend];
    
end

% Grass
for gras_idx = 1:length(gras_match_idx)
    
    if range_bool
        data_to_apphend = ring_train_data_csv_import_w_cat(gras_data_files(gras_match_idx(gras_idx)).name);
    elseif ransac_bool
        data_to_apphend = ring_ransac_train_data_csv_import_w_cat(gras_data_files(gras_match_idx(gras_idx)).name);
    elseif mls_bool
%         data_to_apphend = ring_mls_train_data_csv_import_w_cat(gras_data_files(gras_match_idx(gras_idx)).name);
    end    
    gras_table = [gras_table; data_to_apphend];
    
end

% Gravel
for grav_idx = 1:length(grav_match_idx)
    
    if range_bool
        data_to_apphend = ring_train_data_csv_import_w_cat(grav_data_files(grav_match_idx(grav_idx)).name);
    elseif ransac_bool
        data_to_apphend = ring_ransac_train_data_csv_import_w_cat(grav_data_files(grav_match_idx(grav_idx)).name);
    elseif mls_bool
%         data_to_apphend = ring_mls_train_data_csv_import_w_cat(grav_data_files(grav_match_idx(grav_idx)).name);
    end    
    grav_table = [grav_table; data_to_apphend];
    
end


%% Compile train/test table

% Find number to grab (num samps/terrain type need to be equal)
max_num_to_grab     = min([height(asph_table) height(gras_table) height(grav_table)]);
to_train_tab        = int64(train_percent * max_num_to_grab);

% Get random idx of each table
rand_idx_asph       = randperm(height(asph_table));
rand_idx_gras       = randperm(height(gras_table));
rand_idx_grav       = randperm(height(grav_table));

% Get the training data based off the random idx
asph_train_table    = asph_table(rand_idx_asph(1:to_train_tab), :);
gras_train_table    = gras_table(rand_idx_gras(1:to_train_tab), :);
grav_train_table    = grav_table(rand_idx_grav(1:to_train_tab), :);

% Get the test data based off the random idx 
asph_test_table     = asph_table(rand_idx_asph((to_train_tab+1):max_num_to_grab), :);
gras_test_table     = gras_table(rand_idx_gras((to_train_tab+1):max_num_to_grab), :);
grav_test_table     = grav_table(rand_idx_grav((to_train_tab+1):max_num_to_grab), :);

% Combine the train/test data
TRAIN_ALL_TABLE     = [asph_train_table; gras_train_table; grav_train_table];
TEST_ALL_TABLE      = [asph_test_table; gras_test_table; grav_test_table];


%% Save train/test data

% Filenames
asph_train_fn   = export_dir + "/asph_train"    + string(ring_search_string) + "_" + string(time_now) + ".csv";
gras_train_fn   = export_dir + "/gras_train"    + string(ring_search_string) + "_" + string(time_now) + ".csv";
grav_train_fn   = export_dir + "/grav_train"    + string(ring_search_string) + "_" + string(time_now) + ".csv";

asph_test_fn    = export_dir + "/asph_test"     + string(ring_search_string) + "_" + string(time_now) + ".csv";
gras_test_fn    = export_dir + "/gras_test"     + string(ring_search_string) + "_" + string(time_now) + ".csv";
grav_test_fn    = export_dir + "/grav_test"     + string(ring_search_string) + "_" + string(time_now) + ".csv";

train_all_fn    = export_dir + "/train_all"     + string(ring_search_string) + "_" + string(time_now) + ".csv";
test_all_fn     = export_dir + "/test_all"      + string(ring_search_string) + "_" + string(time_now) + ".csv";

% Save tables
writetable(asph_train_table,asph_train_fn)
writetable(gras_train_table,gras_train_fn)
writetable(grav_train_table,grav_train_fn)

writetable(asph_test_table,asph_test_fn)
writetable(gras_test_table,gras_test_fn)
writetable(grav_test_table,grav_test_fn)

writetable(TRAIN_ALL_TABLE,train_all_fn)
writetable(TEST_ALL_TABLE,test_all_fn)


%% End Program

disp('End Program')




