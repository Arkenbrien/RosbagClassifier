%==========================================================================
%                       Travis Moleski/Rhett Huston
%
%                     FILE CREATION DATE: 10/19/2022
%
%                          RosbagClassifier.m
%
% This program classifies LiDAR point cloud data as gravel, asphalt, or
% unknown, for the purpose of detecting unmakred gravel roads.
%==========================================================================

%% TEMP DEBUG - it will crash here if you press f5 lol

% class_score_function_test(avg_cell_store, Manual_Classfied_Areas, options)


%% Clear & Setup Workspace

clc; clear; close all
format compact


%% Options

% Export Folder
options.export_folder_name      = '01_RDF_Training_Data_Extraction_Export'; % Reference apphended automatically...

% REFERENCE POINT
% 'range'; 'ransac';, 'mls'
options.reference_point         = 'range';

% ARC SIZE
% Center angle variance +- idk what you call this
options.chan_2_d_ang            = 3;
options.chan_3_d_ang            = 3;
options.chan_4_d_ang            = 3;
options.chan_5_d_ang            = 2.5;


% PLOTTING OPTIONS
% Marker size / Linewidth for plotz
options.c2markersize            = 20;
options.c3markersize            = 20;
options.c4markersize            = 20;

% Plotting linewidth for plotz
options.c2linewidth             = 20;
options.c3linewidth             = 20;
options.c4linewidth             = 20;

% which things to plot
options.plot_all_bool           = 0;
options.plot_avg_bool           = 1;
options.plot_rate_bool          = 0;
options.plot_class_rate_bool    = 0;

% Legend Stuff
options.legend_marker_size      = 20;
options.legend_line_width       = 5;
options.legend_font_size        = 56;

options.axis_font_size          = 24;

% Font Type
options.font_type               = 'Sans Regular'; % Default Font: Sans Regular

% Plotting the moving average - how many samples per average?
options.move_avg_size           = 15;

% Do we compare the data to be classified to the training data????
data_comp_bool                  = 0;


% PLANE PROJECTION
% RANSAC Options
options.maxDistance             = 0.5;
options.MaxNumTrials            = 10; % RANSAC Iterations

% Size of figures
fig_size_array                  = [10 10 3500 1600];

% min_dist
min_dist_23                     = 2.25;
min_dist_34                     = 2.25;

% max_dist
max_dist_23                     = 5;
max_dist_34                     = 6;

% distance-filter
options.dist_filt_bool          = 0;

% CONFIDENCE SCORE

% confidence-filter
options.conf_filt_bool          = 1;

