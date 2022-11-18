%% ===================================================================== %%
%  PCD Stack Classifier
%  Classifies a Stack of PCDs
%  Created on 11/17/2022
%  By Rhett Huston
%  In conjuction with Travis Moleski
%  =====================================================================  %


%% Clear & Setup Workspace
clc;
clear;
close all;
format compact

%% Var Inits

ring_min = 29;
ring_max = 31;

% Num """splits""" that will be analized. It is estimated that there are
% 3615 points in a 360 degree sweep (600 RPM).
num_quadrants               = 100;

% Basically just a random number (length of x in pcd xyzi / num_channels)
% representing the number of points in a single 'channel' sweep. No idea if
% this works brb lol (back it works)
num_points_per_quadrant     = int32(3615 / num_quadrants);

% The Score (unused atm)
% class_score_avg = []; guess_score_mean = []; guess_score = [];

% Number of feats tracked - TEST VAR (unused atm)
% num_feats                   = 3;

% Confidence Minimum (unused atm)
% conf_min                    = 0.80;

% Random array inits
time_store = [];
grav_array_temp = []; chip_array_temp = []; gras_array_temp = []; foli_array_temp = [];
grav_avg_array_temp = []; chip_avg_array_temp = []; gras_avg_array_temp = []; foli_avg_array_temp = [];
Grav_Append_Array = []; Chip_Append_Array = []; Foli_Append_Array = []; Gras_Append_Array = [];
Grav_Avg_Append_Array = []; Chip_Avg_Append_Array = []; Foli_Avg_Append_Array = []; Gras_Avg_Append_Array = [];


%% Loading the ROSBAG

% Location of rosbag
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-24-00.bag';
file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-28-18.bag';
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-29-34.bag';
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-31-55.bag';
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-31-55.bag';
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-33-39.bag';
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Coach_Sturbois_Shortened/2022-10-14-14-31-07.bag';
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Coach_Sturbois_Shortened/2022-10-14-14-31-42.bag';
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Armitage_Shortened_Bags/2022-10-20-10-14-05_GRAV.bag';

% Load the rosbag into the workspace
bag =  rosbag(file);

%% Getting the file name from list to have a good savename

[~,rosbag_name,~] = fileparts(file); % [path, name, extension]

%% Loading RDF

disp('Loading RDF...')
% load(rdf_file)
% load('RDF_10_20_2022_10TREES.mat');
% load('RDF_10_20_2022_142TREES.mat');
% load('RDF_Spat.mat');
% load('RDF_Remi.mat');
load('RDF_Both.mat');
disp('RDF Loaded!')

%% Creating the feat list

% There's a better way to do this but this works so as long as it works I'm
% not going to complain too much about it.

disp('Load Feature List...')

load('feat_list.mat');

feat_list_pre_export        = {feat_list.S; feat_list.R};

feat_list_export            = cat(1, feat_list_pre_export{:});

disp('Feature List Loaded!')

%% Selecting ROOT Directory - where to store the stack

% Current Time
time_now                    = datetime("now","Format","uuuuMMddhhmmss");
time_now                    = datestr(time_now,'yyyyMMddhhmmss');

root_dir = "ROSBAG_" + string(rosbag_name) + "_" + string(time_now);

mkdir(root_dir)
addpath(root_dir)

%% Creating TFROM Export

tform_save_folder           = string(root_dir) + "/TFORM";
mkdir(tform_save_folder);
addpath(tform_save_folder);

%% Creating PCD Stack export

PCD_STACK_FOLDER = string(root_dir) + "/PCD_STACK";
mkdir(PCD_STACK_FOLDER);
addpath(PCD_STACK_FOLDER);

%% Creating Classification Stack Export

CLASSIFICATION_STACK_FOLDER = string(root_dir) + "/CLASSIFICATION_STACK";
mkdir(CLASSIFICATION_STACK_FOLDER);
addpath(CLASSIFICATION_STACK_FOLDER);

%% Grabbing Tform

get_tform(bag, tform_save_folder, ring_min, ring_max)

%% LiDAR Stuffz

% RPM of the LiDAR    
RPM                                             = 900;

% Device Model (string): VLP16 VLP32C HDL32E HDL64E VLS128
device_model                                    = "VLP32C";

% Number of channels
num_channels                                    = 32;

