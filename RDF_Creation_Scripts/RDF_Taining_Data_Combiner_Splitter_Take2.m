%==========================================================================
%                               Rhett Huston
%
%                     FILE CREATION DATE: 04/04/2023
%
%                 RDF_Training_Data_Combiner_Splitter.m
%
% This grabs all the channel-specific training data
%
%==========================================================================

%% Clearing Workspace

clear all
close all
clc

disp('>:[')


%% Options

% Which ring to grab: 1-9 = '_#.csv', 10+ = '_##.csv'
ring_search     = 5;

% Which percent is going to the training array
train_percent   = 0.7;

% Which reference point
% RANGE from LiDAR Point of origin
range_bool      = 1;
% Height from RANSAC projected plane
ransac_bool     = 0;
% Height from MLS projected plane
mls_bool        = 0;

side_select = "l"; % "c", "l"


%% Var Init

asph_data_files = []; gras_data_files = []; grav_data_files = []; foli_data_files = []; asph_2_data_files = [];
asph_table = table(); gras_table = table(); grav_table = table(); foli_table = table(); asph_2_table = table();
grav_rm_data_files = []; grav_rm_table = table();

% Time of Run
time_now                = datetime("now","Format","uuuuMMddhhmmss");
time_now                = datestr(time_now,'yyyyMMddhhmmss');

% Which ring to grab search string
ring_search_string = string(ring_search) + "_" + string(side_select);

asph_ring_search_string = string(ring_search) + "_c";
% Tag
tag = '';


%% Select tags

disp('Select Tags')
dlg_list                            = {'Grav', 'Asph', 'Asph2', 'Gras', 'Foli', 'Chip'};
[indx_dlg_list,~]                   = listdlg('ListString', dlg_list,'SelectionMode','multiple');

for tag_list_idx = 1:length(indx_dlg_list)
    
    tag = tag + "_" + string + string(dlg_list(indx_dlg_list(tag_list_idx)));
    
end


%% Export dir

export_dir = uigetdir('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export', 'Select or create export ROOT directory');
export_dir = export_dir + "/chan_" + string(side_select) + "_" + string(ring_search) + string(tag);

if ~exist(export_dir,'dir')
    mkdir(export_dir)
end

addpath(export_dir)


%% Training Data Directories

% Range - Asphalt 1 (not blackburn road)
% asph_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Asphalt';
% gras_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Grass';
% grav_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Gravel';

% Chan_2
% asph_2_dir_1 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export/combined_asphalt';
asph_dir_1 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm/asphalt';
grav_dir_1 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm/gravel_l';
gras_dir_1 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm/grass_l';
% grav_dir_2 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm/gravel';

% asph_dir_2 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export/asphalt_2_2023-03-29-14-55-44';
% grav_dir_2 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export/gravel_2023-03-14-13-12-31';

% asph_dir_3 = '';
% grav_dir_3 = '';
% 
% asph_dir_4 = '';
% grav_dir_4 = '';


%% Load dir

% Set as struct
% asph_2_data_files   = [asph_2_data_files; dir(fullfile(asph_2_dir_1,'/*.csv'))]; 
asph_data_files     =  [asph_data_files; dir(fullfile(asph_dir_1,'/*.csv'))]; 
gras_data_files     = [gras_data_files; dir(fullfile(gras_dir_1,'/*.csv'))]; 
grav_data_files     = [grav_data_files; dir(fullfile(grav_dir_1,'/*.csv'))]; 
% foli_data_files     = [foli_data_files; dir(fullfile(grav_dir_1,'/*.csv'))];
% grav_rm_data_files = [grav_rm_data_files; dir(fullfile(grav_dir_2,'/*.csv'))];


%% Select all files with same ring

% Set as table for easy searching
% asph_2_cell = struct2cell(asph_2_data_files);
asph_cell = struct2cell(asph_data_files);
gras_cell = struct2cell(gras_data_files);
grav_cell = struct2cell(grav_data_files);
% foli_cell = struct2cell(foli_data_files);
% grav_rm_cell = struct2cell(grav_rm_data_files);

