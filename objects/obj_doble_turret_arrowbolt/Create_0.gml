// Inherit the parent event
event_inherited();

// Variables de Stats - -
turret_level = 1;

turret_health = 5;
turret_defense = 1;
turret_range = 700;

// Movimiento - -
turret_rot_spd = 3;

// Proyectil - -
turret_proyectile_spd = 8;
turret_proyectile_dmg = 1;
turret_proyectile_spr = spr_ArrowBolt_proyectile;
turret_bullet = obj_bullet_arrowbolt;

turret_is_dispersable = true;
turret_dispersion = 1;
turret_max_dispersion = 10;

turret_reload_max = 5;
turret_reload_time = 0;