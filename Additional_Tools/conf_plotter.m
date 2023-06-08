%% conf plotter

clear all
close all
clc

%% VAR INIT

% RANGE SETTINGS
grav_conf_lowbound = 0.975;
unkn_conf_lowbound = 0.975;
asph_conf_lowbound = 0.90;

% RANSAC SETTINGS
% grav_conf_lowbound = 0.75;
% unkn_conf_lowbound = 0.95;
% asph_conf_lowbound = 0.75;

% MLS SETTINGS
% grav_conf_lowbound = 0.95;
% unkn_conf_lowbound = 0.60;
% asph_conf_lowbound = 0.90;

options.scale_factor = 10000;
num_chans = 3;

% Chan 2
Grav_Avg_Append_Array_2 = []; Asph_Avg_Append_Array_2 = []; Unkn_Avg_Append_Array_2 = [];

% Chan 3
Grav_Avg_Append_Array_3 = []; Asph_Avg_Append_Array_3 = []; Unkn_Avg_Append_Array_3 = [];

% Chan 4
Grav_Avg_Append_Array_4 = []; Asph_Avg_Append_Array_4 = []; Unkn_Avg_Append_Array_4 = [];

% Chan 2
Grav_CT_Append_Array_2 = []; Asph_CT_Append_Array_2 = []; Unkn_CT_Append_Array_2 = [];

% Chan 3
Grav_CT_Append_Array_3 = []; Asph_CT_Append_Array_3 = []; Unkn_CT_Append_Array_3 = [];

% Chan 4
Grav_CT_Append_Array_4 = []; Asph_CT_Append_Array_4 = []; Unkn_CT_Append_Array_4 = [];

%% Options


% Marker size / Linewidth for plotz
options.c2markersize            = 20;
options.c3markersize            = 20;
options.c4markersize            = 20;

% Plotting linewidth for plotz
options.c2linewidth             = 20;
options.c3linewidth             = 20;
options.c4linewidth             = 20;

% Legend Stuff
options.legend_marker_size      = 20;
options.legend_line_width       = 5;
options.legend_font_size        = 56;

% Size of figures
options.fig_size_array          = [10 10 3500 1600];

% Font Options
options.axis_font_size          = 24;
options.font_type               = 'Sans Regular'; % Default Font: Sans Regular

% Marker Options
options.alpha_value             = 0;
options.linewidth               = 2;
options.scale_factor            = 10000;


%% Load file & data

% load('1686055798.6768_rm_db_4_range_Results_Export.mat')
[matfile, matfolder, ~] = uigetfile('*Results_Export.mat','Get Results');
load(matfile)
disp(matfile)


%% Select the data

load_result_bar = waitbar(0, "Loading Files...");

for idx2 = 1:length(Results_Export.c2)

    xyzi = Results_Export.c2{idx2}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c2{idx2}.scores];

    % Channel 2
    if isequal(Results_Export.c2{idx2}.Yfit, 'asphalt')
%         Asph_All_Append_Array_2             = [Asph_All_Append_Array_2; xyzi];
        Asph_Avg_Append_Array_2             = [Asph_Avg_Append_Array_2; avg_xyzi];
    end

    if isequal(Results_Export.c2{idx2}.Yfit, 'unknown')
%         Unkn_All_Append_Array_2             = [Unkn_All_Append_Array_2; xyzi];
        Unkn_Avg_Append_Array_2             = [Unkn_Avg_Append_Array_2; avg_xyzi];
    end
    
    if isequal(Results_Export.c2{idx2}.Yfit, 'gravel')
%         Grav_All_Append_Array_2             = [Grav_All_Append_Array_2; xyzi];
        Grav_Avg_Append_Array_2             = [Grav_Avg_Append_Array_2; avg_xyzi];
    end

end

waitbar(1/num_chans, load_result_bar, sprintf('Channel %d out of %d', 1, num_chans))

for idx3 = 1:length(Results_Export.c3)

    xyzi = Results_Export.c3{idx3}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c3{idx3}.scores];

    % Channel 3
    if isequal(Results_Export.c3{idx3}.Yfit, 'asphalt')
%         Asph_All_Append_Array_3             = [Asph_All_Append_Array_3; xyzi];
        Asph_Avg_Append_Array_3             = [Asph_Avg_Append_Array_3; avg_xyzi];
    end

    if isequal(Results_Export.c3{idx3}.Yfit, 'unknown')
