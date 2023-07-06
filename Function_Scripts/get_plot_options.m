function options = get_plot_options(options)
    
    % Marker size
    options.c2markersize            = 20;
    options.c3markersize            = 20;
    options.c4markersize            = 20;
    options.c5markersize            = 20;
    options.gravmarkersize          = 30;
    options.asphmarkersize          = 30;
    options.unknmarkersize          = 40;
    
    % Marker Color
    options.grav_col                = 'c';
    options.asph_col                = 'k';
    options.unkn_col                = 'r';
    options.grey_col                = [0.5, 0.5, 0.5];
    
    % Marker Symbol
    options.grav_sym                = 'o';
    options.asph_sym                = 's';
    options.unkn_sym                = 'x';
    options.x_y_z_path_sym          = 'b--';
    options.x_y_z_path_linewidth    = 20;
    options.x_y_z_path_color        = [0.00, 0.53, 1.00];
    
    % Linewidth
    options.c2linewidth             = 20;
    options.c3linewidth             = 20;
    options.c4linewidth             = 20;
    options.c5linewidth             = 20;
    options.gravlinewidth           = 2;
    options.asphlinewidth           = 2;
    options.unknlinewidth           = 6;
    
    % Legend Stuff
    options.legend_marker_size      = 20;
    options.legend_line_width       = 5;
    options.legend_font_size        = 64;
    
    % Legend Marker
    options.h_grav_sym                  = 'co';
    options.h_asph_sym                  = 'ks';
    options.h_unkn_sym                  = 'rx';
    options.h_path_sym                  = '--';
    options.h_path_col                  = [0.00, 0.53, 1.00];
    options.h_grav_size                 = 20;
    options.h_asph_size                 = 20;
    options.h_unkn_size                 = 40;
    options.h_path_linewidth            = 10;
    
    % Size of figures
    options.fig_size_array          = [10 10 3500 1600];
    
    % Font Options
    options.axis_font_size          = 24;
    options.font_type               = 'Sans Regular'; % Default Font: Sans Regular
    
    % Plotting the moving average - how many samples per average?
    options.move_avg_size           = 15;
    
    % Font size in animations
    options.animate_font_size       = 16;
    
    % MCA plot area options
    options.mca_grav_bool           = 1;
    options.mca_asph_bool           = 1;
    options.mca_unkn_bool           = 1;
    options.mca_sor_bool            = 0;
    options.mca_gras_bool           = 0;
    options.mca_road_bool           = 0;
    options.mca_face_alpha_value    = 0.15;
    options.mca_area_sym            = 's';
    options.mca_marker_size         = 30;
    
    
end