% Converting the RPM into Hz then finding dT for each revolution. This
% will hopefully make a point cloud with one full revolution.
dT                      = 1 / (RPM / 60);

% Velodyne
velodyne_packets_topic	= '/velodyne_packets';
%     velodyne_points_topic	= '/velodyne_points';

% Selecting the bag
velodyne_packets_bag    = select(bag, 'Topic', velodyne_packets_topic);
%     velodyne_points_bag     = select(bag_init, 'Topic', velodyne_points_topic);

% Creating Structure
velodyne_packets_struct = readMessages(velodyne_packets_bag,'DataFormat','struct');
%     velodyne_points_struct  = readMessages(velodyne_points_bag,'DataFormat','struct');

disp('Structure Creation Completed.')

%% Allocating memory for the matrices: Needs length of each sweep.

% Reading the velodyne stuffs
veloReader_packets      = velodyneROSMessageReader(velodyne_packets_struct,device_model);

% Extracting Point Clouds
timeDuration_packets    = veloReader_packets.StartTime;

% Read first point cloud recorded
ptCloudObj_packets      = readFrame(veloReader_packets, timeDuration_packets);

% Access Location Data
ptCloudLoc_packets      = ptCloudObj_packets.Location;

% Checking Length
memory_array_xyzi       = double(zeros(1, length(ptCloudLoc_packets(:,:,1)) * num_channels));
memory_array_pt_pack    = double(zeros(32, length(ptCloudLoc_packets(:,:,1)) * num_channels));
memory_array_XYZI_TOT   = double(zeros(length(velodyne_packets_struct),4));

% Allocation
x_append                = memory_array_xyzi;
y_append                = memory_array_xyzi;
z_append                = memory_array_xyzi;
int_append              = memory_array_xyzi;
ptCloudLoc_packets      = memory_array_pt_pack;
XYZI_TOT                = memory_array_XYZI_TOT;

timing                  = zeros(1,length(velodyne_packets_struct));

%% Loop
% Timing
%     tic

num_pcds = length(velodyne_packets_struct);

pcd_bar = waitbar(0, sprintf('PCD %d out of %d', i, num_pcds));