% Transposing for ease of viewing
% asph_2_cell = asph_2_cell';
asph_cell = asph_cell';
gras_cell = gras_cell';
grav_cell = grav_cell';
% foli_cell = foli_cell';
% grav_rm_cell = grav_rm_cell';

% Search for string in row
% asph_2_match_idx = count(string(asph_2_cell), ring_search_string);
asph_match_idx = count(string(asph_cell), asph_ring_search_string);
gras_match_idx = count(string(gras_cell), ring_search_string);
grav_match_idx = count(string(grav_cell), ring_search_string);
% foli_match_idx = count(string(foli_cell), ring_search_string);
% grav_rm_match_idx = count(string(grav_rm_cell), ring_search_string);


% Find index of matching cells
asph_match_idx = find(asph_match_idx(:,1));
% asph_2_match_idx = find(asph_2_match_idx(:,1));
gras_match_idx = find(gras_match_idx(:,1));
grav_match_idx = find(grav_match_idx(:,1));
% foli_match_idx = find(foli_match_idx(:,1));
% grav_rm_match_idx = find(grav_rm_match_idx(:,1));


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

% % Asphalt 2
% for asph_2_idx = 1:length(asph_2_match_idx)
%     
%     if range_bool
%         data_to_apphend = ring_train_data_csv_import_w_cat(asph_2_data_files(asph_2_match_idx(asph_2_idx)).name);
%     elseif ransac_bool
%         data_to_apphend = ring_ransac_train_data_csv_import_w_cat(asph_2_data_files(asph_2_match_idx(asph_2_idx)).name);
%     elseif mls_bool
% %         data_to_apphend = ring_mls_train_data_csv_import_w_cat(asph_data_files(asph_match_idx(asph_idx)).name);
%     end
%     
%     asph_2_table = [asph_2_table; data_to_apphend];
%     
% end

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

% % Foliage
% for foli_idx = 1:length(foli_match_idx)
%     
%     if range_bool
%         data_to_apphend = ring_train_data_csv_import_w_cat(foli_data_files(foli_match_idx(foli_idx)).name);
%     elseif ransac_bool
%         data_to_apphend = ring_ransac_train_data_csv_import_w_cat(foli_data_files(foli_match_idx(foli_idx)).name);
%     elseif mls_bool
% %         data_to_apphend = ring_mls_train_data_csv_import_w_cat(foli_data_files(foli_match_idx(foli_idx)).name);
%     end    
%     foli_table = [foli_table; data_to_apphend];
%     
% end

% Gravel
% for grav_rm_idx = 1:length(grav_rm_match_idx)
%     
%     if range_bool
%         data_to_apphend = ring_train_data_csv_import_w_cat(grav_rm_data_files(grav_rm_match_idx(grav_rm_idx)).name);
%     elseif ransac_bool
%         data_to_apphend = ring_ransac_train_data_csv_import_w_cat(grav_rm_data_files(grav_rm_match_idx(grav_rm_idx)).name);
%     elseif mls_bool
% %         data_to_apphend = ring_mls_train_data_csv_import_w_cat(grav_data_files(grav_match_idx(grav_idx)).name);
%     end    
%     grav_rm_table = [grav_rm_table; data_to_apphend];
%     
% end

%% Compile train/test table

% Find number to grab (num samps/terrain type need to be equal)
max_num_to_grab     = min([height(asph_table) height(gras_table) height(grav_table)]);
% max_num_to_grab     = min([height(asph_table) height(grav_table)]);
% max_num_to_grab     = min([height(asph_2_table) height(grav_table)]);
% max_num_to_grab     = min([height(asph_2_table) height(grav_table) height(grav_rm_table)]);

to_train_tab        = int64(train_percent * max_num_to_grab);

% Get random idx of each table
rand_idx_asph       = randperm(height(asph_table));
% rand_idx_asph       = randperm(height(asph_2_table));
rand_idx_gras       = randperm(height(gras_table));
rand_idx_grav       = randperm(height(grav_table));
% rand_idx_foli       = randperm(height(foli_table));
rand_idx_grav_rm    = randperm(height(grav_rm_table));

