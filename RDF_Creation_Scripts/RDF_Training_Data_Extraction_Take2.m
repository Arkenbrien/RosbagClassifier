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
% chan_2_ll_cent      = 170 * pi/180;
% chan_3_ll_cent      = 170 * pi/180;
% chan_5_ll_cent      = 170 * pi/180;

% Left
% chan_2_l_cent       = 105 * pi/180;
% chan_3_l_cent       = 105  * pi/180;
% chan_5_l_cent       = 95 * pi/180;

% Center is Constant
% cent_cent           = 90 * pi/180;

chan_2_d_ang        = 3;
chan_3_d_ang        = 3;
chan_4_d_ang        = 3;
chan_5_d_ang        = 2.5;

chan_2_c_bounds     = [((90 - chan_2_d_ang) * pi/180), ((90 + chan_2_d_ang) * pi/180)];
chan_3_c_bounds     = [((90 - chan_3_d_ang) * pi/180), ((90 + chan_3_d_ang) * pi/180)];
chan_4_c_bounds     = [((90 - chan_4_d_ang) * pi/180), ((90 + chan_4_d_ang) * pi/180)];
chan_5_c_bounds     = [((90 - chan_5_d_ang) * pi/180), ((90 + chan_5_d_ang) * pi/180)];

chan_2_l_bounds     = [((135 - chan_2_d_ang) * pi/180), ((135 + chan_2_d_ang) * pi/180)];
chan_3_l_bounds     = [((135 - chan_3_d_ang) * pi/180), ((135 + chan_3_d_ang) * pi/180)];
chan_4_l_bounds     = [((135 - chan_4_d_ang) * pi/180), ((135 + chan_4_d_ang) * pi/180)];
chan_5_l_bounds     = [((135 - chan_5_d_ang) * pi/180), ((135 + chan_5_d_ang) * pi/180)];

chan_2_r_bounds     = [((45 - chan_2_d_ang) * pi/180), ((45 + chan_2_d_ang) * pi/180)];
chan_3_r_bounds     = [((45 - chan_3_d_ang) * pi/180), ((45 + chan_3_d_ang) * pi/180)];
chan_4_r_bounds     = [((45 - chan_4_d_ang) * pi/180), ((45 + chan_4_d_ang) * pi/180)];
chan_5_r_bounds     = [((45 - chan_5_d_ang) * pi/180), ((45 + chan_5_d_ang) * pi/180)];

% Right
% chan_2_r_cent       = 75 * pi/180;
% chan_3_r_cent       = 85 * pi/180;
% chan_5_r_cent       = 80 * pi/180;

% More Right
% chan_2_rr_cent      = 10 * pi/180;
% chan_3_rr_cent      = 10 * pi/180;
% chan_5_cent_rr      = 10 * pi/180;

% Angle +- to add to each arc center
% chan_2_d_ang        = 3 * pi/180;
% chan_3_d_ang        = 2 * pi/180;
% chan_5_d_ang        = 2 * pi/180;

% RANSAC Options
maxDistance         = 0.5;

% Plotting the moving average - how many samples per average?
move_avg_size       = 15;

% Size of figures
fig_size_array          = [10 10 3500 1600];


%% roi/rosbag PAIRS - 1 ROI per file

% Gravel Lot 1
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_arc_width_controlol.mat.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/gravel_lot/2023-03-09-14-46-23.bag';
% terrain_opt = 1;
% roi_select = 1;

% Gravel Lot 2, 3
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_gravel_lot_2_2rois.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/gravel_lot/2023-03-14-13-12-31.bag';
% terrain_opt = 1;
% roi_select = 1; % 1, 2

% Lawn Grass 1
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/Manual_Classified_PCD_2022-10-20-10-17-31_CHIP_ALL_for_grass.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Armitage_Shortened_Bags/2022-10-20-10-17-31_CHIP.bag';
% terrain_opt = 4;
% roi_select = 1;

% Lawn Grass 2
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/Manual_Classified_PCD_2022-10-20-10-21-54_CHIP_ALL_for_grass.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Armitage_Shortened_Bags/2022-10-20-10-21-54_CHIP.bag';
% terrain_opt = 4;
% roi_select = 1;