%         Unkn_All_Append_Array_3             = [Unkn_All_Append_Array_3; xyzi];
        Unkn_Avg_Append_Array_3             = [Unkn_Avg_Append_Array_3; avg_xyzi];
    end
    
    if isequal(Results_Export.c3{idx3}.Yfit, 'gravel')
%         Grav_All_Append_Array_3             = [Grav_All_Append_Array_3; xyzi];
        Grav_Avg_Append_Array_3             = [Grav_Avg_Append_Array_3; avg_xyzi];
    end

end

waitbar(2/num_chans, load_result_bar, sprintf('Channel %d out of %d', 2, num_chans))

for idx4 = 1:length(Results_Export.c4)

    xyzi = Results_Export.c4{idx4}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c4{idx4}.scores];

    % Channel 4
    if isequal(Results_Export.c4{idx4}.Yfit, 'asphalt')
%         Asph_All_Append_Array_4             = [Asph_All_Append_Array_4; xyzi];
        Asph_Avg_Append_Array_4             = [Asph_Avg_Append_Array_4; avg_xyzi];
    end

    if isequal(Results_Export.c4{idx4}.Yfit, 'unknown')
%         Unkn_All_Append_Array_4             = [Unkn_All_Append_Array_4; xyzi];
        Unkn_Avg_Append_Array_4             = [Unkn_Avg_Append_Array_4; avg_xyzi];
    end
    
    if isequal(Results_Export.c4{idx4}.Yfit, 'gravel')
%         Grav_All_Append_Array_4             = [Grav_All_Append_Array_4; xyzi];
        Grav_Avg_Append_Array_4             = [Grav_Avg_Append_Array_4; avg_xyzi];
    end

end

waitbar(3/num_chans, load_result_bar, sprintf('Channel %d out of %d', 3, num_chans))

delete(load_result_bar)

load_result_bar = waitbar(0, "Loading Files...");

for idx2 = 1:length(Results_Export.c2)

    xyzi = Results_Export.c2{idx2}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c2{idx2}.scores];

    % Channel 2
    if isequal(Results_Export.c2{idx2}.Yfit, 'asphalt') && Results_Export.c2{idx2}.scores(1) > asph_conf_lowbound
%         Asph_All_Append_Array_2             = [Asph_All_Append_Array_2; xyzi];
        Asph_CT_Append_Array_2             = [Asph_CT_Append_Array_2; avg_xyzi];
    end

    if isequal(Results_Export.c2{idx2}.Yfit, 'unknown') && Results_Export.c2{idx2}.scores(2) > unkn_conf_lowbound
%         Unkn_All_Append_Array_2             = [Unkn_All_Append_Array_2; xyzi];
        Unkn_CT_Append_Array_2             = [Unkn_CT_Append_Array_2; avg_xyzi];
    end
    
    if isequal(Results_Export.c2{idx2}.Yfit, 'gravel') && Results_Export.c2{idx2}.scores(3) > grav_conf_lowbound
%         Grav_All_Append_Array_2             = [Grav_All_Append_Array_2; xyzi];
        Grav_CT_Append_Array_2             = [Grav_CT_Append_Array_2; avg_xyzi];
    end

end

waitbar(1/num_chans, load_result_bar, sprintf('Channel %d out of %d', 1, num_chans))

for idx3 = 1:length(Results_Export.c3)

    xyzi = Results_Export.c3{idx3}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c3{idx3}.scores];

    % Channel 3
    if isequal(Results_Export.c3{idx3}.Yfit, 'asphalt') && Results_Export.c3{idx3}.scores(1) > asph_conf_lowbound
%         Asph_All_Append_Array_3             = [Asph_All_Append_Array_3; xyzi];
        Asph_CT_Append_Array_3             = [Asph_CT_Append_Array_3; avg_xyzi];
    end

    if isequal(Results_Export.c3{idx3}.Yfit, 'unknown') && Results_Export.c3{idx3}.scores(2) > unkn_conf_lowbound
%         Unkn_All_Append_Array_3             = [Unkn_All_Append_Array_3; xyzi];
        Unkn_CT_Append_Array_3             = [Unkn_CT_Append_Array_3; avg_xyzi];
    end
    
    if isequal(Results_Export.c3{idx3}.Yfit, 'gravel') && Results_Export.c3{idx3}.scores(3) > grav_conf_lowbound
