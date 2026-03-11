spawnTimeActual ++;
if spawnTimeActual == spawnTimeMax {
	instance_create_layer(x, random_range(0, room_height), "Enemies", obj_big_stellarite)
	spawnTimeActual = 0;
}