% Pavement 1, 2
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_pavement_1_roi.mat.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/03_13_2023_shortened_coach_sturbois/2023-03-13-10-56-38.bag';
% terrain_opt = 5;
% roi_select = 2; %1,2

% Lawn Grass 3
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_blue_route_grass_roi.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/blue_short/2023-03-15-14-09-13.bag';
% terrain_opt = 4;
% roi_select = 1;

% Pavement 3, 4 - blue_route
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_blue_route_asphalt_roiz.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/blue_short/2023-03-15-14-09-13.bag';
% terrain_opt = 5;
% roi_select = 1; %1,2,3

% Gravel Lot Interception files
% Down 1
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/03_29_14_54_16_all.pcd_20232103130404.mat'; terrain_opt = 6; asph2
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/2023-03-29-14-54-16.bag';
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/foliage_grab_2FROMFILE2023-03-29-14-54-16.pcd_20230904140433.mat'; terrain_opt = 3;
% roi_select = 1;

% Down 2
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/Down_2_03_29_14_57_17_25to150.pcd.pcd_20233803100451.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/2023-03-29-14-57-17.bag';
% roi_select = 1;

% Down 3
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/Down_3_29_14_59_48_250to400.pcd.pcd_20234003100412.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/2023-03-29-14-59-48.bag';
% roi_select = 1;

% Up 1
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/Up_1_29_14_53_21_1tolen.pcd_20234103100425.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/2023-03-29-14-53-21.bag';
% roi_select = 1;

% Up 2
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/2023-03-29-14-55-44.bag.mat'; terrain_opt = 6;
% % roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/foliage_grab_FROM_FILE_2023-03-29-14-55-44_20230104140446.mat'; terrain_opt = 3;
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/2023-03-29-14-55-44.bag';
% roi_select = 1;

% Up 3
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/Up_3_14_58_13_325to450.pcd.pcd_20234303100447.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/2023-03-29-14-58-13.bag';
% roi_select = 1;

% ======================================================================= %

% Redmen Gravel Lot: rm_1 - rm_11
bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/rm_1.bag';
roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/pcd/r_u_a_grav/rm_1.mat';
terrain_opt = 1;
roi_select = 1; %1 = 1,2,3; 2 = 1,2
side_select = 3; %1 = l, 2 = c, 3 = r

% Redmen Gravel Lot Drive-by: rm_db_1 - rm_db_6
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_6.bag';
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/rm_db_6_2.mat'; % rm_db_5 == no good, passing car ruins data plus other shenanigens; rm_db_6 = roi_1, rm_db_6_2 = roi_2
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/SoR_Looks/rm_db_6_SOR.mat'; terrain_opt = 7; 
% terrain_opt = 5;
% roi_select = 1;

% Redmen Gravel Lot Grass Collection: rm_13 15 17 18 19 20 22 23 25 27 29 30 32
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/rm_13.bag';
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/pcd/r_u_a_gras/rm_13.mat';
% terrain_opt = 4;
% roi_select = 1;
% side_select = 3;

%% Variable Initiation

thing2_count = 1;
thing3_count = 1;
thing4_count = 1;
thing5_count = 1;

% Reference Frames
LiDAR_Ref_Frame             = [0; 1.584; 1.444];
IMU_Ref_Frame               = [0; 0.336; -0.046];

% Correction frame:         LiDAR_Ref_Frame - IMU_Ref_Frame [Y X Z]
gps_to_lidar_diff           = [(LiDAR_Ref_Frame(1) - IMU_Ref_Frame(1)), (LiDAR_Ref_Frame(2) - IMU_Ref_Frame(2)), (LiDAR_Ref_Frame(3) - IMU_Ref_Frame(3))]; 

