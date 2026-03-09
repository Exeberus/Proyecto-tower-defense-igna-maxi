if (mouse_check_button_pressed(mb_left)) {
	if (point_distance(x, y, mouse_x, mouse_y) <= 16) {
		if (global.selectedDrone == id) {
		    global.selectedDrone = noone;
		} else {
		    global.selectedDrone = id;
		}
	}
}

if(droneClass != noone) { droneClass.update(); }
