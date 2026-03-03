event_inherited();
//Shield Properties
shieldHp = 5;
shieldHpPorcentage = shieldHp / 4;
shieldActualHp = shieldHp;

//Bubble Properties
canCreateBubble = true;
bubbleIsActive = false;
bubbleCanRecharge = true;
bubbleRechargeSpeed = 2;
myBubble = instance_create_layer(x, y, "Instances", obj_stellarite_bubbleField_mk1);


//Local Turret Particles
shield_sys = part_system_create();
part_system_depth(shield_sys, depth - 1);
part_aura = part_type_create();
part_type_shape(part_aura, pt_shape_pixel);
part_type_color1(part_aura, c_aqua);
part_type_alpha2(part_aura, 0.5, 0);
part_type_life(part_aura, 20, 40);
part_type_direction(part_aura, 0, 359, 0, 0);
part_type_speed(part_aura, 0.5, 1, -0.01, 0);