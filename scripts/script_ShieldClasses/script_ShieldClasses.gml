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

enum BUBBLE_STATE {FADE_IN, ACTIVE, FADE_OUT, DEAD};	
function BubbleField(_bubble) constructor{
	//Properties
	//----Config---
	bubbleObject = _bubble;
	creator = noone;
	bubbleHp = 1;
	bubbleActualHp = 1;
	radio = 0;
	
	//---Animations---
	state         = BUBBLE_STATE.FADE_IN;
	fadeSpeed     = 0.04;
	pulseTimer    = 0;
	pulseSpeed    = 0.03;
	pulseMin      = 0.75;
	pulseMax      = 1.0;
	bubbleObject.image_alpha   = 1;
	bubbleObject.image_xscale  = 1;
	bubbleObject.image_yscale  = 1;
	bubbleObject.visible       = true;
	//Bubble generation
	shield_sys = part_system_create();
	part_system_depth(shield_sys, bubbleObject.depth - 1);
	part_aura = part_type_create();
	part_type_shape(part_aura, pt_shape_pixel);
	part_type_size(part_aura, 2, 8, -0.05, 0); 
	part_type_color1(part_aura, c_aqua);
	part_type_alpha2(part_aura, 0.6, 0);
	part_type_life(part_aura, 300, 600);
	//Bubble Hit
	shieldHit_sys = part_system_create();
	part_system_depth(shieldHit_sys, bubbleObject.depth - 1);
	part_auraHitted = part_type_create();
	part_type_shape(part_auraHitted, pt_shape_pixel);
	part_type_size(part_auraHitted, 2, 8, -0.05, 0); 
	part_type_color1(part_auraHitted, c_red);
	part_type_alpha2(part_auraHitted, 0.6, 0);
	part_type_life(part_auraHitted, 300, 600);
	//Methods
	static initBubble = function(_creator, _bubbleHp, _radio){
		creator = _creator;
		bubbleHp = _bubbleHp;
		bubbleActualHp = _bubbleHp;
		radio = _radio;
		var _targetScale = (_radio * 2) / sprite_get_width(bubbleObject.sprite_index);
	    bubbleObject.image_xscale = _targetScale;
	    bubbleObject.image_yscale = _targetScale;
	    bubbleObject.image_alpha  = 0;
	    bubbleObject.visible      = false;
	}
	static cleanUp = function() {
		if (part_system_exists(shield_sys))    part_system_destroy(shield_sys);
		if (part_type_exists(part_aura))       part_type_destroy(part_aura);
		if (part_system_exists(shieldHit_sys)) part_system_destroy(shieldHit_sys);
		if (part_type_exists(part_auraHitted)) part_type_destroy(part_auraHitted);
		instance_destroy(bubbleObject);
    }
	
	static _emitRing = function(_radio, _count) {
	    repeat (_count) {
	        var _angle = random(360);
	        part_particles_create(
	            shield_sys,
	            bubbleObject.x + lengthdir_x(_radio, _angle),
	            bubbleObject.y + lengthdir_y(_radio, _angle),
	            part_aura,
	            1
	        );
	    }
	}
		
	deathTrigger = false;
	static update = function(){
		if (!instance_exists(creator)) {
		    state = BUBBLE_STATE.DEAD;
            instance_destroy(bubbleObject);
            return;
		}

		switch (state) {
            case BUBBLE_STATE.FADE_IN:
			    var _progress = bubbleObject.image_alpha / 0.6;
			    var _currentRadio = radio * _progress;           
			    bubbleObject.image_alpha += fadeSpeed;
			    _emitRing(_currentRadio, 3);
			    if (bubbleObject.image_alpha >= 0.6) {
			        bubbleObject.image_alpha = 0.6;
			        state = BUBBLE_STATE.ACTIVE;
			    }
			    break;

			case BUBBLE_STATE.ACTIVE:
			    var _hpRatio = bubbleActualHp / bubbleHp;
			    var _ringColor = merge_color(c_red, c_aqua, _hpRatio);
			    part_type_color1(part_aura, _ringColor);
			    _emitRing(radio, 4);
			    break;

			case BUBBLE_STATE.FADE_OUT:
			    _emitRing(radio, 6);
			    bubbleObject.image_alpha -= fadeSpeed * 2;
			    if (bubbleObject.image_alpha <= 0) {
			        state = BUBBLE_STATE.DEAD;
			    }
			    break;
				
			case BUBBLE_STATE.DEAD:
				if(!deathTrigger){
					deathTrigger = true;
					repeat (40) {
				        var _angle = random(360);
				        part_particles_create(shieldHit_sys,bubbleObject.x + lengthdir_x(radio, _angle),bubbleObject.y + lengthdir_y(radio, _angle),part_auraHitted, 1);
				    }
				    repeat (20) {
				        var _angle = random(360);
				        part_particles_create(shieldHit_sys,bubbleObject.x + lengthdir_x(random(radio * 0.5), _angle),bubbleObject.y + lengthdir_y(random(radio * 0.5), _angle),part_auraHitted, 1);
				    }
					bubbleObject.image_xscale = 0;
					bubbleObject.image_yscale = 0;
					with(bubbleObject){alarm[0] = 200;}
				}
				break;
		}
	}
	static takeDamage = function(_dmg){
		if (state != BUBBLE_STATE.ACTIVE) return;
		
		bubbleActualHp -= _dmg;
		if (bubbleActualHp <= 0) {
		    state = BUBBLE_STATE.FADE_OUT;
		}
	}
}
function BubbleShield(_shieldHp, _canRegen, _armorRegenCant, _owner, _associatedBubble, _bubbleHp, _bubbleRegenRate, _radio) : ShieldClass(_shieldHp, _canRegen, _armorRegenCant) constructor {
	//Updated Properties for BubbleShield
	//---Config---
	owner = _owner;
	bubbleObject = _associatedBubble;
	bubbleHp = _bubbleHp;
	bubbleRegenRate = _bubbleRegenRate;
	bubbleRadio = _radio;
	//---State---
	myBubble = noone;
	bubbleIsActive = false;
	bubbleRegenCounter = 0;
	//---Particle System---
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
	static _spawnBubble = function(){
		if (instance_exists(myBubble)) {
	        if (myBubble.bubbleClass.state == BUBBLE_STATE.DEAD) {
	            instance_destroy(myBubble); 
	        } else {
	            return;
	        }
	    }
		myBubble = instance_create_layer(owner.x, owner.y, "Instances", bubbleObject);
		if (!instance_exists(myBubble)) {
            show_debug_message("BubbleShield: failed to create bubble instance.");
            bubbleIsActive = false;
            return;
        }
		//---Bubble Config---
		myBubble.bubbleClass = new BubbleField(myBubble);
		myBubble.bubbleClass.initBubble(owner, bubbleHp, bubbleRadio);
        bubbleIsActive = true;
        
	}
	static update = function(){
		//Shield
		if (shieldActive && canRegen && shieldActualHp < shieldHp) {
        countRegenRate++;
	        if (countRegenRate >= regenRateTime) {
	            shieldActualHp = clamp(shieldActualHp + armorRegenCant, 0, shieldHp);
	            countRegenRate = 0;
			}
	    } else {
	        countRegenRate = 0;
	    }
		spriteChangeByHp(owner);
		
		_emitParticles();
		//Bubble
		_updateBubblePosition();
		_tickRegen();
		if(instance_exists(myBubble)){
			myBubble.bubbleClass.update();	
		}
	}
    static _updateBubblePosition = function() {
        if (instance_exists(myBubble)) {
            myBubble.x = owner.x;
            myBubble.y = owner.y;
        }
    }
    static _tickRegen = function() {
		var _bubbleAlive = instance_exists(myBubble) && myBubble.bubbleClass.state != BUBBLE_STATE.DEAD;
        if (_bubbleAlive  || shieldActualHp <= 0) {
            bubbleRegenCounter = 0;
            bubbleIsActive     = _bubbleAlive;
            return;
        }
        bubbleRegenCounter++;
        if (bubbleRegenCounter >= bubbleRegenRate) {
            _spawnBubble();
        }
    }
    static _emitParticles = function() {
        if (shieldActualHp <= 0) return;

        repeat (3) {
            var _angle = random(360);
            var _dist = random(bubbleRadio);
            part_particles_create(shield_sys, owner.x + lengthdir_x(_dist, _angle), owner.y + lengthdir_y(_dist, _angle), part_aura, 1);
        }
    }
	//---Init---
	_spawnBubble();
}
	
