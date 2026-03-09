if (initialized) {
	initialized = false;
    exp_sys  = part_system_create();
    exp_part = part_type_create();
    part_type_shape(exp_part, pt_shape_pixel);
    part_type_size(exp_part, minSize, maxSize, -0.08, 0);
    part_type_color2(exp_part, colorGradient[0], colorGradient[1]);
    part_type_alpha2(exp_part, 1, 0);
    part_type_life(exp_part, minLife, maxLife);
    part_type_direction(exp_part, 0, 359, 0, 0);
    part_type_speed(exp_part, minSpeed, maxSpeed, -0.1, 0);

    repeat (25) {
        part_particles_create(exp_sys, x, y, exp_part, 1);
    }
    alarm[0] = maxLife + 5;
}