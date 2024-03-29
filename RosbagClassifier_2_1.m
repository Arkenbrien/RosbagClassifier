%==========================================================================
%                             Rhett Huston
%
%                     FILE CREATION DATE: 10/19/2022
%
%                          RosbagClassifier.m
%
% This program classifies LiDAR point cloud data as gravel, asphalt, or
% unknown, for the purpose of detecting unmarked gravel roads.
%==========================================================================


%% Clear & Setup Workspace

clc; clear; close all
format compact


%% Options

% Initilize and Get Standard Options
options = struct();
options = get_plot_options(options);
options = get_arc_options(options);


%
% REFERENCE POINT & FILE
%

% 'range'; 'ransac'; 'mls';
options.reference_point         = 'range';
options.rosbag_number           = 6;
options.llrr_bool               = 0;


%
% EXPORT
%

options.save_results_bool       = 0;
options.custom_export_bool      = 1;


%
% PLOTTING OPTIONS
%

options.mca_plot                = 0;
options.plot_all_bool           = 0;
options.plot_avg_bool           = 0;
options.plot_area_results_bool  = 1;
options.plot_rate_bool          = 0;
options.plot_class_rate_bool    = 0;
options.plot_conf_bool          = 0;
options.plot_perchan_conf_bool  = 0;
options.auto_road_guesser_bool  = 0;
options.plot_avg_in_ani_bool    = 0;
options.plot_ani                = 0;
options.save_anim_bool          = 0;

%
% PLANE PROJECTION
%

% RANSAC Options
options.maxDistance             = 0.5;
options.MaxNumTrials            = 10; % RANSAC Iterations
options.grnd_pln_rmvl_bool      = 0;
options.chansToProject          = [1, 2, 3, 4, 5, 6, 7];


%
% DISTANCE FILTER
%

% distance-filter
options.dist_filt_bool          = 0;
options.min_dist_23             = 2.25;
options.min_dist_34             = 2.25;

% max_dist
options.max_dist_23             = 5;
options.max_dist_34             = 6;
options.max_dist_34             = 6;


%
% CONFIDENCE SCORE
%

% confidence-filter
options.conf_filt_bool          = 1;

if options.conf_filt_bool
    
    options = get_confs(options);
    
end

% Dirt v Gravel RDF:
options.dvg_bool                = 0;


%% RAW results export location

if options.save_results_bool
    options.export_location = get_export_location(options);
end


%% RDF selection
    
if options.reference_point == "range"
    
    chan_4_c_rdf_load_string = 'chan_4_c_2.mat';
    chan_3_c_rdf_load_string = 'chan_3_c_2.mat';
    chan_2_c_rdf_load_string = 'chan_2_c_2.mat';
    
    chan_4_l_rdf_load_string = 'chan_4_c_2.mat';
    chan_3_l_rdf_load_string = 'chan_3_c_2.mat';
    chan_2_l_rdf_load_string = 'chan_2_c_2.mat';
    
    chan_4_r_rdf_load_string = 'chan_4_c_2.mat';
    chan_3_r_rdf_load_string = 'chan_3_c_2.mat';
    chan_2_r_rdf_load_string = 'chan_2_c_2.mat';

