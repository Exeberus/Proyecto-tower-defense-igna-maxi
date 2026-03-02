if (build_mode) {

    var snapped_x = floor(mouse_x / grid_size) * grid_size + grid_size * 0.5;
    var snapped_y = floor(mouse_y / grid_size) * grid_size + grid_size * 0.5;

    // Espera a que el jugador suelte el click primero
    if (build_wait_release) {
        if (!mouse_check_button(mb_left)) {
            build_wait_release = false;
        }
    }
    else {
        // Ahora sí puede colocar
        if (mouse_check_button_pressed(mb_left)) {
            instance_create_layer(snapped_x, snapped_y, "Instances", build_object);

            build_mode = false;
            build_object = noone;
			build_wait_release = true;
        }
    }
}