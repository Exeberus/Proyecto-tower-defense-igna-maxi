draw_self();
if mouseDetect {
	draw_set_font(fnt_pixel_font_small)
	draw_text_colour(x - 15, y + 20, string(object_build_name), c_white, c_white, c_white, c_white, 1);
	draw_text_colour(x - 15, y + 35, "Materials:", c_white, c_white, c_white, c_white, 1);
	draw_text_colour(x - 15, y + 45, "Stellarite: x" + string(stellaritePrice), c_yellow, c_yellow, c_yellow, c_yellow, 1);
}