%         Grav_All_Append_Array_3             = [Grav_All_Append_Array_3; xyzi];
        Grav_CT_Append_Array_3             = [Grav_CT_Append_Array_3; avg_xyzi];
    end

end

waitbar(2/num_chans, load_result_bar, sprintf('Channel %d out of %d', 2, num_chans))

for idx4 = 1:length(Results_Export.c4)

    xyzi = Results_Export.c4{idx4}.points;
    avg_xyzi = [mean(xyzi(:,1)), mean(xyzi(:,2)), mean(xyzi(:,3)), mean(xyzi(:,4)), Results_Export.c4{idx4}.scores];

    % Channel 4
    if isequal(Results_Export.c4{idx4}.Yfit, 'asphalt') && Results_Export.c4{idx4}.scores(1) > asph_conf_lowbound
%         Asph_All_Append_Array_4             = [Asph_All_Append_Array_4; xyzi];
        Asph_CT_Append_Array_4             = [Asph_CT_Append_Array_4; avg_xyzi];
    end

    if isequal(Results_Export.c4{idx4}.Yfit, 'unknown') && Results_Export.c4{idx4}.scores(2) > unkn_conf_lowbound
%         Unkn_All_Append_Array_4             = [Unkn_All_Append_Array_4; xyzi];
        Unkn_CT_Append_Array_4             = [Unkn_CT_Append_Array_4; avg_xyzi];
    end
    
    if isequal(Results_Export.c4{idx4}.Yfit, 'gravel') && Results_Export.c4{idx4}.scores(3) > grav_conf_lowbound
%         Grav_All_Append_Array_4             = [Grav_All_Append_Array_4; xyzi];
        Grav_CT_Append_Array_4             = [Grav_CT_Append_Array_4; avg_xyzi];
    end

end

waitbar(3/num_chans, load_result_bar, sprintf('Channel %d out of %d', 3, num_chans))

delete(load_result_bar)

%% Making a struct for the individual terrain conf plots

All_Avg_Array = [Asph_Avg_Append_Array_2;...
                 Asph_Avg_Append_Array_3;...
                 Asph_Avg_Append_Array_4;...
                 Grav_Avg_Append_Array_2;...
                 Grav_Avg_Append_Array_3;...
                 Grav_Avg_Append_Array_4;...
                 Unkn_Avg_Append_Array_2;...
                 Unkn_Avg_Append_Array_3;...
                 Unkn_Avg_Append_Array_4];






%%  Plot the data - just the dots

dot_figure = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);