% Exporting PCDs
for i = 1:num_pcds
    
    % Which loop is this?
    dT_loop                 = dT * i;
    
    %% Extracting Point Clouds
    %       timeDuration_points      = veloReader_points.StartTime + seconds(dT);
    timeDuration_packets    = veloReader_packets.StartTime + seconds(dT_loop);
    
    % Read first point cloud recorded
    %       ptCloudObj_points        = readFrame(veloReader_points, timeDuration_packets);
    ptCloudObj_packets      = readFrame(veloReader_packets, timeDuration_packets);
    
    % Access Location Data
    %     ptCloudLoc_points        = ptCloudObj_points.Location;
    ptCloudLoc_packets      = ptCloudObj_packets.Location;
    
    % Access Intensity Data
    ptCloudInt_packets      = ptCloudObj_packets.Intensity;
    
    %% Extracting data
    for j = ring_min:ring_max
        
        x                       = ptCloudLoc_packets(j,:,1);
        y                       = ptCloudLoc_packets(j,:,2);
        z                       = ptCloudLoc_packets(j,:,3);
        int                     = ptCloudInt_packets(j,:);
        
        x_append                = [x_append x];
        y_append                = [y_append y];
        z_append                = [z_append z];
        int_append              = [int_append int];
        
    end % Extracting data
    
    XYZI_TOT                = [x_append' y_append' z_append'];
    
    pc                      = pointCloud(XYZI_TOT, 'Intensity', int_append');
    
    % Debug
%     pcshow(pc)
%     view([0 0 90])
%     disp('Pausing until ready...')
%     pause
%     close all
%     disp('Continuing!')

    %Creates pcd file name
    n_strPadded             = sprintf('%08d', i);
    pcdFileName             = strcat(root_dir, '/PCD_STACK/', n_strPadded, '.pcd');
    
    %Writes to a pcd file
    pcwrite(pc, pcdFileName);
    
    %% Resetting the arrays
    x_append                = memory_array_xyzi;
    y_append                = memory_array_xyzi;
    z_append                = memory_array_xyzi;
    int_append              = memory_array_xyzi;
        
    %% Waitbar
    
    waitbar(i/num_pcds, pcd_bar, sprintf('PCD %d out of %d', i, num_pcds))
    
    
end  % Exporting PCD

delete(pcd_bar)

clear i

%% Opening the stack folder:

pcd_files                  = dir(fullfile(PCD_STACK_FOLDER,'/*.pcd'));

%% Pausing so that stupid matlab can recognize that a stupid folder exists
% why matlab why

pause_length = 3;

weight_bar = waitbar(0, sprintf('Loading subfolder...'));

for i = 1:0.1:pause_length

    pause(0.1)

    waitbar(i / pause_length, weight_bar, sprintf('Loading subfolder...'))

end

delete(weight_bar)

%% Classifying each point cloud

classification_bar = waitbar(0, sprintf('PCD 0 out of %d, ~ X.X min left', num_pcds));

for class_idx = 1:1:num_pcds
    
    tStart = tic;
    
    %% Loading the PCD
    ptCloudA                    = pcread(pcd_files(class_idx).name);
    
    % DEBUG: Viewing the point cloud for confirmation and context.
%     pcshow(ptCloudA)
%     view([0 0 90])
%     disp('Pausing until ready...')
%     pause
%     close all
%     disp('Continuing!')
    
    %% RANSAC - MATLAB
    maxDistance                 = 0.1;
    model                       = pcfitplane(ptCloudA, maxDistance);
    a                           = model.Parameters(1);
    b                           = model.Parameters(2);
    c                           = model.Parameters(3);
    d                           = model.Parameters(4);
    
    %% Doing the Classification

    num_loops = length(ptCloudA.Location(:,1)) / double(num_points_per_quadrant) - 2;

    iValues = 1:1:num_loops;

    disp('Starting Classification...')
    
    parfor_progress(max(iValues));

    parfor idx = 1:numel(iValues)

        i = iValues(idx);

        %% "Split" location / indices
        begin_var                   = (i-1) * num_points_per_quadrant + 1;
        end_var                     = i * num_points_per_quadrant;

        indices                     = begin_var:1:end_var;

        %% Select ptCloudB - the 'split' portion

        ptCloudB                    = select(ptCloudA,indices);

        %% Get features

        x_array_B                   = ptCloudB.Location(:,1);
        y_array_B                   = ptCloudB.Location(:,2);
        z_array_B                   = ptCloudB.Location(:,3);
        intensity                   = double(ptCloudB.Intensity);

        % Put into single array & eliminate NaN, Inf, and 0 from array.
        xyzi = [x_array_B y_array_B z_array_B intensity];
        xyzi = xyzi( ~any( isnan(xyzi) | isinf(xyzi), 2), : );
        xyzi(any(xyzi == 0, 2), :) = [];

        % Debug output........
    %     disp('made it before the if statement')
    %     disp([length(x_array_B) length(y_array_B) length(z_array_B) length(intensity)])

        %% Classification
        if length(xyzi(:,1)) > 3
            
            Classification_Time_Start = tic;

            % Debug output........
    %         disp('made it into the if statement')
    %         disp([length(x_array_B) length(y_array_B) length(z_array_B) length(intensity)])

            %% XYDist / Range ratio factor

            xy_dist                     = sqrt(mean(xyzi(:,1))^2 + mean(xyzi(:,2))^2);
            range                       = sqrt((xyzi(:,1)).^2 + (xyzi(:,2)).^2 + (xyzi(:,3)).^2);
            range_mean                  = mean(range);

            %% Height Props

            % Getting height Properties
            h_num                       = abs((a * xyzi(:,1)) + (b *  xyzi(:,2)) + (c *  xyzi(:,3)) - d);
            h_dem                       = sqrt(a^2 + b^2 + c^2);
            height                      = h_num / h_dem;

            %% Z Props

            Z                           = xyzi(:,3);

           %% Safety for Shapiro Wilks freaking out about stuff being the same

               % Catch for shaprio wilks balking at non-varying values - fix later?
            if sum(double(intensity)) / length(double(intensity)) == mean(double(intensity))
                intensity(1) = intensity(1) + 1;
            end
            if sum(height) / length(height) == mean(height)
                height(1) = height(1) + 0.001;
            end

            %% Feat Extract

            StandDevHeight              = double(std(height));
            MeanHeight                  = double(mean(height));
            MinHeight                   = double(min(height));
            MaxHeight                   = double(max(height));
            MedHeight                   = double(median(height));
            RoughnessHeight             = double(MaxHeight - MinHeight);
            MinMaxRatioHeight           = double(MinHeight / MaxHeight);
            Min2MaxRatioHeight          = double(MinHeight^2 / MaxHeight);
            MagGradientHeight           = double(sqrt(sum(gradient(height).^2)));

            StandDevHeightXYDist        = double(std(height) / xy_dist);
            MeanHeightXYDist            = double(mean(height) / xy_dist);
            MinHeightXYDist             = double(min(height) / xy_dist);
            MaxHeightXYDist             = double(max(height) / xy_dist);
            MedHeightXYDist             = double(median(height) / xy_dist);
            RoughnessHeightXYDist       = double(MaxHeightXYDist - MinHeightXYDist);
            MinMaxRatioHeightXYDist     = double(MinHeightXYDist / MaxHeightXYDist);
            Min2MaxRatioHeightXYDist    = double(MinHeightXYDist^2 / MaxHeightXYDist);
            MagGradientHeightXYDist     = double(sqrt(sum(gradient(height).^2)) / xy_dist);

            StandDevHeightRange         = double(std(height) / range_mean);
            MeanHeightRange             = double(mean(height) / range_mean);
            MinHeightRange              = double(min(height) / range_mean);
            MaxHeightRange              = double(max(height) / range_mean);
            MedHeightRange              = double(median(height) / range_mean);
            RoughnessHeightRange        = double(MaxHeightRange - MinHeightRange);
            MinMaxRatioHeightRange      = double(MinHeightRange / MaxHeightRange);
            Min2MaxRatioHeightRange     = double(MinHeightRange^2 / MaxHeightRange);
            MagGradientHeightRange      = double(sqrt(sum(gradient(height).^2)) / range_mean);

            % Getting RANGE Spatial Properties

            StandDevRange               = double(std(range));
            MeanRange                   = double(mean(range));
            MinRange                    = double(min(range));
            MaxRange                    = double(max(range));
            MedRange                    = double(median(range));
            RoughnessRange              = double(MaxRange - MinRange);
            MinMaxRatioRange            = double(MinRange / MaxRange);
            Min2MaxRatioRange           = double(MinRange^2 / MaxRange);
            MagGradientRange            = double(sqrt(sum(gradient(range).^2)));

            StandDevRangeXYDist         = double(std(range) / xy_dist);
            MeanRangeXYDist             = double(mean(range) / xy_dist);
            MinRangeXYDist              = double(min(range) / xy_dist);
            MaxRangeXYDist              = double(max(range) / xy_dist);
            MedRangeXYDist              = double(median(range) / xy_dist);
            RoughnessRangeXYDist        = double(MaxRangeXYDist - MinRangeXYDist);
            MinMaxRatioRangeXYDist      = double(MinRangeXYDist / MaxRangeXYDist);
            Min2MaxRatioRangeXYDist     = double(MinRangeXYDist^2 / MaxRangeXYDist);
            MagGradientRangeXYDist      = double(sqrt(sum(gradient(range).^2)) / xy_dist);

            StandDevRangeRange          = double(std(range) / range_mean);
            MeanRangeRange              = double(mean(range) / range_mean);
            MinRangeRange               = double(min(range) / range_mean);
            MaxRangeRange               = double(max(range) / range_mean);
            MedRangeRange               = double(median(range) / range_mean);
            RoughnessRangeRange         = double(MaxRangeRange - MinRangeRange);
            MinMaxRatioRangeRange       = double(MinRangeRange / MaxRangeRange);
            Min2MaxRatioRangeRange      = double(MinRangeRange^2 / MaxRangeRange);
            MagGradientRangeRange       = double(sqrt(sum(gradient(range).^2)) / range_mean);

            % Getting Height from the Zero plane (literally just z lol)

            StandDevZ                   = double(std(Z));
            MeanZ                       = double(mean(Z));
            MinZ                        = double(min(Z));
            MaxZ                        = double(max(Z));
            MedZ                        = double(median(Z));
            RoughnessZ                  = double(MaxZ - MinZ);
            MinMaxRatioZ                = double(MinZ / MaxZ);
            Min2MaxRatioZ               = double(MinZ^2 / MaxZ);
            MagGradientZ                = double(sqrt(sum(gradient(Z).^2)));

            StandDevZXYDist             = double(std(Z) / xy_dist);
            MeanZXYDist                 = double(mean(Z) / xy_dist);
            MinZXYDist                  = double(min(Z) / xy_dist);
            MaxZXYDist                  = double(max(Z) / xy_dist);
            MedZXYDist                  = double(median(Z) / xy_dist);
            RoughnessZXYDist            = double(MaxZXYDist - MinZXYDist);
            MinMaxRatioZXYDist          = double(MinZXYDist / MaxZXYDist);
            Min2MaxRatioZXYDist         = double(MinZXYDist^2 / MaxZXYDist);
            MagGradientZXYDist          = double(sqrt(sum(gradient(Z).^2)) / xy_dist);

            StandDevZRange              = double(std(Z) / range_mean);
            MeanZRange                  = double(mean(Z) / range_mean);
            MinZRange                   = double(min(Z) / range_mean);
            MaxZRange                   = double(max(Z) / range_mean);
            MedZRange                   = double(median(Z) / range_mean);
            RoughnessZRange             = double(MaxZRange - MinZRange);
            MinMaxRatioZRange           = double(MinZRange / MaxZRange);
            Min2MaxRatioZRange          = double(MinZRange^2 / MaxZRange);
            MagGradientZRange           = double(sqrt(sum(gradient(Z).^2)) / range_mean);

            % I don't actually use this but it's here just in case
%             % Shaprio-Wilks - Height
%             [H, pValue, W] = swtest_fun(single(height), 0.05);
% 
%             SwHHeight                   = H;
%             SwpValueHeight              = pValue;
%             SwWHeight                   = W;
% 
%             % Shaprio-Wilks - Range
%             [H, pValue, W] = swtest_fun(single(range), 0.05);
% 
%             SwHRange                    = H;
%             SwpValueRange               = pValue;
%             SwWRange                    = W;
% 
%             % Shaprio-Wilks - Z
%             [H, pValue, W] = swtest_fun(single(range), 0.05);
% 
%             SwHZ                        = H;
%             SwpValueZ                   = pValue;
%             SwWZ                        = W;

            % Shaprio-Wilks - Height

            SwHHeight                   = 0;
            SwpValueHeight              = 0;
            SwWHeight                   = 0;

            % Shaprio-Wilks - Range

            SwHRange                    = 0;
            SwpValueRange               = 0;
            SwWRange                    = 0;

            % Shaprio-Wilks - Z

            SwHZ                        = 0;
            SwpValueZ                   = 0;
            SwWZ                        = 0;

            %% REMISION FEATURES CALCULATED AND SAVED

            StandDevInt                 = double(std(intensity));
            MeanInt                     = double(mean(intensity));
            MinInt                      = double(min(intensity));
            MaxInt                      = double(max(intensity));
            MedInt                      = double(median(intensity));
            RangeInt                    = double(MaxInt - MinInt);
            MinMaxRatioInt              = double(MinInt / MaxInt);
            Min2MaxRatioInt             = double(MinInt^2 / MaxInt);
            MagGradientInt              = double(sqrt(sum(gradient(intensity).^2)));

            StandDevIntXYDist           = double(std(intensity) / xy_dist);
            MeanIntXYDist               = double(mean(intensity) / xy_dist);
            MinIntXYDist                = double(min(intensity) / xy_dist);
            MaxIntXYDist                = double(max(intensity) / xy_dist);
            MedIntXYDist                = double(median(intensity) / xy_dist);
            RangeIntXYDist              = double(MaxIntXYDist - MinIntXYDist);
            MinMaxRatioIntXYDist        = double(MinIntXYDist / MaxIntXYDist);
            Min2MaxRatioIntXYDist       = double(MinIntXYDist^2 / MaxIntXYDist);
            MagGradientIntXYDist        = double(sqrt(sum(gradient(intensity).^2)) / xy_dist);

            StandDevIntRange            = double(std(intensity) / range_mean);
            MeanIntRange                = double(mean(intensity) / range_mean);
            MinIntRange                 = double(min(intensity) / range_mean);
            MaxIntRange                 = double(max(intensity) / range_mean);
            MedIntRange                 = double(median(intensity) / range_mean);
            RangeIntRange               = double(MaxIntRange - MinIntRange);
            MinMaxRatioIntRange         = double(MinIntRange / MaxIntRange);
            Min2MaxRatioIntRange        = double(MinIntRange^2 / MaxIntRange);
            MagGradientIntRange         = double(sqrt(sum(gradient(intensity).^2)) / range_mean);
            
            % I don't use this atm but the code is still here
%             % Shaprio-Wilks
%             [H, pValue, W] = swtest_fun(single(abs(intensity)), 0.05);
% 
%             SwHInt                      = H;
%             SwpValueInt                 = pValue;
%             SwWInt                      = W;
            SwHInt                      = 0;
            SwpValueInt                 = 0;
            SwWInt                      = 0;

            % Super annoying huge table

            feat_extract_table = [StandDevHeight
            MeanHeight
            MinHeight
            MaxHeight
            MedHeight
            RoughnessHeight
            MinMaxRatioHeight
            Min2MaxRatioHeight
            MagGradientHeight
            StandDevHeightXYDist
            MeanHeightXYDist
            MinHeightXYDist
            MaxHeightXYDist
            MedHeightXYDist
            RoughnessHeightXYDist
            MinMaxRatioHeightXYDist
            Min2MaxRatioHeightXYDist
            MagGradientHeightXYDist
            StandDevHeightRange
            MeanHeightRange
            MinHeightRange
            MaxHeightRange
            MedHeightRange
            RoughnessHeightRange
            MinMaxRatioHeightRange
            Min2MaxRatioHeightRange
            MagGradientHeightRange
            StandDevRange
            MeanRange
            MinRange
            MaxRange
            MedRange
            RoughnessRange
            MinMaxRatioRange
            Min2MaxRatioRange
            MagGradientRange
            StandDevRangeXYDist
            MeanRangeXYDist
            MinRangeXYDist
            MaxRangeXYDist
            MedRangeXYDist
            RoughnessRangeXYDist
            MinMaxRatioRangeXYDist
            Min2MaxRatioRangeXYDist
            MagGradientRangeXYDist
            StandDevRangeRange
            MeanRangeRange
            MinRangeRange
            MaxRangeRange
            MedRangeRange
            RoughnessRangeRange
            MinMaxRatioRangeRange
            Min2MaxRatioRangeRange
            MagGradientRangeRange
            StandDevZ
            MeanZ
            MinZ
            MaxZ
            MedZ
            RoughnessZ
            MinMaxRatioZ
            Min2MaxRatioZ
            MagGradientZ
            StandDevZXYDist
            MeanZXYDist
            MinZXYDist
            MaxZXYDist
            MedZXYDist
            RoughnessZXYDist
            MinMaxRatioZXYDist
            Min2MaxRatioZXYDist
            MagGradientZXYDist
            StandDevZRange
            MeanZRange
            MinZRange
            MaxZRange
            MedZRange
            RoughnessZRange
            MinMaxRatioZRange
            Min2MaxRatioZRange
            MagGradientZRange
            SwHHeight
            SwpValueHeight
            SwWHeight
            SwHRange
            SwpValueRange
            SwWRange
            SwHZ
            SwpValueZ
            SwWZ
            StandDevInt
            MeanInt
            MinInt
            MaxInt
            MedInt
            RangeInt
            MinMaxRatioInt
            Min2MaxRatioInt
            MagGradientInt
            StandDevIntXYDist
            MeanIntXYDist
            MinIntXYDist
            MaxIntXYDist
            MedIntXYDist
            RangeIntXYDist
            MinMaxRatioIntXYDist
            Min2MaxRatioIntXYDist
            MagGradientIntXYDist
            StandDevIntRange
            MeanIntRange
            MinIntRange
            MaxIntRange
            MedIntRange
            RangeIntRange
            MinMaxRatioIntRange
            Min2MaxRatioIntRange
            MagGradientIntRange
            SwHInt
            SwpValueInt
            SwWInt]';

            %% Getting just the features that are needed

    %         Mdl_Trainer_Table       = getfeaturenamearray(feat_extract_table);

            %% Tabulating & Getting desired features

            table_export = array2table(feat_extract_table,'VariableNames',feat_list_export);

            %% Run RFD algorithm

            [Yfit, scores, stdevs]              = predict(Mdl, table_export);
            
            %% End Time
            
            Classification_Time_End = toc(Classification_Time_Start);

            %% Exporting results to struct

            Classification_Result(idx).label    = Yfit;
            Classification_Result(idx).scores   = scores;
            Classification_Result(idx).stdevs   = stdevs;
            Classification_Result(idx).xyzi     = xyzi;
            Classification_Result(idx).time     = Classification_Time_End;
            Classification_Result(idx).avg_xyz  = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3))];

        end % if statment for > than 3 points that are not Inf, NaN, or 0.

        %% Weightbar

        parfor_progress;
        
        %% Clear Vars for Safety

    %     feat_array = []; k = 0; 
    %     x_array_B = []; y_array_B = []; z_array_B = []; intensity = [];
    %     height = []; h_num = 0; h_dem = 0;
    %     guess_label = {}; guess_score = []; class_score_avg = [];
    

    end % Classification
    
    parfor_progress(0);

    disp('Point Cloud Data Classification Complete!')

    %% Saving the Classification Result
