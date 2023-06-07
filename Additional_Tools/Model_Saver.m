%% Model Saver

% Time of Run
time_now                = datetime("now","Format","uuuuMMddhhmmss");
time_now                = datestr(time_now,'yyyyMMddhhmmss');

% Directory
% export_dir = '/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Classifier_App/Trained_Models';

% DvG.c2 = Mdl;

% Filename
model_name = 'chan_2_r_range.mat';

% Overalldir
file_ovrl_name = string(model_name);

% Save
save(file_ovrl_name, 'Mdl')



