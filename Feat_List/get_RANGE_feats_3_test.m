% This function just gets a great big table
function table_export = get_RANGE_feats_3_test(xyzi)
    
    %% Table Header
    table_head   = {'StandDevRange',...
                    'RoughnessRange',...
                    'MinMaxRatioRange',...
                    'Min2MaxRatioRange',...
                    'MagGradientRange',...
                    'StandDevInt',...
                    'MeanInt',...
                    'RangeInt',...
                    'MedMaxRatioInt',...
                    'Med2MaxRatioInt',...
                    'MagGradientInt',...
                    'XYMinMaxDist'};

    %% Getting height, range, z, intensity

    % Range ratio factor
    LiDAR_range                 = sqrt((xyzi(:,1)).^2 + (xyzi(:,2)).^2 + (xyzi(:,3)).^2);
    range_mean                  = mean(LiDAR_range);

    %% Feat Extract
    
    data_data    = [std(LiDAR_range) / range_mean,...
                    (max(LiDAR_range) - min(LiDAR_range)) / range_mean,...
                    min(LiDAR_range) / max(LiDAR_range),...
                    (min(LiDAR_range).^2 / max(LiDAR_range)) / range_mean,...
                    sqrt(sum(gradient(LiDAR_range).^2)) / range_mean,...
                    double(std(xyzi(:,4))),...
                    double(mean(xyzi(:,4))),...
                    max(xyzi(:,4)) - min(xyzi(:,4)),...
                    median(xyzi(:,4)) / max(xyzi(:,4)),...
                    median(xyzi(:,4)).^2 / max(xyzi(:,4)),...
                    sqrt(sum(gradient(xyzi(:,4)).^2)),...
                    sqrt((xyzi(end,1) - xyzi(1,1))^2 + (xyzi(end,2) - xyzi(1,2))^2)];

%     data_data = [std(range),...
%     max(range) - min(range),...
%     min(range) / max(range),...
%     min(range)^2 / max(range),...
%     sqrt(sum(gradient(range).^2)),...
%     std(range) / range_mean,...
%     (max(range) - min(range)) / range_mean,...
%     (min(range) / max(range)) / range_mean,...
%     (min(range)^2 / max(range)) / range_mean,...
%     sqrt(sum(gradient(range).^2)) / range_mean,...
%     std(xyzi(:,4)),...
%     max(xyzi(:,4)) - min(xyzi(:,4)),...
%     min(xyzi(:,4)) / max(xyzi(:,4)),...
%     min(xyzi(:,4))^2 / max(xyzi(:,4)),...
%     sqrt(sum(gradient(xyzi(:,4)).^2)),...
%     std(xyzi(:,4)) / range_mean,...
%     (max(xyzi(:,4)) - min(xyzi(:,4))) / range_mean,...
%     (min(xyzi(:,4)) / max(xyzi(:,4))) / range_mean,...
%     (min(xyzi(:,4))^2 / max(xyzi(:,4))) / range_mean,...
%     sqrt(sum(gradient(xyzi(:,4)).^2)) / range_mean];
    
    %% Creating the Table
    
    table_export = array2table(data_data, 'VariableNames', table_head);
    
    
   %% REFERENCE
