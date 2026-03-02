function initialize() {
	partSystem = part_system_create();
	part_system_depth(partSystem, depth);

	p_color  = c_white;
	p_amount = 10;
	p_size   = 1;
	p_speed  = 2;
	p_life   = 30;
	p_sprite = noone;

	if (variable_instance_exists(id, "settings")) {
	    p_color  = settings.color;
	    p_amount = settings.amount;
	    p_size   = settings.size;
	    p_speed  = settings.speed;
		p_life = settings.life;
		p_sprite = settings.sprite;
	};

	particle = part_type_create();

	//Config Particles
	if(!p_sprite) {
		part_type_shape(particle, pt_shape_pixel);;
	} else{
		part_type_sprite(particle, p_sprite, false, false, false);
	}
	part_type_color1(particle, p_color);
	part_type_size(particle, p_size*0.5, p_size, -0.05, 0);
	part_type_speed(particle, p_speed * 0.5, p_speed, 0, 0);
	part_type_life(particle, 15, p_life);
	part_type_direction(particle, 0, 360, 0, 0);
	part_type_alpha2(particle, 1, 0);
	part_type_gravity(particle, 0, 0);
	part_type_orientation(particle, 0, 360, 0, 0, true);

	part_particles_create(partSystem, x, y, particle, p_amount);
	alarm[0] = p_life + 5;
};