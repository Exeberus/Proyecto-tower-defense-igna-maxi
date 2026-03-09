restantDmg = enemyClass.takeDamage(other.myShield.shieldActualHp);
if(restantDmg <= 0){
	other.myShield.shieldActualHp = restantDmg * -1;
	instance_destroy();
} else {
	instance_destroy();
	instance_destroy(other);
}