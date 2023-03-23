%% ===================================================================== %%
%  PCD Stack Classifier
%  Classifies a Stack of PCDs
%  Created on 11/17/2022
%  By Rhett Huston
%  In conjuction with Travis Moleski
%  Programmed with a IBM Model M keyboard :D
%  =====================================================================  %

%% Clear & Setup Workspace

clc;
clear;
close all;
format compact

%% OPTIONS

% RDF/Feature to use
% NOTE: RAN ZXY & MLS ZXY = same, RAN RANGE & MLS RANGE same. Planes are
% not projected. Naming scheme fail, however beause of how baggin works
% there are slight differences in the algorithms.
dlg_list                            = {'RAN All', 'RAN TT', 'MLS All', 'MLS TT', 'Range', 'ZXY'};
[indx_dlg_list,~]                   = listdlg('ListString', dlg_list,'ListSize', [250 250], 'SelectionMode','single');

% Use seperate algorithm for determining if a positive road identification
% is made, verify with a different algorithm to verify
use_sep_rdf_bool = 0;
use_score_trim_bool = 0;

% Rings go from 0-31, with 0 being the highest elevation channel, 31 being
% the lowest. (28:31 was standard to project)
ring_min = 31;
ring_max = 31;

% Making combined PCD with only the desired rings
rings = [4 2];

% Num quadrants that will be be examined in a single 360 sweep per channel
num_quadrants               = 100;

% Moving Averge size - for plotting purposes
move_avg_size = 30;

% Temp limiter for testing - set num_pcd_over_ride to 1 to use the num_pcds
% value, otherwise it WILL be overwritten.
num_pcd_over_ride = 0;
num_pcds = 30;

% Save Figures
save_figure_bool = 1;

% Close all figs at end 
close_figs_bool = 0;

%% Determining the plane projection method based off the RDF selection

if indx_dlg_list == 1 || indx_dlg_list == 2 
    ran_proj = 1;
    mls_proj = 0;
elseif indx_dlg_list == 3 || indx_dlg_list == 4 
    mls_proj = 1;
    ran_proj = 0;
elseif indx_dlg_list == 5 || indx_dlg_list == 6
    ran_proj = 0;
    mls_proj = 0;
end
% 
% ran_proj = 0;
% mls_proj = 0;

%% Loading second RDF

if use_sep_rdf_bool
    rdf_2nd_load_string = 'Ran_Range_50D_51Tree.mat'; % RANGE
    load(rdf_2nd_load_string)
    Mdl_Range_Verify = Mdl;
end
    
%% Loading Appropriate RDF

% {'RAN All', 'RAN TT', 'MLS All', 'MLS TT', 'Range', 'ZXY'};

if indx_dlg_list == 1
    rdf_load_string = 'RAN_ALL_100D_46Tree.mat'; % RAN ALL
%     rdf_load_string = 'RDF_OLD.mat'; % RAN ALL
%     rdf_load_string = 'Ran_All_Smol.mat'; %Ran All small
%     rdf_load_string = 'RAN_ALL_adaboostrdf.mat';
elseif indx_dlg_list == 2
    rdf_load_string = 'RAN_TT_100D_51Tree.mat'; % RAN TT
elseif indx_dlg_list == 3
    rdf_load_string = 'MLS_ALL_200D_61Tree.mat'; % MLS ALL
elseif indx_dlg_list == 4
    rdf_load_string = 'MLS_TT_50D_56Tree.mat'; % MLS TT
elseif indx_dlg_list == 5
    rdf_load_string = 'Ran_Range_50D_51Tree.mat'; % RANGE
elseif indx_dlg_list == 6
    rdf_load_string = 'MLS_ZXY_50D_41Tree.mat'; % ZXY
elseif indx_dlg_list == 7
    % Not Implemented
end

% rdf_load_string = 'Channel_2_RDF.mat';


%% Var Inits

% xyz arrays for the four classes
grav_array_temp         = []; chip_array_temp       = []; gras_array_temp       = []; foli_array_temp       = [];
grav_avg_array_temp     = []; chip_avg_array_temp   = []; gras_avg_array_temp   = []; foli_avg_array_temp   = [];
Grav_All_Append_Array   = []; Chip_All_Append_Array = []; Foli_All_Append_Array = []; Gras_All_Append_Array = [];
Grav_Avg_Append_Array   = []; Chip_Avg_Append_Array = []; Foli_Avg_Append_Array = []; Gras_Avg_Append_Array = [];

