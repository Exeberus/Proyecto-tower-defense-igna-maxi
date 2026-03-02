event_inherited();

var inst1 = instance_create_layer(x, y, "Instances",  obj_small_stellarite);
inst1.direction = 270 - random_range(10, 35); 
inst1.speed = speed + 0.15;
var inst2 = instance_create_layer(x, y, "Instances",  obj_small_stellarite);
inst2.direction = 270 + random_range(10, 35); 
inst2.speed = speed + 0.15;

script_asteroid_explosion(x, y, make_color_rgb(120,120,120), 3, 2, 2, 240, spr_small_stellarite);
