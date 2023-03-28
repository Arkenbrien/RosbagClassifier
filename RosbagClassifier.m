%==========================================================================
%                       Travis Moleski/Rhett Huston
%
%                     FILE CREATION DATE: 10/19/2022
%
%                          RosbagClassifier.m
%
% This program  
%==========================================================================

%% Clear & Setup Workspace

clc; clear; close all
format compact


%% Options

% Reference Point
% RANGE from LiDAR Point of origin
range_bool  = 1;

% Height from RANSAC projected plane
ransac_bool = 0;

% Height from MLS projected plane
mls_bool    = 0;

% LL | L | C | R | RR
% More Left
chan_2_ll_cent      = 130 * pi/180;
chan_3_ll_cent      = 120 * pi/180;
chan_5_ll_cent      = 110 * pi/180;

% Left
chan_2_l_cent       = 110 * pi/180;
chan_3_l_cent       = 105 * pi/180;
chan_5_l_cent       = 100 * pi/180;

% Center is Constant
cent_cent           = 90 * pi/180;

% Right
chan_2_r_cent       = 70 * pi/180;
chan_3_r_cent       = 75 * pi/180;
chan_5_r_cent       = 80 * pi/180;

% More Right
chan_2_rr_cent      = 50 * pi/180;
chan_3_rr_cent      = 60 * pi/180;
chan_5_cent_rr      = 70 * pi/180;

% Angle +- to add to each arc center
chan_2_d_ang        = 4 * pi/180;
chan_3_d_ang        = 3 * pi/180;
chan_5_d_ang        = 2 * pi/180;

% RANSAC - not used atm
% maxDistance         = 0.5;

% Plotting the moving average - how many samples per average?
move_avg_size       = 15;

% Size of figures
fig_size_array          = [10 10 3500 1600];


%% RDF / Rosbag selection

% Which RDF to load?

if range_bool
    
    chan_2_rdf_load_string = 'chan_2_RANGE_rdf.mat';
    chan_5_rdf_load_string = 'chan_5_RANGE_rdf.mat';
    chan_3_rdf_load_string = 'chan_3_RANGE_rdf.mat';
    
elseif ransac_bool
    
    chan_2_rdf_load_string = 'chan_2_RANSAC_rdf.mat';
    chan_5_rdf_load_string = 'chan_5_RANSAC_rdf.mat';
    chan_3_rdf_load_string = 'chan_3_RANSAC_rdf.mat';
    
elseif mls_bool
    
    chan_2_rdf_load_string = 'chan_2_MLS_rdf.mat';
    chan_5_rdf_load_string = 'chan_5_MLS_rdf.mat';
    chan_3_rdf_load_string = 'chan_3_MLS_rdf.mat';
    
end



% roi/rosbag PAIRS - 1 ROI per file

% Gravel Lot TRAINING
% roi_file =
% '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_arc_width_controlol.mat.mat'; % Training source - two seperate one-lane chunks
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/gravel_lot/2023-03-09-14-46-23.bag';

% Pavement 1 TRAINING/VERIFICATION MULIGAN ROAD
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_pavement_1_roi.mat.mat'; % TRAINING SOURCE - Two seperate lanes
% roi_file = 'shortened_coach_sturbois.mat'; % Past training source
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/03_13_2023_shortened_coach_sturbois/2023-03-13-10-56-38.bag';

% Pavement 2  VERIFICAION MULIGAN ROAD
bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_bags_03_23_23/Mulligan_Road_2.bag';
roi_file = 'mulligan_road_2.pcd_20234423140304.mat';


%% Loading RDF

raw_data_export = {};
disp('Loading RDF...')
chan_2_rdf = load(chan_2_rdf_load_string);
chan_3_rdf = load(chan_3_rdf_load_string);
chan_5_rdf = load(chan_5_rdf_load_string);
disp('RDF Loaded!')


%% Variable Initiation

% Reference Frames
LiDAR_Ref_Frame             = [0; 1.584; 1.444];
IMU_Ref_Frame               = [0; 0.336; -0.046];

% Correction frame:         LiDAR_Ref_Frame - IMU_Ref_Frame [Y X Z]
gps_to_lidar_diff           = [(LiDAR_Ref_Frame(1) - IMU_Ref_Frame(1)), (LiDAR_Ref_Frame(2) - IMU_Ref_Frame(2)), (LiDAR_Ref_Frame(3) - IMU_Ref_Frame(3))]; 

% Angle array creation

% Channel 2
% chan_2_ll_angs  = [chan_2_ll_cent   - chan_2_d_ang,     chan_2_ll_cent  + chan_2_d_ang];
% chan_2_l_angs   = [chan_2_l_cent    - chan_2_d_ang,     chan_2_l_cent   + chan_2_d_ang];
% chan_2_c_angs   = [cent_cent        - chan_2_d_ang,     cent_cent       + chan_2_d_ang];
% chan_2_r_angs   = [chan_2_r_cent    - chan_2_d_ang,     chan_2_r_cent   + chan_2_d_ang];
% chan_2_rr_angs  = [chan_2_rr_cent   - chan_2_d_ang,     chan_2_rr_cent  + chan_2_d_ang];

