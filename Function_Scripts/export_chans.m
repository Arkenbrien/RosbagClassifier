function export_chans(chan_2_c_table_export, chan_3_c_table_export, chan_4_c_table_export, terrain_opt)

    %% Var Init
    
    chan_2_table = table(); chan_3_table = table(); chan_4_table = table();
    
    fig_size_array  = [10 10 3500 1600];

    time_now        = datetime("now","Format","uuuummddhhMMss");
    time_now        = datestr(time_now,'yyyymmddhhMMss');
    
    if terrain_opt == 1
        leg = 'Grav from TD';
    elseif terrain_opt == 2
        leg = 'Chip from TD';
    elseif terrain_opt == 3
        leg = 'Foli from TD';
    elseif terrain_opt == 4
        leg = 'Gras from TD';
    elseif terrain_opt == 5
        leg = 'Asph from TD';
    elseif terrain_opt == 6
        leg = 'Asph2 from TD';
    end
    
    %% Save location
    
    xy_export_dir_2 = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump_c2/" + string(time_now);
    
    mkdir(xy_export_dir_2)
    addpath(xy_export_dir_2)
    
    xy_export_dir_3 = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump_c3/" + string(time_now);
    
    mkdir(xy_export_dir_3)
    addpath(xy_export_dir_3)
    
    xy_export_dir_4 = "/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Image_Dump_c4/" + string(time_now);
    
    mkdir(xy_export_dir_4)
    addpath(xy_export_dir_4)
    
    
    %% Load training data csv into workspace

    % asph_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Asph_Feat_Extract/Asph_Feat_Extract_1/raw_data_export_20235813120337_2.csv';
    % gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Gras_Feat_Extract/Gras_Feat_Extract_1/raw_data_export_20233811130352_2.csv';
    % grav_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Grav_Feat_Extract/Grav_Feat_Extract_1/raw_data_export_20230311130328_2.csv';
    % asph_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Asph_Feat_Extract/Asph_Feat_Extract_2/raw_data_export_20230514130316_2.csv';
    % gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Gras_Feat_Extract/Gras_Feat_Extract_2/raw_data_export_20232614130326_2.csv';
    % grav_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Grav_Feat_Extract/Grav_Feat_Extract_2/raw_data_export_20232414160313_gravel_1_2.csv';

    asph_file_chan2 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_2__Grav_Asph2_20233006110409/asph_2_train_chan2.csv';
    % gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Grass/gras_train_chan2_20235704140400.csv';
    grav_file_chan2 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_2__Grav_Asph2_20233006110409/grav_train_chan2.csv';
    % foli_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Foliage/foli_train_chan2_20235704140400.csv';

    asph_file_chan3 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_3__Grav_Asph_20234406100455/asph_2_train_chan3_20234406100455.csv';
    % gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Grass/gras_train_chan2_20235704140400.csv';
    grav_file_chan3 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_3__Grav_Asph_20234406100455/grav_train_chan3_20234406100455.csv';
    % foli_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Foliage/foli_train_chan2_20235704140400.csv';
    
    asph_file_chan4 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_4__Grav_Asph2_20232606110433/asph_2_train_chan4.csv';
    % gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Grass/gras_train_chan2_20235704140400.csv';
    grav_file_chan4 = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_4__Grav_Asph2_20232606110433/grav_train_chan4.csv';
    % foli_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Foliage/foli_train_chan2_20235704140400.csv';
    
    % Load csv into workspace
    % gras_data = ring_train_data_csv_import_w_cat(gras_file);
    grav_data_chan_2 = ring_train_data_csv_import_w_cat(grav_file_chan2);
    asph_data_chan_2 = ring_train_data_csv_import_w_cat(asph_file_chan2);
    % foli_data = ring_train_data_csv_import_w_cat(foli_file);
    % gras_data = ring_train_data_csv_import_w_cat(gras_file);
    grav_data_chan_3 = ring_train_data_csv_import_w_cat(grav_file_chan3);
    asph_data_chan_3 = ring_train_data_csv_import_w_cat(asph_file_chan3);
    % foli_data = ring_train_data_csv_import_w_cat(foli_file);
    % gras_data = ring_train_data_csv_import_w_cat(gras_file);
    grav_data_chan_4 = ring_train_data_csv_import_w_cat(grav_file_chan4);
    asph_data_chan_4 = ring_train_data_csv_import_w_cat(asph_file_chan4);
    % foli_data = ring_train_data_csv_import_w_cat(foli_file);
    
    % Get feat labels
    labels = grav_data_chan_2.Properties.VariableNames(1,1:end-1);

    % Convert table to array
    % gras_array = table2array(gras_data(:,1:end-1));
    grav_array_chan_2 = table2array(grav_data_chan_2(:,1:end-1));
    asph_array_chan_2 = table2array(asph_data_chan_2(:,1:end-1));
    % foli_array = table2array(foli_data(:,1:end-1));
    % gras_array = table2array(gras_data(:,1:end-1));
    grav_array_chan_3 = table2array(grav_data_chan_3(:,1:end-1));
    asph_array_chan_3 = table2array(asph_data_chan_3(:,1:end-1));
    % foli_array = table2array(foli_data(:,1:end-1));
    % gras_array = table2array(gras_data(:,1:end-1));
    grav_array_chan_4 = table2array(grav_data_chan_4(:,1:end-1));
    asph_array_chan_4 = table2array(asph_data_chan_4(:,1:end-1));
    % foli_array = table2array(foli_data(:,1:end-1));
    
    %% Load the stuff from the classification
    
    % chan_2
    for c2_idx = 1:length(chan_2_c_table_export)
        
        if ~isempty(chan_2_c_table_export{c2_idx})
            
            chan_2_table = [chan_2_table; chan_2_c_table_export{c2_idx}];
            
        end
        
    end
    
    % Convert from table to array
    chan_2_array = table2array(chan_2_table);
    
    % chan_3
    for c3_idx = 1:length(chan_3_c_table_export)
        
        if ~isempty(chan_3_c_table_export{c3_idx})
            
            chan_3_table = [chan_3_table; chan_3_c_table_export{c3_idx}];
            
        end
        
    end
    
    % Convert from table to array
    chan_3_array = table2array(chan_3_table);
    
    % chan_4
    for c4_idx = 1:length(chan_4_c_table_export)
        
        if ~isempty(chan_4_c_table_export{c4_idx})
            
            chan_4_table = [chan_4_table; chan_4_c_table_export{c4_idx}];
            
        end
        
    end
    
    % Convert from table to array
    chan_4_array = table2array(chan_4_table);
        
    
    %% Plot the data - xy chart

    parfor x_axis_idx = 1:length(labels)
