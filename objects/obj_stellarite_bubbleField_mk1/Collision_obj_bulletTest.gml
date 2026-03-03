bubbleActualHp -= other.proyectile_dmg;

var dir = point_direction(x, y, other.x, other.y);
part_particles_create(shieldHit_sys, other.x, other.y, part_auraHitted, 20);
instance_destroy(other);
