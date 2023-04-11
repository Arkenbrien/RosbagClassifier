% Takes the TRIMMED xyzir cloud, transformation, and roi file, and splits
% it between the front and rear clouds

function [data_export_a, data_export_b] = grab_training_data(xyz_cloud, tform, Manual_Classfied_Areas, model_RANSAC, model_MLS, save_folder, terrain_opt, roi_select)

    %% Loading Area - atm just one area supported
    
    if terrain_opt == 1
        xy_roi = Manual_Classfied_Areas.grav{roi_select};
    elseif terrain_opt == 2
        xy_roi = Manual_Classfied_Areas.chip{roi_select};
    elseif terrain_opt == 3
        xy_roi = Manual_Classfied_Areas.foli{roi_select};
    elseif terrain_opt == 4
        xy_roi = Manual_Classfied_Areas.gras{roi_select};
    elseif terrain_opt == 5
        try
            xy_roi = Manual_Classfied_Areas.asph_roi{roi_select};
        catch
            xy_roi = Manual_Classfied_Areas.asph{roi_select};
        end
    end

    %% Creating front/rear point clouds & re-grabbing the points

    % Check Each Ring
    for ring_idx = 2:1:5

        xyzir_temp                      = xyz_cloud(xyz_cloud(:,5) == (ring_idx-1), :); %Get ring

        if terrain_opt == 1 || terrain_opt == 2  || terrain_opt == 5     % ROAD SURFACE

            xyzir_A                     = xyzir_temp(xyzir_temp(:,1) < 0, :);
            xyzir_B                     = xyzir_temp(xyzir_temp(:,1) > 0, :);

        elseif terrain_opt == 3 || terrain_opt == 4   % NON-ROAD SURFACE

            xyzir_A                     = xyzir_temp(xyzir_temp(:,2) < 0, :);
            xyzir_B                     = xyzir_temp(xyzir_temp(:,2) > 0, :);

        end

        % Creating front cloud
        cloud_A                     = pointCloud([xyzir_A(:,1), xyzir_A(:,2), xyzir_A(:,3)], 'Intensity',  xyzir_A(:,4));
        cloud_A                     = pctransform(cloud_A, tform);

        % Creating back cloud
        cloud_B                     = pointCloud([xyzir_B(:,1), xyzir_B(:,2), xyzir_B(:,3)], 'Intensity',  xyzir_B(:,4));
        cloud_B                     = pctransform(cloud_B, tform);

        % Grabbing the front/rear points
        xyzi_A                      = [cloud_A.Location(:,1), cloud_A.Location(:,2), cloud_A.Location(:,3), cloud_A.Intensity(:)];
        xyzi_B                      = [cloud_B.Location(:,1), cloud_B.Location(:,2), cloud_B.Location(:,3), cloud_B.Intensity(:)];


        %% Front check
        roi_A                       = inpolygon(xyzi_A(:,1), xyzi_A(:,2), xy_roi(:,1), xy_roi(:,2));

        % Get array of ones
        roi_A_idx                   = find(roi_A==1);

        % Point cloud B with JUST the indexed points
        A_ptCloudROI                = select(cloud_A,roi_A_idx);

        % Grabbing the xyzi data
        xyzi_A_Final                = [A_ptCloudROI.Location(:,1), A_ptCloudROI.Location(:,2), A_ptCloudROI.Location(:,3), A_ptCloudROI.Intensity(:)];

        %% Rear Check
        roi_B                       = inpolygon(xyzi_B(:,1), xyzi_B(:,2), xy_roi(:,1), xy_roi(:,2));

        % Get array of ones
        roi_B_idx                   = find(roi_B==1);

        % Point cloud B with JUST the indexed points
        B_ptCloudROI                = select(cloud_B,roi_B_idx);

        % Grabbing the xyzi data
        xyzi_B_Final                = [B_ptCloudROI.Location(:,1), B_ptCloudROI.Location(:,2), B_ptCloudROI.Location(:,3), B_ptCloudROI.Intensity(:)];


        %% Saving the training data

        if ~isempty(roi_A_idx)
            
            % Check
%             roi_fig = figure('Name','roi fig','NumberTitle','off');
%             pcshow(A_ptCloudROI)
%             view([0 0 90]);
% 
%             disp('Pausing until ready')
%             pause
%             close(roi_fig)
            
            train_dat_a = save_training_data(xyzi_A_Final, model_RANSAC, model_MLS, save_folder, Manual_Classfied_Areas, terrain_opt, ring_idx);
            data_export_a{1, ring_idx} = train_dat_a;
            
        else
            
            data_export_a{1, ring_idx} = [];

        end

        if ~isempty(roi_B_idx)
            
            % Check
%             roi_fig = figure('Name','roi fig','NumberTitle','off');
%             pcshow(B_ptCloudROI)
%             view([0 0 90]);
% 
%             disp('Pausing until ready')
%             pause
%             close(roi_fig)

            train_dat_b = save_training_data(xyzi_B_Final, model_RANSAC, model_MLS, save_folder, Manual_Classfied_Areas, terrain_opt, ring_idx);
            data_export_b{ring_idx} = train_dat_b;
                        
        else
            
            data_export_b{ring_idx} = [];
            
        end
        
        % ring_idx

        %         if ~isempty(front_idx_in) && ~isempty(rear_idx_in)

        % Do Something
        %             roi_fig = figure('Name','roi fig','NumberTitle','off');
        %             pcshow(rear_ptCloudROI)
        %             hold on
        %             pcshow(front_ptCloudROI)
        %             view([0 0 90]);
        %
        %             pause
        %
        %             close(roi_fig)
        %         end
        
        % need front and back LiDAR - or do I ???? Yes because I'm going to
        % also include side/side eventually so yes I gotta include the two
        % rhings eventually
        
        

    end % For Each Ring

end % End Func