% Diagnostics array
time_store = [];
num_points_per_channel_grab = []; 
size_xyzi = [];
pcd_class_end = []; 
plane_proj_time = []; 
rdf_time_store = []; 
to_struct_time = [];
quadrant_rate = []; 
feat_grab_time = [];
tform_time = [];
class_rate = [];

% tform rotational correction factor. 
corr_z_rot_deg  = 90;
corr_z_matrix   = rotz(corr_z_rot_deg);

% Basically just a random number (length of x in pcd xyzi / num_channels)
% representing the number of points in a single 'channel' sweep. No idea if
% this works brb lol (back it works) - Calculated by dividing the entire
% number of points in a point cloud by the number of channels. This number
% is very consistant so it works 99.9999% of the time. There is a safety in
% place to catch the odd spill-over
% points_per_channel          = 3615; % 300 RPM
% 3615 is only evenly divisible by: 1, 3, 5, 15, 241, 723, 1205. 15 is few
% quadrants, will result in very low accuracy scores, while 241 may be too
% small, and it will take a long time for stuff to classify. 
points_per_channel          = 1808; % 600 RPM
num_points_per_quadrant     = int32(points_per_channel / num_quadrants);

%% Loading the ROSBAG

% THE SIX ROSBAGS

% Chipseal
% RANGE - Y | MLS ALL - Y | RAN ALL - Y | MLS TT - Y | RAN TT - Y | ZXY - Y | RAN OLD - Y | Bothe - Y
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Coach_Sturbois_Shortened/sturbois_chipseal_woods_1.bag';

% RANGE - Y | MLS ALL - Y | RAN ALL - Y | MLS TT - Y | RAN TT - Y | ZXY - Y | RAN OLD - Y | Bothe - Y
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Coach_Sturbois_Shortened/sturbois_chipseal_woods_2.bag';

% RANGE - Y | MLS ALL - Y | RAN ALL - Y | MLS TT - Y | RAN TT - Y | ZXY - Y | RAN OLD - Y | Bothe - Y
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/shortened_Simms/2022-10-11-09-24-00.bag';

% Gravel
% RANGE - Y | MLS ALL - Y | RAN ALL - Y | MLS TT - Y | RAN TT - Y | ZXY - Y | RAN OLD - Y | Bothe - Y
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Armitage_Shortened_Bags/2022-10-20-10-14-05_GRAV.bag';

% RANGE - Y | MLS ALL - Y | RAN ALL - Y | MLS TT - Y | RAN TT - Y | ZXY - Y | RAN OLD - Y | Bothe - Y
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Coach_Sturbois_Shortened/sturbois_curve_1.bag';

% RANGE - Y | MLS ALL - Y | RAN ALL - Y | MLS TT - Y | RAN TT - Y | ZXY - Y | RAN OLD - Y | Bothe - Y
% file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/Coach_Sturbois_Shortened/sturbois_straight_1.bag';

% FUN BAGS
% file = 'ridges_inner_loop.bag';
file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/03_23_23_SHORTENED_CAOCH/angel_ridge_1.bag';

% Load the rosbag into the workspace
bag = rosbag(file);

%% Getting the file name from list to have a good savename

[~,rosbag_name,~] = fileparts(file); % [path, name, extension]

%% Loading RDF

disp('Loading RDF...')
load(rdf_load_string);
disp('RDF Loaded!')

%% Creating ROOT Directory

% Current Time
time_now                    = datetime("now","Format","uuuuMMddhhmmss");
time_now                    = datestr(time_now,'yyyyMMddhhmmss');

if use_sep_rdf_bool
    root_dir = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/SEP_RDF_TESTS/" + string(rdf_load_string) + "_" + string(num_quadrants) + "_RB_" + string(rosbag_name) + "_" + string(time_now);
elseif use_score_trim_bool
    root_dir = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/SCORE_TESTS/" + string(rdf_load_string) + "_" + string(num_quadrants) + "_RB_" + string(rosbag_name) + "_" + string(time_now);
else
%     root_dir = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Specific_Channel/" + string(rdf_load_string) + "_" + string(num_quadrants) + "_RB_" + string(rosbag_name) + "_" + string(time_now);
    root_dir = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/Channel_2_Only/" + string(rdf_load_string) + "Chan_2" + string(time_now);
end

if ~exist(root_dir,'dir')
    mkdir(root_dir)
end

addpath(root_dir)

%% Creating TFROM Export

tform_save_folder           = string(root_dir) + "/TFORM";
mkdir(tform_save_folder);
addpath(tform_save_folder);

%% Creating Combined PCD Export

COMPILED_PCD_FOLDER = string(root_dir) + "/COMPILED_PCD";
mkdir(COMPILED_PCD_FOLDER);
addpath(COMPILED_PCD_FOLDER);

