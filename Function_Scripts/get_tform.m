% Get tform

function get_tform(bag, tform_save_folder, ring_min, ring_max)
    
    %% Temp Debug
%     
% 
%     % Location of rosbag
%     file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-24-00.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-24-00.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-28-18.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-29-34.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-31-55.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-31-55.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-33-39.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Coach_Sturbois_Shortened/2022-10-14-14-31-07.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Coach_Sturbois_Shortened/2022-10-14-14-31-42.bag';
%     % file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Armitage_Shortened_Bags/2022-10-20-10-14-05_GRAV.bag';
% 
%     % Load the rosbag into the workspace
%     bag =  rosbag(file);
% 

    %% Variable Initiation
    LiDAR_Ref_Frame             = [0; 1.584; 1.444];
    IMU_Ref_Frame               = [0; 0.336; -0.046];

    % Correction frame:         LiDAR_Ref_Frame - IMU_Ref_Frame [Y X Z]
    gps_to_lidar_diff           = [(LiDAR_Ref_Frame(1) - IMU_Ref_Frame(1)), (LiDAR_Ref_Frame(2) - IMU_Ref_Frame(2)), (LiDAR_Ref_Frame(3) - IMU_Ref_Frame(3))]; 

    time_store = [];
    
    %% Topics
    topics = bag.AvailableTopics;

    lidar_topic = select(bag,'Topic','velodyne_packets');
    lidar_msgs = readMessages(lidar_topic, 'DataFormat', 'struct');

    gps_topic = select(bag,'Topic','/gps/gps');
    gps_msgs = readMessages(gps_topic, 'DataFormat', 'struct');
    
    %% Timestamps
    
    % Matching timestamps
    [indexes, fromTimes, toTimes, diffs] = matchTimestamps(lidar_msgs, gps_msgs);

    %Find which GPS message matches the first scan
    matchedLidar                = lidar_msgs{1};
    matchedGps_init             = gps_msgs{indexes(1)};

    %% Initilizing the starting point
    % Select reference point as first GPS reading (local)
    origin = [matchedGps_init.Latitude, matchedGps_init.Longitude, matchedGps_init.Altitude];
    [xEast_init, yNorth_init, zUp_init] = latlon2local(matchedGps_init.Latitude, matchedGps_init.Longitude, matchedGps_init.Altitude, origin);


    %%  CONVERT TO LIDAR FRAME:

    % Getting the initial roll, pitch, and yaw values
    roll                        = matchedGps_init.Roll;
    pitch                       = matchedGps_init.Pitch;
    yaw                         = matchedGps_init.Track + 180;

    % Setting the offset from the gps orientation to the lidar
    % takes gps emu to local frame of lidar
    gps2lidar = [ cosd(90) sind(90) 0;
        -sind(90) cosd(90) 0;
        0       0          1];

    % Setting the (gps_to_lidar_diff) offset from the lidar offset to the gps
    LidarOffset2gps = [ cosd(90) -sind(90)  0;
        sind(90)  cosd(90)   0;
        0        0           1];

    % Setting initial orientation offset
    init_rotate_offset          = rotz(90-yaw)*roty(roll)*rotx(pitch);

    % Offset the gps coord by the current orientation (in this case, initial)
    % Converts the ground truth to lidar frame
    groundTruthTrajectory       = [xEast_init, yNorth_init, zUp_init] * gps2lidar;

    % Setting the updated difference between the lidar and gps coordiate and
    % orientation
    % Converts the offsett to the lidar frame
    gps_to_lidar_diff_update    = gps_to_lidar_diff * LidarOffset2gps * init_rotate_offset;

    % Rotating the offset and adding them together
    LidarxEast_init             = groundTruthTrajectory(1) + gps_to_lidar_diff_update(1);
    LidaryNorth_init            = groundTruthTrajectory(2) + gps_to_lidar_diff_update(2);
    LidarzUp_init               = groundTruthTrajectory(3) + gps_to_lidar_diff_update(3);

    % Making the vector of ^^^
    lidarTrajectory             = [LidarxEast_init,LidaryNorth_init,LidarzUp_init];

    % Initilizing the lists
    gps_pos_store(1,:)          = groundTruthTrajectory;
    lidar_pos_store(1,:)        = lidarTrajectory;

    % Reading the current cloud for xyz, intensity, and ring (channel) values
%     init_cloud                  = rosReadXYZ(matchedLidar);
%     intensities                 = rosReadField(matchedLidar, 'intensity');
%     ring                        = rosReadField(matchedLidar, 'ring');
%     init_cloud(:,4)             = intensities;
%     init_cloud(:,5)             = ring;

    % Eliminate nans and zeros
%     init_cloud                   = init_cloud( ~any( isnan(init_cloud) | isinf(init_cloud), 2),:);

    % Sort rows
%     init_cloud = sortrows(init_cloud,5);
    
    % Data Trimming
    

    % Transforming the initial point cloud
    tform(1)                    = rigid3d(init_rotate_offset, [lidarTrajectory(1) lidarTrajectory(2) lidarTrajectory(3)]);

    % Creating the initial point cloud object
%     init_pcl                    = pointCloud([init_cloud(:,1), init_cloud(:,2), init_cloud(:,3)], 'Intensity',  init_cloud(:,4));
%     init_pcl                    = pctransform(init_pcl, tform);