% 
%     StandDevHeight              = double(std(height));
%     MeanHeight                  = double(mean(height));
%     MinHeight                   = double(min(height));
%     MaxHeight                   = double(max(height));
%     MedHeight                   = double(median(height));
%     RoughnessHeight             = double(MaxHeight - min(height));
%     MinMaxRatioHeight           = double(MinHeight / MaxHeight);
%     Min2MaxRatioHeight          = double(MinHeight^2 / MaxHeight);
%     MagGradientHeight           = double(sqrt(sum(gradient(height).^2)));
% 
%     StandDevHeightXYDist        = double(std(height) / xy_dist);
%     MeanHeightXYDist            = double(mean(height) / xy_dist);
%     MinHeightXYDist             = double(min(height) / xy_dist);
%     MaxHeightXYDist             = double(max(height) / xy_dist);
%     MedHeightXYDist             = double(median(height) / xy_dist);
%     RoughnessHeightXYDist       = double(MaxHeightXYDist - MinHeightXYDist);
%     MinMaxRatioHeightXYDist     = double(MinHeightXYDist / MaxHeightXYDist);
%     Min2MaxRatioHeightXYDist    = double(MinHeightXYDist^2 / MaxHeightXYDist);
%     MagGradientHeightXYDist     = double(sqrt(sum(gradient(height).^2)) / xy_dist);
% 
%     StandDevHeightRange         = double(std(height) / range_mean);
%     MeanHeightRange             = double(mean(height) / range_mean);
%     MinHeightRange              = double(min(height) / range_mean);
%     MaxHeightRange              = double(max(height) / range_mean);
%     MedHeightRange              = double(median(height) / range_mean);
%     RoughnessHeightRange        = double(MaxHeightRange - MinHeightRange);
%     MinMaxRatioHeightRange      = double(MinHeightRange / MaxHeightRange);
%     Min2MaxRatioHeightRange     = double(MinHeightRange^2 / MaxHeightRange);
%     MagGradientHeightRange      = double(sqrt(sum(gradient(height).^2)) / range_mean);
% 
%     % Getting RANGE Spatial Properties
% 
%     StandDevRange               = double(std(range));
%     MeanRange                   = double(mean(range));
%     MinRange                    = double(min(range));
%     MaxRange                    = double(max(range));
%     MedRange                    = double(median(range));
%     RoughnessRange              = double(MaxRange - MinRange);
%     MinMaxRatioRange            = double(MinRange / MaxRange);
%     Min2MaxRatioRange           = double(MinRange^2 / MaxRange);
%     MagGradientRange            = double(sqrt(sum(gradient(range).^2)));
% 
%     StandDevRangeXYDist         = double(std(range) / xy_dist);
%     MeanRangeXYDist             = double(mean(range) / xy_dist);
%     MinRangeXYDist              = double(min(range) / xy_dist);
%     MaxRangeXYDist              = double(max(range) / xy_dist);
%     MedRangeXYDist              = double(median(range) / xy_dist);
%     RoughnessRangeXYDist        = double(MaxRangeXYDist - MinRangeXYDist);
%     MinMaxRatioRangeXYDist      = double(MinRangeXYDist / MaxRangeXYDist);
%     Min2MaxRatioRangeXYDist     = double(MinRangeXYDist^2 / MaxRangeXYDist);
%     MagGradientRangeXYDist      = double(sqrt(sum(gradient(range).^2)) / xy_dist);
% 
%     StandDevRangeRange          = double(std(range) / range_mean);
%     MeanRangeRange              = double(mean(range) / range_mean);
%     MinRangeRange               = double(min(range) / range_mean);
%     MaxRangeRange               = double(max(range) / range_mean);
%     MedRangeRange               = double(median(range) / range_mean);
%     RoughnessRangeRange         = double(MaxRangeRange - MinRangeRange);
%     MinMaxRatioRangeRange       = double(MinRangeRange / MaxRangeRange);
%     Min2MaxRatioRangeRange      = double(MinRangeRange^2 / MaxRangeRange);
%     MagGradientRangeRange       = double(sqrt(sum(gradient(range).^2)) / range_mean);
% 
%     % Getting Height from the Zero plane (literally just z lol)
% 
%     StandDevZ                   = double(std(xyzi(:,3)));
%     MeanZ                       = double(mean(xyzi(:,3)));
%     MinZ                        = double(min(xyzi(:,3)));
%     MaxZ                        = double(max(xyzi(:,3)));
%     MedZ                        = double(median(xyzi(:,3)));
%     RoughnessZ                  = double(MaxZ - MinZ);
%     MinMaxRatioZ                = double(MinZ / MaxZ);
%     Min2MaxRatioZ               = double(MinZ^2 / MaxZ);
%     MagGradientZ                = double(sqrt(sum(gradient(xyzi(:,3)).^2)));
% 
%     StandDevZXYDist             = double(std(xyzi(:,3)) / xy_dist);
%     MeanZXYDist                 = double(mean(xyzi(:,3)) / xy_dist);
%     MinZXYDist                  = double(min(xyzi(:,3)) / xy_dist);
%     MaxZXYDist                  = double(max(xyzi(:,3)) / xy_dist);
%     MedZXYDist                  = double(median(xyzi(:,3)) / xy_dist);
%     RoughnessZXYDist            = double(MaxZXYDist - MinZXYDist);
%     MinMaxRatioZXYDist          = double(MinZXYDist / MaxZXYDist);
%     Min2MaxRatioZXYDist         = double(MinZXYDist^2 / MaxZXYDist);
%     MagGradientZXYDist          = double(sqrt(sum(gradient(xyzi(:,3)).^2)) / xy_dist);
% 
%     StandDevZRange              = double(std(xyzi(:,3)) / range_mean);
%     MeanZRange                  = double(mean(xyzi(:,3)) / range_mean);
%     MinZRange                   = double(min(xyzi(:,3)) / range_mean);
%     MaxZRange                   = double(max(xyzi(:,3)) / range_mean);
%     MedZRange                   = double(median(xyzi(:,3)) / range_mean);
%     RoughnessZRange             = double(MaxZRange - MinZRange);
%     MinMaxRatioZRange           = double(MinZRange / MaxZRange);
%     Min2MaxRatioZRange          = double(MinZRange^2 / MaxZRange);
%     MagGradientZRange           = double(sqrt(sum(gradient(xyzi(:,3)).^2)) / range_mean);
% 
%     %% REMISION FEATURES CALCULATED AND SAVED
% 
%     StandDevInt                 = double(std(xyzi(:,4)));
%     MeanInt                     = double(mean(xyzi(:,4)));
%     MinInt                      = double(min(xyzi(:,4)));
%     MaxInt                      = double(max(xyzi(:,4)));
%     MedInt                      = double(median(xyzi(:,4)));
%     RangeInt                    = double(MaxInt - MinInt);
%     MinMaxRatioInt              = double(MinInt / MaxInt);
%     Min2MaxRatioInt             = double(MinInt^2 / MaxInt);
%     MagGradientInt              = double(sqrt(sum(gradient(xyzi(:,4)).^2)));
% 
%     StandDevIntXYDist           = double(std(xyzi(:,4)) / xy_dist);
%     MeanIntXYDist               = double(mean(xyzi(:,4)) / xy_dist);
%     MinIntXYDist                = double(min(xyzi(:,4)) / xy_dist);
%     MaxIntXYDist                = double(max(xyzi(:,4)) / xy_dist);
%     MedIntXYDist                = double(median(xyzi(:,4)) / xy_dist);
%     RangeIntXYDist              = double(MaxIntXYDist - MinIntXYDist);
%     MinMaxRatioIntXYDist        = double(MinIntXYDist / MaxIntXYDist);
%     Min2MaxRatioIntXYDist       = double(MinIntXYDist^2 / MaxIntXYDist);
%     MagGradientIntXYDist        = double(sqrt(sum(gradient(xyzi(:,4)).^2)) / xy_dist);
% 
%     StandDevIntRange            = double(std(xyzi(:,4)) / range_mean);
%     MeanIntRange                = double(mean(xyzi(:,4)) / range_mean);
%     MinIntRange                 = double(min(xyzi(:,4)) / range_mean);
%     MaxIntRange                 = double(max(xyzi(:,4)) / range_mean);
%     MedIntRange                 = double(median(xyzi(:,4)) / range_mean);
%     RangeIntRange               = double(MaxIntRange - MinIntRange);
%     MinMaxRatioIntRange         = double(MinIntRange / MaxIntRange);
%     Min2MaxRatioIntRange        = double(MinIntRange^2 / MaxIntRange);
%     MagGradientIntRange         = double(sqrt(sum(gradient(xyzi(:,4)).^2)) / range_mean);
    
end