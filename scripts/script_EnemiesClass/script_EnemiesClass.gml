function EnemiesClass(_owner, _isBoss, _hp, _damage, _movSpeed) constructor{
	owner = _owner;
	isBoss = _isBoss;
	hp = _hp;
	actualHp = hp;
	damage = _damage;
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
		var _ratio = hpRatio();
	    with (_object) {
	        if (_ratio > 0.75) {
	            image_index = 0;
	        } else if (_ratio > 0.5) {
	            image_index = 1;
	        } else if (_ratio > 0.25) {
	            image_index = 2;
	        } else if (_ratio > 0) {
	            image_index = 3;
	        } else {
	            image_blend = c_red;
	            image_alpha = 0.6;
	        }
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

enum ENEMY_STATE { MOVING, MODE_CHANGE, TURRET };
function TurretEnemyClass(_owner, _isBoss, _hp, _damage, _movSpeed, _sprTurret, _objBullets, _shootDmg, _shootSpd, _shootingRange, _shootDelay) : EnemiesClass(_owner, _isBoss, _hp, _damage, _movSpeed) constructor{
	turretSpr = _sprTurret;
	shootSpr = _objBullets;
	shootDmg = _shootDmg;
	shootSpd = _shootSpd;
	shootingRange = _shootingRange;
	shootDelay = _shootDelay;
	shootActualDelay = 0;
	
	state = ENEMY_STATE.MOVING;
	
	static _canShoot = function(){
		var _dist = point_distance(owner.x, owner.y, target.x, target.y);
		if(_dist >= shootingRange){ 
			return false; 
		} else {
			return true;
		}
	}
	static _turnIntoTurret = function(){
		script_general_explosions(owner.x, owner.y, true, c_purple, c_fuchsia, 2, 6, 30, 65, 1, 2);	
		script_general_explosions(owner.x, owner.y, true, c_purple, c_fuchsia, 2, 6, 20, 45, 1, 4);	
		owner.sprite_index = turretSpr;
		owner.image_index  = 0;
		owner.speed = 0;
		actualHp = actualHp / 2;
	}
	static shootingMode = function(){
		shootActualDelay++;
		if(shootActualDelay >= shootDelay){
			var _bullet = instance_create_layer(owner.x, owner.y, "Bullets", obj_enemy_tucson_bullets);
			_bullet.proyectile_spd = shootSpd;
			_bullet.proyectile_dmg = shootDmg;
			_bullet.proyectile_dir = owner.direction;
			_bullet.trailColor = c_red;
			_bullet.depth = -1;
			shootActualDelay = 0;
		}
	}
	
	static update = function(){
		if(isAlive == false){
			instance_destroy(owner);
		}
		spriteChangeByHp(owner);
		switch(state){
			case ENEMY_STATE.MOVING:
				moveToTarget(target);
				if(_canShoot()){ state = ENEMY_STATE.MODE_CHANGE };
				break;
			case ENEMY_STATE.MODE_CHANGE:
				_turnIntoTurret();
				state = ENEMY_STATE.TURRET;
				break;
			case ENEMY_STATE.TURRET:
				shootingMode();
				break;
		}
		
	}
}