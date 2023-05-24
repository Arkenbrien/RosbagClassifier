function time_out = get_classify_fun_time(classify_fun)

    %% VAR INIT
    
    % Temp Debug: COMMENT OUT!!!
%     classify_fun = classify_fun_out_2c;
    
    % Init Time Out Var
    time_out = zeros(length(classify_fun),1);
    
    
    %% Grab Time Data
    
    % Do Something
    for idx = 1:1:length(classify_fun)
        
        time_out(idx,1) = classify_fun{idx}.classify_time;
        
    end
    
    
    
    
    
    
    
    
    
    
end