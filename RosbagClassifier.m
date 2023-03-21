%==========================================================================
%                       Travis Moleski/Rhett Huston
%
%                     FILE CREATION DATE: 10/19/2022
%
%                      Bulk_Training_Data_Extract.m
%
% 
%==========================================================================

%% Clear & Setup Workspace

clc; clear; close all
format compact


%% Options

% Left | Cent | Right Area Center Angle
% Center is Constant
cent_cent           = 90 * pi/180;

% Left
chan_2_cent_left    = 110 * pi/180;
chan_5_cent_left    = 105 * pi/180;

% Right (needed only four characters)
chan_2_cent_rite    =  75 * pi/180;
chan_5_cent_rite    =  70 * pi/180;

% Angle +- to add to center
chan_2_d_ang        = 5 * pi/180;
chan_5_d_ang        = 3 * pi/180;

% Angle Select
% class_angles = [125 105 100 80 75 55 ];

% Which RDF to load?
% rdf_load_string = 'test_07_chan_2_20_spltz.mat';
chan_2_rdf_load_string = '26_3_10_Test_0720_splits_TreeBagger.mat';
chan_5_rdf_load_string = '86_3_10_Test_11_100_splitz_TreeBagger.mat';

% roi/rosbag PAIRS - 1 ROI per file

% Gravel Lot 1
% roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_arc_width_controlol.mat.mat';
% bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/gravel_lot/2023-03-09-14-46-23.bag';
% terrain_opt = 1;
% roi_select = 1;

% Pavement 1, 2
roi_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/man_roi/Manual_Classified_PCD_pavement_1_roi.mat.mat';
bag_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/03_13_2023_shortened_coach_sturbois/2023-03-13-10-56-38.bag';
terrain_opt = 5;
roi_select = 1; %1,2


%% Loading RDF

raw_data_export = {};
disp('Loading RDF...')
chan_2_rdf = load(chan_2_rdf_load_string);
chan_5_rdf = load(chan_5_rdf_load_string);
disp('RDF Loaded!')


%% Variable Initiation

% Reference Frames
LiDAR_Ref_Frame             = [0; 1.584; 1.444];
IMU_Ref_Frame               = [0; 0.336; -0.046];

% Correction frame:         LiDAR_Ref_Frame - IMU_Ref_Frame [Y X Z]
gps_to_lidar_diff           = [(LiDAR_Ref_Frame(1) - IMU_Ref_Frame(1)), (LiDAR_Ref_Frame(2) - IMU_Ref_Frame(2)), (LiDAR_Ref_Frame(3) - IMU_Ref_Frame(3))]; 

% Angle Selection
chan_2_left_angs   = [chan_2_cent_left-chan_2_d_ang  chan_2_cent_left+chan_2_d_ang];
chan_2_cent_angs   = [cent_cent-chan_2_d_ang  cent_cent+chan_2_d_ang];
chan_2_rite_angs   = [chan_2_cent_rite-chan_2_d_ang  chan_2_cent_rite+chan_2_d_ang];

chan_5_left_angs   = [chan_5_cent_left-chan_5_d_ang  chan_5_cent_left+chan_5_d_ang];
chan_5_cent_angs   = [cent_cent-chan_5_d_ang  cent_cent+chan_5_d_ang];
chan_5_rite_angs   = [chan_5_cent_rite-chan_5_d_ang  chan_5_cent_rite+chan_5_d_ang];

% Array Inits
% Chan 2
grav_array_temp_2         = []; asph_array_temp_2       = []; foli_array_temp_2       = []; gras_array_temp_2       = []; 
grav_avg_array_temp_2     = []; asph_avg_array_temp_2   = []; foli_avg_array_temp_2   = []; gras_avg_array_temp_2   = []; 
Grav_All_Append_Array_2   = []; Asph_All_Append_Array_2 = []; Foli_All_Append_Array_2 = []; Gras_All_Append_Array_2 = [];
Grav_Avg_Append_Array_2   = []; Asph_Avg_Append_Array_2 = []; Foli_Avg_Append_Array_2 = []; Gras_Avg_Append_Array_2 = [];

