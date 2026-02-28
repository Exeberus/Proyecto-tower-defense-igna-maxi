hp -= 1;
instance_destroy(other);
image_xscale -= 0.05;
image_yscale -= 0.05;
if(hp <= 0){
	instance_destroy();
}