%     
%     n_strPadded                 = sprintf('%08d', class_idx);
% %     Classification_FileName     = strcat(root_dir, '/CLASSIFICATION_STACK/', n_strPadded, '.mat');
%     Classification_FileName     = string(root_dir) + "/CLASSIFICATION_STACK/" + string(n_strPadded) + ".mat";
%     
    %Creates pcd file name
    n_strPadded             = sprintf('%08d', class_idx);
%     Classification_FileName             = strcat(CLASSIFICATION_STACK_FOLDER, '/', n_strPadded, '.mat') ;
    Classification_FileName = string(CLASSIFICATION_STACK_FOLDER) + "/" + string(n_strPadded) + ".mat";
    
    save(Classification_FileName, 'Classification_Result')
    
    %% Clearing Vars for Safety
    
    clear Classification_Result
    
    %% Time to Completion Estimation
    tEnd = toc(tStart);
    time_store = [time_store; tEnd];
    time_avg = mean(time_store);
    est_time_to_complete = (time_avg * (num_pcds - class_idx)) / 60;
    
    %% Waitbar
    
    waitbar(class_idx/num_pcds,classification_bar,sprintf('Cloud %d out of %d, ~ %0.1f min left', class_idx, num_pcds, est_time_to_complete))
    
    
end % Loop of which pcd I'm in

