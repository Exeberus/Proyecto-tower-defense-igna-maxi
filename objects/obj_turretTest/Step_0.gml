var target_angle = point_direction(x, y, mouse_x, mouse_y);
image_angle = target_angle;

if (mouse_check_button(mb_left) && can_shoot) {
    
    var bala = instance_create_layer(x, y, "Instances", obj_bulletTest);
    
    bala.direction = image_angle;
    bala.image_angle = image_angle;
    
    can_shoot = false;
    alarm[0] = shoot_delay; 
}