function area_export = check_areas(Avg_Arrays, tformed_area, tformed_origin, area_guess_opts)
    
    
    %% Temp Debug Area
    
%     tformed_area = tformed_r;
    
    %% VAR INIT
    
    tformed_ax = tformed_area(:,1);
    tformed_ay = tformed_area(:,2);
    area_export.origin = tformed_origin;
    
    
     %% Get points in area

    c2g_indices = find(inpolygon(Avg_Arrays.grav2(:,1), Avg_Arrays.grav2(:,2), tformed_ax, tformed_ay)==1);
    c3g_indices = find(inpolygon(Avg_Arrays.grav3(:,1), Avg_Arrays.grav3(:,2), tformed_ax, tformed_ay)==1);
    c4g_indices = find(inpolygon(Avg_Arrays.grav4(:,1), Avg_Arrays.grav4(:,2), tformed_ax, tformed_ay)==1);

    c2a_indices = find(inpolygon(Avg_Arrays.asph2(:,1), Avg_Arrays.asph2(:,2), tformed_ax, tformed_ay)==1);
    c3a_indices = find(inpolygon(Avg_Arrays.asph3(:,1), Avg_Arrays.asph3(:,2), tformed_ax, tformed_ay)==1);
    c4a_indices = find(inpolygon(Avg_Arrays.asph4(:,1), Avg_Arrays.asph4(:,2), tformed_ax, tformed_ay)==1);

    c2u_indices = find(inpolygon(Avg_Arrays.unkn2(:,1), Avg_Arrays.unkn2(:,2), tformed_ax, tformed_ay)==1);
    c3u_indices = find(inpolygon(Avg_Arrays.unkn3(:,1), Avg_Arrays.unkn3(:,2), tformed_ax, tformed_ay)==1);
    c4u_indices = find(inpolygon(Avg_Arrays.unkn4(:,1), Avg_Arrays.unkn4(:,2), tformed_ax, tformed_ay)==1);
    
    
    %% Get Array
    
    c2_array = [Avg_Arrays.grav2(c2g_indices,1), Avg_Arrays.grav2(c2g_indices,2), Avg_Arrays.grav2(c2g_indices,3);... 
                Avg_Arrays.asph2(c2a_indices,1), Avg_Arrays.asph2(c2a_indices,2), Avg_Arrays.asph2(c2a_indices,3);... 
                Avg_Arrays.unkn2(c2u_indices,1), Avg_Arrays.unkn2(c2u_indices,2), Avg_Arrays.unkn2(c2u_indices,3)];
            
    c3_array = [Avg_Arrays.grav3(c3g_indices,1), Avg_Arrays.grav3(c3g_indices,2), Avg_Arrays.grav3(c3g_indices,3);... 
                Avg_Arrays.asph3(c3a_indices,1), Avg_Arrays.asph3(c3a_indices,2), Avg_Arrays.asph3(c3a_indices,3);... 
                Avg_Arrays.unkn3(c3u_indices,1), Avg_Arrays.unkn3(c3u_indices,2), Avg_Arrays.unkn3(c3u_indices,3)];
            
    c4_array = [Avg_Arrays.grav4(c4g_indices,1), Avg_Arrays.grav4(c4g_indices,2), Avg_Arrays.grav4(c4g_indices,3);... 
                Avg_Arrays.asph4(c4a_indices,1), Avg_Arrays.asph4(c4a_indices,2), Avg_Arrays.asph4(c4a_indices,3);... 
                Avg_Arrays.unkn4(c4u_indices,1), Avg_Arrays.unkn4(c4u_indices,2), Avg_Arrays.unkn4(c4u_indices,3)];
    
    data_array = [c2_array; c3_array; c4_array];
    
    area_export.all_points      = data_array;
    
    area_export.grav_points     = [Avg_Arrays.grav2(c2g_indices,1), Avg_Arrays.grav2(c2g_indices,2), Avg_Arrays.grav2(c2g_indices,3);... 
                                   Avg_Arrays.grav3(c3g_indices,1), Avg_Arrays.grav3(c3g_indices,2), Avg_Arrays.grav3(c3g_indices,3);...
                                   Avg_Arrays.grav4(c4g_indices,1), Avg_Arrays.grav4(c4g_indices,2), Avg_Arrays.grav4(c4g_indices,3)];
                            
    area_export.asph_points     = [Avg_Arrays.asph2(c2a_indices,1), Avg_Arrays.asph2(c2a_indices,2), Avg_Arrays.asph2(c2a_indices,3);... 
                                   Avg_Arrays.asph3(c3a_indices,1), Avg_Arrays.asph3(c3a_indices,2), Avg_Arrays.asph3(c3a_indices,3);...
                                   Avg_Arrays.asph4(c4a_indices,1), Avg_Arrays.asph4(c4a_indices,2), Avg_Arrays.asph4(c4a_indices,3)];
                               
    area_export.unkn_points     = [Avg_Arrays.unkn2(c2u_indices,1), Avg_Arrays.unkn2(c2u_indices,2), Avg_Arrays.unkn2(c2u_indices,3);...
                                   Avg_Arrays.unkn3(c3u_indices,1), Avg_Arrays.unkn3(c3u_indices,2), Avg_Arrays.unkn3(c3u_indices,3);...
                                   Avg_Arrays.unkn4(c4u_indices,1), Avg_Arrays.unkn4(c4u_indices,2), Avg_Arrays.unkn4(c4u_indices,3)];
    
                               
    %% If array is not empty and has enough to do math on it
    
    if  height(data_array) >= 2

        %% Get Per Channel Percentages

        chan2_sum = length(c2g_indices) + length(c2a_indices) + length(c2u_indices);
        chan3_sum = length(c3g_indices) + length(c3a_indices) + length(c3u_indices);
        chan4_sum = length(c4g_indices) + length(c4a_indices) + length(c4u_indices); 

        if chan2_sum > 0
            chan2_g_percent = length(c2g_indices) / chan2_sum;
            chan2_a_percent = length(c2a_indices) / chan2_sum; 
            chan2_u_percent = length(c2u_indices) / chan2_sum;
        else
            chan2_g_percent = 0;
            chan2_a_percent = 0; 
            chan2_u_percent = 0;
        end

        if chan3_sum > 0
            chan3_g_percent = length(c3g_indices) / chan3_sum;
            chan3_a_percent = length(c3a_indices) / chan3_sum;
            chan3_u_percent = length(c3u_indices) / chan3_sum;
        else
            chan3_g_percent = 0;
            chan3_a_percent = 0;
            chan3_u_percent = 0;
        end

        if chan4_sum > 0
            chan4_g_percent = length(c4g_indices) / chan4_sum;
            chan4_a_percent = length(c4a_indices) / chan4_sum;
            chan4_u_percent = length(c4u_indices) / chan4_sum;
        else
            chan4_g_percent = 0;
            chan4_a_percent = 0;
            chan4_u_percent = 0;
        end
        
        
        %% Get Per Area Percentages
        
        tot_grav_percent = 100 * ((length(c2g_indices) + length(c3g_indices) + length(c4g_indices)) / (chan2_sum + chan3_sum + chan4_sum));
        tot_asph_percent = 100 * ((length(c2a_indices) + length(c3a_indices) + length(c4a_indices)) / (chan2_sum + chan3_sum + chan4_sum));
        tot_unkn_percent = 100 * ((length(c2u_indices) + length(c3u_indices) + length(c4u_indices)) / (chan2_sum + chan3_sum + chan4_sum));
        area_export.tot_percent = [tot_grav_percent, tot_asph_percent, tot_unkn_percent];
        
        
        %% Get distance between lines
        
        distances_c2 = pdist2([c2_array(:,1), c2_array(:,2)], [c3_array(:,1), c3_array(:,2)]);
        distances_c3 = pdist2([c3_array(:,1), c3_array(:,2)], [c2_array(:,1), c2_array(:,2); c4_array(:,1), c4_array(:,2)]);
        distances_c4 = pdist2([c4_array(:,1), c4_array(:,2)], [c3_array(:,1), c3_array(:,2)]);
        
        
        %% Get Features
        
        % C2
        area_export.minDistance_c2      = min(distances_c2(:));
        area_export.maxDistance_c2      = max(distances_c2(:));
        area_export.meanDistance_c2     = mean(distances_c2(:));
        area_export.stdDistance_c2      = std(distances_c2);
        area_export.stdHeight_c2        = std(c2_array(:,3));
        area_export.meanHeight_c2       = mean(c2_array(:,3));
        
        % C3
        area_export.minDistance_c3      = min(distances_c3(:));
        area_export.maxDistance_c3      = max(distances_c3(:));
        area_export.meanDistance_c3     = mean(distances_c3(:));
        area_export.stdDistance_c3      = std(distances_c3);
        area_export.stdHeight_c3        = std(c3_array(:,3));
        area_export.meanHeight_c3       = mean(c3_array(:,3));
        
        % C4
        area_export.minDistance_c4      = min(distances_c4(:));
        area_export.maxDistance_c4      = max(distances_c4(:));
        area_export.meanDistance_c4     = mean(distances_c4(:));
        area_export.stdDistance_c4      = std(distances_c4);
        area_export.stdHeight_c4        = std(c4_array(:,3));
        area_export.meanHeight_c4       = mean(c4_array(:,3));
        
        % C2 -> C3
        area_export.DistBetween_c23     = area_export.meanDistance_c3 - area_export.meanDistance_c2;
        area_export.Slope_c23           = abs((area_export.meanHeight_c3 - area_export.meanHeight_c2) / (area_export.meanDistance_c3 - area_export.meanDistance_c2));
        
        % C3 -> C4
        area_export.DistBetween_c34     = area_export.meanDistance_c4 - area_export.meanDistance_c3;
        area_export.Slope_c34           = abs((area_export.meanHeight_c3 - area_export.meanHeight_c4) / (area_export.meanDistance_c3 - area_export.meanDistance_c4));
        
        % C2 -> C4
        area_export.d43_32_ratio = (area_export.meanDistance_c4 - area_export.meanDistance_c3) / (area_export.meanDistance_c3 - area_export.meanDistance_c2);
        tooClose = any(area_export.minDistance_c2(:) < area_guess_opts.close_threshold) || any(area_export.minDistance_c3(:) < area_guess_opts.close_threshold) || any(area_export.minDistance_c4(:) < area_guess_opts.close_threshold);
        tooFar = any(area_export.maxDistance_c2(:) > area_guess_opts.far_threshold) || any(area_export.maxDistance_c3(:) > area_guess_opts.far_threshold) || any(area_export.maxDistance_c4(:) > area_guess_opts.far_threshold);

        
        %% Check if area is road surface

        if chan2_g_percent > area_guess_opts.c2g_min && chan3_g_percent > area_guess_opts.c3g_min && chan4_g_percent > area_guess_opts.c4g_min
            
            if tooClose %|| tooFar
                
                area_export.area    = tformed_area;
                area_export.clas    = 'unknown';
                
            elseif area_export.stdHeight_c2 > 1 || area_export.stdHeight_c3 > 1 || area_export.stdHeight_c4 > 1
                
                area_export.area    = tformed_area;
                area_export.clas    = 'unknown'; 
                
            elseif area_export.stdDistance_c4 > 2.5
                
                area_export.area    = tformed_area;
                area_export.clas    = 'unknown';
            
            elseif (area_export.DistBetween_c34 - area_export.DistBetween_c23) < -0.75
                
                area_export.area    = tformed_area;
                area_export.clas    = 'unknown'; 
                           
            elseif area_export.d43_32_ratio > area_guess_opts.d43_32_ratio_max
                
                area_export.area    = tformed_area;
                area_export.clas    = 'unknown';
                
