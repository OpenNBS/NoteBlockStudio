function draw_areaheader(argument0, argument1, argument2, argument3, argument4) {
	// draw_areaheader(x, y, w, h, str)
	var xx, yy, w, h, str;
	xx = argument0
	yy = argument1
	w = argument2
	h = argument3
	str = argument4
	switch (theme) {
	    case 0:
	        draw_set_color(make_color_rgb(213, 223, 229))
			draw_rectircle(xx, yy, xx + w, yy + h, 1)
			draw_set_color(c_white)
	        break;
	    case 1:
	        draw_frame(xx, yy, xx + w, yy + h)
			draw_set_color(13160660)
	        break;
		case 2:
			draw_frame(xx, yy, xx + w, yy + h)
			draw_set_color(c_dark)
			break;
		case 3:
			draw_set_color(15987699)
			if (fdark) draw_set_color(2105376)
			break;
	}
	if (theme != 3) draw_rectangle(xx + 12, yy - 6, xx + 12 + string_width_dynamic(str) + 6, yy + 6, 0)
	draw_theme_color()
	draw_text_dynamic(xx + 16, yy - 6, str)



}
