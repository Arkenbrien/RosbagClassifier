%% Results Rate Plotter on a single plot plotting program that doos the plots

% Just load the results rate . mat file lol

hold on

% reference:

% RESULTS_RATE.quadrant_rate = quadrant_rate;
% RESULTS_RATE.size_xyzi = size_xyzi;
% RESULTS_RATE.feat_grab_time = feat_grab_time;
% RESULTS_RATE.plane_proj_time = plane_proj_time;
% RESULTS_RATE.class_rate  = class_rate;

% Getting avg
avg_quadrant_rate = mean(RESULTS_RATE.quadrant_rate);
avg_feat_grab_time = mean(RESULTS_RATE.feat_grab_time);
avg_plane_proj_time = mean(RESULTS_RATE.plane_proj_time);
avg_class_rate = mean(RESULTS_RATE.class_rate);

sum_all = avg_feat_grab_time + avg_plane_proj_time + avg_class_rate;
percent_feat_grab = avg_feat_grab_time * 100 / sum_all;
percent_plane_proj = avg_plane_proj_time * 100 / sum_all;
percent_class_rate = avg_class_rate * 100 / sum_all;

sum_all = avg_feat_grab_time + avg_plane_proj_time + avg_class_rate;
percent_feat_grab_2 = avg_feat_grab_time * 100 / sum_all;
percent_plane_proj_2 = avg_plane_proj_time * 100 / sum_all;
percent_class_rate_2 = avg_class_rate * 100 / sum_all;

round_num = 2;

% plot it

figure
X = categorical({'Extraction','Projection','Classification'});
X = reordercats(X,{'Extraction','Projection','Classification'});
Y = [avg_feat_grab_time avg_plane_proj_time avg_class_rate];
b = bar(X,Y, 'r')

xtips2 = b.XEndPoints;
ytips2 = b.YEndPoints;
labels2 = string([round(percent_feat_grab, round_num)+"%" round(percent_plane_proj, round_num)+"%" round(percent_class_rate, round_num)+"%"]);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center', 'VerticalAlignment','bottom')




