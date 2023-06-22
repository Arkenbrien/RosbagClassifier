function [All_Arrays, Avg_Arrays] = get_classified_arrays(channel_2_fun_out,... 
                                                          channel_3_fun_out,... 
                                                          channel_4_fun_out)
                                                
                                                      
    disp('Loading Files...')

    load_result_bar = waitbar(0, "Loading Files...");
    
    %% VAR INIT

    % Chan 2
    Grav_All_Append_Array_2   = []; Asph_All_Append_Array_2 = []; Foli_All_Append_Array_2 = []; Gras_All_Append_Array_2 = [];
    Grav_Avg_Append_Array_2   = []; Asph_Avg_Append_Array_2 = []; Foli_Avg_Append_Array_2 = []; Gras_Avg_Append_Array_2 = [];
    Unkn_All_Append_Array_2   = [];
    Unkn_Avg_Append_Array_2   = [];

    % Chan 3
    Grav_All_Append_Array_3   = []; Asph_All_Append_Array_3 = []; Foli_All_Append_Array_3 = []; Gras_All_Append_Array_3 = [];
    Grav_Avg_Append_Array_3   = []; Asph_Avg_Append_Array_3 = []; Foli_Avg_Append_Array_3 = []; Gras_Avg_Append_Array_3 = [];
    Unkn_All_Append_Array_3   = [];
    Unkn_Avg_Append_Array_3   = [];

    % Chan 4
    Grav_All_Append_Array_4   = []; Asph_All_Append_Array_4 = []; Foli_All_Append_Array_4 = []; Gras_All_Append_Array_4 = [];
    Grav_Avg_Append_Array_4   = []; Asph_Avg_Append_Array_4 = []; Foli_Avg_Append_Array_4 = []; Gras_Avg_Append_Array_4 = [];
    Unkn_All_Append_Array_4   = [];
    Unkn_Avg_Append_Array_4   = [];

    % Chan 5
    Grav_All_Append_Array_5   = []; Asph_All_Append_Array_5 = []; Foli_All_Append_Array_5 = []; Gras_All_Append_Array_5 = [];
    Grav_Avg_Append_Array_5   = []; Asph_Avg_Append_Array_5 = []; Foli_Avg_Append_Array_5 = []; Gras_Avg_Append_Array_5 = [];
    Unkn_All_Append_Array_5   = [];
    Unkn_Avg_Append_Array_5   = [];
    
    % weight bar thing
    num_chans = 3;
    
    
    %% Getting the arrays
    
    for idx2 = 1:length(channel_2_fun_out)
        
        xyzi = channel_2_fun_out{idx2}.points;
        avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), channel_2_fun_out{idx2}.scores];
        
        % Channel 2
        if isequal(channel_2_fun_out{idx2}.Yfit, 'gravel')
            Grav_All_Append_Array_2             = [Grav_All_Append_Array_2; xyzi];
            Grav_Avg_Append_Array_2             = [Grav_Avg_Append_Array_2; avg_xyzi];
        end

        if isequal(channel_2_fun_out{idx2}.Yfit, 'asphalt')
            Asph_All_Append_Array_2             = [Asph_All_Append_Array_2; xyzi];
            Asph_Avg_Append_Array_2             = [Asph_Avg_Append_Array_2; avg_xyzi];
        end
        
        if isequal(channel_2_fun_out{idx2}.Yfit, 'unknown')
            Unkn_All_Append_Array_2             = [Unkn_All_Append_Array_2; xyzi];
            Unkn_Avg_Append_Array_2             = [Unkn_Avg_Append_Array_2; avg_xyzi];
        end
        
    end
    
    waitbar(1/num_chans, load_result_bar, sprintf('Channel %d out of %d', 1, num_chans))
    
    for idx3 = 1:length(channel_3_fun_out)
        
        xyzi = channel_3_fun_out{idx3}.points;
        avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), channel_3_fun_out{idx2}.scores];
        
        % Channel 3
        if isequal(channel_3_fun_out{idx3}.Yfit, 'gravel')
            Grav_All_Append_Array_3             = [Grav_All_Append_Array_3; xyzi];
            Grav_Avg_Append_Array_3             = [Grav_Avg_Append_Array_3; avg_xyzi];
        end

        if isequal(channel_3_fun_out{idx3}.Yfit, 'asphalt')
            Asph_All_Append_Array_3             = [Asph_All_Append_Array_3; xyzi];
            Asph_Avg_Append_Array_3             = [Asph_Avg_Append_Array_3; avg_xyzi];
        end
        
        if isequal(channel_3_fun_out{idx3}.Yfit, 'unknown')
            Unkn_All_Append_Array_3             = [Unkn_All_Append_Array_3; xyzi];
            Unkn_Avg_Append_Array_3             = [Unkn_Avg_Append_Array_3; avg_xyzi];
        end
        
    end
    
    waitbar(2/num_chans, load_result_bar, sprintf('Channel %d out of %d', 2, num_chans))
    
    for idx4 = 1:length(channel_4_fun_out)
        
        xyzi = channel_4_fun_out{idx4}.points;
        avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), channel_4_fun_out{idx2}.scores];
        
        % Channel 4
        if isequal(channel_4_fun_out{idx4}.Yfit, 'gravel')
            Grav_All_Append_Array_4             = [Grav_All_Append_Array_4; xyzi];
            Grav_Avg_Append_Array_4             = [Grav_Avg_Append_Array_4; avg_xyzi];
        end

        if isequal(channel_4_fun_out{idx4}.Yfit, 'asphalt')
            Asph_All_Append_Array_4             = [Asph_All_Append_Array_4; xyzi];
            Asph_Avg_Append_Array_4             = [Asph_Avg_Append_Array_4; avg_xyzi];
        end
        
        if isequal(channel_4_fun_out{idx4}.Yfit, 'unknown')
            Unkn_All_Append_Array_4             = [Unkn_All_Append_Array_4; xyzi];
            Unkn_Avg_Append_Array_4             = [Unkn_Avg_Append_Array_4; avg_xyzi];
        end
        
    end
    
    waitbar(3/num_chans, load_result_bar, sprintf('Channel %d out of %d', 3, num_chans))
    
    
    %% Getting the outputs
    
    All_Arrays.grav2 = Grav_All_Append_Array_2;
    All_Arrays.asph2 = Asph_All_Append_Array_2;
    All_Arrays.unkn2 = Unkn_All_Append_Array_2;
    All_Arrays.grav3 = Grav_All_Append_Array_3;
    All_Arrays.asph3 = Asph_All_Append_Array_3;
    All_Arrays.unkn3 = Unkn_All_Append_Array_3;
    All_Arrays.grav4 = Grav_All_Append_Array_4;
    All_Arrays.asph4 = Asph_All_Append_Array_4;
    All_Arrays.unkn4 = Unkn_All_Append_Array_4;
    
    Avg_Arrays.grav2 = Grav_Avg_Append_Array_2;
    Avg_Arrays.asph2 = Asph_Avg_Append_Array_2;
    Avg_Arrays.unkn2 = Unkn_Avg_Append_Array_2;
    Avg_Arrays.grav3 = Grav_Avg_Append_Array_3;
    Avg_Arrays.asph3 = Asph_Avg_Append_Array_3;
    Avg_Arrays.unkn3 = Unkn_Avg_Append_Array_3;
    Avg_Arrays.grav4 = Grav_Avg_Append_Array_4;
    Avg_Arrays.asph4 = Asph_Avg_Append_Array_4;
    Avg_Arrays.unkn4 = Unkn_Avg_Append_Array_4;
    
    
    %% Weight Bar
    
    close(load_result_bar)

    disp('Files loaded!')
    
    
end