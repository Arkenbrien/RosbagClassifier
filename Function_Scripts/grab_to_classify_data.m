% Takes the TRIMMED xyzir cloud, transformation, and roi file, and splits
% it between the front and rear clouds

function [data_export_a] = grab_to_classify_data(xyz_cloud, tform, Manual_Classfied_Areas, terrain_opt, roi_select)

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
        xy_roi = Manual_Classfied_Areas.asph{roi_select};
    end

    %% Creating front/rear point clouds & re-grabbing the points

%     xyzir_temp                      = xyz_cloud(xyz_cloud(:,5) == (ring_idx-1), :); %Get ring

    if terrain_opt == 1 || terrain_opt == 2  || terrain_opt == 5     % ROAD SURFACE

        xyzi_raw_A                     = xyz_cloud(xyz_cloud(:,1) < 0, :);
%         xyzi_raw_B                     = xyz_cloud(xyz_cloud(:,1) > 0, :);

    elseif terrain_opt == 3 || terrain_opt == 4   % NON-ROAD SURFACE

        xyzi_raw_A                     = xyzir_temp(xyz_cloud(:,2) < 0, :);
%         xyzi_raw_B                     = xyzir_temp(xyz_cloud(:,2) > 0, :);

    end

    % Creating front cloud
    cloud_A                     = pointCloud([xyzi_raw_A(:,1), xyzi_raw_A(:,2), xyzi_raw_A(:,3)], 'Intensity',  xyzi_raw_A(:,4));
    cloud_A                     = pctransform(cloud_A, tform);

    % Creating back cloud
%     cloud_B                     = pointCloud([xyzi_raw_B(:,1), xyzi_raw_B(:,2), xyzi_raw_B(:,3)], 'Intensity',  xyzi_raw_B(:,4));
%     cloud_B                     = pctransform(cloud_B, tform);

    % Grabbing the front/rear points
    xyzi_A                      = [cloud_A.Location(:,1), cloud_A.Location(:,2), cloud_A.Location(:,3), double(cloud_A.Intensity(:))];
%     xyzi_B                      = [cloud_B.Location(:,1), cloud_B.Location(:,2), cloud_B.Location(:,3), double(cloud_B.Intensity(:))];


    %% A - Front/Right check
    roi_A                       = inpolygon(xyzi_A(:,1), xyzi_A(:,2), xy_roi(:,1), xy_roi(:,2));

    % Get array of ones
    roi_A_idx                   = find(roi_A==1);

    % Point cloud B with JUST the indexed points
    A_ptCloudROI                = select(cloud_A,roi_A_idx);

    % Grabbing the xyzi data
    xyzi_A_Final                = [A_ptCloudROI.Location(:,1), A_ptCloudROI.Location(:,2), A_ptCloudROI.Location(:,3), double(A_ptCloudROI.Intensity(:))];

    %% B - Rear/Left Check
%     
%     roi_B                       = inpolygon(xyzi_B(:,1), xyzi_B(:,2), xy_roi(:,1), xy_roi(:,2));
% 
%     % Get array of ones
%     roi_B_idx                   = find(roi_B==1);
% 
%     % Point cloud B with JUST the indexed points
%     B_ptCloudROI                = select(cloud_B,roi_B_idx);
% 
%     % Grabbing the xyzi data
%     xyzi_B_Final                = [B_ptCloudROI.Location(:,1), B_ptCloudROI.Location(:,2), B_ptCloudROI.Location(:,3), double(B_ptCloudROI.Intensity(:))];


    %% Saving the training data

    if ~isempty(roi_A_idx)

        data_export_a = xyzi_A_Final;

    else

        data_export_a = [];

    end

%     
%     if ~isempty(roi_B_idx)
% 
%         data_export_b = xyzi_B_Final;
% 
%     else
% 
%         data_export_b = [];
% 
%     end

    
end % End Func