%     chan_4_c_rdf_load_string = 'chan_4_c_range_50pc.mat';
%     chan_3_c_rdf_load_string = 'chan_3_c_range_50pc.mat';
%     chan_2_c_rdf_load_string = 'chan_2_c_range_50pc.mat';
%     
%     chan_4_l_rdf_load_string = 'chan_4_c_range_50pc.mat';
%     chan_3_l_rdf_load_string = 'chan_3_c_range_50pc.mat';
%     chan_2_l_rdf_load_string = 'chan_2_c_range_50pc.mat';
%     
%     chan_4_r_rdf_load_string = 'chan_4_c_range_50pc.mat';
%     chan_3_r_rdf_load_string = 'chan_3_c_range_50pc.mat';
%     chan_2_r_rdf_load_string = 'chan_2_c_range_50pc.mat';
%     
%     chan_4_c_rdf_load_string = 'chan_4_c_range_75pc.mat';
%     chan_3_c_rdf_load_string = 'chan_3_c_range_75pc.mat';
%     chan_2_c_rdf_load_string = 'chan_2_c_range_75pc.mat';
%     
%     chan_4_l_rdf_load_string = 'chan_4_c_range_75pc.mat';
%     chan_3_l_rdf_load_string = 'chan_3_c_range_75pc.mat';
%     chan_2_l_rdf_load_string = 'chan_2_c_range_75pc.mat';
%     
%     chan_4_r_rdf_load_string = 'chan_4_c_range_75pc.mat';
%     chan_3_r_rdf_load_string = 'chan_3_c_range_75pc.mat';
%     chan_2_r_rdf_load_string = 'chan_2_c_range_75pc.mat';
    
    
elseif options.reference_point == "ransac"
    
    chan_4_c_rdf_load_string = 'chan_4_c_ransac.mat';
    chan_3_c_rdf_load_string = 'chan_3_c_ransac.mat';
    chan_2_c_rdf_load_string = 'chan_2_c_ransac.mat';
    
    chan_4_l_rdf_load_string = 'chan_4_c_ransac.mat';
    chan_3_l_rdf_load_string = 'chan_3_c_ransac.mat';
    chan_2_l_rdf_load_string = 'chan_2_c_ransac.mat';
    
    chan_4_r_rdf_load_string = 'chan_4_c_ransac.mat';
    chan_3_r_rdf_load_string = 'chan_3_c_ransac.mat';
    chan_2_r_rdf_load_string = 'chan_2_c_ransac.mat';
    
elseif options.reference_point == "mls"
    
    chan_4_c_rdf_load_string = 'chan_4_c_mls.mat';
    chan_3_c_rdf_load_string = 'chan_3_c_mls.mat';
    chan_2_c_rdf_load_string = 'chan_2_c_mls.mat';
    
    chan_4_l_rdf_load_string = 'chan_4_c_mls.mat';
    chan_3_l_rdf_load_string = 'chan_3_c_mls.mat';
    chan_2_l_rdf_load_string = 'chan_2_c_mls.mat';
    
    chan_4_r_rdf_load_string = 'chan_4_c_mls.mat';
    chan_3_r_rdf_load_string = 'chan_3_c_mls.mat';
    chan_2_r_rdf_load_string = 'chan_2_c_mls.mat';
    
end


%% roi/rosbag PAIRS - 1 ROI per file

% Redmen Gravel Lot Drive-by: rm_db_1 - rm_db_4, rm_db_6
if options.rosbag_number == 1
    bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_1.bag';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_1_truth_areas_v3.mat';
elseif options.rosbag_number == 2
    bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_2.bag';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_2_truth_areas_v3.mat';
elseif options.rosbag_number == 3
    bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_3.bag';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_3_truth_areas_v3.mat';
elseif options.rosbag_number == 4 % NOTE; 1156.8 feet traveled in rm_db_4 338.01 avg sec per scan, 463 clouds in the file
    bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_4.bag';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_4_truth_areas_v3.mat';
elseif options.rosbag_number == 6
    bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_6.bag';
    roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_6_truth_areas_v3.mat';
    
elseif options.rosbag_number == 7

    % Redmen Gravel Lot: rm_1 - rm_11 - not 4,  4 is mysteriously borked... (x.x )
%     bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/rm_9.bag';
%     roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/pcd/r_u_a_grav/rm_9.mat';

    % Redmen Gravel Lot Drive-by: rm_db_1 - rm_db_6 (not 5 tho)
%     bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_2.bag';
%     roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/rm_db_2.mat'; % rm_db_5 == no good, passing car ruins data plus other shenanigens; rm_db_6 = roi_1, rm_db_6_2 = roi_2


    % Redmen Gravel Lot Grass Collection: rm_13 15 17 18 19 20 22 23 25 27 29 30 32
