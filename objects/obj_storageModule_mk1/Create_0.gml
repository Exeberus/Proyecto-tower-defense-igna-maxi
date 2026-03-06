storageModule = new StorageModule(id, 4); 
droneTest = instance_create_layer(x+50, y+50, "Instances", obj_stellarite_droneCollector_mk1);
droneTest.myDroneCollector = new DroneUnit(droneTest, id, 1000, 2);