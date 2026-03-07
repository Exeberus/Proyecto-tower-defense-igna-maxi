if (variable_global_exists("selectedDrone") && global.selectedDrone == id) {
    global.selectedDrone = noone;
} else {
    global.selectedDrone = id;
}