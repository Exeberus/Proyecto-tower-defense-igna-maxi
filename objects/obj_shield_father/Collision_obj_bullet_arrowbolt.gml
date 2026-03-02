if(!(shieldHp <= 0)){
	shieldHp -= other.proyectile_dmg
	instance_destroy(other);
} else{
	shieldActive = false;
	shieldHp = 0;
}



