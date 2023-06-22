%==========================================================================
%                       Travis Moleski/Rhett Huston
%
%                     FILE CREATION DATE: 10/19/2022
%
%                      Raw_Training_Data_Extraction.m
%
% This program  ... yes
%==========================================================================

%% Clear & Setup Workspace

clc; clear; close all
format compact


%% Options

% 'range'; 'ransac';, 'mls'
options.reference_point = 'range';

options.export_folder_name = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/RAW_RDF_Training_Data'; % Reference apphended automatically...

chan_2_d_ang        = 3;
chan_3_d_ang        = 3;
chan_4_d_ang        = 3;
chan_5_d_ang        = 2.5;
chan_6_d_ang        = 2.5;

% RANSAC Options
options.maxDistance         = 0.5;
options.MaxNumTrials    = 10;

% Plotting the moving average - how many samples per average?
move_avg_size       = 15;

% Size of figures
fig_size_array          = [10 10 3500 1600];


%% ROSBAG & Region Of Interest (manually classified areas)

% ======================================================================= %

% Redmen Gravel Lot: rm_1 - rm_11 - not 4,  4 is mysteriously borked... (x.x )
bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/rm_11.bag';
roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/pcd/r_u_a_grav/rm_11.mat';
terrain_opt = 1;
roi_select = 1; %1 = 1,2,3; 2 = 1,2
side_select = 2; %1 = l, 2 = c, 3 = r

% Redmen Gravel Lot Drive-by: rm_db_1 - rm_db_6 (not 5 tho)
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_6.bag';
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/rm_db_6.mat'; % rm_db_5 == no good, passing car ruins data plus other shenanigens; rm_db_6 = roi_1, rm_db_6_2 = roi_2
% % % roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/SoR_Looks/rm_db_6_SOR.mat'; terrain_opt = 7; 
% terrain_opt = 5;
% roi_select = 1;
% side_select = 2; %1 = l, 2 = c, 3 = r

% Redmen Gravel Lot Grass Collection: rm_13 15 17 18 19 20 22 23 25 27 29 30 32
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/rm_32.bag';
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/pcd/r_u_a_gras/rm_32.mat';
% terrain_opt = 4;
% roi_select = 1;
% side_select = 2; %1 = l, 2 = c, 3 = r


%% Variable Initiation

% Counter for exporting all data into one csv (Diag Purposes)
chan_2_export_count = 1;
chan_3_export_count = 1;
chan_4_export_count = 1;
chan_5_export_count = 1;

% Channel Bounds
chan_2_c_bounds     = [((90 - chan_2_d_ang) * pi/180), ((90 + chan_2_d_ang) * pi/180)];
chan_3_c_bounds     = [((90 - chan_3_d_ang) * pi/180), ((90 + chan_3_d_ang) * pi/180)];
chan_4_c_bounds     = [((90 - chan_4_d_ang) * pi/180), ((90 + chan_4_d_ang) * pi/180)];
chan_5_c_bounds     = [((90 - chan_5_d_ang) * pi/180), ((90 + chan_5_d_ang) * pi/180)];
chan_6_c_bounds     = [((90 - chan_6_d_ang) * pi/180), ((90 + chan_6_d_ang) * pi/180)];

chan_2_l_bounds     = [((135 - chan_2_d_ang) * pi/180), ((135 + chan_2_d_ang) * pi/180)];
chan_3_l_bounds     = [((135 - chan_3_d_ang) * pi/180), ((135 + chan_3_d_ang) * pi/180)];
chan_4_l_bounds     = [((135 - chan_4_d_ang) * pi/180), ((135 + chan_4_d_ang) * pi/180)];
chan_5_l_bounds     = [((135 - chan_5_d_ang) * pi/180), ((135 + chan_5_d_ang) * pi/180)];
chan_6_l_bounds     = [((135 - chan_6_d_ang) * pi/180), ((135 + chan_6_d_ang) * pi/180)];

