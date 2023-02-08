% This function just gets a great big table
function Mdl_Trainer_Table = getfeaturenamearray(table_extract)
    
    %% BOOL logic to select which features to use out of the training data
    
    % SPATIAL
    
    %% Height
    
    % Examining the height from reference plane
    StandDevHeight_bool             = 0;
    MeanHeight_bool                 = 0;
    MinHeight_bool                  = 0;
    MaxHeight_bool                  = 0;
    MedHeight_bool                  = 0;
    RoughnessHeight_bool            = 0;
    MinMaxRatioHeight_bool          = 0;
    Min2MaxRatioHeight_bool         = 0;
    MagGradientHeight_bool          = 0;
    
    % Examining the height from reference plane / XY Distance
    StandDevHeightXYDist_bool       = 0;
    MeanHeightXYDist_bool           = 0;
    MinHeightXYDist_bool            = 0;
    MaxHeightXYDist_bool            = 0;
    MedHeightXYDist_bool            = 0;
    RoughnessHeightXYDist_bool      = 0;
    MinMaxRatioHeightXYDist_bool    = 0;
    Min2MaxRatioHeightXYDist_bool   = 0;
    MagGradientHeightXYDist_bool    = 0;
    
    % Examining the height from reference plane / Range to LiDAR
    StandDevHeightRange_bool        = 0;
    MeanHeightRange_bool            = 0;
    MinHeightRange_bool             = 0;
    MaxHeightRange_bool             = 0;
    MedHeightRange_bool             = 0;
    RoughnessHeightRange_bool       = 0;
    MinMaxRatioHeightRange_bool     = 0;
    Min2MaxRatioHeightRange_bool    = 0;
    MagGradientHeightRange_bool     = 0;
    
    %% Range
    
    % Examining the range from LiDAR
    StandDevRange_bool              = 1;
    MeanRange_bool             		= 0;
    MinRange_bool             		= 0;
    MaxRange_bool             		= 0;
    MedRange_bool             		= 0;
    RoughnessRange_bool             = 1;
    MinMaxRatioRange_bool           = 1;
    Min2MaxRatioRange_bool          = 1;
    MagGradientRange_bool           = 1;
    
    % Examining the range from LiDAR / XY Dist
    StandDevRangeXYDist_bool        = 0;
    MeanRangeXYDist_bool            = 0;
    MinRangeXYDist_bool             = 0;
    MaxRangeXYDist_bool             = 0;
    MedRangeXYDist_bool             = 0;
    RoughnessRangeXYDist_bool       = 0;
    MinMaxRatioRangeXYDist_bool     = 0;
    Min2MaxRatioRangeXYDist_bool    = 0;
    MagGradientRangeXYDist_bool     = 0;
    
    % Examining the range from LiDAR / Range
    StandDevRangeRange_bool         = 1;
    MeanRangeRange_bool             = 0;
    MinRangeRange_bool             	= 0;
    MaxRangeRange_bool             	= 0;
    MedRangeRange_bool             	= 0;
    RoughnessRangeRange_bool        = 1;
    MinMaxRatioRangeRange_bool      = 1;
    Min2MaxRatioRangeRange_bool     = 1;
    MagGradientRangeRange_bool      = 1;
    
    %% Z
    
    % Examining the Z from LiDAR
    StandDevZ_bool                  = 0;
    MeanZ_bool                      = 0;
    MinZ_bool                       = 0;
    MaxZ_bool                       = 0;
    MedZ_bool                       = 0;
    RoughnessZ_bool                 = 0;
    MinMaxRatioZ_bool               = 0;
    Min2MaxRatioZ_bool              = 0;
    MagGradientZ_bool               = 0;
    
    % Examining the Z from LiDAR / XY Dist
    StandDevZXYDist_bool            = 0;
    MeanZXYDist_bool                = 0;
    MinZXYDist_bool                 = 0;
    MaxZXYDist_bool                 = 0;
    MedZXYDist_bool                 = 0;
    RoughnessZXYDist_bool           = 0;
    MinMaxRatioZXYDist_bool         = 0;
    Min2MaxRatioZXYDist_bool        = 0;
    MagGradientZXYDist_bool         = 0;
    
    % Examining the Z from LiDAR / Z
    StandDevZRange_bool             = 0;
    MeanZRange_bool                 = 0;
    MinZRange_bool                  = 0;
    MaxZRange_bool                  = 0;
    MedZRange_bool                  = 0;
    RoughnessZRange_bool            = 0;
    MinMaxRatioZRange_bool          = 0;
    Min2MaxRatioZRange_bool         = 0;
    MagGradientZRange_bool          = 0;
    
    %% SW - Spatial
        
    % Test for normal distribution for Range Height Z
    SwHHeight_bool                  = 0;
    SwpValueHeight_bool             = 0;
    SwWHeight_bool                  = 0;
    
    SwHRange_bool             		= 0;
    SwpValueRange_bool             	= 0;
    SwWRange_bool             		= 0;
    
    SwHZ_bool                       = 0;
    SwpValueZ_bool                  = 0;
    SwWZ_bool                       = 0;

    %% REMISSION
    
    % Examining intensity
    StandDevInt_bool             	= 1;
    MeanInt_bool             		= 0;
    MinInt_bool             		= 0;
    MaxInt_bool             		= 0;
    MedInt_bool             		= 0;
    RangeInt_bool             		= 1;
    MinMaxRatioInt_bool             = 1;
    Min2MaxRatioInt_bool            = 1;
    MagGradientInt_bool             = 1;
    
    % Examining intensity / height
    StandDevIntXYDist_bool          = 0;
    MeanIntXYDist_bool             	= 0;
    MinIntXYDist_bool             	= 0;
    MaxIntXYDist_bool             	= 0;
    MedIntXYDist_bool             	= 0;
    RangeIntXYDist_bool             = 0;
    MinMaxRatioIntXYDist_bool       = 0;
    Min2MaxRatioIntXYDist_bool      = 0;
    MagGradientIntXYDist_bool       = 0;
    
    % Examining intensity / range
    StandDevIntRange_bool           = 1;
    MeanIntRange_bool             	= 0;
    MinIntRange_bool             	= 0;
    MaxIntRange_bool             	= 0;
    MedIntRange_bool             	= 0;
    RangeIntRange_bool             	= 1;
    MinMaxRatioIntRange_bool        = 1;
    Min2MaxRatioIntRange_bool       = 1;
    MagGradientIntRange_bool        = 1;
    
    %% SW - Remission
   
    % Tests for normal distribution of Intensity
    SwHInt_bool             		= 0;
    SwpValueInt_bool             	= 0;
    SwWInt_bool             		= 0;

    %% Bool Array
    
    % This just creates a table with all the bools
    feat_array_table = [StandDevHeight_bool
    MeanHeight_bool
    MinHeight_bool
    MaxHeight_bool
    MedHeight_bool
    RoughnessHeight_bool
    MinMaxRatioHeight_bool
    Min2MaxRatioHeight_bool
    MagGradientHeight_bool
    StandDevHeightXYDist_bool
    MeanHeightXYDist_bool
    MinHeightXYDist_bool
    MaxHeightXYDist_bool
    MedHeightXYDist_bool
    RoughnessHeightXYDist_bool
    MinMaxRatioHeightXYDist_bool
    Min2MaxRatioHeightXYDist_bool
    MagGradientHeightXYDist_bool
    StandDevHeightRange_bool
    MeanHeightRange_bool
    MinHeightRange_bool
    MaxHeightRange_bool
    MedHeightRange_bool
    RoughnessHeightRange_bool
    MinMaxRatioHeightRange_bool
    Min2MaxRatioHeightRange_bool
    MagGradientHeightRange_bool
    StandDevRange_bool
    MeanRange_bool
    MinRange_bool
    MaxRange_bool
    MedRange_bool
    RoughnessRange_bool
    MinMaxRatioRange_bool
    Min2MaxRatioRange_bool
    MagGradientRange_bool
    StandDevRangeXYDist_bool
    MeanRangeXYDist_bool
    MinRangeXYDist_bool
    MaxRangeXYDist_bool
    MedRangeXYDist_bool
    RoughnessRangeXYDist_bool
    MinMaxRatioRangeXYDist_bool
    Min2MaxRatioRangeXYDist_bool
    MagGradientRangeXYDist_bool
    StandDevRangeRange_bool
    MeanRangeRange_bool
    MinRangeRange_bool
    MaxRangeRange_bool
    MedRangeRange_bool
    RoughnessRangeRange_bool
    MinMaxRatioRangeRange_bool
    Min2MaxRatioRangeRange_bool
    MagGradientRangeRange_bool
    StandDevZ_bool
    MeanZ_bool		
    MinZ_bool		
    MaxZ_bool		
    MedZ_bool		
    RoughnessZ_bool
    MinMaxRatioZ_bool
    Min2MaxRatioZ_bool
    MagGradientZ_bool
    StandDevZXYDist_bool
    MeanZXYDist_bool
    MinZXYDist_bool
    MaxZXYDist_bool
    MedZXYDist_bool
    RoughnessZXYDist_bool
    MinMaxRatioZXYDist_bool
    Min2MaxRatioZXYDist_bool
    MagGradientZXYDist_bool
    StandDevZRange_bool
    MeanZRange_bool
    MinZRange_bool
    MaxZRange_bool
    MedZRange_bool
    RoughnessZRange_bool
    MinMaxRatioZRange_bool
    Min2MaxRatioZRange_bool
    MagGradientZRange_bool
    SwHHeight_bool
    SwpValueHeight_bool
    SwWHeight_bool
    SwHRange_bool
    SwpValueRange_bool
    SwWRange_bool
    SwHZ_bool
    SwpValueZ_bool
    SwWZ_bool
    StandDevInt_bool
    MeanInt_bool
    MinInt_bool
    MaxInt_bool
    MedInt_bool
    RangeInt_bool
    MinMaxRatioInt_bool
    Min2MaxRatioInt_bool
    MagGradientInt_bool
    StandDevIntXYDist_bool
    MeanIntXYDist_bool
    MinIntXYDist_bool
    MaxIntXYDist_bool
    MedIntXYDist_bool
    RangeIntXYDist_bool
    MinMaxRatioIntXYDist_bool
    Min2MaxRatioIntXYDist_bool
    MagGradientIntXYDist_bool
    StandDevIntRange_bool
    MeanIntRange_bool
    MinIntRange_bool
    MaxIntRange_bool
    MedIntRange_bool
    RangeIntRange_bool
    MinMaxRatioIntRange_bool
    Min2MaxRatioIntRange_bool
    MagGradientIntRange_bool
    SwHInt_bool
    SwpValueInt_bool
    SwWInt_bool]';

    feat_array_table = double(feat_array_table);
    
    %% Getting the index of all the 1's
    feat_bool_idx   = find(feat_array_table == 1);
    
    %% Sanity Check for length of feat_bool_idx
    sanity_check    = length(feat_bool_idx);
    
    %% Grabbing the desired data from the table
    
    Mdl_Trainer_Table = table_extract(:,feat_bool_idx);
    
end