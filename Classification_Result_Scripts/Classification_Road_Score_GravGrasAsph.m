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
% clc

%% Options

% No Options for you! :D

%     load('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Manuall_Classified_Areas_Wide_SoR/sturbois_straight_1_MANUAL_CLASSIFICATION_widesor.mat');

asph_bool       = 0;
grav_bool       = 1;
gras_bool       = 0;
non_road_bool   = 1;
road_bool       = 0;

%% Var Init

grav_array = []; asph_array = []; foli_array = []; gras_array = [];

grav_in_grav_count      = 0;
asph_in_grav_count      = 0;
gras_in_grav_count      = 0;

grav_in_asph_count      = 0;
asph_in_asph_count      = 0;
gras_in_asph_count      = 0;

grav_in_foli_count      = 0;
asph_in_foli_count      = 0;
gras_in_foli_count      = 0;

grav_in_gras_count      = 0;
asph_in_gras_count      = 0;
gras_in_gras_count      = 0;

grav_in_nonroad_count   = 0;
asph_in_nonroad_count   = 0;
gras_in_nonroad_count   = 0;

grav_inroad_array       = [];
asph_inroad_array       = [];
gras_inroad_array       = [];

grav_inroad_array       = [];
asph_inroad_array       = [];
gras_inroad_array       = [];

grav_offroad_array      = [];
asph_offroad_array      = [];
gras_offroad_array      = [];


%% Load Classification Root File

RESULT_EXPORT_FOLDER = uigetdir('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/');

addpath(RESULT_EXPORT_FOLDER);


%% Load Truth Areas

if contains(root_dir, 'sturbois_asphseal_woods_1')
    
    load('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Manuall_Classified_Areas_Wide_SoR/sturbois_asphseal_woods_1_MANUAL_CLASSIFICATION_widesor.mat');
    
    asph_bool       = 1;
    grav_bool       = 1;
    gras_bool       = 0;
    non_road_bool   = 1;
    road_bool       = 0;
    
elseif contains(root_dir, 'sturbois_asphseal_woods_2')
    
    load('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Manuall_Classified_Areas_Wide_SoR/sturbois_asphseal_woods_2_MANUAL_CLASSIFICATION_widesor.mat');
    
    asph_bool       = 1;
    grav_bool       = 1;
    gras_bool       = 0;
    non_road_bool   = 1;
    road_bool       = 0;
    
elseif contains(root_dir, '2022-10-11-09-24-00')
    
    load('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Manuall_Classified_Areas_Wide_SoR/2022-10-11-09-24-00_MANUAL_CLASSIFICATION_widesor.mat');
    
    asph_bool       = 1;
    grav_bool       = 1;
    gras_bool       = 0;
    non_road_bool   = 1;
    road_bool       = 0;
    
elseif contains(root_dir, '2022-10-20-10-14-05_GRAV')
    
    load('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Manuall_Classified_Areas_Wide_SoR/2022-10-20-10-14-05_GRAV_MANUAL_CLASSIFICATION_widesor.mat');
    
    asph_bool       = 0;
    grav_bool       = 1;
    gras_bool       = 0;
    non_road_bool   = 1;
    road_bool       = 0;
    
elseif contains(root_dir, 'sturbois_curve_1')
    
    load('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Manuall_Classified_Areas_Wide_SoR/sturbois_curve_1_MANUAL_CLASSIFICATION_widesor.mat');
    
    asph_bool       = 0;
    grav_bool       = 1;
    gras_bool       = 0;
    non_road_bool   = 1;
    road_bool       = 0;
    
elseif contains(root_dir, 'sturbois_straight_1')
    
    load('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/Manuall_Classified_Areas_Wide_SoR/sturbois_straight_1_MANUAL_CLASSIFICATION_widesor.mat');
    
    asph_bool       = 0;
    grav_bool       = 1;
    gras_bool       = 0;
           = 0;
    non_road_bool   = 1;
    road_bool       = 0;
    