% chan_2_angs     = [chan_2_ll_angs chan_2_l_angs chan_2_c_angs chan_2_r_angs chan_2_rr_angs];
chan_2_strt_angs = [chan_2_ll_cent-chan_2_d_ang chan_2_l_cent-chan_2_d_ang cent_cent-chan_2_d_ang chan_2_r_cent-chan_2_d_ang chan_2_rr_cent-chan_2_d_ang];
chan_2_end_angs  = [chan_2_ll_cent+chan_2_d_ang chan_2_l_cent+chan_2_d_ang cent_cent+chan_2_d_ang chan_2_r_cent+chan_2_d_ang chan_2_rr_cent+chan_2_d_ang];

% Channel 3
% chan_3_ll_angs  = [chan_3_ll_cent   - chan_3_d_ang,     chan_3_ll_cent  + chan_3_d_ang];
% chan_3_l_angs   = [chan_3_l_cent    - chan_3_d_ang,     chan_3_l_cent   + chan_3_d_ang];
% chan_3_c_angs   = [cent_cent        - chan_3_d_ang,     cent_cent       + chan_3_d_ang];
% chan_3_r_angs   = [chan_3_r_cent    - chan_3_d_ang,     chan_3_r_cent   + chan_3_d_ang];
% chan_3_rr_angs  = [chan_3_rr_cent   - chan_3_d_ang,     chan_3_rr_cent  + chan_3_d_ang];

% chan_3_angs     = [chan_3_ll_angs chan_3_l_angs chan_3_c_angs chan_3_r_angs chan_3_rr_angs];
chan_3_strt_angs = [chan_3_ll_cent-chan_3_d_ang chan_3_l_cent-chan_3_d_ang cent_cent-chan_3_d_ang chan_3_r_cent-chan_3_d_ang chan_3_rr_cent-chan_3_d_ang];
chan_3_end_angs  = [chan_3_ll_cent+chan_3_d_ang chan_3_l_cent+chan_3_d_ang cent_cent+chan_3_d_ang chan_3_r_cent+chan_3_d_ang chan_3_rr_cent+chan_3_d_ang];

% Channel 5
% chan_5_ll_angs  = [chan_5_ll_cent   - chan_5_d_ang,     chan_5_ll_cent  + chan_5_d_ang];
% chan_5_l_angs   = [chan_5_l_cent    - chan_5_d_ang,     chan_5_l_cent   + chan_5_d_ang];
% chan_5_c_angs   = [cent_cent        - chan_5_d_ang,     cent_cent       + chan_5_d_ang];
% chan_5_r_angs   = [chan_5_r_cent    - chan_5_d_ang,     chan_5_r_cent   + chan_5_d_ang];
% chan_5_rr_angs  = [chan_5_cent_rr   - chan_5_d_ang,     chan_5_cent_rr  + chan_5_d_ang];

% chan_5_angs     = [chan_5_ll_angs chan_5_l_angs chan_5_c_angs chan_5_r_angs chan_5_rr_angs];
chan_5_strt_angs = [chan_5_ll_cent-chan_5_d_ang chan_5_l_cent-chan_5_d_ang cent_cent-chan_5_d_ang chan_5_r_cent-chan_5_d_ang chan_5_cent_rr-chan_5_d_ang];
chan_5_end_angs  = [chan_5_ll_cent+chan_5_d_ang chan_5_l_cent+chan_5_d_ang cent_cent+chan_5_d_ang chan_5_r_cent+chan_5_d_ang chan_5_cent_rr+chan_5_d_ang];

% all_angs        = [chan_2_angs chan_3_angs chan_5_angs];
all_start_angs  = [chan_2_strt_angs,    chan_3_strt_angs,   chan_5_strt_angs];
all_end_angs    = [chan_2_end_angs,     chan_3_end_angs,    chan_5_end_angs];

% Only certain channels
% all_start_angs  = [chan_2_strt_angs];
% all_end_angs    = [chan_2_end_angs];
% all_start_angs  = [chan_3_strt_angs];
% all_end_angs    = [chan_3_end_angs];
% all_start_angs  = [chan_5_strt_angs];
% all_end_angs    = [chan_5_end_angs];

% Names for channel
area_names = [];

% Array Inits
% Chan 2
grav_array_temp_2         = []; asph_array_temp_2       = []; foli_array_temp_2       = []; gras_array_temp_2       = []; 
grav_avg_array_temp_2     = []; asph_avg_array_temp_2   = []; foli_avg_array_temp_2   = []; gras_avg_array_temp_2   = []; 
Grav_All_Append_Array_2   = []; Asph_All_Append_Array_2 = []; Foli_All_Append_Array_2 = []; Gras_All_Append_Array_2 = [];
Grav_Avg_Append_Array_2   = []; Asph_Avg_Append_Array_2 = []; Foli_Avg_Append_Array_2 = []; Gras_Avg_Append_Array_2 = [];

