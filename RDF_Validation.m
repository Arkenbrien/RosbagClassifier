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

%% Var Init


% Stuff for appending stuff
feat_export = []; types = []; data_files = []; feat_name_export = []; cut_predictor_array = []; indv_result_array = [];

% Look at each tree for feature counting and scoring
individual_bool = 0;


%% Opening Up the Validation Data

% Directories for the Validation Data...
% Two methods of plane projection were compared: RANSAC and MLS. Each have
% their own seperate validation data set.
% RANSAC
% chip_dir            = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/VALIDATION_DATA/Chipseal/CHIPSEAL_VALIDATION_FEAT_EXTRACT';
% gras_dir            = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/VALIDATION_DATA/Grass/GRASS_VALIDATION_FEAT_EXTRACT';
% foli_dir            = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/VALIDATION_DATA/Foliage/FOLIAGE_VALIDATION_FEAT_EXTRACT';
% grav_dir            = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/VALIDATION_DATA/Gravel/GRAVEL_VALIDATION_FEAT_EXTRACT';

% Method of Least Squares
chip_dir            = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/VALIDATION_DATA/Chipseal/chip_validation_mls';
gras_dir            = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/VALIDATION_DATA/Grass/gras_validation_mls';
foli_dir            = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/VALIDATION_DATA/Foliage/foli_validation_mls';
grav_dir            = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/VALIDATION_DATA/Gravel/grav_validation_mls';

validation_files = [dir(fullfile(chip_dir,'/*.mat')); dir(fullfile(gras_dir,'/*.mat')); dir(fullfile(foli_dir,'/*.mat')); dir(fullfile(grav_dir,'/*.mat'))];

%% Creating the feat data array

f                       = waitbar(0,'1','Name','Loading V Data');
len                     = length(validation_files);

% Handling the feature values
for val_file_idx = 1:len
    
    % Load the file
    load(validation_files(val_file_idx).name);
    
    % Setting the terrain types
    types                   = [types; string(cell2mat(train_dat.type))];
        
    feat_extract_S          = struct2array(train_dat.feat.S);
    feat_extract_R          = struct2array(train_dat.feat.R);
    
    feat_export             = [feat_export; feat_extract_S feat_extract_R];
        
    waitbar(val_file_idx/(len),f,sprintf('%1.1f',(val_file_idx/len*100)))

end

close(f)

%% Var init for this stuff

sum_grav = sum(count(types,'gravel'));
sum_foli = sum(count(types,'foliage'));
sum_chip = sum(count(types,'chipseal'));
sum_gras = sum(count(types,'grass'));


%% Exporting the table for use in the Treebagger Function

