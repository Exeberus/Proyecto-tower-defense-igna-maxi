// Movimiento del proyectil - -
x += lengthdir_x(proyectile_spd, proyectile_dir);
y += lengthdir_y(proyectile_spd, proyectile_dir);
image_angle = proyectile_dir;

repeat (2) {
    part_particles_create(trail_sys, x, y, trail_part, 1);
}