else
    
    load('/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/pcd_exports/Manual_Classified_PCD_gravel_lot_rererere.mat');

    asph_bool       = 0;
    grav_bool       = 1;
    gras_bool       = 0;
    non_road_bool   = 0;
    road_bool       = 0;
    
end

%% Loading Dataz

for clas_idx = 1:1:length(RESULTS_AVG.grav(:,1))
    grav_array = [grav_array; RESULTS_AVG.grav(clas_idx, :)];
end

for clas_idx = 1:1:length(RESULTS_AVG.asph(:,1))
    asph_array = [asph_array; RESULTS_AVG.asph(clas_idx, :)];
end

% for clas_idx = 1:1:length(RESULTS_AVG.foli(:,1))
%     foli_array = [foli_array; RESULTS_AVG.foli(clas_idx, :)];
% end

for clas_idx = 1:1:length(RESULTS_AVG.gras(:,1))
    gras_array = [gras_array; RESULTS_AVG.gras(clas_idx, :)];
end

%% Making a pretty plot

figure

hold all

% try
    
    plot3(grav_array(:,1), grav_array(:,2), grav_array(:,3), 'c.', 'MarkerSize', 18)
    plot3(asph_array(:,1), asph_array(:,2), asph_array(:,3), 'k.', 'MarkerSize', 18)
%     plot3(foli_array(:,1), foli_array(:,2), foli_array(:,3), 'm.', 'MarkerSize', 18)
    plot3(gras_array(:,1), gras_array(:,2), gras_array(:,3), 'g.', 'MarkerSize', 18)
    
    if asph_bool

        for i = 1:length(Manual_Classfied_Areas.asph)

            % Plot something

            xy_roi = Manual_Classfied_Areas.asph{:,i};

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
    
    if non_road_bool
        
        for i = 1:length(Manual_Classfied_Areas.non_road_roi)

            % Do Something
            xy_roi = Manual_Classfied_Areas.non_road_roi{:,i};

            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor',[1.00, 0.65, 0.30],'FaceAlpha',0.25)

        end

    end
    
    if road_bool
        
        for i = 1:length(Manual_Classfied_Areas.road_roi)

            % Do Something
            xy_roi = Manual_Classfied_Areas.road_roi{:,i};

            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor',[0.58, 0.50, 1.00],'FaceAlpha',0.25)

        end

    end

% end
% 
axis equal

view([0 0 90])

xlim_max = max([grav_array(:,1); asph_array(:,1); foli_array(:,1); gras_array(:,1)]);
xlim_min = min([grav_array(:,1); asph_array(:,1); foli_array(:,1); gras_array(:,1)]);

ylim_max = max([grav_array(:,2); asph_array(:,2); foli_array(:,2); gras_array(:,2)]);
ylim_min = min([grav_array(:,2); asph_array(:,2); foli_array(:,2); gras_array(:,2)]);

xlim([xlim_min xlim_max]);
ylim([ylim_min ylim_max]);

axis off

l = legend({'\color{cyan} Gravel','\color{black} asphseal','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
l.Interpreter = 'tex';

hold off

view([pi/2 0 90])

ax = gca;
ax.Clipping = 'off';

%% Finding raw score value - NO GROUND PLANE FILTER

% Determines the indexes of all the classified points that lie in a
% manually classified areas. Each manually defined area has at least two 

% Gravel

if grav_bool

    for i = 1:length(Manual_Classfied_Areas.grav)

        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.grav{:,i};

        % Grabs the indexes for all the points that lie in the polygon
        grav_in_grav        = inpolygon(grav_array(:,1), grav_array(:,2), xy_roi(:,1), xy_roi(:,2));
        asph_in_grav        = inpolygon(asph_array(:,1), asph_array(:,2), xy_roi(:,1), xy_roi(:,2));
        foli_in_grav        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_grav        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));

        % Gets number of points per result
        grav_in_grav_count  = grav_in_grav_count + length(find(grav_in_grav == 1));
        asph_in_grav_count  = asph_in_grav_count + length(find(asph_in_grav == 1));
        foli_in_grav_count  = foli_in_grav_count + length(find(foli_in_grav == 1));
        gras_in_grav_count  = gras_in_grav_count + length(find(gras_in_grav == 1));

        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_inroad_array       = [grav_inroad_array; find(grav_in_grav == 1)];
        asph_inroad_array       = [asph_inroad_array; find(asph_in_grav == 1)];
        foli_inroad_array       = [foli_inroad_array; find(foli_in_grav == 1)];
        gras_inroad_array       = [gras_inroad_array; find(gras_in_grav == 1)];

        % per-area for later
        grav_used_grav{i} = [find(grav_in_grav == 1)];
        asph_used_grav{i} = [find(asph_in_grav == 1)];
        foli_used_grav{i} = [find(foli_in_grav == 1)];
        gras_used_grav{i} = [find(gras_in_grav == 1)];

    end