%     bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/rm_23.bag';
%     roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/pcd/r_u_a_gras/rm_23.mat';

end


%% Loading RDF

raw_data_export = {};
disp('Loading RDFs...')
chan_2_c_rdf = load(chan_2_c_rdf_load_string);
chan_3_c_rdf = load(chan_3_c_rdf_load_string);
chan_4_c_rdf = load(chan_4_c_rdf_load_string);

chan_2_l_rdf = load(chan_2_l_rdf_load_string);
chan_3_l_rdf = load(chan_3_l_rdf_load_string);
chan_4_l_rdf = load(chan_4_l_rdf_load_string);

chan_2_r_rdf = load(chan_2_r_rdf_load_string);
chan_3_r_rdf = load(chan_3_r_rdf_load_string);
chan_4_r_rdf = load(chan_4_r_rdf_load_string);

DvG = load('chan_2_DvG.mat');
disp('RDFs Loaded!')


%% Variable Initiation

% Reference Frames
LiDAR_Ref_Frame             = [0; 1.584; 1.444];
IMU_Ref_Frame               = [0; 0.336; -0.046];

% Correction frame:         LiDAR_Ref_Frame - IMU_Ref_Frame [Y X Z]
gps_to_lidar_diff           = [(LiDAR_Ref_Frame(1) - IMU_Ref_Frame(1)), (LiDAR_Ref_Frame(2) - IMU_Ref_Frame(2)), (LiDAR_Ref_Frame(3) - IMU_Ref_Frame(3))]; 

% Angle array creation
chan_2_c_bounds     = [((90 - options.chan_2_d_ang) * pi/180), ((90 + options.chan_2_d_ang) * pi/180)];
chan_3_c_bounds     = [((90 - options.chan_3_d_ang) * pi/180), ((90 + options.chan_3_d_ang) * pi/180)];
chan_4_c_bounds     = [((90 - options.chan_4_d_ang) * pi/180), ((90 + options.chan_4_d_ang) * pi/180)];

chan_2_l_bounds     = [((options.chan_2_l_cent_ang - options.chan_2_d_ang) * pi/180), ((options.chan_2_l_cent_ang + options.chan_2_d_ang) * pi/180)];
chan_3_l_bounds     = [((options.chan_3_l_cent_ang - options.chan_3_d_ang) * pi/180), ((options.chan_3_l_cent_ang + options.chan_3_d_ang) * pi/180)];
chan_4_l_bounds     = [((options.chan_4_l_cent_ang - options.chan_4_d_ang) * pi/180), ((options.chan_4_l_cent_ang + options.chan_4_d_ang) * pi/180)];

chan_2_ll_bounds     = [((options.chan_2_ll_cent_ang - options.chan_2_d_ang) * pi/180), ((options.chan_2_ll_cent_ang + options.chan_2_d_ang) * pi/180)];
chan_3_ll_bounds     = [((options.chan_3_ll_cent_ang - options.chan_3_d_ang) * pi/180), ((options.chan_3_ll_cent_ang + options.chan_3_d_ang) * pi/180)];
chan_4_ll_bounds     = [((options.chan_4_ll_cent_ang - options.chan_4_d_ang) * pi/180), ((options.chan_4_ll_cent_ang + options.chan_4_d_ang) * pi/180)];

chan_2_r_bounds     = [((options.chan_2_r_cent_ang  - options.chan_2_d_ang) * pi/180), ((options.chan_2_r_cent_ang  + options.chan_2_d_ang) * pi/180)];
chan_3_r_bounds     = [((options.chan_3_r_cent_ang  - options.chan_3_d_ang) * pi/180), ((options.chan_3_r_cent_ang  + options.chan_3_d_ang) * pi/180)];
chan_4_r_bounds     = [((options.chan_4_r_cent_ang  - options.chan_4_d_ang) * pi/180), ((options.chan_4_r_cent_ang  + options.chan_4_d_ang) * pi/180)];