%     pointCloudList{1}           = init_pcl;

    %% Doing the data
    fprintf('Max time delta is %f sec \n',max(abs(diffs)));

    h = waitbar(0, "Cartographing...");
    for cloud = 1:length(lidar_msgs)

        tStart = tic;

        % Reading the current point cloud and matched gps coord
        current_cloud               = lidar_msgs{cloud};
        matched_stamp               = gps_msgs{indexes(cloud)};

        % Converting the gps coord to xyz (m)
        [xEast, yNorth, zUp]        = latlon2local(matched_stamp.Latitude, matched_stamp.Longitude, matched_stamp.Altitude, origin);

        % Grabbing the angles
        roll                        = matched_stamp.Roll;
        pitch                       = matched_stamp.Pitch;
        yaw                         = matched_stamp.Track+180;

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
        groundTruthTrajectory       = groundTruthTrajectory;

        % Rotating the offset and adding them together
        LidarxEast                  = groundTruthTrajectory(1)  + gps_to_lidar_diff_update(1);
        LidaryNorth                 = groundTruthTrajectory(2)  + gps_to_lidar_diff_update(2);
        LidarzUp                    = groundTruthTrajectory(3)  + gps_to_lidar_diff_update(3);

        % Making the vector of ^^^
        lidarTrajectory             = [LidarxEast, LidaryNorth, LidarzUp];

        % Reading the current cloud for xyz, intensity, and ring (channel) values
%         xyz_cloud                   = rosReadXYZ(current_cloud);
%         intensities                 = rosReadField(current_cloud, 'intensity');
%         ring                        = rosReadField(current_cloud, 'ring');
%         xyz_cloud(:,4)              = intensities;
%         xyz_cloud(:,5)              = ring;

        % Eliminiating infs and nans from the xyz data - there may be a way to
        % use the
%         xyz_cloud                   = xyz_cloud( ~any( isnan(xyz_cloud) | isinf(xyz_cloud), 2),:);

        % EXPERIMENT sort rows
%         xyz_cloud = sortrows(xyz_cloud,5);

        % Transforming the point cloud
        tform(cloud)                = rigid3d(rotate_update, [lidarTrajectory(1) lidarTrajectory(2) lidarTrajectory(3)]);

        % Creating the point cloud object3
%         pointClouXYZI_curr          = pointCloud([xyz_cloud(:,1), xyz_cloud(:,2), xyz_cloud(:,3)], 'Intensity',  xyz_cloud(:,4));
%         pointClouXYZI_curr          = pctransform(pointClouXYZI_curr, tform(cloud));

        gps_pos_store(cloud,:)      = groundTruthTrajectory;
        lidar_pos_store(cloud,:)    = lidarTrajectory;

%         pointCloudList{cloud}       = pointClouXYZI_curr;

        %     mergeGridStep = 0.1;
        %     pointCloudList = pcmerge(pointCloudList, pointClouXYZI_curr, mergeGridStep);

        %% Time to Completion Estimation
        tEnd = toc(tStart);
        time_store = [time_store; tEnd];
        time_avg = mean(time_store);
        est_time_to_complete = (time_avg * (length(lidar_msgs) - cloud));

        %% Waitbar

        waitbar(cloud/length(lidar_msgs),h,sprintf('Cloud %d out of %d, ~ %0.1f min left', cloud, length(lidar_msgs), est_time_to_complete))

    end

    delete(h)

    %% Compiling the map

%     disp("Making the map, sire...")
%     pointCloudList = pccat([pointCloudList{:}]);

    %% Displaying the map
% 
%     figure
% 
%     hold on
% 
%     % Plotting the line between the lidar and gps
%     for point = 1:length(lidar_pos_store)
% 
%         plot3([lidar_pos_store(point,1) gps_pos_store(point,1)],...
%             [lidar_pos_store(point,2) gps_pos_store(point,2)],...
%             [lidar_pos_store(point,3) gps_pos_store(point,3)],...
%             'linewidth',3)
% 
%     end
% 
%     % Plotting the lidar and gps points
%     scatter3(gps_pos_store(1,1),gps_pos_store(1,2),gps_pos_store(1,3),420,'^','MarkerFaceColor','yellow')
%     scatter3(gps_pos_store(end,1),gps_pos_store(end,2),gps_pos_store(end,3),420,'^','MarkerFaceColor','blue')
%     scatter3(gps_pos_store(:,1),gps_pos_store(:,2),gps_pos_store(:,3),50,'^','MarkerFaceColor','magenta')
%     scatter3(lidar_pos_store(:,1),lidar_pos_store(:,2),lidar_pos_store(:,3),50,'^','MarkerFaceColor','cyan')
% 
%     % Plotting the point cloud
%     pcshow(pointCloudList);
% 
%     view([0 0 90])

    %% Save the Tform Array

    disp('Saving Tform File... ')


    Save_Tform_Filename                 = tform_save_folder + "/tform.mat";
    Save_Gps_Loc_Filename               = tform_save_folder + "/gps_loc.mat";
    Save_LiDAR_Loc_Filename             = tform_save_folder + "/LiDAR_loc.mat";
    
    save(Save_Tform_Filename, 'tform')
    save(Save_Gps_Loc_Filename, 'gps_pos_store')
    save(Save_LiDAR_Loc_Filename, 'lidar_pos_store')
    
    disp('Data saved! :D')

    %% End Program

    disp('Tform Saved!')

end