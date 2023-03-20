%==========================================================================
%                            Rhett Huston
%
%                     FILE CREATION DATE: 02/27/2023
%
%                        Classification Results Diag
%
% Displays the classification results between stdevs or scores values.
% 
%==========================================================================

%% Clear Workspace

clear all
close all
clc

%% Options

% Use either stdevs or scores to display
stdevs_bool = 0;
scores_bool = 1;

% display between these two values:
low_val     = 0.1;
hig_val     = 0.3;

% which of the four terrains you wanna look at:
grav_bool   = 1;
chip_bool   = 0;
foli_bool   = 0;
gras_bool   = 0;

%% Var Inits

% xyz arrays for the four classes
grav_array_temp         = []; chip_array_temp       = []; gras_array_temp       = []; foli_array_temp       = [];
grav_avg_array_temp     = []; chip_avg_array_temp   = []; gras_avg_array_temp   = []; foli_avg_array_temp   = [];
Grav_All_Append_Array   = []; Chip_All_Append_Array = []; Foli_All_Append_Array = []; Gras_All_Append_Array = [];
Grav_Avg_Append_Array   = []; Chip_Avg_Append_Array = []; Foli_Avg_Append_Array = []; Gras_Avg_Append_Array = [];


% tform rotational correction factor. 
corr_z_rot_deg  = 90;
corr_z_matrix   = rotz(corr_z_rot_deg);

%% Load Classification Root File

root_dir = uigetdir();

%% Adding paths

% tform
tform_save_folder           = string(root_dir) + "/TFORM";
addpath(tform_save_folder);

% Classification Stack
CLASSIFICATION_STACK_FOLDER = string(root_dir) + "/CLASSIFICATION_STACK";
addpath(CLASSIFICATION_STACK_FOLDER);

% Image export
IMAGE_EXPORT_FOLDER = string(root_dir) + "/IMAGE_EXPORT";
addpath(IMAGE_EXPORT_FOLDER);

%% Load Classification Stack Stuff

Save_Tform_Filename                 = tform_save_folder + "/tform.mat";
Save_Gps_Loc_Filename               = tform_save_folder + "/gps_loc.mat";
Save_LiDAR_Loc_Filename             = tform_save_folder + "/LiDAR_loc.mat";

load(Save_Tform_Filename);
load(Save_Gps_Loc_Filename);
load(Save_LiDAR_Loc_Filename);

classification_list             = dir(fullfile(CLASSIFICATION_STACK_FOLDER,'/*.mat'));

%% Applying Tform to each result

disp('Applying Tform to each result')

Grav_All_Append_Array = []; Chip_All_Append_Array = []; Foli_All_Append_Array = []; Gras_All_Append_Array = [];
Grav_Avg_Append_Array = []; Chip_Avg_Append_Array = []; Foli_Avg_Append_Array = []; Gras_Avg_Append_Array = [];

tform_apply_bar = waitbar(0, sprintf('tform 0 out of %d, ~ X.X min left', length(tform)));

for tform_idx = 1:1:length(tform) - 3

    %% Clearing Vars
    
    grav_array_temp = []; chip_array_temp = []; gras_array_temp = []; foli_array_temp = [];
    grav_avg_array_temp = []; chip_avg_array_temp = []; gras_avg_array_temp = []; foli_avg_array_temp = [];
    
    label_cell = [];

    %% Loading Classification

    load(classification_list(tform_idx).name)
    
    %% Grabbing the Classification Results

    % Go through all the classification results
    for result_idx = 1:1:length(Classification_Result)
        
        label                       = Classification_Result(result_idx).label;
        
        % I was messing around with the MATLAB machine learning app, this
        % catches the classification label and re-formats it to the correct
        % format for the later code. 
        
        try
            label = cellstr(label);
        catch
