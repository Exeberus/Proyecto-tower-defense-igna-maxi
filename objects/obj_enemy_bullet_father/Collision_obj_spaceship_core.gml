if(!other.spaceshipCore.isAlive) exit;
other.spaceshipCore.actualHp -= proyectile_dmg;
if(other.spaceshipCore.actualHp <= 0){
	other.image_index = 1;
	other.image_alpha = 0.4;
	other.spaceshipCore.isAlive = false;
}
instance_destroy();