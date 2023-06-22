function export_train_vali_csv(chan_2c_feat_table, options, chan)

    %% Temp Var Init
    
    uniqueStrings = unique(chan_2c_feat_table.terrain_type);
    smallest_idx = 0;
    smallest_size = Inf;
    
    %% Seperating the data by terrain & 
    
    for idx = 1:numel(uniqueStrings)
        
        % What Terrain
        currentString = uniqueStrings{idx};
        
        % Select all by terrain
        filteredTable = chan_2c_feat_table(strcmp(chan_2c_feat_table.terrain_type, currentString), :);
        
        % Sending to larger variable
        tablesCellArray{idx} = filteredTable;
        
        % Getting the size of table
        table_size = size(filteredTable,1);
        
        if table_size < smallest_size
            
            smallest_size = table_size;
            smallest_idx = idx;
            
        end
            
    end
    
    max_num_to_grab     = smallest_size;
    to_train_tab        = int64(options.train_percent * max_num_to_grab);
    


    %% Save train/test data

    % Filenames
    asph_train_fn   = export_dir + "/asph_train_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
    gras_train_fn   = export_dir + "/gras_train_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
    grav_train_fn   = export_dir + "/grav_train_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";

    asph_test_fn    = export_dir + "/asph_test_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
    gras_test_fn    = export_dir + "/gras_test_chan_"   + string(side_select) + "_" + string(ring_search) + "_" + ".csv";
    grav_test_fn    = export_dir + "/grav_test_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";

    train_all_fn    = export_dir + "/train_all_chan_"   + string(side_select) + "_" + string(ring_search) + ".csv";
    test_all_fn     = export_dir + "/test_all_chan_"   + string(side_select) + "_" + string(ring_search) +".csv";

    % Save tables
    writetable(asph_train_table,asph_train_fn)
    writetable(gras_train_table,gras_train_fn)
    writetable(grav_train_table,grav_train_fn)

    writetable(asph_test_table,asph_test_fn)
    writetable(gras_test_table,gras_test_fn)
    writetable(grav_test_table,grav_test_fn)

    writetable(TRAIN_ALL_TABLE,train_all_fn)
    writetable(TEST_ALL_TABLE,test_all_fn)


end