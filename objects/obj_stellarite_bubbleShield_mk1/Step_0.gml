//event_inherited();

//Shield

//Shield Particles
for(i=0;i<3;i++){
	if (shieldActualHp > 0) {
	    var angle = random(360);
	    var dist = random(128);
	    var px = x + lengthdir_x(dist, angle);
	    var py = y + lengthdir_y(dist, angle);
	    part_particles_create(shield_sys, px, py, part_aura, 1);
	}
}


//Bubble
if (!instance_exists(myBubble) && canCreateBubble) {
    myBubble = instance_create_layer(x, y, "Instances", obj_stellarite_bubbleField_mk1);
	bubbleIsActive = true;
    with(myBubble) {
        creator = other.id;
        radio = 120;
    }
}
if(instance_exists(myBubble)){
	myBubble.x = x;
    myBubble.y = y;
}






