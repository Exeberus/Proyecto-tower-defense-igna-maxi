function StorageModule(_owner, _maxSlots) constructor {
	//Properties
	owner = _owner;
	maxSlots = 4;
	count = 0;
	minerals = array_create(maxSlots, noone);
	
	slotOffsets = [
		{ x: -8, y: -8 },
        { x:  8, y: -8 }, 
        { x: -8, y:  8 },  
        { x:  8, y:  8 }
	]
	
	glow_sys  = part_system_create();
	part_system_depth(glow_sys, owner.depth - 2);
	glow_part = part_type_create();
	part_type_shape(glow_part, pt_shape_pixel);
	part_type_size(glow_part, 0.25, 1.5, -0.05, 0);
	part_type_color2(glow_part, c_yellow, c_white);
	part_type_alpha2(glow_part, 0.8, 0);
	part_type_life(glow_part, 20, 40);
	part_type_direction(glow_part, 0, 359, 0, 0);
	part_type_speed(glow_part, 0.2, 0.65, -0.02, 0);
	
	//Methods
	static _snapMineralToSlot = function(_mineral, _slotIndex){
		_mineral.x = owner.x + slotOffsets[_slotIndex].x;
        _mineral.y = owner.y + slotOffsets[_slotIndex].y;
        _mineral.visible = true;
        _mineral.reserved = true;
		_mineral.depth   = owner.depth - 1;
	}
	static _addMineral = function(_mineral){
		if(isFull()) return false;
		for (var i = 0; i < maxSlots; i++) {
            if (minerals[i] == noone) {
                minerals[i] = _mineral;
                count++;
                _snapMineralToSlot(_mineral, i);
                return true;
            }
        }
        return false;

	}
	static _removeMinerals = function(){
		for (var i = maxSlots - 1; i >= 0; i--) {
            if (minerals[i] != noone) {
                var _m      = minerals[i];
                minerals[i] = noone;
                count       = max(count - 1, 0);
                return _m;
            }
        }
        return noone;
	}
	static isFull = function(){ return count >= maxSlots; }
	static fillRatio = function(){ return count / maxSlots; }
	
	static update = function(){
		for (var i = 0; i < maxSlots; i++) {
            if (minerals[i] != noone) {
                if (!instance_exists(minerals[i])) {
                    minerals[i] = noone;
                    count = max(count - 1, 0);
                } else {
                    _snapMineralToSlot(minerals[i], i);
					var _mx = owner.x + slotOffsets[i].x;
	                var _my = owner.y + slotOffsets[i].y;
	                repeat (2) {
	                    part_particles_create(glow_sys, _mx, _my, glow_part, 1);
	                }
                }
            }
        }
	}
	static cleanUp = function() {
	    if (part_system_exists(glow_sys)) part_system_destroy(glow_sys);
	    if (part_type_exists(glow_part))  part_type_destroy(glow_part);
	}
};

function DroneModule() constructor {
	
}

enum DRONE_STATE { IDLE, FLYING_TO_MINERAL, RETURNING }
function DroneUnit(_self, _owner, _searchRadius, _speed) constructor {
	//Properties
	drone = _self;
	owner = _owner;
	searchRadius = _searchRadius;
	droneSpeed = _speed;
	drone.speed = 0;
	
	state = DRONE_STATE.IDLE;
	targetMineral = noone;
	carriedMineral = noone;
	
	//Necesario=?
	idleTimer = 0;
	maxIdleWait = 60;
	
	//Methods
	static _searchMineral = function(){
		if(!instance_exists(owner)) return; //Y/O Eliminacion Dron Asociado
		//if (!variable_instance_exists(owner, "storageModule")) return;
        //if (owner.storageModule.isFull()) return;
		var _closest = noone;
		var _closestDist = searchRadius;
		var _droneX      = drone.x;  
		var _droneY      = drone.y;
		
		with(obj_mineral_stellarite_l1){ //Pasar por parametro como array
			if(reserved) continue;
			var _d = point_distance(_droneX, _droneY, x, y);
            if (_d < _closestDist) {
                _closestDist = _d;
                _closest     = id;
            }
		}
		
		if(_closest != noone){
			targetMineral = _closest;
			targetMineral.reserved = true;
			state = DRONE_STATE.FLYING_TO_MINERAL;
		}
	}
	static _pickUpMineral = function(){
		if (!instance_exists(targetMineral)) {
            state = DRONE_STATE.IDLE;
            return;
        }
		carriedMineral = targetMineral;
		targetMineral = noone;
		state = DRONE_STATE.RETURNING;
	}
	static _depositMineral = function(){
		if (!instance_exists(owner) || !variable_instance_exists(owner, "storageModule")) {
            state = DRONE_STATE.IDLE;
            return;
        }
		var _deposited = owner.storageModule._addMineral(carriedMineral);
		if (!_deposited) {
            if (instance_exists(carriedMineral)) {
                carriedMineral.reserved = false;
            }
        }
		carriedMineral = noone;
        state          = DRONE_STATE.IDLE;
	}
		
	static update = function(){
		switch(state) {
			case DRONE_STATE.IDLE:
				if(!instance_exists(owner)){
					instance_destroy(drone);
					return;
				}
				drone.x = lerp(drone.x, owner.x, 0.1);
                drone.y = lerp(drone.y, owner.y, 0.1);
				
				idleTimer++;
				if(idleTimer >= maxIdleWait){
					idleTimer = 0;
					_searchMineral();
				}
				break;
				
			case DRONE_STATE.FLYING_TO_MINERAL:
				if (!instance_exists(targetMineral)) {
                    state = DRONE_STATE.IDLE;
                    break;
                }
				var _dx = targetMineral.x - drone.x;
                var _dy = targetMineral.y - drone.y;
				var _dist = point_distance(drone.x, drone.y, targetMineral.x, targetMineral.y);
				
				if(_dist <= droneSpeed){
					drone.x = targetMineral.x;
                    drone.y = targetMineral.y;
                    _pickUpMineral();
                } else {
                    drone.x += (_dx / _dist) * droneSpeed;
                    drone.y += (_dy / _dist) * droneSpeed;
                    drone.image_angle = point_direction(0, 0, _dx, _dy);
                }	
				break;
				
			case DRONE_STATE.RETURNING:
				var _dx   = owner.x - drone.x;
                var _dy   = owner.y - drone.y;
                var _dist = point_distance(drone.x, drone.y, owner.x, owner.y);
				
				if (instance_exists(carriedMineral)) {
                    carriedMineral.x = drone.x;
                    carriedMineral.y = drone.y;
                } else {
					state = DRONE_STATE.IDLE;
				}
				
				if (_dist <= droneSpeed) {
                    _depositMineral();
                } else {
                    drone.x += (_dx / _dist) * droneSpeed;
                    drone.y += (_dy / _dist) * droneSpeed;
                    drone.image_angle = point_direction(0, 0, _dx, _dy);
                }
				break;
		}
	};
	
}