delete(classification_bar)

%% Load the classifications

classification_list             = dir(fullfile(CLASSIFICATION_STACK_FOLDER,'/*.mat'));

%% Load the tform, gps location, and lidar location

Save_Tform_Filename                 = tform_save_folder + "/tform.mat";
Save_Gps_Loc_Filename               = tform_save_folder + "/gps_loc.mat";
Save_LiDAR_Loc_Filename             = tform_save_folder + "/LiDAR_loc.mat";

load(Save_Tform_Filename);
load(Save_Gps_Loc_Filename);
load(Save_LiDAR_Loc_Filename);

%% Temp Debuging Thing
% 
% clear all
% 
% time_store = [];
% grav_array_temp = []; chip_array_temp = []; gras_array_temp = []; foli_array_temp = [];
% grav_avg_array_temp = []; chip_avg_array_temp = []; gras_avg_array_temp = []; foli_avg_array_temp = [];
% Grav_Append_Array = []; Chip_Append_Array = []; Foli_Append_Array = []; Gras_Append_Array = [];
% Grav_Avg_Append_Array = []; Chip_Avg_Append_Array = []; Foli_Avg_Append_Array = []; Gras_Avg_Append_Array = [];
% 
% 
% temp_dir = "ROSBAG_2022-10-11-09-24-00_20220217161137";
% CLASSIFICATION_STACK_FOLDER = string(temp_dir) + "/CLASSIFICATION_STACK";
% tform_save_folder = string(temp_dir) + "/TFORM";
% classification_list             = dir(fullfile(CLASSIFICATION_STACK_FOLDER,'/*.mat'));
% tform_file_loc                  = string(tform_save_folder) + "/tform.mat";
% load(tform_file_loc);

