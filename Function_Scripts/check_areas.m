function area_export = check_areas(Avg_Arrays, tformed_area, area_guess_opts)
    
    
    %% Temp Debug Area
    
%     tformed_area = tformed_r;
    
    %% VAR INIT
    
    tformed_ax = tformed_area(:,1);
    tformed_ay = tformed_area(:,2);
    clear c2g_indices c3g_indices c4g_indices c2a_indices c3a_indices c4a_indices c2u_indices c3u_indices c4u_indices
    clear data_array
    
    
     %% Check Areas

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
                                   Avg_Arrays.asph3(c3a_indices,1), Avg_Arrays.asph3(c3a_indices,2), Avg_Arrays.asph3(c3a_indices,3);...
                                   Avg_Arrays.unkn4(c4u_indices,1), Avg_Arrays.unkn4(c4u_indices,2), Avg_Arrays.unkn4(c4u_indices,3)];
                                   
                                   
    
    if  height(data_array) >= 2

        %% Get Percentages

        chan2_sum = length(c2g_indices) + length(c2a_indices) + length(c2u_indices);
        chan3_sum = length(c3g_indices) + length(c3a_indices) + length(c3u_indices);
        chan4_sum = length(c4g_indices) + length(c4a_indices) + length(c4u_indices); 

        if chan2_sum > 0
            chan2_g_percent = length(c2g_indices) / chan2_sum;
            chan2_a_percent = length(c2a_indices) / chan2_sum; 
        else
            chan2_g_percent = 0;
            chan2_a_percent = 0; 
        end

        if chan3_sum > 0
            chan3_g_percent = length(c3g_indices) / chan3_sum;
            chan3_a_percent = length(c3a_indices) / chan3_sum;        
        else
            chan3_g_percent = 0;
            chan3_a_percent = 0;
        end

        if chan4_sum > 0
            chan4_g_percent = length(c4g_indices) / chan4_sum;
            chan4_a_percent = length(c4a_indices) / chan4_sum;
        else
            chan4_g_percent = 0;
            chan4_a_percent = 0;
        end


        %% Get MLS

        model_MLS                   = MLL_plane_proj(data_array(isfinite(data_array(:,1)), :));
        abcd                        = [model_MLS.a, model_MLS.b, model_MLS.c, model_MLS.d];


        %% Getting height, range, z, intensity

        % Getting height
        h_num                       = abs((abcd(1) * data_array(:,1)) + (abcd(2) *  data_array(:,2)) + (abcd(3) *  data_array(:,3)) - abcd(4));
        h_dem                       = sqrt(abcd(1)^2 + abcd(2)^2 + abcd(3)^2);
        height_array                      = h_num / h_dem;

        % Getting height properties
        height_stan_dev             = std(height_array);
    %     disp(height_stan_dev)


        %% Check if area is road surface

        if chan2_g_percent > area_guess_opts.c2g_min && chan3_g_percent > area_guess_opts.c3g_min && chan4_g_percent > area_guess_opts.c4g_min && height_stan_dev < area_guess_opts.stdv

            area_export.area    = tformed_area;
            area_export.clas    = 'gravel';


        elseif chan2_a_percent > area_guess_opts.c2a_min && chan3_a_percent > area_guess_opts.c3a_min && chan4_a_percent > area_guess_opts.c4a_min && height_stan_dev < area_guess_opts.stdv

            area_export.area    = tformed_area;
            area_export.clas    = 'asphalt';

        else

            area_export.area    = tformed_area;
            area_export.clas    = 'unknown';

        end
        
    else
        
        area_export.area    = tformed_area;
        area_export.clas    = 'unknown';
        area_export.points  = [NaN, NaN, NaN];
        
    end
    
    
    
end