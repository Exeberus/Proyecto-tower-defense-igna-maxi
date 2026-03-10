if (bubbleClass != noone && bubbleClass.state == BUBBLE_STATE.ACTIVE) {
    var _h = 16; 
	var _w = 16; 
    if (other.sprite_index != -1) {
        _h = sprite_get_height(other.sprite_index);
		_w = sprite_get_width(other.sprite_index);
    }
    bubbleClass.emitFilterWarning(other.x, other.y, _h, _w);
}