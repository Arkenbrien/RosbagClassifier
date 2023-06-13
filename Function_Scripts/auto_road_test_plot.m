function auto_road_test_plot(left_area_export, cent_area_export, right_area_export, options)

    
    figure

    hold all
    for idx = 1:length(cent_area_export)
        scatter3(cent_area_export{idx}.points(:,1), cent_area_export{idx}.points(:,2), cent_area_export{idx}.points(:,3))
    end
    view([0 0 90])
    axis equal
    
    
    
end