%         
%         dat_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
%         h1 = histogram(asph_array_chan_2(:,x_axis_idx));
%         hold on
%         h2 = histogram(chan_2_array(:,x_axis_idx));
%         hold off
%         % Save image
%         filename = xy_export_dir_2 + "/chan_2_" + string(labels(x_axis_idx)) + "_" + string(labels(y_axis_idx)) + ".png";
%         saveas(dat_fig, filename);
%         
        
        for y_axis_idx = 1:1:length(labels)

            if x_axis_idx ~= y_axis_idx

                % Do something
                dat_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
                scatter(chan_2_array(:,x_axis_idx), chan_2_array(:,y_axis_idx), 100, 'co', 'Linewidth', 10)
                hold on
                scatter(asph_array_chan_2(:,x_axis_idx), asph_array_chan_2(:,y_axis_idx), 50, 'k*', 'Linewidth', 10)
                hold on
                scatter(grav_array_chan_2(:,x_axis_idx), grav_array_chan_2(:,y_axis_idx), 50, 'm*')
                hold off
                xlabel(string(labels(x_axis_idx)))
                ylabel(string(labels(y_axis_idx)))
                legend({string(leg), 'Asph TD', 'Grav TD'})

                % Save image
                filename = xy_export_dir_2 + "/chan_2_" + string(labels(x_axis_idx)) + "_" + string(labels(y_axis_idx)) + ".png";
                saveas(dat_fig, filename);

            end

        end

    end
    
    disp('Channel 2 complete!')
    
     parfor x_axis_idx = 1:length(labels)

        for y_axis_idx = 1:1:length(labels)

            if x_axis_idx ~= y_axis_idx

                % Do something
                dat_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
                scatter(chan_3_array(:,x_axis_idx), chan_3_array(:,y_axis_idx), 100, 'co', 'Linewidth', 10)
                hold on
                scatter(asph_array_chan_3(:,x_axis_idx), asph_array_chan_3(:,y_axis_idx), 50, 'k*', 'Linewidth', 10)
                hold on
                scatter(grav_array_chan_3(:,x_axis_idx), grav_array_chan_3(:,y_axis_idx), 50, 'm*')
                hold off
                xlabel(string(labels(x_axis_idx)))
                ylabel(string(labels(y_axis_idx)))
                legend({string(leg), 'Asph TD', 'Grav TD'})

                % Save image
                filename = xy_export_dir_3 + "/chan_3_" + string(labels(x_axis_idx)) + "_" + string(labels(y_axis_idx)) + ".png";
                saveas(dat_fig, filename);

            end

        end

     end
    
     disp('Channel 3 complete!')
     
      parfor x_axis_idx = 1:length(labels)

        for y_axis_idx = 1:1:length(labels)

            if x_axis_idx ~= y_axis_idx

                % Do something
                dat_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
                scatter(chan_4_array(:,x_axis_idx), chan_4_array(:,y_axis_idx), 100, 'co', 'Linewidth', 10)
                hold on
                scatter(asph_array_chan_4(:,x_axis_idx), asph_array_chan_4(:,y_axis_idx), 50, 'k*', 'Linewidth', 10)
                hold on
                scatter(grav_array_chan_4(:,x_axis_idx), grav_array_chan_4(:,y_axis_idx), 50, 'm*')
                hold off
                xlabel(string(labels(x_axis_idx)))
                ylabel(string(labels(y_axis_idx)))
                legend({string(leg), 'Asph TD', 'Grav TD'})

                % Save image
                filename = xy_export_dir_4 + "/chan_4_" + string(labels(x_axis_idx)) + "_" + string(labels(y_axis_idx)) + ".png";
                saveas(dat_fig, filename);

            end

        end

      end
    
      disp('Channel 4 complete!')
    
end