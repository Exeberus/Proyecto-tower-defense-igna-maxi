function EnemiesClass(_owner, _isBoss, _hp, _damage, _shootingRange, _movSpeed) constructor{
	owner = _owner;
	isBoss = _isBoss;
	hp = _hp;
	actualHp = hp;
	damage = _damage;
	shootingRange = _shootingRange;
	movSpeed = _movSpeed;
	
	isAlive = true;
	target = noone;
	
	static findTarget = function(){
		if(!instance_exists(obj_spaceship_core)) { 
			target = noone;
			return;
		};
		target = obj_spaceship_core;
		
	}
	static moveToTarget = function(_target){
		if(_target != noone && instance_exists(obj_spaceship_core)){
			owner.direction = point_direction(owner.x, owner.y, _target.x, _target.y);
			owner.image_angle = owner.direction;
			owner.speed = movSpeed;
		}
		if(!instance_exists(obj_spaceship_core)){
			_onDeath();
		}
	}
	static hpRatio = function() { return actualHp / hp; }
	static spriteChangeByHp = function(_object){
		hpPorcentage = hpRatio();
		if(hpPorcentage > (0.75)) {
			_object.image_index = 0;
		} else if(hpPorcentage > (0.5)){
			_object.image_index = 1;
		} else if(hpPorcentage > (0.25)){
			_object.image_index = 2;
		} else if (hpPorcentage > 0){
			_object.image_index = 3;
			_object.image_blend = -1;
			_object.image_alpha = 1;
		} else{
			_object.image_blend = c_red;
			_object.image_alpha = 0.6;
		}
	}
	static _onDeath = function(){
		isAlive = false;
	}
	static cleanUp = function(){
	
	};
	static takeDamage = function(_dmg){
		actualHp -= _dmg;
		if(actualHp <= 0){
			_onDeath();	
		}
		return actualHp;
	}
	static bulletCollision = function(_proyectile){
		takeDamage(_proyectile.proyectile_dmg);
		instance_destroy(_proyectile);
	}
	
	findTarget();
	static update = function(){
		moveToTarget(target);
		if(isAlive == false){
			instance_destroy(owner);
		}
	}
}