function area_export = checkIfPointsInAllChannelsLLRRTest(Avg_Arrays, indices, area_guess_opts, tformed_area, area_export)



        %% Get Array

        c2_array = [Avg_Arrays.grav2(indices.c2g,1), Avg_Arrays.grav2(indices.c2g,2), Avg_Arrays.grav2(indices.c2g,3);... 
                    Avg_Arrays.asph2(indices.c2a,1), Avg_Arrays.asph2(indices.c2a,2), Avg_Arrays.asph2(indices.c2a,3);... 
                    Avg_Arrays.unkn2(indices.c2u,1), Avg_Arrays.unkn2(indices.c2u,2), Avg_Arrays.unkn2(indices.c2u,3)];

        c3_array = [Avg_Arrays.grav3(indices.c3g,1), Avg_Arrays.grav3(indices.c3g,2), Avg_Arrays.grav3(indices.c3g,3);... 
                    Avg_Arrays.asph3(indices.c3a,1), Avg_Arrays.asph3(indices.c3a,2), Avg_Arrays.asph3(indices.c3a,3);... 
                    Avg_Arrays.unkn3(indices.c3u,1), Avg_Arrays.unkn3(indices.c3u,2), Avg_Arrays.unkn3(indices.c3u,3)];

        c4_array = [Avg_Arrays.grav4(indices.c4g,1), Avg_Arrays.grav4(indices.c4g,2), Avg_Arrays.grav4(indices.c4g,3);... 
                    Avg_Arrays.asph4(indices.c4a,1), Avg_Arrays.asph4(indices.c4a,2), Avg_Arrays.asph4(indices.c4a,3);... 
                    Avg_Arrays.unkn4(indices.c4u,1), Avg_Arrays.unkn4(indices.c4u,2), Avg_Arrays.unkn4(indices.c4u,3)];

        data_array = [c2_array; c3_array; c4_array];

        area_export.all_points      = data_array;



        %% If array is not empty and has enough to do math on it

        if  height(data_array) >= 2

            %% Get Per Channel Percentages

            chan2_sum = length(indices.c2g) + length(indices.c2a) + length(indices.c2u);
            chan3_sum = length(indices.c3g) + length(indices.c3a) + length(indices.c3u);
            chan4_sum = length(indices.c4g) + length(indices.c4a) + length(indices.c4u); 

            if chan2_sum > 0
                chan2_g_percent = length(indices.c2g) / chan2_sum;
                chan2_a_percent = length(indices.c2a) / chan2_sum; 
                chan2_u_percent = length(indices.c2u) / chan2_sum;
            else
                chan2_g_percent = 0;
                chan2_a_percent = 0; 
                chan2_u_percent = 0;
            end

            if chan3_sum > 0
                chan3_g_percent = length(indices.c3g) / chan3_sum;
                chan3_a_percent = length(indices.c3a) / chan3_sum;
                chan3_u_percent = length(indices.c3u) / chan3_sum;
            else
                chan3_g_percent = 0;
                chan3_a_percent = 0;
                chan3_u_percent = 0;
            end

            if chan4_sum > 0
                chan4_g_percent = length(indices.c4g) / chan4_sum;
                chan4_a_percent = length(indices.c4a) / chan4_sum;
                chan4_u_percent = length(indices.c4u) / chan4_sum;
            else
                chan4_g_percent = 0;
                chan4_a_percent = 0;
                chan4_u_percent = 0;
            end


            %% Get Per Area Percentages

            tot_grav_percent = 100 * ((length(indices.c2g) + length(indices.c3g) + length(indices.c4g)) / (chan2_sum + chan3_sum + chan4_sum));
            tot_asph_percent = 100 * ((length(indices.c2a) + length(indices.c3a) + length(indices.c4a)) / (chan2_sum + chan3_sum + chan4_sum));
            tot_unkn_percent = 100 * ((length(indices.c2u) + length(indices.c3u) + length(indices.c4u)) / (chan2_sum + chan3_sum + chan4_sum));
            area_export.tot_percent = [tot_grav_percent, tot_asph_percent, tot_unkn_percent];


            %% Get distance between lines

