function options = get_arc_options(options)
    
    %
    % ARC SIZE
    %
    
    options.c_only_bool             = 0;

    % Center angle variance +- idk what you call this
    options.chan_2_d_ang            = 3;
    options.chan_3_d_ang            = 3;
    options.chan_4_d_ang            = 3;
    options.chan_5_d_ang            = 3;

    % Center of ll arc
    options.chan_2_ll_cent_ang      = 0;
    options.chan_3_ll_cent_ang      = 0;
    options.chan_4_ll_cent_ang      = 0;
    options.chan_5_ll_cent_ang      = 0;

    % Center of l arc
    options.chan_2_l_cent_ang       = 45;
    options.chan_3_l_cent_ang       = 45;
    options.chan_4_l_cent_ang       = 45;
    options.chan_5_l_cent_ang       = 45;

    % Center of c arc
    options.chan_2_c_cent_ang       = 90;
    options.chan_3_c_cent_ang       = 90;
    options.chan_4_c_cent_ang       = 90;
    options.chan_5_c_cent_ang       = 90;

    % Center of r arc
    options.chan_2_r_cent_ang       = 135;
    options.chan_3_r_cent_ang       = 135;
    options.chan_4_r_cent_ang       = 135;
    options.chan_5_r_cent_ang       = 135;

    % Center of rr arc
    options.chan_2_rr_cent_ang      = 180;
    options.chan_3_rr_cent_ang      = 180;
    options.chan_4_rr_cent_ang      = 180;
    options.chan_5_rr_cent_ang      = 180;

end