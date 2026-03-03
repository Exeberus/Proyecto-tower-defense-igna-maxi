var angle = random(360);
var px = x + lengthdir_x(bubbleRadio, angle);
var py = y + lengthdir_y(bubbleRadio, angle);
part_particles_create(shield_sys, px, py, part_aura, 1);

if (bubbleActualHp <= 0) {
    instance_destroy();
}