bubbleActive = true;
bubbleHp = 10;
bubbleActualHp = bubbleHp;

bubbleRadio = 120;
var _diameter = bubbleRadio * 2;
var _scale = _diameter / 32;
image_xscale = _scale;
image_yscale = _scale;
image_alpha = 0;

creator = noone;

//Local Particle System 
//Bubble generation
shield_sys = part_system_create();
part_system_depth(shield_sys, depth - 1);
part_aura = part_type_create();
part_type_shape(part_aura, pt_shape_pixel);
part_type_size(part_aura, 2, 8, -0.05, 0); 
part_type_color1(part_aura, c_aqua);
part_type_alpha2(part_aura, 0.6, 0);
part_type_life(part_aura, 300, 600);
//Bubble Hit
shieldHit_sys = part_system_create();
part_system_depth(shieldHit_sys, depth - 1);
part_auraHitted = part_type_create();
part_type_shape(part_auraHitted, pt_shape_pixel);
part_type_size(part_auraHitted, 2, 8, -0.05, 0); 
part_type_color1(part_auraHitted, c_red);
part_type_alpha2(part_auraHitted, 0.6, 0);
part_type_life(part_auraHitted, 300, 600);
