function parsaveITR(Filename_Overall, Overall_Acc, grav_acc, chip_acc, foli_acc, gras_acc, NumTrees, NumPredictorsToSample, Cost, MaxNumSplits, result_array, Validation_Time)
    
    result_table_header = {'Gravel', 'Chipseal', 'Foliage', 'Grass'};
    
    RDF_RESULTS.result_table        = array2table(result_array,'VariableNames',result_table_header,'RowNames',result_table_header);
    RDF_RESULTS.Overall_Acc         =Overall_Acc;
    RDF_RESULTS.grav_acc            = grav_acc;
    RDF_RESULTS.chip_acc            = chip_acc;
    RDF_RESULTS.foli_acc            = foli_acc;
    RDF_RESULTS.gras_acc            = gras_acc;
    RDF_RESULTS.Validation_Time     = Validation_Time;
    RDF_RESULTS.NumTrees                    = NumTrees;
    RDF_RESULTS.NumPredictorsToSample       = NumPredictorsToSample;
    RDF_RESULTS.Cost                        = Cost;
    RDF_RESULTS.MaxNumSplits                = MaxNumSplits;
    
    % Save it
    save(Filename_Overall, 'RDF_RESULTS')
        
end
