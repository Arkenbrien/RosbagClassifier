function class_score_function(avg_cell_store, Manual_Classfied_Areas)

    %% Options
    
    
    %% Var Init

    % Get index of non-empty cells
    used_chans = find(~cellfun(@isempty,avg_cell_store));

    
    %% For each channel
    
    for chan_idx = 1:length(used_chans)
        
        
        %% Grabbing the arrays 
        
        % Loads up each result's average coordinate for each
        % classification
        Grav_Avg_Array = avg_cell_store{used_chans(chan_idx)}.Grav;
        Asph_Avg_Array = avg_cell_store{used_chans(chan_idx)}.Asph;
        Gras_Avg_Array = avg_cell_store{used_chans(chan_idx)}.Gras;
                
        
        %% Gravel
        
        try
            
            for grav_idx = 1:length(Manual_Classfied_Areas.grav)

                % Grabs the polygon data
                xy_roi              = Manual_Classfied_Areas.grav{:,grav_idx};

                % Grabs the indexes for all the points that lie in the polygon
                grav_in_grav        = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                asph_in_grav        = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                gras_in_grav        = sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                tot_in_area         = grav_in_grav + asph_in_grav + gras_in_grav;
                
                if tot_in_area ~= 0 

                    % Score per area
                    channel_in_grav_area_score{chan_idx, grav_idx}.grav_score = grav_in_grav / tot_in_area * 100;
                    channel_in_grav_area_score{chan_idx, grav_idx}.asph_score = asph_in_grav / tot_in_area * 100;
                    channel_in_grav_area_score{chan_idx, grav_idx}.gras_score = gras_in_grav / tot_in_area * 100;
                    channel_in_grav_area_score{chan_idx, grav_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];
                    
                else
                    
                    disp('tot_in_area == 0!')
                
                end
                
            end

        catch

            disp('No gravel areas to score!')
            channel_in_grav_area_score = [];

        end

        
        %% Asphalt/pavement
        
        try

            for asph_idx = 1:length(Manual_Classfied_Areas.asph_roi)
                                
                % Grabs the polygon data
                xy_roi              = Manual_Classfied_Areas.asph_roi{:,asph_idx};

                % Grabs the indexes for all the points that lie in the polygon
                grav_in_asph        =  sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                asph_in_asph        =  sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                gras_in_asph        =  sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                tot_in_area         = grav_in_asph + asph_in_asph + gras_in_asph;

                % Score per area
                if tot_in_area ~= 0
                    
                    channel_in_asph_area_score{chan_idx, asph_idx}.grav_score = grav_in_asph / tot_in_area * 100;
                    channel_in_asph_area_score{chan_idx, asph_idx}.asph_score = asph_in_asph / tot_in_area * 100;
                    channel_in_asph_area_score{chan_idx, asph_idx}.gras_score = gras_in_asph / tot_in_area * 100;
                    channel_in_asph_area_score{chan_idx, asph_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];
                    
                end
                
            end

        catch

            disp('No pavement areas to score!')
            channel_in_asph_area_score = [];

        end

        
        %% Non-Road (nr) == Side-Of-Road
        
        try

            for nr_idx = 1:length(Manual_Classfied_Areas.non_road_roi)

                % Grabs the polygon data
                xy_roi              = Manual_Classfied_Areas.non_road_roi{:,nr_idx};

                % Grabs the indexes for all the points that lie in the polygon
                grav_in_nonroad     = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                asph_in_nonroad     = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                gras_in_nonroad     = sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                tot_in_area         = grav_in_nonroad + asph_in_nonroad + gras_in_nonroad;

                % Score per area
                if tot_in_area ~= 0

                    channel_in_nonroad_area_score{chan_idx, nr_idx}.grav_score = grav_in_nonroad / tot_in_area * 100;
                    channel_in_nonroad_area_score{chan_idx, nr_idx}.asph_score = asph_in_nonroad / tot_in_area * 100;
                    channel_in_nonroad_area_score{chan_idx, nr_idx}.gras_score = gras_in_nonroad / tot_in_area * 100;
                    channel_in_nonroad_area_score{chan_idx, nr_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];
                    
                end
                
            end

        catch

            disp('No side-of-road areas to score!')
            channel_in_nonroad_area_score = [];

        end


        %% Other road areas (cement driveways etc)
        
        try

            for road_idx = 1:length(Manual_Classfied_Areas.road_roi)

                % Grabs the polygon data
                xy_roi             = Manual_Classfied_Areas.road_roi{:,road_idx};

                % Grabs the indexes for all the points that lie in the polygon
                grav_in_other_road = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                asph_in_other_road = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                gras_in_other_road = sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                tot_in_area        = grav_in_other_road + asph_in_other_road + gras_in_other_road;

                % Score per area
                if tot_in_area ~= 0

                    channel_in_other_road_area_score{chan_idx, road_idx}.grav_score = grav_in_other_road / tot_in_area * 100;
                    channel_in_other_road_area_score{chan_idx, road_idx}.asph_score = asph_in_other_road / tot_in_area * 100;
                    channel_in_other_road_area_score{chan_idx, road_idx}.gras_score = gras_in_other_road / tot_in_area * 100;
                    channel_in_other_road_area_score{chan_idx, road_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];
                    
                end

            end

        catch

            disp('No other paved surface areas to score!')
            channel_in_other_road_area_score = [];

        end
        
    end
    
    %% For each area all channels
    
    [tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score] = tot_in_area_score(channel_in_grav_area_score, channel_in_asph_area_score, channel_in_nonroad_area_score, channel_in_other_road_area_score, used_chans, Manual_Classfied_Areas);
    
    
    %% For all areas all channels
    
    accuracy_table = all_area_acc(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score);
    
    
    %% Plotting all channels' scores and areas
    
    per_area_score_plot(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score, Manual_Classfied_Areas)

    
    
end