end

% asphseal

if asph_bool
    
    for i = 1:1:length(Manual_Classfied_Areas.asph)
        
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.asph{:,i};
        
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_asph        = inpolygon(grav_array(:,1), grav_array(:,2), xy_roi(:,1), xy_roi(:,2));
        asph_in_asph        = inpolygon(asph_array(:,1), asph_array(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_asph        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_asph        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));
        
        % Gets number of points per result
        grav_in_asph_count  = grav_in_asph_count + length(find(grav_in_asph == 1));
        asph_in_asph_count  = asph_in_asph_count + length(find(asph_in_asph == 1));
        foli_in_asph_count  = foli_in_asph_count + length(find(foli_in_asph == 1));
        gras_in_asph_count  = gras_in_asph_count + length(find(gras_in_asph == 1));
        
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_inroad_array       = [grav_inroad_array; find(grav_in_asph == 1)];
        asph_inroad_array       = [asph_inroad_array; find(asph_in_asph == 1)];
        foli_inroad_array       = [foli_inroad_array; find(foli_in_asph == 1)];
        gras_inroad_array       = [gras_inroad_array; find(gras_in_asph == 1)];
        
        % per-area for later
        grav_used_asph{i} = [find(grav_in_asph == 1)];
        asph_used_asph{i} = [find(asph_in_asph == 1)];
        foli_used_asph{i} = [find(foli_in_asph == 1)];
        gras_used_asph{i} = [find(gras_in_asph == 1)];
        
    end
    
end

% Foliage

if foli_bool
    
    for i = 1:1:length(Manual_Classfied_Areas.foli)
        
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.foli{:,i};
        
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_foli        = inpolygon(grav_array(:,1), grav_array(:,2), xy_roi(:,1), xy_roi(:,2));
        asph_in_foli        = inpolygon(asph_array(:,1), asph_array(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_foli        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_foli        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));
        
        % Gets number of points per result
        grav_in_foli_count  = grav_in_foli_count + length(find(grav_in_foli == 1));
        asph_in_foli_count  = asph_in_foli_count + length(find(asph_in_foli == 1));
        foli_in_foli_count  = foli_in_foli_count + length(find(foli_in_foli == 1));
        gras_in_foli_count  = gras_in_foli_count + length(find(gras_in_foli == 1));
        
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_inroad_array       = [grav_inroad_array; find(grav_in_foli == 1)];
        asph_inroad_array       = [asph_inroad_array; find(asph_in_foli == 1)];
        foli_inroad_array       = [foli_inroad_array; find(foli_in_foli == 1)];
        gras_inroad_array       = [gras_inroad_array; find(gras_in_foli == 1)];
        
        % per-area for later
        grav_used_foli{i} = [find(grav_in_foli == 1)];
        asph_used_foli{i} = [find(asph_in_foli == 1)];
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
        asph_in_gras        = inpolygon(asph_array(:,1), asph_array(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_gras        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_gras        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));
    
        % Gets number of points per result
        grav_in_gras_count  = grav_in_gras_count + length(find(grav_in_gras == 1));
        asph_in_gras_count  = asph_in_gras_count + length(find(asph_in_gras == 1));
        foli_in_gras_count  = foli_in_gras_count + length(find(foli_in_gras == 1));
        gras_in_gras_count  = gras_in_gras_count + length(find(gras_in_gras == 1));
    
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_inroad_array       = [grav_inroad_array; find(grav_in_gras == 1)];
        asph_inroad_array       = [asph_inroad_array; find(asph_in_gras == 1)];
        foli_inroad_array       = [foli_inroad_array; find(foli_in_gras == 1)];
        gras_inroad_array       = [gras_inroad_array; find(gras_in_gras == 1)];
    
        % per-area for later
        grav_used_gras{i} = [find(grav_in_gras == 1)];
        asph_used_gras{i} = [find(asph_in_gras == 1)];
        foli_used_gras{i} = [find(foli_in_gras == 1)];
        gras_used_gras{i} = [find(gras_in_gras == 1)];
    
    end
    
