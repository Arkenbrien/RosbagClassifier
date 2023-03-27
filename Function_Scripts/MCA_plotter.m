function MCA_plotter(Manual_Classfied_Areas)
    
    hold all
    
    % Gravel
    try
        
        for grav_idx = 1:length(Manual_Classfied_Areas.grav)
            
            to_plot_xy_roi = Manual_Classfied_Areas.grav{grav_idx};
            pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
            plot(pgon,'FaceColor',[0.75,0.00,0.00],'FaceAlpha',0.15)

        end
        
    catch
        
        disp('No gravel areas to plot!')
        
    end
    
    % Asphalt/pavement
    try
        
        for asph_idx = 1:length(Manual_Classfied_Areas.asph_roi)
            
            to_plot_xy_roi = Manual_Classfied_Areas.asph_roi{asph_idx};
            pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
            plot(pgon,'FaceColor',[0.50,0.50,0.00],'FaceAlpha',0.15)

        end
        
    catch
        
        disp('No pavement areas to plot!')
        
    end
    
    % Side-Of-Road
    try
        
        for asph_idx = 1:length(Manual_Classfied_Areas.non_road_roi)
            
            to_plot_xy_roi = Manual_Classfied_Areas.non_road_roi{asph_idx};
            pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
            plot(pgon,'FaceColor',[0.50,0.50,0.00],'FaceAlpha',0.15)

        end
        
    catch
        
        disp('No side-of-road areas to plot!')
        
    end
    
    
    % Other road areas
    try
        
        for road_idx = 1:length(Manual_Classfied_Areas.road_roi)
            
            to_plot_xy_roi = Manual_Classfied_Areas.road_roi{road_idx};
            pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
            plot(pgon,'FaceColor',[0.50, 0.50, 1.00],'FaceAlpha',0.15)

        end
        
    catch
        
        disp('No pavement areas to plot!')
        
    end
    
    
    
end