repeat (20) {
    part_particles_create(hit_sys, x, y, hit_part, 1);
}
if (part_system_exists(trail_sys)) part_system_destroy(trail_sys);
if (part_type_exists(trail_part))  part_type_destroy(trail_part);

alarm[0] = 30;