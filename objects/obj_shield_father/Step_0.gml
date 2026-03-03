if(shieldActualHp > (shieldHpPorcentage * 3)) {
	image_index = 0;
} else if(shieldActualHp > (shieldHpPorcentage * 2)){
	image_index = 1;
} else if(shieldActualHp > (shieldHpPorcentage)){
	image_index = 2;
} else if (shieldActualHp > 0){
	image_index = 3;
	image_blend = noone;
	image_alpha = 1;
} else{
	image_blend = c_red;
	image_alpha = 0.6;
}

if(shieldActive && canRegen){
	countRegenRate += 1;
	if(countRegenRate >= regenRateTime){
		countRegenRate = 0;
		if(shieldActualHp < shieldHp){
			shieldActualHp += armorRegenCant;
		}
	}
}