%% Creating PCD Stack export

PCD_STACK_FOLDER = string(root_dir) + "/PCD_STACK";
mkdir(PCD_STACK_FOLDER);
addpath(PCD_STACK_FOLDER);

%% Creating Classification Stack Export

CLASSIFICATION_STACK_FOLDER = string(root_dir) + "/CLASSIFICATION_STACK";
mkdir(CLASSIFICATION_STACK_FOLDER);
addpath(CLASSIFICATION_STACK_FOLDER);

%% Creating Export Location

RESULT_EXPORT_FOLDER = string(root_dir) + "/RESULT_EXPORT";
mkdir(RESULT_EXPORT_FOLDER);
addpath(RESULT_EXPORT_FOLDER);

%% Creating Image Export Location

IMAGE_EXPORT_FOLDER = string(root_dir) + "/IMAGE_EXPORT";
mkdir(IMAGE_EXPORT_FOLDER);
addpath(IMAGE_EXPORT_FOLDER);

%% Grabbing Tform

get_tform(bag, tform_save_folder, ring_min, ring_max)

%% Creating Combined PCD

% make_combined_pcd(bag, COMPILED_PCD_FOLDER) 

%% Creating Combined PCD with desired rings

% make_combined_pcd_small(bag, COMPILED_PCD_FOLDER, rings)

%% LiDAR Stuffz

% RPM of the LiDAR    
RPM                                             = 600;

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
xyzi_chan_2                = memory_array_XYZI_TOT;

timing                  = zeros(1,length(velodyne_packets_struct));

if ~num_pcd_over_ride
    num_pcds = length(velodyne_packets_struct) - 3;
end

%% Extracting PCDs
% Timing
%     tic

disp('Extracting PCDs & Saving to disk')

pcd_bar = waitbar(0, sprintf('PCD %d out of %d', i, num_pcds));

% Exporting PCDs
for pcd_idx = 1:num_pcds
    
    % Which loop is this?
    dT_loop                 = dT * pcd_idx;
    
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
%     for j = ring_min:ring_max
%         
%         x                       = ptCloudLoc_packets(j,:,1);
%         y                       = ptCloudLoc_packets(j,:,2);
%         z                       = ptCloudLoc_packets(j,:,3);
%         int                     = ptCloudInt_packets(j,:);
%         
%         x_append                = [x_append x];
%         y_append                = [y_append y];
%         z_append                = [z_append z];
%         int_append              = [int_append int];
%         
%         % Testing Var
%         num_points_per_channel_grab = [num_points_per_channel_grab; length(x)];
%         
%     end % Extracting data
    
    % ring_2 grab
    
    x_2                     = ptCloudLoc_packets(2,:,1);
    y_2                     = ptCloudLoc_packets(2,:,2);
    z_2                     = ptCloudLoc_packets(2,:,3);
    int_2                   = ptCloudInt_packets(2,:);
    
    xyzi_chan_2             = [x_2' y_2' z_2' double(int_2')];
    
    xyzi_chan_2 = xyzi_chan_2( ~any( isnan(xyzi_chan_2) | isinf(xyzi_chan_2), 2), : );
    xyzi_chan_2(any(xyzi_chan_2 == 0, 2), :) = [];
    
    pc                      = pointCloud(xyzi_chan_2(:,1:3), 'Intensity', xyzi_chan_2(:,4));
    
    
    % Debug
%     pcshow(pc)
%     view([0 0 90])
%     disp('Pausing until ready...')
%     pause
%     close all
%     disp('Continuing!')

    %Creates pcd file name
    n_strPadded             = sprintf('%08d', pcd_idx);
    pcdFileName             = strcat(root_dir, '/PCD_STACK/', n_strPadded, '.pcd');
    
    %Writes to a pcd file
    pcwrite(pc, pcdFileName);
    
    %% Resetting the arrays
%     x_append                = memory_array_xyzi;
%     y_append                = memory_array_xyzi;
%     z_append                = memory_array_xyzi;
%     int_append              = memory_array_xyzi;
    xyzi_chan_2             = [];
        
    %% Waitbar
    
    waitbar(pcd_idx/num_pcds, pcd_bar, sprintf('PCD %d out of %d', pcd_idx, num_pcds))
    
end  % Exporting PCD

delete(pcd_bar)

disp('PCDs exported, loading pcds into array...')

%% Opening the stack folder:

pcd_files                  = dir(fullfile(PCD_STACK_FOLDER,'/*.pcd'));

disp('PCDs loaded. Loading all folders...')

