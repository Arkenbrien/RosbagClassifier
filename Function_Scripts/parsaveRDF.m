function parsaveRDF(Filename_Overall, Overall_Acc, conf_mat, NumTrees, NumPredictorsToSample, MaxNumSplits, Overall_RDF_Validation_Time, Quadrant_Classification_Time, size_tester_table)
        
    RDF_RESULTS.Overall_Acc                 = Overall_Acc;
    RDF_RESULTS.conf_mat                    = conf_mat;
    RDF_RESULTS.Validation_Time             = Overall_RDF_Validation_Time;
    RDF_RESULTS.Quadrant_Class_Time         = Quadrant_Classification_Time;
    RDF_RESULTS.NumTrees                    = NumTrees;
    RDF_RESULTS.NumPredictorsToSample       = NumPredictorsToSample;
    RDF_RESULTS.MaxNumSplits                = MaxNumSplits;
    RDF_RESULTS.Test_Size                   = size_tester_table;
    
    % Save it
    save(Filename_Overall, 'RDF_RESULTS')
        
end