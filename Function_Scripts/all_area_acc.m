function accuracy_table = all_area_acc(tot_in_grav_score, tot_in_asph_score, tot_in_nr_score, tot_in_or_score)

    disp('Entered accuracy_table.m')
    
    %% Var Init
    
    acc_array = zeros(2,2);
    
    % Re-set vars
    temp_asph_acc = [];
    temp_unkn_acc = [];
    temp_grav_acc = [];
    
    %% Asphalt Area
    
    for asph_area_idx = 1:length(tot_in_asph_score)
        
        temp_asph_acc = [temp_asph_acc; tot_in_asph_score{asph_area_idx}.tot_asph_in_asph_score];
        temp_unkn_acc = [temp_unkn_acc; tot_in_asph_score{asph_area_idx}.tot_unkn_in_asph_score];
        temp_grav_acc = [temp_grav_acc; tot_in_asph_score{asph_area_idx}.tot_grav_in_asph_score];
        
    end
    
    % Send to array
    acc_array(1,1) = mean(temp_asph_acc);
    acc_array(2,1) = mean(temp_grav_acc);
    acc_array(3,1) = mean(temp_unkn_acc);
%     
    % Send to array
%     acc_array(1,1) = mean(temp_asph_acc);
% %     acc_array(2,1) = mean(temp_gras_acc);
%     acc_array(2,1) = mean(temp_grav_acc);
%     
    
    % Re-set vars
    temp_asph_acc = [];
    temp_unkn_acc = [];
    temp_grav_acc = [];
    

    
    %% Gravel area
    
    for grav_area_idx = 1:length(tot_in_grav_score)
        
        temp_asph_acc = [temp_asph_acc; tot_in_grav_score{grav_area_idx}.tot_asph_in_grav_score];
        temp_unkn_acc = [temp_unkn_acc; tot_in_grav_score{grav_area_idx}.tot_unkn_in_grav_score];
        temp_grav_acc = [temp_grav_acc; tot_in_grav_score{grav_area_idx}.tot_grav_in_grav_score];
        
    end
    
    % Send to array
    acc_array(1,2) = mean(temp_asph_acc);
    acc_array(2,2) = mean(temp_grav_acc);
    acc_array(3,2) = mean(temp_unkn_acc);
% 
%     acc_array(1,2) = mean(temp_asph_acc);
%     acc_array(2,2) = mean(temp_unkn_acc);
%     acc_array(2,2) = mean(temp_grav_acc);

    
    % Re-set vars
    temp_asph_acc = [];
    temp_unkn_acc = [];
    temp_grav_acc = [];
    
        
    %% Non-Road Area
    
    for unkn_area_idx = 1:length(tot_in_nr_score)
        
        temp_asph_acc = [temp_asph_acc; tot_in_nr_score{unkn_area_idx}.tot_asph_in_nr_score];
        temp_unkn_acc = [temp_unkn_acc; tot_in_nr_score{unkn_area_idx}.tot_unkn_in_nr_score];
        temp_grav_acc = [temp_grav_acc; tot_in_nr_score{unkn_area_idx}.tot_grav_in_nr_score];
        
    end
        
    % Send to array
    acc_array(1,3) = mean(temp_asph_acc);
    acc_array(2,3) = mean(temp_grav_acc);
    acc_array(3,3) = mean(temp_unkn_acc);
    
    % Re-set vars
    temp_asph_acc = [];
    temp_gras_acc = [];
    temp_grav_acc = [];
    
    
    %% Convert to Acc Table
    
    header_Top = {'Asphalt', 'Gravel', 'Unknown'};
    header_Row = {'Asphalt', 'Gravel', 'Unknown'};
    accuracy_table = array2table(acc_array, 'VariableNames', header_Top, 'RowNames', header_Row)
    
    assignin('base', 'accuracy_table', accuracy_table)
    
    %% End Script
    
    disp('Completed accuracy_table.m')

end