function train_dat = save_training_data(xyzi, model_RANSAC, model_MLS, save_folder, Manual_Classfied_Areas, mca_bool, ring_idx)
    
    % Assigning Training Data to struct
    
    train_dat.xyzi  = xyzi;
    train_dat.rana  = model_RANSAC.Parameters(1);
    train_dat.ranb  = model_RANSAC.Parameters(2);
    train_dat.ranc  = model_RANSAC.Parameters(3);
    train_dat.rand  = model_RANSAC.Parameters(4);
    train_dat.mlla  = model_MLS.a;
    train_dat.mllb  = model_MLS.b;
    train_dat.mllc  = model_MLS.c;
    train_dat.mlld  = model_MLS.d;
    
    % Saving training data

    if mca_bool == 1
        Filename        = save_folder + "/Gravel_Training_Data_RING_" + string(sprintf( '%06d', ring_idx )) + ".mat";
    elseif mca_bool == 2
        Filename        = save_folder + "/Chipseal_Training_Data_RING_" + string(sprintf( '%06d', ring_idx )) + ".mat";
    elseif mca_bool == 3
         Filename        = save_folder + "/Foliage_Training_Data_RING_" + string(sprintf( '%06d', ring_idx )) + ".mat";
    elseif mca_bool == 4
         Filename        = save_folder + "/Grass_Training_Data_RING_" + string(sprintf( '%06d', ring_idx )) + ".mat";
    end

%     save(Filename, 'train_dat')
    
end