%             warning('Label may be incorrectly formatted')
        end
        
        scores                      = Classification_Result(result_idx).scores;
        stdevs                      = Classification_Result(result_idx).stdevs;
                
        score_array = repmat(scores, length(Classification_Result(result_idx).xyzi), 1);
        stdevs_array = repmat(stdevs, length(Classification_Result(result_idx).xyzi), 1);
        
        % If the labelresult is not empty, grab the xyz data according to 
        % the label. 
        % I supply two types of arrays - one having all the points and one
        % having the average xyz of the points per classified quadrant
        if ~isempty(Classification_Result(result_idx).label)

            if grav_bool
                
                if isequal(cell2mat(label), 'gravel')
                    
                    grav_array_temp         = [grav_array_temp; Classification_Result(result_idx).xyzi, score_array, stdevs_array];
                    grav_avg_array_temp     = [grav_avg_array_temp; Classification_Result(result_idx).avg_xyz, scores, stdevs];
                    
                end
                
            end

            if chip_bool
                
                if isequal(cell2mat(label), 'chipseal')
                    chip_array_temp         = [chip_array_temp; Classification_Result(result_idx).xyzi, score_array, stdevs_array];
                    chip_avg_array_temp     = [chip_avg_array_temp; Classification_Result(result_idx).avg_xyz, scores, stdevs];
                end
                
            end

            if foli_bool
                
                if isequal(cell2mat(label), 'foliage')
                    foli_array_temp         = [foli_array_temp; Classification_Result(result_idx).xyzi, score_array, stdevs_array];
                    foli_avg_array_temp     = [foli_avg_array_temp; Classification_Result(result_idx).avg_xyz, scores, stdevs];
                end
                
            end

            if gras_bool
                
                if isequal(cell2mat(label), 'grass')
                    gras_array_temp         = [gras_array_temp; Classification_Result(result_idx).xyzi, score_array, stdevs_array];
                    gras_avg_array_temp     = [gras_avg_array_temp; Classification_Result(result_idx).avg_xyz, scores, stdevs];
                end
                
            end

        end % Go through all the result
        
    end % Going through the classification results
    
    %% Applying the Transform
    
    % I supply two types of arrays - one having all the points and one
    % having the average xyz of the points per classified quadrant

    if ~isempty(grav_array_temp)
        grav_array_temp(:,1:3)          = grav_array_temp(:,1:3)    * tform(tform_idx).Rotation     * corr_z_matrix;
        grav_array_temp(:,1:3)          = grav_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Grav_All_Append_Array               = [Grav_All_Append_Array; grav_array_temp];
    end
    
    if ~isempty(grav_avg_array_temp)
        grav_avg_array_temp(:,1:3)             = grav_avg_array_temp(:,1:3)       * tform(tform_idx).Rotation     * corr_z_matrix;
        grav_avg_array_temp(:,1:3)             = grav_avg_array_temp(:,1:3)       + tform(tform_idx).Translation;
        Grav_Avg_Append_Array           = [Grav_Avg_Append_Array; grav_avg_array_temp];
    end
    
    if ~isempty(chip_array_temp)
        chip_array_temp(:,1:3)          = chip_array_temp(:,1:3)    * tform(tform_idx).Rotation     * corr_z_matrix;
        chip_array_temp(:,1:3)          = chip_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Chip_All_Append_Array               = [Chip_All_Append_Array; chip_array_temp];
    end
    
    if ~isempty(chip_avg_array_temp)
        chip_avg_array_temp(:,1:3)             = chip_avg_array_temp(:,1:3)       * tform(tform_idx).Rotation     * corr_z_matrix;
        chip_avg_array_temp(:,1:3)             = chip_avg_array_temp(:,1:3)       + tform(tform_idx).Translation;
        Chip_Avg_Append_Array           = [Chip_Avg_Append_Array; chip_avg_array_temp];
    end
    
    if ~isempty(foli_array_temp)
        foli_array_temp(:,1:3)          = foli_array_temp(:,1:3)    * tform(tform_idx).Rotation     * corr_z_matrix;
        foli_array_temp(:,1:3)          = foli_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Foli_All_Append_Array               = [Foli_All_Append_Array; foli_array_temp];
    end
    
    if ~isempty(foli_avg_array_temp)
        foli_avg_array_temp(:,1:3)             = foli_avg_array_temp(:,1:3)       * tform(tform_idx).Rotation     * corr_z_matrix;
        foli_avg_array_temp(:,1:3)             = foli_avg_array_temp(:,1:3)       + tform(tform_idx).Translation;
        Foli_Avg_Append_Array           = [Foli_Avg_Append_Array; foli_avg_array_temp];
    end
    
    if ~isempty(gras_array_temp)
        gras_array_temp(:,1:3)          = gras_array_temp(:,1:3)    * tform(tform_idx).Rotation     * corr_z_matrix;
        gras_array_temp(:,1:3)          = gras_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Gras_All_Append_Array               = [Gras_All_Append_Array; gras_array_temp];
    end
    
    if ~isempty(gras_avg_array_temp)
        gras_avg_array_temp(:,1:3)             = gras_avg_array_temp(:,1:3)       * tform(tform_idx).Rotation     * corr_z_matrix;
        gras_avg_array_temp(:,1:3)             = gras_avg_array_temp(:,1:3)       + tform(tform_idx).Translation;
        Gras_Avg_Append_Array           = [Gras_Avg_Append_Array; gras_avg_array_temp];
    end
    
    %% Waitbar

    waitbar(tform_idx/ length(tform),tform_apply_bar,sprintf('tform %d out of %d', tform_idx, length(tform)))

