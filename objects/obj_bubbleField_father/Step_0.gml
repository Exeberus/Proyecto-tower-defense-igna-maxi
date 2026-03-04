if(image_alpha < 0.7) image_alpha += 0.5;
if (radio != 0) {
    var _diameter = radio * 2;
    var _targetScale = (radio * 2) / sprite_get_width(sprite_index);
	image_xscale = lerp(image_xscale, _targetScale, 0.2);
	image_yscale = lerp(image_yscale, _targetScale, 0.2);
}
if (!instance_exists(creator)) {
    instance_destroy();
}

