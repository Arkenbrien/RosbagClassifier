function MCA_plotter_AltColor(Manual_Classfied_Areas, max_h)
    %%
%     hold all
    
    face_alpha_value = 0.15;
    
    % Gravel
    if isfield(Manual_Classfied_Areas, 'grav')
        
        for grav_idx = 1:length(Manual_Classfied_Areas.grav)
            
            to_plot_xy_roi = Manual_Classfied_Areas.grav{grav_idx};
            height_array = ones(length(Manual_Classfied_Areas.grav{grav_idx}),1) * max_h;
            patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[0.00,0.75,0.00], 'FaceAlpha', face_alpha_value)

        end
        
    else
        
        disp('No gravel areas to plot!')
        
    end
    
    % Asphalt/pavement
    if isfield(Manual_Classfied_Areas, 'asph')
        
        for asph_idx = 1:length(Manual_Classfied_Areas.asph)
            
            to_plot_xy_roi = Manual_Classfied_Areas.asph{asph_idx};
            height_array = ones(length(Manual_Classfied_Areas.asph{asph_idx}),1) * max_h;
            patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[0.00,0.50,0.50], 'FaceAlpha', face_alpha_value)

        end
        
    else
        
        disp('No pavement areas to plot!')
        
    end
    
    % Side-Of-Road
    if isfield(Manual_Classfied_Areas, 'non_road')
        
        for nr_idx = 1:length(Manual_Classfied_Areas.non_road)
            
            to_plot_xy_roi = Manual_Classfied_Areas.non_road{nr_idx};
            height_array = ones(length(Manual_Classfied_Areas.non_road{nr_idx}),1) * max_h;
            patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[1.00,0.40,0.10], 'FaceAlpha', face_alpha_value)

        end
        
    else
        
        disp('No side-of-road areas to plot!')
        
    end
    
%     % Gras
%     try
%         
%         for asph_idx = 1:length(Manual_Classfied_Areas.gras)
%             
%             to_plot_xy_roi = Manual_Classfied_Areas.gras{asph_idx};
%             pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
%             plot(pgon,'FaceColor',[0.25,0.50,0.25],'FaceAlpha', face_alpha_value)
% 
%         end
%         
%     catch
%         
%         disp('No grass areas to plot!')
%         
%     end  
    
    % Other road areas
%     try
%         
%         for road_idx = 1:length(Manual_Classfied_Areas.road_roi)
%             
%             to_plot_xy_roi = Manual_Classfied_Areas.road_roi{road_idx};
%             height_array = ones(length(Manual_Classfied_Areas.road_roi{road_idx}),1);
%             patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[0.10, 0.50, 0.00], 'FaceAlpha', face_alpha_value)
% 
%         end
%         
%     catch
%         
%         disp('No pavement areas to plot!')
%         
%     end
    
    
    
end