% Chan 5
grav_array_temp_5         = []; asph_array_temp_5       = []; foli_array_temp_5       = []; gras_array_temp_5       = []; 
grav_avg_array_temp_5     = []; asph_avg_array_temp_5   = []; foli_avg_array_temp_5   = []; gras_avg_array_temp_5   = []; 
Grav_All_Append_Array_5   = []; Asph_All_Append_Array_5 = []; Foli_All_Append_Array_5 = []; Gras_All_Append_Array_5 = [];
Grav_Avg_Append_Array_5   = []; Asph_Avg_Append_Array_5 = []; Foli_Avg_Append_Array_5 = []; Gras_Avg_Append_Array_5 = [];

raw_data_export = []; save_folder = [];
model_RANSAC = []; model_MLS = [];

% Legend Stuff
h = zeros(1,3);

% Size of figures
fig_size_array          = [10 10 3500 1600];


%% Load Stuff

% Load the ROI file
load(roi_file);

% Plot Color lol
if terrain_opt == 1
    to_plot_xy_roi = Manual_Classfied_Areas.grav{roi_select};
%     to_plot_xy_roi_2 = Manual_Classfied_Areas.grav{2};
%     color = 'red';
elseif terrain_opt == 2
    to_plot_xy_roi = Manual_Classfied_Areas.chip{roi_select};
%     color = 'black';
elseif terrain_opt == 3
    to_plot_xy_roi = Manual_Classfied_Areas.foli{roi_select};
%     color = 'magenta';
elseif terrain_opt == 4
    to_plot_xy_roi = Manual_Classfied_Areas.gras{roi_select};
%     color = 'green';
elseif terrain_opt == 5
    to_plot_xy_roi = Manual_Classfied_Areas.asph{roi_select};
    to_plot_xy_roi_2 = Manual_Classfied_Areas.asph{2};
%     color = 'yellow';
end

color = 'red';

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

root_dir = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Channel_2_Only/" + string(chan_2_rdf_load_string) + "Chan_2z" + string(time_now);

if ~exist(root_dir,'dir')
    mkdir(root_dir)
end

addpath(root_dir)
CLASSIFICATION_STACK_FOLDER = string(root_dir) + "/CLASSIFICATION_STACK";
mkdir(CLASSIFICATION_STACK_FOLDER);
addpath(CLASSIFICATION_STACK_FOLDER);


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


%% Doing the data

fprintf('Max time delta is %f sec \n',max(abs(diffs)));

% h = waitbar(0, "Grabbing the dataz...");

parfor_progress(cloud_break);

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
     
    % Comment Here
    groundTruthTrajectory       = [xEast, yNorth, zUp] * gps2lidar ;
    
    % Comment Here
    gps_to_lidar_diff_update    = gps_to_lidar_diff * LidarOffset2gps * rotate_update;

    % Comment Here
    LidarxEast                  = groundTruthTrajectory(1)  + gps_to_lidar_diff_update(1);
    LidaryNorth                 = groundTruthTrajectory(2)  + gps_to_lidar_diff_update(2);
    LidarzUp                    = groundTruthTrajectory(3)  + gps_to_lidar_diff_update(3);

    % Comment here
%     groundTruthTrajectory       = groundTruthTrajectory;
    lidarTrajectory             = [LidarxEast, LidaryNorth, LidarzUp];
    
    % Reading the current cloud for xyz, intensity, and ring (channel) values
    xyz_cloud                   = rosReadXYZ(current_cloud);
    intensities                 = rosReadField(current_cloud, 'intensity');
    ring                        = rosReadField(current_cloud, 'ring');
    xyz_cloud(:,4)              = intensities;
    xyz_cloud(:,5)              = ring;
    
    %% RANSAC and MLS
 
%     x_ptA                       = ptCloudSource.Location(:,1);
%     y_ptA                       = ptCloudSource.Location(:,2);
%     z_ptA                       = ptCloudSource.Location(:,3);
%     xyz_mll                     = [x_ptA y_ptA z_ptA];
%     model_MLS                   = MLL_plane_proj(xyz_mll(isfinite(xyz_mll(:,1)), :));
    % RANSAC - MATLAB
%     maxDistance                 = 0.5;
%     model_RANSAC                = pcfitplane(ptCloudSource, maxDistance);

    %% Trimming data
    
    % Data Clean-up
    xyz_cloud = xyz_cloud( ~any( isnan(xyz_cloud) | isinf(xyz_cloud), 2),:);
    xyz_cloud = xyz_cloud(xyz_cloud(:,1) >= 0, :);

    % Channel Split
    xyz_cloud_2 = xyz_cloud(xyz_cloud(:,5) == 1, :);
    xyz_cloud_5 = xyz_cloud(xyz_cloud(:,5) == 5, :);
    
    % DEBUG
