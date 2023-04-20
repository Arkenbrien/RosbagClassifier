%% Clear workspace

clear all
close all
clc

%% Options

export_dir = uigetdir('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export', 'Grab/make image export location');
xy_export_dir = export_dir + "/xy_images";
hist_export_dir = export_dir + "/hist_images";
import_export_dir = export_dir + "/feat_import_images";

mkdir(xy_export_dir)
mkdir(hist_export_dir)
mkdir(import_export_dir)

addpath(xy_export_dir)
addpath(hist_export_dir)
addpath(import_export_dir)

%% Var Init

fig_size_array  = [10 10 3500 1600];

time_now        = datetime("now","Format","uuuuMMddhhmmss");
time_now        = datestr(time_now,'yyyyMMddhhmmss');

%% Load data

% Ask user for file
% gras_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Gras_Feat_Extract/Grav_Feat_Extract_1/*.csv', 'Get GRASS data');
% grav_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Grav_Feat_Extract/Gras_Feat_Extract_1/*.csv', 'Get GRAVEL data');
% asph_file = uigetfile('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Asph_Feat_Extract/Asph_Feat_Extract_1/*.csv', 'Get ASPHALT data');

%% Load csv into workspace

% asph_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Asph_Feat_Extract/Asph_Feat_Extract_1/raw_data_export_20235813120337_2.csv';
% gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Gras_Feat_Extract/Gras_Feat_Extract_1/raw_data_export_20233811130352_2.csv';
% grav_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Grav_Feat_Extract/Grav_Feat_Extract_1/raw_data_export_20230311130328_2.csv';
% asph_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Asph_Feat_Extract/Asph_Feat_Extract_2/raw_data_export_20230514130316_2.csv';
% gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Gras_Feat_Extract/Gras_Feat_Extract_2/raw_data_export_20232614130326_2.csv';
% grav_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Grav_Feat_Extract/Grav_Feat_Extract_2/raw_data_export_20232414160313_gravel_1_2.csv';

% asph_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_2__Grav_Asph_Asph2_20233007100408/asph_2_train_chan2.csv';
% gras_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Grass/gras_train_chan2_20235704140400.csv';
% grav_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_2__Grav_Asph_Asph2_20233007100408/grav_train_chan2.csv';
% foli_file = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/02_RDF_Training_Data_Extraction_Result_Handler_Export/Range/Foliage/foli_train_chan2_20235704140400.csv';
% grav_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/rm_comp/chan_2__Grav_Asph2_20234413100431/grav_train_chan2.csv'
% asph_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/rm_comp/chan_2__Grav_Asph2_20234413100431/grav_rm_train_chan2.csv'

asph_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_5_Grav_Asph_Gras/asph_train_chan5';
gras_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_5_Grav_Asph_Gras/gras_train_chan5';
grav_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/TRAINING_DATA/02_RDF_Training_Data_Combiner_Splitter_Export/chan_5_Grav_Asph_Gras/grav_train_chan5';

% Load csv into workspace
gras_data = ring_train_data_csv_import_w_cat(gras_file);
grav_data = ring_train_data_csv_import_w_cat(grav_file);
asph_data = ring_train_data_csv_import_w_cat(asph_file);
% foli_data = ring_train_data_csv_import_w_cat(foli_file);

% Find minimum for equal numbers of data per terrain type
% max_dat_size    =  max([length(gras_array(:,1)) length(grav_array(:,1)) length(asph_array(:,1))]);
min_dat_size    =  min([height(gras_data) height(grav_data) height(asph_data)]);
% min_dat_size    =  min([height(grav_data) height(asph_data)]);

% Re-sample based on minimum number
gras_data               = gras_data(1:min_dat_size,:);
grav_data               = grav_data(1:min_dat_size,:);
asph_data               = asph_data(1:min_dat_size,:);
% foli_data               = foli_data(1:min_dat_size,:);

% Apphend all the data
Mdl_Trainer_Table       = [grav_data; asph_data];
terrain_types           = Mdl_Trainer_Table(:,end);
Mdl_Trainer_Table       = Mdl_Trainer_Table(:,1:end-1);
Mdl_Trainer_Array       = table2array(Mdl_Trainer_Table);
terrain_types_array     = string(table2cell(terrain_types));

% NOTE: this does NOT import the categorical array containing terrain type
% gras_data = ring_train_data_csv_import(gras_file);
% grav_data = ring_train_data_csv_import(grav_file);
% asph_data = ring_train_data_csv_import(asph_file);

% Get feat labels
labels = grav_data.Properties.VariableNames(1,1:end-1);

% Convert table to array
gras_array = table2array(gras_data(:,1:end-1));
grav_array = table2array(grav_data(:,1:end-1));
asph_array = table2array(asph_data(:,1:end-1));
% foli_array = table2array(foli_data(:,1:end-1));


% Find minimum for accurate plotting
% min_dat_size    =  min([length(gras_array(:,1)) length(grav_array(:,1)) length(asph_array(:,1))]);

%% Plot the data - xy chart

% parfor x_axis_idx = 1:length(labels)
%     
%     for y_axis_idx = 1:1:length(labels)
%         
%         if x_axis_idx ~= y_axis_idx
%             
%             % Do something
%             dat_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
%             scatter(gras_array(1:min_dat_size,x_axis_idx), gras_array(1:min_dat_size,y_axis_idx), 'g*', 'Linewidth', 10)
%             hold on
%             scatter(grav_array(1:min_dat_size,x_axis_idx), grav_array(1:min_dat_size,y_axis_idx), 100, 'co', 'Linewidth', 10)
%             hold on
%             scatter(asph_array(1:min_dat_size,x_axis_idx), asph_array(1:min_dat_size,y_axis_idx), 50, 'kx', 'Linewidth', 10)
%             hold on
% %             scatter(asph_array(1:min_dat_size,x_axis_idx), asph_array(1:min_dat_size,y_axis_idx), 50, 'k*')
%             hold off
%             xlabel(string(labels(x_axis_idx)))
%             ylabel(string(labels(y_axis_idx)))
%             legend({'Grass', 'Gravel', 'Asphalt'})
%             
%             % Save image
%             filename = xy_export_dir + "/" + time_now + "_" + string(labels(x_axis_idx)) + "_" + string(labels(y_axis_idx)) + ".png";
%             saveas(dat_fig, filename);
%             
%         end
%         
%     end
%     
% end

%% Plot the data - histograms

parfor feat_idx = 1:length(labels)
    
    hist_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',28);
    gras_hist = histogram(gras_array(1:min_dat_size,feat_idx));
    hold on
    grav_hist = histogram(grav_array(1:min_dat_size,feat_idx));
    hold on
    asph_hist = histogram(asph_array(1:min_dat_size,feat_idx));
    hold off
    
    grav_hist.FaceColor = 'c';
    gras_hist.FaceColor = 'g';
    asph_hist.FaceColor = 'k';
    
    x_max = max([grav_array(1:min_dat_size,feat_idx)' asph_array(1:min_dat_size,feat_idx)']);
    x_min = min([grav_array(1:min_dat_size,feat_idx)' asph_array(1:min_dat_size,feat_idx)']);
    bin_size = (x_max - x_min) / 50;
    
    grav_hist.BinWidth = bin_size;
    gras_hist.BinWidth = bin_size;
    asph_hist.BinWidth = bin_size;
    
    xlabel(string(labels(feat_idx)));
    ylabel('Count')
    legend({'Grass', 'Gravel', 'Asphalt'})
    
    filename = hist_export_dir + "/" + time_now + "_" + string(labels(feat_idx)) + "_HISTOGRAM.png";
    saveas(hist_fig, filename);
    
end

%% fscchi2

fssci2_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',14);
[idx1, scores1] = fscchi2(Mdl_Trainer_Table,terrain_types);

bar(scores1(idx1))
xlabel('Predictor rank')
ylabel('Predictor importance score')
xticks(1:1:width(Mdl_Trainer_Table))
xticklabels(strrep(labels(idx1),'_','\_'))
xtickangle(45)
title('fscchi2')

%% fscmrmr

fscmrmr_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',14);

[idx2, scores2] = fscmrmr(Mdl_Trainer_Table,terrain_types);
bar(scores2(idx2))
xlabel('Predictor rank')
ylabel('Predictor importance score')
xticks(1:1:width(Mdl_Trainer_Table))
xticklabels(strrep(labels(idx2),'_','\_'))
xtickangle(45)
title('fscmrmr')

%% fscnca

fscnca_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',14);
[idx3, scores3] = fscchi2(Mdl_Trainer_Table,terrain_types);

bar(scores3(idx3))
xlabel('Predictor rank')
ylabel('Predictor importance score')
xticks(1:1:width(Mdl_Trainer_Table))
xticklabels(strrep(labels(idx3),'_','\_'))
xtickangle(45)
title('fscnca')

%% relieff

relieff_fig = figure('Position', fig_size_array, 'DefaultAxesFontSize',14);

[idx4, weights4] = relieff(Mdl_Trainer_Array, terrain_types_array, 1, 'method', 'classification');
bar(weights4(idx4))
xlabel('Predictor rank')
ylabel('Predictor importance score')
xticks(1:1:width(Mdl_Trainer_Table))
xticklabels(strrep(labels(idx4),'_','\_'))
xtickangle(45)
title('relieff')

%% Importance Fig Save

saveas(fssci2_fig, import_export_dir + "/fssci2_fig" + time_now + ".png")
saveas(fscmrmr_fig, import_export_dir + "/fscmrmr_fig" + time_now + ".png")
saveas(fscnca_fig, import_export_dir + "/fscnca_fig" + time_now +  ".png")
saveas(relieff_fig, import_export_dir + "/relieff_fig" + time_now + ".png")

%% End program

disp('End plot export!')
