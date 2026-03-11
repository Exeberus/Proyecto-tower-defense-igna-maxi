if(!other.isAlive) exit;
other.actualHp -= proyectile_dmg;
if(other.actualHp <= 0){
	if(object_is_ancestor(other.object_index, obj_droneCollector_father)){
		instance_destroy(other);
	}
	other.image_index = 1;
	other.image_alpha = 0.4;
	other.isAlive = false;
	script_general_explosions(other.x, other.y, true, c_orange, c_yellow, 3, 6, 25, 50, 3, 8);
} 
instance_destroy();