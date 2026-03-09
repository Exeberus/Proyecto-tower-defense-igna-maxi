function SpaceshipCore(_owner, _hp) constructor{
	owner = _owner;
	hp = _hp;
	actualHp = _hp;
	isAlive = true;
	
	modules = [];
	isDestroying = false;
	destroyIndex   = 0;      
    destroyTimer   = 0;
    destroyDelay   = 8;
	
	static _spawnExplosion = function(_x, _y) {
		script_general_explosions(_x,_y, false, 0,0,0,0,0,0);
    }
	static _destroySequence = function() {
        destroyTimer++;
        if (destroyTimer < destroyDelay) return;
        destroyTimer = 0;
		destroyDelay = random_range(6, 12);

        if (destroyIndex < array_length(modules)) {
            var _mod = modules[destroyIndex];
            if (instance_exists(_mod)) {
                _spawnExplosion(_mod.x, _mod.y);
				_mod.visible = false;
                instance_destroy(_mod);
            }
            destroyIndex++;
        } else {
            script_general_explosions(owner.x, owner.y, true, c_white, c_yellow, 8, 20, 60, 120, 5, 15);
			script_general_explosions(owner.x, owner.y, true, c_red, c_orange, 4, 12, 40, 80, 8, 20);
			script_general_explosions(owner.x, owner.y, true, c_gray, c_dkgray, 2, 6, 80, 150, 1, 3);
            instance_destroy(owner);
        }
		global.gameOver = true;
    }
	
	static registerModule = function(_module){
		array_push(modules, _module);
	}
	static unregisterModule = function(_module){
		for (var i = array_length(modules) - 1; i >= 0; i--) {
            if (modules[i] == _module) {
                array_delete(modules, i, 1);
                break;
            }
        }
	}
	static _shuffleModules = function() {
        var _len = array_length(modules);
        for (var i = _len - 1; i > 0; i--) {
            var _j     = irandom(i);
            var _aux  = modules[i];
            modules[i] = modules[_j];
            modules[_j] = _aux;
        }
    }
	
	static hpRatio = function() { return actualHp / hp; }
	static _onDeath = function(){
		isAlive = false;
		isDestroying = true;
		destroyIndex = 0;
		destroyTimer = 0;
		_shuffleModules();
	}
	static takeDamage = function(_dmg){
		if(!isAlive){ return };
		actualHp -= _dmg;
		actualHp  = max(actualHp, 0);
		if(actualHp <= 0){
			_onDeath();
		}
	}
	
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
	static bulletCollision = function(_proyectile){
		takeDamage(_proyectile.proyectile_dmg);
		instance_destroy(_proyectile);
	}

	static update = function(){
		spriteChangeByHp(owner);
		if(!isAlive){
			isDestroying = true;	
		}
		if(isDestroying){
			_destroySequence();	
		}
	}
	
}