function export_location = get_export_location(options)
    if options.custom_export_bool
        export_location = uigetdir('/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/','Get Export Directory');
        addpath(export_location);
    elseif options.reference_point == "range"
        options.export_location  = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/RANGE_RAW/';
    elseif options.reference_point == "ransac"
        options.export_location  = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/RANSAC_RAW/';
    elseif options.reference_point == "mls"
        options.export_location  = '/media/autobuntu/chonk/chonk/git_repos/PCD_STACK_RDF_CLASSIFIER/CLASSIFICATION_RESULTS/MLS_RAW/';
    end 
end