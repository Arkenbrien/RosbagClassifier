function RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud)
    
    Classification_Result.label    = Yfit;
    Classification_Result.scores   = scores;
    Classification_Result.stdevs   = stdevs;
    Classification_Result.xyzi     = xyz_cloud;
    Classification_Result.avg_xyz  = [mean(xyz_cloud(:,1)), mean(xyz_cloud(:,2)), mean(xyz_cloud(:,3))];
    
    save(Classification_FileName, 'Classification_Result')
    
end