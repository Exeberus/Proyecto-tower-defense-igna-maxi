shieldActive = true;
shieldHp = 10;
shieldActualHp = shieldHp;
shieldHpPorcentage = shieldHp / 4;

canRegen = false;
regenRateTime = 120; //Tiempo cada Regeneracion Realizada
countRegenRate = 0;  //Contador para que se haga Regeneracion
armorRegenCant = 0; //Cantidad a Regenerar

function bulletCollision(){
	if(!(shieldActualHp <= 0)){
		shieldActualHp -= other.proyectile_dmg
		instance_destroy(other);
	} else{
		shieldActive = false;
		shieldActualHp = 0;
	}
}