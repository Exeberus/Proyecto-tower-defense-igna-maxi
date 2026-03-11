
if(!other.isAlive) exit;
other.turret_health -= proyectile_dmg;
if(other.turret_health <= 0){
	other.image_index = 1;
	other.image_alpha = 0.4;
	other.isAlive = false;
	script_general_explosions(other.x, other.y, true, c_orange, c_red, 3, 10, 30, 60, 3, 8);
}
instance_destroy();
