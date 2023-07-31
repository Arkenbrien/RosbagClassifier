function area_export = check_areas(Avg_Arrays, tformed_area, tformed_origin, area_guess_opts)
    
    
    %% Temp Debug Area
    
%     tformed_area = tformed_l;
    
    %% VAR INIT
    
    tformed_ax = tformed_area(:,1);
    tformed_ay = tformed_area(:,2);
    area_export.origin = tformed_origin;
    
    
     %% Get points in area

    indices.c2g = find(inpolygon(Avg_Arrays.grav2(:,1), Avg_Arrays.grav2(:,2), tformed_ax, tformed_ay)==1);
    indices.c3g = find(inpolygon(Avg_Arrays.grav3(:,1), Avg_Arrays.grav3(:,2), tformed_ax, tformed_ay)==1);
    indices.c4g = find(inpolygon(Avg_Arrays.grav4(:,1), Avg_Arrays.grav4(:,2), tformed_ax, tformed_ay)==1);

    indices.c2a = find(inpolygon(Avg_Arrays.asph2(:,1), Avg_Arrays.asph2(:,2), tformed_ax, tformed_ay)==1);
    indices.c3a = find(inpolygon(Avg_Arrays.asph3(:,1), Avg_Arrays.asph3(:,2), tformed_ax, tformed_ay)==1);
    indices.c4a = find(inpolygon(Avg_Arrays.asph4(:,1), Avg_Arrays.asph4(:,2), tformed_ax, tformed_ay)==1);

    indices.c2u = find(inpolygon(Avg_Arrays.unkn2(:,1), Avg_Arrays.unkn2(:,2), tformed_ax, tformed_ay)==1);
    indices.c3u = find(inpolygon(Avg_Arrays.unkn3(:,1), Avg_Arrays.unkn3(:,2), tformed_ax, tformed_ay)==1);
    indices.c4u = find(inpolygon(Avg_Arrays.unkn4(:,1), Avg_Arrays.unkn4(:,2), tformed_ax, tformed_ay)==1);
    
    c2_sum = length(indices.c2g) + length(indices.c2a) + length(indices.c2u);
    c3_sum = length(indices.c3g) + length(indices.c3a) + length(indices.c3u);
    c4_sum = length(indices.c4g) + length(indices.c4a) + length(indices.c4u);
    
    area_export.road_classes_sum = length(indices.c2g) + length(indices.c2a) +  length(indices.c3g) + length(indices.c3a) + length(indices.c4g) + length(indices.c4a);
    area_export.non_road_classes_sum = length(indices.c2u) + length(indices.c3u) + length(indices.c4u);
    
    area_export.grav_points     = [Avg_Arrays.grav2(indices.c2g,1), Avg_Arrays.grav2(indices.c2g,2), Avg_Arrays.grav2(indices.c2g,3);... 
                                   Avg_Arrays.grav3(indices.c3g,1), Avg_Arrays.grav3(indices.c3g,2), Avg_Arrays.grav3(indices.c3g,3);...
                                   Avg_Arrays.grav4(indices.c4g,1), Avg_Arrays.grav4(indices.c4g,2), Avg_Arrays.grav4(indices.c4g,3)];

    area_export.asph_points     = [Avg_Arrays.asph2(indices.c2a,1), Avg_Arrays.asph2(indices.c2a,2), Avg_Arrays.asph2(indices.c2a,3);... 
                                   Avg_Arrays.asph3(indices.c3a,1), Avg_Arrays.asph3(indices.c3a,2), Avg_Arrays.asph3(indices.c3a,3);...
                                   Avg_Arrays.asph4(indices.c4a,1), Avg_Arrays.asph4(indices.c4a,2), Avg_Arrays.asph4(indices.c4a,3)];

    area_export.unkn_points     = [Avg_Arrays.unkn2(indices.c2u,1), Avg_Arrays.unkn2(indices.c2u,2), Avg_Arrays.unkn2(indices.c2u,3);...
                                   Avg_Arrays.unkn3(indices.c3u,1), Avg_Arrays.unkn3(indices.c3u,2), Avg_Arrays.unkn3(indices.c3u,3);...
                                   Avg_Arrays.unkn4(indices.c4u,1), Avg_Arrays.unkn4(indices.c4u,2), Avg_Arrays.unkn4(indices.c4u,3)];

        
    if c2_sum > 1 && c3_sum > 1 && c4_sum > 1
        
%         area_export = checkIfPointsInAllChannels(Avg_Arrays, indices, area_guess_opts, tformed_area, area_export);
        area_export = checkIfPointsInAllChannelsLLRRTest(Avg_Arrays, indices, area_guess_opts, tformed_area, area_export);

    elseif area_export.road_classes_sum > area_export.non_road_classes_sum * 5 && area_export.road_classes_sum > 2
        
%         area_export = checkIfPointsInAllChannels(Avg_Arrays, indices, area_guess_opts, tformed_area, area_export);
        area_export = checkIfPointsInAllChannelsLLRRTest(Avg_Arrays, indices, area_guess_opts, tformed_area, area_export);
        
    else

        area_export = unknownArea(area_export, tformed_area);
        
            
    end % if there's data in all three channels
    
end

%% Old Code




            

                



