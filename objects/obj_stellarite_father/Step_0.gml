image_angle += rot_speed;
speed += random_range(-0.05, 0.05);
direction += random_range(-2, 2);

direction = clamp(direction, 150, 210);
speed = clamp(speed, 0.1, 2.5);

if(hp <= 0){
	instance_destroy();
}