%% Pausing so that stupid matlab can recognize that a stupid folder exists
% why matlab why

pause_length = 2;

weight_bar = waitbar(0, sprintf('Waisting Your Time...'));

for i = 1:1:pause_length

    pause(1)
    
    % Yes these folders & files exist, Matlab, chill.
    addpath(root_dir)
    addpath(tform_save_folder)
    addpath(PCD_STACK_FOLDER)
    addpath(CLASSIFICATION_STACK_FOLDER)
    addpath(RESULT_EXPORT_FOLDER)

    waitbar(i / pause_length, weight_bar, sprintf('WAISTing Your Time...'))

end

delete(weight_bar)

disp('Folders loaded. Commencing classification!')

%% Classifying each point cloud

classification_bar = waitbar(0, sprintf('PCD 0 out of %d, ~ X.X min left', num_pcds));

for class_idx = 1:1:num_pcds
    
    %% Clearing Vars for Safety
    
    clear Classification_Result

   %% Overall PCD Timing
    
    tStart = tic;
    
    %% Loading the PCD
    ptCloudA                    = pcread(pcd_files(class_idx).name);
%     
%     pcshow(ptCloudA)
%     pause
%     
    %% Post Load Timing & Debuging Point Cloud

    % DEBUG: Viewing the point cloud for confirmation and context.