end

% non-road

if non_road_bool
    
    for i = 1:1:length(Manual_Classfied_Areas.non_road_roi)
    
        % Grabs the polygon data
        xy_roi              = Manual_Classfied_Areas.non_road_roi{:,i};
        
        % Grabs the indexes for all the points that lie in the polygon
        grav_in_nonroad        = inpolygon(grav_array(:,1), grav_array(:,2), xy_roi(:,1), xy_roi(:,2));
        asph_in_nonroad        = inpolygon(asph_array(:,1), asph_array(:,2), xy_roi(:,1) ,xy_roi(:,2));
        foli_in_nonroad        = inpolygon(foli_array(:,1), foli_array(:,2), xy_roi(:,1), xy_roi(:,2));
        gras_in_nonroad        = inpolygon(gras_array(:,1), gras_array(:,2), xy_roi(:,1), xy_roi(:,2));
    
        % Gets number of points per result
        grav_in_nonroad_count  = grav_in_nonroad_count + length(find(grav_in_nonroad == 1));
        asph_in_nonroad_count  = asph_in_nonroad_count + length(find(asph_in_nonroad == 1));
        foli_in_nonroad_count  = foli_in_nonroad_count + length(find(foli_in_nonroad == 1));
        gras_in_nonroad_count  = gras_in_nonroad_count + length(find(gras_in_nonroad == 1));
    
        % Getting all of the used points (some points lie outside defined areas
        % - unscoreable therefore those points are removed).
        grav_offroad_array       = [grav_offroad_array; find(grav_in_nonroad == 1)];
        asph_offroad_array       = [asph_offroad_array; find(asph_in_nonroad == 1)];
        foli_offroad_array       = [foli_offroad_array; find(foli_in_nonroad == 1)];
        gras_offroad_array       = [gras_offroad_array; find(gras_in_nonroad == 1)];
    
        % per-area for later
        grav_used_offroad{i} = [find(grav_in_nonroad == 1)];
        asph_used_offroad{i} = [find(asph_in_nonroad == 1)];
        foli_used_offroad{i} = [find(foli_in_nonroad == 1)];
        gras_used_offroad{i} = [find(gras_in_nonroad == 1)];
    
    end
    
end



%% Caluclating in-gravel score

if grav_bool
    
    num_used_IN_grav_area = grav_in_grav_count + asph_in_grav_count + foli_in_grav_count + gras_in_grav_count;
    
    num_used_grav = grav_in_grav_count + grav_in_asph_count + grav_in_foli_count + grav_in_gras_count;
    
    grav_in_grav_score = grav_in_grav_count / num_used_IN_grav_area * 100;
    asph_in_grav_score = asph_in_grav_count / num_used_IN_grav_area * 100;
    foli_in_grav_score = foli_in_grav_count / num_used_IN_grav_area * 100;
    gras_in_grav_score = gras_in_grav_count / num_used_IN_grav_area * 100;
    
    score_grav_array = [ grav_in_grav_score; asph_in_grav_score; foli_in_grav_score; gras_in_grav_score];
    
    sum(score_grav_array)
    
    score_grav_area_array = [];
    
else
    
    score_grav_array = [0;0;0;0];
    
end

%% Calculating in-asphseal score

