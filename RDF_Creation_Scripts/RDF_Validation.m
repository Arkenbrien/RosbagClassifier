%==========================================================================
%                               Rhett Huston
%
%                      FILE CREATION DATE: 08/03/2022
%
%                     Random Forest Evaluation Program
%
% This program takes a random forest model created using MATLAB's
% TreeBagger function and evaluates it against a validation data set.
% Results are exported and plotted.
%==========================================================================

clear all; close all; clc;

%% Options

% Look at each tree for feature counting and scoring - WARNING! SLOW!
individual_bool = 0;

%% Var Init

% Time of Run
time_now                = datetime("now","Format","uuuuMMddhhmmss");
time_now                = datestr(time_now,'yyyyMMddhhmmss');

% Stuff for appending stuff
feat_export = []; terrain_types = []; data_files = []; feat_name_export = []; cut_predictor_array = []; indv_result_array = [];

%% Selecting the RDF Folder

rdf_dir                 = uigetdir('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/DECISION_TREES/Week_Ov_03_14_2023','Grab Tree Import Directory');
[~,rdf_dir_name,~]      = fileparts(rdf_dir); 
addpath(rdf_dir);
rdf_files               = [dir(fullfile(rdf_dir,'/*.mat'))];

%% Load Verification Data - Indv sources

