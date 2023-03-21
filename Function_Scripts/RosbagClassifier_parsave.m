function RosbagClassifier_parsave(Classification_FileName, Yfit, scores, stdevs, xyz_cloud, tform)
    
    Classification_Result.label    = Yfit;
    Classification_Result.scores   = scores;
    Classification_Result.stdevs   = stdevs;
    Classification_Result.xyzi     = xyz_cloud(:,1:3) * tform.Rotation + tform.Translation;
    Classification_Result.avg_xyz  = [mean(xyz_cloud(:,1)), mean(xyz_cloud(:,2)), mean(xyz_cloud(:,3))] * tform.Rotation + tform.Translation;
    
    save(Classification_FileName, 'Classification_Result')
    
end