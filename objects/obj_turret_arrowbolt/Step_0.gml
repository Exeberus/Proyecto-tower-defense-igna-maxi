// Apuntado
var objective_dir = point_direction(x, y, mouse_x, mouse_y);
var objective_diff = angle_difference(image_angle - 180, objective_dir);

direction += clamp(objective_diff, -turret_rot_spd, turret_rot_spd);
image_angle = direction;

// Crear bala
turret_reload_time -= 1
if turret_reload_time <= 0 {
	var proyectile_create = instance_create_layer(x, y, "instances", obj_bullet_arrowbolt) {
		proyectile_create.proyectile_spd = turret_proyectile_spd;
		proyectile_create.proyectile_dmg = turret_proyectile_dmg;
		proyectile_create.proyectile_dir = direction;
	}
	turret_reload_time = turret_reload_max;
}