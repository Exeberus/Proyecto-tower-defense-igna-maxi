if(shieldHp > (shieldHpPorcentage * 3)) {
	image_index = 0;
} else if(shieldHp > (shieldHpPorcentage * 2)){
	image_index = 1;
} else if(shieldHp > (shieldHpPorcentage)){
	image_index = 2;
} else if (shieldHp > 0){
	image_index = 3;
} else{
	image_blend = c_red;
	image_alpha = 0.6;
}


regenRateTime = 120;
regenRate += armorRegenRate;
if(regenRate >= regenRateTime){
	regenRate = 0;
	shieldHp += armorRegenCant;
}