chan_2_rr_bounds     = [((options.chan_2_rr_cent_ang  - options.chan_2_d_ang) * pi/180), ((options.chan_2_rr_cent_ang  + options.chan_2_d_ang) * pi/180)];
chan_3_rr_bounds     = [((options.chan_3_rr_cent_ang  - options.chan_3_d_ang) * pi/180), ((options.chan_3_rr_cent_ang  + options.chan_3_d_ang) * pi/180)];
chan_4_rr_bounds     = [((options.chan_4_rr_cent_ang  - options.chan_4_d_ang) * pi/180), ((options.chan_4_rr_cent_ang  + options.chan_4_d_ang) * pi/180)];


% Names for channel
area_names = [];

% Array Inits
% Chan 2
Grav_All_Append_Array_2   = []; Asph_All_Append_Array_2 = []; Foli_All_Append_Array_2 = []; Gras_All_Append_Array_2 = [];
Grav_Avg_Append_Array_2   = []; Asph_Avg_Append_Array_2 = []; Foli_Avg_Append_Array_2 = []; Gras_Avg_Append_Array_2 = [];
Unkn_All_Append_Array_2   = [];
Unkn_Avg_Append_Array_2   = [];

% Chan 3
Grav_All_Append_Array_3   = []; Asph_All_Append_Array_3 = []; Foli_All_Append_Array_3 = []; Gras_All_Append_Array_3 = [];
Grav_Avg_Append_Array_3   = []; Asph_Avg_Append_Array_3 = []; Foli_Avg_Append_Array_3 = []; Gras_Avg_Append_Array_3 = [];
Unkn_All_Append_Array_3   = [];
Unkn_Avg_Append_Array_3   = [];

% Chan 4
Grav_All_Append_Array_4   = []; Asph_All_Append_Array_4 = []; Foli_All_Append_Array_4 = []; Gras_All_Append_Array_4 = [];
Grav_Avg_Append_Array_4   = []; Asph_Avg_Append_Array_4 = []; Foli_Avg_Append_Array_4 = []; Gras_Avg_Append_Array_4 = [];
Unkn_All_Append_Array_4   = [];
Unkn_Avg_Append_Array_4   = [];

% Chan 5
Grav_All_Append_Array_5   = []; Asph_All_Append_Array_5 = []; Foli_All_Append_Array_5 = []; Gras_All_Append_Array_5 = [];
Grav_Avg_Append_Array_5   = []; Asph_Avg_Append_Array_5 = []; Foli_Avg_Append_Array_5 = []; Gras_Avg_Append_Array_5 = [];
Unkn_All_Append_Array_5   = [];
Unkn_Avg_Append_Array_5   = [];

% Other Stuff
raw_data_export = []; save_folder = [];
model_RANSAC = []; model_MLS = [];

pcd_class_rate = []; plane_proj_toc = [];

% Legend Stuff
h = zeros(1,3);

% table exports
% chan_2_c_table_export = table(); chan_3_c_table_export = table(); chan_4_c_table_export = table();



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

% cloud_break                 = 20;
cloud_break                 = length(lidar_msgs);
gps_pos_store               = zeros(cloud_break,3);
lidar_pos_store             = gps_pos_store;


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
LidarOffset2gps = [ cosd(90) -sind(90)   0;
                    sind(90)  cosd(90)   0;
                    0        0           1]; 

fprintf('Max time delta is %f sec \n',max(abs(diffs)));


%% Classifying the Rosbag

% TO-DO: Re-make so that the results are not saved to disk but saved to
% memory, makes loading results way faster.

disp('Starting Classification!')

% Rate of classification rate per 360 scan
pcd_class_rate = Par(int64(cloud_break));

% Progress bar
parfor_progress(cloud_break);
classy = tic;

