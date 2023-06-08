function [tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_sr_score] = tot_in_area_score_test(channel_in_grav_area_score, channel_in_asph_area_score, channel_in_nonroad_area_score, channel_in_side_road_area_score, used_chans, Manual_Classfied_Areas)

    disp('Entered tot_in_area_score.m')
    
    %% Get Total Score / Area: Gravel
    
    if isfield(Manual_Classfied_Areas, 'grav')        
        
        for grav_idx = 1:length(Manual_Classfied_Areas.grav)    
            
            %% Var Init
            tot_num_counter = 0;
            tot_num_grav = 0; tot_num_unkn = 0; tot_num_asph = 0;
            
            for chan_idx = 1:length(used_chans)
                
%                 if ~isempty(channel_in_grav_area_score{chan_idx, grav_idx})
                if isfield(channel_in_grav_area_score{chan_idx, grav_idx}, 'grav_in_grav')
                    
                    tot_num_counter = tot_num_counter + channel_in_grav_area_score{chan_idx, grav_idx}.tot_in_area;
                    tot_num_grav = tot_num_grav + channel_in_grav_area_score{chan_idx, grav_idx}.grav_in_grav;
                    tot_num_unkn = tot_num_unkn + channel_in_grav_area_score{chan_idx, grav_idx}.unkn_in_grav;
                    tot_num_asph = tot_num_asph + channel_in_grav_area_score{chan_idx, grav_idx}.asph_in_grav;
                    
                end
                
            end
            
            tot_in_grav_score{grav_idx}.tot_grav_in_grav_score  = tot_num_grav / tot_num_counter * 100;
            tot_in_grav_score{grav_idx}.tot_asph_in_grav_score  = tot_num_asph / tot_num_counter * 100;
            tot_in_grav_score{grav_idx}.tot_unkn_in_grav_score  = tot_num_unkn / tot_num_counter * 100;
            tot_in_grav_score{grav_idx}.avg_loc                 = channel_in_grav_area_score{1, grav_idx}.avg_loc;
            
        end
        
    else
        
        disp('Nothing in gravel areas!')
        tot_in_grav_score = [];

    end  
    
    %% Get Total Score / Area: Asphalt
    
    if isfield(Manual_Classfied_Areas, 'asph')
        
        for asph_idx = 1:length(Manual_Classfied_Areas.asph)    
            
            % Var Init
            tot_num_counter = 0;
            tot_num_grav = 0; tot_num_unkn = 0; tot_num_asph = 0;
            
            for chan_idx = 1:length(used_chans)
                
                % Get them scores
%                 if ~isempty(channel_in_asph_area_score{chan_idx, asph_idx})
                if isfield(channel_in_asph_area_score{chan_idx, asph_idx}, 'asph_in_asph')
                    
                    tot_num_counter = tot_num_counter + channel_in_asph_area_score{chan_idx, asph_idx}.tot_in_area;
                    tot_num_grav = tot_num_grav + channel_in_asph_area_score{chan_idx, asph_idx}.grav_in_asph;
                    tot_num_unkn = tot_num_unkn + channel_in_asph_area_score{chan_idx, asph_idx}.unkn_in_asph;
                    tot_num_asph = tot_num_asph + channel_in_asph_area_score{chan_idx, asph_idx}.asph_in_asph;
                
                end
                
            end
            
            tot_in_asph_score{asph_idx}.tot_grav_in_asph_score  = tot_num_grav / tot_num_counter * 100;
            tot_in_asph_score{asph_idx}.tot_asph_in_asph_score  = tot_num_asph / tot_num_counter * 100;
            tot_in_asph_score{asph_idx}.tot_unkn_in_asph_score  = tot_num_unkn / tot_num_counter * 100;
            tot_in_asph_score{asph_idx}.avg_loc                 = channel_in_asph_area_score{1, asph_idx}.avg_loc;
            
        end
        
    else
        
        disp('Nothing in Asphalt areas!')
        tot_in_asph_score = [];

    end
    
    %% Get Total Score / Area: Non-Road
    
    if isfield(Manual_Classfied_Areas, 'non_road')
        
        for nr_idx = 1:length(Manual_Classfied_Areas.non_road)    
            
            % Var Init
            tot_num_counter = 0;
            tot_num_grav = 0; tot_num_unkn = 0; tot_num_asph = 0;
            
            for chan_idx = 1:length(used_chans)
                
                % Get them scores
                if isfield(channel_in_nonroad_area_score{chan_idx, nr_idx}, 'tot_in_area')
                    
                    tot_num_counter = tot_num_counter + channel_in_nonroad_area_score{chan_idx, nr_idx}.tot_in_area;
                    tot_num_grav = tot_num_grav + channel_in_nonroad_area_score{chan_idx, nr_idx}.grav_in_nonroad;
                    tot_num_unkn = tot_num_unkn + channel_in_nonroad_area_score{chan_idx, nr_idx}.unkn_in_nonroad;
                    tot_num_asph = tot_num_asph + channel_in_nonroad_area_score{chan_idx, nr_idx}.asph_in_nonroad;
                    
                end
                
            end
            
            tot_in_nr_score{nr_idx}.tot_grav_in_nr_score  = tot_num_grav / tot_num_counter * 100;
            tot_in_nr_score{nr_idx}.tot_asph_in_nr_score  = tot_num_asph / tot_num_counter * 100;
            tot_in_nr_score{nr_idx}.tot_unkn_in_nr_score  = tot_num_unkn / tot_num_counter * 100;
            tot_in_nr_score{nr_idx}.avg_loc                     = channel_in_nonroad_area_score{1, nr_idx}.avg_loc;
            
        end
        
    else
        
        disp('Nothing in Non-Road areas!')
        tot_in_nr_score = [];

    end
    
    %% Get Total Score / Area: Side of Road
    
    if isfield(Manual_Classfied_Areas, 'side_road')
        
        for sr_idx = 1:length(Manual_Classfied_Areas.side_road)    
            
            % Var Init
            tot_num_counter = 0;
            tot_num_grav = 0; tot_num_unkn = 0; tot_num_asph = 0;
            
            for chan_idx = 1:length(used_chans)
                
                % Get them scores
                if isfield(channel_in_side_road_area_score{chan_idx, sr_idx}, 'tot_in_area')
                    
                    tot_num_counter = tot_num_counter + channel_in_side_road_area_score{chan_idx, sr_idx}.tot_in_area;
                    tot_num_grav = tot_num_grav + channel_in_side_road_area_score{chan_idx, sr_idx}.grav_in_side_road;
                    tot_num_unkn = tot_num_unkn + channel_in_side_road_area_score{chan_idx, sr_idx}.unkn_in_side_road;
                    tot_num_asph = tot_num_asph + channel_in_side_road_area_score{chan_idx, sr_idx}.asph_in_side_road;

                end
                
            end
            
            tot_in_sr_score{sr_idx}.tot_grav_in_sr_score  = tot_num_grav / tot_num_counter * 100;
            tot_in_sr_score{sr_idx}.tot_asph_in_sr_score  = tot_num_asph / tot_num_counter * 100;
            tot_in_sr_score{sr_idx}.tot_unkn_in_sr_score  = tot_num_unkn / tot_num_counter * 100;
            tot_in_sr_score{sr_idx}.avg_loc               = channel_in_side_road_area_score{1, sr_idx}.avg_loc;
            
        end
        
    else
        
        disp('Nothing in Non-Road areas!')
        tot_in_sr_score = [];

    end
    
    %% Get Total Score / Area: Other-Road

%     tot_in_or_score = [];

        
    %% End Script
    
    disp('Completed tot_in_area_score.m')


end