% Chan 3
grav_array_temp_3         = []; asph_array_temp_3       = []; foli_array_temp_3       = []; gras_array_temp_3       = []; 
grav_avg_array_temp_3     = []; asph_avg_array_temp_3   = []; foli_avg_array_temp_3   = []; gras_avg_array_temp_3   = []; 
Grav_All_Append_Array_3   = []; Asph_All_Append_Array_3 = []; Foli_All_Append_Array_3 = []; Gras_All_Append_Array_3 = [];
Grav_Avg_Append_Array_3   = []; Asph_Avg_Append_Array_3 = []; Foli_Avg_Append_Array_3 = []; Gras_Avg_Append_Array_3 = [];

% Chan 5
grav_array_temp_5         = []; asph_array_temp_5       = []; foli_array_temp_5       = []; gras_array_temp_5       = []; 
grav_avg_array_temp_5     = []; asph_avg_array_temp_5   = []; foli_avg_array_temp_5   = []; gras_avg_array_temp_5   = []; 
Grav_All_Append_Array_5   = []; Asph_All_Append_Array_5 = []; Foli_All_Append_Array_5 = []; Gras_All_Append_Array_5 = [];
Grav_Avg_Append_Array_5   = []; Asph_Avg_Append_Array_5 = []; Foli_Avg_Append_Array_5 = []; Gras_Avg_Append_Array_5 = [];

raw_data_export = []; save_folder = [];
model_RANSAC = []; model_MLS = [];

pcd_class_rate = [];

% Legend Stuff
h = zeros(1,3);



%% Load Stuff

% Load the ROI file. If one is not provided ROIS will obv. not be plotted
if ~isempty(roi_file)
    load(roi_file);
else
    Manual_Classfied_Areas = [];
end

% Load the rosbag into the workspace
disp('Loading ROSBAG')
bag = rosbag(bag_file);
disp('ROSBAG Loaded')

% Topics
disp('Loading Messages...')
topics = bag.AvailableTopics;
          
disp('Loading LIDAR Messages...')
lidar_topic = select(bag,'Topic','velodyne_points');
lidar_msgs = readMessages(lidar_topic, 'DataFormat', 'struct');

disp('Loading GPS Messages... ')
gps_topic = select(bag,'Topic','/gps/gps');
gps_msgs = readMessages(gps_topic, 'DataFormat', 'struct');

disp('Messages Loaded')


%% Save Location

time_now        = datetime("now","Format","uuuuMMddhhmmss");
time_now        = datestr(time_now,'yyyyMMddhhmmss');

export_dir = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Chan_2_3_5_" + string(time_now);

if ~exist(export_dir,'dir')
    mkdir(export_dir)
end

% addpath(root_dir)
% CLASSIFICATION_STACK_FOLDER = string(root_dir) + "/CLASSIFICATION_STACK";
% mkdir(CLASSIFICATION_STACK_FOLDER);
addpath(export_dir);


%% More Var Init

% cloud_break                 = 20;
cloud_break                 = length(lidar_msgs);
gps_pos_store               = zeros(cloud_break,3);
lidar_pos_store             = gps_pos_store;

% RANSAC - MATLAB
maxDistance                 = 0.5;


%% Timestamps

% Matching timestamps
[indexes, fromTimes, toTimes, diffs] = matchTimestamps(lidar_msgs, gps_msgs);

%Find which GPS message matches the first scan
matchedLidar                = lidar_msgs{1};
matchedGps_init             = gps_msgs{indexes(1)};


%% Initilizing the starting point
% Select reference point as first GPS reading (local)
origin = [matchedGps_init.Latitude, matchedGps_init.Longitude, matchedGps_init.Altitude];

% Setting the offset from the gps orientation to the lidar
% takes gps emu to local frame of lidar
gps2lidar = [ cosd(90) sind(90) 0;
             -sind(90) cosd(90) 0;
             0       0          1]; 
         
% Setting the (gps_to_lidar_diff) offset from the lidar offset to the gps
LidarOffset2gps = [ cosd(90) -sind(90)  0;
                    sind(90)  cosd(90)   0;
                    0        0           1]; 

fprintf('Max time delta is %f sec \n',max(abs(diffs)));


%% Classifying the Rosbag

% TO-DO: Re-make so that the results are not saved to disk but saved to
% memory, makes loading results way faster.

% Rate of classification rate per 360 scan
pcd_class_rate = Par(int64(cloud_break));

% Progress bar
parfor_progress(cloud_break);

