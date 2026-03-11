is_enemy = true;
trail_sys  = part_system_create();
part_system_depth(trail_sys, depth + 1);
trail_part = part_type_create();
part_type_shape(trail_part, pt_shape_pixel);
part_type_size(trail_part, 2, 5, -0.04, 0);
part_type_color2(trail_part, c_red, c_dkgray);
part_type_alpha2(trail_part, 0.6, 0);
part_type_life(trail_part, 20, 40);
part_type_direction(trail_part, 0, 359, 0, 0);
part_type_speed(trail_part, 0.1, 0.5, -0.02, 0);




