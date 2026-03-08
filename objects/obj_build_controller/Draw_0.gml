if (build_mode) {
	var snapped_x = floor(mouse_x / grid_size) * grid_size + grid_size * 0.5;
	var snapped_y = floor(mouse_y / grid_size) * grid_size + grid_size * 0.5;
	
    var bay = instance_position(snapped_x, snapped_y, obj_turret_bay);
	
	// Cambiar de color icono.
	var can_build = false;
	
	if build_object == obj_turret_bay {
		if bay == noone {
			can_build = true;
		}
	}
	else {
		if (bay != noone && !bay.is_ocuppied) {
			can_build = true;
		}
	}
	
	// Cambiar color
	if can_build {
		draw_set_colour(c_lime);
		
		draw_text_colour(mouse_x, mouse_y + 60, "Can Build", c_lime, c_lime, c_lime, c_lime, 1);
	} else {
		draw_set_colour(c_red);
		
		draw_text_colour(mouse_x, mouse_y + 60, "Cant Build", c_red, c_red, c_red, c_red, 1);
	}
	
	draw_sprite_ext(get_build_sprite, 0, snapped_x, snapped_y, 1, 1, 0, draw_get_colour(), 0.5);
	
	draw_set_alpha(0.5);
	draw_sprite(get_build_sprite, 0, snapped_x, snapped_y);
	draw_set_alpha(1);
	
	draw_set_font(fnt_pixel_font_small);
	draw_text_colour(mouse_x, mouse_y + 15, string(build_name), c_white, c_white, c_aqua, c_aqua, 1);
	
	draw_text_colour(mouse_x, mouse_y + 40, "- Left Click to Build", c_white, c_white, c_white, c_white, 1);
	draw_text_colour(mouse_x, mouse_y + 50, "- Right Click to Cancel", c_white, c_white, c_white, c_white, 1);

	draw_set_colour(c_white)
}