% Channel 2
hold all
try
    plot3(Grav_CT_Append_Array_2(:,1), Grav_CT_Append_Array_2(:,2), Grav_CT_Append_Array_2(:,3), 'co', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
catch
    disp('No Grav Data on Chan 2!')
end
try   
    plot3(Asph_CT_Append_Array_2(:,1), Asph_CT_Append_Array_2(:,2), Asph_CT_Append_Array_2(:,3), 'ko', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
catch
    disp('No Asph Data on Chan 2!')
end
try
    plot3(Unkn_CT_Append_Array_2(:,1), Unkn_CT_Append_Array_2(:,2), Unkn_CT_Append_Array_2(:,3), 'ro', 'MarkerSize', options.c2markersize, 'Linewidth', options.c2linewidth)
catch
    disp('No Unkn Data on Chan 2!')
end

% Channel 3
try
    plot3(Grav_CT_Append_Array_3(:,1), Grav_CT_Append_Array_3(:,2), Grav_CT_Append_Array_3(:,3), 'co', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
catch
    disp('No Grav Data on Chan 3!')
end

try   
    plot3(Asph_CT_Append_Array_3(:,1), Asph_CT_Append_Array_3(:,2), Asph_CT_Append_Array_3(:,3), 'ko', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
catch
    disp('No Asph Data on Chan 3!')
end

try
    plot3(Unkn_CT_Append_Array_3(:,1), Unkn_CT_Append_Array_3(:,2), Unkn_CT_Append_Array_3(:,3), 'ro', 'MarkerSize', options.c3markersize, 'Linewidth', options.c3linewidth)
catch
    disp('No Unkn Data on Chan 3!')
end

% Channel 4
try
    plot3(Grav_CT_Append_Array_4(:,1), Grav_CT_Append_Array_4(:,2), Grav_CT_Append_Array_4(:,3), 'co', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
catch
    disp('No Grav Data on Chan 4!')
end

try   
    plot3(Asph_CT_Append_Array_4(:,1), Asph_CT_Append_Array_4(:,2), Asph_CT_Append_Array_4(:,3), 'ko', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
catch
    disp('No Asph Data on Chan 4!')
end

try
    plot3(Unkn_CT_Append_Array_4(:,1), Unkn_CT_Append_Array_4(:,2), Unkn_CT_Append_Array_4(:,3), 'ro', 'MarkerSize', options.c4markersize, 'Linewidth', options.c4linewidth)
catch
    disp('No Unkn Data on Chan 4!')
end
axis('equal')
axis off
view([0 0 90])

hold on

% MCA_plotter(Manual_Classfied_Areas, z_max_lim)

% xlim([x_min_lim x_max_lim]);
% ylim([y_min_lim y_max_lim]);

h(1) = plot(NaN,NaN,'oc', 'LineWidth', 25);
h(2) = plot(NaN,NaN,'ok', 'LineWidth', 25);
h(3) = plot(NaN,NaN,'or', 'LineWidth', 25);
l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

ax2 = gca;
ax2.Clipping = 'off';



%%  Plot the data - Size-altered 

scatter_figure = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);

% Channel 2
hold all
try
    scatter3(Grav_Avg_Append_Array_2(:,1), Grav_Avg_Append_Array_2(:,2), Grav_Avg_Append_Array_2(:,3), 'filled', 'SizeData', ((Grav_Avg_Append_Array_2(:,7)+0.01)*options.scale_factor), 'MarkerFaceColor', 'c', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'c')
catch
    disp('No Grav Data on Chan 2!')
end
try   
    scatter3(Asph_Avg_Append_Array_2(:,1), Asph_Avg_Append_Array_2(:,2), Asph_Avg_Append_Array_2(:,3), 'filled', 'SizeData', ((Asph_Avg_Append_Array_2(:,5)+0.01)*options.scale_factor), 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'k') 
catch
    disp('No Asph Data on Chan 2!')
end
try
    scatter3(Unkn_Avg_Append_Array_2(:,1), Unkn_Avg_Append_Array_2(:,2), Unkn_Avg_Append_Array_2(:,3), 'filled', 'SizeData', ((Unkn_Avg_Append_Array_2(:,6)+0.01)*options.scale_factor), 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'r')
catch
    disp('No Unkn Data on Chan 2!')
end

% Channel 3
try
    scatter3(Grav_Avg_Append_Array_3(:,1), Grav_Avg_Append_Array_3(:,2), Grav_Avg_Append_Array_3(:,3), 'filled', 'SizeData', ((Grav_Avg_Append_Array_3(:,7)+0.01)*options.scale_factor), 'MarkerFaceColor', 'c', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'c')
catch
    disp('No Grav Data on Chan 3!')
end

try   
    scatter3(Asph_Avg_Append_Array_3(:,1), Asph_Avg_Append_Array_3(:,2), Asph_Avg_Append_Array_3(:,3), 'filled', 'SizeData', ((Asph_Avg_Append_Array_3(:,5)+0.01)*options.scale_factor), 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'k') 
catch
    disp('No Asph Data on Chan 3!')
end

try
    scatter3(Unkn_Avg_Append_Array_3(:,1), Unkn_Avg_Append_Array_3(:,2), Unkn_Avg_Append_Array_3(:,3), 'filled', 'SizeData', ((Unkn_Avg_Append_Array_3(:,6)+0.01)*options.scale_factor), 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'r')
catch
    disp('No Unkn Data on Chan 3!')
end

% Channel 4
try
    scatter3(Grav_Avg_Append_Array_4(:,1), Grav_Avg_Append_Array_4(:,2), Grav_Avg_Append_Array_4(:,3), 'filled', 'SizeData', ((Grav_Avg_Append_Array_4(:,7)+0.01)*options.scale_factor), 'MarkerFaceColor', 'c', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'c')
catch
    disp('No Grav Data on Chan 4!')
end

try   
    scatter3(Asph_Avg_Append_Array_4(:,1), Asph_Avg_Append_Array_4(:,2), Asph_Avg_Append_Array_4(:,3), 'filled', 'SizeData', ((Asph_Avg_Append_Array_4(:,5)+0.01)*options.scale_factor), 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'k') 
catch
    disp('No Asph Data on Chan 4!')
end

try
    scatter3(Unkn_Avg_Append_Array_4(:,1), Unkn_Avg_Append_Array_4(:,2), Unkn_Avg_Append_Array_4(:,3), 'filled', 'SizeData', ((Unkn_Avg_Append_Array_4(:,6)+0.01)*options.scale_factor), 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'r')
catch
    disp('No Unkn Data on Chan 4!')
end

axis('equal')
axis off
view([0 0 90])

hold on

% MCA_plotter(Manual_Classfied_Areas, z_max_lim)

% xlim([x_min_lim x_max_lim]);
% ylim([y_min_lim y_max_lim]);

h(1) = plot(NaN,NaN,'oc', 'LineWidth', 25);
h(2) = plot(NaN,NaN,'ok', 'LineWidth', 25);
h(3) = plot(NaN,NaN,'or', 'LineWidth', 25);
l = legend(h, {'\color{cyan} Gravel','\color{black} Asphalt','\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

ax2 = gca;
ax2.Clipping = 'off';


%% Plotting Asphalt Confs

asph_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,5)+0.01)*options.scale_factor), 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'k') 
hold on
axis('equal')
axis off
view([0 0 90])
hold on
h = plot(NaN,NaN,'ok', 'LineWidth', 25);
hold off
l = legend(h, {'\color{black} Asphalt'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';
ax2 = gca;
ax2.Clipping = 'off';


%% Plotting Grass (UNKNOWN) Confs

unkn_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,6)+0.01)*options.scale_factor), 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'r')
hold on
axis('equal')
axis off
view([0 0 90])
hold on
h = plot(NaN,NaN,'or', 'LineWidth', 25);
l = legend(h, {'\color{red} Unkn'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';
hold off
ax2 = gca;
ax2.Clipping = 'off';


%% Plotting Gravel Confs

grav_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'filled', 'SizeData', ((All_Avg_Array(:,7)+0.01)*options.scale_factor), 'MarkerFaceColor', 'c', 'MarkerFaceAlpha', options.alpha_value, 'MarkerEdgeColor', 'c')
hold on
axis('equal')
axis off
view([0 0 90])
hold on
h = plot(NaN,NaN,'oc', 'LineWidth', 25);
l = legend(h, {'\color{cyan} Gravel'}, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';
hold off
ax2 = gca;
ax2.Clipping = 'off';


%% Plotting All Confs

all_conf_fig = figure('Position', options.fig_size_array, 'DefaultAxesFontSize', options.axis_font_size);
hold on
scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'SizeData', (((All_Avg_Array(:,7)+0.01)*options.scale_factor)*1.25), 'Marker', 'square', 'MarkerEdgeColor', 'c', 'LineWidth', options.linewidth)
scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'SizeData', ((All_Avg_Array(:,6)+0.01)*options.scale_factor), 'Marker', 'o', 'MarkerEdgeColor', 'r', 'LineWidth', options.linewidth)
scatter3(All_Avg_Array(:,1), All_Avg_Array(:,2), All_Avg_Array(:,3), 'SizeData', ((All_Avg_Array(:,5)+0.01)*options.scale_factor), 'Marker', 'diamond', 'MarkerEdgeColor', 'k', 'LineWidth', options.linewidth) 
axis('equal')
axis off
view([0 0 90])
h(1) = plot(NaN,NaN,'c', 'LineWidth', 2, 'Marker', 'square', 'MarkerSize',50, 'LineStyle', 'none');
h(2) = plot(NaN,NaN,'r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize',50, 'LineStyle', 'none');
h(3) = plot(NaN,NaN,'k', 'LineWidth', 2, 'Marker', 'diamond', 'MarkerSize',50, 'LineStyle', 'none');
legendLabels = {'\color{cyan}Grav', '\color{red}Unkn', '\color{black}Asph'};
legendLabels = cellfun(@(label) sprintf('\x2005%s', label), legendLabels, 'UniformOutput', false);
l = legend(h, legendLabels, 'FontSize', 100, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';
% Increase the size of the legend box
legendPos = l.Position;  % Get the current position of the legend
legendPos(3) = legendPos(3) * 1.25;  % Increase the width of the legend box
l.Position = legendPos;  % Set the new position for the legend
hold off
ax2 = gca;
ax2.Clipping = 'off';


%% End Program

disp('End Program')

