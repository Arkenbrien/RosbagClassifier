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

%% Selecting the export folder

export_dir              = uigetdir('');
addpath(export_dir)

%% Training Setup

prompt                  = {'Min Tree Num', '~Num RDFs', 'Max Tree Num', 'Number directories (training sources) will be used', 'MaxNumSplits?', 'Test Number?', 'Special Tag?'};
dlgtitle                = 'Tree Creation Setup';
definput                = {'10','50', '1000', '2', '10', 'Test_X', ''};
dims                    = [1 35];
setup_answers           = inputdlg(prompt,dlgtitle,dims,definput);

Min_Num_Tree            = str2double(setup_answers(1));
Num_RDF                 = str2double(setup_answers(2));
Max_Num_Tree            = str2double(setup_answers(3));
NumDirs                 = str2double(setup_answers(4)); 
NumSplits               = str2double(setup_answers(5));
test_number             = string(setup_answers(6));
spec_tag                = string(setup_answers(7));

% Creating the array for the number of trees
Split_Value             = (Max_Num_Tree - Min_Num_Tree) / Num_RDF;
Tree_Num_Array          = unique(round(Min_Num_Tree:Split_Value:Max_Num_Tree), 'stable');
% Tree_Num_Array = [1:300];

%% Reinialize the stupid training data???

prompt                  = {'Re-init training data? Yes/No'};
dlgtitle                = 'Training Data Init';
definput                = {'Yes'};
dims                    = [1 35];
init_ans                = inputdlg(prompt,dlgtitle,dims,definput);

init_ans_result         = string(init_ans(1));

%% Grabbing Directories
if init_ans_result == "Yes"
    
    % Stuff for appending stuff
    feat_export = []; terrain_types = []; data_files = []; feat_name_export = []; cut_predictor_array = [];

    for i = 1:NumDirs

        % Grabs the directory of the .mat files with the features
        data_folder             = uigetdir('/home/autobuntu/RDF_Training_Data_Base/Single_Folders_Processed_Data');
        
        % Displays for sanity
        disp(data_folder)

        % Apphends the file's directory list to a larger array
        data_files              = [data_files; dir(fullfile(data_folder,'/*.mat'))]; 
        
    end
    
end
    
    %% Loading the data into a single table
    
    f                       = waitbar(0,'1','Name','Loading Training Data');
    num_loops               = length(data_files);
    
    % Handling the feature values
    for i = 1:num_loops

        % Load the file
        load(data_files(i).name);

        % Setting the terrain types
        terrain_types           = [terrain_types; string(cell2mat(train_dat.type))];

        feat_extract_S          = struct2array(train_dat.feat.S);
        feat_extract_R          = struct2array(train_dat.feat.R);

        feat_export             = [feat_export; feat_extract_S feat_extract_R];

        waitbar(i/(num_loops),f,sprintf('%1.1f',(i/num_loops*100)))

    end

    close(f)
    
%% Exporting the table for use in the Treebagger Function
    
table_head_S            = [string(fieldnames(train_dat.feat.S)')];
table_head_R            = [string(fieldnames(train_dat.feat.R)')];
table_head              = [table_head_S table_head_R];
table_extract           = array2table(feat_export,'VariableNames',table_head);


%% Choosing features to put into the RDF Trainer

Mdl_Trainer_Table       = getfeaturenamearray(table_extract);

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

cost_array = ([0 0.75 1 1; 0.75 0 1 1; 1 1 0 1; 1 1 1 0]);
S.ClassNames = ["gravel","chipseal","foliage","grass"];
S.ClassificationCosts = cost_array;

%% Creating the Trees :D

tic

parfor_progress(length(Tree_Num_Array));

parfor tree_idx = 1:300
    
%     disp('Creating the Trees')

    % Safety for more features to use as predictors than actual features in
    % array

    % Creating the Model
    Mdl                     = TreeBagger(Tree_Num_Array(tree_idx),Mdl_Trainer_Table, ...
                                        terrain_types, ...
                                        "Method", "classification", ...
                                        "MaxNumSplits", NumSplits, ...
                                        "NumPredictorsToSample", Num_Feats, ...
                                        "Cost", S, ...
                                        "OOBPredictorImportance", "on", ...
                                        OOBPrediction = "on" ,...
                                        InBagFraction = 1.0);  
    
    %% Saving the files
%     disp('Created, saving file...')

    % Saving the file
    time_now                = datetime("now","Format","uuuuMMddhhmmss");
    time_now                = datestr(time_now,'yyyyMMddhhmmss');
    
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

disp('Training Table saving...')
Trainer_Table_Head      = Mdl_Trainer_Table.Properties.VariableNames;
Filename_Opt            = export_dir + "/" + "_" + test_number + "_Trainer_Table_Head.mat";
save(Filename_Opt, 'Trainer_Table_Head')
disp('Training Table saved! Name: ')
disp(Filename_Opt)

%% Prog End

gong_gong()

disp('Program ended')







