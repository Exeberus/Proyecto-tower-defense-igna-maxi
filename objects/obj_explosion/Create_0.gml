exp_sys  = part_system_create();
exp_part = part_type_create();
part_type_shape(exp_part, pt_shape_pixel);
part_type_size(exp_part, 2, 6, -0.08, 0);
part_type_color2(exp_part, c_yellow, c_red);
part_type_alpha2(exp_part, 1, 0);
part_type_life(exp_part, 20, 40);
part_type_direction(exp_part, 0, 359, 0, 0);
part_type_speed(exp_part, 2, 6, -0.1, 0);

repeat (25) {
    part_particles_create(exp_sys, x, y, exp_part, 1);
}

alarm[0] = 45;