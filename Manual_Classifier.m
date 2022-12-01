%==========================================================================
%                            Rhett Huston
%
%                     FILE CREATION DATE: 10/11/2022
%
%                             PC Manual Area Classifier
%
% This program looks loads a point cloud and asks to select areas that are
% of a desired terrain type. The areas are stored in a .mat file.
%
%==========================================================================

%% Clear Workspace

clear all
close all
clc

%% Loading Point Cloud

disp('Loading PCD...')

% %Setting the import folder location
% [pcd_file, pcd_path]        = uigetfile('/media/autobuntu/chonk/chonk/DATA/*.pcd','Grab PCD file');
% 
% %Setting Full File Path
% pointcloud_obj              = fullfile(pcd_path,pcd_file);
% 
% ptCloudSource               = pcread(pointcloud_obj);
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/DATA/MATLAB_PCD_EXPORT/lidar2Geo_export/2022-10-11-09-31-55/2022-10-11-09-31-55_min5_max25_fullpcd.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/DATA/MATLAB_PCD_EXPORT/lidar2Geo_export/coach_sturbois/sorted_sturbois_straight.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/sturbois_straight_gravel.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/sturbois_straight_gravel.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/sturbois_training_curve.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/sturbois_chipseal_woods_5.ply');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/sturbois_curve_1_all.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/2022-10-20-10-17-06_CHIP_ALL_for_grass.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/2022-10-20-10-13-35_GRAV_ALL_foliage.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/2022-10-20-16-56-40_GRAV.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/sturbois_straight_1_all.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/PCD_RDF_Classifier/2022-10-11-09-28-18_Shortened_Sims.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/shortened_simms_2022_10_11_09_33_39.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/2022-10-20-10-13-35_GRAV.pcd');
% ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT/2022-10-20-1 1-15-07_GRAV_PRESENTAKSJDLF.pcd');

ptCloudSource = pcread('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/ROSBAG_2022-10-11-09-28-18_20225823091158/COMPILED_PCD/2022-10-11-09-28-18.pcd');

ptCloudSource_figure = figure('Name','pcd','NumberTitle','off');
pcshow(ptCloudSource)
axis equal
view([0 0 90])

%% Selecting Export Location

% export_dir = '/media/autobuntu/chonk/chonk/DATA/MATLAB_PCD_EXPORT/lidar2Geo_export/2022-10-11-09-31-55/';

%% Var Init

grav_ind = 1;
chip_ind = 1;
gras_ind = 1;
foli_ind = 1;
non_road_ind = 1;
road_ind = 1;

%% Selecting ROIs

% PROCESS:
% while true...
% Select if gravel, chipseal, foliage, grass
% Select a Polygon
% display the area (?)
% ask if polygon is okay (? - if above is possible then yes do this as a sanity check)
% Store ROI to a gravel, chipseal, foliage, or grass .roi structs
% Ask if finished - if so break.
% If not finished, eliminate the area from the point cloud so that progress
% can be visually seen
% If finished, break
% Save the structures to a single .mat file


