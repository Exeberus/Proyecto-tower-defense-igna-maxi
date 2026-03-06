// Variables de Stats - -
proyectile_spd = 0;
proyectile_dmg = 0;
proyectile_dir = 0;

image_xscale = 0.5;
image_yscale = 0.5;

// Estela
trail_sys  = part_system_create();
part_system_depth(trail_sys, depth + 1); 
trail_part = part_type_create();
part_type_shape(trail_part, pt_shape_pixel);
part_type_size(trail_part, 1, 3, -0.08, 0);
part_type_color2(trail_part, c_white, c_yellow);
part_type_alpha2(trail_part, 0.8, 0);
part_type_life(trail_part, 8, 15);
part_type_direction(trail_part, direction + 160, direction + 200, 0, 0); 
part_type_speed(trail_part, 0.2, 0.8, -0.05, 0);

hit_sys  = part_system_create();
part_system_depth(hit_sys, depth - 1);
hit_part = part_type_create();
part_type_shape(hit_part, pt_shape_pixel);
part_type_size(hit_part, 1, 4, -0.06, 0);
part_type_color2(hit_part, c_yellow, c_red);
part_type_alpha2(hit_part, 1, 0);
part_type_life(hit_part, 15, 25);
part_type_direction(hit_part, 0, 359, 0, 0);
part_type_speed(hit_part, 1, 4, -0.1, 0);