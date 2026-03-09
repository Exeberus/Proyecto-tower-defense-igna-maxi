if(!other.isAlive) exit;
restantDmg = enemyClass.takeDamage(other.actualHp);
if(restantDmg <= 0){
	other.actualHp = restantDmg * -1;
	if(other.actualHp <= 0){
		if(object_is_ancestor(other.object_index, obj_droneCollector_father)){
			instance_destroy(other);
		}
		other.image_index = 1;
		other.image_alpha = 0.4;
		other.isAlive = false;
		script_general_explosions(other.x, other.y, true, c_orange, c_yellow, 3, 6, 25, 50, 3, 8);
	}
} else {
	if(object_is_ancestor(other.object_index, obj_droneCollector_father)){
		instance_destroy(other);
	}
	other.image_index = 1;
	other.image_alpha = 0.4;
	other.isAlive = false;
	script_general_explosions(other.x, other.y, true, c_orange, c_red, 3, 10, 30, 60, 3, 8);
}
instance_destroy();