% Classifying per 360 scan
parfor cloud = 1:cloud_break
  
    %% Clearing Vars
    
    xyz_cloud = [];
    xyzi_grab = [];
    tform = [];
    current_cloud = [];
    intensities = [];
    ring = [];
    
    %% Grabbing Data
    
    % Reading the current point cloud and matched gps coord
    current_cloud               = lidar_msgs{cloud};
    matched_stamp               = gps_msgs{indexes(cloud)};
    
    % Converting the gps coord to xyz (m)
    [xEast, yNorth, zUp]        = latlon2local(matched_stamp.Latitude, matched_stamp.Longitude, matched_stamp.Altitude, origin);
    
    % Grabbing the angles
    roll                        = matched_stamp.Roll;
    pitch                       = matched_stamp.Pitch;
    yaw                         = matched_stamp.Track+180;
    
    %% Rectifying Frames
     
    % Creating the rotation matrix
    rotate_update               = rotz(90-yaw)*roty(roll)*rotx(pitch);
     
    % Offset the gps coord by the current orientation (in this case, initial) 
    % Converts the ground truth to lidar frame
    groundTruthTrajectory       = [xEast, yNorth, zUp] * gps2lidar ;
    
    % Setting the updated difference between the lidar and gps coordiate and
    % orientation
    % Converts the offsett to the lidar frame
    gps_to_lidar_diff_update    = gps_to_lidar_diff * LidarOffset2gps * rotate_update;

    % Offset the gps coord by the current orientation (in this case, initial) 
    % Converts the ground truth to lidar frame
    LidarxEast                  = groundTruthTrajectory(1)  + gps_to_lidar_diff_update(1);
    LidaryNorth                 = groundTruthTrajectory(2)  + gps_to_lidar_diff_update(2);
    LidarzUp                    = groundTruthTrajectory(3)  + gps_to_lidar_diff_update(3);

    % Making the vector of ^^^
    lidarTrajectory             = [LidarxEast, LidaryNorth, LidarzUp];
    
    % Creating the transform
    tform                       = rigid3d(rotate_update, [lidarTrajectory(1) lidarTrajectory(2) lidarTrajectory(3)]);
    
    % Reading the current cloud for xyz, intensity, and ring (channel) values
    xyz_cloud                   = rosReadXYZ(current_cloud);
    intensities                 = rosReadField(current_cloud, 'intensity');
    ring                        = rosReadField(current_cloud, 'ring');
    xyz_cloud(:,4)              = intensities;
    xyz_cloud(:,5)              = ring;
    
    %% RANSAC and MLS
    
    if mls_bool
        
        % MLS
        xyz_mll                     = [xyz_cloud(:,1) xyz_cloud(:,2) xyz_cloud(:,3)];
        model_MLS                   = MLL_plane_proj(xyz_mll(isfinite(xyz_mll(:,1)), :));
        abcd                        = [model_MLS.a, model_MLS.b, model_MLS.c, model_MLS.d];
        
    elseif ransac_bool
        
        % RANSAC - MATLAB
        ptCloudSource               = pointCloud([xyz_cloud(:,1), xyz_cloud(:,2), xyz_cloud(:,3)], 'Intensity', xyz_cloud(:,4));
        model_RANSAC                = pcfitplane(ptCloudSource, maxDistance);
        abcd                        = [model_RANSAC.Parameters(1), model_RANSAC.Parameters(2), model_RANSAC.Parameters(3), model_RANSAC.Parameters(4)];
        
    end
    
    
    %% Trimming data
    
    % Data Clean-up
    xyz_cloud = xyz_cloud( ~any( isnan(xyz_cloud) | isinf(xyz_cloud), 2),:);
    xyz_cloud = xyz_cloud(xyz_cloud(:,1) >= 0, :);

    % Channel Split
    xyz_cloud_2 = xyz_cloud(xyz_cloud(:,5) == 1, :); % indexes start @ 0
    xyz_cloud_3 = xyz_cloud(xyz_cloud(:,5) == 2, :); % indexes start @ 0
    xyz_cloud_5 = xyz_cloud(xyz_cloud(:,5) == 4, :); % indexes start @ 0
    
    % DEBUG
