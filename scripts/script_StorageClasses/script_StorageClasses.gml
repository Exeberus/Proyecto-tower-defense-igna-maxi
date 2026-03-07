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
	
	//Minerals Particles
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
	//Enroll Particles
	highlight_sys  = part_system_create();
	part_system_depth(highlight_sys, owner.depth - 3);
	highlight_part = part_type_create();
	part_type_shape(highlight_part, pt_shape_pixel);
	part_type_size(highlight_part, 1, 3, -0.06, 0);
	part_type_color2(highlight_part, c_green, c_white);
	part_type_alpha2(highlight_part, 1, 0);
	part_type_life(highlight_part, 15, 30);
	part_type_direction(highlight_part, 0, 359, 0, 0);
	part_type_speed(highlight_part, 0.5, 2, -0.05, 0);
	
	highlightActive  = false;
	highlightTimer   = 0;
	highlightSpeed   = 0.08;
	
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
	
	static enrollDroneToStorage = function(){
		if(!variable_global_exists("selectedDrone")){ return };
		highlightActive = (global.selectedDrone != noone);
		if (highlightActive) {
		    highlightTimer += highlightSpeed;

			var _sin = (sin(highlightTimer * 3) + 1) / 2;  
		    owner.image_blend = merge_color(c_white, c_lime, _sin);
		    var _pulse = 1 + (0.1 * _sin);
		    owner.image_xscale = _pulse;
		    owner.image_yscale = _pulse;
		    repeat (3) {
		        var _angle = random(360);
		        part_particles_create(
		            highlight_sys,
		            owner.x + lengthdir_x(20, _angle),
		            owner.y + lengthdir_y(20, _angle),
		            highlight_part, 1
		        );
		    }

		    if (mouse_check_button_pressed(mb_left)) {
		        var _mx = mouse_x;
		        var _my = mouse_y;
		        if (point_in_rectangle(_mx, _my, owner.bbox_left, owner.bbox_top, owner.bbox_right, owner.bbox_bottom)) {
		            if (instance_exists(global.selectedDrone)) {
		                global.selectedDrone.droneClass.designatedStorageModule = owner;
		                show_debug_message("Dron asignado a storage: " + string(owner));
		            }
		            global.selectedDrone = noone;
		        }
		    }
		} else {
		    highlightTimer     = 0;
	        owner.image_blend  = c_white;
	        owner.image_xscale = 1;
	        owner.image_yscale = 1;
		}
	}
	static update = function(){
		enrollDroneToStorage();
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
		if (part_system_exists(highlight_sys)) part_system_destroy(highlight_sys);
		if (part_type_exists(highlight_part))  part_type_destroy(highlight_part);
	}
};

function DroneModule(_droneModule, _droneObject, _droneSpeed,_droneCount, _searchRadius) constructor {
	droneModule  = _droneModule;
    droneObject  = _droneObject;
	droneSpeed = _droneSpeed;
    droneCount   = _droneCount;   
    searchRadius = _searchRadius;
	
	drones = array_create(droneCount, noone);
	
	static _spawnDrone = function(_index){
		var _inst = instance_create_layer(droneModule.x, droneModule.y, "Instances", droneObject);
		_inst.droneClass = new DroneUnit(_inst, droneModule, searchRadius, droneSpeed);
		_inst.depth--;
		drones[_index] = _inst;
	}
	static _spawnAllDrones = function(){
		for (var i = 0; i < droneCount; i++) {
            _spawnDrone(i);
        }	
	}

	static addDrone = function(){
		droneCount++;
        array_push(drones, noone);
        _spawnDrone(droneCount - 1);
	}
	static update = function(){
		for (var i = 0; i < droneCount; i++) {
            if (!instance_exists(drones[i])) {
                _spawnDrone(i);
            } else {
                drones[i].droneClass.update();
            }
        }
	}
	static cleanUp = function(){
		for (var i = 0; i < droneCount; i++) {
            if (instance_exists(drones[i])) instance_destroy(drones[i]);
        }
	}
	
	_spawnAllDrones();
}

enum DRONE_STATE { IDLE, FLYING_TO_MINERAL, RETURNING }
function DroneUnit(_self, _owner, _searchRadius, _speed) constructor {
	//Properties
	drone = _self;
	owner = _owner;
	designatedStorageModule = noone;
	searchRadius = _searchRadius;
	droneSpeed = _speed;
	drone.speed = 0;
	
	state = DRONE_STATE.IDLE;
	targetMineral = noone;
	carriedMineral = noone;
	
	idleTimer = 0;
	maxIdleWait = 60;
	
	orbitAngle  = random(360); 
	orbitSpeed  = 1;          
	orbitRadius = 50;  
	
	//Methods
	static _searchMineral = function(){
		if(!instance_exists(owner)) return; //Y/O Eliminacion Dron Asociado
		if (!variable_instance_exists(designatedStorageModule, "storageModule")) return;
        if (designatedStorageModule.storageModule.isFull()) return;
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
		if (!instance_exists(owner) || !instance_exists(designatedStorageModule) || !variable_instance_exists(designatedStorageModule, "storageModule")) {
            state = DRONE_STATE.IDLE;
            return;
        }
		var _deposited = designatedStorageModule.storageModule._addMineral(carriedMineral);
		if (!_deposited && instance_exists(carriedMineral)) {
             carriedMineral.reserved = false;
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
				orbitAngle += orbitSpeed;
				if(designatedStorageModule != noone){
				    var _targetX = designatedStorageModule.x + lengthdir_x(orbitRadius, orbitAngle);
				    var _targetY = designatedStorageModule.y + lengthdir_y(orbitRadius, orbitAngle);
				    drone.x = lerp(drone.x, _targetX, 0.1);
				    drone.y = lerp(drone.y, _targetY, 0.1);
				    drone.image_angle = orbitAngle + 90;
				} else {
				    drone.x = owner.x + lengthdir_x(orbitRadius, orbitAngle);
				    drone.y = owner.y + lengthdir_y(orbitRadius, orbitAngle);
				    drone.image_angle = orbitAngle + 90;
				}
				
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
				var _dx   = designatedStorageModule.x - drone.x;
                var _dy   = designatedStorageModule.y - drone.y;
                var _dist = point_distance(drone.x, drone.y, designatedStorageModule.x, designatedStorageModule.y);
				
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