%% Applying Tform to each result

Grav_Append_Array = []; Chip_Append_Array = []; Foli_Append_Array = []; Gras_Append_Array = [];
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
    
    % Correction factor because reasons (idk it just todd howards)
    rotatez = 90;
    
    if ~isempty(grav_array_temp)
        grav_array_temp(:,1:3)          = grav_array_temp(:,1:3)    * tform(tform_idx).Rotation * rotz(rotatez);
        grav_array_temp(:,1:3)          = grav_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Grav_Append_Array               = [Grav_Append_Array; grav_array_temp];
    end
    
    if ~isempty(grav_avg_array_temp)
        grav_avg_array_temp             = grav_avg_array_temp       * tform(tform_idx).Rotation * rotz(rotatez);
        grav_avg_array_temp             = grav_avg_array_temp       + tform(tform_idx).Translation;
        Grav_Avg_Append_Array           = [Grav_Avg_Append_Array; grav_avg_array_temp];
    end
    
    if ~isempty(chip_array_temp)
        chip_array_temp(:,1:3)          = chip_array_temp(:,1:3)    * tform(tform_idx).Rotation * rotz(rotatez);
        chip_array_temp(:,1:3)          = chip_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Chip_Append_Array               = [Chip_Append_Array; chip_array_temp];
    end
    
    if ~isempty(chip_avg_array_temp)
        chip_avg_array_temp             = chip_avg_array_temp       * tform(tform_idx).Rotation * rotz(rotatez);
        chip_avg_array_temp             = chip_avg_array_temp       + tform(tform_idx).Translation;
        Chip_Avg_Append_Array           = [Chip_Avg_Append_Array; chip_avg_array_temp];
    end
    
    if ~isempty(foli_array_temp)
        foli_array_temp(:,1:3)          = foli_array_temp(:,1:3)    * tform(tform_idx).Rotation * rotz(rotatez);
        foli_array_temp(:,1:3)          = foli_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Foli_Append_Array               = [Foli_Append_Array; foli_array_temp];
    end
    
    if ~isempty(foli_avg_array_temp)
        foli_avg_array_temp             = foli_avg_array_temp       * tform(tform_idx).Rotation * rotz(rotatez);
        foli_avg_array_temp             = foli_avg_array_temp       + tform(tform_idx).Translation;
        Foli_Avg_Append_Array           = [Foli_Avg_Append_Array; foli_avg_array_temp];
    end
    
    if ~isempty(gras_array_temp)
        gras_array_temp(:,1:3)          = gras_array_temp(:,1:3)    * tform(tform_idx).Rotation * rotz(rotatez);
        gras_array_temp(:,1:3)          = gras_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Gras_Append_Array               = [Gras_Append_Array; gras_array_temp];
    end
    
    if ~isempty(gras_avg_array_temp)
        gras_avg_array_temp             = gras_avg_array_temp       * tform(tform_idx).Rotation * rotz(rotatez);
        gras_avg_array_temp             = gras_avg_array_temp       + tform(tform_idx).Translation;
        Gras_Avg_Append_Array           = [Gras_Avg_Append_Array; gras_avg_array_temp];
    end

    
