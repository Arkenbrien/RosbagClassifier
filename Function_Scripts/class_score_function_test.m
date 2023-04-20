function class_score_function_test(avg_cell_store, Manual_Classfied_Areas)

    disp('Entered class_score_function')

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
        Unkn_Avg_Array = avg_cell_store{used_chans(chan_idx)}.Unkn;
                
        
        %% Gravel
        
        if isfield(Manual_Classfied_Areas, 'grav')
            
            for grav_idx = 1:length(Manual_Classfied_Areas.grav)

                % Grabs the polygon data
                xy_roi              = Manual_Classfied_Areas.grav{:,grav_idx};

                % Grabs the indexes for all the points that lie in the polygon
                grav_in_grav        = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                asph_in_grav        = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
%                 gras_in_grav        = sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                unkn_in_grav        = sum(inpolygon(Unkn_Avg_Array(:,1), Unkn_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
%                 tot_in_area         = grav_in_grav + asph_in_grav + gras_in_grav;
                tot_in_area         = grav_in_grav + asph_in_grav + unkn_in_grav;
                
                if tot_in_area ~= 0 

                    % Score per area
                    channel_in_grav_area_score{chan_idx, grav_idx}.grav_in_grav = grav_in_grav;
                    channel_in_grav_area_score{chan_idx, grav_idx}.asph_in_grav = asph_in_grav;
%                     channel_in_grav_area_score{chan_idx, grav_idx}.gras_in_grav = gras_in_grav
                    channel_in_grav_area_score{chan_idx, grav_idx}.unkn_in_grav = unkn_in_grav;
                    channel_in_grav_area_score{chan_idx, grav_idx}.tot_in_area = tot_in_area;
                   
                    
                else
                    
                    disp('tot_in_area == 0!')
                
                end
                
                channel_in_grav_area_score{chan_idx, grav_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];
                
            end

        else

            disp('No gravel areas to score!')
            channel_in_grav_area_score = [];

        end

        
        %% Asphalt/pavement
        
        if isfield(Manual_Classfied_Areas, 'asph')

            for asph_idx = 1:length(Manual_Classfied_Areas.asph)
                                
                % Grabs the polygon data
                xy_roi              = Manual_Classfied_Areas.asph{:,asph_idx};

                % Grabs the indexes for all the points that lie in the polygon
                grav_in_asph        =  sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                asph_in_asph        =  sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
%                 gras_in_asph        =  sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                unkn_in_asph        =  sum(inpolygon(Unkn_Avg_Array(:,1), Unkn_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
%                 tot_in_area         = grav_in_asph + asph_in_asph + gras_in_asph;
                tot_in_area         = grav_in_asph + asph_in_asph + unkn_in_asph;

                % Score per area
                if tot_in_area ~= 0
                    
                    channel_in_asph_area_score{chan_idx, asph_idx}.grav_in_asph = grav_in_asph;
                    channel_in_asph_area_score{chan_idx, asph_idx}.asph_in_asph = asph_in_asph;
%                     channel_in_asph_area_score{chan_idx, asph_idx}.gras_in_asph = gras_in_asph;
                    channel_in_asph_area_score{chan_idx, asph_idx}.unkn_in_asph = unkn_in_asph;
                    channel_in_asph_area_score{chan_idx, asph_idx}.tot_in_area = tot_in_area;
                    
                    
                end
                
                channel_in_asph_area_score{chan_idx, asph_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];
                
            end

        else

            disp('No pavement areas to score!')
            channel_in_asph_area_score = [];

        end

        
        %% Non-Road (nr) == Side-Of-Road
        
        if isfield(Manual_Classfied_Areas, 'non_road')

            for nr_idx = 1:length(Manual_Classfied_Areas.non_road_roi)

                % Grabs the polygon data
                xy_roi              = Manual_Classfied_Areas.non_road_roi{:,nr_idx};

                % Grabs the indexes for all the points that lie in the polygon
                grav_in_nonroad     = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                asph_in_nonroad     = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
%                 gras_in_nonroad     = sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                unkn_in_nonroad     = sum(inpolygon(Unkn_Avg_Array(:,1), Unkn_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
%                 tot_in_area         = grav_in_nonroad + asph_in_nonroad + gras_in_nonroad;
                tot_in_area         = grav_in_nonroad + asph_in_nonroad + unkn_in_nonroad;

                % Score per area
                if tot_in_area ~= 0

                    channel_in_nonroad_area_score{chan_idx, nr_idx}.grav_in_nonroad = grav_in_nonroad;
                    channel_in_nonroad_area_score{chan_idx, nr_idx}.asph_in_nonroad = asph_in_nonroad;
%                     channel_in_nonroad_area_score{chan_idx, nr_idx}.gras_in_nonroad = gras_in_nonroad;
                    channel_in_nonroad_area_score{chan_idx, nr_idx}.unkn_in_nonroad = unkn_in_nonroad;
                    channel_in_nonroad_area_score{chan_idx, nr_idx}.tot_in_area = tot_in_area;
                    
                end
                
                channel_in_nonroad_area_score{chan_idx, nr_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];

            end

        else

            disp('No side-of-road areas to score!')
            channel_in_nonroad_area_score = [];

        end


        %% Other road areas (cement driveways etc)
        
        if isfield(Manual_Classfied_Areas, 'road')

            for road_idx = 1:length(Manual_Classfied_Areas.road)

                % Grabs the polygon data
                xy_roi             = Manual_Classfied_Areas.road_roi{:,road_idx};

                % Grabs the indexes for all the points that lie in the polygon
                grav_in_other_road = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                asph_in_other_road = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
%                 gras_in_other_road = sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                unkn_in_other_road = sum(inpolygon(Gras_Avg_Array(:,1), Gras_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
%                 tot_in_area        = grav_in_other_road + asph_in_other_road + gras_in_other_road;
                tot_in_area        = grav_in_other_road + asph_in_other_road + unkn_in_other_road;

                % Score per area
                if tot_in_area ~= 0

                    channel_in_other_road_area_score{chan_idx, road_idx}.grav_in_other_road = grav_in_other_road;
                    channel_in_other_road_area_score{chan_idx, road_idx}.asph_in_other_road = asph_in_other_road;
%                     channel_in_other_road_area_score{chan_idx, road_idx}.gras_in_other_road = gras_in_other_road;
                    channel_in_other_road_area_score{chan_idx, road_idx}.unkn_in_other_road = unkn_in_other_road;
                    channel_in_other_road_area_score{chan_idx, road_idx}.tot_in_area = tot_in_area;
                    
                end
                
                channel_in_other_road_area_score{chan_idx, road_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];

            end

        else

            disp('No other paved surface areas to score!')
            channel_in_other_road_area_score = [];

        end
        
    end
    
    %% For each area all channels
    
    [tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score] = tot_in_area_score_test(channel_in_grav_area_score, channel_in_asph_area_score, channel_in_nonroad_area_score, channel_in_other_road_area_score, used_chans, Manual_Classfied_Areas)
    
    
    %% For all areas all channels
    
    accuracy_table = all_area_acc(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score);
    
    
    %% Plotting all channels' scores and areas
    
    per_area_score_plot(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score, Manual_Classfied_Areas)

    
    %% End Script
    
    disp('End of class_score_function')
    
    
end