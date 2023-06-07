function MCA_plotter(Manual_Classfied_Areas, max_h)
    
%     hold on
    
    face_alpha_value = 0.15;
    
    % Gravel
    if isfield(Manual_Classfied_Areas, 'grav')
        
        for grav_idx = 1:length(Manual_Classfied_Areas.grav)
            
            to_plot_xy_roi = Manual_Classfied_Areas.grav{grav_idx};
            height_array = ones(length(Manual_Classfied_Areas.grav{grav_idx}),1) * max_h;
            patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[1.00,0.00,0.00], 'FaceAlpha', face_alpha_value)

        end
        
    else
        
        disp('No gravel areas to plot!')
        
    end
    
    % Asphalt/pavement
    if isfield(Manual_Classfied_Areas, 'asph')
        
        for asph_idx = 1:length(Manual_Classfied_Areas.asph)
            
            to_plot_xy_roi = Manual_Classfied_Areas.asph{asph_idx};
            height_array = ones(length(Manual_Classfied_Areas.asph{asph_idx}),1) * max_h;
            patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[0.50,0.50,0.00], 'FaceAlpha', face_alpha_value)

        end
        
    else
        
        disp('No pavement areas to plot!')
        
    end
    
%     Side-Of-Road
    if isfield(Manual_Classfied_Areas, 'non_road')
        
        for nr_idx = 1:length(Manual_Classfied_Areas.non_road)
            
            to_plot_xy_roi = Manual_Classfied_Areas.non_road{nr_idx};
            height_array = ones(length(Manual_Classfied_Areas.non_road{nr_idx}),1) * max_h;
            patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[0.75 ,0.25, 0.75], 'FaceAlpha', face_alpha_value)

        end
        
    else
        
        disp('No side-of-road areas to plot!')
        
    end
    
%     % gras
%     if isfield(Manual_Classfied_Areas, 'gras')
%         
%         for gras_idx = 1:length(Manual_Classfied_Areas.gras)
%             
%             to_plot_xy_roi = Manual_Classfied_Areas.gras{gras_idx};
%             height_array = ones(length(Manual_Classfied_Areas.gras{grav_idx}),1) * max_h;
%             patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[0.75 ,0.25, 0.75], 'FaceAlpha', face_alpha_value)
% 
%         end
%         
%     else
%         
%         disp('No side-of-road areas to plot!')
%         
%     end
    
    
%     % Other road areas
%     if isfield(Manual_Classfied_Areas, 'road')
%         
%         for road_idx = 1:length(Manual_Classfied_Areas.road)
%             
%             to_plot_xy_roi = Manual_Classfied_Areas.road_roi{road_idx};
%             pgon = polyshape(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2));
%             plot(pgon,'FaceColor',[0.50, 0.50, 1.00],'FaceAlpha', face_alpha_value)
%             height_array = ones(length(Manual_Classfied_Areas.grav{grav_idx}),1) * max_h;
%             patch(to_plot_xy_roi(:,1),to_plot_xy_roi(:,2),height_array,[0.00,0.75,0.00], 'FaceAlpha', face_alpha_value)
% 
%         end
%         
%     else
%         
%         disp('No other pavement areas to plot!')
%         
%     end
    
end