%     figure
%     ptCloudSource = pointCloud([xyz_cloud(:,1), xyz_cloud(:,2), xyz_cloud(:,3)], 'Intensity',  xyz_cloud(:,4));
%     pcshow(ptCloudSource)
%     pause


    %% Getting Left | Center | Right areas
    
    % CHANNEL 2
    % Chan_2 - LEFT
    chan_2_left_idxs = find((atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) > chan_2_left_angs(1) & (atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) <  chan_2_left_angs(2));
        
    % Chan_2 - CENTER
    chan_2_cent_idxs = find((atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) > chan_2_cent_angs(1) & (atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) <  chan_2_cent_angs(2));
    
    % Chan_2 - RIGHT
    chan_2_rite_idxs = find((atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) > chan_2_rite_angs(1) & (atan2(xyz_cloud_2(:,1), xyz_cloud_2(:,2))) < chan_2_rite_angs(2));
    
    % CHANNEL 5
    % Chan_5 - LEFT
    chan_5_left_idxs = find((atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) > chan_5_left_angs(1) & (atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) <  chan_5_left_angs(2));
        
    % Chan_5 - CENTER
    chan_5_cent_idxs = find((atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) > chan_5_cent_angs(1) & (atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) <  chan_5_cent_angs(2));
    
    % Chan_5 - RIGHT
    chan_5_rite_idxs = find((atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) > chan_5_rite_angs(1) & (atan2(xyz_cloud_5(:,1), xyz_cloud_5(:,2))) < chan_5_rite_angs(2));
    
    % Appending all to single thing so we can loop through it to save on
    % pixel real-estate (lots of repeated code)
%     chan_idxs{1,:} = chan_2_left_idxs;

    
    %% Applying Transform

    % Creating the transform object
    tform           = rigid3d(rotate_update, [lidarTrajectory(1) lidarTrajectory(2) lidarTrajectory(3)]);
    
    % Transforming the point cloud
    xyz_cloud_2(:,1:3) = xyz_cloud_2(:,1:3) * tform.Rotation + tform.Translation;
    xyz_cloud_5(:,1:3) = xyz_cloud_5(:,1:3) * tform.Rotation + tform.Translation;
    

    %% Classify C2 LEFT

    table_export = get_feats_2(xyz_cloud_2(chan_2_left_idxs,:),[]);

    [Yfit, scores, stdevs]              = predict(chan_2_rdf.Mdl, table_export);

    %Creates pcd file name
    n_strPadded             = sprintf('%08d', cloud);
    Classification_FileName = string(CLASSIFICATION_STACK_FOLDER) + "/LEFT_2_" + string(n_strPadded) + ".mat";

    % Saves it
    RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_2(chan_2_left_idxs,:))


    %% Classify C2 CENTER

    table_export = get_feats_2(xyz_cloud_2(chan_2_cent_idxs,:),[]);

    [Yfit, scores, stdevs]              = predict(chan_2_rdf.Mdl, table_export);

    %Creates pcd file name
    n_strPadded             = sprintf('%08d', cloud);
    Classification_FileName = string(CLASSIFICATION_STACK_FOLDER) + "/FRONT_2_" + string(n_strPadded) + ".mat";

    % Saves it
    RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_2(chan_2_cent_idxs,:))


    %% Classify C2 RIGHT

    table_export = get_feats_2(xyz_cloud_2(chan_2_rite_idxs,:),[]);

    [Yfit, scores, stdevs]              = predict(chan_2_rdf.Mdl, table_export);

    %Creates pcd file name
    n_strPadded             = sprintf('%08d', cloud);
    Classification_FileName = string(CLASSIFICATION_STACK_FOLDER) + "/RIGHT_2_" + string(n_strPadded) + ".mat";

    % Saves it
    RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_2(chan_2_rite_idxs,:))
    
    
