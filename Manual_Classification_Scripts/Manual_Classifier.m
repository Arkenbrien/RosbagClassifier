%==========================================================================
%                            Rhett Huston
%
%                     FILE CREATION DATE: 10/11/2022
%
%                       PC Manual Area Classifier
%
% This program looks loads a point cloud and asks to select areas that are
% of a desired terrain type. The areas are stored in a .mat file.
%
%==========================================================================

%% Clear Workspace

clear all
close all
clc

%% Options

load_prev_MCA_file = 1;
use_prev_MCA_file = 0;


%% Ask user to load previous file

% WARNING! Must ensure that the previous file is what you want, please do
% not try to do anything stupid like load a MCA for one pcd and then add
% new rois for a different pcd! This is asking for trouble! Very bad!
% 
% load_prev_MCA_file = questdlg("Load previous file? This will apphend any future additions to the file, and will not delete previous rois.",... 
%     "Load Previous File?",...
%     "Yes", "No", "No");


%% Loading point cloud

% Ask user for location of pcd
% [pcfile, pcfolder, ~] = uigetfile('/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/lot_intercept/*.pcd','Get PCD');
[pcfile, pcfolder, ~] = uigetfile('/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/*.pcd','Get PCD');

addpath(string(pcfolder));

disp('Loading PCD...')
ptCloudSource = pcread(pcfile);

ptCloudSource_figure = figure('Name','pcd','NumberTitle','off');
pcshow(ptCloudSource)
axis equal
view([0 0 90])

%% Loading the old MCA file if selected
if load_prev_MCA_file
    
    % Load File
    [Manual_Classfied_Areas_File, mca_folder] = uigetfile("/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/", "Grab old MCA");
    load(Manual_Classfied_Areas_File)
    
    mca_plot_fun(Manual_Classfied_Areas)
    
end

disp('PCD Loaded!')


%% Creating Export Location

% Time of Run
time_now                = datetime("now","Format","uuuuMMddhhmmss");
time_now                = datestr(time_now,'yyyyMMddhhmmss');

% if load_prev_MCA_file == "Yes"
%     
%     [mca_dir, mca_name, mca_type] = fileparts(which(Manual_Classfied_Areas_File));
%     
%     Filename = string(mca_dir) + "/" + string(mca_name) + string(mca_type);
% 
% else
%     
%     MANUAL_CLASSIFICATION_FOLDER = string(root_dir) + "/MANUAL_CLASSIFICATION";
%     mkdir(MANUAL_CLASSIFICATION_FOLDER);
%     addpath(MANUAL_CLASSIFICATION_FOLDER);
%     Filename = string(MANUAL_CLASSIFICATION_FOLDER) + "/MANUAL_CLASSIFICATION.mat";
%     
% end

if load_prev_MCA_file
    
    Filename = string(mca_folder) + string(Manual_Classfied_Areas_File) + "_" + string(time_now) + ".mat";
    
else
    
    Filename = string(pcfolder) + string(pcfile) + ".mat";
    
end


%% Var Init

grav_ind_start          = 1;
chip_ind_start          = 1;
gras_ind_start          = 1;
foli_ind_start          = 1;
non_road_ind_start      = 1;
road_ind_start          = 1;
asph_ind_start          = 1;

if use_prev_MCA_file
    
    try
        grav_ind_start      = length(Manual_Classfied_Areas.grav);
        grav_ind            = grav_ind_start + 1;
    catch
        grav_ind        = 1;
    end
    try
        chip_ind_start      = length(Manual_Classfied_Areas.chip);
        chip_ind            = chip_ind_start + 1;
    catch
        chip_ind        = 1;
    end
    try
        gras_ind_start      = length(Manual_Classfied_Areas.gras);
        gras_ind            = gras_ind_start + 1;
    catch
        gras_ind        = 1;
    end
    try
        foli_ind_start      = length(Manual_Classfied_Areas.foli);
        foli_ind            = foli_ind_start + 1;
    catch
        foli_ind        = 1;
    end
    try
        asph_ind_start      = length(Manual_Classfied_Areas.asph);
        asph_ind            = asph_ind_start + 1;
    catch
        asph_ind        = 1;
    end
    try
        non_road_ind_start  = length(Manual_Classfied_Areas.non_road);
        non_road_ind        = non_road_ind_start + 1;
    catch
        non_road_ind    = 1;
    end
    try
        road_ind_start      = length(Manual_Classfied_Areas.road);
        road_ind            = road_ind_start + 1;
    catch
        road_ind        = 1;
    end
    
else
    
    grav_ind        = 1;
    chip_ind        = 1;
    gras_ind        = 1;
    foli_ind        = 1;
    asph_ind        = 1;
    non_road_ind    = 1;
    road_ind        = 1;
    
end

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
    dlg_list                            = {'Gravel', 'Chipseal', 'Grass', 'Foliage', 'Road Surf', 'Non Road Surf', 'Asph'};
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
                    Manual_Classfied_Areas.grav{grav_ind} = xy_roi;

                    % increase the index counter
                    grav_ind = grav_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor','red','FaceAlpha',0.75)

                case 2

                    disp('Chipseal')

                    % Save the x y of the polygon points
                    Manual_Classfied_Areas.chip{chip_ind} = xy_roi;

                    % increase the index counter
                    chip_ind = chip_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor','white','FaceAlpha',0.75)

                case 3

                    disp('Grass')

                    % Save the x y of the polygon points
                    Manual_Classfied_Areas.gras{gras_ind} = xy_roi;

                    % increase the index counter
                    gras_ind = gras_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor','green','FaceAlpha',0.75)

                case 4

                    disp('Foliage')

                    % Save the x y of the polygon points
                    Manual_Classfied_Areas.foli{foli_ind} = xy_roi;

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
                    Manual_Classfied_Areas.road{road_ind} = xy_roi;

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
                    Manual_Classfied_Areas.non_road{non_road_ind} = xy_roi;

                    % increase the index counter
                    non_road_ind = non_road_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor',[0.75 ,0.25, 0.75],'FaceAlpha',0.75)
                    
                case 7
                    
                    disp('Asphalt')
                    % Save the x y of the polygon points
                    Manual_Classfied_Areas.asph{asph_ind} = xy_roi;

                    % increase the index counter
                    asph_ind = asph_ind + 1;

                    % Plot the shape unto the point cloud for easy
                    % identification
                    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
                    plot(pgon,'FaceColor',[0.50,0.50,0.00],'FaceAlpha',0.75)
                    
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

%% Saving MCA file

save_ans = questdlg('Save?', 'Save?', 'Yes', 'No', 'Yes');

switch save_ans

    case 'Yes'
        
        disp('Saving File')
        save(Filename, 'Manual_Classfied_Areas')
        
    case 'No'

        disp('Not Saving File')

end


%% End Program

close all

disp('End Program!')