% Array Inits
% Chan 2
grav_array_temp_2         = []; asph_array_temp_2       = []; foli_array_temp_2       = []; gras_array_temp_2       = []; 
grav_avg_array_temp_2     = []; asph_avg_array_temp_2   = []; foli_avg_array_temp_2   = []; gras_avg_array_temp_2   = []; 
Grav_All_Append_Array_2   = []; Asph_All_Append_Array_2 = []; Foli_All_Append_Array_2 = []; Gras_All_Append_Array_2 = [];
Grav_Avg_Append_Array_2   = []; Asph_Avg_Append_Array_2 = []; Foli_Avg_Append_Array_2 = []; Gras_Avg_Append_Array_2 = [];

chan_2_feat_table = table(); chan_3_feat_table = table(); chan_4_feat_table = table(); chan_5_feat_table = table();

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
    disp('ROI FILE BAD or something idk what')
end

% Load the rosbag into the workspace
disp('Loading ROSBAG (takes a while!)')
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

cloud_break                 = length(lidar_msgs);
gps_pos_store               = zeros(cloud_break,3);
lidar_pos_store             = gps_pos_store;


%% Save Location & ROI setup

time_now        = datetime("now","Format","uuuuMMddhhmmss");
time_now        = datestr(time_now,'yyyyMMddhhmmss');

[~, bag_name, ~] = fileparts(bag_file);

if terrain_opt == 1
    terrain_type    = 'gravel';
    save_folder     = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm";
    xy_roi          = Manual_Classfied_Areas.grav{:,roi_select};
elseif terrain_opt == 2
    terrain_type    = 'chipseal';    
    save_folder     = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm";
    xy_roi          = Manual_Classfied_Areas.chip{:,roi_select};
elseif terrain_opt == 3
    terrain_type    = 'foliage';
    save_folder     = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm";
    xy_roi          = Manual_Classfied_Areas.foli{:,roi_select};
elseif terrain_opt == 4
    terrain_type    = 'grass';
    save_folder     = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm";
    xy_roi          = Manual_Classfied_Areas.gras{:,roi_select};
elseif terrain_opt == 5
    terrain_type    = 'asphalt';
    save_folder     = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm";
    xy_roi          = Manual_Classfied_Areas.asph{:,roi_select};
elseif terrain_opt == 6
    terrain_type    = 'asphalt_2';
    save_folder     = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm";
    xy_roi          = Manual_Classfied_Areas.asph_roi{:,roi_select};
elseif terrain_opt == 7
    terrain_type    = 'dirt';
    save_folder     = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/01_RDF_Training_Data_Extraction_Export_rm";
    xy_roi          = Manual_Classfied_Areas.non_road{:,roi_select};
end

if range_bool
    
    save_folder = save_folder + "/" + string(terrain_type);
    disp(save_folder)

elseif ransac_bool 
    
    save_folder = save_folder + "_RAN/" + string(terrain_type);
    disp(save_folder)
    
end

mkdir(save_folder)
addpath(save_folder)


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


%% Checkaronis

manual_classifier_pcd_display(roi_file, lidar_msgs, gps_msgs, terrain_opt, roi_select)

disp('Waiting until ready!')
pause

close all

disp('Okay, Extracting Data.......')

%% Extracting Data

extract_bar = waitbar(0, "Extracting Files...");

% Classifying per 360 scan
for cloud = 1:cloud_break
  
    %% Clearing Vars
    
    xyz_cloud = [];
    xyzi_grab = [];
    tform = [];
    current_cloud = [];
    intensities = [];
    ring = [];
    abcd = [];
    table_export = [];
    
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
    xyz_cloud_4 = xyz_cloud(xyz_cloud(:,5) == 3, :); % indexes start @ 0
    xyz_cloud_5 = xyz_cloud(xyz_cloud(:,5) == 4, :); % indexes start @ 0
    
    % DEBUG
