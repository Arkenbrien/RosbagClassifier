%==========================================================================
%                               Rhett Huston
%
%                      FILE CREATION DATE: 06/20/2022
%
%                    Training Script - TreeBagger function
%
% This program uses the TreeBagger function to create a series of decision
% trees. TreeBagger grows the decision trees in the ensemble using 
% bootstrap samples of the data. Also, TreeBagger selects a random subset 
% of predictors to use at each decision split as in the random forest 
% algorithm.
%
% The program first grabs all the desired training data files in .mat
% format, then creates a huge table out of all the data selected and the
% terrain types. TreeBagger then saves the data as a .mat file.
%
%==========================================================================
close all
clear all
clc

%% OPTIONS

write_table             = 0;

%% Var Init

% Time of Run
time_now                = datetime("now","Format","uuuuMMddhhmmss");
time_now                = datestr(time_now,'yyyyMMddhhmmss');

%% Selecting the export folder

export_dir              = uigetdir('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/DECISION_TREES/Weak_Ov_03_14_2023','Grab Tree Export Directory');
addpath(export_dir)

[~, export_name, ~] = fileparts(export_dir);
default_test_num = export_name(1:7);
default_test_nam = export_name(9:end);

%% Training Setup

prompt                  = {'Min Tree Num', 'Step Size', 'Max Tree Num', 'MaxNumSplits?', 'Test Number?', 'Special Tag?'};
dlgtitle                = 'Tree Creation Setup';
definput                = {'1','5', '301',  '100', default_test_num, default_test_nam};
dims                    = [1 35];
setup_answers           = inputdlg(prompt,dlgtitle,dims,definput);

Min_Num_Trees           = str2double(setup_answers(1));
Step_Size               = str2double(setup_answers(2));
Max_Num_Trees           = str2double(setup_answers(3));
NumSplits               = str2double(setup_answers(4));
test_number             = string(setup_answers(5));
spec_tag                = string(setup_answers(6));

% Creating the array for the number of trees
Tree_Num_Array          = [Min_Num_Trees:Step_Size:Max_Num_Trees];

%% Load Training Data - Indv training sources

% Ask user for file
% gras_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Gras_Feat_Extract/Grav_Feat_Extract_1/*.csv', 'Get GRASS data');
% grav_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Grav_Feat_Extract/Gras_Feat_Extract_1/*.csv', 'Get GRAVEL data');
% asph_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Asph_Feat_Extract/Asph_Feat_Extract_1/*.csv', 'Get ASPHALT data');
% 
% asph_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/asphalt_combined_data_1.csv';
% gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/grass_combined_data_1.csv';
% grav_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/gravel_combined_data_1.csv';
% 
% % Load csv into workspace
% gras_data = ring_train_data_csv_import_w_cat(gras_file);
% grav_data = ring_train_data_csv_import_w_cat(grav_file);
% asph_data = ring_train_data_csv_import_w_cat(asph_file);
% 
% % Find minimum for equal numbers of data per terrain type
% % max_dat_size    =  max([length(gras_array(:,1)) length(grav_array(:,1)) length(asph_array(:,1))]);
% min_dat_size    =  min([height(gras_data) height(grav_data) height(asph_data)]);
% 
% % Re-sample based on minimum number
% gras_data               = gras_data(1:min_dat_size,:);
% grav_data               = grav_data(1:min_dat_size,:);
% asph_data               = asph_data(1:min_dat_size,:);
% 
% % Apphend all the data
% Mdl_Trainer_Table       = [gras_data; grav_data; asph_data];
% terrain_types           = Mdl_Trainer_Table(:,end);
% Mdl_Trainer_Table       = Mdl_Trainer_Table(:,1:end-1);


%% Load Training Data - All-in-one

[train_dat_file, train_dat_path]       = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/*.csv','Grab CSV training data');
% 
import_file = string(train_dat_path) + string(train_dat_file);

Mdl_Trainer_Table       = readtable(import_file);
terrain_types           = Mdl_Trainer_Table(:,end);
Mdl_Trainer_Table       = Mdl_Trainer_Table(:,1:end-1);

% Mdl_Trainer_Table       = getallfeats(Mdl_Trainer_Table);
% Mdl_Trainer_Table       = getzxyfeats(table_extract);
% Mdl_Trainer_Table       = gettoptwentyfeats(table_extract);
% Mdl_Trainer_Table       = getrangefeats(table_extract);


%% How many features to use

def_val_num_feat        = round(sqrt(width(Mdl_Trainer_Table)));

% prompt                  = {'How many features to use? There are ' + string(width(Mdl_Trainer_Table)) + ' features in the training data set. Default value is the sqrt of the number of features: ' + string(def_val_num_feat)};
% dlgtitle                = 'Tree Creation Setup';
% dims                    = [1 35];
% feat_answer           = inputdlg(prompt,dlgtitle,dims);
% 
% Num_Feats               = str2double(feat_answer(1));

Num_Feats = def_val_num_feat;

%% Setting up cost array

% cost_array = ([0 0.75 1.25 1.25; 0.75 0 1.25 1.25; 1 1 0 1; 1 1 1 0]);
% S.ClassNames = ["gravel","chipseal","foliage","grass"];
% S.ClassificationCosts = cost_array;

%% Creating the Trees :D

% Tree_Num_Array = [1:2:300];

tic

parfor_progress(length(Tree_Num_Array));

parfor tree_idx = 1:length(Tree_Num_Array)
    
%     disp('Creating the Trees')

    % Safety for more features to use as predictors than actual features in
    % array

    % Creating the Model
    Mdl                     = TreeBagger(Tree_Num_Array(tree_idx),Mdl_Trainer_Table, ...
                                        terrain_types, ...
                                        "Method", "classification", ...
                                        "MaxNumSplits", NumSplits, ...
                                        "NumPredictorsToSample", Num_Feats, ...
                                        "OOBPredictorImportance", "on", ...
                                        OOBPrediction = "on" ,...
                                        InBagFraction = 0.5);  
    
    %% Saving the files
%     disp('Created, saving file...')

    Filename_Mdl            = export_dir + "/" + string(Tree_Num_Array(tree_idx)) + "_" + string(Num_Feats) + "_" + string(length(Mdl_Trainer_Table.Properties.VariableNames)) + "_" + test_number + spec_tag + "_TreeBagger.mat";

    parsaveMdl(Filename_Mdl, Mdl);

%     disp('File Saved! Name: ')
%     disp(Filename_Mdl)

    parfor_progress;

end

parfor_progress(0)

disp('Completed making RDFs')

toc

%% Saving Data

% disp('Training Table saving...')
% Trainer_Table_Head      = Mdl_Trainer_Table.Properties.VariableNames;
% Filename_Opt            = export_dir + "/" + "_" + test_number + "_Trainer_Table_Head.mat";
% save(Filename_Opt, 'Trainer_Table_Head')
% disp('Training Table saved! Name: ')
% disp(Filename_Opt)

%% End Program

% gong_gong()

disp('Program ended')







