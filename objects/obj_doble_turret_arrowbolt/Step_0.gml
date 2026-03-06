
// Deteccion del enemigo
var nearest_enemy = noone;
var nearest_distance = turret_range;

with (all) {
	if variable_instance_exists(id, "is_enemy") && is_enemy {
		var dist = point_distance(other.x, other.y, x, y);
		
		if dist < nearest_distance {
			nearest_distance = dist;
			nearest_enemy = id;
		}
	}
}

// Apuntando y disparo
if nearest_enemy != noone {
	turret_reload_time ++;
	turret_reload_time = clamp(turret_reload_time, 0, turret_reload_max)
	
	if turret_reload_time >= turret_reload_max {
		turret_reload_time = 0;
		if(turret_is_dispersable){
			turret_shooting_time = turret_shooting_time + 0.5;
			turret_actual_dispersion = turret_shooting_time * turret_dispersion;
			turret_actual_dispersion = clamp(turret_actual_dispersion, 0, turret_max_dispersion);
		}
		
		var proyectile_create = instance_create_layer(x, y+16, "Bullets", turret_bullet);
		var proyectile_create2 = instance_create_layer(x, y-16, "Bullets", turret_bullet);
		proyectile_create.proyectile_spd = turret_proyectile_spd;
		proyectile_create.proyectile_dmg = turret_proyectile_dmg;
		proyectile_create.proyectile_dir = irandom_range(image_angle - turret_actual_dispersion, image_angle + turret_actual_dispersion);
		proyectile_create2.proyectile_spd = turret_proyectile_spd;
		proyectile_create2.proyectile_dmg = turret_proyectile_dmg;
		proyectile_create2.proyectile_dir = irandom_range(image_angle - turret_actual_dispersion, image_angle + turret_actual_dispersion);
	}
	var target_dir = point_direction(x, y, nearest_enemy.x, nearest_enemy.y);
	var difference = angle_difference(image_angle, target_dir);
			
	image_angle -= clamp(difference, -turret_rot_spd, turret_rot_spd);
} else {
	var base_dir = 0;
	var difference = angle_difference(image_angle, base_dir)
	image_angle -= clamp(difference, -turret_rot_spd, turret_rot_spd);
	turret_shooting_time = 0;
}