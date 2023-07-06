function class_score_function_test(Avg_Arrays, Manual_Classfied_Areas, options)

    disp('Entered class_score_function')

    %% Options
    
    
    %% Var Init
    
    avg_cell_store{2}.Grav = Avg_Arrays.grav2;
    avg_cell_store{2}.Asph = Avg_Arrays.asph2;
    avg_cell_store{2}.Unkn = Avg_Arrays.unkn2;

    avg_cell_store{3}.Grav = Avg_Arrays.grav3;
    avg_cell_store{3}.Asph = Avg_Arrays.asph3;
    avg_cell_store{3}.Unkn = Avg_Arrays.unkn3;

    avg_cell_store{4}.Grav = Avg_Arrays.grav4;
    avg_cell_store{4}.Asph = Avg_Arrays.asph4;
    avg_cell_store{4}.Unkn = Avg_Arrays.unkn4;
    
    % Get index of non-empty cells
    used_chans = find(~cellfun(@isempty,avg_cell_store));
    
    % Getting the z max height so that the projected areas are above the point cloud 
    z_max_lim = max([Avg_Arrays.grav2(:,3); Avg_Arrays.asph2(:,3); Avg_Arrays.unkn2(:,3)]) + 5;
    options.max_h = z_max_lim;
    
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
                if ~isempty(Grav_Avg_Array)
                    grav_in_grav        = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    grav_in_grav = 0;
                end
                
                if ~isempty(Asph_Avg_Array)
                    asph_in_grav        = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    asph_in_grav = 0;
                end
                
                if ~isempty(Unkn_Avg_Array)
                    unkn_in_grav        = sum(inpolygon(Unkn_Avg_Array(:,1), Unkn_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    unkn_in_grav = 0;
                end
                
                tot_in_area         = grav_in_grav + asph_in_grav + unkn_in_grav;
                
                if tot_in_area ~= 0 

                    % Score per area
                    channel_in_grav_area_score{chan_idx, grav_idx}.grav_in_grav = grav_in_grav;
                    channel_in_grav_area_score{chan_idx, grav_idx}.asph_in_grav = asph_in_grav;
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
                if ~isempty(Grav_Avg_Array)
                    grav_in_asph        =  sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    grav_in_asph = 0;
                end
                
                if ~isempty(Asph_Avg_Array)
                    asph_in_asph        =  sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    asph_in_asph = 0;
                end
                
                if ~isempty(Unkn_Avg_Array)
                    unkn_in_asph        =  sum(inpolygon(Unkn_Avg_Array(:,1), Unkn_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    unkn_in_asph = 0;
                end
                
%                 tot_in_area         = grav_in_asph + asph_in_asph + gras_in_asph;
                tot_in_area         = grav_in_asph + asph_in_asph + unkn_in_asph;

                % Score per area
                if tot_in_area ~= 0
                    
                    channel_in_asph_area_score{chan_idx, asph_idx}.grav_in_asph = grav_in_asph;
                    channel_in_asph_area_score{chan_idx, asph_idx}.asph_in_asph = asph_in_asph;
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

            for nr_idx = 1:length(Manual_Classfied_Areas.non_road)

                % Grabs the polygon data
                xy_roi              = Manual_Classfied_Areas.non_road{:,nr_idx};

                % Grabs the indexes for all the points that lie in the polygon
                if ~isempty(Grav_Avg_Array)
                    grav_in_nonroad     = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    grav_in_nonroad = 0;
                end
                
                if ~isempty(Asph_Avg_Array)
                    asph_in_nonroad     = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    asph_in_nonroad = 0;
                end
                
                if ~isempty(Unkn_Avg_Array)
                    unkn_in_nonroad     = sum(inpolygon(Unkn_Avg_Array(:,1), Unkn_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    unkn_in_nonroad = 0;
                end
                
%                 tot_in_area         = grav_in_nonroad + asph_in_nonroad + gras_in_nonroad;
                tot_in_area         = grav_in_nonroad + asph_in_nonroad + unkn_in_nonroad;

                % Score per area
                if tot_in_area ~= 0
                    
                    channel_in_nonroad_area_score{chan_idx, nr_idx}.grav_in_nonroad = grav_in_nonroad;
                    channel_in_nonroad_area_score{chan_idx, nr_idx}.asph_in_nonroad = asph_in_nonroad;
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
        
        if isfield(Manual_Classfied_Areas, 'side_road')

            for side_road_idx = 1:length(Manual_Classfied_Areas.side_road)

                % Grabs the polygon data
                xy_roi             = Manual_Classfied_Areas.side_road{:,side_road_idx};

                % Grabs the indexes for all the points that lie in the polygon
                if ~isempty(Grav_Avg_Array)
                    grav_in_side_road = sum(inpolygon(Grav_Avg_Array(:,1), Grav_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    grav_in_side_road = 0;
                end
                
                if ~isempty(Asph_Avg_Array)
                    asph_in_side_road = sum(inpolygon(Asph_Avg_Array(:,1), Asph_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    asph_in_side_road = 0;
                end
                
                if ~isempty(Unkn_Avg_Array)
                    unkn_in_side_road = sum(inpolygon(Unkn_Avg_Array(:,1), Unkn_Avg_Array(:,2), xy_roi(:,1), xy_roi(:,2)));
                else
                    unkn_in_side_road = 0;
                end
                
                tot_in_area        = grav_in_side_road + asph_in_side_road + unkn_in_side_road;

                % Score per area
                if tot_in_area ~= 0

                    channel_in_side_road_area_score{chan_idx, side_road_idx}.grav_in_side_road = grav_in_side_road;
                    channel_in_side_road_area_score{chan_idx, side_road_idx}.asph_in_side_road = asph_in_side_road;
                    channel_in_side_road_area_score{chan_idx, side_road_idx}.unkn_in_side_road = unkn_in_side_road;
                    channel_in_side_road_area_score{chan_idx, side_road_idx}.tot_in_area = tot_in_area;
                    
                end
                
                channel_in_side_road_area_score{chan_idx, side_road_idx}.avg_loc    = [mean(xy_roi(:,1)) mean(xy_roi(:,2))];

            end

        else

            disp('No other paved surface areas to score!')
            channel_in_side_road_area_score = [];

        end
        
    end
    
    %% For each area all channels
    
    [tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_sr_score] = tot_in_area_score_test(channel_in_grav_area_score, channel_in_asph_area_score, channel_in_nonroad_area_score, channel_in_side_road_area_score, used_chans, Manual_Classfied_Areas);
    
    
    %% For all areas all channels
    
    accuracy_table = all_area_acc(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_sr_score);
    
    
    %% Plotting all channels' scores and areas
    
    per_area_score_plot(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_sr_score, Manual_Classfied_Areas, options);

    
    %% End Script
    
    disp('End of class_score_function')
    
    
end