if asph_bool
    
    num_used_IN_asph_area = grav_in_asph_count + asph_in_asph_count + foli_in_asph_count + gras_in_asph_count;
    
    num_used_asph = asph_in_grav_count + asph_in_asph_count + asph_in_foli_count + asph_in_gras_count;
    
    grav_in_asph_score = grav_in_asph_count / num_used_IN_asph_area * 100;
    asph_in_asph_score = asph_in_asph_count / num_used_IN_asph_area * 100;
    foli_in_asph_score = foli_in_asph_count / num_used_IN_asph_area * 100;
    gras_in_asph_score = gras_in_asph_count / num_used_IN_asph_area * 100;
    
    score_asph_array = [grav_in_asph_score; asph_in_asph_score; foli_in_asph_score; gras_in_asph_score];
    
    sum(score_asph_array)
    
else
    
    score_asph_array = [0;0;0;0];
    
end

%% Calulcating in-foliage score

if foli_bool
    
    num_used_IN_foli_area = grav_in_foli_count + asph_in_foli_count + foli_in_foli_count + gras_in_foli_count;
    
    num_used_foli = foli_in_grav_count + foli_in_asph_count + foli_in_foli_count + foli_in_gras_count;
    
    grav_in_foli_score = grav_in_foli_count / num_used_foli * 100;
    asph_in_foli_score = asph_in_foli_count / num_used_foli * 100;
    foli_in_foli_score = foli_in_foli_count / num_used_foli * 100;
    gras_in_foli_score = gras_in_foli_count / num_used_foli * 100;
    
    score_foli_array = [grav_in_foli_score; asph_in_foli_score; foli_in_foli_score; gras_in_foli_score];
    
else
    
    score_foli_array = [0; 0; 0; 0];
    
end

%% Calculating in-grass score

if gras_bool
    
    num_used_IN_gras_area = grav_in_gras_count + asph_in_gras_count + foli_in_gras_count + gras_in_gras_count;
    
    num_used_gras = gras_in_grav_count + gras_in_asph_count + gras_in_foli_count + gras_in_gras_count;
    
    grav_in_gras_score = grav_in_gras_count / num_used_gras * 100;
    asph_in_gras_score = asph_in_gras_count / num_used_gras * 100;
    foli_in_gras_score = foli_in_gras_count / num_used_gras * 100;
    gras_in_gras_score = gras_in_gras_count / num_used_gras * 100;
    
    score_gras_array = [grav_in_gras_score; asph_in_gras_score; foli_in_gras_score; gras_in_gras_score];
    
else
    
    score_gras_array = [0; 0; 0; 0];
    
end

%% Calculating non-road score

if non_road_bool
    
    num_used_IN_nonroad_area = grav_in_nonroad_count + asph_in_nonroad_count + foli_in_nonroad_count + gras_in_nonroad_count;
        
    grav_in_nonroad_score = grav_in_nonroad_count / num_used_IN_nonroad_area * 100;
    asph_in_nonroad_score = asph_in_nonroad_count / num_used_IN_nonroad_area * 100;
    foli_in_nonroad_score = foli_in_nonroad_count / num_used_IN_nonroad_area * 100;
    gras_in_nonroad_score = gras_in_nonroad_count / num_used_IN_nonroad_area * 100;
    
    score_nonroad_array = [grav_in_nonroad_score; asph_in_nonroad_score; foli_in_nonroad_score; gras_in_nonroad_score];
    
else
    
    score_nonroad_array = [0; 0; 0; 0];
    
end

%% Calculating in-road score

if road_bool
    
    num_used_IN_road_area = grav_in_road_count + asph_in_road_count + foli_in_road_count + gras_in_road_count;
    
    num_used_inroad = foli_in_grav_count + foli_in_asph_count + foli_in_foli_count + foli_in_gras_count;
    
    grav_in_road_score = grav_in_road_count / num_used_inroad * 100;
    asph_in_road_score = asph_in_road_count / num_used_inroad * 100;
    foli_in_road_score = foli_in_road_count / num_used_inroad * 100;
    gras_in_road_score = gras_in_road_count / num_used_inroad * 100;
    
    score_road_array = [grav_in_road_score; asph_in_road_score; foli_in_road_score; gras_in_road_score];
    
