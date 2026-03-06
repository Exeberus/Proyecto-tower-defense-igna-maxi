// Variables de Stats - -
turret_level = 1;

turret_health = 0;
turret_defense = 0;
turret_range = 0;

// Movimiento - -
turret_rot_spd = 0;

// Proyectil - -
turret_proyectile_spd = 0;
turret_proyectile_dmg = 0;
turret_proyectile_spr = noone;
turret_bullet = noone;

turret_reload_max = 0;
turret_reload_time = 0;

turret_is_dispersable = false;
turret_dispersion = 1;
turret_max_dispersion = 10;

turret_shooting_time = 0;
turret_actual_dispersion = 0;
// Variables Main de OBJ - -
direction = 0;

// Declarar posicion de instancia
layer = layer_get_id("Turrets");