%     pcshow(ptCloudA)
%     view([0 0 90])
%     disp('Pausing until ready...')
%     pause
%     close all
%     disp('Continuing!')
        
    pcd_class_start = tic;
    
    %% Plane Projection
    
    % RANSAC
    if ran_proj
        
        maxDistance                 = 0.1;
        model                       = pcfitplane(ptCloudA, maxDistance);
        a                           = model.Parameters(1);
        b                           = model.Parameters(2);
        c                           = model.Parameters(3);
        d                           = model.Parameters(4);
        
        plane_proj_time = [plane_proj_time; toc(pcd_class_start)];
        
        abcd = [a, b, c, d];
        
    end
    
    % MLS
    if mls_proj
        
        x_ptA                       = ptCloudA.Location(:,1);
        y_ptA                       = ptCloudA.Location(:,2);
        z_ptA                       = ptCloudA.Location(:,3);
        xyz_mll                     = [x_ptA y_ptA z_ptA];
        fobjPlane                   = planarFit(xyz_mll(isfinite(xyz_mll(:,1)), :)');
        
        a = fobjPlane.a;
        b = fobjPlane.b;
        c = fobjPlane.c;
        d = fobjPlane.d;
        
        plane_proj_time = [plane_proj_time; toc(pcd_class_start)];
        
        abcd = [a, b, c, d];
        
    end
    
    %% Doing the Classification
    
    num_quadrants;
    num_loops = num_quadrants;
    
%     num_loops = length(ptCloudA.Location(:,1)) / double(num_points_per_quadrant);% - 2;

    iValues = 1:1:int32(num_loops);

    sprintf('Starting classification of PCD %d out of %d', class_idx, num_pcds)
    
    parfor_progress(max(iValues));

    parfor idx = 1:numel(iValues)

        i = iValues(idx);
        
        %% "Split" location / indices
        begin_var                   = (i-1) * num_points_per_quadrant + 1;
        end_var                     = i * num_points_per_quadrant;
        
        if end_var > length(ptCloudA.Location(:,1))
            
            end_var = length(ptCloudA.Location(:,1));
            
        end

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
        
        % Debug value to test for size....
        size_xyzi = [size_xyzi; length(xyzi(:,1))];

        % Debug output........
    %     disp('made it before the if statement')
    %     disp([length(x_array_B) length(y_array_B) length(z_array_B) length(intensity)])

        %% Classification
        if length(xyzi(:,1)) > 3
            
            Classification_Time_Start = tic;

            % Debug output........
    %         disp('made it into the if statement')
    %         disp([length(x_array_B) length(y_array_B) length(z_array_B) length(intensity)])

            %% Feat Extract
            
            % Here is the list in order
            % dlg_list = = {'RAN All', 'RAN TT', 'MLS All', 'MLS TT', 'Range', 'ZXY'};
            % 1 = RAN All
            % 2 = RAN TT
            % 3 = MLS All
            % 4 = MLS TT
            % 5 = RANGE
            % 6 = ZXY
            % THEREFORE
            % 1, 3  = get all feats
            % 2     = get ran tt feats
            % 4     = get mls tt feats
            % 5     = get range feats
            % 6     = get zxy
            % 7     = get z NOT IMPLEMENTED YET!
            
            feat_grab_time_start = tic;
            
            if indx_dlg_list == 1 || indx_dlg_list == 3
                table_export = getallfeats(xyzi, abcd);
            elseif indx_dlg_list == 2
                table_export = gettoptwentyfeatsran(xyzi, abcd);
            elseif indx_dlg_list == 4
                table_export = gettoptwentyfeatsmls(xyzi, abcd);
            elseif indx_dlg_list == 5
                table_export = getrangefeats(xyzi);
            elseif indx_dlg_list == 6
                table_export = getzxyfeats(xyzi);
%             elseif indx_dlg_list == 7
                % table_export = getzfeats(xyzi);
            end
            
%             table_export = get_feats_2(xyzi,[])
            
%             if use_sep_rdf_bool
%                 range_table_export = getrangefeats(xyzi);
%             end
            
            feat_grab_time = [feat_grab_time; toc(feat_grab_time_start)];

            %% Run RFD algorithm
            
            rdf_time_start = tic;
            
            [Yfit, scores, stdevs]              = predict(Mdl, table_export);
%             Yfit = trainedModel.predictFcn(table_export);
            scores = zeros(4,1);
            stdevs = zeros(4,1);

            if use_score_trim_bool
                
                %(Grav_All_Append_Array(:,8) - Grav_All_Append_Array(:,7)) <= 0.3 & (Grav_All_Append_Array(:,8) - Grav_All_Append_Array(:,6)) <= 0.2
                % Do something
                if scores(4) - scores(3) <= 0.1 && scores(4) - scores(2) <= 0.1
                    
                    if scores(3) > scores(2)
                        
                        Yfit = {'foliage'};
                        
                    elseif scores(2) >= scores(3)
                    
                        Yfit = {'grass'};
                        
                    end
                    
                end
                
            end
            
            % If the result is equal to a road surface, use the 2nd
            % algorithm to help determine road surface type
            if use_sep_rdf_bool

                if abs(scores(4) - scores(3)) <= 0.1

                    Yfit = {'grass'};

                elseif isequal(cell2mat(Yfit), 'gravel')

                    range_table_export = getrangefeats(xyzi);

                    [Yfit_2, scores_2, stdevs_2] = predict(Mdl_Range_Verify, range_table_export);

    %                 if isequal(cell2mat(Yfit_2), 'gravel') && isequal(cell2mat(Yfit), 'gravel')
    %                     Yfit = Yfit;
    %                 elseif isequal(cell2mat(Yfit_2), 'grass') && isequal(cell2mat(Yfit), 'gravel')
    %                     Yfit = Yfit;

                    if isequal(cell2mat(Yfit_2), 'gravel') && isequal(cell2mat(Yfit), 'grass')

                        Yfit = Yfit_2;

                    end

                end

            end

            class_rate = [class_rate; toc(rdf_time_start)];
%             [Yfit, scores, stdevs]              = trainedModel4.predictFcn(table_export);
%             Yfit = trainedModel4.predictFcn(table_export);
            
            %% End Time
            
            Classification_Time_End = toc(Classification_Time_Start);

            %% Exporting results to struct

%             if class(Yfit) == 'categorical'
%                 
%                 Yfit = cellstr(Yfit);
%                 
%             end
                
            to_struct_start = tic;
            
            Classification_Result(idx).scores   = scores;
            Classification_Result(idx).stdevs   = stdevs;
            Classification_Result(idx).label    = Yfit;

            Classification_Result(idx).xyzi     = xyzi;
            Classification_Result(idx).time     = Classification_Time_End;
            Classification_Result(idx).avg_xyz  = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3))];
%             Classification_Result(idx).rdf_time = rdf_time_store;
            
            to_struct_time = [to_struct_time; toc(to_struct_start)];

        end % if statment for > than 3 points that are not Inf, NaN, or 0.

        %% Weightbar

        parfor_progress;
        
        %% Clear Vars for Safety

    %     feat_array = []; k = 0; 
    %     x_array_B = []; y_array_B = []; z_array_B = []; intensity = [];
    %     height = []; h_num = 0; h_dem = 0;
    %     guess_label = {}; guess_score = []; class_score_avg = [];
    

    end % Classification
    
    pcd_class_end = [pcd_class_end; toc(pcd_class_start)];
    
    parfor_progress(0);

    %% Saving the Classification Result
    
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
    
    
    %% Time to Completion Estimation
    tEnd = toc(tStart);
    time_store = [time_store; tEnd];
    time_avg = mean(time_store);
    est_time_to_complete = (time_avg * (num_pcds - class_idx)) / 60;
    
    %% Waitbar
    
    sprintf('Classification Complete! ~ %0.1f min left', est_time_to_complete)
    if class_idx == 69
        disp('PCD 69 - Nice')
    end
    waitbar(class_idx/num_pcds,classification_bar,sprintf('PCD %d out of %d, ~ %0.1f min left', class_idx, num_pcds, est_time_to_complete))
    
    
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

