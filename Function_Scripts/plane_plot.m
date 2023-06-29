%==========================================================================
%                               Rhett Huston
%
%                      FILE CREATION DATE: 05/12/2022
%
%                               Plane Plot
%
% This program plots a plane for visulization purposes.
%
%==========================================================================

function plane_plot(plane_params,xyz_input)
    %%
    % What are the minimum/maximum values of each dimention
    xmin = min(xyz_input(:,1)); xmax = max(xyz_input(:,1));
    ymin = min(xyz_input(:,2)); ymax = max(xyz_input(:,2));
    zmin = min(xyz_input(:,3)); zmax = max(xyz_input(:,3));
    
    %% Creating the minimum/maximum array for determining the corners of
    % the projected plane. Plane will be large enough to cover the entire
    % point cloud map by determining the maximum value of that array. A
    % grid is generated using the maximum found values.
    minmax          = [xmin xmax ymin ymax zmin zmax];
    max_minmax      = max(minmax);
%     max_minmax      = 3;
    ndgrid_array    = [-max_minmax max_minmax];
    
    %% Creating the grid
%     [xx, yy]        = ndgrid(ndgrid_array,ndgrid_array);
    
    [xx, yy]        = meshgrid([xmax,xmin], [ymax,ymin]);

    %% Determining the z value for each point in the array
    z               = (-plane_params(1)*xx - plane_params(2)*yy - plane_params(4)) / plane_params(3);
    
    %% Plotting the plane
    
    surfplot = surf(xx,yy,z,'FaceAlpha',0.25);
    surfplot.EdgeColor = 'none';
    surfplot.FaceColor = 'r';
    
    hold on
    
    % Plotting the points
    scatterplot = scatter3(xyz_input(:,1), xyz_input(:,2), xyz_input(:,3), 100, 'Marker', 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
%     scatterplot.Marker = 'o';
%     scatterplot.LineWidth = 0.75;
    axis('equal')
    
%     legend({plot_title_string, 'XYZ samples'}, 'Location','northoutside','FontSize',15);
    xlabel('X [m]');
    ylabel('Y [m]');
    zlabel('Z [m]');
    
%     xlim([-50 50])
    
    ax2 = gca;
    ax2.Clipping = 'off';
    
    hold off
    
end

