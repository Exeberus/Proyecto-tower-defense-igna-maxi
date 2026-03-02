if (build_mode)
{
	var snapped_x = floor(mouse_x / grid_size) * grid_size + grid_size * 0.5;
	var snapped_y = floor(mouse_y / grid_size) * grid_size + grid_size * 0.5;
	
	draw_set_alpha(0.5);
	draw_sprite(object_get_sprite(build_object), 0, snapped_x, snapped_y);
	draw_set_alpha(1);
}