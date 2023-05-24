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

%% Options

% roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/rm_db_2.mat';
pcd_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/rm_db_2.pcd';
roi_file = '/media/autobuntu/chonk/chonk/DATA/chonk_ROSBAG/redmen/drive_by/r_u_a_asph/rm_db_2_where_training_area.mat';

%% Var Init

face_alpha_value = 0.75;
h2 = zeros(1,3);

%% Grabbing compiled pcd

disp('Loading PCD...')

ptCloudSource = pcread(pcd_file);


Z_max = ptCloudSource.ZLimits(2);


point_cloud_to_plot = [ ptCloudSource.Location(:,1),  ptCloudSource.Location(:,2),  ptCloudSource.Location(:,3),  ptCloudSource.Intensity];

point_cloud_to_plot(:,3) = point_cloud_to_plot(:,3) - (1.25*Z_max);

ptCloudSource = pointCloud([point_cloud_to_plot(:,1),  point_cloud_to_plot(:,2),  point_cloud_to_plot(:,3)], 'Intensity', point_cloud_to_plot(:,4));

ptCloudSource_figure = figure('Name','pcd','NumberTitle','off');


axes1 = axes('Parent',ptCloudSource_figure);
set(axes1,'XColor','none','YColor','none','ZColor','none');

hold all

h2(1) = plot(NaN,NaN,'s', 'Color', [0.75, 0.00, 0.00]);
h2(2) = plot(NaN,NaN,'s', 'Color', [0.50, 0.50, 0.00]);
h2(3) = plot(NaN,NaN,'s', 'Color', [0.50, 0.50, 1.00]);
    
axes1 = axes('Tag','PointCloud','Parent',ptCloudSource_figure);
hold(axes1,'on');

pcshow(ptCloudSource)
axis equal
view([0 0 90])

% Set the remaining axes properties
set(axes1,'Color','white','DataAspectRatio',[1 1 1],'XColor','none','YColor','none','ZColor','none');
set(gcf,'Color','white');

axis off

ax = gca;
ax.Clipping = 'off';

hold all

%% Plotting Manually Defined Areas

load(roi_file)

hold all
    

% Gravel
try

    for grav_idx = 1:length(Manual_Classfied_Areas.grav)

        to_plot_xy_roi = Manual_Classfied_Areas.grav{grav_idx};
        pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
%         shp = alphaShape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),double(ones(length(to_plot_xy_roi(:,1)),1)*Z_max));
        plot(pgon,'FaceColor',[0.75,0.00,0.00],'FaceAlpha', face_alpha_value)
%         plot(shp,'FaceColor',[0.75,0.00,0.00],'FaceAlpha', face_alpha_value)
        
    end

catch

    disp('No gravel areas to plot!')

end

% Asphalt/pavement
%     try

    for asph_idx = 1:length(Manual_Classfied_Areas.asph)

        to_plot_xy_roi = Manual_Classfied_Areas.asph{asph_idx};
        pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
%         shp = alphaShape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),double(ones(length(to_plot_xy_roi(:,1)),1)*Z_max))
        plot(pgon,'FaceColor',[0.50,0.50,0.00],'FaceAlpha', face_alpha_value)
%         plot(shp,'FaceColor',[0.50,0.50,0.00],'FaceAlpha', face_alpha_value)

    end

%     catch

    disp('No pavement areas to plot!')

%     end

% Side-Of-Road
try

    for asph_idx = 1:length(Manual_Classfied_Areas.non_road)

        to_plot_xy_roi = Manual_Classfied_Areas.non_road{asph_idx};
        pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
%         shp = alphaShape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),double(ones(length(to_plot_xy_roi(:,1)),1)*Z_max));
        plot(pgon,'FaceColor',[0.75 ,0.25, 0.75],'FaceAlpha', face_alpha_value)
%         plot(shp,'FaceColor',[0.50,0.50,0.00],'FaceAlpha', face_alpha_value)
        
    end

catch

    disp('No side-of-road areas to plot!')

end


% gras
try

    for asph_idx = 1:length(Manual_Classfied_Areas.gras)

        to_plot_xy_roi = Manual_Classfied_Areas.gras{asph_idx};
        pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
%         shp = alphaShape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),double(ones(length(to_plot_xy_roi(:,1)),1)*Z_max));
        plot(pgon,'FaceColor',[0.00,1.00,0.00],'FaceAlpha', face_alpha_value)
%         plot(shp,'FaceColor',[0.50,0.50,0.00],'FaceAlpha', face_alpha_value)
        
    end

catch

    disp('No side-of-road areas to plot!')

end

% Other road areas
try

    for road_idx = 1:length(Manual_Classfied_Areas.road)

        to_plot_xy_roi = Manual_Classfied_Areas.road_roi{road_idx};
        pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
%         shp = alphaShape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),double(ones(length(to_plot_xy_roi(:,1)),1)*Z_max));
        plot(pgon,'FaceColor',[0.50, 0.50, 1.00],'FaceAlpha', face_alpha_value)
%          plot(shp,'FaceColor',[0.50, 0.50, 1.00],'FaceAlpha', face_alpha_value)

    end

catch

    disp('No pavement areas to plot!')

end
% 
% axes1 = axes('Tag','PointCloud','Parent',ptCloudSource_figure);
% hold(axes1,'on');
% 
% pcshow(ptCloudSource)
% axis equal
% view([0 0 90])
% 
% % Set the remaining axes properties
% set(axes1,'Color','white','DataAspectRatio',[1 1 1],'XColor','black','YColor','black','ZColor','black');
% set(gcf,'Color','white');


%% Clean UP

% axis off
% 
% % Legend
% h2(1) = plot(NaN,NaN,'s', 'Color', [0.75, 0.00, 0.00]);
% h2(2) = plot(NaN,NaN,'s', 'Color', [0.50, 0.50, 0.00]);
% h2(3) = plot(NaN,NaN,'s', 'Color', [0.75 ,0.25, 0.75]);
% l = legend(h2, {'\color[rgb]{0.75, 0.00, 0.00} Gravel',...
%                 '\color[rgb]{0.50, 0.50, 0.00} Asphalt',...
%                 '\color[rgb]{0.75, 0.25, 0.75} Side of Road'},...
%                 'FontSize', 28,...
%                 'FontWeight', 'bold',... 
%                 'LineWidth', 4,...
%                 'FontName', 'Monospaced');
% l.Interpreter = 'tex';
% 
% hold off

axis off

% Legend
h2(1) = plot(NaN,NaN,'s', 'Color', [0.75, 0.00, 0.00], 'MarkerSize', 20, 'LineWidth', 10);
h2(2) = plot(NaN,NaN,'s', 'Color', [0.50, 0.50, 0.00], 'MarkerSize', 20, 'LineWidth', 10);
h2(3) = plot(NaN,NaN,'s', 'Color', [0.00, 1.00, 0.00], 'MarkerSize', 20, 'LineWidth', 10);
l = legend(h2, {'\color[rgb]{0.75, 0.00, 0.00} Gravel',...
                '\color[rgb]{0.50, 0.50, 0.00} Asphalt',...
                '\color[rgb]{0.00, 1.00, 0.00} Grass'},...
                'FontSize', 28,...
                'FontWeight', 'bold',... 
                'LineWidth', 4);
l.Interpreter = 'tex';

hold off



%% End PrograM

disp('End Program')

























