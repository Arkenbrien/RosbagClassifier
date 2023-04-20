function mca_plot_fun(Manual_Classfied_Areas)

    hold all

    if isfield(Manual_Classfied_Areas,'grav')

        for plot_idx = 1:length(Manual_Classfied_Areas.grav)

            xy_roi = Manual_Classfied_Areas.grav{1,plot_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor','red','FaceAlpha',0.75)

        end

    end

    if isfield(Manual_Classfied_Areas,'chip')

        for plot_idx = 1:length(Manual_Classfied_Areas.chip)

            xy_roi = Manual_Classfied_Areas.chip{1,plot_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor','white','FaceAlpha',0.75)

        end

    end

    if isfield(Manual_Classfied_Areas,'gras')

        for plot_idx = 1:length(Manual_Classfied_Areas.gras)

            xy_roi = Manual_Classfied_Areas.gras{1,plot_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor','green','FaceAlpha',0.75)

        end

    end

    if isfield(Manual_Classfied_Areas,'foli')

        for plot_idx = 1:length(Manual_Classfied_Areas.foli)

            xy_roi = Manual_Classfied_Areas.foli{1,plot_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor','magenta','FaceAlpha',0.75)

        end

    end

    if isfield(Manual_Classfied_Areas,'road_roi')

        for plot_idx = 1:length(Manual_Classfied_Areas.road_roi)

            xy_roi = Manual_Classfied_Areas.road_roi{1,plot_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor',[0.58, 0.50, 1.00],'FaceAlpha',0.75)

        end

    end

    if isfield(Manual_Classfied_Areas,'non_road_roi')

        for plot_idx = 1:length(Manual_Classfied_Areas.non_road_roi)

            xy_roi = Manual_Classfied_Areas.non_road_roi{1,plot_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor',[1.00, 0.65, 0.30],'FaceAlpha',0.75)

        end

    end
    
    if isfield(Manual_Classfied_Areas,'asph')

        for plot_idx = 1:length(Manual_Classfied_Areas.asph)

            xy_roi = Manual_Classfied_Areas.asph{1,plot_idx};
            pgon = polyshape(xy_roi(:,1),xy_roi(:,2));
            plot(pgon,'FaceColor',[1.00, 0.65, 0.30],'FaceAlpha',0.75)

        end

    end
    
end