else
    
    score_road_array = [0; 0; 0; 0];
    
end


%% Overall Score

tot_num_used = length(grav_inroad_array) + length(asph_inroad_array) + length(foli_inroad_array) + length(gras_inroad_array);

tot_num_non_road = length(grav_offroad_array) + length(asph_offroad_array) + length(foli_offroad_array) + length(gras_offroad_array);

% Gravel row
score_overall_array(1,1) = grav_in_grav_count / tot_num_used * 100;
score_overall_array(1,2) = grav_in_asph_count / tot_num_used * 100;
score_overall_array(1,3) = grav_in_foli_count / tot_num_used * 100;
score_overall_array(1,4) = grav_in_gras_count / tot_num_used * 100;

% asphseal Row
score_overall_array(2,1) = asph_in_grav_count / tot_num_used * 100;
score_overall_array(2,2) = asph_in_asph_count / tot_num_used * 100;
score_overall_array(2,3) = asph_in_foli_count / tot_num_used * 100;
score_overall_array(2,4) = asph_in_gras_count / tot_num_used * 100;

% Foliage Row
score_overall_array(3,1) = foli_in_grav_count / tot_num_used * 100;
score_overall_array(3,2) = foli_in_asph_count / tot_num_used * 100;
score_overall_array(3,3) = foli_in_foli_count / tot_num_used * 100;
score_overall_array(3,4) = foli_in_gras_count / tot_num_used * 100;

% Grass Row
score_overall_array(4,1) = gras_in_grav_count / tot_num_used * 100;
score_overall_array(4,2) = gras_in_asph_count / tot_num_used * 100;
score_overall_array(4,3) = gras_in_foli_count / tot_num_used * 100;
score_overall_array(4,4) = gras_in_gras_count / tot_num_used * 100;

% Off Road Column
score_offroad_array(1,1) = grav_in_nonroad_count / tot_num_non_road * 100;
score_offroad_array(2,1) = asph_in_nonroad_count / tot_num_non_road * 100;
score_offroad_array(3,1) = foli_in_nonroad_count / tot_num_non_road * 100;
score_offroad_array(4,1) = gras_in_nonroad_count / tot_num_non_road * 100;

%% Table of Results - Confusion Matrix

table_name = {'Gravel' 'asphseal' 'Foliage' 'Grass'};

score_table = array2table(score_overall_array, 'VariableNames',table_name,'RowNames', table_name);

%% Table of Results Including Off-Road - Confusion Matrix

score_array_SoR = [score_overall_array, score_offroad_array];

table_name_offroad = {'Gravel' 'asphseal' 'Foliage' 'Grass' 'SoR'};

score_table_SoR = array2table(score_array_SoR, 'VariableNames',table_name_offroad,'RowNames', table_name);

score_table_SoR(:,[1,5])
score_table_SoR(:,[1,2,5])

%% Table of Results - Per-Area

score_area_array = [score_grav_array, score_asph_array, score_foli_array, score_gras_array];

table_name = {'Gravel' 'asphseal' 'Foliage' 'Grass'};

score_table = array2table(score_area_array, 'VariableNames',table_name,'RowNames', table_name);

%% Table of Results Including Off-Road - Per-Area

score_area_array_SoR = [score_area_array, score_offroad_array];

score_array_SoR = [score_overall_array, score_offroad_array];

table_name_offroad = {'Gravel' 'asphseal' 'Foliage' 'Grass' 'SoR'};

score_table_SoR = array2table(score_area_array_SoR, 'VariableNames',table_name_offroad,'RowNames', table_name);

score_table_SoR(:,[1,5])
score_table_SoR(:,[1,2,5])