% Adjust results based on confidence scores (not all are used, check the
% classify_fun for implementation
if options.reference_point == "range" || options.reference_point == "mls"
    
    options.c2gravconfupbound       = 0.90;
    options.c2unknconflwbound       = 0.10;
    
    options.c3asphconfupbound       = 0.89;
    options.c3gravconfupbound       = 0.80;
    options.c3unknconflwbound       = 0.20;
    
    options.c4gravconfupbound       = 0.90;
    options.c4unknconflwbound       = 0.20;

elseif options.reference_point == "ransac"
    
    % Channel 2 Gravel
    options.c2gravconflwbound       = 0.45;   
    options.c2gravconfupbound       = 0.70;
    
    % Channel 2 Unknown
    options.c2unknconflwbound       = 0.00;
    options.c2unknconfupbound       = 0.55;
    
    % Channel 2 Asphalt
    options.c2asphconflwbound       = 0.00;
    options.c2asphconfupbound       = 1.00;
    
    % Channel 3 Gravel
    options.c3gravconflwbound       = 0.45;
    options.c3gravconfupbound       = 0.60;
    
    % Channel 3 Unknown
    options.c3unknconflwbound       = 0.40;
    options.c3unknconfupbound       = 0.50;
    
    % Channel 3 Asph
    options.c3asphconflwbound       = 0.00;
    options.c3asphconfupbound       = 1.00;
    
    % Channel 4 Gravel
    options.c4unknconflwbound       = 0.45;
    options.c4unknconfupbound       = 0.55;
    
    % Channel 4 Unknown
    options.c4gravconflwbound       = 0.40;
    options.c4gravconfupbound       = 0.50;
    
    % Channel 4 Asph
    options.c4asphconflwbound       = 0.00;
    options.c4asphconfupbound       = 1.00;    

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
% rm_db_1
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_1.bag';
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_1_truth_areas_v3.mat';

% rm_db_2
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_2.bag';
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_2_truth_areas_v3.mat';

% rm_db_3
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_3.bag';
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_3_truth_areas_v3.mat';

% rm_db_4 : NOTE; 1156.8 feet traveled in rm_db_4 338.01 avg sec per scan, 463 clouds in the file
bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_4.bag';
roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_4_truth_areas_v3.mat';

% rm_db_6
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/rm_db_6.bag';
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Truth_Areas_v3/rm_db_6_truth_areas_v3.mat';

% Gravel Training Stuff
% % Redmen Gravel Lot: rm_1 - rm_11
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/rm_3.bag';
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/shortened_big_one/pcd/r_u_a_grav/rm_3.mat';


%% Loading RDF

raw_data_export = {};
disp('Loading RDFs...')
chan_2_c_rdf = load(chan_2_c_rdf_load_string);
chan_3_c_rdf = load(chan_3_c_rdf_load_string);
chan_4_c_rdf = load(chan_4_c_rdf_load_string);
% chan_5_rdf = load(chan_5_rdf_load_string);

chan_2_l_rdf = load(chan_2_l_rdf_load_string);
chan_3_l_rdf = load(chan_3_l_rdf_load_string);
chan_4_l_rdf = load(chan_4_l_rdf_load_string);

chan_2_r_rdf = load(chan_2_r_rdf_load_string);
chan_3_r_rdf = load(chan_3_r_rdf_load_string);
chan_4_r_rdf = load(chan_4_r_rdf_load_string);

% DvG = load(DvG_load_string);
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
% chan_5_c_bounds     = [((90 - options.chan_5_d_ang) * pi/180), ((90 + options.chan_5_d_ang) * pi/180)];

chan_2_l_bounds     = [((135 - options.chan_2_d_ang) * pi/180), ((135 + options.chan_2_d_ang) * pi/180)];
chan_3_l_bounds     = [((135 - options.chan_3_d_ang) * pi/180), ((135 + options.chan_3_d_ang) * pi/180)];
chan_4_l_bounds     = [((135 - options.chan_4_d_ang) * pi/180), ((135 + options.chan_4_d_ang) * pi/180)];
% chan_5_l_bounds     = [((135 - options.chan_5_d_ang) * pi/180), ((135 + options.chan_5_d_ang) * pi/180)];

chan_2_r_bounds     = [((45 - options.chan_2_d_ang) * pi/180), ((45 + options.chan_2_d_ang) * pi/180)];
chan_3_r_bounds     = [((45 - options.chan_3_d_ang) * pi/180), ((45 + options.chan_3_d_ang) * pi/180)];
chan_4_r_bounds     = [((45 - options.chan_4_d_ang) * pi/180), ((45 + options.chan_4_d_ang) * pi/180)];
% chan_5_r_bounds     = [((45 - options.chan_5_d_ang) * pi/180), ((45 + options.chan_5_d_ang) * pi/180)];

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

pcd_class_rate = [];

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


%% Save Location

time_now        = datetime("now","Format","uuuuMMddhhmmss");
time_now        = datestr(time_now,'yyyyMMddhhmmss');

options.export_dir = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Chan_2_3_5_" + string(time_now);

if ~exist(string(options.export_dir),'dir')
    mkdir(string(options.export_dir))
end

% addpath(root_dir)
% CLASSIFICATION_STACK_FOLDER = string(root_dir) + "/CLASSIFICATION_STACK";
% mkdir(CLASSIFICATION_STACK_FOLDER);
addpath(string(options.export_dir));


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
    tform = [];
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
%     xyz_cloud = xyz_cloud(xyz_cloud(:,1) >= 0, :);

    % Channel Split
    xyz_cloud_2 = xyz_cloud(xyz_cloud(:,5) == 1, :); % indexes start @ 0
    xyz_cloud_3 = xyz_cloud(xyz_cloud(:,5) == 2, :); % indexes start @ 0
    xyz_cloud_4 = xyz_cloud(xyz_cloud(:,5) == 3, :); % indexes start @ 0
%     xyz_cloud_5 = xyz_cloud(xyz_cloud(:,5) == 4, :); % indexes start @ 0
    
    %% Classification Area
    
    if ~options.dist_filt_bool

        % CHANNEL 2 CENT

        classify_fun_out_2c{cloud} = classify_fun(xyz_cloud_2, chan_2_c_bounds, chan_2_c_rdf, tform, cloud, options, "2c");

        % CHANNEL 3 CENT

        classify_fun_out_3c{cloud} = classify_fun(xyz_cloud_3, chan_3_c_bounds, chan_3_c_rdf, tform, cloud, options, "3c");

        % CHANNEL 4 CENT

        classify_fun_out_4c{cloud} = classify_fun(xyz_cloud_4, chan_4_c_bounds, chan_4_c_rdf, tform, cloud, options, "4c");

        % CHANNEL 5 CENT

            % nothing yet in chan 5 - maybe later?

        % CHANNEL 2 LEFT

        classify_fun_out_2l{cloud} = classify_fun(xyz_cloud_2, chan_2_l_bounds, chan_2_l_rdf, tform, cloud, options, "2l");

        % CHANNEL 3 LEFT

        classify_fun_out_3l{cloud} = classify_fun(xyz_cloud_3, chan_3_l_bounds, chan_3_l_rdf, tform, cloud, options, "3l");

        % CHANNEL 4 LEFT

        classify_fun_out_4l{cloud} = classify_fun(xyz_cloud_4, chan_4_l_bounds, chan_4_l_rdf, tform, cloud, options, "4l");

        % CHANNEL 5 CENT

            % nothing yet in chan 5 - maybe later?

        % CHANNEL 2 RIGHT

        classify_fun_out_2r{cloud} = classify_fun(xyz_cloud_2, chan_2_r_bounds, chan_2_r_rdf, tform, cloud, options, "2r");

        % CHANNEL 3 RIGHT

        classify_fun_out_3r{cloud} = classify_fun(xyz_cloud_3, chan_3_r_bounds, chan_3_r_rdf, tform, cloud, options, "3r");

        % CHANNEL 4 RIGHT

        classify_fun_out_4r{cloud} = classify_fun(xyz_cloud_4, chan_4_r_bounds, chan_4_r_rdf, tform, cloud, options, "4r");

        % CHANNEL 5 CENT

            % nothing yet in chan 5 - maybe later?
            
    


    %% Distance Filtering
    
    % It is expected that the distances between the 
   
%     elseif options.dist_filt_bool
% 
%         %% Classification Area 2
%         
%         % Classify using slightly different function so that the distances can be exploited
%         classify_fun_out_2c{cloud} = classify_fun_No_Save(xyz_cloud_2, chan_2_c_bounds, chan_2_c_rdf, tform, cloud, options, conf_filt_bool, "2c")
%         classify_fun_out_3c{cloud} = classify_fun_No_Save(xyz_cloud_3, chan_3_c_bounds, chan_3_c_rdf, tform, cloud, options, conf_filt_bool, "3c")
%         classify_fun_out_4c{cloud} = classify_fun_No_Save(xyz_cloud_4, chan_4_c_bounds, chan_4_c_rdf, tform, cloud, options, conf_filt_bool, "4c")
%         
%         classify_fun_out_2l{cloud} = classify_fun_No_Save(xyz_cloud_2, chan_2_l_bounds, chan_2_l_rdf, tform, cloud, options, conf_filt_bool, "2l")
%         classify_fun_out_3l{cloud} = classify_fun_No_Save(xyz_cloud_3, chan_3_l_bounds, chan_3_l_rdf, tform, cloud, options, conf_filt_bool, "3l")
%         classify_fun_out_4l{cloud} = classify_fun_No_Save(xyz_cloud_4, chan_4_l_bounds, chan_4_l_rdf, tform, cloud, options, conf_filt_bool, "4l")
%         
%         classify_fun_out_2r{cloud} = classify_fun_No_Save(xyz_cloud_2, chan_2_r_bounds, chan_2_r_rdf, tform, cloud, options, conf_filt_bool, "2r")
%         classify_fun_out_3r{cloud}{cloud} = classify_fun_No_Save(xyz_cloud_3, chan_3_r_bounds, chan_3_r_rdf, tform, cloud, options, conf_filt_bool, "3r")
%         classify_fun_out_4r = classify_fun_No_Save(xyz_cloud_4, chan_4_r_bounds, chan_4_r_rdf, tform, cloud, options, conf_filt_bool, "4r")
%         
%         
%         %% Getting distance between points
%         
%         % Mean Points
%         c_2_mean = [mean(xyz_cloud_2(classify_fun_out_2c{cloud}.arc_idx_2c,1)), mean(xyz_cloud_2(classify_fun_out_2c{cloud}.arc_idx_2c,2)), mean(xyz_cloud_2(classify_fun_out_2c{cloud}.arc_idx_2c,3))];
%         c_3_mean = [mean(xyz_cloud_3(classify_fun_out_3c{cloud}.arc_idx_3c,1)), mean(xyz_cloud_3(classify_fun_out_3c{cloud}.arc_idx_3c,2)), mean(xyz_cloud_3(classify_fun_out_3c{cloud}.arc_idx_3c,3))];
%         c_4_mean = [mean(xyz_cloud_4(classify_fun_out_4c{cloud}.arc_idx_4c,1)), mean(xyz_cloud_4(classify_fun_out_4c{cloud}.arc_idx_4c,2)), mean(xyz_cloud_4(classify_fun_out_4c{cloud}.arc_idx_4c,3))];
% 
%         l_2_mean = [mean(xyz_cloud_2(classify_fun_out_2l{cloud}.arc_idx_2l,1)), mean(xyz_cloud_2(classify_fun_out_2l{cloud}.arc_idx_2l,2)), mean(xyz_cloud_2(classify_fun_out_2l{cloud}.arc_idx_2l,3))];
%         l_3_mean = [mean(xyz_cloud_3(classify_fun_out_3l{cloud}.arc_idx_3l,1)), mean(xyz_cloud_3(classify_fun_out_3l{cloud}.arc_idx_3l,2)), mean(xyz_cloud_3(classify_fun_out_3l{cloud}.arc_idx_3l,3))];
%         l_4_mean = [mean(xyz_cloud_4(classify_fun_out_4l{cloud}.arc_idx_4l,1)), mean(xyz_cloud_4(classify_fun_out_4l{cloud}.arc_idx_4l,2)), mean(xyz_cloud_4(classify_fun_out_4l{cloud}.arc_idx_4l,3))];
% 
%         r_2_mean = [mean(xyz_cloud_2(classify_fun_out_2r{cloud}.arc_idx_2r,1)), mean(xyz_cloud_2(classify_fun_out_2r{cloud}.arc_idx_2r,2)), mean(xyz_cloud_2(classify_fun_out_2r{cloud}.arc_idx_2r,3))];
%         r_3_mean = [mean(xyz_cloud_3(classify_fun_out_3r{cloud}.arc_idx_3r,1)), mean(xyz_cloud_3(classify_fun_out_3r{cloud}.arc_idx_3r,2)), mean(xyz_cloud_3(classify_fun_out_3r{cloud}.arc_idx_3r,3))];
%         r_4_mean = [mean(xyz_cloud_4(classify_fun_out_4r{cloud}.arc_idx_4r,1)), mean(xyz_cloud_4(classify_fun_out_4r{cloud}.arc_idx_4r,2)), mean(xyz_cloud_4(classify_fun_out_4r{cloud}.arc_idx_4r,3))];
% 
%         % center 
%         c_23_dist{cloud} = sqrt( (c_2_mean(1) - c_3_mean(1))^2 + (c_2_mean(2) - c_3_mean(2))^2 + (c_2_mean(3) - c_3_mean(3))^2);
%         c_34_dist{cloud} = sqrt( (c_4_mean(1) - c_3_mean(1))^2 + (c_4_mean(2) - c_3_mean(2))^2 + (c_4_mean(3) - c_3_mean(3))^2);
% 
%         % left 
%         l_23_dist{cloud} = sqrt( (c_2_mean(1) - c_3_mean(1))^2 + (c_2_mean(2) - c_3_mean(2))^2 + (c_2_mean(3) - c_3_mean(3))^2);
%         l_34_dist{cloud} = sqrt( (c_4_mean(1) - c_3_mean(1))^2 + (c_4_mean(2) - c_3_mean(2))^2 + (c_4_mean(3) - c_3_mean(3))^2);
% 
%         % right 
%         r_23_dist{cloud} = sqrt( (c_2_mean(1) - c_3_mean(1))^2 + (c_2_mean(2) - c_3_mean(2))^2 + (c_2_mean(3) - c_3_mean(3))^2);
%         r_34_dist{cloud} = sqrt( (c_4_mean(1) - c_3_mean(1))^2 + (c_4_mean(2) - c_3_mean(2))^2 + (c_4_mean(3) - c_3_mean(3))^2);
% 
%         %% Consecutive point logic
% 
%         % Center
%         if ~isequal(classify_fun_out_2c{cloud}.Yfit, classify_fun_out_3c{cloud}.Yfit) && c_23_dist{cloud} <= min_dist_23 || ~isequal(classify_fun_out_2c{cloud}.Yfit, classify_fun_out_3c{cloud}.Yfit) && c_23_dist{cloud} >= max_dist_23
% 
%             Yfit_2c = categorical("unknown");
%             Yfit_3c = categorical("unknown");
% 
%         end
% 
%         if ~isequal(classify_fun_out_3c{cloud}.Yfit, classify_fun_out_4c{cloud}.Yfit) && c_34_dist{cloud} <= min_dist_34 || ~isequal(classify_fun_out_3c{cloud}.Yfit, classify_fun_out_4c{cloud}.Yfit) && c_23_dist{cloud} >= max_dist_34
% 
%             Yfit_3c = categorical("unknown");
%             Yfit_4c = categorical("unknown");
% 
%         end
% 
%         % Left
%         if ~isequal(classify_fun_out_2l{cloud}.Yfit, classify_fun_out_3l{cloud}.Yfit) && l_23_dist{cloud} <= min_dist_23 || ~isequal(classify_fun_out_2l{cloud}.Yfit, classify_fun_out_3l{cloud}.Yfit) && l_23_dist{cloud} >= max_dist_23
% 
%             Yfit_2l = categorical("unknown");
%             Yfit_3l = categorical("unknown");
% 
%         end
% 
%         if ~isequal(classify_fun_out_3l{cloud}.Yfit, classify_fun_out_4l{cloud}.Yfit) && l_34_dist{cloud} <= min_dist_34 || ~isequal(classify_fun_out_3l{cloud}.Yfit, classify_fun_out_4l{cloud}.Yfit) && l_23_dist{cloud} >= max_dist_34
% 
%             Yfit_3l = categorical("unknown");
%             Yfit_4l = categorical("unknown");
% 
%         end
% 
%         % Right
%         if ~isequal(classify_fun_out_2r{cloud}.Yfit, classify_fun_out_3r{cloud}.Yfit) && r_23_dist{cloud} <= min_dist_23 || ~isequal(classify_fun_out_2r{cloud}.Yfit, classify_fun_out_3r{cloud}.Yfit) && r_23_dist{cloud} >= max_dist_23
% 
%             Yfit_2c = categorical("unknown");
%             Yfit_3c = categorical("unknown");
% 
%         end
% 
%         if ~isequal(classify_fun_out_3r{cloud}.Yfit, classify_fun_out_4r{cloud}.Yfit) && r_34_dist{cloud} <= min_dist_34 || ~isequal(classify_fun_out_3r{cloud}.Yfit, classify_fun_out_4r{cloud}.Yfit) && r_23_dist{cloud} >= max_dist_34
% 
%             Yfit_3r = categorical("unknown");
%             Yfit_4r = categorical("unknown");
% 
%         end
% 
%         %% Saving the Data for the above area
% 
%         RosbagClassifier_parsave_tform(classify_fun_out_2c.Classification_FileName_2c, Yfit_2c, [], [], xyz_cloud_2(arc_idx_2c,:), tform);
%         RosbagClassifier_parsave_tform(classify_fun_out_3c.Classification_FileName_3c, Yfit_3c, [], [], xyz_cloud_3(arc_idx_3c,:), tform);
%         RosbagClassifier_parsave_tform(classify_fun_out_4c.Classification_FileName_4c, Yfit_4c, [], [], xyz_cloud_4(arc_idx_4c,:), tform);
% 
%         RosbagClassifier_parsave_tform(classify_fun_out_2l.Classification_FileName_2l, Yfit_2l, [], [], xyz_cloud_2(arc_idx_2l,:), tform);
%         RosbagClassifier_parsave_tform(classify_fun_out_3l.Classification_FileName_3l, Yfit_3l, [], [], xyz_cloud_3(arc_idx_3l,:), tform);
%         RosbagClassifier_parsave_tform(classify_fun_out_4l.Classification_FileName_4l, Yfit_4l, [], [], xyz_cloud_4(arc_idx_4l,:), tform);
% 
%         RosbagClassifier_parsave_tform(classify_fun_out_2r.Classification_FileName_2r, Yfit_2r, [], [], xyz_cloud_2(arc_idx_2r,:), tform);
%         RosbagClassifier_parsave_tform(classify_fun_out_3r.Classification_FileName_3r, Yfit_3r, [], [], xyz_cloud_3(arc_idx_3r,:), tform);
%         RosbagClassifier_parsave_tform(classify_fun_out_4r.Classification_FileName_4r, Yfit_4r, [], [], xyz_cloud_4(arc_idx_4r,:), tform);
        
        
    end  % distance filtering
    
    
    %% Weightbar
    
    % Progress Bar
	parfor_progress;

    pcd_class_rate_rate{cloud} = toc(rate);
    
    
end


parfor_progress(0);

disp('Classification Complete!')

disp(toc(classy))

%% Quickly export the discovered features into a table

% if data_comp_bool
%     
%     export_chans(chan_2_c_table_export, chan_3_c_table_export, chan_4_c_table_export, terrain_opt);
%     
% end


%% Load the Classification folder and grab the results

classification_list             = dir(fullfile(string(options.export_dir),'/*.mat'));

num_files                       = length(classification_list);


%% Apphending all the results to an array

disp('Loading Files...')

load_result_bar = waitbar(0, "Loading Files...");

for class_idx = 1:1:num_files
    
    %% Var Init
  
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
        warning('Label may be incorrectly formatted')
    end


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
    
    if isequal(cell2mat(label), 'unknown')    && chan_number == 2
        Unkn_All_Append_Array_2             = [Unkn_All_Append_Array_2; Classification_Result.xyzi];
        Unkn_Avg_Append_Array_2             = [Unkn_Avg_Append_Array_2; Classification_Result.avg_xyz];
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
    
    if isequal(cell2mat(label), 'unknown')    && chan_number == 3
        Unkn_All_Append_Array_3             = [Unkn_All_Append_Array_3; Classification_Result.xyzi];
        Unkn_Avg_Append_Array_3             = [Unkn_Avg_Append_Array_3; Classification_Result.avg_xyz];
    end
    
    
    % Channel 4
    if isequal(cell2mat(label), 'gravel')   && chan_number == 4
        Grav_All_Append_Array_4             = [Grav_All_Append_Array_4; Classification_Result.xyzi];
        Grav_Avg_Append_Array_4             = [Grav_Avg_Append_Array_4; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'asphalt')  && chan_number == 4
        Asph_All_Append_Array_4             = [Asph_All_Append_Array_4; Classification_Result.xyzi];
        Asph_Avg_Append_Array_4             = [Asph_Avg_Append_Array_4; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'grass') 	&& chan_number == 4
        Gras_All_Append_Array_4             = [Gras_All_Append_Array_4; Classification_Result.xyzi];
        Gras_Avg_Append_Array_4             = [Gras_Avg_Append_Array_4; Classification_Result.avg_xyz];
    end
    
    if isequal(cell2mat(label), 'unknown')    && chan_number == 4
        Unkn_All_Append_Array_4             = [Unkn_All_Append_Array_4; Classification_Result.xyzi];
        Unkn_Avg_Append_Array_4             = [Unkn_Avg_Append_Array_4; Classification_Result.avg_xyz];
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

disp('Files loaded!')


%% Arrays to single struct

if ~isempty(Grav_Avg_Append_Array_2) || ~isempty(Asph_Avg_Append_Array_2) || ~isempty(Unkn_Avg_Append_Array_2)
    
    avg_cell_store{2}.Grav = Grav_Avg_Append_Array_2;
    avg_cell_store{2}.Asph = Asph_Avg_Append_Array_2;
    avg_cell_store{2}.Unkn = Unkn_Avg_Append_Array_2;

end

if ~isempty(Grav_Avg_Append_Array_3) || ~isempty(Asph_Avg_Append_Array_3) || ~isempty(Unkn_Avg_Append_Array_3)

    avg_cell_store{3}.Grav = Grav_Avg_Append_Array_3;
    avg_cell_store{3}.Asph = Asph_Avg_Append_Array_3;
    avg_cell_store{3}.Unkn = Unkn_Avg_Append_Array_3;

end

if ~isempty(Grav_Avg_Append_Array_4) || ~isempty(Asph_Avg_Append_Array_4) || ~isempty(Unkn_Avg_Append_Array_4)

    avg_cell_store{4}.Grav = Grav_Avg_Append_Array_4;
    avg_cell_store{4}.Asph = Asph_Avg_Append_Array_4;
    avg_cell_store{4}.Unkn = Unkn_Avg_Append_Array_4;

end

% if ~isempty(Grav_Avg_Append_Array_5) || ~isempty(Asph_Avg_Append_Array_5) || ~isempty(Unkn_Avg_Append_Array_5)
% 
%     avg_cell_store{5}.Grav = Grav_Avg_Append_Array_5;
%     avg_cell_store{5}.Asph = Asph_Avg_Append_Array_5;
%     avg_cell_store{5}.Unkn = Unkn_Avg_Append_Array_5;
% 
% end


%% Get Plot Limits

disp('Plotting Results')

try
    
    x_min_lim = min([Grav_All_Append_Array_2(:,1); Asph_All_Append_Array_2(:,1); Unkn_All_Append_Array_2(:,1)]) - 5;
    x_max_lim = max([Grav_All_Append_Array_2(:,1); Asph_All_Append_Array_2(:,1); Unkn_All_Append_Array_2(:,1)]) + 5;

    y_min_lim = min([Grav_All_Append_Array_2(:,2); Asph_All_Append_Array_2(:,2); Unkn_All_Append_Array_2(:,2)]) - 5;
    y_max_lim = max([Grav_All_Append_Array_2(:,2); Asph_All_Append_Array_2(:,2); Unkn_All_Append_Array_2(:,2)]) + 5;
    
    z_min_lim = min([Grav_All_Append_Array_2(:,3); Asph_All_Append_Array_2(:,3); Unkn_All_Append_Array_2(:,3)]) - 5;
    z_max_lim = max([Grav_All_Append_Array_2(:,3); Asph_All_Append_Array_2(:,3); Unkn_All_Append_Array_2(:,3)]) + 5;
    
    
catch
    
    x_min_lim = -100;
    x_max_lim = 100;
    y_min_lim = -100;
    y_max_lim = 100;
    z_min_lim = -20;
    z_max_lim = 20;
    
    
end

options.max_h = z_max_lim;


%% Score the Results

class_score_function_test(avg_cell_store, Manual_Classfied_Areas, options)



%% Plotting All Points

if options.plot_all_bool

    % All points
    result_all_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);

    hold all

    % Channel 2
    try
        plot3(Grav_All_Append_Array_2(:,1), Grav_All_Append_Array_2(:,2), Grav_All_Append_Array_2(:,3), 'c.', 'MarkerSize', options.c2markersize)
    catch
        disp('No Grav Data on Chan 2!')
    end

    try
        plot3(Asph_All_Append_Array_2(:,1), Asph_All_Append_Array_2(:,2), Asph_All_Append_Array_2(:,3), 'k.', 'MarkerSize', options.c2markersize)
    catch
        disp('No Asph Dataon Chan 2!')
    end

    % try
    %     plot3(Gras_All_Append_Array_2(:,1), Gras_All_Append_Array_2(:,2), Gras_All_Append_Array_2(:,3), 'g.', 'MarkerSize', options.c2markersize)
    % catch
    %     disp('No Gras Dataon Chan 2!')
    % end

    try
        plot3(Unkn_All_Append_Array_2(:,1), Unkn_All_Append_Array_2(:,2), Unkn_All_Append_Array_2(:,3), 'r.', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 2!')
    end

    % Channel 3
    try
        plot3(Grav_All_Append_Array_3(:,1), Grav_All_Append_Array_3(:,2), Grav_All_Append_Array_3(:,3), 'c^', 'MarkerSize', 10)
    catch
        disp('No Grav Data on Chan 3!')
    end

    try
        plot3(Asph_All_Append_Array_3(:,1), Asph_All_Append_Array_3(:,2), Asph_All_Append_Array_3(:,3), 'k^', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 3!')
    end

    % try
    %     plot3(Gras_All_Append_Array_3(:,1), Gras_All_Append_Array_3(:,2), Gras_All_Append_Array_3(:,3), 'g^', 'MarkerSize', 10)
    % catch
    %     disp('No Gras Dataon Chan 3!')
    % end

    try
        plot3(Unkn_All_Append_Array_3(:,1), Unkn_All_Append_Array_3(:,2), Unkn_All_Append_Array_3(:,3), 'r^', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 3!')
    end

    % Channel 4
    try
        plot3(Grav_All_Append_Array_4(:,1), Grav_All_Append_Array_4(:,2), Grav_All_Append_Array_4(:,3), 'cv', 'MarkerSize', 10)
    catch
        disp('No Grav Data on Chan 4!')
    end

    try
        plot3(Asph_All_Append_Array_4(:,1), Asph_All_Append_Array_4(:,2), Asph_All_Append_Array_4(:,3), 'kv', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 4!')
    end

    % try
    %     plot3(Gras_All_Append_Array_4(:,1), Gras_All_Append_Array_4(:,2), Gras_All_Append_Array_4(:,3), 'gv', 'MarkerSize', 10)
    % catch
    %     disp('No Gras Dataon Chan 4!')
    % end

    try
        plot3(Unkn_All_Append_Array_4(:,1), Unkn_All_Append_Array_4(:,2), Unkn_All_Append_Array_4(:,3), 'rv', 'MarkerSize', 10)
    catch
        disp('No Asph Dataon Chan 4!')
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

    % try
    %     plot3(Gras_All_Append_Array_5(:,1), Gras_All_Append_Array_5(:,2), Gras_All_Append_Array_5(:,3), 'gx', 'MarkerSize', 10)
    % catch
    %     disp('No Gras Data on Chan 5!')
    % end

    try
        plot3(Unkn_All_Append_Array_5(:,1), Unkn_All_Append_Array_5(:,2), Unkn_All_Append_Array_5(:,3), 'rx', 'MarkerSize', 10)
    catch
        disp('No Asph Data on Chan 5!')
    end

    axis('equal')
    axis off
    view([pi/2 0 90])

    % MCA_plotter(Manual_Classfied_Areas)

    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);

    h(1) = plot(NaN,NaN,'oc');
    h(2) = plot(NaN,NaN,'ok');
    h(3) = plot(NaN,NaN,'or');
    l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{red} Unkn'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';

    ax = gca;
    ax.Clipping = 'off';

end

%% Average points

if options.plot_avg_bool

    result_avg_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);

    hold all

    % Channel 2
    try
        plot3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), 'co', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Grav Data on Chan 2!')
    end

    try   
        plot3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), 'ko', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Asph Data on Chan 2!')
    end

    % try
    %     plot3(Gras_Avg_Append_Array_2(:,1), Gras_Avg_Append_Array_2(:,2), Gras_Avg_Append_Array_2(:,3), 'go', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
    % catch
    %     disp('No Gras Data on Chan 2!')
    % end

    try
        plot3(Unkn_Avg_Append_Array_2(:,1), Unkn_Avg_Append_Array_2(:,2), Unkn_Avg_Append_Array_2(:,3), 'ro', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
    catch
        disp('No Unkn Data on Chan 2!')
    end


    % Channel 3
    try
        plot3(Grav_Avg_Append_Array_3(:,1), Grav_Avg_Append_Array_3(:,2), Grav_Avg_Append_Array_3(:,3), 'co', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Grav Data on Chan 3!')
    end

    try   
        plot3(Asph_Avg_Append_Array_3(:,1), Asph_Avg_Append_Array_3(:,2), Asph_Avg_Append_Array_3(:,3), 'ko', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Asph Data on Chan 3!')
    end

%     try
%         plot3(Gras_Avg_Append_Array_3(:,1), Gras_Avg_Append_Array_3(:,2), Gras_Avg_Append_Array_3(:,3), 'g^', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
%     catch
%         disp('No Gras Data on Chan 3!')
%     end

    try
        plot3(Unkn_Avg_Append_Array_3(:,1), Unkn_Avg_Append_Array_3(:,2), Unkn_Avg_Append_Array_3(:,3), 'ro', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
    catch
        disp('No Unkn Data on Chan 3!')
    end

    % Channel 4
    try
        plot3(Grav_Avg_Append_Array_4(:,1), Grav_Avg_Append_Array_4(:,2), Grav_Avg_Append_Array_4(:,3), 'co', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Grav Data on Chan 4!')
    end

    try   
        plot3(Asph_Avg_Append_Array_4(:,1), Asph_Avg_Append_Array_4(:,2), Asph_Avg_Append_Array_4(:,3), 'ko', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Asph Data on Chan 4!')
    end

    % try
    %     plot3(Gras_Avg_Append_Array_4(:,1), Gras_Avg_Append_Array_4(:,2), Gras_Avg_Append_Array_4(:,3), 'gv', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
    % catch
    %     disp('No Gras Data on Chan 4!')
    % end

    try
        plot3(Unkn_Avg_Append_Array_4(:,1), Unkn_Avg_Append_Array_4(:,2), Unkn_Avg_Append_Array_4(:,3), 'ro', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
    catch
        disp('No Unkn Data on Chan 4!')
    end


    % Channel 5
    % try
    %     plot3(Grav_Avg_Append_Array_5(:,1), Grav_Avg_Append_Array_5(:,2), Grav_Avg_Append_Array_5(:,3), 'cx', 'MarkerSize', 15, 'Linewidth', 5)
    % catch
    %     disp('No Grav Data on Chan 5!')
    % end
    % 
    % try   
    %     plot3(Asph_Avg_Append_Array_5(:,1), Asph_Avg_Append_Array_5(:,2), Asph_Avg_Append_Array_5(:,3), 'kx', 'MarkerSize', 15, 'Linewidth', 5)
    % catch
    %     disp('No Asph Data on Chan 5!')
    % end
    % 
    % try
    %     plot3(Gras_Avg_Append_Array_5(:,1), Gras_Avg_Append_Array_5(:,2), Gras_Avg_Append_Array_5(:,3), 'gx', 'MarkerSize', 15, 'Linewidth', 5)
    % catch
    %     disp('No Gras Data on Chan 5!')
    % end

    axis('equal')
    axis off
    view([0 0 90])

    hold on

%     MCA_plotter(Manual_Classfied_Areas)

    xlim([x_min_lim x_max_lim]);
    ylim([y_min_lim y_max_lim]);

    h(1) = plot(NaN,NaN,'oc', 'LineWidth', 20);
    h(2) = plot(NaN,NaN,'ok', 'LineWidth', 20);
    h(3) = plot(NaN,NaN,'or', 'LineWidth', 20);
    l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{red} Unkn'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';

    ax2 = gca;
    ax2.Clipping = 'off';

end

%% PCD Classification Rate - INCLUDING SAVING

if options.plot_rate_bool

%     plot(pcd_class_rate)

%     time_struct        = pcd_class_rate.par2struct;
%     time_extract        = (time_struct.ItStop - time_struct.ItStart) / max(time_struct.Worker);

    time_extract        = cell2mat(pcd_class_rate_rate);

    max_time            = max(time_extract); %s
    min_time            = min(time_extract); %s

    max_Hz              = 1 / min(time_extract); %Hz
    min_Hz              = 1 / max(time_extract); %Hz

    pcd_class_rate_Hz    =  time_extract.^(-1);

    Move_mean_time      = movmean(time_extract, options.move_avg_size);
    Move_mean_Hz        = movmean(pcd_class_rate_Hz, options.move_avg_size);

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

%     ylim([min_time max_time])

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

end

%% Plot classification rate - Classification only (classify_fun_out)

if options.plot_class_rate_bool
    
    plot_class_rate_fun(classify_fun_out_2c, classify_fun_out_3c, classify_fun_out_4c, classify_fun_out_2l, classify_fun_out_3l, classify_fun_out_4l, classify_fun_out_2r, classify_fun_out_3r, classify_fun_out_4r, options)
    

    
    
end


%% End Program 

disp('End Program!')





%% old code dump

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
% Down 1Lucin Cutoff
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/03_29_14_54_16_all.pcd_20232103130404.mat'; terrain_opt = 6; % asph2
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/2023-03-29-14-54-16.bag';
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/foliage_grab_2FROMFILE2023-03-29-14-54-16.pcd_20230904140433.mat';
% roi_file = 'down_1.pcd_FROM_FILE_2023-03-29-14-5.pcd_20230412160441.mat';
% terrain_opt = 3; foliage
% terrain_opt = 6;
% roi_select = 3;

% Down 2
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/Down_2_03_29_14_57_17_25to150.pcd.pcd_20233803100451.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/2023-03-29-14-57-17.bag';
% roi_select = 1;
% terrain_opt = 1;

% Down 3
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/Down_3_29_14_59_48_250to400.pcd.pcd_20234003100412.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Down/2023-03-29-14-59-48.bag';
% roi_select = 1;
% terrain_opt = 1;

% % Up 1
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/Up_1_29_14_53_21_1tolen.pcd_20234103100425.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/2023-03-29-14-53-21.bag';
% roi_select = 1;
% terrain_opt = 1;

% Up 2
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/2023-03-29-14-55-44.bag.mat'; terrain_opt = 6;
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/foliage_grab_FROM_FILE_2023-03-29-14-55-44_20230104140446.mat'; terrain_opt = 3;
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/2023-03-29-14-55-44.bag';
% roi_select = 1;

% Up 3
% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/Up_3_14_58_13_325to450.pcd.pcd_20234303100447.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/Up/2023-03-29-14-58-13.bag';
% roi_select = 1;