% Classifying per 360 scan
parfor cloud = 1:cloud_break
    
    %% Clearing Vars
    
    xyz_cloud = [];
    xyzi_grab = [];
    current_cloud = [];
    intensities = [];
    ring = [];
    abcd = [];
    table_export = [];
    
    rate = tic;
    
    Yfit_2c = []; Yfit_3c = []; Yfit_4c = [];
    Yfit_2l = []; Yfit_3l = []; Yfit_4l = []; 
    Yfit_2r = []; Yfit_3r = []; Yfit_4r = [];
    
    %% Grabbing Data
    
    % Reading the current point cloud and matched gps coord
    current_cloud               = lidar_msgs{cloud};
    matched_stamp               = gps_msgs{indexes(cloud)};
    
    % Converting the gps coord to xyz (m)
    [xEast, yNorth, zUp]        = latlon2local(matched_stamp.Latitude, matched_stamp.Longitude, matched_stamp.Altitude, origin);
    
    path_coord{cloud}           = [xEast, yNorth, zUp];
    
    % Grabbing the angles
    roll                        = matched_stamp.Roll;
    pitch                       = matched_stamp.Pitch;
    yaw                         = matched_stamp.Track+180;
    
    
    %% Rectifying Frames
     
    % Creating the rotation matrix
    rotate_update               = rotz(90-yaw)*roty(roll)*rotx(pitch);
     
    % Offset the gps coord by the current orientation
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
    tform{cloud}                = rigid3d(rotate_update, [lidarTrajectory(1) lidarTrajectory(2) lidarTrajectory(3)]);
    
    % Reading the current cloud for xyz, intensity, and ring (channel) values
    xyz_cloud                   = rosReadXYZ(current_cloud);
    intensities                 = rosReadField(current_cloud, 'intensity');
    ring                        = rosReadField(current_cloud, 'ring');
    xyz_cloud(:,4)              = intensities;
    xyz_cloud(:,5)              = ring;

    
    %% Trimming data
    
    % Data Clean-up
    xyz_cloud = xyz_cloud( ~any( isnan(xyz_cloud) | isinf(xyz_cloud), 2),:);
%     xyz_cloud = xyz_cloud(xyz_cloud(:,1) >= 0, :);

    %% Ground Plane Removal EXPERIMENT
    
    if options.grnd_pln_rmvl_bool
    
        plane_proj_tic              = tic;
        rows                        = any(ismember(xyz_cloud(:, 5), options.chansToProject), 2);
        xyz_cloud                   = xyz_cloud(rows, :);
        [~, inlierIndices, ~]       = pcfitplane(pointCloud([xyz_cloud(:,1), xyz_cloud(:,2), xyz_cloud(:,3)]), .25);
        xyz_cloud                   = xyz_cloud(inlierIndices,:);
        plane_proj_toc{cloud}       = toc(plane_proj_tic);

    end
    
    %% Channel Split
    xyz_cloud_2 = xyz_cloud(xyz_cloud(:,5) == 1, :); % indexes start @ 0
    xyz_cloud_3 = xyz_cloud(xyz_cloud(:,5) == 2, :); % indexes start @ 0
    xyz_cloud_4 = xyz_cloud(xyz_cloud(:,5) == 3, :); % indexes start @ 0