chan_2_r_bounds     = [((45 - chan_2_d_ang) * pi/180), ((45 + chan_2_d_ang) * pi/180)];
chan_3_r_bounds     = [((45 - chan_3_d_ang) * pi/180), ((45 + chan_3_d_ang) * pi/180)];
chan_4_r_bounds     = [((45 - chan_4_d_ang) * pi/180), ((45 + chan_4_d_ang) * pi/180)];
chan_5_r_bounds     = [((45 - chan_5_d_ang) * pi/180), ((45 + chan_5_d_ang) * pi/180)];
chan_6_r_bounds     = [((45 - chan_6_d_ang) * pi/180), ((45 + chan_6_d_ang) * pi/180)];

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

chan_2c_feat_table = table(); chan_3c_feat_table = table(); chan_4c_feat_table = table(); chan_5c_feat_table = table();
% chan_2l_feat_table = table(); chan_3l_feat_table = table(); chan_4l_feat_table = table(); chan_5l_feat_table = table();
% chan_2r_feat_table = table(); chan_3r_feat_table = table(); chan_4r_feat_table = table(); chan_5r_feat_table = table();

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
    xy_roi          = Manual_Classfied_Areas.grav{:,roi_select};
elseif terrain_opt == 2
    terrain_type    = 'chipseal';    
    xy_roi          = Manual_Classfied_Areas.chip{:,roi_select};
elseif terrain_opt == 3
    terrain_type    = 'foliage';
    xy_roi          = Manual_Classfied_Areas.foli{:,roi_select};
elseif terrain_opt == 4
    terrain_type    = 'grass';
    xy_roi          = Manual_Classfied_Areas.gras{:,roi_select};
elseif terrain_opt == 5
    terrain_type    = 'asphalt';
    xy_roi          = Manual_Classfied_Areas.asph{:,roi_select};
elseif terrain_opt == 6
    terrain_type    = 'asphalt_2';
    xy_roi          = Manual_Classfied_Areas.asph_roi{:,roi_select};
elseif terrain_opt == 7
    terrain_type    = 'dirt';
    xy_roi          = Manual_Classfied_Areas.non_road{:,roi_select};
end

if options.reference_point == "range"
    
    save_folder = options.export_folder_name + "/RANGE/";
    disp(save_folder)

elseif options.reference_point == "ransac"
    
    save_folder = options.export_folder_name + "/RANSAC/";
    disp(save_folder)
    