%     figure
%     ptCloudSource = pointCloud([xyz_cloud(:,1), xyz_cloud(:,2), xyz_cloud(:,3)], 'Intensity',  xyz_cloud(:,4));
%     pcshow(ptCloudSource)
%     pause


    %% Getting Left | Center | Right areas
    
    Par.tic;
    
    for area_find_idx = 1:length(all_start_angs)

        if any(area_find_idx == 1:5) % Channel 2

            % Find Indexes
            arc_idx     = find((atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) > all_start_angs(area_find_idx) & (atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) <  all_end_angs(area_find_idx));

            % Grabbing Features
            if range_bool
                table_export = get_feats_2(xyz_cloud_2(arc_idx,:), []);
            elseif ransac_bool
                table_export = get_RANSAC_feats_2(xyz_cloud_2(arc_idx,:),abcd);
            elseif mls_bool
                disp('nothing here');
            end

            % Classifying
            [Yfit, scores, stdevs]              = predict(chan_2_rdf.Mdl, table_export);

            %Creates pcd file name
            n_strPadded             = sprintf('%08d', cloud);
            Classification_FileName = string(export_dir) + "/2_" + string(area_find_idx) + "_" + string(n_strPadded) + ".mat";

            % Saves it
            RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_2(arc_idx,:), tform)
            
        elseif any(area_find_idx == 6:10) % Channel 5

            % Find Indexes
            arc_idx     = find((atan2(xyz_cloud_3(:,1), xyz_cloud_3(:,2))) > all_start_angs(area_find_idx) & (atan2(xyz_cloud_3(:,1), xyz_cloud_3(:,2))) <  all_end_angs(area_find_idx));

            % Grabbing Features
            if range_bool
                table_export = get_feats_2(xyz_cloud_3(arc_idx,:), []);
            elseif ransac_bool
                table_export = get_RANSAC_feats_2(xyz_cloud_3(arc_idx,:),abcd);
            elseif mls_bool
                disp('nothing here');
            end

            % Classifying
            [Yfit, scores, stdevs]              = predict(chan_3_rdf.Mdl, table_export);

            %Creates pcd file name
            n_strPadded             = sprintf('%08d', cloud);
            Classification_FileName = string(export_dir) + "/3_" + string(area_find_idx) + "_" + string(n_strPadded) + ".mat";

            % Saves it
            RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_3(arc_idx,:), tform)

        elseif any(area_find_idx == 11:15) % Channel 5

            % Find Indexes
            arc_idx     = find((atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) > all_start_angs(area_find_idx) & (atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) <  all_end_angs(area_find_idx));

            % Grabbing Features
            if range_bool
                table_export = get_feats_2(xyz_cloud_5(arc_idx,:), []);
            elseif ransac_bool
                table_export = get_RANSAC_feats_2(xyz_cloud_5(arc_idx,:),abcd);
            elseif mls_bool
                disp('nothing here');
            end
            
            % Classifying
            [Yfit, scores, stdevs]              = predict(chan_5_rdf.Mdl, table_export);

            %Creates pcd file name
            n_strPadded             = sprintf('%08d', cloud);
            Classification_FileName = string(export_dir) + "/5_" + string(area_find_idx) + "_" + string(n_strPadded) + ".mat";

            % Saves it
            RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_5(arc_idx,:), tform)
            
        end
        
    end
    
    pcd_class_rate(cloud) = Par.toc;
    

    %% Weightbar
    
	parfor_progress;

end

stop(pcd_class_rate)

parfor_progress(0);


%% Load the Classification folder and grab the results

classification_list             = dir(fullfile(export_dir,'/*.mat'));

num_files                       = length(classification_list);


%% Apphending all the results to an array

load_result_bar = waitbar(0, "Loading Files...");

for class_idx = 1:1:num_files
    
    % Starting the timer for the progress bar estimated time
%     tform_start = tic;

    %% Clearing Vars

%     grav_array_temp_2         = []; asph_array_temp_2       = []; gras_array_temp_2       = []; 
%     grav_avg_array_temp_2     = []; asph_avg_array_temp_2   = []; gras_avg_array_temp_2   = []; 
%     
%     grav_array_temp_3         = []; asph_array_temp_3       = []; gras_array_temp_3       = []; 
%     grav_avg_array_temp_3     = []; asph_avg_array_temp_3   = []; gras_avg_array_temp_3   = []; 
%     
%     grav_array_temp_5         = []; asph_array_temp_5       = []; gras_array_temp_5       = []; 
%     grav_avg_array_temp_5     = []; asph_avg_array_temp_5   = []; gras_avg_array_temp_5   = []; 
%     
    label_cell = [];

    
    %% Loading Classification

    load(classification_list(class_idx).name)
    
%     underscore_idx = strfind(classification_list(class_idx).name, '_');
    
    chan_number = str2double(classification_list(class_idx).name(1:1));
    
    
    %% Grabbing the Classification Results

    % Go through all the classification results
%     parfor result_idx = 1:1:length(Classification_Result)
        
        label                       = Classification_Result.label;
        
        % I was messing around with the MATLAB machine learning app, this
        % catches the classification label and re-formats it to the correct
        % format for the later code. 
        
        try
            label = cellstr(label);
        catch
%             warning('Label may be incorrectly formatted')
        end
        
%         scores                      = Classification_Result(result_idx).scores;
%         stdevs                      = Classification_Result(result_idx).stdevs;
        
        % If the labelresult is not empty, grab the xyz data according to 
        % the label. 
        % I supply two types of arrays - one having all the points and one
        % having the average xyz of the points per classified quadrant
