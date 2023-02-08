function fobjPlane= MLL_plane_proj(xyz_trim)

%     disp('MLL Plane Projection')
    
    %% Transpose
    
    % planarFit only works with x y z rows not columns.
    xyz_trim_t = xyz_trim';

    
    %% Fit Plane (MLL)
        
    % Plot?
    plot_bool = 0;

    % Call to determine the plane fit
    fobjPlane=planarFit(xyz_trim_t);
    
    if plot_bool == 1
        
        % Min/max of the arrays for plot limits
        xmin = min(xyz_trim_t(1,:)); xmax = max(xyz_trim_t(1,:));
        ymin = min(xyz_trim_t(2,:)); ymax = max(xyz_trim_t(2,:));
        zmin = min(xyz_trim_t(3,:)); zmax = max(xyz_trim_t(3,:));

        figure('DefaultAxesFontSize',14)
        
        [hL,hD] = plot(fobjPlane); %Visualize the fit

        xlim([xmin xmax])
        ylim([ymin ymax])
        zlim([zmin zmax])
        legend([hL,hD],'Plane fit MLL', 'XYZ samples', 'Location','northoutside','FontSize',15);
        xlabel('X [m]');
        ylabel('Y [m]');
        zlabel('Z [m]');
        
    end
    
    

end

