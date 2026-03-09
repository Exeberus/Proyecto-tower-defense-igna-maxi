if(!other.spaceshipCore.isAlive) exit;
restantDmg = enemyClass.takeDamage(other.spaceshipCore.actualHp);
if(restantDmg <= 0){
	other.spaceshipCore.actualHp = restantDmg * -1;
	if(other.spaceshipCore.actualHp <= 0){
		other.image_index = 1;
		other.image_alpha = 0.4;
		other.spaceshipCore.isAlive = false;
	}
} else {
	other.image_index = 1;
	other.image_alpha = 0.4;
	other.spaceshipCore.isAlive = false;
}
instance_destroy();