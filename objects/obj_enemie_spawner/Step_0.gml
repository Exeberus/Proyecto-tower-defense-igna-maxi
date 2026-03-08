spawnTimeActual ++;
if spawnTimeActual == spawnTimeMax {
	instance_create_layer(x, random_range(0, room_height), "Instances", obj_test_enemy)
	spawnTimeActual = 0;
}