%     if ~isempty(Classification_Result.label) && chan_number == 2
% 
%         if isequal(cell2mat(label), 'gravel')
%             grav_array_temp_2         = [grav_array_temp_2; Classification_Result.xyzi];
%             grav_avg_array_temp_2     = [grav_avg_array_temp_2; Classification_Result.avg_xyz];
%         end
% 
%         if isequal(cell2mat(label), 'asphalt')
%             asph_array_temp_2         = [asph_array_temp_2; Classification_Result.xyzi];
%             asph_avg_array_temp_2     = [asph_avg_array_temp_2; Classification_Result.avg_xyz];
%         end
% 
%         if isequal(cell2mat(label), 'grass')
%             gras_array_temp_2         = [gras_array_temp_2; Classification_Result.xyzi];
%             gras_avg_array_temp_2     = [gras_avg_array_temp_2; Classification_Result.avg_xyz];
% 
%         end
% 
%     elseif ~isempty(Classification_Result.label) && chan_number == 3
% 
%         if isequal(cell2mat(label), 'gravel')
%             grav_array_temp_3         = [grav_array_temp_3; Classification_Result.xyzi];
%             grav_avg_array_temp_3     = [grav_avg_array_temp_3; Classification_Result.avg_xyz];
%         end
% 
%         if isequal(cell2mat(label), 'asphalt')
%             asph_array_temp_3         = [asph_array_temp_3; Classification_Result.xyzi];
%             asph_avg_array_temp_3     = [asph_avg_array_temp_3; Classification_Result.avg_xyz];
%         end
% 
%         if isequal(cell2mat(label), 'grass')
%             gras_array_temp_3         = [gras_array_temp_3; Classification_Result.xyzi];
%             gras_avg_array_temp_3     = [gras_avg_array_temp_3; Classification_Result.avg_xyz];
%         end
% 
%     elseif ~isempty(Classification_Result.label) && chan_number == 5
% 
%         if isequal(cell2mat(label), 'gravel')
%             grav_array_temp_5         = [grav_array_temp_5; Classification_Result.xyzi];
%             grav_avg_array_temp_5     = [grav_avg_array_temp_5; Classification_Result.avg_xyz];
%         end
% 
%         if isequal(cell2mat(label), 'asphalt')
%             asph_array_temp_5         = [asph_array_temp_5; Classification_Result.xyzi];
%             asph_avg_array_temp_5     = [asph_avg_array_temp_5; Classification_Result.avg_xyz];
%         end
% 
%         if isequal(cell2mat(label), 'grass')
%             gras_array_temp_5         = [gras_array_temp_5; Classification_Result.xyzi];
%             gras_avg_array_temp_5     = [gras_avg_array_temp_5; Classification_Result.avg_xyz];
%         end
% 
%     end % Go through all the result

    %% Apphending all results
    
    % I supply two types of arrays - one having all the points and one
    % having the average xyz of the points per classified quadrant

    % Channel 2
    if isequal(cell2mat(label), 'gravel')   && chan_number == 2
        Grav_All_Append_Array_2             = [Grav_All_Append_Array_2; Classification_Result.xyzi];
        Grav_Avg_Append_Array_2             = [Grav_Avg_Append_Array_2; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'asphalt')  && chan_number == 2
        Asph_All_Append_Array_2             = [Asph_All_Append_Array_2; Classification_Result.xyzi];
        Asph_Avg_Append_Array_2             = [Asph_Avg_Append_Array_2; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'grass')    && chan_number == 2
        Gras_All_Append_Array_2             = [Gras_All_Append_Array_2; Classification_Result.xyzi];
        Gras_Avg_Append_Array_2             = [Gras_Avg_Append_Array_2; Classification_Result.avg_xyz];
    end
    
    % Channel 3
    if isequal(cell2mat(label), 'gravel')   && chan_number == 3
        Grav_All_Append_Array_3             = [Grav_All_Append_Array_3; Classification_Result.xyzi];
        Grav_Avg_Append_Array_3             = [Grav_Avg_Append_Array_3; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'asphalt')  && chan_number == 3
        Asph_All_Append_Array_3             = [Asph_All_Append_Array_3; Classification_Result.xyzi];
        Asph_Avg_Append_Array_3             = [Asph_Avg_Append_Array_3; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'grass') 	&& chan_number == 3
        Gras_All_Append_Array_3             = [Gras_All_Append_Array_3; Classification_Result.xyzi];
        Gras_Avg_Append_Array_3             = [Gras_Avg_Append_Array_3; Classification_Result.avg_xyz];
    end
    
    % Channel 5
    if isequal(cell2mat(label), 'gravel')   && chan_number == 5
        Grav_All_Append_Array_5             = [Grav_All_Append_Array_5; Classification_Result.xyzi];
        Grav_Avg_Append_Array_5             = [Grav_Avg_Append_Array_5; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'asphalt')  && chan_number == 5
        Asph_All_Append_Array_5             = [Asph_All_Append_Array_5; Classification_Result.xyzi];
        Asph_Avg_Append_Array_5             = [Asph_Avg_Append_Array_5; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'grass')    && chan_number == 5
        Gras_All_Append_Array_5             = [Gras_All_Append_Array_5; Classification_Result.xyzi];
        Gras_Avg_Append_Array_5             = [Gras_Avg_Append_Array_5; Classification_Result.avg_xyz];
    end
    
    %% Weightbar
    
    if class_idx == 69
        waitbar(class_idx/num_files, load_result_bar, sprintf('File %d out of %d NICE',class_idx, num_files))
    elseif class_idx == 420
        waitbar(class_idx/num_files, load_result_bar, sprintf('File %d out of %d NICE',class_idx, num_files))
    else
        waitbar(class_idx/num_files, load_result_bar, sprintf('File %d out of %d',class_idx, num_files))
    end
    