%     figure
%     ptCloudSource = pointCloud([xyz_cloud(:,1), xyz_cloud(:,2), xyz_cloud(:,3)], 'Intensity',  xyz_cloud(:,4));
%     pcshow(ptCloudSource)
%     pause


    %% Find Indexes CHANNEL 2

    % Find points in the arc
    if side_select == 1
        arc_idx_2 = find((atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) > chan_2_l_bounds(1) & (atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) <  chan_2_l_bounds(2));
    elseif side_select == 2
        arc_idx_2 = find((atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) > chan_2_c_bounds(1) & (atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) <  chan_2_c_bounds(2));
    elseif side_select == 3
        arc_idx_2 = find((atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) > chan_2_r_bounds(1) & (atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) <  chan_2_r_bounds(2));
    end

    % Apply Transformation
    xyz_cloud_2(:,1:3) = xyz_cloud_2(:,1:3) * tform.Rotation + tform.Translation;

    % Check if in manually defined truth area
    in_polygon_check_2 = inpolygon(xyz_cloud_2(arc_idx_2,1), xyz_cloud_2(arc_idx_2,2), xy_roi(:,1), xy_roi(:,2));
    sum(in_polygon_check_2)

    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_2) > 0 % && sum(in_polygon_check_2) > (length(xyz_cloud_2(arc_idx_2,1)) - 3)

        if range_bool
            
            chan_2_feat_table = [chan_2_feat_table; get_RANGE_feats_2(xyz_cloud_2(arc_idx_2,:),[])];

            chan_2_xyzi{thing2_count} = xyz_cloud_2(arc_idx_2,:);
            thing2_count = thing2_count + 1;
            
        elseif ransac_bool
            
            chan_2_feat_table = [chan_2_feat_table; get_RANSAC_feats_2(xyz_cloud_2(arc_idx_2,:),abcd)];

            chan_2_xyzi{thing2_count} = xyz_cloud_2(arc_idx_2,:);
            thing2_count = thing2_count + 1;
            
        end
        
    end
    
    %% Find Indexes CHANNEL 3

    % Find points in the arc
    if side_select == 1
        arc_idx_3     = find((atan2(xyz_cloud_3(:,1), xyz_cloud_3(:,2))) > chan_3_l_bounds(1) & (atan2(xyz_cloud_3(:,1), xyz_cloud_3(:,2))) <  chan_3_l_bounds(2));
    elseif side_select == 2
        arc_idx_3     = find((atan2(xyz_cloud_3(:,1), xyz_cloud_3(:,2))) > chan_3_c_bounds(1) & (atan2(xyz_cloud_3(:,1), xyz_cloud_3(:,2))) <  chan_3_c_bounds(2));
    elseif side_select == 3
        arc_idx_3     = find((atan2(xyz_cloud_3(:,1), xyz_cloud_3(:,2))) > chan_3_r_bounds(1) & (atan2(xyz_cloud_3(:,1), xyz_cloud_3(:,2))) <  chan_3_r_bounds(2));
    end
    
    % Apply Transformation
    xyz_cloud_3(:,1:3) = xyz_cloud_3(:,1:3) * tform.Rotation + tform.Translation;

    % Check if in manually defined truth area
    in_polygon_check_3 = inpolygon(xyz_cloud_3(arc_idx_3,1), xyz_cloud_3(arc_idx_3,2), xy_roi(:,1), xy_roi(:,2));