%% Applying Tform to each result

disp('Applying Tform to each result')

Grav_All_Append_Array = []; Chip_All_Append_Array = []; Foli_All_Append_Array = []; Gras_All_Append_Array = [];
Grav_Avg_Append_Array = []; Chip_Avg_Append_Array = []; Foli_Avg_Append_Array = []; Gras_Avg_Append_Array = [];

tform_apply_bar = waitbar(0, sprintf('tform 0 out of %d, ~ X.X min left', num_pcds));

for tform_idx = 1:1:num_pcds
    
    % Starting the timer for the progress bar estimated time
    tform_start = tic;

    %% Clearing Vars
    
    grav_array_temp = []; chip_array_temp = []; gras_array_temp = []; foli_array_temp = [];
    grav_avg_array_temp = []; chip_avg_array_temp = []; gras_avg_array_temp = []; foli_avg_array_temp = [];
    
    label_cell = [];

    %% Loading Classification

    load(classification_list(tform_idx).name)
    
    %% Grabbing the Classification Results

    % Go through all the classification results
    parfor result_idx = 1:1:length(Classification_Result)
        
        label                       = Classification_Result(result_idx).label;
        
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

    if ~isempty(grav_array_temp)
        grav_array_temp(:,1:3)          = grav_array_temp(:,1:3)    * tform(tform_idx).Rotation     * corr_z_matrix;
        grav_array_temp(:,1:3)          = grav_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Grav_All_Append_Array               = [Grav_All_Append_Array; grav_array_temp];
    end
    
    if ~isempty(grav_avg_array_temp)
        grav_avg_array_temp             = grav_avg_array_temp       * tform(tform_idx).Rotation     * corr_z_matrix;
        grav_avg_array_temp             = grav_avg_array_temp       + tform(tform_idx).Translation;
        Grav_Avg_Append_Array           = [Grav_Avg_Append_Array; grav_avg_array_temp];
    end
    
    if ~isempty(chip_array_temp)
        chip_array_temp(:,1:3)          = chip_array_temp(:,1:3)    * tform(tform_idx).Rotation     * corr_z_matrix;
        chip_array_temp(:,1:3)          = chip_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Chip_All_Append_Array               = [Chip_All_Append_Array; chip_array_temp];
    end
    
    if ~isempty(chip_avg_array_temp)
        chip_avg_array_temp             = chip_avg_array_temp       * tform(tform_idx).Rotation     * corr_z_matrix;
        chip_avg_array_temp             = chip_avg_array_temp       + tform(tform_idx).Translation;
        Chip_Avg_Append_Array           = [Chip_Avg_Append_Array; chip_avg_array_temp];
    end
    
    if ~isempty(foli_array_temp)
        foli_array_temp(:,1:3)          = foli_array_temp(:,1:3)    * tform(tform_idx).Rotation     * corr_z_matrix;
        foli_array_temp(:,1:3)          = foli_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Foli_All_Append_Array               = [Foli_All_Append_Array; foli_array_temp];
    end
    
    if ~isempty(foli_avg_array_temp)
        foli_avg_array_temp             = foli_avg_array_temp       * tform(tform_idx).Rotation     * corr_z_matrix;
        foli_avg_array_temp             = foli_avg_array_temp       + tform(tform_idx).Translation;
        Foli_Avg_Append_Array           = [Foli_Avg_Append_Array; foli_avg_array_temp];
    end
    
    if ~isempty(gras_array_temp)
        gras_array_temp(:,1:3)          = gras_array_temp(:,1:3)    * tform(tform_idx).Rotation     * corr_z_matrix;
        gras_array_temp(:,1:3)          = gras_array_temp(:,1:3)    + tform(tform_idx).Translation;
        Gras_All_Append_Array               = [Gras_All_Append_Array; gras_array_temp];
    end
    
    if ~isempty(gras_avg_array_temp)
        gras_avg_array_temp             = gras_avg_array_temp       * tform(tform_idx).Rotation     * corr_z_matrix;
        gras_avg_array_temp             = gras_avg_array_temp       + tform(tform_idx).Translation;
        Gras_Avg_Append_Array           = [Gras_Avg_Append_Array; gras_avg_array_temp];
    end
    
    %% Waitbar
    
    tform_time = [tform_time; toc(tform_start)];
    tform_time_avg = mean(tform_time);
    tform_est_time_to_complete = (tform_time_avg * (num_pcds - tform_idx));
    
    waitbar(tform_idx/num_pcds,tform_apply_bar,sprintf('tform %d out of %d, ~ %0.2f sec left', tform_idx, num_pcds, tform_est_time_to_complete))

