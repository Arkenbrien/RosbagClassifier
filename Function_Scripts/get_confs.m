function options = get_confs(options)
    
    % Get Confidence Intervals
    if options.reference_point == "range" 

        % Channel 2 Gravel
        options.c2gravconflwbound       = 0.90;   
        options.c2gravconfupbound       = 1.00;

        % Channel 2 Unknown
        options.c2unknconflwbound       = 0.10;
        options.c2unknconfupbound       = 1.00;

        % Channel 2 Asphalt
        options.c2asphconflwbound       = 0.00;
        options.c2asphconfupbound       = 1.00;

        % Channel 3 Gravel
        options.c3gravconflwbound       = 0.95;
        options.c3gravconfupbound       = 1.00;

        % Channel 3 Unknown
        options.c3unknconflwbound       = 0.30;
        options.c3unknconfupbound       = 0.99;

        % Channel 3 Asph
        options.c3asphconflwbound       = 0.00;
        options.c3asphconfupbound       = 1.00;

        % Channel 4 Gravel
        options.c4gravconflwbound       = 0.90;
        options.c4gravconfupbound       = 1.00;

        % Channel 4 Unknown
        options.c4unknconflwbound       = 0.10;
        options.c4unknconfupbound       = 1.00;

        % Channel 4 Asph
        options.c4asphconflwbound       = 0.00;
        options.c4asphconfupbound       = 1.00;
        
        
        
    elseif options.reference_point == "mls" 
        
        % Channel 2 Gravel
        options.c2gravconflwbound       = 0.95;   
        options.c2gravconfupbound       = 1.00;

        % Channel 2 Unknown
        options.c2unknconflwbound       = 0.05;
        options.c2unknconfupbound       = 1.00;

        % Channel 2 Asphalt
        options.c2asphconflwbound       = 0.00;
        options.c2asphconfupbound       = 1.00;

        % Channel 3 Gravel
        options.c3gravconflwbound       = 0.99;
        options.c3gravconfupbound       = 1.00;

        % Channel 3 Unknown
        options.c3unknconflwbound       = 0.01;
        options.c3unknconfupbound       = 1.00;

        % Channel 3 Asph
        options.c3asphconflwbound       = 0.00;
        options.c3asphconfupbound       = 1.00;

        % Channel 4 Gravel
        options.c4gravconflwbound       = 0.80;
        options.c4gravconfupbound       = 1.00;

        % Channel 4 Unknown
        options.c4unknconflwbound       = 0.20;
        options.c4unknconfupbound       = 1.00;

        % Channel 4 Asph
        options.c4asphconflwbound       = 0.00;
        options.c4asphconfupbound       = 1.00;
        
    elseif options.reference_point == "ransac" 
        
        % Channel 2 Gravel
        options.c2gravconflwbound       = 0.45;   
        options.c2gravconfupbound       = 0.70;

        % Channel 2 Unknown
        options.c2unknconflwbound       = 0.00;
        options.c2unknconfupbound       = 0.55;

        % Channel 2 Asphalt
        options.c2asphconflwbound       = 0.00;
        options.c2asphconfupbound       = 1.00;

        % Channel 3 Gravel
        options.c3gravconflwbound       = 0.45;
        options.c3gravconfupbound       = 0.60;

        % Channel 3 Unknown
        options.c3unknconflwbound       = 0.40;
        options.c3unknconfupbound       = 0.50;

        % Channel 3 Asph
        options.c3asphconflwbound       = 0.00;
        options.c3asphconfupbound       = 1.00;

        % Channel 4 Gravel
        options.c4unknconflwbound       = 0.45;
        options.c4unknconfupbound       = 0.55;

        % Channel 4 Unknown
        options.c4gravconflwbound       = 0.40;
        options.c4gravconfupbound       = 0.50;

        % Channel 4 Asph
        options.c4asphconflwbound       = 0.00;
        options.c4asphconfupbound       = 1.00;      
        
    end
    
    
    
    
    
    
end