%     %% Classify C5 LEFT
% 
%     table_export = get_feats_2(xyz_cloud_5(chan_5_left_idxs,:),[]);
% 
%     [Yfit, scores, stdevs]              = predict(chan_5_rdf.Mdl, table_export);
% 
%     %Creates pcd file name
%     n_strPadded             = sprintf('%08d', cloud);
%     Classification_FileName = string(CLASSIFICATION_STACK_FOLDER) + "/LEFT_5_" + string(n_strPadded) + ".mat";
% 
%     % Saves it
%     RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_5(chan_5_left_idxs,:))
% 
% 
%     %% Classify C5 CENTER
% 
%     table_export = get_feats_2(xyz_cloud_5(chan_5_cent_idxs,:),[]);
% 
%     [Yfit, scores, stdevs]              = predict(chan_5_rdf.Mdl, table_export);
% 
%     %Creates pcd file name
%     n_strPadded             = sprintf('%08d', cloud);
%     Classification_FileName = string(CLASSIFICATION_STACK_FOLDER) + "/FRONT_5_" + string(n_strPadded) + ".mat";
% 
%     % Saves it
%     RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_5(chan_5_cent_idxs,:))
% 
% 
%     %% Classify C5 RIGHT
% 
%     table_export = get_feats_2(xyz_cloud_5(chan_5_rite_idxs,:),[]);
% 
%     [Yfit, scores, stdevs]              = predict(chan_5_rdf.Mdl, table_export);
% 
%     %Creates pcd file name
%     n_strPadded             = sprintf('%08d', cloud);
%     Classification_FileName = string(CLASSIFICATION_STACK_FOLDER) + "/RIGHT_5_" + string(n_strPadded) + ".mat";
% 
%     % Saves it
%     RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud_5(chan_5_rite_idxs,:))
    
    

    %% Weightbar
    
	parfor_progress;
    

end

parfor_progress(0);


%% Load the Classification folder and grab the results

classification_list             = dir(fullfile(CLASSIFICATION_STACK_FOLDER,'/*.mat'));


%% Apphending all the results to an array

for class_idx = 1:1:length(classification_list)
    
    % Starting the timer for the progress bar estimated time
    tform_start = tic;

    %% Clearing Vars
    
    grav_array_temp_2 = []; asph_array_temp_2 = []; gras_array_temp_2 = [];
    grav_avg_array_temp_2 = []; asph_avg_array_temp_2 = []; gras_avg_array_temp_2 = [];
    
    label_cell = [];

    
    %% Loading Classification

    load(classification_list(class_idx).name)
    
    
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
        if ~isempty(Classification_Result.label)

            if isequal(cell2mat(label), 'gravel')
                grav_array_temp_2         = [grav_array_temp_2; Classification_Result.xyzi];
                grav_avg_array_temp_2     = [grav_avg_array_temp_2; Classification_Result.avg_xyz];
            end
            
            if isequal(cell2mat(label), 'asphalt')
                asph_array_temp_2         = [asph_array_temp_2; Classification_Result.xyzi];
                asph_avg_array_temp_2     = [asph_avg_array_temp_2; Classification_Result.avg_xyz];
            end
            
            if isequal(cell2mat(label), 'grass')
                gras_array_temp_2         = [gras_array_temp_2; Classification_Result.xyzi];
                gras_avg_array_temp_2     = [gras_avg_array_temp_2; Classification_Result.avg_xyz];
            end

        end % Go through all the result
        
%     end % Going through the classification results
    

    %% Apphending all results
    
    % I supply two types of arrays - one having all the points and one
    % having the average xyz of the points per classified quadrant

    if ~isempty(grav_array_temp_2)
        Grav_All_Append_Array_2           = [Grav_All_Append_Array_2; grav_array_temp_2];
        Grav_Avg_Append_Array_2           = [Grav_Avg_Append_Array_2; grav_avg_array_temp_2];
    end
    
    if ~isempty(asph_array_temp_2)
        Asph_All_Append_Array_2               = [Asph_All_Append_Array_2; asph_array_temp_2];
        Asph_Avg_Append_Array_2           = [Asph_Avg_Append_Array_2; asph_avg_array_temp_2];
    end
    
    if ~isempty(gras_array_temp_2)
        Gras_All_Append_Array_2           = [Gras_All_Append_Array_2; gras_array_temp_2];
        Gras_Avg_Append_Array_2           = [Gras_Avg_Append_Array_2; gras_avg_array_temp_2];
    end

end % Going through the transform list


%% PLEASE just be good. :'(

disp('Plotting Results')
% 

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
result_all_fig = figure('DefaultAxesFontSize', 14)

hold all

