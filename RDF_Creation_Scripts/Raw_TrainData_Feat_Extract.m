%==========================================================================
%                               Rhett Huston
%
%                     FILE CREATION DATE: 04/04/2023
%
%                 RDF_Training_Data_Combiner_Splitter.m
%
% This grabs a .mat file & exports all the individual training and
% validation data sets per channel
%
%==========================================================================


%% OPTIONS

% Reference point - only range is supported atm
% 'range'; 'ransac'; 'mls'
options.reference_point = 'range';

% Export Folder
options.export_folder_name = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_Training_Validation_Data"; 

% Which percentage (0 - 1.0) of data to go into the trainig (rest to vali)
options.to_train = 0.70;

%% VAR INIT

chan_2c_feat_table = table(); chan_3c_feat_table = table(); chan_4c_feat_table = table(); chan_5c_feat_table = table(); chan_6c_feat_table = table();
asph_data_files = []; gras_data_files = []; grav_data_files = []; foli_data_files = []; asph_2_data_files = [];
asph_table = table(); gras_table = table(); grav_table = table(); foli_table = table(); asph_2_table = table();
grav_rm_data_files = []; grav_rm_table = table();

% Time of Run
time_now                = datetime("now","Format","uuuuMMddhhmmss");
time_now                = datestr(time_now,'yyyyMMddhhmmss');

side_select = "center"; % Here for a reminder nothing more.


%% Get .mat from user

[filename, pathname] = uigetfile('*.mat', 'Select a .mat file');

fullPath = fullfile(pathname, filename);

loadedData = load(fullPath);

disp('File loaded successfully.');


%% Go through the file & pull all channels into a table

for idx = 1:length(loadedData.raw_training_data)

    if ~isempty(loadedData.raw_training_data{idx})
        
        terrain_type = get_terrain_type(loadedData.raw_training_data{idx}.terrain_opt);

        if isfield(loadedData.raw_training_data{idx}, 'c2')
            chan_2c_feat_table = [chan_2c_feat_table; get_RANGE_feats_2(loadedData.raw_training_data{idx}.c2), table(terrain_type, 'VariableNames', {'terrain_type'})];
        end

        if isfield(loadedData.raw_training_data{idx}, 'c3')
            chan_3c_feat_table = [chan_3c_feat_table; get_RANGE_feats_2(loadedData.raw_training_data{idx}.c3), table(terrain_type, 'VariableNames', {'terrain_type'})];
        end

        if isfield(loadedData.raw_training_data{idx}, 'c4')
            chan_4c_feat_table = [chan_4c_feat_table; get_RANGE_feats_2(loadedData.raw_training_data{idx}.c4), table(terrain_type, 'VariableNames', {'terrain_type'})];
        end

        if isfield(loadedData.raw_training_data{idx}, 'c5')
            chan_5c_feat_table = [chan_5c_feat_table; get_RANGE_feats_2(loadedData.raw_training_data{idx}.c5), table(terrain_type, 'VariableNames', {'terrain_type'})];
        end

        if isfield(loadedData.raw_training_data{idx}, 'c6')
            chan_6c_feat_table = [chan_6c_feat_table; get_RANGE_feats_2(loadedData.raw_training_data{idx}.c6), table(terrain_type, 'VariableNames', {'terrain_type'})];
        end
        
    end

end


%% Pull training/validiation data

export_train_vali_csv(chan_2c_feat_table, options, 'c2')
export_train_vali_csv(chan_3c_feat_table, options, 'c3')
export_train_vali_csv(chan_4c_feat_table, options, 'c4')
export_train_vali_csv(chan_5c_feat_table, options, 'c5')
export_train_vali_csv(chan_6c_feat_table, options, 'c6')





%% Functions

function terrain_type = get_terrain_type(terrain_opt) 

    if terrain_opt == 1
        terrain_type    = "gravel";
    elseif terrain_opt == 2
        terrain_type    = "chipseal";    
    elseif terrain_opt == 3
        terrain_type    = "foliage";
    elseif terrain_opt == 4
        terrain_type    = "grass";
    elseif terrain_opt == 5
        terrain_type    = "asphalt";
    elseif terrain_opt == 6
        terrain_type    = "asphalt_2";
    elseif terrain_opt == 7
        terrain_type    = "dirt";
    end
    
end