%     xyz_cloud_5 = xyz_cloud(xyz_cloud(:,5) == 4, :); % indexes start @ 0
    
    %% Classification Area

    % CHANNEL 2 CENT

    classify_fun_out_2c{cloud} = classify_fun(xyz_cloud_2, chan_2_c_bounds, chan_2_c_rdf, tform{cloud}, DvG, options, "2c");

    % CHANNEL 3 CENT

    classify_fun_out_3c{cloud} = classify_fun(xyz_cloud_3, chan_3_c_bounds, chan_3_c_rdf, tform{cloud}, DvG, options, "3c");

    % CHANNEL 4 CENT

    classify_fun_out_4c{cloud} = classify_fun(xyz_cloud_4, chan_4_c_bounds, chan_4_c_rdf, tform{cloud}, DvG, options, "4c");
    
    if ~options.c_only_bool

        % CHANNEL 2 LEFT

        classify_fun_out_2l{cloud} = classify_fun(xyz_cloud_2, chan_2_l_bounds, chan_2_l_rdf, tform{cloud}, DvG, options, "2l");

        % CHANNEL 3 LEFT

        classify_fun_out_3l{cloud} = classify_fun(xyz_cloud_3, chan_3_l_bounds, chan_3_l_rdf, tform{cloud}, DvG, options, "3l");

        % CHANNEL 4 LEFT

        classify_fun_out_4l{cloud} = classify_fun(xyz_cloud_4, chan_4_l_bounds, chan_4_l_rdf, tform{cloud}, DvG, options, "4l");

        % CHANNEL 2 RIGHT

        classify_fun_out_2r{cloud} = classify_fun(xyz_cloud_2, chan_2_r_bounds, chan_2_r_rdf, tform{cloud}, DvG, options, "2r");

        % CHANNEL 3 RIGHT

        classify_fun_out_3r{cloud} = classify_fun(xyz_cloud_3, chan_3_r_bounds, chan_3_r_rdf, tform{cloud}, DvG, options, "3r");

        % CHANNEL 4 RIGHT

        classify_fun_out_4r{cloud} = classify_fun(xyz_cloud_4, chan_4_r_bounds, chan_4_r_rdf, tform{cloud}, DvG, options, "4r");
        
    end
    
    if options.llrr_bool

        % CHANNEL 2 LLEFT

        classify_fun_out_2ll{cloud} = classify_fun(xyz_cloud_2, chan_2_ll_bounds, chan_2_l_rdf, tform{cloud}, DvG, options, "2ll");

        % CHANNEL 3 LLEFT

        classify_fun_out_3ll{cloud} = classify_fun(xyz_cloud_3, chan_3_ll_bounds, chan_3_l_rdf, tform{cloud}, DvG, options, "3ll");

        % CHANNEL 4 LLEFT

        classify_fun_out_4ll{cloud} = classify_fun(xyz_cloud_4, chan_4_ll_bounds, chan_4_l_rdf, tform{cloud}, DvG, options, "4ll");

        % CHANNEL 2 RRIGHT

        classify_fun_out_2rr{cloud} = classify_fun(xyz_cloud_2, chan_2_rr_bounds, chan_2_r_rdf, tform{cloud}, DvG, options, "2rr");

        % CHANNEL 3 RRIGHT

        classify_fun_out_3rr{cloud} = classify_fun(xyz_cloud_3, chan_3_rr_bounds, chan_3_r_rdf, tform{cloud}, DvG, options, "3rr");

        % CHANNEL 4 RRIGHT

        classify_fun_out_4rr{cloud} = classify_fun(xyz_cloud_4, chan_4_rr_bounds, chan_4_r_rdf, tform{cloud}, DvG, options, "4rr");

    end
    
    %% Weightbar
    
    % Progress Bar
	parfor_progress;

    pcd_class_rate_rate{cloud} = toc(rate);
    
    
end

parfor_progress(0);

disp('Classification Complete!')

disp(toc(classy))


%% Apphending all results to arrays

if options.llrr_bool
    
    channel_2_fun_out = [classify_fun_out_2ll, classify_fun_out_2l, classify_fun_out_2c, classify_fun_out_2r, classify_fun_out_2rr];
    channel_3_fun_out = [classify_fun_out_3ll, classify_fun_out_3l, classify_fun_out_3c, classify_fun_out_3r, classify_fun_out_3rr];
    channel_4_fun_out = [classify_fun_out_4ll, classify_fun_out_4l, classify_fun_out_4c, classify_fun_out_4r, classify_fun_out_4rr];
    
    llrr_test_results.ll    = classify_fun_out_2ll;
    llrr_test_results.l     = classify_fun_out_2l;
    llrr_test_results.c     = classify_fun_out_2c;
    llrr_test_results.r     = classify_fun_out_2r;
    llrr_test_results.rr    = classify_fun_out_2rr;
    
