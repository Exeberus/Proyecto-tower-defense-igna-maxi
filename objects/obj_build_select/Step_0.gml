if position_meeting(mouse_x, mouse_y, id) {
	if image_angle < 45 {
		image_angle += 2;
	}
} else {
	if image_angle > 0 {
		image_angle -= 3
	}
}