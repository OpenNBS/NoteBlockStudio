function draw_window_macro_setpanning() {
	// draw_window_setpanning()
	var x1, y1, a, b, str, total_vals, val, decr, inc;
	if (songs[song].selected == 0) {
		window = 0
		return 0
	}
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	text_exists[0] = 0
	x1 = floor(rw / 2 - 80)
	y1 = floor(rh / 2 - 80) + windowoffset
	draw_window(x1, y1, x1 + 140, y1 + 130)
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Set note panning")
	else draw_text_dynamic(x1 + 8, y1 + 8, "设置声道")

	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 1)
	}
	if (language != 1) draw_areaheader(x1 + 10, y1 + 53, 120, 35, "Panning")
	else draw_areaheader(x1 + 10, y1 + 53, 120, 35, "声道")
	setpan = median(-100, draw_dragvalue(12, x1 + 55, y1 + 65, setpan, 0.1), 100)

	draw_theme_color()
	if (draw_button2(x1 + 10, y1 + 98, 60, "OK")) {
		windowalpha = 0
		windowclose = 0
		windowopen = 0
		window = 0
		selection_change(m_pan, setpan + 100, false)
		if(!keyboard_check(vk_alt)) selection_place(false)
	}
	if (draw_button2(x1 + 70, y1 + 98, 60, condstr(language !=1, "Cancel", "取消")) && (windowopen = 1 || theme != 3)) {windowclose = 1}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