%             elseif area_export.meanDistance_c4 < (area_export.meanDistance_c2 + 2.5) || area_export.meanDistance_c4 < (area_export.meanDistance_c3 + 1.0)
%                 
%                 area_export.area    = tformed_area;
%                 area_export.clas    = 'unknown';

            elseif chan2_g_percent > area_guess_opts.c2g_min && chan3_g_percent > area_guess_opts.c3g_min && chan4_a_percent > area_guess_opts.c4a_min

                area_export.area    = tformed_area;
                area_export.clas    = 'gravel';
                
            else
                
                area_export.area    = tformed_area;
                area_export.clas    = 'gravel';
                
            end
            
        elseif chan2_a_percent > area_guess_opts.c2a_min && chan3_a_percent > area_guess_opts.c3a_min && chan4_a_percent > area_guess_opts.c4a_min

            area_export.area    = tformed_area;
            area_export.clas    = 'asphalt';
            
        elseif tot_asph_percent > 65.0
            
            area_export.area    = tformed_area;
            area_export.clas    = 'asphalt';
            
        elseif tot_asph_percent > 35.0 && tot_grav_percent > 35.0
            
            area_export.area    = tformed_area;
            area_export.clas    = 'asphalt';

        else

            area_export.area    = tformed_area;
            area_export.clas    = 'unknown';

        end
        
        
    else % if less than two points in array
        
        area_export.area                = tformed_area;
        area_export.clas                = 'unknown';
        area_export.points              = [NaN, NaN, NaN];
        area_export.tot_percent         = [0, 0, 0];
        
        % C2
        area_export.minDistance_c2      = NaN;
        area_export.maxDistance_c2      = NaN;
        area_export.meanDistance_c2     = NaN;
        area_export.stdDistance_c2      = NaN;
        area_export.stdHeight_c2        = NaN;
        area_export.meanHeight_c2       = NaN;

        % C3
        area_export.minDistance_c3      = NaN;
        area_export.maxDistance_c3      = NaN;
        area_export.meanDistance_c3     = NaN;
        area_export.stdDistance_c3      = NaN;
        area_export.stdHeight_c3        = NaN;
        area_export.meanHeight_c3       = NaN;
        
        % C4
        area_export.minDistance_c4      = NaN;
        area_export.maxDistance_c4      = NaN;
        area_export.meanDistance_c4     = NaN;
        area_export.stdDistance_c4      = NaN;
        area_export.stdHeight_c4        = NaN;
        area_export.meanHeight_c4       = NaN;
        
        % C2 -> C3
        area_export.DistBetween_c23     = NaN;
        area_export.Slope_c23           = NaN;
        
        % C3 -> C4
        area_export.DistBetween_c34     = NaN;
        area_export.Slope_c34           = NaN;
        
        % C2 -> C4
        area_export.d43_32_ratio        = NaN;
        
    end
    
    
    
end

%% Old Code




            

                