end % Going through the transform list

delete(tform_apply_bar)

disp('Tform application complete!')


%% Grabbing the time of quadrant classification

disp('Grabbing time of quadrant classification')

for rate_idx = 1:1:num_pcds
    
    % Load classification file
    load(classification_list(rate_idx).name)

    % for each file, grab the time
    for result_idx = 1:1:length(Classification_Result)
        
        quadrant_rate = [quadrant_rate; Classification_Result(result_idx).time];
        
    end

end

disp('Quadrant classification obtained!')

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

plot3(Grav_All_Append_Array(:,1), Grav_All_Append_Array(:,2), Grav_All_Append_Array(:,3), 'c.', 'MarkerSize', 3.5)
plot3(Chip_All_Append_Array(:,1), Chip_All_Append_Array(:,2), Chip_All_Append_Array(:,3), 'k.', 'MarkerSize', 3.5)
% plot3(Foli_All_Append_Array(:,1), Foli_All_Append_Array(:,2), Foli_All_Append_Array(:,3), 'm.', 'MarkerSize', 3.5)
plot3(Gras_All_Append_Array(:,1), Gras_All_Append_Array(:,2), Gras_All_Append_Array(:,3), 'g.', 'MarkerSize', 3.5)

axis('equal')
axis off
view([0 0 90])

xlim([x_min_lim x_max_lim]);
ylim([y_min_lim y_max_lim]);

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

ax = gca;
ax.Clipping = 'off';

%% Average points

result_avg_fig = figure('DefaultAxesFontSize', 14)

hold all

plot3(Grav_Avg_Append_Array(:,1), Grav_Avg_Append_Array(:,2), Grav_Avg_Append_Array(:,3), 'c.', 'MarkerSize', 8.5)
plot3(Chip_Avg_Append_Array(:,1), Chip_Avg_Append_Array(:,2), Chip_Avg_Append_Array(:,3), 'k.', 'MarkerSize', 8.5)
% plot3(Foli_Avg_Append_Array(:,1), Foli_Avg_Append_Array(:,2), Foli_Avg_Append_Array(:,3), 'm.', 'MarkerSize', 8.5)
plot3(Gras_Avg_Append_Array(:,1), Gras_Avg_Append_Array(:,2), Gras_Avg_Append_Array(:,3), 'g.', 'MarkerSize', 8.5)

axis('equal')
axis off
view([0 0 90])

xlim([x_min_lim x_max_lim]);
ylim([y_min_lim y_max_lim]);

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

ax2 = gca;
ax2.Clipping = 'off';

%% Quadrant Rate Time

max_time            = max(quadrant_rate); %s
min_time            = min(quadrant_rate); %s

max_Hz              = 1 / min(quadrant_rate); %Hz
min_Hz              = 1 / max(quadrant_rate); %Hz

quadrant_rate_Hz    =  quadrant_rate.^(-1);

Move_mean_time      = movmean(quadrant_rate, move_avg_size);
Move_mean_Hz        = movmean(quadrant_rate_Hz, move_avg_size);

rate_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10  1400 500])

hold on

plot(quadrant_rate, 'b')
plot(Move_mean_time, 'r', 'LineWidth', 3)

l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

hold off
% axis('equal')

xlabel('Quadrant')
ylabel('Time (s)')

ylim([ min_time max_time])

hold off

% Classification Rate Hz

hz_results_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500])

hold all

plot(quadrant_rate_Hz, 'b')
plot(Move_mean_Hz, 'r', 'LineWidth', 3)

% axis('equal')

xlabel('Quadrant')
ylabel('Hz')

 l = legend({'\color{blue} Time (s)','\color{red} Moving Avg (s)'}, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 4);
    l.Interpreter = 'tex';

hold off

%% Plane projection Time

plane_proj_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500])

plot(plane_proj_time*1000, 'r', 'LineWidth', 3)

xlabel('PCD')
ylabel('Time (ms)')
legend({sprintf('Plane Projection Time (ms)\n Mean: %f', mean(plane_proj_time)*1000)}, 'Location', 'best')

%% XYZI_Size

xyzi_size_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500])

plot(size_xyzi, 'r', 'LineWidth', 3)

