function ShieldClass(_shieldHp, _canRegen, _armorRegenCant) constructor{
	//Properties
	shieldActive = true;
	shieldHp = _shieldHp;
	shieldActualHp = shieldHp;
	shieldHpPorcentage = shieldHp / 4;
	
	canRegen = _canRegen;
	regenRateTime = 120; //Tiempo cada Regeneracion Realizada
	countRegenRate = 0;  //Contador para que se haga Regeneracion
	armorRegenCant = _armorRegenCant; //Cantidad a Regenerar
	
	//Methods (extra functions)
	static bulletCollision = function(_proyectile){
		
		if (shieldActive && shieldActualHp > 0) {
            shieldActualHp -= _proyectile.proyectile_dmg;
			instance_destroy(_proyectile);
            if (shieldActualHp <= 0) {
                shieldActualHp = 0;
                shieldActive = false;
            }
            return true; //True if shield receive damage
        }
        return false; //False if shield was desactivated
	}
	static update = function(){
		if (!shieldActive || !canRegen) return; //Shield is broken so don't regenerate

        if (shieldActualHp < shieldHp) {
            countRegenRate++;
            if (countRegenRate >= regenRateTime) {
                shieldActualHp = clamp(shieldActualHp + armorRegenCant, 0, shieldHp);
                countRegenRate = 0;
            }
        } else{
			countRegenRate = 0;
		}
	}
	static spriteChangeByHp = function(_object){
		if(shieldActualHp > (shieldHpPorcentage * 3)) {
			_object.image_index = 0;
		} else if(shieldActualHp > (shieldHpPorcentage * 2)){
			_object.image_index = 1;
		} else if(shieldActualHp > (shieldHpPorcentage)){
			_object.image_index = 2;
		} else if (shieldActualHp > 0){
			_object.image_index = 3;
			_object.image_blend = -1;
			_object.image_alpha = 1;
		} else{
			_object.image_blend = c_red;
			_object.image_alpha = 0.6;
		}
	}
}

function BubbleShield(_shieldHp, _canRegen, _armorRegenCant, _owner, _associatedBubble) : ShieldClass(_shieldHp, _canRegen, _armorRegenCant) constructor {
	//Updated Properties for BubbleShield
	myBubble = instance_create_layer(_owner.x, _owner.y, "Instances", _associatedBubble);
	bubbleIsActive = false;
	canCreateBubble = true;
	bubbleCanRecharge = true;
	bubbleRegenRate = 120;
	bubbleCountRegenRate = 0;
	
	//Initial Config of Bubble
	if(instance_exists(myBubble)){
		myBubble.creator = _owner;
		myBubble.radio = 120;
		bubbleIsActive = true;
		myBubble.image_alpha = 0;
		myBubble.visible = false;
	}
	
	//Shield Particle System
	shield_sys = part_system_create();
	part_system_depth(shield_sys, _owner.depth - 1);
	part_aura = part_type_create();
	part_type_shape(part_aura, pt_shape_pixel);
	part_type_color1(part_aura, c_aqua);
	part_type_alpha2(part_aura, 0.5, 0);
	part_type_life(part_aura, 20, 40);
	part_type_direction(part_aura, 0, 359, 0, 0);
	part_type_speed(part_aura, 0.5, 1, -0.01, 0);
	
	//New Methods
	static shieldParticles = function(_object){
		for(var i=0;i<3;i++){
			if (shieldActualHp > 0) {
			    var angle = random(360);
			    var dist = random(128);
			    var px = _object.x + lengthdir_x(dist, angle);
			    var py = _object.y + lengthdir_y(dist, angle);
			    part_particles_create(shield_sys, px, py, part_aura, 1);
			}
		}
	}
	static recreateBubble = function(_owner, _bubbleObject){
		if (!instance_exists(myBubble) && canCreateBubble) {
			myBubble = instance_create_layer(_owner.x, _owner.y, "Instances", _bubbleObject);
			if (instance_exists(myBubble)) {
	            myBubble.creator = _owner;
	            myBubble.radio = 120;
	            bubbleIsActive = true;
		        myBubble.visible = true;
			}
			return true;
		}
		return false;
	}
	
	static bubblePositionUpdate = function(_owner){
		if(instance_exists(myBubble)){
			myBubble.x = _owner.x;
		    myBubble.y = _owner.y;
		}
	}
	static checkAndRecreateBubble = function(_owner, _bubbleObject){
		if (!instance_exists(myBubble) && canCreateBubble && bubbleCanRecharge && shieldActualHp > 0){
			bubbleCountRegenRate++;
			if(bubbleCountRegenRate >= bubbleRegenRate){
				recreateBubble(_owner, _bubbleObject);
				bubbleCountRegenRate = 0;
			}
		} else{
			bubbleCountRegenRate = 0;
		}
	}
}