end % Going through the transform list

%% Plotting the results

figure

hold all

plot3(Grav_Append_Array(:,1), Grav_Append_Array(:,2), Grav_Append_Array(:,3), 'c.', 'MarkerSize', 3.5)
plot3(Chip_Append_Array(:,1), Chip_Append_Array(:,2), Chip_Append_Array(:,3), 'k.', 'MarkerSize', 3.5)
plot3(Foli_Append_Array(:,1), Foli_Append_Array(:,2), Foli_Append_Array(:,3), 'm.', 'MarkerSize', 3.5)
plot3(Gras_Append_Array(:,1), Gras_Append_Array(:,2), Gras_Append_Array(:,3), 'g.', 'MarkerSize', 3.5)

axis('equal')
axis off
view([0 0 90])

figure

hold all

plot3(Grav_Avg_Append_Array(:,1), Grav_Avg_Append_Array(:,2), Grav_Avg_Append_Array(:,3), 'c.', 'MarkerSize', 3.5)
plot3(Chip_Avg_Append_Array(:,1), Chip_Avg_Append_Array(:,2), Chip_Avg_Append_Array(:,3), 'k.', 'MarkerSize', 3.5)
plot3(Foli_Avg_Append_Array(:,1), Foli_Avg_Append_Array(:,2), Foli_Avg_Append_Array(:,3), 'm.', 'MarkerSize', 3.5)
plot3(Gras_Avg_Append_Array(:,1), Gras_Avg_Append_Array(:,2), Gras_Avg_Append_Array(:,3), 'g.', 'MarkerSize', 3.5)

axis('equal')
axis off
view([0 0 90])


%% End program

disp('End Program!')