function draw_window_macro_setvelocity() {
	// draw_window_setvelocity()
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
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Set note velocity")
	else draw_text_dynamic(x1 + 8, y1 + 8, "设置音量")
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 1)
	}
	if (language != 1) draw_areaheader(x1 + 10, y1 + 53, 120, 35, "Velocity")
	else draw_areaheader(x1 + 10, y1 + 53, 120, 35, "音量")
	setvel = median(0, draw_dragvalue(10, x1 + 55, y1 + 65, setvel, 0.1), 100 + (percentvel * 900))

	draw_theme_color()
	if (language != 1) {if (draw_checkbox(x1 + 15, y1 + 80, percentvel, "Percent", "Apply the velocity as a percentage\nof each note's current velocity.", 0, 1)) percentvel = !percentvel}
	else {if (draw_checkbox(x1 + 15, y1 + 80, percentvel, "百分比", "按百分比应用至每个音符。", 0, 1)) percentvel = !percentvel}
	if (draw_button2(x1 + 10, y1 + 98, 60, condstr(language != 1, "OK", "确定"))) {
		windowalpha = 0
		windowclose = 0
		windowopen = 0
		window = 0
		if (!percentvel) {
			selection_change(m_vel, setvel, false)
		} else {
			str = songs[song].selection_code
			if (songs[song].selected = 0) return 0
			for (a = 0; a < songs[song].selection_l; a += 1) {
			    if (songs[song].selection_colfirst[a] > -1) {
			        for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
			            if (songs[song].selection_exists[a, b]) {
							songs[song].selection_vel[a, b] = songs[song].selection_vel[a, b] * setvel / 100
			            }
			        }
			    }
			}
			selection_code_update()
			history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)
		}
		if(!keyboard_check(vk_alt)) selection_place(false)
	}
	if (draw_button2(x1 + 70, y1 + 98, 60, condstr(language != 1, "Cancel", "取消")) && (windowopen = 1 || theme != 3)) {windowclose = 1}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