%% Plot only used points
% 
% figure
% 
% hold all
% 
% plot3(grav_array(grav_inroad_array,1), grav_array(grav_inroad_array,2), grav_array(grav_inroad_array,3), 'c.', 'MarkerSize', 18)
% plot3(asph_array(asph_inroad_array,1), asph_array(asph_inroad_array,2), asph_array(asph_inroad_array,3), 'k.', 'MarkerSize', 18)
% plot3(gras_array(gras_inroad_array,1), gras_array(gras_inroad_array,2), gras_array(gras_inroad_array,3), 'g.', 'MarkerSize', 18)
% 
% plot3(grav_array(grav_offroad_array,1), grav_array(grav_offroad_array,2), grav_array(grav_offroad_array,3), 'c.', 'MarkerSize', 18)
% plot3(asph_array(asph_offroad_array,1), asph_array(asph_offroad_array,2), asph_array(asph_offroad_array,3), 'k.', 'MarkerSize', 18)
% plot3(gras_array(gras_offroad_array,1), gras_array(gras_offroad_array,2), gras_array(gras_offroad_array,3), 'g.', 'MarkerSize', 18)
% 
% if asph_bool
%     
%     for i = 1:length(Manual_Classfied_Areas.asph)
%     
%         % Plot something
%     
%         xy_roi = Manual_Classfied_Areas.asph{:,i};
%     
%         pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
%         plot(pgon,'FaceColor','black','FaceAlpha',0.25)
%     
%     end
%     
% end
% 
% if grav_bool
%     
%     for i = 1:length(Manual_Classfied_Areas.grav)
%         
%         % Plot something
%         xy_roi = Manual_Classfied_Areas.grav{:,i};
%         
%         pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
%         plot(pgon,'FaceColor','red','FaceAlpha',0.25)
%         
%     end
%     
% end
% 
% 
% if gras_bool
%     
%     for i = 1:length(Manual_Classfied_Areas.gras)
%     
%         % Plot Something
%         xy_roi = Manual_Classfied_Areas.gras{:,i};
%     
%         pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
%         plot(pgon,'FaceColor','green','FaceAlpha',0.25)
%     
%     end
%     
% end
% 
% if non_road_bool
% 
%     for i = 1:length(Manual_Classfied_Areas.non_road_roi)
% 
%         % Do Something
%         xy_roi = Manual_Classfied_Areas.non_road_roi{:,i};
% 
%         pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
%         plot(pgon,'FaceColor',[1.00, 0.65, 0.30],'FaceAlpha',0.25)
% 
%     end
% 
% end
% 
% if road_bool
% 
%     for i = 1:length(Manual_Classfied_Areas.road_roi)
% 
%         % Do Something
%         xy_roi = Manual_Classfied_Areas.road_roi{:,i};
% 
%         pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
%         plot(pgon,'FaceColor',[0.58, 0.50, 1.00],'FaceAlpha',0.25)
% 
%     end
% 
% end
% 
% axis equal
% 
% view([0 0 90])
% %
% % xlim_max = max([grav_array(:,1); asph_array(:,1); gras_array(:,1)]);
% % xlim_min = min([grav_array(:,1); asph_array(:,1); gras_array(:,1)]);
% %
% % ylim_max = max([grav_array(:,2); asph_array(:,2); gras_array(:,2)]);
% % ylim_min = min([grav_array(:,2); asph_array(:,2); gras_array(:,2)]);
% %
% % xlim([xlim_min xlim_max]);
% % ylim([ylim_min ylim_max]);
% 
% axis off
% 
% hold off
% 
% l = legend({'\color{cyan} Gravel','\color{black} Pavement','\color{magenta} Foliage','\color{green} Grass'}, 'FontSize', 36, 'FontWeight', 'bold', 'LineWidth', 4);
% l.Interpreter = 'tex';
% 
% view([pi/2 0 90])
% 
% ax = gca;
% ax.Clipping = 'off';
% 


%% Display the standard end of program notification which consists of a single line of text being printed unto the command window resulting in the user of this program being informed that the program has completed successfully
% [asdf, qwer, zxcv] = fileparts(root_dir);
% disp(asdf)
% disp(qwer)
% disp(zxcv)
disp('End Program!')


