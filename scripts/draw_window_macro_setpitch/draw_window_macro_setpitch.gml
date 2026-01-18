function draw_window_macro_setpitch() {
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
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Set note pitch")
	else draw_text_dynamic(x1 + 8, y1 + 8, "设置音高")
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 1)
	}
	if (language != 1) draw_areaheader(x1 + 10, y1 + 53, 120, 35, "Pitch")
	else draw_areaheader(x1 + 10, y1 + 53, 120, 35, "音高")
	setpit = median(-1200, draw_dragvalue(18, x1 + 55, y1 + 65, setpit, 0.1), 1200)

	draw_theme_color()
	if (language != 1) {if (draw_checkbox(x1 + 15, y1 + 80, addpitch, "Add mode", "Add the pitch amount to each note,\ninstead of setting it.", 0, 1)) addpitch = !addpitch}
	else {if (draw_checkbox(x1 + 15, y1 + 80, addpitch, "加法模式", "将数值叠加至音符上，而不是直接设置。", 0, 1)) addpitch = !addpitch}
	if (draw_button2(x1 + 10, y1 + 98, 60, condstr(language != 1, "OK", "确定"))) {
		windowalpha = 0
		windowclose = 0
		windowopen = 0
		window = 0
		selection_change(m_pit, setpit, addpitch)
		if(!keyboard_check(vk_alt)) selection_place(false)
	}
	if (draw_button2(x1 + 70, y1 + 98, 60, condstr(language !=1, "Cancel", "取消")) && (windowopen = 1 || theme != 3)) {windowclose = 1}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
