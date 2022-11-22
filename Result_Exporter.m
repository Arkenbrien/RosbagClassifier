%% ===================================================================== %%
%  PCD Stack Classifier Result Exporter
%  Exports the results from the stack classifier (in case if needed)
%  Created on 11/18/2022
%  By Rhett Huston
%  =====================================================================  %


%% Requesting user for file

root_dir = uigetdir();

%% Creating TFROM Export

tform_save_folder           = string(root_dir) + "/TFORM";
addpath(tform_save_folder);

%% Creating PCD Stack export

PCD_STACK_FOLDER = string(root_dir) + "/PCD_STACK";
addpath(PCD_STACK_FOLDER);

%% Creating Classification Stack Export

CLASSIFICATION_STACK_FOLDER = string(root_dir) + "/CLASSIFICATION_STACK";
addpath(CLASSIFICATION_STACK_FOLDER);

%% Creating Export Location

RESULT_EXPORT_FOLDER = string(root_dir) + "/RESULT_EXPORT";
mkdir(RESULT_EXPORT_FOLDER);
addpath(RESULT_EXPORT_FOLDER);

%% Loading the stuffs

classification_list         = dir(fullfile(CLASSIFICATION_STACK_FOLDER,'/*.mat'));
num_pcds                    = length(classification_list);

tform_file_loc                  = string(tform_save_folder) + "/tform.mat";
load(tform_file_loc);

%% Applying Tform to each result

Grav_All_Append_Array = []; Chip_All_Append_Array = []; Foli_All_Append_Array = []; Gras_All_Append_Array = [];
Grav_Avg_Append_Array = []; Chip_Avg_Append_Array = []; Foli_Avg_Append_Array = []; Gras_Avg_Append_Array = [];

for tform_idx = 1:1:num_pcds

    %% Clearing Vars
    
    grav_array_temp = []; chip_array_temp = []; gras_array_temp = []; foli_array_temp = [];
    grav_avg_array_temp = []; chip_avg_array_temp = []; gras_avg_array_temp = []; foli_avg_array_temp = [];

    %% Loading Classification

    load(classification_list(tform_idx).name)

     %% Grabbing the Classification Results

    % Go through all the classification results
    for result_idx = 1:1:length(Classification_Result)
        
        label                       = Classification_Result(result_idx).label;
        scores                      = Classification_Result(result_idx).scores;
        stdevs                      = Classification_Result(result_idx).stdevs;
        
        % If the labelresult is not empty, grab the xyz data according to 
        % the label. 
        % I supply two types of arrays - one having all the points and one
        % having the average xyz of the points per classified quadrant
        if ~isempty(Classification_Result(result_idx).label)

            if isequal(cell2mat(label), 'gravel')
                grav_array_temp         = [grav_array_temp; Classification_Result(result_idx).xyzi];
                grav_avg_array_temp     = [grav_avg_array_temp; Classification_Result(result_idx).avg_xyz];
            end

            if isequal(cell2mat(label), 'chipseal')
                chip_array_temp         = [chip_array_temp; Classification_Result(result_idx).xyzi];
                chip_avg_array_temp     = [chip_avg_array_temp; Classification_Result(result_idx).avg_xyz];
            end

            if isequal(cell2mat(label), 'foliage')
                foli_array_temp         = [foli_array_temp; Classification_Result(result_idx).xyzi];
                foli_avg_array_temp     = [foli_avg_array_temp; Classification_Result(result_idx).avg_xyz];
            end

            if isequal(cell2mat(label), 'grass')
                gras_array_temp         = [gras_array_temp; Classification_Result(result_idx).xyzi];
                gras_avg_array_temp     = [gras_avg_array_temp; Classification_Result(result_idx).avg_xyz];
            end

        end % Go through all the result
        
    end % Going through the classification results
    
    %% Applying the Transform
    
    % I supply two types of arrays - one having all the points and one
    % having the average xyz of the points per classified quadrant
    
    % 1' = 0.3048 m
    % Test......
%     corr_trans = 0.3048;
    corr_trans = 1;