xlabel('Quadrant')
ylabel('# Points')
legend({'# Points'}, 'Location', 'best')

%% Quadrant Feat Grab

feat_grab_fig = figure('DefaultAxesFontSize', 14, 'Position', [10 10 1400 500])

plot(feat_grab_time * 1000, 'r', 'LineWidth', 3)

xlabel('Quadrant')
ylabel('Time (ms)')
legend({sprintf('Feat Extr. Time (ms)\n Mean: %f', mean(feat_grab_time))}, 'Location', 'best')

%% Creating result structs

disp('Plotting complete!')

disp('Creating Structs...')

RESULTS_ALL.grav = Grav_All_Append_Array;
RESULTS_ALL.chip = Chip_All_Append_Array;
RESULTS_ALL.foli = Foli_All_Append_Array;
RESULTS_ALL.gras = Gras_All_Append_Array;

RESULTS_AVG.grav = Grav_Avg_Append_Array;
RESULTS_AVG.chip = Chip_Avg_Append_Array;
RESULTS_AVG.foli = Foli_Avg_Append_Array;
RESULTS_AVG.gras = Gras_Avg_Append_Array;

RESULTS_RATE.quadrant_rate = quadrant_rate;
RESULTS_RATE.size_xyzi = size_xyzi;
RESULTS_RATE.feat_grab_time = feat_grab_time;
RESULTS_RATE.plane_proj_time = plane_proj_time;
RESULTS_RATE.class_rate  = class_rate;
RESULTS_RATE.pcd_class_end = pcd_class_end;

%% Saving the Results

disp('Structs Created! Saving structs to disk...')

Save_All_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/ALL_RESULTS.mat";
Save_Avg_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/AVG_RESULTS.mat";
Save_Result_Rate_Filename = string(RESULT_EXPORT_FOLDER) + "/RESULTS_RATE.mat";

save(Save_All_Results_Filename, 'RESULTS_ALL');
save(Save_Avg_Results_Filename, 'RESULTS_AVG');
save(Save_Result_Rate_Filename, 'RESULTS_RATE');

%% Saving Figures

disp('Structs saved to disk!')

if save_figure_bool
    
    disp('PAUSING UNTIL FIGURES RESIZED AS DESIRED!!!')
    pause
    disp('Saving Figures....')

    try

        saveas(result_all_fig, string(IMAGE_EXPORT_FOLDER) + '/result_all_fig.png', 'png');
        saveas(result_avg_fig, string(IMAGE_EXPORT_FOLDER) + '/result_avg_fig.png', 'png');
        saveas(rate_results_fig, string(IMAGE_EXPORT_FOLDER) + '/rate_results_fig.png', 'png');
        saveas(hz_results_fig, string(IMAGE_EXPORT_FOLDER) + '/hz_results_fig.png', 'png');
        saveas(plane_proj_fig, string(IMAGE_EXPORT_FOLDER) + '/plane_proj_fig.png', 'png');
        saveas(xyzi_size_fig, string(IMAGE_EXPORT_FOLDER) + '/xyzi_size_fig.png', 'png');
        saveas(feat_grab_fig, string(IMAGE_EXPORT_FOLDER) + '/feat_grab_fig.png', 'png');
    %     saveas(hz_results_fig, string(IMAGE_EXPORT_FOLDER) + '/hz_results_fig.fig', 'fig');
        saveas(result_all_fig, string(IMAGE_EXPORT_FOLDER) + '/result_all_fig.fig', 'fig');
        saveas(result_avg_fig, string(IMAGE_EXPORT_FOLDER) + '/result_avg_fig.fig', 'fig');
        saveas(rate_results_fig, string(IMAGE_EXPORT_FOLDER) + '/rate_results_fig.fig', 'fig');
        saveas(hz_results_fig, string(IMAGE_EXPORT_FOLDER) + '/hz_results_fig.fig', 'fig');
        saveas(plane_proj_fig, string(IMAGE_EXPORT_FOLDER) + '/plane_proj_fig.fig', 'fig');
        saveas(xyzi_size_fig, string(IMAGE_EXPORT_FOLDER) + '/xyzi_size_fig.fig', 'fig');
        saveas(feat_grab_fig, string(IMAGE_EXPORT_FOLDER) + '/feat_grab_fig.fig', 'fig');
    %     saveas(hz_results_fig, string(IMAGE_EXPORT_FOLDER) + '/hz_results_fig.fig', 'fig');

    catch
        disp('SOME FIGURES GONE!')
    end

    disp('Figures saved')

end

%% End program

if close_figs_bool
    
    close all
    
end

disp('End Program!')