%     sum(in_polygon_check_3)
    
    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_3) > 0 && sum(in_polygon_check_3) > (length(xyz_cloud_3(arc_idx_3,1)) - 3)

        if range_bool
            
            chan_3_feat_table = [chan_3_feat_table; get_RANGE_feats_2(xyz_cloud_3(arc_idx_3,:),[])];
            
            chan_3_xyzi{thing3_count} = xyz_cloud_3(arc_idx_3,:);
            thing3_count = thing3_count + 1;
            
        elseif ransac_bool
            
            chan_3_feat_table = [chan_3_feat_table; get_RANSAC_feats_2(xyz_cloud_3(arc_idx_3,:),abcd)];
            
            chan_3_xyzi{thing3_count} = xyz_cloud_3(arc_idx_3,:);
            thing3_count = thing3_count + 1;
            
        end

    end
    
    
    %% Find Indexes CHANNEL 4

    % Find points in the arc
    if side_select == 1
        arc_idx_4     = find((atan2(xyz_cloud_4(:,1), xyz_cloud_4(:,2))) > chan_4_l_bounds(1) & (atan2(xyz_cloud_4(:,1), xyz_cloud_4(:,2))) <  chan_4_l_bounds(2));
    elseif side_select == 2
        arc_idx_4     = find((atan2(xyz_cloud_4(:,1), xyz_cloud_4(:,2))) > chan_4_c_bounds(1) & (atan2(xyz_cloud_4(:,1), xyz_cloud_4(:,2))) <  chan_4_c_bounds(2));
    elseif side_select == 3
        arc_idx_4     = find((atan2(xyz_cloud_4(:,1), xyz_cloud_4(:,2))) > chan_4_r_bounds(1) & (atan2(xyz_cloud_4(:,1), xyz_cloud_4(:,2))) <  chan_4_r_bounds(2));
    end

    % Apply Transformation
    xyz_cloud_4(:,1:3) = xyz_cloud_4(:,1:3) * tform.Rotation + tform.Translation;

    % Check if in manually defined truth area
    in_polygon_check_4 = inpolygon(xyz_cloud_4(arc_idx_4,1), xyz_cloud_4(arc_idx_4,2), xy_roi(:,1), xy_roi(:,2));
%     sum(in_polygon_check_4)
    
    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_4) > 0 && sum(in_polygon_check_4) > (length(xyz_cloud_4(arc_idx_4,1)) - 3)

        if range_bool
            
            chan_4_feat_table = [chan_4_feat_table; get_RANGE_feats_2(xyz_cloud_4(arc_idx_4,:),[])];
            
            chan_4_xyzi{thing4_count} = xyz_cloud_4(arc_idx_4,:);
            thing4_count = thing4_count + 1;
            
        elseif ransac_bool
            
            chan_4_feat_table = [chan_4_feat_table; get_RANSAC_feats_2(xyz_cloud_4(arc_idx_4,:),abcd)];
            
            chan_4_xyzi{thing4_count} = xyz_cloud_4(arc_idx_4,:);
            thing4_count = thing4_count + 1;
            
        end

    end
    
    %% Find Indexes CHANNEL 5

    % Find points in the arc
    if side_select == 1
            arc_idx_5     = find((atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) > chan_5_l_bounds(1) & (atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) <  chan_5_l_bounds(2));
    elseif side_select == 2
            arc_idx_5     = find((atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) > chan_5_c_bounds(1) & (atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) <  chan_5_c_bounds(2));
    elseif side_select == 3
            arc_idx_5     = find((atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) > chan_5_r_bounds(1) & (atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) <  chan_5_r_bounds(2));
    end

    % Apply Transformation
    xyz_cloud_5(:,1:3) = xyz_cloud_5(:,1:3) * tform.Rotation + tform.Translation;

    % Check if in manually defined truth area
    in_polygon_check_5 = inpolygon(xyz_cloud_5(arc_idx_5,1), xyz_cloud_5(arc_idx_5,2), xy_roi(:,1), xy_roi(:,2));
%     sum(in_polygon_check_5)
    
    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_5) > 0 && sum(in_polygon_check_5) > (length(xyz_cloud_5(arc_idx_5,1)) - 3)
        
        if range_bool
            
            chan_5_feat_table = [chan_5_feat_table; get_RANGE_feats_2(xyz_cloud_5(arc_idx_5,:),[])];
            
            chan_5_xyzi{thing5_count} = xyz_cloud_5(arc_idx_5,:);
            thing5_count = thing5_count + 1;
            
        elseif ransac_bool
            
            chan_5_feat_table = [chan_5_feat_table; get_RANSAC_feats_2(xyz_cloud_5(arc_idx_5,:),abcd)];
            
            chan_5_xyzi{thing5_count} = xyz_cloud_5(arc_idx_5,:);
            thing5_count = thing5_count + 1;
            
        end
            
    end
    
    %% Debug - plotting
                  
%     scatter(xyz_cloud_2(arc_idx,1), xyz_cloud_2(arc_idx,2))
          
    %% Weightbar
    
% 	parfor_progress;
    waitbar(cloud/cloud_break, extract_bar, sprintf('cloud %d out of %d', cloud, cloud_break))


