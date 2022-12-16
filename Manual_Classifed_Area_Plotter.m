%==========================================================================
%                            Rhett Huston
%
%                     FILE CREATION DATE: 10/11/2022
%
%                   PC Manual Area Classifier Plotter
%
% This program looks loads a point cloud and and manually defined areas and
% plots those bad boys out.
%
%==========================================================================

%% Clear Workspace

clear all
close all
clc

%% Requesting user for file

root_dir = uigetdir();

%% Grabbing Manual Classification File

MANUAL_CLASSIFICATION_FILE = string(root_dir) + "/MANUAL_CLASSIFICATION/MANUAL_CLASSIFICATION.mat";
load(MANUAL_CLASSIFICATION_FILE)

%% Grabbing compiled pcd

disp('Loading PCD...')

Combined_Pcd_File = string(root_dir) + "/COMPILED_PCD/COMPILED_PCD.pcd";

ptCloudSource = pcread(Combined_Pcd_File);

ptCloudSource_figure = figure('Name','pcd','NumberTitle','off');

axes1 = axes('Tag','PointCloud','Parent',ptCloudSource_figure);
hold(axes1,'on');

pcshow(ptCloudSource)
axis equal
view([0 0 90])

% Set the remaining axes properties
set(axes1,'Color','white','DataAspectRatio',[1 1 1],'XColor','black','YColor','black','ZColor','black');
set(gcf,'Color','white');

hold on

%% Plotting Manually Defined Areas


if isfield(Manual_Classfied_Areas,'grav')
    
    for plot_idx = 1:length(Manual_Classfied_Areas.grav)
        
        xy_roi = Manual_Classfied_Areas.grav{1,plot_idx};
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','red','FaceAlpha',0.75)
        
    end
    
end

if isfield(Manual_Classfied_Areas,'chip')
    
    for plot_idx = 1:length(Manual_Classfied_Areas.chip)
        
        xy_roi = Manual_Classfied_Areas.chip{1,plot_idx};
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','white','FaceAlpha',0.75)
        
    end
    
end

if isfield(Manual_Classfied_Areas,'gras')
    
    for plot_idx = 1:length(Manual_Classfied_Areas.gras)
        
        xy_roi = Manual_Classfied_Areas.gras{1,plot_idx};
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','green','FaceAlpha',0.75)
        
    end
    
end

if isfield(Manual_Classfied_Areas,'foli')
    
    for plot_idx = 1:length(Manual_Classfied_Areas.foli)
        
        xy_roi = Manual_Classfied_Areas.foli{1,plot_idx};
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','magenta','FaceAlpha',0.75)
        
    end
    
end

if isfield(Manual_Classfied_Areas,'road_roi')
    
    for plot_idx = 1:length(Manual_Classfied_Areas.road_roi)
        
        xy_roi = Manual_Classfied_Areas.road_roi{1,plot_idx};
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor',[0.58, 0.50, 1.00],'FaceAlpha',0.75)
        
    end
    
end

if isfield(Manual_Classfied_Areas,'non_road_roi')
    
    for plot_idx = 1:length(Manual_Classfied_Areas.non_road_roi)
        
        xy_roi = Manual_Classfied_Areas.non_road_roi{1,plot_idx};
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor',[1.00, 0.65, 0.30],'FaceAlpha',0.75)
        
    end
    
end

%% Clean UP

axis off
hold off

%% End PrograM

disp('End Program')

