try
    plot3(Grav_All_Append_Array_2(:,1), Grav_All_Append_Array_2(:,2), Grav_All_Append_Array_2(:,3), 'c.', 'MarkerSize', 3.5)
catch
    disp('No Grav Data!')
end
   
try
    plot3(Asph_All_Append_Array_2(:,1), Asph_All_Append_Array_2(:,2), Asph_All_Append_Array_2(:,3), 'k.', 'MarkerSize', 3.5)
catch
    disp('No Asph Data!')
end

try
    plot3(Gras_All_Append_Array_2(:,1), Gras_All_Append_Array_2(:,2), Gras_All_Append_Array_2(:,3), 'g.', 'MarkerSize', 3.5)
catch
    disp('No Gras Data!')
end

axis('equal')
axis off
view([0 0 90])

hold on
pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
plot(pgon,'FaceColor',color,'FaceAlpha',0.15)

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

try
    plot3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), 'c.', 'MarkerSize', 8.5)
catch
    disp('No Grav Data!')
end

try   
    plot3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), 'k.', 'MarkerSize', 8.5)
catch
    disp('No Asph Data!')
end

try
    plot3(Gras_Avg_Append_Array_2(:,1), Gras_Avg_Append_Array_2(:,2), Gras_Avg_Append_Array_2(:,3), 'g.', 'MarkerSize', 8.5)
catch
    disp('No Gras Data!')
end

axis('equal')
axis off
view([0 0 90])

hold on
pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
plot(pgon,'FaceColor',color,'FaceAlpha',0.15)

try
    pgon_2 = polyshape(to_plot_xy_roi_2(:,1),to_plot_xy_roi_2(:,2));
catch
    disp('Only 1 area')
end

xlim([x_min_lim x_max_lim]);
ylim([y_min_lim y_max_lim]);

h(1) = plot(NaN,NaN,'oc');
h(2) = plot(NaN,NaN,'ok');
h(3) = plot(NaN,NaN,'og');
l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

ax2 = gca;
ax2.Clipping = 'off';






%% save the raw_data_export
% 
% Filename        = save_folder + "/raw_data_export_" + string(time_now) + "_" + string(terrain_type) + "_" + string(roi_select) + ".mat";
% 
% save(Filename, 'raw_data_export')


%% Compiling the map
% 
% disp("Making the map, sire...")
% pointCloudList = pccat([pointCloudList{:}]);

%% Displaying the map
% 
% hold on
% 
% % Plotting the line between the lidar and gps
% for point = 1:length(lidar_pos_store)
%     
%     plot3([lidar_pos_store(point,1) gps_pos_store(point,1)],...
%           [lidar_pos_store(point,2) gps_pos_store(point,2)],...
%           [lidar_pos_store(point,3) gps_pos_store(point,3)],...
%           'linewidth',3)
%       
% end
% 
% % Plotting the lidar and gps points
% scatter3(gps_pos_store(1,1),gps_pos_store(1,2),gps_pos_store(1,3),420,'^','MarkerFaceColor','yellow')
% scatter3(gps_pos_store(end,1),gps_pos_store(end,2),gps_pos_store(end,3),420,'^','MarkerFaceColor','blue')
% scatter3(gps_pos_store(:,1),gps_pos_store(:,2),gps_pos_store(:,3),50,'^','MarkerFaceColor','magenta')
% scatter3(lidar_pos_store(:,1),lidar_pos_store(:,2),lidar_pos_store(:,3),50,'^','MarkerFaceColor','cyan')
% 
% % Plotting the point cloud
% pcshow(pointCloudList);
% 
% view([0 0 90])

%% Save the PCD
% 
% save_ans = questdlg('Save pcd?', 'Save pcd?', 'Yes', 'No', 'No');
% 
% switch save_ans
%     
%     case 'Yes'
%         
%         name_ans        = inputdlg({'Enter Filename:'}, 'Filename', [1 35], {'pcd.pcd'});
%         name_ans        = name_ans{:};
%                 
%         export_dir      = uigetdir();
%         PCDFileName     = fullfile(export_dir, name_ans);
%         
%         pcwrite(pointCloudList,PCDFileName)
%         
%     case 'No'
%         
%         warning('WILL NOT SAVE THE PCD!')
%         
% end

%% End Program 

% web('https://www.youtube.com/watch?v=DPBvMsT3prg&ab_channel=AdesRizaTV')

% gong_gong()

disp('End Program!')
