if(instance_exists(creator)) {
	var _hitted = creator.myShield.bulletCollision(other);
	if(_hitted){
		part_particles_create(shieldHit_sys, other.x, other.y, part_auraHitted, 15);
	    image_blend = c_red;
	    image_alpha = 1;      
	    image_xscale *= 1.05; 
	    image_yscale *= 1.05;
	    alarm[0] = 3;
	}
}