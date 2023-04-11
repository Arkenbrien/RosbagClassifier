function [tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score] = tot_in_area_score(channel_in_grav_area_score, channel_in_asph_area_score, channel_in_nonroad_area_score, channel_in_other_road_area_score, used_chans, Manual_Classfied_Areas)

    disp('Entered tot_in_area_score.m')
    
    %% Get Total Score / Area: Gravel
    
    try
        
        for grav_idx = 1:length(Manual_Classfied_Areas.grav)    
            
            % Var Init
            tot_grav_in_grav_score_tmp = [];
            tot_asph_in_grav_score_tmp = [];
            tot_gras_in_grav_score_tmp = [];
            
            for chan_idx = 1:length(used_chans)
                
                if ~isempty(channel_in_grav_area_score{chan_idx, grav_idx})
                    
                    % Get them scores
                    tot_grav_in_grav_score_tmp = [tot_grav_in_grav_score_tmp; channel_in_grav_area_score{chan_idx, grav_idx}.grav_score];
                    tot_asph_in_grav_score_tmp = [tot_asph_in_grav_score_tmp; channel_in_grav_area_score{chan_idx, grav_idx}.asph_score];
                    tot_gras_in_grav_score_tmp = [tot_gras_in_grav_score_tmp; channel_in_grav_area_score{chan_idx, grav_idx}.gras_score];
                    
                end
                
            end
            
            tot_in_grav_score{grav_idx}.tot_grav_in_grav_score  = mean(tot_grav_in_grav_score_tmp);
            tot_in_grav_score{grav_idx}.tot_asph_in_grav_score  = mean(tot_asph_in_grav_score_tmp);
            tot_in_grav_score{grav_idx}.tot_gras_in_grav_score  = mean(tot_gras_in_grav_score_tmp);
            tot_in_grav_score{grav_idx}.avg_loc                 = channel_in_grav_area_score{1, grav_idx}.avg_loc;
            
        end
        
    catch
        
        disp('Nothing in gravel areas!')
        tot_in_grav_score = [];

    end  
    
    %% Get Total Score / Area: Asphalt
    
    try
        
        for asph_idx = 1:length(Manual_Classfied_Areas.asph_roi)    
            
            % Var Init
            tot_grav_in_asph_score_tmp = [];
            tot_asph_in_asph_score_tmp = []; 
            tot_gras_in_asph_score_tmp = [];
            
            for chan_idx = 1:length(used_chans)
                
                % Get them scores
                if ~isempty(channel_in_asph_area_score{chan_idx, asph_idx})
                    
                    tot_grav_in_asph_score_tmp = [tot_grav_in_asph_score_tmp; channel_in_asph_area_score{chan_idx, asph_idx}.grav_score];
                    tot_asph_in_asph_score_tmp = [tot_asph_in_asph_score_tmp; channel_in_asph_area_score{chan_idx, asph_idx}.asph_score];
                    tot_gras_in_asph_score_tmp = [tot_gras_in_asph_score_tmp; channel_in_asph_area_score{chan_idx, asph_idx}.gras_score];
                
                end
                
            end
            
            tot_in_asph_score{asph_idx}.tot_grav_in_asph_score  = mean(tot_grav_in_asph_score_tmp);
            tot_in_asph_score{asph_idx}.tot_asph_in_asph_score  = mean(tot_asph_in_asph_score_tmp);
            tot_in_asph_score{asph_idx}.tot_gras_in_asph_score  = mean(tot_gras_in_asph_score_tmp);
            tot_in_asph_score{asph_idx}.avg_loc                 = channel_in_asph_area_score{1, asph_idx}.avg_loc;
            
        end
        
    catch
        
        disp('Nothing in Asphalt areas!')
        tot_in_asph_score = [];

    end
    
        %% Get Total Score / Area: Non-Road
    
    try
        
        for nr_idx = 1:length(Manual_Classfied_Areas.non_road_roi)    
            
            % Var Init
            tot_grav_in_nr_score_tmp = [];
            tot_asph_in_nr_score_tmp = []; 
            tot_gras_in_nr_score_tmp = [];
            
            for chan_idx = 1:length(used_chans)
                
                % Get them scores
                if ~isempty(channel_in_nonroad_area_score{chan_idx, nr_idx})

                    tot_grav_in_nr_score_tmp = [tot_grav_in_nr_score_tmp; channel_in_nonroad_area_score{chan_idx, nr_idx}.grav_score];
                    tot_asph_in_nr_score_tmp = [tot_asph_in_nr_score_tmp; channel_in_nonroad_area_score{chan_idx, nr_idx}.asph_score];
                    tot_gras_in_nr_score_tmp = [tot_gras_in_nr_score_tmp; channel_in_nonroad_area_score{chan_idx, nr_idx}.gras_score];

                end
                
            end
            
            tot_in_nr_score{nr_idx}.tot_grav_in_nr_score        = mean(tot_grav_in_nr_score_tmp);
            tot_in_nr_score{nr_idx}.tot_asph_in_nr_score        = mean(tot_asph_in_nr_score_tmp);
            tot_in_nr_score{nr_idx}.tot_gras_in_nr_score        = mean(tot_gras_in_nr_score_tmp);
            tot_in_nr_score{nr_idx}.avg_loc                     = channel_in_nonroad_area_score{1, nr_idx}.avg_loc;
            
        end
        
    catch
        
        disp('Nothing in Non-Road areas!')
        tot_in_nr_score = [];

    end
    
        %% Get Total Score / Area: Other-Road
    
    try
        
        for or_idx = 1:length(Manual_Classfied_Areas.road_roi)    
            
            % Var Init
            tot_grav_in_or_score_tmp = [];
            tot_asph_in_or_score_tmp = []; 
            tot_gras_in_or_score_tmp = [];
            
            for chan_idx = 1:length(used_chans)
                
                % Get them scores
                if ~isempty(channel_in_other_road_area_score{chan_idx, or_idx})
                    
                    tot_grav_in_or_score_tmp = [tot_grav_in_or_score_tmp; channel_in_other_road_area_score{chan_idx, or_idx}.grav_score];
                    tot_asph_in_or_score_tmp = [tot_asph_in_or_score_tmp; channel_in_other_road_area_score{chan_idx, or_idx}.asph_score];
                    tot_gras_in_or_score_tmp = [tot_gras_in_or_score_tmp; channel_in_other_road_area_score{chan_idx, or_idx}.gras_score];

                end
                
            end
            
            tot_in_or_score{or_idx}.tot_grav_in_or_score  = mean(tot_grav_in_or_score_tmp);
            tot_in_or_score{or_idx}.tot_asph_in_or_score  = mean(tot_asph_in_or_score_tmp);
            tot_in_or_score{or_idx}.tot_gras_in_or_score  = mean(tot_gras_in_or_score_tmp);
            tot_in_or_score{or_idx}.avg_loc               = channel_in_other_road_area_score{1, or_idx}.avg_loc;
            
        end
        
    catch
        
        disp('Nothing in Other-Road areas!')
        tot_in_or_score = [];

    end
    
    %% End Script
    
    disp('Completed tot_in_area_score.m')


end