function draw_window_macro_portamento() {
	// draw_window_portamento()
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
	draw_text_dynamic(x1 + 8, y1 + 8, "Portamento")
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 1)
	}
	if (language != 1) {if (draw_checkbox(x1 + 10, y1 + 30, porta_reverse, "Reversed", "Portamento is done in the inverse direction.")) porta_reverse=!porta_reverse}
	else {if (draw_checkbox(x1 + 10, y1 + 30, porta_reverse, "反转", "反方向应用 Portamento。")) porta_reverse=!porta_reverse}
	if (language != 1) draw_areaheader(x1 + 10, y1 + 53, 120, 35, "Cent shift")
	else draw_areaheader(x1 + 10, y1 + 53, 120, 35, "偏移")
	port_cent = median(-1200, draw_dragvalue(11, x1 + 55, y1 + 65, port_cent, 0.1), 1200)

	draw_theme_color()
	if (draw_button2(x1 + 10, y1 + 98, 60, condstr(language !=1, "OK", "确定"))) {
		windowalpha = 0
		windowclose = 0
		windowopen = 0
		window = 0
		str = songs[song].selection_code
		var arr_data = selection_to_array_ext()
		total_vals = array_length(arr_data)
		decr = port_cent / macro_column_count(arr_data)
		inc = decr
		val = 0
		while (val < total_vals) {
			val += 6
			if porta_reverse = 1 {
				arr_data[real(val)] = real(port_cent) + real(decr)
			} else arr_data[real(val)] = arr_data[real(val)] + real(decr)
			val ++
			while arr_data[val] != -1 {
				val += 5
				if porta_reverse = 1 {
					arr_data[real(val)] = real(port_cent) + real(decr)
				} else arr_data[real(val)] = arr_data[real(val)] + real(decr)
				val ++
			}
			if porta_reverse = 1 {
				decr = decr - inc
			} else decr = decr + inc
			val ++
		}
		selection_load_from_array(songs[song].selection_x, songs[song].selection_y, arr_data)
		history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)
		if(!keyboard_check(vk_alt)) selection_place(false)
	}
	if (draw_button2(x1 + 70, y1 + 98, 60, condstr(language !=1, "Cancel", "取消")) && (windowopen = 1 || theme != 3)) {windowclose = 1}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
