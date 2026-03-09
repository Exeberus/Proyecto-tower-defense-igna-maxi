if(!other.myShield.shieldActive) exit;
restantDmg = enemyClass.takeDamage(other.myShield.shieldActualHp);
if(restantDmg <= 0){
	other.myShield.shieldActualHp = restantDmg * -1;
	if(other.myShield.shieldActualHp <= 0){
		other.mask_index = -1;
		other.opacity = 0.4;
		other.myShield.shieldActive = false;
		script_general_explosions(other.x, other.y, true, c_grey, c_white, 2, 5, 10, 25, 2, 5);
	}
} else {
	other.mask_index = -1;
	other.opacity = 0.4;
	other.myShield.shieldActive = false;
	script_general_explosions(other.x, other.y, true, c_grey, c_white, 2, 5, 10, 25, 2, 5);
}
instance_destroy();
