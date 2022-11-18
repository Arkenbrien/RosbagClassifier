%% ===================================================================== %%
%  PCD Stack Classifier Result Plotter
%  Plots the results from the stack classifier
%  Created on 11/18/2022
%  By Rhett Huston
%  =====================================================================  %

clear all;
close all;
clc;

%% Requesting user for file

root_dir = uigetdir();

%% Creating Export Location

RESULT_EXPORT_FOLDER = string(root_dir) + "/RESULT_EXPORT";

Save_All_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/ALL_RESULTS.mat";
Save_Avg_Results_Filename = string(RESULT_EXPORT_FOLDER) + "/AVG_RESULTS.mat";

load(Save_All_Results_Filename);
load(Save_Avg_Results_Filename);

%% Creating result structs

RESULTS_ALL.grav = Grav_All_Append_Array;
RESULTS_ALL.chip = Chip_All_Append_Array;
RESULTS_ALL.foli = Foli_All_Append_Array;
RESULTS_ALL.gras = Gras_All_Append_Array;

RESULTS_AVG.grav = Grav_Avg_Append_Array;
RESULTS_AVG.chip = Chip_Avg_Append_Array;
RESULTS_AVG.foli = Foli_Avg_Append_Array;
RESULTS_AVG.gras = Gras_Avg_Append_Array;

%% Plotting Results

figure

hold all

plot3(Grav_All_Append_Array(:,1), Grav_All_Append_Array(:,2), Grav_All_Append_Array(:,3), 'c.', 'MarkerSize', 3.5)
plot3(Chip_All_Append_Array(:,1), Chip_All_Append_Array(:,2), Chip_All_Append_Array(:,3), 'k.', 'MarkerSize', 3.5)
plot3(Foli_All_Append_Array(:,1), Foli_All_Append_Array(:,2), Foli_All_Append_Array(:,3), 'm.', 'MarkerSize', 3.5)
plot3(Gras_All_Append_Array(:,1), Gras_All_Append_Array(:,2), Gras_All_Append_Array(:,3), 'g.', 'MarkerSize', 3.5)

axis('equal')
axis off
view([0 0 90])

figure

hold all

plot3(Grav_Avg_Append_Array(:,1), Grav_Avg_Append_Array(:,2), Grav_Avg_Append_Array(:,3), 'c.', 'MarkerSize', 3.5)
plot3(Chip_Avg_Append_Array(:,1), Chip_Avg_Append_Array(:,2), Chip_Avg_Append_Array(:,3), 'k.', 'MarkerSize', 3.5)
plot3(Foli_Avg_Append_Array(:,1), Foli_Avg_Append_Array(:,2), Foli_Avg_Append_Array(:,3), 'm.', 'MarkerSize', 3.5)
plot3(Gras_Avg_Append_Array(:,1), Gras_Avg_Append_Array(:,2), Gras_Avg_Append_Array(:,3), 'g.', 'MarkerSize', 3.5)

axis('equal')
axis off
view([0 0 90])

%% End Program

disp('End Program')



