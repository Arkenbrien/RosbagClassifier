%==========================================================================
%                            Rhett Huston
%
%                     FILE CREATION DATE: 10/13/2022
%
%                        Large PCD Scoring
%
% This program looks loads the defined area as well as the
%
%==========================================================================

%% Clear Workspace

clear all
close all
clc

%% Load Truth Areas

area_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/ROSBAG_2022-10-11-09-28-18_20225823091158/MANUAL_CLASS/Manual_Classified_PCD_2022-10-11-09-28-18_manual_classification.mat';

load(area_file);

%% Load Classification Results

class_file = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/ROSBAG_2022-10-11-09-28-18_20225823091158/RESULT_EXPORT/AVG_RESULTS.mat';
load(class_file);

%% Loading Dataz

grav_array = []; chip_array = []; gras_array = []; foli_array = [];

for i = 1:length(RESULTS_AVG)
    
    grav_array = [grav_array; RESULTS_AVG(i).grav];
    chip_array = [chip_array; RESULTS_AVG(i).chip];
    foli_array = [foli_array; RESULTS_AVG(i).foli];
    gras_array = [gras_array; RESULTS_AVG(i).gras];
    
    
end


%% Trimming points as needed


% Trim zeros and above certain height (quick foliage removal)
% Way better method now used - this is legacy just in case for future ref

% max_z = 100;
% min_z = -1;

% grav_array(any(grav_array == 0 | grav_array(:,3) >= max_z, 2), :) = [];
% chip_array(any(chip_array == 0 | chip_array(:,3) >= max_z, 2), :) = [];
% foli_array(any(foli_array == 0 | foli_array(:,3) >= max_z, 2), :) = [];
% gras_array(any(gras_array == 0 | gras_array(:,3) >= max_z, 2), :) = [];

% Trim zeros only - Still Needed
grav_array(any(grav_array == 0 , 2), :) = [];
chip_array(any(chip_array == 0 , 2), :) = [];
foli_array(any(foli_array == 0 , 2), :) = [];
gras_array(any(gras_array == 0 , 2), :) = [];

%% Var Init

chip_bool = 1;
grav_bool = 1;
gras_bool = 0;
foli_bool = 0;

%% Making a pretty plot

figure

hold all

plot3(grav_array(:,1), grav_array(:,2), grav_array(:,3), 'c.', 'MarkerSize', 18)
plot3(chip_array(:,1), chip_array(:,2), chip_array(:,3), 'k.', 'MarkerSize', 18)
plot3(foli_array(:,1), foli_array(:,2), foli_array(:,3), 'm.', 'MarkerSize', 18)
plot3(gras_array(:,1), gras_array(:,2), gras_array(:,3), 'g.', 'MarkerSize', 18)

