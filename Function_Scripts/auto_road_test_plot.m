function auto_road_test_plot(left_area_export, cent_area_export, right_area_export, options)

%         % C2
%         area_export.minDistance_c2      = NaN;
%         area_export.maxDistance_c2      = NaN;
%         area_export.meanDistance_c2     = NaN;
%         area_export.stdDistance_c2      = NaN;
%         area_export.stdHeight_c2        = NaN;
%         area_export.meanHeight_c2       = NaN;
%         
%         % C3
%         area_export.minDistance_c3      = NaN;
%         area_export.maxDistance_c3      = NaN;
%         area_export.meanDistance_c3     = NaN;
%         area_export.stdDistance_c3      = NaN;
%         area_export.stdHeight_c3        = NaN;
%         area_export.meanHeight_c3       = NaN;
%         
%         % C4
%         area_export.minDistance_c4      = NaN;
%         area_export.maxDistance_c4      = NaN;
%         area_export.meanDistance_c4     = NaN;
%         area_export.stdDistance_c4      = NaN;
%         area_export.stdHeight_c4        = NaN;
%         area_export.meanHeight_c4       = NaN;
%         
%         % C2 -> C3
%         area_export.DistBetween_c23     = NaN;
%         area_export.Slope_c23           = NaN;
%         
%         % C3 -> C4
%         area_export.DistBetween_c34     = NaN;
%         area_export.Slope_c34           = NaN;
%         
%         % C2 -> C4
%         area_export.d43_32_ratio        = NaN;
        
    %%
    close all
    for idx = 1:length(cent_area_export)
        
        Slope_c23(idx) = right_area_export{idx}.Slope_c23;
        Slope_c34(idx) = right_area_export{idx}.Slope_c34;
        
        if isequal(right_area_export{idx}.clas, 'gravel')
            grav_guess(idx) = 1;
        else
            grav_guess(idx) = 0;
        end
        
    end
    
    figure
    hold on
    plot(Slope_c23)
    plot(Slope_c34)
    plot(grav_guess*max(Slope_c34))
    xlim([100 length(cent_area_export)])
    legend('Slope_c23', 'Slope_c34', 'grav')
    hold off
    
    
    %%
    close all
    for idx = 1:length(cent_area_export)
        
        Slope_c23(idx) = left_area_export{idx}.meanDistance_c3;
        Slope_c34(idx) = left_area_export{idx}.meanDistance_c4;
        
%         % C2
%         area_export.minDistance_c2      = NaN;
%         area_export.maxDistance_c2      = NaN;
%         area_export.meanDistance_c2     = NaN;
%         area_export.stdDistance_c2      = NaN;
%         area_export.stdHeight_c2        = NaN;
%         area_export.meanHeight_c2       = NaN;
%         
%         % C3
%         area_export.minDistance_c3      = NaN;
%         area_export.maxDistance_c3      = NaN;
%         area_export.meanDistance_c3     = NaN;
%         area_export.stdDistance_c3      = NaN;
%         area_export.stdHeight_c3        = NaN;
%         area_export.meanHeight_c3       = NaN;
%         
%         % C4
%         area_export.minDistance_c4      = NaN;
%         area_export.maxDistance_c4      = NaN;
%         area_export.meanDistance_c4     = NaN;
%         area_export.stdDistance_c4      = NaN;
%         area_export.stdHeight_c4        = NaN;
%         area_export.meanHeight_c4       = NaN;
        
        if isequal(right_area_export{idx}.clas, 'gravel')
            grav_guess(idx) = 1;
        else
            grav_guess(idx) = 0;
        end
        
    end
    
    figure
    hold on
    plot(Slope_c23)
    plot(Slope_c34)
%     plot(grav_guess*max(Slope_c34))
    xlim([100 length(cent_area_export)])
    legend('Slope_c23', 'Slope_c34', 'grav')
    hold off
    
     %%
    close all
    for idx = 1:length(left_area_export)
        
%         A(idx) = left_area_export{idx}.stdDistance_c2;
%         B(idx) = left_area_export{idx}.stdDistance_c3;
%         C(idx) = left_area_export{idx}.stdDistance_c4;

        A(idx) = mean(left_area_export{idx}.Slope_c24);
        B(idx) = mean(left_area_export{idx}.Slope_c24_minmax);
        C(idx) = mean(left_area_export{idx}.Slope_c34);
        
%         % C2
%         area_export.minDistance_c2      = NaN;
%         area_export.maxDistance_c2      = NaN;
%         area_export.meanDistance_c2     = NaN;
%         area_export.stdDistance_c2      = NaN;
%         area_export.stdHeight_c2        = NaN;
%         area_export.meanHeight_c2       = NaN;
%         
%         % C3
%         area_export.minDistance_c3      = NaN;
%         area_export.maxDistance_c3      = NaN;
%         area_export.meanDistance_c3     = NaN;
%         area_export.stdDistance_c3      = NaN;
%         area_export.stdHeight_c3        = NaN;
%         area_export.meanHeight_c3       = NaN;
%         
%         % C4
%         area_export.minDistance_c4      = NaN;
%         area_export.maxDistance_c4      = NaN;
%         area_export.meanDistance_c4     = NaN;
%         area_export.stdDistance_c4      = NaN;
%         area_export.stdHeight_c4        = NaN;
%         area_export.meanHeight_c4       = NaN;
        
        if isequal(right_area_export{idx}.clas, 'gravel')
            grav_guess(idx) = 1;
        else
            grav_guess(idx) = 0;
        end
        
    end
    
    figure
    hold on
    plot(A)
    plot(B)
    plot(C)
    plot(grav_guess*max(C))
    xlim([100 length(left_area_export)])
    legend('A', 'B', 'C', 'grav')
    hold off
    
end
