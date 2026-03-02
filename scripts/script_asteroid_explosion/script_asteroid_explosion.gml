function script_asteroid_explosion(_x, _y, _color, _amount, _size, _speed, _life, _sprite){
	var p = instance_create_layer(_x, _y, "Instances", obj_generator_particle);
    
    p.settings = {
        color  : _color,
		amount : _amount,
		size   : _size,
		speed  : _speed,
		life :  _life,
		sprite: _sprite
    };
	
	p.initialize(); 
};