elseif options.c_only_bool
   
    channel_2_fun_out = [classify_fun_out_2c];
    channel_3_fun_out = [classify_fun_out_3c];
    channel_4_fun_out = [classify_fun_out_4c]; 
    
else

    channel_2_fun_out = [classify_fun_out_2l, classify_fun_out_2c, classify_fun_out_2r];
    channel_3_fun_out = [classify_fun_out_3l, classify_fun_out_3c, classify_fun_out_3r];
    channel_4_fun_out = [classify_fun_out_4l, classify_fun_out_4c, classify_fun_out_4r];
    
end

Results_Export.c2 = channel_2_fun_out;
Results_Export.c3 = channel_3_fun_out;
Results_Export.c4 = channel_4_fun_out;
Results_Export.path_coord = path_coord;
Results_Export.tform = tform;

[All_Arrays, Avg_Arrays]    = get_classified_arrays(channel_2_fun_out,... 
                                                    channel_3_fun_out,... 
                                                    channel_4_fun_out);

% channel_2_fun_out = [classify_fun_out_2ll, classify_fun_out_2l, classify_fun_out_2c, classify_fun_out_2r, classify_fun_out_2rr];
% channel_3_fun_out = [classify_fun_out_3ll, classify_fun_out_3l, classify_fun_out_3c, classify_fun_out_3r, classify_fun_out_3rr];
% channel_4_fun_out = [classify_fun_out_4ll, classify_fun_out_4l, classify_fun_out_4c, classify_fun_out_4r, classify_fun_out_4rr];
% 
% [All_Arrays, Avg_Arrays]    = get_classified_arrays(channel_2_fun_out,... 
%                                                     channel_3_fun_out,... 
%                                                     channel_4_fun_out);


%% Save all results to a .mat file

if options.save_results_bool

    currentEpochTime = posixtime(datetime('now', 'TimeZone', 'UTC'));
    [~,bag_name,~] = fileparts(bag_file);
    export_Results_Export_filename = options.export_location + "/" + string(bag_name) + "_" + string(options.reference_point) + "_" + string(currentEpochTime) + "_Results_Export.mat";
    export_options_filename = options.export_location + "/" + string(bag_name) + "_" + string(options.reference_point) + "_" + string(currentEpochTime) + "_options.mat";
    
    save(export_Results_Export_filename, 'Results_Export')
    save(export_options_filename, 'options')
    
    disp('Results Saved!')
    
end


%% Plotting Auto Road Guess

if options.auto_road_guesser_bool

    auto_road_guesser(Avg_Arrays, Manual_Classfied_Areas, path_coord, options, tform)
    
end


%% Score the Results

if options.plot_area_results_bool
    
    class_score_function_test(Avg_Arrays, Manual_Classfied_Areas)
    
end


%% Plotting All Points

if options.plot_all_bool
    
    plot_all_class_results_fun(All_Arrays, path_coord, options)

end


%% Plotting Average points

if options.plot_avg_bool
    
    plot_avg_class_results_fun(Avg_Arrays, Manual_Classfied_Areas, path_coord, options)
    
end


%% Plotting Average points with confs

if options.plot_conf_bool
    
    plot_avg_class_confs_results_fun(Avg_Arrays, Manual_Classfied_Areas, options)
    
end


%% Plotting Average points with confs per channel

if options.plot_perchan_conf_bool
    
    plot_avg_class_perchan_confs_results_fun(Avg_Arrays, Manual_Classfied_Areas, options)
    
end


%% Plotting PCD Classification Rate

if options.plot_rate_bool
    
    plot_rate_fun(pcd_class_rate_rate, plane_proj_toc, options)
    
end


%% Plotting classification rate - Classification only (classify_fun_out)

if options.plot_class_rate_bool
    
    plot_class_rate_fun(classify_fun_out_2c, classify_fun_out_3c, classify_fun_out_4c, classify_fun_out_2l, classify_fun_out_3l, classify_fun_out_4l, classify_fun_out_2r, classify_fun_out_3r, classify_fun_out_4r, options)
    
end


%% End Program 

disp('End Program!')



