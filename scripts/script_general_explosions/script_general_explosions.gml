function script_general_explosions(_x, _y, _personalizedValues, _colorGradient1, _colorGradient2, _minSize, _maxSize, _minLife, _maxLife, _minSpeed, _maxSpeed){
	var _exp = instance_create_layer(_x, _y, "Instances", obj_explosion);
	
	if(_personalizedValues){
		_exp.colorGradient[0] = _colorGradient1
		_exp.colorGradient[1] = _colorGradient2;
		_exp.minSize = _minSize;
		_exp.maxSize = _maxSize;
		_exp.minLife = _minLife;
		_exp.maxLife =_maxLife;
		_exp.minSpeed = _minSpeed;
		_exp.maxSpeed = _maxSpeed;
		_exp.initialized = true;
	} else{
		_exp.initialized = true;
	}
	

}
