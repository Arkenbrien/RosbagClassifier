function area_export = unknownArea(area_export, tformed_area)

    area_export.area                = tformed_area;
    area_export.clas                = 'unknown';
    area_export.points              = [NaN, NaN, NaN];
    area_export.tot_percent         = [0, 0, 0];
    area_export.Slope_c24           = NaN;
    area_export.Slope_c24_minmax    = NaN;

    % C2
    area_export.minDistance_c2      = NaN;
    area_export.maxDistance_c2      = NaN;
    area_export.meanDistance_c2     = NaN;
    area_export.stdDistance_c2      = NaN;
    area_export.stdHeight_c2        = NaN;
    area_export.meanHeight_c2       = NaN;

    % C3
    area_export.minDistance_c3      = NaN;
    area_export.maxDistance_c3      = NaN;
    area_export.meanDistance_c3     = NaN;
    area_export.stdDistance_c3      = NaN;
    area_export.stdHeight_c3        = NaN;
    area_export.meanHeight_c3       = NaN;

    % C4
    area_export.minDistance_c4      = NaN;
    area_export.maxDistance_c4      = NaN;
    area_export.meanDistance_c4     = NaN;
    area_export.stdDistance_c4      = NaN;
    area_export.stdHeight_c4        = NaN;
    area_export.meanHeight_c4       = NaN;

    % C2 -> C3
    area_export.DistBetween_c23     = NaN;
    area_export.Slope_c23           = NaN;

    % C3 -> C4
    area_export.DistBetween_c34     = NaN;
    area_export.Slope_c34           = NaN;

    % C2 -> C4
    area_export.d43_32_ratio        = NaN;

end