%             distances_c2 = pdist2([c2_array(:,1), c2_array(:,2)], [c3_array(:,1), c3_array(:,2)]);
%             distances_c3 = pdist2([c3_array(:,1), c3_array(:,2)], [c2_array(:,1), c2_array(:,2); c4_array(:,1), c4_array(:,2)]);
%             distances_c4 = pdist2([c4_array(:,1), c4_array(:,2)], [c3_array(:,1), c3_array(:,2)]);

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
            area_export.minHeight_c2        = min(c2_array(:,3));
            area_export.maxHeight_c2        = max(c2_array(:,3));
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
            area_export.minHeight_c4        = min(c4_array(:,3));
            area_export.maxHeight_c4        = max(c4_array(:,3));
            area_export.meanHeight_c4       = mean(c4_array(:,3));

            % C2 -> C3
            area_export.DistBetween_c23     = area_export.meanDistance_c3 - area_export.meanDistance_c2;
            area_export.Slope_c23           = abs((area_export.meanHeight_c3 - area_export.meanHeight_c2) / (area_export.meanDistance_c3 - area_export.meanDistance_c2));

            % C3 -> C4
            area_export.DistBetween_c34     = area_export.meanDistance_c4 - area_export.meanDistance_c3;
            area_export.Slope_c34           = abs((area_export.meanHeight_c3 - area_export.meanHeight_c4) / (area_export.meanDistance_c3 - area_export.meanDistance_c4));

            % C2 -> C4
            area_export.Slope_c24           = abs((area_export.meanHeight_c2 - area_export.meanHeight_c4) / (area_export.meanDistance_c2 - area_export.meanDistance_c4));
            area_export.Slope_c24_minmax    = abs((area_export.minHeight_c2 - area_export.maxHeight_c4) / (area_export.minDistance_c2 - area_export.maxDistance_c4));
            area_export.Slope_c24_minmax2   = abs((area_export.maxHeight_c2 - area_export.minHeight_c4) / (area_export.maxDistance_c2 - area_export.minDistance_c4));
            area_export.d43_32_ratio = (area_export.meanDistance_c4 - area_export.meanDistance_c3) / (area_export.meanDistance_c3 - area_export.meanDistance_c2);
            tooClose = any(area_export.minDistance_c2(:) < area_guess_opts.close_threshold) || any(area_export.minDistance_c3(:) < area_guess_opts.close_threshold) || any(area_export.minDistance_c4(:) < area_guess_opts.close_threshold);
            tooFar = any(area_export.maxDistance_c2(:) > area_guess_opts.far_threshold) || any(area_export.maxDistance_c3(:) > area_guess_opts.far_threshold) || any(area_export.maxDistance_c4(:) > area_guess_opts.far_threshold);


            %% Check if area is road surface
                            
            %    
            % Gravel Arguments
            %
            
            if chan2_g_percent > area_guess_opts.c2g_min && chan3_g_percent > area_guess_opts.c3g_min && chan4_g_percent > area_guess_opts.c4g_min

%                 if tooClose %|| tooFar
% 
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'unknown';
%                     
% %                 elseif  isempty(indices.c3u) && isempty(indices.c4u)
%                 elseif  isempty(indices.c4g)
%                     
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'unknown';
% 
%                 elseif area_export.stdHeight_c2 > 1 || area_export.stdHeight_c3 > 1 || area_export.stdHeight_c4 > 1
% 
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'unknown'; 
% 
%                 elseif area_export.stdDistance_c4 > 2.5
% 
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'unknown';
% 
%                 elseif (area_export.DistBetween_c34 - area_export.DistBetween_c23) < -0.75
% 
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'unknown'; 
% 
%                 elseif area_export.d43_32_ratio > area_guess_opts.d43_32_ratio_max
% 
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'unknown';
% 
% %                 elseif area_export.meanDistance_c4 < (area_export.meanDistance_c3 - .125)
% %                     
% %                     area_export.area    = tformed_area;
% %                     area_export.clas    = 'unknown';
% 
%                 elseif chan2_g_percent > area_guess_opts.c2g_min && chan3_g_percent > area_guess_opts.c3g_min && chan4_a_percent > area_guess_opts.c4a_min
% 
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'gravel';
% 
%                 else

                    area_export.area    = tformed_area;
                    area_export.clas    = 'gravel';

%                 end

                
            %    
            % Asphalt Arguments
            %
            
            elseif chan2_a_percent > area_guess_opts.c2a_min && chan3_a_percent > area_guess_opts.c3a_min && chan4_a_percent > area_guess_opts.c4a_min

                area_export.area    = tformed_area;
                area_export.clas    = 'asphalt';

            elseif tot_asph_percent > 65.0
                
                if isempty(indices.c3a) && isempty(indices.c4a)
                    
                    area_export.area    = tformed_area;
                    area_export.clas    = 'unknown';
                    
                elseif ~isempty(indices.c2a) && ~isempty(indices.c3a) && ~isempty(indices.c4a)

                    area_export.area    = tformed_area;
                    area_export.clas    = 'asphalt';
                    
                else
                    
                    if area_export.road_classes_sum > area_export.non_road_classes_sum * 5 && area_export.road_classes_sum > 5
                        
                        area_export.area    = tformed_area;
                        area_export.clas    = 'asphalt';
                        
                    else
                        
                        area_export.area    = tformed_area;
                        area_export.clas    = 'unknown';
                        
                    end
                    
                end

            elseif tot_asph_percent > 35.0 && tot_grav_percent > 35.0

%                  if isempty(indices.c3a) && isempty(indices.c4a)
                    
                    area_export.area    = tformed_area;
                    area_export.clas    = 'asphalt';
                    
%             elseif area_export.road_classes_sum > area_export.non_road_classes_sum * 5
%                     
% %                 elseif ~isempty(indices.c2a) && ~isempty(indices.c3a) && ~isempty(indices.c4a)
% % 
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'asphalt';
%                     
%                 else
%                     
%                     area_export.area    = tformed_area;
%                     area_export.clas    = 'unknown';
%                     
%                 end



            else

                area_export.area    = tformed_area;
                area_export.clas    = 'unknown';

            end


        else % if less than two points in array

            area_export = unknownArea(area_export, tformed_area);

        end % if there's more than three rows of data
        
    
    
end