if chip_bool
    
    for i = 1:length(Manual_Classfied_Areas.chip)
        
        % Plot something
        
        xy_roi = Manual_Classfied_Areas.chip{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','black','FaceAlpha',0.25)
        
    end
    
end

if grav_bool
    
    for i = 1:length(Manual_Classfied_Areas.grav)
        
        % Plot something
        xy_roi = Manual_Classfied_Areas.grav{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','red','FaceAlpha',0.25)
        
    end
    
end

if gras_bool
    
    for i = 1:length(Manual_Classfied_Areas.gras)
        
        % Plot Something
        xy_roi = Manual_Classfied_Areas.gras{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','green','FaceAlpha',0.25)
        
    end
    
end

if foli_bool
    for i = 1:length(Manual_Classfied_Areas.foli)
        
        % Do Something
        xy_roi = Manual_Classfied_Areas.foli{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','magenta','FaceAlpha',0.25)
        
    end
    
end

axis equal

view([0 0 90])

xlim_max = max([grav_array(:,1); chip_array(:,1); foli_array(:,1); gras_array(:,1)]);
xlim_min = min([grav_array(:,1); chip_array(:,1); foli_array(:,1); gras_array(:,1)]);

ylim_max = max([grav_array(:,2); chip_array(:,2); foli_array(:,2); gras_array(:,2)]);
ylim_min = min([grav_array(:,2); chip_array(:,2); foli_array(:,2); gras_array(:,2)]);

xlim([xlim_min xlim_max]);
ylim([ylim_min ylim_max]);

axis off

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

hold off

view([pi/2 0 90])

%% Finding raw score value - PRE GROUND PLANE FILTER

% Reference....
% % Query points, this is the X,Y of the point cloud data
% xq = pt.Location(:,1);
% yq = pt.Location(:,2);
%
% % ROI points, this is the X,Y of each point made in making the Polygon
% xv = roi.Position(:,1);
% yv = roi.Position(:,2);
%
% % Returns binary results of each point (X/Y)
% in = inpolygon(xq,yq,xv,yv);
%
% % Get array of ones
% idx_in = find(in==1);

% Gravel

% Score Initilization
grav_in_grav_count  = 0;
chip_in_grav_count  = 0;
foli_in_grav_count  = 0;
gras_in_grav_count  = 0;

grav_in_chip_count  = 0;
chip_in_chip_count  = 0;
foli_in_chip_count  = 0;
gras_in_chip_count  = 0;

grav_in_foli_count  = 0;
chip_in_foli_count  = 0;
foli_in_foli_count  = 0;
gras_in_foli_count  = 0;

grav_in_gras_count  = 0;
chip_in_gras_count  = 0;
foli_in_gras_count  = 0;
gras_in_gras_count  = 0;

% Index Store
grav_used_overall_idx       = [];
chip_used_overall_idx       = [];
foli_used_overall_idx       = [];
gras_used_overall_idx       = [];

% Gravel

for i = 1:length(Manual_Classfied_Areas.grav)
    
    % Grabs the polygon data
    xy_roi              = Manual_Classfied_Areas.grav{:,i};
    
    % Grabs the indexes for all the points that lie in the polygon
    grav_in_grav        = inpolygon(grav_array(:,1), grav_array(:,2), xy_roi(:,1), xy_roi(:,2));
    chip_in_grav        = inpolygon(chip_array(:,1), chip_array(:,2), xy_roi(:,1), xy_roi(:,2));
    foli_in_grav        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
    gras_in_grav        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));
    
    % Gets number of points per result
    grav_in_grav_count  = grav_in_grav_count + length(find(grav_in_grav == 1));
    chip_in_grav_count  = chip_in_grav_count + length(find(chip_in_grav == 1));
    foli_in_grav_count  = foli_in_grav_count + length(find(foli_in_grav == 1));
    gras_in_grav_count  = gras_in_grav_count + length(find(gras_in_grav == 1));
    
    % Getting all of the used points (some points lie outside defined areas
    % - unscoreable therefore those points are removed).
    grav_used_overall_idx       = [grav_used_overall_idx; find(grav_in_grav == 1)];
    chip_used_overall_idx       = [chip_used_overall_idx; find(chip_in_grav == 1)];
    foli_used_overall_idx       = [foli_used_overall_idx; find(foli_in_grav == 1)];
    gras_used_overall_idx       = [gras_used_overall_idx; find(gras_in_grav == 1)];
    
    % per-area for later
    grav_used_grav{i} = [find(grav_in_grav == 1)];
    chip_used_grav{i} = [find(chip_in_grav == 1)];
    foli_used_grav{i} = [find(foli_in_grav == 1)];
    gras_used_grav{i} = [find(gras_in_grav == 1)];
    
end



% Chipseal

if chip_bool
    
    for i = 1:1:length(Manual_Classfied_Areas.chip)
        
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.chip{:,i};
        
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_chip        = inpolygon(grav_array(:,1), grav_array(:,2), xy_roi(:,1), xy_roi(:,2));
        chip_in_chip        = inpolygon(chip_array(:,1), chip_array(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_chip        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_chip        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));
        
        % Gets number of points per result
        grav_in_chip_count  = grav_in_chip_count + length(find(grav_in_chip == 1));
        chip_in_chip_count  = chip_in_chip_count + length(find(chip_in_chip == 1));
        foli_in_chip_count  = foli_in_chip_count + length(find(foli_in_chip == 1));
        gras_in_chip_count  = gras_in_chip_count + length(find(gras_in_chip == 1));
        
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_used_overall_idx       = [grav_used_overall_idx; find(grav_in_chip == 1)];
        chip_used_overall_idx       = [chip_used_overall_idx; find(chip_in_chip == 1)];
        foli_used_overall_idx       = [foli_used_overall_idx; find(foli_in_chip == 1)];
        gras_used_overall_idx       = [gras_used_overall_idx; find(gras_in_chip == 1)];
        
        % per-area for later
        grav_used_chip{i} = [find(grav_in_chip == 1)];
        chip_used_chip{i} = [find(chip_in_chip == 1)];
        foli_used_chip{i} = [find(foli_in_chip == 1)];
        gras_used_chip{i} = [find(gras_in_chip == 1)];
        
    end
    
end

% Foliage

if foli_bool
    
    for i = 1:1:length(Manual_Classfied_Areas.foli)
        
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.foli{:,i};
        
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_foli        = inpolygon(grav_array(:,1), grav_array(:,2), xy_roi(:,1), xy_roi(:,2));
        chip_in_foli        = inpolygon(chip_array(:,1), chip_array(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_foli        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_foli        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));
        
        % Gets number of points per result
        grav_in_foli_count  = grav_in_foli_count + length(find(grav_in_foli == 1));
        chip_in_foli_count  = chip_in_foli_count + length(find(chip_in_foli == 1));
        foli_in_foli_count  = foli_in_foli_count + length(find(foli_in_foli == 1));
        gras_in_foli_count  = gras_in_foli_count + length(find(gras_in_foli == 1));
        
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_used_overall_idx       = [grav_used_idx; find(grav_in_foli == 1)];
        chip_used_overall_idx       = [chip_used_idx; find(chip_in_foli == 1)];
        foli_used_overall_idx       = [foli_used_idx; find(foli_in_foli == 1)];
        gras_used_overall_idx       = [gras_used_idx; find(gras_in_foli == 1)];
        
        % per-area for later
        grav_used_foli{i} = [find(grav_in_foli == 1)];
        chip_used_foli{i} = [find(chip_in_foli == 1)];
        foli_used_foli{i} = [find(foli_in_foli == 1)];
        gras_used_foli{i} = [find(gras_in_foli == 1)];
        
    end
    
end

% Grass

if gras_bool
    
    for i = 1:1:length(Manual_Classfied_Areas.gras)
    
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.gras{:,i};
    
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_gras        = inpolygon(grav_array(:,1), grav_array(:,2), xy_roi(:,1), xy_roi(:,2));
        chip_in_gras        = inpolygon(chip_array(:,1), chip_array(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_gras        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_gras        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));
    
        % Gets number of points per result
        grav_in_gras_count  = grav_in_gras_count + length(find(grav_in_gras == 1));
        chip_in_gras_count  = chip_in_gras_count + length(find(chip_in_gras == 1));
        foli_in_gras_count  = foli_in_gras_count + length(find(foli_in_gras == 1));
        gras_in_gras_count  = gras_in_gras_count + length(find(gras_in_gras == 1));
    
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_used_overall_idx       = [grav_used_idx; find(grav_in_gras == 1)];
        chip_used_overall_idx       = [chip_used_idx; find(chip_in_gras == 1)];
        foli_used_overall_idx       = [foli_used_idx; find(foli_in_gras == 1)];
        gras_used_overall_idx       = [gras_used_idx; find(gras_in_gras == 1)];
    
        % per-area for later
        grav_used_gras{i} = [find(grav_in_gras == 1)];
        chip_used_gras{i} = [find(chip_in_gras == 1)];
        foli_used_gras{i} = [find(foli_in_gras == 1)];
        gras_used_gras{i} = [find(gras_in_gras == 1)];
    
    end
    
end


%% Caluclating in-gravel score

if grav_bool
    
    num_used_IN_grav_area = grav_in_grav_count + chip_in_grav_count + foli_in_grav_count + gras_in_grav_count;
    
    num_used_grav = grav_in_grav_count + grav_in_chip_count + grav_in_foli_count + grav_in_gras_count;
    
    grav_in_grav_score = grav_in_grav_count / num_used_IN_grav_area * 100;
    chip_in_grav_score = chip_in_grav_count / num_used_IN_grav_area * 100;
    foli_in_grav_score = foli_in_grav_count / num_used_IN_grav_area * 100;
    gras_in_grav_score = gras_in_gras_count / num_used_IN_grav_area * 100;
    
    score_grav_array = [ grav_in_grav_score; chip_in_grav_score; foli_in_grav_score; gras_in_grav_score]
    
    sum(score_grav_array)
    
else
    
    score_grav_array = [0;0;0;0];
    
end

%% Calculating in-chipseal score

if chip_bool
    
    num_used_IN_chip_area = grav_in_chip_count + chip_in_chip_count + foli_in_chip_count + gras_in_chip_count;
    
    num_used_chip = chip_in_grav_count + chip_in_chip_count + chip_in_foli_count + chip_in_gras_count;
    
    grav_in_chip_score = grav_in_chip_count / num_used_IN_chip_area * 100;
    chip_in_chip_score = chip_in_chip_count / num_used_IN_chip_area * 100;
    foli_in_chip_score = foli_in_chip_count / num_used_IN_chip_area * 100;
    gras_in_chip_score = gras_in_chip_count / num_used_IN_chip_area * 100;
    
    score_chip_array = [grav_in_chip_score; chip_in_chip_score; foli_in_chip_score; gras_in_chip_score];
    
    sum(score_chip_array)
    
else
    
    score_chip_array = [0;0;0;0];
    
end

%% Calulcating in-foliage score

if foli_bool
    
    num_used_IN_foli_area = grav_in_foli_count + chip_in_foli_count + foli_in_foli_count + gras_in_foli_count;
    
    num_used_foli = foli_in_grav_count + foli_in_chip_count + foli_in_foli_count + foli_in_gras_count;
    
    grav_in_foli_score = grav_in_foli_count / num_used_foli * 100;
    chip_in_foli_score = chip_in_foli_count / num_used_foli * 100;
    foli_in_foli_score = foli_in_foli_count / num_used_foli * 100;
    gras_in_foli_score = gras_in_foli_count / num_used_foli * 100;
    
    score_foli_array = [grav_in_foli_score; chip_in_foli_score; foli_in_foli_score; gras_in_foli_score];
    
else
    
    score_foli_array = [0; 0; 0; 0];
    
end

%% Calculating in-gras score

if gras_bool
    
    % num_used_IN_gras_area = grav_in_gras_count + chip_in_gras_count + foli_in_gras_count + gras_in_gras_count;
    %
    num_used_gras = gras_in_grav_count + gras_in_chip_count + gras_in_foli_count + gras_in_gras_count;
    %
    % grav_in_gras_score = grav_in_gras_count / num_used_gras * 100;
    % chip_in_gras_score = chip_in_gras_count / num_used_gras * 100;
    % foli_in_gras_score = foli_in_gras_count / num_used_gras * 100;
    % gras_in_gras_score = gras_in_gras_count / num_used_gras * 100;
    %
    % score_gras_array = [grav_in_gras_score; chip_in_gras_score; foli_in_gras_score; gras_in_gras_score];
    
else
    
    score_gras_array = [0; 0; 0; 0];
    
end

%% Overall Score

tot_num_used = length(grav_used_overall_idx) + length(chip_used_overall_idx) + length(foli_used_overall_idx) + length(gras_used_overall_idx);

% % Gravel row
score_overall_array(1,1) = grav_in_grav_count / tot_num_used * 100;
score_overall_array(1,2) = grav_in_chip_count / tot_num_used * 100;
score_overall_array(1,3) = grav_in_foli_count / tot_num_used * 100;
score_overall_array(1,4) = grav_in_gras_count / tot_num_used * 100;

% Chipseal Row
score_overall_array(2,1) = chip_in_grav_count / tot_num_used * 100;
score_overall_array(2,2) = chip_in_chip_count / tot_num_used * 100;
score_overall_array(2,3) = chip_in_foli_count / tot_num_used * 100;
score_overall_array(2,4) = chip_in_gras_count / tot_num_used * 100;

% Foliage Row
score_overall_array(3,1) = foli_in_grav_count / tot_num_used * 100;
score_overall_array(3,2) = foli_in_chip_count / tot_num_used * 100;
score_overall_array(3,3) = foli_in_foli_count / tot_num_used * 100;
score_overall_array(3,4) = foli_in_gras_count / tot_num_used * 100;

% Grass Row
score_overall_array(4,1) = gras_in_grav_count / tot_num_used * 100;
score_overall_array(4,2) = gras_in_chip_count / tot_num_used * 100;
score_overall_array(4,3) = gras_in_foli_count / tot_num_used * 100;
score_overall_array(4,4) = gras_in_gras_count / tot_num_used * 100;


%% Table of Results

table_name = {'Gravel' 'Chipseal' 'Foliage' 'Grass'};

score_table = array2table(score_overall_array, 'VariableNames',table_name,'RowNames', table_name)
% score_table.Properties.DimensionNames = table_name;

% score_table.Properties.RowNames = table_name;

% sum(score_array(:,1))
% sum(score_array(:,2))
% score_array(1,1) + score_array(1,2)
% score_array(2,1) + score_array(2,2)

%% Plot only used points

% figure

hold all

plot3(grav_array(grav_used_overall_idx,1), grav_array(grav_used_overall_idx,2), grav_array(grav_used_overall_idx,3), 'c.', 'MarkerSize', 18)
plot3(chip_array(chip_used_overall_idx,1), chip_array(chip_used_overall_idx,2), chip_array(chip_used_overall_idx,3), 'k.', 'MarkerSize', 18)
plot3(foli_array(foli_used_overall_idx,1), foli_array(foli_used_overall_idx,2), foli_array(foli_used_overall_idx,3), 'm.', 'MarkerSize', 18)
plot3(gras_array(gras_used_overall_idx,1), gras_array(gras_used_overall_idx,2), gras_array(gras_used_overall_idx,3), 'g.', 'MarkerSize', 18)

if chip_bool
    
    for i = 1:length(Manual_Classfied_Areas.chip)
    
        % Plot something
    
        xy_roi = Manual_Classfied_Areas.chip{:,i};
    
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','black','FaceAlpha',0.25)
    
    end
    
end

if grav_bool
    
    for i = 1:length(Manual_Classfied_Areas.grav)
        
        % Plot something
        xy_roi = Manual_Classfied_Areas.grav{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','red','FaceAlpha',0.25)
        
    end
    
end


if gras_bool
    
    for i = 1:length(Manual_Classfied_Areas.gras)
    
        % Plot Something
        xy_roi = Manual_Classfied_Areas.gras{:,i};
    
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','green','FaceAlpha',0.25)
    
    end
    
end

if foli_bool
    
    for i = 1:length(Manual_Classfied_Areas.foli)
    
        % Do Something
        xy_roi = Manual_Classfied_Areas.foli{:,i};
    
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','magenta','FaceAlpha',0.25)
    
    end
    
end

axis equal

view([0 0 90])
%
% xlim_max = max([grav_array(:,1); chip_array(:,1); foli_array(:,1); gras_array(:,1)]);
% xlim_min = min([grav_array(:,1); chip_array(:,1); foli_array(:,1); gras_array(:,1)]);
%
% ylim_max = max([grav_array(:,2); chip_array(:,2); foli_array(:,2); gras_array(:,2)]);
% ylim_min = min([grav_array(:,2); chip_array(:,2); foli_array(:,2); gras_array(:,2)]);
%
% xlim([xlim_min xlim_max]);
% ylim([ylim_min ylim_max]);

axis off

hold off

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

view([pi/2 0 90])

%% Attemping RANSAC point elimination

% close all

%making temp tags so I can grab stuff later
grav_tag = ones(length(grav_array(grav_used_overall_idx,1)),1) * 1;
chip_tag = ones(length(chip_array(chip_used_overall_idx,1)),1) * 2;
foli_tag = ones(length(foli_array(foli_used_overall_idx,1)),1) * 3;
gras_tag = ones(length(gras_array(gras_used_overall_idx,1)),1) * 4;

% Making an array for each used item
grav_used_array = [grav_array(grav_used_overall_idx,1), grav_array(grav_used_overall_idx,2), grav_array(grav_used_overall_idx,3), grav_tag];
chip_used_array = [chip_array(chip_used_overall_idx,1), chip_array(chip_used_overall_idx,2), chip_array(chip_used_overall_idx,3), chip_tag];
foli_used_array = [foli_array(foli_used_overall_idx,1), foli_array(foli_used_overall_idx,2), foli_array(foli_used_overall_idx,3), foli_tag];
gras_used_array = [gras_array(gras_used_overall_idx,1), gras_array(gras_used_overall_idx,2), gras_array(gras_used_overall_idx,3), gras_tag];

% making a big array
temp_xyz_array = [grav_used_array; chip_used_array; foli_used_array; gras_used_array];

% Converting to point cloud
temp_point_cloud_A = pointCloud([temp_xyz_array(:,1), temp_xyz_array(:,2), temp_xyz_array(:,3)]);
figure
pcshow(temp_point_cloud_A)

% Grabbing ground plane & indexes of inlier points
maxDistance = 1;
[model, inIdx, outIdx] = pcfitplane(temp_point_cloud_A,maxDistance);

% Verifying that the ground plane is grabbed
temp_xyz_array_post_fitplane = [temp_xyz_array(inIdx,1) temp_xyz_array(inIdx,2) temp_xyz_array(inIdx,3)];
temp_point_cloud_B = pointCloud(temp_xyz_array_post_fitplane);
figure
pcshow(temp_point_cloud_B)

% Getting Indexes of the filtered stuffs
% inIdx = indexes that I want
grav_used_array_filt            = temp_xyz_array(temp_xyz_array(inIdx,4)==1,:);
chip_used_array_filt            = temp_xyz_array(temp_xyz_array(inIdx,4)==2,:);
foli_used_array_filt            = temp_xyz_array(temp_xyz_array(inIdx,4)==3,:);
gras_used_array_filt            = temp_xyz_array(temp_xyz_array(inIdx,4)==4,:);

%% Making a plot to verify that the ground plane removal + backing out workeded

figure

hold all

plot3(grav_used_array_filt(:,1), grav_used_array_filt(:,2), grav_used_array_filt(:,3), 'c.', 'MarkerSize', 18)
plot3(chip_used_array_filt(:,1), chip_used_array_filt(:,2), chip_used_array_filt(:,3), 'k.', 'MarkerSize', 18)
plot3(foli_used_array_filt(:,1), foli_used_array_filt(:,2), foli_used_array_filt(:,3), 'm.', 'MarkerSize', 18)
plot3(gras_used_array_filt(:,1), gras_used_array_filt(:,2), gras_used_array_filt(:,3), 'g.', 'MarkerSize', 18)

if chip_bool
    
    for i = 1:length(Manual_Classfied_Areas.chip)
        
        % Plot something
        
        xy_roi = Manual_Classfied_Areas.chip{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','black','FaceAlpha',0.25)
        
    end
    
end

if grav_bool
    
    for i = 1:length(Manual_Classfied_Areas.grav)
        
        
        % Plot something
        xy_roi = Manual_Classfied_Areas.grav{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','red','FaceAlpha',0.25)
        
    end
    
end

if gras_bool
    
    for i = 1:length(Manual_Classfied_Areas.gras)
        
        % Plot Something
        xy_roi = Manual_Classfied_Areas.gras{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','green','FaceAlpha',0.25)
        
    end
    
end

if foli_bool
    
    for i = 1:length(Manual_Classfied_Areas.foli)
        
        % Do Something
        xy_roi = Manual_Classfied_Areas.foli{:,i};
        
        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','magenta','FaceAlpha',0.25)
        
    end
    
end

axis equal

view([0 0 90])

xlim_max = max([grav_used_array_filt(:,1); chip_used_array_filt(:,1); foli_used_array_filt(:,1); gras_used_array_filt(:,1)]);
xlim_min = min([grav_used_array_filt(:,1); chip_used_array_filt(:,1); foli_used_array_filt(:,1); gras_used_array_filt(:,1)]);

ylim_max = max([grav_used_array_filt(:,2); chip_used_array_filt(:,2); foli_used_array_filt(:,2); gras_used_array_filt(:,2)]);
ylim_min = min([grav_used_array_filt(:,2); chip_used_array_filt(:,2); foli_used_array_filt(:,2); gras_used_array_filt(:,2)]);

xlim([xlim_min xlim_max]);
ylim([ylim_min ylim_max]);

axis off

hold off

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

view([pi/2 0 90])



%% Finding raw score value - POST GROUND PLANE FILTER

% Reference....
% % Query points, this is the X,Y of the point cloud data
% xq = pt.Location(:,1);
% yq = pt.Location(:,2);
%
% % ROI points, this is the X,Y of each point made in making the Polygon
% xv = roi.Position(:,1);
% yv = roi.Position(:,2);
%
% % Returns binary results of each point (X/Y)
% in = inpolygon(xq,yq,xv,yv);
%
% % Get array of ones
% idx_in = find(in==1);

% Gravel

% Score Initilization
grav_in_grav_count  = 0;
chip_in_grav_count  = 0;
foli_in_grav_count  = 0;
gras_in_grav_count  = 0;

grav_in_chip_count  = 0;
chip_in_chip_count  = 0;
foli_in_chip_count  = 0;
gras_in_chip_count  = 0;

grav_in_foli_count  = 0;
chip_in_foli_count  = 0;
foli_in_foli_count  = 0;
gras_in_foli_count  = 0;

grav_in_gras_count  = 0;
chip_in_gras_count  = 0;
foli_in_gras_count  = 0;
gras_in_gras_count  = 0;

% Index Store
grav_used_overall_idx       = [];
chip_used_overall_idx       = [];
foli_used_overall_idx       = [];
gras_used_overall_idx       = [];


% Gravel

if grav_bool
    
    for i = 1:length(Manual_Classfied_Areas.grav)
        
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.grav{:,i};
        
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_grav        = inpolygon(grav_used_array_filt(:,1), grav_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        chip_in_grav        = inpolygon(chip_used_array_filt(:,1), chip_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        foli_in_grav        = inpolygon(foli_used_array_filt(:,1), foli_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_grav        = inpolygon(gras_used_array_filt(:,1), gras_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        
        % Gets number of points per result
        grav_in_grav_count  = grav_in_grav_count + length(find(grav_in_grav == 1));
        chip_in_grav_count  = chip_in_grav_count + length(find(chip_in_grav == 1));
        foli_in_grav_count  = foli_in_grav_count + length(find(foli_in_grav == 1));
        gras_in_grav_count  = gras_in_grav_count + length(find(gras_in_grav == 1));
        
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_used_overall_idx       = [grav_used_overall_idx; find(grav_in_grav == 1)];
        chip_used_overall_idx       = [chip_used_overall_idx; find(chip_in_grav == 1)];
        foli_used_overall_idx       = [foli_used_overall_idx; find(foli_in_grav == 1)];
        gras_used_overall_idx       = [gras_used_overall_idx; find(gras_in_grav == 1)];
        
        % per-area for later
        grav_used_grav{i} = [find(grav_in_grav == 1)];
        chip_used_grav{i} = [find(chip_in_grav == 1)];
        foli_used_grav{i} = [find(foli_in_grav == 1)];
        gras_used_grav{i} = [find(gras_in_grav == 1)];
        
    end
    
end

if chip_bool
    
    % Chipseal
    
    for i = 1:1:length(Manual_Classfied_Areas.chip)
        
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.chip{:,i};
        
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_chip        = inpolygon(grav_used_array_filt(:,1), grav_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        chip_in_chip        = inpolygon(chip_used_array_filt(:,1), chip_used_array_filt(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_chip        = inpolygon(foli_used_array_filt(:,1), foli_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_chip        = inpolygon(gras_used_array_filt(:,1), gras_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        
        % Gets number of points per result
        grav_in_chip_count  = grav_in_chip_count + length(find(grav_in_chip == 1));
        chip_in_chip_count  = chip_in_chip_count + length(find(chip_in_chip == 1));
        foli_in_chip_count  = foli_in_chip_count + length(find(foli_in_chip == 1));
        gras_in_chip_count  = gras_in_chip_count + length(find(gras_in_chip == 1));
        
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_used_overall_idx       = [grav_used_overall_idx; find(grav_in_chip == 1)];
        chip_used_overall_idx       = [chip_used_overall_idx; find(chip_in_chip == 1)];
        foli_used_overall_idx       = [foli_used_overall_idx; find(foli_in_chip == 1)];
        gras_used_overall_idx       = [gras_used_overall_idx; find(gras_in_chip == 1)];
        
        % per-area for later
        grav_used_chip{i} = [find(grav_in_chip == 1)];
        chip_used_chip{i} = [find(chip_in_chip == 1)];
        foli_used_chip{i} = [find(foli_in_chip == 1)];
        gras_used_chip{i} = [find(gras_in_chip == 1)];
        
    end
    
end

% % Foliage

if foli_bool
    
    for i = 1:1:length(Manual_Classfied_Areas.foli)
    
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.foli{:,i};
    
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_foli        = inpolygon(grav_used_array_filt(:,1), grav_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        chip_in_foli        = inpolygon(chip_used_array_filt(:,1), chip_used_array_filt(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_foli        = inpolygon(foli_used_array_filt(:,1), foli_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_foli        = inpolygon(gras_used_array_filt(:,1), gras_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
    
        % Gets number of points per result
        grav_in_foli_count  = grav_in_foli_count + length(find(grav_in_foli == 1));
        chip_in_foli_count  = chip_in_foli_count + length(find(chip_in_foli == 1));
        foli_in_foli_count  = foli_in_foli_count + length(find(foli_in_foli == 1));
        gras_in_foli_count  = gras_in_foli_count + length(find(gras_in_foli == 1));
    
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_used_overall_idx       = [grav_used_idx; find(grav_in_foli == 1)];
        chip_used_overall_idx       = [chip_used_idx; find(chip_in_foli == 1)];
        foli_used_overall_idx       = [foli_used_idx; find(foli_in_foli == 1)];
        gras_used_overall_idx       = [gras_used_idx; find(gras_in_foli == 1)];
    
        % per-area for later
        grav_used_foli{i} = [find(grav_in_foli == 1)];
        chip_used_foli{i} = [find(chip_in_foli == 1)];
        foli_used_foli{i} = [find(foli_in_foli == 1)];
        gras_used_foli{i} = [find(gras_in_foli == 1)];
    
    end
    
end


% Grass

if gras_bool
    
    for i = 1:1:length(Manual_Classfied_Areas.gras)
    
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.gras{:,i};
    
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_gras        = inpolygon(grav_used_array_filt(:,1), grav_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        chip_in_gras        = inpolygon(chip_used_array_filt(:,1), chip_used_array_filt(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_gras        = inpolygon(foli_used_array_filt(:,1), foli_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_gras        = inpolygon(gras_used_array_filt(:,1), gras_used_array_filt(:,2), xy_roi(:,1), xy_roi(:,2));
    
        % Gets number of points per result
        grav_in_gras_count  = grav_in_gras_count + length(find(grav_in_gras == 1));
        chip_in_gras_count  = chip_in_gras_count + length(find(chip_in_gras == 1));
        foli_in_gras_count  = foli_in_gras_count + length(find(foli_in_gras == 1));
        gras_in_gras_count  = gras_in_gras_count + length(find(gras_in_gras == 1));
    
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_used_overall_idx       = [grav_used_idx; find(grav_in_gras == 1)];
        chip_used_overall_idx       = [chip_used_idx; find(chip_in_gras == 1)];
        foli_used_overall_idx       = [foli_used_idx; find(foli_in_gras == 1)];
        gras_used_overall_idx       = [gras_used_idx; find(gras_in_gras == 1)];
    
        % per-area for later
        grav_used_gras{i} = [find(grav_in_gras == 1)];
        chip_used_gras{i} = [find(chip_in_gras == 1)];
        foli_used_gras{i} = [find(foli_in_gras == 1)];
        gras_used_gras{i} = [find(gras_in_gras == 1)];
    
    end
    
end



%% Caluclating in-gravel score

num_used_IN_grav_area = grav_in_grav_count + chip_in_grav_count + foli_in_grav_count + gras_in_grav_count;

num_used_grav = grav_in_grav_count + grav_in_chip_count + grav_in_foli_count + grav_in_gras_count;

grav_in_grav_score = grav_in_grav_count / num_used_IN_grav_area * 100;
chip_in_grav_score = chip_in_grav_count / num_used_IN_grav_area * 100;
foli_in_grav_score = foli_in_grav_count / num_used_IN_grav_area * 100;
gras_in_grav_score = gras_in_gras_count / num_used_IN_grav_area * 100;

score_grav_used_array_filt = [ grav_in_grav_score; chip_in_grav_score; foli_in_grav_score; gras_in_grav_score]

sum(score_grav_used_array_filt)

%% Calculating in-chipseal score

num_used_IN_chip_area = grav_in_chip_count + chip_in_chip_count + foli_in_chip_count + gras_in_chip_count;

num_used_chip = chip_in_grav_count + chip_in_chip_count + chip_in_foli_count + chip_in_gras_count;

grav_in_chip_score = grav_in_chip_count / num_used_IN_chip_area * 100;
chip_in_chip_score = chip_in_chip_count / num_used_IN_chip_area * 100;
foli_in_chip_score = foli_in_chip_count / num_used_IN_chip_area * 100;
gras_in_chip_score = gras_in_chip_count / num_used_IN_chip_area * 100;

score_chip_used_array_filt = [grav_in_chip_score; chip_in_chip_score; foli_in_chip_score; gras_in_chip_score];

sum(score_chip_used_array_filt)

%% Calulcating in-foliage score

num_used_IN_foli_area = grav_in_foli_count + chip_in_foli_count + foli_in_foli_count + gras_in_foli_count;

num_used_foli = foli_in_grav_count + foli_in_chip_count + foli_in_foli_count + foli_in_gras_count;

grav_in_foli_score = grav_in_foli_count / num_used_foli * 100;
chip_in_foli_score = chip_in_foli_count / num_used_foli * 100;
foli_in_foli_score = foli_in_foli_count / num_used_foli * 100;
gras_in_foli_score = gras_in_foli_count / num_used_foli * 100;

score_foli_used_array_filt = [grav_in_foli_score; chip_in_foli_score; foli_in_foli_score; gras_in_foli_score];

score_foli_used_array_filt = [0; 0; 0; 0];

%% Calculating in-gras score

num_used_IN_gras_area = grav_in_gras_count + chip_in_gras_count + foli_in_gras_count + gras_in_gras_count;

num_used_gras = gras_in_grav_count + gras_in_chip_count + gras_in_foli_count + gras_in_gras_count;

grav_in_gras_score = grav_in_gras_count / num_used_gras * 100;
chip_in_gras_score = chip_in_gras_count / num_used_gras * 100;
foli_in_gras_score = foli_in_gras_count / num_used_gras * 100;
gras_in_gras_score = gras_in_gras_count / num_used_gras * 100;

score_gras_used_array_filt = [grav_in_gras_score; chip_in_gras_score; foli_in_gras_score; gras_in_gras_score];

score_gras_used_array_filt = [0; 0; 0; 0];

%% Overall Score

tot_num_used = length(grav_used_overall_idx) + length(chip_used_overall_idx) + length(foli_used_overall_idx) + length(gras_used_overall_idx);

% % Gravel row
score_overall_array(1,1) = grav_in_grav_count / tot_num_used * 100;
score_overall_array(1,2) = grav_in_chip_count / tot_num_used * 100;
score_overall_array(1,3) = grav_in_foli_count / tot_num_used * 100;
score_overall_array(1,4) = grav_in_gras_count / tot_num_used * 100;

% Chipseal Row
score_overall_array(2,1) = chip_in_grav_count / tot_num_used * 100;
score_overall_array(2,2) = chip_in_chip_count / tot_num_used * 100;
score_overall_array(2,3) = chip_in_foli_count / tot_num_used * 100;
score_overall_array(2,4) = chip_in_gras_count / tot_num_used * 100;

% Foliage Row
score_overall_array(3,1) = foli_in_grav_count / tot_num_used * 100;
score_overall_array(3,2) = foli_in_chip_count / tot_num_used * 100;
score_overall_array(3,3) = foli_in_foli_count / tot_num_used * 100;
score_overall_array(3,4) = foli_in_gras_count / tot_num_used * 100;

% Grass Row
score_overall_array(4,1) = gras_in_grav_count / tot_num_used * 100;
score_overall_array(4,2) = gras_in_chip_count / tot_num_used * 100;
score_overall_array(4,3) = gras_in_foli_count / tot_num_used * 100;
score_overall_array(4,4) = gras_in_gras_count / tot_num_used * 100;


%% Table of Results

table_name = {'Gravel' 'Chipseal' 'Foliage' 'Grass'};

score_table_filt = array2table(score_overall_array, 'VariableNames',table_name,'RowNames', table_name)
% score_table.Properties.DimensionNames = table_name;

% score_table.Properties.RowNames = table_name;

% sum(score_array(:,1))
% sum(score_array(:,2))
% score_array(1,1) + score_array(1,2)
% score_array(2,1) + score_array(2,2)

%% Plot only used points

figure

hold all

plot3(grav_used_array_filt(grav_used_overall_idx,1), grav_used_array_filt(grav_used_overall_idx,2), grav_used_array_filt(grav_used_overall_idx,3), 'c.', 'MarkerSize', 18)
plot3(chip_used_array_filt(chip_used_overall_idx,1), chip_used_array_filt(chip_used_overall_idx,2), chip_used_array_filt(chip_used_overall_idx,3), 'k.', 'MarkerSize', 18)
plot3(foli_used_array_filt(foli_used_overall_idx,1), foli_used_array_filt(foli_used_overall_idx,2), foli_used_array_filt(foli_used_overall_idx,3), 'm.', 'MarkerSize', 18)
plot3(gras_used_array_filt(gras_used_overall_idx,1), gras_used_array_filt(gras_used_overall_idx,2), gras_used_array_filt(gras_used_overall_idx,3), 'g.', 'MarkerSize', 18)

if chip_bool
    
    for i = 1:length(Manual_Classfied_Areas.chip)

        % Plot something

        xy_roi = Manual_Classfied_Areas.chip{:,i};

        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','black','FaceAlpha',0.25)

    end

end

if grav_bool

for i = 1:length(Manual_Classfied_Areas.grav)
    
    % Plot something
    xy_roi = Manual_Classfied_Areas.grav{:,i};
    
    pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
    plot(pgon,'FaceColor','red','FaceAlpha',0.25)
    
end

end

if gras_bool

    for i = 1:length(Manual_Classfied_Areas.gras)

        % Plot Something
        xy_roi = Manual_Classfied_Areas.gras{:,i};

        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','green','FaceAlpha',0.25)

    end

end

if foli_bool

    for i = 1:length(Manual_Classfied_Areas.foli)

        % Do Something
        xy_roi = Manual_Classfied_Areas.foli{:,i};

        pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
        plot(pgon,'FaceColor','magenta','FaceAlpha',0.25)

    end

end

axis equal

view([0 0 90])

xlim_max = max([grav_used_array_filt(:,1); chip_used_array_filt(:,1); foli_used_array_filt(:,1); gras_used_array_filt(:,1)]);
xlim_min = min([grav_used_array_filt(:,1); chip_used_array_filt(:,1); foli_used_array_filt(:,1); gras_used_array_filt(:,1)]);

ylim_max = max([grav_used_array_filt(:,2); chip_used_array_filt(:,2); foli_used_array_filt(:,2); gras_used_array_filt(:,2)]);
ylim_min = min([grav_used_array_filt(:,2); chip_used_array_filt(:,2); foli_used_array_filt(:,2); gras_used_array_filt(:,2)]);

xlim([xlim_min xlim_max]);
ylim([ylim_min ylim_max]);

axis off

hold off

l = legend({'\color{cyan} Gravel','\color{black} Chipseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

view([pi/2 0 90])


%% Display the standard end of program notification which consists of a single line of text being printed unto the command window resulting in the user of this program being informed that the program has completed successfully
disp('End Program!')
