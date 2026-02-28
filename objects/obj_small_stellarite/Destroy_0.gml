event_inherited();
repeat(2){
	var inst = instance_create_layer(x, y, "Instances", obj_mineral_stellarite_l1);
	inst.direction = random_range(220, 320);
	inst.speed = speed + 0.15;
}
script_asteroid_explosion(x, y, make_color_rgb(120,120,120), 3, 2, 3, 240, spr_mineral_stellarite_l1);