end % Going through the transform list

close(load_result_bar)

%% Score the Results

avg_cell_store{2}.Grav = Grav_Avg_Append_Array_2;
avg_cell_store{2}.Asph = Asph_Avg_Append_Array_2;
avg_cell_store{2}.Gras = Gras_Avg_Append_Array_2;

avg_cell_store{3}.Grav = Grav_Avg_Append_Array_3;
avg_cell_store{3}.Asph = Asph_Avg_Append_Array_3;
avg_cell_store{3}.Gras = Gras_Avg_Append_Array_3;

avg_cell_store{5}.Grav = Grav_Avg_Append_Array_5;
avg_cell_store{5}.Asph = Asph_Avg_Append_Array_5;
avg_cell_store{5}.Gras = Gras_Avg_Append_Array_5;

% Score Fun
class_score_function(avg_cell_store, Manual_Classfied_Areas)


%% Plotting all points

disp('Plotting Results')

try
    
    x_min_lim = min([Grav_All_Append_Array_2(:,1); Asph_All_Append_Array_2(:,1); Gras_All_Append_Array_2(:,1)]) - 5;
    x_max_lim = max([Grav_All_Append_Array_2(:,1); Asph_All_Append_Array_2(:,1); Gras_All_Append_Array_2(:,1)]) + 5;

    y_min_lim = min([Grav_All_Append_Array_2(:,2); Asph_All_Append_Array_2(:,2); Gras_All_Append_Array_2(:,2)]) - 5;
    y_max_lim = max([Grav_All_Append_Array_2(:,2); Asph_All_Append_Array_2(:,2); Gras_All_Append_Array_2(:,2)]) + 5;
    
    
catch
    
    x_min_lim = -100;
    x_max_lim = 100;
    y_min_lim = -100;
    y_max_lim = 100;
    
end

% All points
result_all_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);

hold all

% Channel 2
try
    plot3(Grav_All_Append_Array_2(:,1), Grav_All_Append_Array_2(:,2), Grav_All_Append_Array_2(:,3), 'c.', 'MarkerSize', 10)
catch
    disp('No Grav Data on Chan 2!')
end
   
try
    plot3(Asph_All_Append_Array_2(:,1), Asph_All_Append_Array_2(:,2), Asph_All_Append_Array_2(:,3), 'k.', 'MarkerSize', 10)
catch
    disp('No Asph Dataon Chan 2!')
end

try
    plot3(Gras_All_Append_Array_2(:,1), Gras_All_Append_Array_2(:,2), Gras_All_Append_Array_2(:,3), 'g.', 'MarkerSize', 10)
catch
    disp('No Gras Dataon Chan 2!')
end

% Channel 3
try
    plot3(Grav_All_Append_Array_3(:,1), Grav_All_Append_Array_3(:,2), Grav_All_Append_Array_3(:,3), 'c^', 'MarkerSize', 10)
catch
    disp('No Grav Data on Chan 2!')
end
   
try
    plot3(Asph_All_Append_Array_3(:,1), Asph_All_Append_Array_3(:,2), Asph_All_Append_Array_3(:,3), 'k^', 'MarkerSize', 10)
catch
    disp('No Asph Dataon Chan 2!')
end

try
    plot3(Gras_All_Append_Array_3(:,1), Gras_All_Append_Array_3(:,2), Gras_All_Append_Array_3(:,3), 'g^', 'MarkerSize', 10)
catch
    disp('No Gras Dataon Chan 2!')
end

% Channel 5
try
    plot3(Grav_All_Append_Array_5(:,1), Grav_All_Append_Array_5(:,2), Grav_All_Append_Array_5(:,3), 'cx', 'MarkerSize', 10)
catch
    disp('No Grav Data on Chan 5!')
end
   
try
    plot3(Asph_All_Append_Array_5(:,1), Asph_All_Append_Array_5(:,2), Asph_All_Append_Array_5(:,3), 'kx', 'MarkerSize', 10)
catch
    disp('No Asph Data on Chan 5!')
end

try
    plot3(Gras_All_Append_Array_5(:,1), Gras_All_Append_Array_5(:,2), Gras_All_Append_Array_5(:,3), 'gx', 'MarkerSize', 10)
catch
    disp('No Gras Data on Chan 5!')
end

axis('equal')
axis off
view([pi/2 0 90])

MCA_plotter(Manual_Classfied_Areas)