table_head_S            = [string(fieldnames(train_dat.feat.S)')];
table_head_R            = [string(fieldnames(train_dat.feat.R)')];
table_head              = [table_head_S table_head_R];

% Creating the big table
table_extract           = array2table(feat_export,'VariableNames',table_head);

%% Selecting the RDF Folder

rdf_dir                 = uigetdir('/home/autobuntu/Documents/Rural-Road-Lane-Creator/TRAINING_DATA/','Grab Tree Import Directory');
addpath(rdf_dir);
rdf_files               = [dir(fullfile(rdf_dir,'/*.mat'))];

%% Creating Export Folder

export_dir              = uigetdir('/home/autobuntu/Documents/Rural-Road-Lane-Creator/','Grab Result Export Dir');
addpath(export_dir);

[filepath,export_folder_name,ext] = fileparts(export_dir);


%% Validating the overall RDF

% Wait bar fun woooo
% f = waitbar(0,'0','Name','Overall Progress');
% 

job_begin_tic     = tic;

parfor_progress(length(rdf_files));

parfor rdf_idx = 1:length(rdf_files)
    
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
    table_export        = 0;
    classification_time_end = [];
    
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

        for score_idx = 1:len

            %% Put in Table Format

            table_export                        = array2table(feat_export(score_idx,:),'VariableNames',table_head);

            %% Plugging into the BIG RDF
            
            classification_time_start = tic;
            [Yfit, scores, stdevs]              = predict(loaded_file(rdf_idx).Mdl, table_export);
            classification_time_end = [classification_time_end; toc(classification_time_start)];
            
            %% Plugging into individual RDF

            if individual_bool

                for j = 1:length(loaded_file(rdf_idx).Mdl.Trees) % For each tree

                    % Get the prediction 
                    Prediction                 = predict(loaded_file(rdf_idx).Mdl.Trees{j}, table_export);

                    for k = 1:(length(table_head) + 2)

                        if k <= length(table_head) % Getting the results for each Cut

                            indv_result_array{j,k}  = sum(count(loaded_file(rdf_idx).Mdl.Trees{j}.CutPredictor,table_head(k)));

                        elseif k == length(table_head) + 1 % Getting the actual and predicted label inserted 

                            % Predicted
                            indv_result_array{j,k}  = string(Prediction);

                        elseif k == length(table_head) + 2

                            % Actual
                            indv_result_array{j,k}  = types(score_idx);

                        end % Getting the numbers + the predicted | actual results inserted

                    end % Getting the individual tree results in a row

                end % Getting all the individual tree results

                % Exporting individual tree array
                Individual_Tree_Result(rdf_idx,score_idx).result_array = indv_result_array;

                % Exporting pretty looking table of individual trees results
                indv_result_table = array2table(indv_result_array,'VariableNames',indv_header_row,'RowNames',indv_row_name);

                % Exporting stuff to mega structure yipeeee
                Individual_Tree_Result(rdf_idx,score_idx).table                         = indv_result_table;
                Individual_Tree_Result(rdf_idx,score_idx).NumTrees                      = loaded_file(rdf_idx).Mdl.NumTrees;
                Individual_Tree_Result(rdf_idx,score_idx).NumPredictorsToSample         = loaded_file(rdf_idx).Mdl.NumPredictorsToSample;
                Individual_Tree_Result(rdf_idx,score_idx).Cost                          = loaded_file(rdf_idx).Mdl.Cost;
                Individual_Tree_Result(rdf_idx,score_idx).MaxNumSplits                  = loaded_file(rdf_idx).Mdl.TreeArguments{2}; 

            end % individual tree examination

            %% Overall comparison to actual

            % Base Accuracy
            if isequal(cell2mat(Yfit), types(score_idx))

                Overall_Correct         = Overall_Correct + 1;

            end

            %% Case by Case (there has to be a better way for this lol)

            %                             Actual
            %               __________________________________
            %               | 0         0         0         0 |
            % Prediction    | 0         0         0         0 |
            %               | 0         0         0         0 |
            %               | 0         0         0         0 |

            % GRAVEL ROW
            if isequal(cell2mat(Yfit), 'gravel') && types(score_idx) == "gravel"

                result_array(1,1)       = result_array(1,1) + 1;

            elseif isequal(cell2mat(Yfit), 'gravel') && types(score_idx) == "chipseal"

                result_array(1,2)       = result_array(1,2) + 1;

            elseif isequal(cell2mat(Yfit), 'gravel') && types(score_idx) == "foliage"

                result_array(1,3)       = result_array(1,3) + 1;

            elseif isequal(cell2mat(Yfit), 'gravel') && types(score_idx) == "grass"

                result_array(1,4)       = result_array(1,4) + 1;

            % CHIPSEAL ROW

            elseif isequal(cell2mat(Yfit), 'chipseal') && types(score_idx) == "gravel"

                result_array(2,1)       = result_array(2,1) + 1;

            elseif isequal(cell2mat(Yfit), 'chipseal') && types(score_idx) == "chipseal"

                result_array(2,2)       = result_array(2,2) + 1;

            elseif isequal(cell2mat(Yfit), 'chipseal') && types(score_idx) == "foliage"

                result_array(2,3)       = result_array(2,3) + 1;

            elseif isequal(cell2mat(Yfit), 'chipseal') && types(score_idx) == "grass"

                result_array(2,4)       = result_array(2,4) + 1;

            % FOLIAGE ROW

            elseif isequal(cell2mat(Yfit), 'foliage') && types(score_idx) == "gravel"

                result_array(3,1)       = result_array(3,1) + 1;

            elseif isequal(cell2mat(Yfit), 'foliage') && types(score_idx) == "chipseal"

                result_array(3,2)       = result_array(3,2) + 1;

            elseif isequal(cell2mat(Yfit), 'foliage') && types(score_idx) == "foliage"

                result_array(3,3)       = result_array(3,3) + 1;

            elseif isequal(cell2mat(Yfit), 'foliage') && types(score_idx) == "grass"

                result_array(3,4)       = result_array(3,4) + 1;

            % GRASS ROW

            elseif isequal(cell2mat(Yfit), 'grass') && types(score_idx) == "gravel"

                result_array(4,1)       = result_array(4,1) + 1;

            elseif isequal(cell2mat(Yfit), 'grass') && types(score_idx) == "chipseal"

                result_array(4,2)       = result_array(4,2) + 1;

            elseif isequal(cell2mat(Yfit), 'grass') && types(score_idx) == "foliage"

                result_array(4,3)       = result_array(4,3) + 1;

            elseif isequal(cell2mat(Yfit), 'grass') && types(score_idx) == "grass"

                result_array(4,4)       = result_array(4,4) + 1;

            end

        end % RDF Scoreing - each tree is scored and results are plooped into a 4x4 array

        %% Displaying fun stuff + Timing

        Quadrant_Classification_Time            = mean(classification_time_end);
        Overall_RDF_Validation_Time             = toc(rdf_begin_tic);

        %% Calculate accuracy

        % Overall Accuracy
        Overall_Acc                 = Overall_Correct / len

        % Individual Accuracy
        grav_acc                    = result_array(1,1) / sum_grav;
        chip_acc                    = result_array(2,2) / sum_chip;
        foli_acc                    = result_array(3,3) / sum_foli;
        gras_acc                    = result_array(4,4) / sum_gras;

        %% Options Saving

        NumTrees                    = loaded_file(rdf_idx).Mdl.NumTrees;
        NumPredictorsToSample       = loaded_file(rdf_idx).Mdl.NumPredictorsToSample;
        Cost                        = loaded_file(rdf_idx).Mdl.Cost;
        MaxNumSplits                = loaded_file(rdf_idx).Mdl.TreeArguments{2};

        %% SAVE DAT STUPID DATA

%         disp('Saving Data')

    %     File_Subname_1      = string(loaded_file(rdf_idx).Mdl.NumTrees);
        File_Subname_1      = string(rdf_files(rdf_idx).name);

        Filename_Overall = string(export_dir) + '/' + string(export_folder_name) + "_" + File_Subname_1 + '_RDF_RESULTS.mat';

        % Debug....
%         disp(Filename_Overall)

        parsaveRDF(Filename_Overall, Overall_Acc, grav_acc, chip_acc, foli_acc, gras_acc, NumTrees, NumPredictorsToSample, Cost, MaxNumSplits, result_array, Overall_RDF_Validation_Time, Quadrant_Classification_Time)

%         disp('Saving Data Complete!')
        
    end % If statement tha that avoids the stupid crashing at the end of the thing
    
    parfor_progress;
  
end

parfor_progress(0);

%% Saving  Individual_Tree_Result
% For some reason Individual_Tree_Result is okay with being a super massive
% struct so okay it's being saved as is.
if individual_bool
    
    disp('Saving the individual result...')   
    Filename_Indv = string(export_dir) + "/" + string(export_folder_name) + '_RDF_INDV_RESULTS.mat';
    save(Filename_Indv, 'Individual_Tree_Result','-v7.3')
    disp('File saved! :D File name: ')
    disp(Filename_Indv)
    
end

job_end_toc = toc(job_begin_tic);

fprintf("End of Verification! This sucker took %f seconds (%f minutes) to complete!!!!\n\n", job_end_toc, (job_end_toc / 60))

%% Verifictaion Scoring Plot function

% to-do later

disp('End Program!')

gong_gong()