end % Going through the transform list

delete(tform_apply_bar)

disp('Tform application complete!')

%% Grab only the desired scores

% % Eliminate points based on channel
% init_cloud(init_cloud(:,5) < ring_max, :) = [];
% init_cloud(init_cloud(:,5) > ring_min, :) = [];
% (x, y, z, i, chips score, foli score, grass score, gravel score, chips stdev, foli stdev, grass stdev, gravel stdev) 

% display between these two values:
low_val     = 0.0;
hig_val     = 1;


if scores_bool
    
    if grav_bool
        
        idx = find(Grav_All_Append_Array(:,8) <= hig_val & Grav_All_Append_Array(:,8) >= low_val);
        Grav_Des_Array = Grav_All_Append_Array(idx, :);
    
%         Grav_Des_Array = Grav_All_Append_Array(Grav_All_Append_Array(:,8) < hig_val) & Grav_All_Append_Array(Grav_All_Append_Array(:,8) > low_val);
    
    end
    
end


%% Random Testing 

idx_2 = find((Grav_All_Append_Array(:,8) - Grav_All_Append_Array(:,7)) <= 0.2 & (Grav_All_Append_Array(:,8) - Grav_All_Append_Array(:,6)) <= 0.3);
test_array =  Grav_All_Append_Array(idx_2, :);
figure
plot3(test_array(:,1), test_array(:,2), test_array(:,3), 'c.', 'MarkerSize', 3.5)
axis('equal')
axis off
view([0 0 90])




%% Plotting the results

disp('Plotting Results')
% 

try
    
    x_min_lim = min([Grav_All_Append_Array(:,1); Chip_All_Append_Array(:,1); Foli_All_Append_Array(:,1); Gras_All_Append_Array(:,1)]) - 5;
    x_max_lim = max([Grav_All_Append_Array(:,1); Chip_All_Append_Array(:,1); Foli_All_Append_Array(:,1); Gras_All_Append_Array(:,1)]) + 5;

    y_min_lim = min([Grav_All_Append_Array(:,2); Chip_All_Append_Array(:,2); Foli_All_Append_Array(:,2); Gras_All_Append_Array(:,2)]) - 5;
    y_max_lim = max([Grav_All_Append_Array(:,2); Chip_All_Append_Array(:,2); Foli_All_Append_Array(:,2); Gras_All_Append_Array(:,2)]) + 5;
    
    
catch
    
    x_min_lim = -100;
    x_max_lim = 100;
    y_min_lim = -100;
    y_max_lim = 100;
end

% All points
result_all_fig = figure('DefaultAxesFontSize', 14)

hold all

plot3(Grav_Des_Array(:,1), Grav_Des_Array(:,2), Grav_Des_Array(:,3), 'c.', 'MarkerSize', 3.5)
% plot3(Chip_All_Append_Array(:,1), Chip_All_Append_Array(:,2), Chip_All_Append_Array(:,3), 'k.', 'MarkerSize', 3.5)
% plot3(Foli_All_Append_Array(:,1), Foli_All_Append_Array(:,2), Foli_All_Append_Array(:,3), 'm.', 'MarkerSize', 3.5)
% plot3(Gras_All_Append_Array(:,1), Gras_All_Append_Array(:,2), Gras_All_Append_Array(:,3), 'g.', 'MarkerSize', 3.5)

axis('equal')
axis off
view([0 0 90])

xlim([x_min_lim x_max_lim]);
ylim([y_min_lim y_max_lim]);

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';
    


