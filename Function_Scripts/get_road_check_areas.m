function road_check_areas = get_road_check_areas()

    %% VAR INIT
    
    w = 2;
    l = 15;
    h = [0 0 0 0];
    face_alpha_value = 1;

    %% Coordinates for each box

    l_area_x = [-w -w w w];
    l_area_y = [w l l w];
    
    c_area_x = [w l l w];
    c_area_y = [w w -w -w];
    
    r_area_x = [-w -w w w];
    r_area_y = [-w -l -l -w];
    
    
    %% TEST PLOT
    
%     close all
%     figure
%     hold all
%     patch(l_area_x,l_area_y,h)
%     patch(c_area_x,c_area_y,h)
%     patch(r_area_x,r_area_y,h)
%     axis equal
%     
    
    %% Exporting to Struct
    
    road_check_areas.lx = l_area_x;
    road_check_areas.ly = l_area_y;
    
    road_check_areas.cx = c_area_x;
    road_check_areas.cy = c_area_y;
    
    road_check_areas.rx = r_area_x;
    road_check_areas.ry = r_area_y;
    road_check_areas.h = h;
    
end