% Get the training data based off the random idx
asph_train_table    = asph_table(rand_idx_asph(1:to_train_tab), :);
% asph_2_train_table  = asph_2_table(rand_idx_asph(1:to_train_tab), :);
gras_train_table    = gras_table(rand_idx_gras(1:to_train_tab), :);
grav_train_table    = grav_table(rand_idx_grav(1:to_train_tab), :);
% foli_train_table    = foli_table(rand_idx_foli(1:to_train_tab), :);
% grav_rm_train_table    = grav_rm_table(rand_idx_grav_rm(1:to_train_tab), :);


% Get the test data based off the random idx 
asph_test_table     = asph_table(rand_idx_asph((to_train_tab+1):max_num_to_grab), :);
% asph_2_test_table   = asph_2_table(rand_idx_asph((to_train_tab+1):max_num_to_grab), :);
gras_test_table     = gras_table(rand_idx_gras((to_train_tab+1):max_num_to_grab), :);
grav_test_table     = grav_table(rand_idx_grav((to_train_tab+1):max_num_to_grab), :);
% foli_test_table     = foli_table(rand_idx_foli((to_train_tab+1):max_num_to_grab), :);
% grav_rm_test_table     = grav_rm_table(rand_idx_grav_rm((to_train_tab+1):max_num_to_grab), :);


% Combine the train/test data
TRAIN_ALL_TABLE     = [asph_train_table; gras_train_table; grav_train_table];
TEST_ALL_TABLE      = [asph_test_table; gras_test_table; grav_test_table];
% TRAIN_ALL_TABLE     = [asph_train_table;    grav_train_table];
% TEST_ALL_TABLE      = [asph_test_table;     grav_test_table];
% TRAIN_ALL_TABLE     = [asph_2_train_table;    grav_train_table];
% TEST_ALL_TABLE      = [asph_2_test_table;     grav_test_table];
% TRAIN_ALL_TABLE     = [asph_2_train_table;    grav_train_table;      grav_rm_train_table];
% TEST_ALL_TABLE      = [asph_2_test_table;     grav_test_table;       grav_rm_test_table];


%% Save train/test data

% Filenames
asph_train_fn   = export_dir + "/asph_train_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
% asph_2_train_fn   = export_dir + "/asph_2_train_chan"   + string(ring_search) + ".csv";
gras_train_fn   = export_dir + "/gras_train_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
grav_train_fn   = export_dir + "/grav_train_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
% foli_train_fn   = export_dir + "/foli_train_chan"   + string(ring_search) + ".csv";
% grav_rm_train_fn  = export_dir + "/grav_rm_train_chan"   + string(ring_search) + ".csv";

asph_test_fn    = export_dir + "/asph_test_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
% asph_2_test_fn    = export_dir + "/asph_2_test_chan"    + string(ring_search) + ".csv";
gras_test_fn    = export_dir + "/gras_test_chan_"   + string(side_select) + "_" + string(ring_search) + "_" + ".csv";
grav_test_fn    = export_dir + "/grav_test_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
% foli_test_fn    = export_dir + "/foli_test_chan"    + string(ring_search) + ".csv";
% grav_rm_test_fn    = export_dir + "/grav_rm_test_chan"    + string(ring_search) + ".csv";

train_all_fn    = export_dir + "/train_all_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
test_all_fn     = export_dir + "/test_all_chan_"   + string(side_select) + "_" + string(ring_search) +".csv";

% Save tables
writetable(asph_train_table,asph_train_fn)
% writetable(asph_2_train_table,asph_2_train_fn)
writetable(gras_train_table,gras_train_fn)
writetable(grav_train_table,grav_train_fn)
% writetable(foli_train_table,foli_train_fn)
% writetable(grav_rm_train_table,grav_rm_train_fn)

writetable(asph_test_table,asph_test_fn)
% writetable(asph_2_test_table,asph_2_test_fn)
writetable(gras_test_table,gras_test_fn)
writetable(grav_test_table,grav_test_fn)
% writetable(foli_test_table,foli_test_fn)
% writetable(grav_rm_test_table,grav_rm_test_fn)

writetable(TRAIN_ALL_TABLE,train_all_fn)
writetable(TEST_ALL_TABLE,test_all_fn)


%% End Program

disp('End Program')



