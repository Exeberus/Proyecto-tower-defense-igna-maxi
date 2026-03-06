if (build_mode) {	
	var snapped_x = floor(mouse_x / grid_size) * grid_size + grid_size * 0.5;
    var snapped_y = floor(mouse_y / grid_size) * grid_size + grid_size * 0.5;
	
	bay = instance_position(snapped_x, snapped_y, obj_turret_bay); // Detectar si esta sobre una Bahia

    // Espera a que el jugador suelte el click primero
    if (build_wait_release) {
        if !mouse_check_button(mb_left) {
            build_wait_release = false;
        }
    } else if mouse_check_button(mb_right){
		build_mode = false;
        build_object = noone;
		build_wait_release = true;
	}
    else {
        // Ahora sí puede colocar
		if build_object == obj_turret_bay {
			if mouse_check_button_pressed(mb_left) && bay == noone {
				instance_create_layer(snapped_x, snapped_y, "Turrets", build_object);
				
				bay.is_ocuppied = true;
	            build_mode = false;
	            build_object = noone;
				build_wait_release = true;
				
			} else if mouse_check_button_pressed(mb_left) && bay != noone && !bay.is_ocuppied {
	            instance_create_layer(snapped_x, snapped_y, "Turrets", build_object);
				
				bay.is_ocuppied = true;
	            build_mode = false;
	            build_object = noone;
				build_wait_release = true;
			}
		}
    }
}