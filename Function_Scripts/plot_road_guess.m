function plot_road_guess(left_area_export, cent_area_export, right_area_export, Manual_Classfied_Areas, Avg_Arrays, options)

    %% VAR INIT

    road_guess_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
    
    face_alpha_value = 0.15;
    
    %% PLOT

    % Left
    for area_idx = 1:length(left_area_export)
        
        if isequal(string(left_area_export{area_idx}.clas), 'gravel')
            
            patch(left_area_export{area_idx}.area(:,1),left_area_export{area_idx}.area(:,2),left_area_export{area_idx}.area(:,3),[0.00,1.00,1.00], 'FaceAlpha', face_alpha_value)
            
        elseif isequal(string(left_area_export{area_idx}.clas), 'asphalt')
            
            patch(left_area_export{area_idx}.area(:,1),left_area_export{area_idx}.area(:,2),left_area_export{area_idx}.area(:,3),[0.00,0.00,0.00], 'FaceAlpha', face_alpha_value)
            
        end
     

    end
    
    % Center
    for area_idx = 1:length(cent_area_export)
        
        if isequal(string(cent_area_export{area_idx}.clas), 'gravel')
            
            patch(cent_area_export{area_idx}.area(:,1),cent_area_export{area_idx}.area(:,2),cent_area_export{area_idx}.area(:,3),[0.00,1.00,1.00], 'FaceAlpha', face_alpha_value)
            
        elseif isequal(string(cent_area_export{area_idx}.clas), 'asphalt')
            
            patch(cent_area_export{area_idx}.area(:,1),cent_area_export{area_idx}.area(:,2),cent_area_export{area_idx}.area(:,3),[0.00,0.00,0.00], 'FaceAlpha', face_alpha_value)
            
        else
            
            patch(cent_area_export{area_idx}.area(:,1),cent_area_export{area_idx}.area(:,2),cent_area_export{area_idx}.area(:,3),[1.00,0.00,0.00], 'FaceAlpha', 0.1)
            
        end
     

    end
    
    % right
    for area_idx = 1:length(right_area_export)
        
        if isequal(string(right_area_export{area_idx}.clas), 'gravel')
            
            patch(right_area_export{area_idx}.area(:,1),right_area_export{area_idx}.area(:,2),right_area_export{area_idx}.area(:,3),[0.00,1.00,1.00], 'FaceAlpha', face_alpha_value)
            
        elseif isequal(string(right_area_export{area_idx}.clas), 'asphalt')
            
            patch(right_area_export{area_idx}.area(:,1),right_area_export{area_idx}.area(:,2),right_area_export{area_idx}.area(:,3),[0.00,0.00,0.00], 'FaceAlpha', face_alpha_value)
            
        end
     

    end
    
    
    axis equal
    
    hold on
    
    MCA_plotter(Manual_Classfied_Areas, 0)
    
    hold off
    
    hold all
    
    if options.plot_avg_in_ani_bool
        
        plot_avg_class_results_fun(Avg_Arrays, Manual_Classfied_Areas, options)
        
    end

    axis off
    
    
end