elseif options.reference_point == "mls" 
    
    save_folder = options.export_folder_name + "/MLS/";
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
    
    
    %% Trimming data
    
    % Data Clean-up
    xyz_cloud = xyz_cloud( ~any( isnan(xyz_cloud) | isinf(xyz_cloud), 2),:);
    xyz_cloud = xyz_cloud(xyz_cloud(:,1) >= 0, :);

    % Channel Split
    xyz_cloud_2 = xyz_cloud(xyz_cloud(:,5) == 1, :); % indexes start @ 0
    xyz_cloud_3 = xyz_cloud(xyz_cloud(:,5) == 2, :); % indexes start @ 0
    xyz_cloud_4 = xyz_cloud(xyz_cloud(:,5) == 3, :); % indexes start @ 0
    xyz_cloud_5 = xyz_cloud(xyz_cloud(:,5) == 4, :); % indexes start @ 0
    xyz_cloud_6 = xyz_cloud(xyz_cloud(:,5) == 5, :); % indexes start @ 0
    
    raw_training_data{cloud}.terrain_opt = terrain_opt;

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

    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_2) > 0 % && sum(in_polygon_check_2) > (length(xyz_cloud_2(arc_idx_2,1)) - 3)

        raw_training_data{cloud}.c2 = xyz_cloud_2(arc_idx_2,:);
        
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
    
    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_3) > 0 && sum(in_polygon_check_3) > (length(xyz_cloud_3(arc_idx_3,1)) - 3)

        raw_training_data{cloud}.c3 = xyz_cloud_3(arc_idx_3,:);
        
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
    
    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_4) > 0 && sum(in_polygon_check_4) > (length(xyz_cloud_4(arc_idx_4,1)) - 3)

        raw_training_data{cloud}.c4 = xyz_cloud_4(arc_idx_4,:);
        
        
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
    
    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_5) > 0 && sum(in_polygon_check_5) > (length(xyz_cloud_5(arc_idx_5,1)) - 3)
        
        raw_training_data{cloud}.c5 = xyz_cloud_5(arc_idx_5,:);
            
    end

    %% Find Indexes CHANNEL 6

    % Find points in the arc
    if side_select == 1
            arc_idx_6     = find((atan2(xyz_cloud_6(:,1), xyz_cloud_6(:,2))) > chan_6_l_bounds(1) & (atan2(xyz_cloud_6(:,1), xyz_cloud_6(:,2))) <  chan_6_l_bounds(2));
    elseif side_select == 2
            arc_idx_6     = find((atan2(xyz_cloud_6(:,1), xyz_cloud_6(:,2))) > chan_6_c_bounds(1) & (atan2(xyz_cloud_6(:,1), xyz_cloud_6(:,2))) <  chan_6_c_bounds(2));
    elseif side_select == 3
            arc_idx_6     = find((atan2(xyz_cloud_6(:,1), xyz_cloud_6(:,2))) > chan_6_r_bounds(1) & (atan2(xyz_cloud_6(:,1), xyz_cloud_6(:,2))) <  chan_6_r_bounds(2));
    end

    % Apply Transformation
    xyz_cloud_6(:,1:3) = xyz_cloud_6(:,1:3) * tform.Rotation + tform.Translation;

    % Check if in manually defined truth area
    in_polygon_check_6 = inpolygon(xyz_cloud_6(arc_idx_6,1), xyz_cloud_6(arc_idx_6,2), xy_roi(:,1), xy_roi(:,2));
    
    % Compare to see if the majority of arc is in manually defined
    % area - if so extract data
    if sum(in_polygon_check_6) > 0 && sum(in_polygon_check_6) > (length(xyz_cloud_6(arc_idx_6,1)) - 3)
        
        raw_training_data{cloud}.c6 = xyz_cloud_6(arc_idx_6,:);
            
    end
    
    
    %% Weightbar
    
% 	parfor_progress;
    waitbar(cloud/cloud_break, extract_bar, sprintf('cloud %d out of %d', cloud, cloud_break))


end

close(extract_bar)


%% Apphend to old .mat file

% Display dialog box with "Yes" and "No" options
choice = questdlg('Do you want to load an old file?', 'File Load', 'Yes', 'No', 'No');

% Check the user's choice
if strcmpi(choice, 'Yes')
    % Prompt the user to select a .mat file
    [filename, pathname] = uigetfile('*.mat', 'Select a .mat file');
    if isequal(filename, 0)
        disp('No file selected.');
    else
        
        % Load the selected .mat file
        fullPath = fullfile(pathname, filename);

        new_data = raw_training_data;
        
        loadedData = load(fullPath);
        
        % Use the loaded data as needed
        disp('File loaded successfully.');
        % Do something with the loaded data...
        
        disp(length(raw_training_data))
        
        raw_training_data = [raw_training_data, new_data];
        
        disp(length(raw_training_data))
        
        filename = string(save_folder) + "/raw_training_data" +  string(time_now) +  ".mat";
    
        save(filename, 'raw_training_data')

        disp('Data Saved')
        
    end
    
else
    
    disp('No file will be loaded.');
    
    filename = string(save_folder) + "raw_training_data" +  string(time_now) +  ".mat";
    
    save(filename, 'raw_training_data')
    
    disp('Data Saved')
end


%% End Program 
% 
% disp('End Program!')