xlim([x_min_lim x_max_lim]);
ylim([y_min_lim y_max_lim]);

h(1) = plot(NaN,NaN,'oc');
h(2) = plot(NaN,NaN,'ok');
h(3) = plot(NaN,NaN,'og');
l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

ax = gca;
ax.Clipping = 'off';


%% Average points

result_avg_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);

hold all

% Channel 2
try
    plot3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), 'co', 'MarkerSize', 8.5, 'Linewidth', 5)
catch
    disp('No Grav Data on Chan 2!')
end

try   
    plot3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), 'ko', 'MarkerSize', 8.5, 'Linewidth', 5)
catch
    disp('No Asph Data on Chan 2!')
end

try
    plot3(Gras_Avg_Append_Array_2(:,1), Gras_Avg_Append_Array_2(:,2), Gras_Avg_Append_Array_2(:,3), 'go', 'MarkerSize', 8.5, 'Linewidth', 5)
catch
    disp('No Gras Data on Chan 2!')
end


% Channel 3
try
    plot3(Grav_Avg_Append_Array_3(:,1), Grav_Avg_Append_Array_3(:,2), Grav_Avg_Append_Array_3(:,3), 'c^', 'MarkerSize', 8.5, 'Linewidth', 5)
catch
    disp('No Grav Data on Chan 3!')
end

try   
    plot3(Asph_Avg_Append_Array_3(:,1), Asph_Avg_Append_Array_3(:,2), Asph_Avg_Append_Array_3(:,3), 'k^', 'MarkerSize', 8.5, 'Linewidth', 5)
catch
    disp('No Asph Data on Chan 3!')
end

try
    plot3(Gras_Avg_Append_Array_3(:,1), Gras_Avg_Append_Array_3(:,2), Gras_Avg_Append_Array_3(:,3), 'g^', 'MarkerSize', 8.5, 'Linewidth', 5)
catch
    disp('No Gras Data on Chan 3!')
end


% Channel 5
try
    plot3(Grav_Avg_Append_Array_5(:,1), Grav_Avg_Append_Array_5(:,2), Grav_Avg_Append_Array_5(:,3), 'cx', 'MarkerSize', 15, 'Linewidth', 5)
catch
    disp('No Grav Data on Chan 5!')
end

try   
    plot3(Asph_Avg_Append_Array_5(:,1), Asph_Avg_Append_Array_5(:,2), Asph_Avg_Append_Array_5(:,3), 'kx', 'MarkerSize', 15, 'Linewidth', 5)
catch
    disp('No Asph Data on Chan 5!')
end

try
    plot3(Gras_Avg_Append_Array_5(:,1), Gras_Avg_Append_Array_5(:,2), Gras_Avg_Append_Array_5(:,3), 'gx', 'MarkerSize', 15, 'Linewidth', 5)
catch
    disp('No Gras Data on Chan 5!')
end

axis('equal')
axis off
view([pi/2 0 90])

hold on

MCA_plotter(Manual_Classfied_Areas)
% 
% pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
% plot(pgon,'FaceColor',color,'FaceAlpha',0.15)
% 
% try
%     pgon_2 = polyshape(to_plot_xy_roi_2(:,1),to_plot_xy_roi_2(:,2));
%     plot(pgon_2,'FaceColor',color,'FaceAlpha',0.15)
% catch
%     disp('Only 1 area')
% end

xlim([x_min_lim x_max_lim]);
ylim([y_min_lim y_max_lim]);

h(1) = plot(NaN,NaN,'oc');
h(2) = plot(NaN,NaN,'ok');
h(3) = plot(NaN,NaN,'og');
l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

ax2 = gca;
ax2.Clipping = 'off';


%% PCD Classification Rate

% plot(pcd_class_rate)

time_extract        = pcd_class_rate.par2struct;
time_extract        = (time_extract.ItStop - time_extract.ItStart) / max(time_extract.Worker);

max_time            = max(time_extract); %s
min_time            = min(time_extract); %s

max_Hz              = 1 / min(time_extract); %Hz
min_Hz              = 1 / max(time_extract); %Hz

pcd_class_rate_Hz    =  time_extract.^(-1);

Move_mean_time      = movmean(time_extract, move_avg_size);
Move_mean_Hz        = movmean(pcd_class_rate_Hz, move_avg_size);

rate_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10  1400 500]);

hold on

plot(time_extract, 'b')
plot(Move_mean_time, 'r', 'LineWidth', 3)

l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

hold off
% axis('equal')

xlabel('360 Scan')
ylabel('Time (s)')

ylim([min_time max_time])

hold off

% Classification Rate Hz

hz_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500]);

hold all

plot(pcd_class_rate_Hz, 'b')
plot(Move_mean_Hz, 'r', 'LineWidth', 3)

% axis('equal')

xlabel('360 Scan')
ylabel('Hz')

 l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4, 'Location', 'southeast');
    l.Interpreter = 'tex';

hold off


%% End Program 

disp('End Program!')