end

close(extract_bar)

%% Save xyzi

% fn2_temp = "chan_2_xyzi_" + string(bag_name) + "_" + string(roi_select) + ".mat"; 
% fn3_temp = "chan_3_xyzi_" + string(bag_name) + "_" + string(roi_select) + ".mat"; 
% fn4_temp = "chan_4_xyzi_" + string(bag_name) + "_" + string(roi_select) + ".mat"; 
% fn5_temp = "chan_5_xyzi_" + string(bag_name) + "_" + string(roi_select) + ".mat"; 
% 
% % Overalldir
% file2_ovrl_name = string(fn2_temp);
% file3_ovrl_name = string(fn3_temp);
% file4_ovrl_name = string(fn4_temp);
% file5_ovrl_name = string(fn5_temp);
% 
% % Save
% save(file2_ovrl_name, 'chan_2_xyzi')
% save(file3_ovrl_name, 'chan_3_xyzi')
% save(file4_ovrl_name, 'chan_4_xyzi')
% save(file5_ovrl_name, 'chan_5_xyzi')

%% Save extracted table CENT

% Adding the terrain type to the table

if side_select == 2

    if height(chan_2_feat_table) > 3 && height(chan_3_feat_table) > 3 

        chan_2_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_2_feat_table),1);
        chan_3_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_3_feat_table),1);
        chan_4_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_4_feat_table),1);
        chan_5_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_5_feat_table),1);

        % Creating filenames
        chan_2_c_filename        = save_folder + "/2_c_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_3_c_filename        = save_folder + "/3_c_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_4_c_filename        = save_folder + "/4_c_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_5_c_filename        = save_folder + "/5_c_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";

        % Saving the table
        writetable(chan_2_feat_table, chan_2_c_filename)
        writetable(chan_3_feat_table, chan_3_c_filename)
        writetable(chan_4_feat_table, chan_4_c_filename)
        writetable(chan_5_feat_table, chan_5_c_filename)

    else

        warning('No C data!')

    end

end


%% Save extracted table LEFT

if side_select == 1

    % Adding the terrain type to the table

    if height(chan_2_feat_table) > 3 && height(chan_3_feat_table) > 3 

        chan_2_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_2_feat_table),1);
        chan_3_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_3_feat_table),1);
        chan_4_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_4_feat_table),1);
        chan_5_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_5_feat_table),1);

        % Creating filenames
        chan_2_l_filename        = save_folder + "/2_l_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_3_l_filename        = save_folder + "/3_l_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_4_l_filename        = save_folder + "/4_l_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_5_l_filename        = save_folder + "/5_l_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";

        % Saving the table
        writetable(chan_2_feat_table, chan_2_l_filename)
        writetable(chan_3_feat_table, chan_3_l_filename)
        writetable(chan_4_feat_table, chan_4_l_filename)
        writetable(chan_5_feat_table, chan_5_l_filename)

    else

        warning('No L data!')

    end

end


%% Save extracted table RIGHT


if side_select == 3
    
    % Adding the terrain type to the table

    if height(chan_2_feat_table) > 3

        chan_2_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_2_feat_table),1);
        chan_3_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_3_feat_table),1);
        chan_4_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_4_feat_table),1);
        chan_5_feat_table.terrain_type = repelem(categorical({terrain_type}), height(chan_5_feat_table),1);

        % Creating filenames
        chan_2_r_filename        = save_folder + "/2_r_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_3_r_filename        = save_folder + "/3_r_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_4_r_filename        = save_folder + "/4_r_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";
        chan_5_r_filename        = save_folder + "/5_r_" + string(terrain_type) + "_" + string(bag_name) + "_" + string(roi_select) + ".csv";

        % Saving the table
        writetable(chan_2_feat_table, chan_2_r_filename)
        writetable(chan_3_feat_table, chan_3_r_filename)
        writetable(chan_4_feat_table, chan_4_r_filename)
        writetable(chan_5_feat_table, chan_5_r_filename)

    else

        warning('No R data!')

    end

end


%% End Program 

disp('End Program!')