while true

    %% Initilization
    % Select desired type
    disp('Select terrain type')
    dlg_list                            = {'Gravel', 'Chipseal', 'Grass', 'Foliage', 'Road Surf', 'Non Road Surf'};
    [indx_dlg_list,~]                   = listdlg('ListString', dlg_list,'SelectionMode','single');

    % Selecting the zoom tool by default
    disp('Zoom to where you want, Sahib')
    zoom(ptCloudSource_figure)

    % Pausing until ready for ROI selection
    disp('Pausing until you are ready, Sahib')
    pause
    view([0 0 90])

    %% Selecting ROI and grabbing points
    % Grab User Defined Area
    disp('Selecting ROI')
    roi = drawpolygon;

    % ROI points, this is the X,Y of each point made in making the Polygon
    x_roi = roi.Position(:,1);
    y_roi = roi.Position(:,2);
    xy_roi = [x_roi y_roi];

    %% Verification

    % Query points, this is the X,Y of the point cloud data
    xq = ptCloudSource.Location(:,1);
    yq = ptCloudSource.Location(:,2);

    % Returns binary results of each point (X/Y)
    in = inpolygon(xq,yq,x_roi,y_roi);

    % Get array of ones
    idx_in = find(in==1);

    % Point cloud B with JUST the indexed points
    disp('Verify that this is okay')
    ptCloudROI = select(ptCloudSource,idx_in);

    hold off

    roi_fig = figure('Name','roi fig','NumberTitle','off');
    pcshow(ptCloudROI)
    view([0 0 90]);

    disp('Pausing until ready')
    pause
    close(roi_fig)

    %% Save or discard
    save_ans = questdlg('Save the data?','Save the data?','Yes','No','Yes');

    hold on

    switch save_ans

        case 'Yes'

            % Save the data based on the dlg_list result
            % Increase counter for each terrain struct



            switch indx_dlg_list

                %  {'Gravel', 'Chipseal', 'Grass', 'Foliage'};

                case 1

                    disp('Gravel')

                    % Save the x y of the polygon points
                    grav_roi{grav_ind} = xy_roi;

                    % increase the index counter
                    grav_ind = grav_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor','red','FaceAlpha',0.75)

                case 2

                    disp('Chipseal')

                    % Save the x y of the polygon points
                    chip_roi{chip_ind} = xy_roi;

                    % increase the index counter
                    chip_ind = chip_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor','white','FaceAlpha',0.75)

                case 3

                    disp('Grass')

                    % Save the x y of the polygon points
                    gras_roi{gras_ind} = xy_roi;

                    % increase the index counter
                    gras_ind = gras_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor','green','FaceAlpha',0.75)

                case 4

                    disp('Foliage')

                    % Save the x y of the polygon points
                    foli_roi{foli_ind} = xy_roi;

                    % increase the index counter
                    foli_ind = foli_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor','magenta','FaceAlpha',0.75)
                    
                case 5
                    
                    disp('Road Surf')
                    %rgb(149,128,255)
                    % Save the x y of the polygon points
                    road_roi{road_ind} = xy_roi;

                    % increase the index counter
                    road_ind = road_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor',[0.58, 0.50, 1.00],'FaceAlpha',0.75)
                    
                case 6

                    disp('Non Road Surf')
                    %rgb(149,128,255)
                    % Save the x y of the polygon points
                    non_road_roi{non_road_ind} = xy_roi;

                    % increase the index counter
                    non_road_ind = non_road_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor',[1.00, 0.65, 0.30],'FaceAlpha',0.75)

            end

            % Clear the workspace for safety
            delete(roi)
            clear xq yq xv yv in indx_in pgon 

        case 'No'

            % Clear the workspace for safety
            delete(roi)
            clear roi xq yq xv yv in indx_in


    end

    % Determine if to contiue looping
    cont_ans = questdlg('Continue?', 'Continue?', 'Yes', 'No', 'Yes');

    switch cont_ans

        case 'Yes'

            % Do something... nothing?

        case 'No'

            break

    end

end

%% Saving the file

if foli_ind ~= 1
    Manual_Classfied_Areas.foli = foli_roi;
end

if gras_ind ~= 1
    Manual_Classfied_Areas.gras = gras_roi;
end

if grav_ind ~= 1
    Manual_Classfied_Areas.grav = grav_roi;
end

if chip_ind ~= 1
    Manual_Classfied_Areas.chip = chip_roi;
end

if road_ind ~= 1
    Manual_Classfied_Areas.road_roi = road_roi;
end

if non_road_ind ~= 1
    Manual_Classfied_Areas.non_road_roi = non_road_roi;
end

name_ans        = inputdlg({'Enter File Name:'}, 'Filename', [1 35], {'Filename'});
name_ans        = string(name_ans{:});

% save_name       = string(name_ans);

export_dir      = uigetdir('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_PCD_EXPORT','Grab Classification Export Directory');
addpath(export_dir)

disp('Saving data...')
time_now        = datetime("now","Format","uuuuMMddhhmmss");
time_now        = datestr(time_now,'yyyyMMddhhmmss');

Filename        = string(export_dir) + "/Manual_Classified_PCD_" + name_ans + ".mat";
save(Filename, 'Manual_Classfied_Areas')

disp('End Program!')














