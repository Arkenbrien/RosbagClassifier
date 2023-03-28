%% Init Worksapce

clear all 
close all
clc

%% Options

mls_bool = 0;
ran_bool = 1;


%% Var Init


%% Inport data

% Ask user for file & load
import_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/*.mat', 'Get raw data!')
load(import_file);

% get size of import file (maybe we have a bigger/smaller LiDAR in future, no?
import_dims = size(raw_data_export);

%% Terrain Type

% Select desired type
disp('Select terrain type')
dlg_list                    = {'Gravel', 'Chipseal', 'Grass', 'Foliage', 'Asphalt'};
[terrain_opt,~]           = listdlg('ListString', dlg_list,'SelectionMode','single');

if terrain_opt == 1
    terrain_type = 'gravel';
elseif terrain_opt == 2
    terrain_type = 'chipseal';
elseif terrain_opt == 3
    terrain_type = 'grass';
elseif terrain_opt == 4
    terrain_type = 'foliage';
elseif terrain_opt == 5
    terrain_type = 'asphalt';
end

%% Export Location 

% Ask user for directory, make file, add to path
export_location = uigetdir('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA','Get||Make export location')

if ~exist(export_location,'dir')
    mkdir(export_location)
end

addpath(export_location)

%% For each ring, grab the data and export it to an export location

h = waitbar(0, "Grabbing the dataz...");

% Examine each column (ring)
for ring_idx = 1:1:import_dims(2)
    
    % Clear export table for each loop.
    export_table = table();
    
    % Examine each row (360 scan == pcd)
    for row_idx = 1:1:import_dims(1)
        
        % If the cell isn't empty
        if ~isempty(raw_data_export{row_idx, ring_idx})
            
            % Grab the data
            xyzi = raw_data_export{row_idx, ring_idx}.xyzi;
            
            % If we're using RANSAC or MLL as plane projection method
            if ran_bool
                
                abcd = [raw_data_export{row_idx, ring_idx}.rana,...
                        raw_data_export{row_idx, ring_idx}.ranb,...
                        raw_data_export{row_idx, ring_idx}.ranc,...
                        raw_data_export{row_idx, ring_idx}.rand];
                    
                % Extract Features
                extracted_feats = get_RANSAC_feats_2(xyzi,abcd);
                
            elseif mls_bool
                
                abcd = [raw_data_export{row_idx, ring_idx}.mlla,...
                        raw_data_export{row_idx, ring_idx}.mllb,...
                        raw_data_export{row_idx, ring_idx}.mllc,...
                        raw_data_export{row_idx, ring_idx}.mlld];
                    
            else
                
                abcd = [];
                
                % Extract features
                extracted_feats = get_RANGE_feats_2(xyzi,abcd);
                
            end
            
            
            
            % Initilize export table, otherwise append
            export_table = [export_table; extracted_feats];
                    
        end
    
    end
        
    export_table.terrain_type = repelem(categorical({terrain_type}),height(export_table),1);
    
    % save table as csv
    filename = export_location + "/" + string(import_file(1:end-4)) + "_" + string(ring_idx) + ".csv";
    writetable(export_table, filename);
    
    % DEBUG
    table_holder{ring_idx} = export_table;
    
    %% Weightbar
    
    waitbar(ring_idx/import_dims(2),h,sprintf('Ring %01d out of %01d',ring_idx, import_dims(2)))
    
    
end

delete(h)

%% End program

disp('End Program')