% Ask user for file
% gras_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Gras_Feat_Extract/Grav_Feat_Extract_1/*.csv', 'Get GRASS data');
% grav_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Grav_Feat_Extract/Gras_Feat_Extract_1/*.csv', 'Get GRAVEL data');
% asph_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Asph_Feat_Extract/Asph_Feat_Extract_1/*.csv', 'Get ASPHALT data');

% asph_file = '';
% gras_file = '';
% grav_file = '';
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
% Mdl_Tester_Table       = [gras_data; grav_data; asph_data];
% terrain_types           = string(table2cell(Mdl_Tester_Table(:,end)));
% Mdl_Tester_Table       = Mdl_Tester_Table(:,1:end-1);
% size_tester_table       = size(Mdl_Tester_Table);

%% Load Validation Data - One source

[train_dat_file, train_dat_path]       = uigetfile('*.csv','Grab CSV testing data');

import_file = string(train_dat_path) + string(train_dat_file);

Mdl_Tester_Table        = readtable(import_file);
% terrain_types           = Mdl_Tester_Table(:,end);
terrain_types           = string(table2cell(Mdl_Tester_Table(:,end)));
Mdl_Tester_Table        = Mdl_Tester_Table(:,1:end-1);
size_tester_table       = size(Mdl_Tester_Table);
% 
% % Mdl_Tester_Table        = getallfeats(Mdl_Tester_Table);
% % Mdl_Tester_Table        = getzxyfeats(table_extract);
% % Mdl_Tester_Table        = gettoptwentyfeats(table_extract);
% % Mdl_Tester_Table        = getrangefeats(table_extract);

%% Creating Export Folder

[rdf_filepath, rdf_name, ~] = fileparts(rdf_dir);

export_dir = string(rdf_filepath) + "/" + string(rdf_name) + "_Results";

% export_dir              = uigetdir('/home/autobuntu/Documents/Rural-Road-Lane-Creator/','Grab Result Export Dir');
mkdir(export_dir);
addpath(export_dir);

[~,export_folder_name,~] = fileparts(export_dir);

%% Validating the overall RDF

% Wait bar fun woooo
% f = waitbar(0,'0','Name','Overall Progress');
% 

job_begin_tic     = tic;

parfor_progress(length(rdf_files));

parfor rdf_idx = 1:length(rdf_files)-1
    
    % Var Init + Reset
    Overall_Correct     = 0; 
    result_array        = zeros(4);
    grav_acc            = 0;
    chip_acc            = 0;
    foli_acc            = 0;
    gras_acc            = 0;
    Yfit                = 0;
    scores              = 0;
    stdevs              = 0;
    clf_time_end        = [];    
    Yfit_Append         = [];
    
    % Loading the File
    loaded_file(rdf_idx) = load(rdf_files(rdf_idx).name);
    
    % Debugggg
%     disp('New loop:')
%     disp(rdf_idx)
%     disp(rdf_files(rdf_idx).name)
    
    if strfind(rdf_files(rdf_idx).name,'TreeBagger') > 0 % If statement to make sure the program doesn't crash at the tree info file

        %% Preparing the export table(s)

        if individual_bool

        %     indv_result_array   = zeros(length(Mdl.Trees), length(table_head));
            indv_result_array   = cell(length(loaded_file(rdf_idx).Mdl.Trees), (length(table_head)+2));
            indv_row_name       = 1:1:length(loaded_file(rdf_idx).Mdl.Trees);
            indv_row_name       = strtrim(cellstr(num2str(indv_row_name'))');
            indv_header_row     = [table_head, "Predicted", "Actual"];

        end

        % Timing for the things
        rdf_begin_tic = tic;

    %     g = waitbar(0,'0','Name','Subset Progress');


%         for score_idx = 1:size_tester_table(1)

        %% Plugging into the BIG RDF

        classification_time_start = tic;
        [Yfit, scores, stdevs]              = predict(loaded_file(rdf_idx).Mdl, Mdl_Tester_Table);
        clf_time_end = [clf_time_end; toc(classification_time_start)];
        Yfit_Append = [Yfit_Append; Yfit];

        %% Displaying fun stuff + Timing

        Quadrant_Classification_Time            = mean(clf_time_end);
        Overall_RDF_Validation_Time             = toc(rdf_begin_tic);

        %% Calculate accuracy
        
%         conf_fig = figure()
                
        % Confusion Matrix
        conf_mat = confusionchart(terrain_types, string(Yfit_Append));
        
%         saveas(conf_fig, (export_dir + "/conf_mat_" + string(rdf_files(rdf_idx).name) + ".png"));
        
        % Overall Accuracy          
        Overall_Acc = sum(diag(conf_mat.NormalizedValues)) / size_tester_table(1);

%         % Individual Accuracy
%         grav_acc                    = conf_mat.NormalizedValues(4,4) / sum_grav;
%         chip_acc                    = conf_mat.NormalizedValues(1,1) / sum_chip;
%         foli_acc                    = conf_mat.NormalizedValues(2,2) / sum_foli;
%         gras_acc                    = conf_mat.NormalizedValues(3,3) / sum_gras;

        % Individual Accuracy
%         grav_acc                    = conf_mat.NormalizedValues(3,3) / min_dat_size;
%         asph_acc                    = conf_mat.NormalizedValues(1,1) / min_dat_size;
%         gras_acc                    = conf_mat.NormalizedValues(2,2) / min_dat_size;

        %% Options Saving

        NumTrees                    = loaded_file(rdf_idx).Mdl.NumTrees;
        NumPredictorsToSample       = loaded_file(rdf_idx).Mdl.NumPredictorsToSample;
        MaxNumSplits                = loaded_file(rdf_idx).Mdl.TreeArguments{2};

        %% SAVE DAT STUPID DATA

    %     File_Subname_1      = string(loaded_file(rdf_idx).Mdl.NumTrees);
        File_Subname_1      = string(rdf_files(rdf_idx).name);

        Filename_Overall = string(export_dir) + '/' + string(export_folder_name) + "_" + File_Subname_1 + '_RDF_RESULTS.mat';

        parsaveRDF(Filename_Overall, Overall_Acc, conf_mat, NumTrees, NumPredictorsToSample, MaxNumSplits, Overall_RDF_Validation_Time, Quadrant_Classification_Time, size_tester_table)

    end % If statement tha that avoids the stupid crashing at the end of the thing
    
    parfor_progress;
  
end

parfor_progress(0);

close all

%% Saving  Individual_Tree_Result
% For some reason Individual_Tree_Result is okay with being a super massive
% struct so okay it's being saved as is.
% if individual_bool
%     
%     disp('Saving the individual result...')   
%     Filename_Indv = string(export_dir) + "/" + string(export_folder_name) + '_RDF_INDV_RESULTS.mat';
%     save(Filename_Indv, 'Individual_Tree_Result','-v7.3')
%     disp('File saved! :D File name: ')
%     disp(Filename_Indv)
%     
% end

job_end_toc = toc(job_begin_tic);

fprintf("End of Verification! This sucker took %f seconds (%f minutes) to complete!!!!\n\n", job_end_toc, (job_end_toc / 60))

%% Verifictaion Scoring Plot function

% to-do later

disp('End Program!')

% gong_gong()