%     corr_trans = 0.6;
    
    % Correction factor because reasons (idk it just todd howards)
    corr_z = 90;
    
    if ~isempty(grav_array_temp)
        grav_array_temp(:,1:3)          = grav_array_temp(:,1:3)    * tform(tform_idx).Rotation * rotz(corr_z);
        grav_array_temp(:,1:3)          = grav_array_temp(:,1:3)    + tform(tform_idx).Translation * corr_trans;
        Grav_All_Append_Array               = [Grav_All_Append_Array; grav_array_temp];
    end
    
    if ~isempty(grav_avg_array_temp)
        grav_avg_array_temp             = grav_avg_array_temp       * tform(tform_idx).Rotation * rotz(corr_z);
        grav_avg_array_temp             = grav_avg_array_temp       + tform(tform_idx).Translation * corr_trans;
        Grav_Avg_Append_Array           = [Grav_Avg_Append_Array; grav_avg_array_temp];
    end
    
    if ~isempty(chip_array_temp)
        chip_array_temp(:,1:3)          = chip_array_temp(:,1:3)    * tform(tform_idx).Rotation * rotz(corr_z);
        chip_array_temp(:,1:3)          = chip_array_temp(:,1:3)    + tform(tform_idx).Translation * corr_trans;
        Chip_All_Append_Array               = [Chip_All_Append_Array; chip_array_temp];
    end
    
    if ~isempty(chip_avg_array_temp)
        chip_avg_array_temp             = chip_avg_array_temp       * tform(tform_idx).Rotation * rotz(corr_z);
        chip_avg_array_temp             = chip_avg_array_temp       + tform(tform_idx).Translation * corr_trans;
        Chip_Avg_Append_Array           = [Chip_Avg_Append_Array; chip_avg_array_temp];
    end
    
    if ~isempty(foli_array_temp)
        foli_array_temp(:,1:3)          = foli_array_temp(:,1:3)    * tform(tform_idx).Rotation * rotz(corr_z);
        foli_array_temp(:,1:3)          = foli_array_temp(:,1:3)    + tform(tform_idx).Translation * corr_trans;
        Foli_All_Append_Array               = [Foli_All_Append_Array; foli_array_temp];
    end
    
    if ~isempty(foli_avg_array_temp)
        foli_avg_array_temp             = foli_avg_array_temp       * tform(tform_idx).Rotation * rotz(corr_z);
        foli_avg_array_temp             = foli_avg_array_temp       + tform(tform_idx).Translation * corr_trans;
        Foli_Avg_Append_Array           = [Foli_Avg_Append_Array; foli_avg_array_temp];
    end
    
    if ~isempty(gras_array_temp)
        gras_array_temp(:,1:3)          = gras_array_temp(:,1:3)    * tform(tform_idx).Rotation * rotz(corr_z);
        gras_array_temp(:,1:3)          = gras_array_temp(:,1:3)    + tform(tform_idx).Translation * corr_trans;
        Gras_All_Append_Array               = [Gras_All_Append_Array; gras_array_temp];
    end
    
    if ~isempty(gras_avg_array_temp)
        gras_avg_array_temp             = gras_avg_array_temp       * tform(tform_idx).Rotation * rotz(corr_z);
        gras_avg_array_temp             = gras_avg_array_temp       + tform(tform_idx).Translation * corr_trans;
        Gras_Avg_Append_Array           = [Gras_Avg_Append_Array; gras_avg_array_temp];
    end

    
end % Going through the transform list

%% Grabbing the time of quadrant classification

quadrant_rate = []; quadrant_move_avg = []; move_avg_size = 5;

for rate_idx = 1:1:num_pcds
    
    % Do Something
    load(classification_list(rate_idx).name)
    
%     disp(classification_list(rate_idx).name)
    
    for result_idx = 1:1:length(Classification_Result)
        
        time_time = Classification_Result(result_idx).time;
        quadrant_rate = [quadrant_rate; time_time];
        
    end

end

%% Creating result structs

RESULTS_ALL.grav = Grav_All_Append_Array;
RESULTS_ALL.chip = Chip_All_Append_Array;
RESULTS_ALL.foli = Foli_All_Append_Array;
RESULTS_ALL.gras = Gras_All_Append_Array;

RESULTS_AVG.grav = Grav_Avg_Append_Array;
RESULTS_AVG.chip = Chip_Avg_Append_Array;
RESULTS_AVG.foli = Foli_Avg_Append_Array;
RESULTS_AVG.gras = Gras_Avg_Append_Array;

RESULTS_RATE.quadrant_rate = quadrant_rate;



%% Saving Stuff


Save_All_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/ALL_RESULTS.mat";
Save_Avg_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/AVG_RESULTS.mat";
Save_Rate_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/RATE_RESULTS.mat";

save(Save_All_Results_Filename, 'RESULTS_ALL');
save(Save_Avg_Results_Filename, 'RESULTS_AVG');
save(Save_Rate_Results_Filename, 'RESULTS_RATE');

%% End program

disp('End Program!')





