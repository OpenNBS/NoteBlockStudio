function draw_window_macro_arpeggio() {
	// draw_window_macro_arpeggio()
	var x1, y1, a, i, pattern, str, total_vals, val, arplen
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
	draw_text_dynamic(x1 + 8, y1 + 8, "Arpeggio")
	pattern = ""
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 1)
	}
	if (language != 1) draw_areaheader(x1 + 10, y1 + 43, 120, 35, "Pattern")
	else draw_areaheader(x1 + 10, y1 + 43, 120, 35, "规律")

	if (language != 1) pattern = draw_textarea(57, x1 + 15, y1 + 50, 113, 25, string(pattern), "Must separate relative keys with pipes.") 
	else pattern = draw_textarea(57, x1 + 15, y1 + 50, 113, 25, string(pattern), "必须用“|”分隔相联系的音。") 

	draw_theme_color()
	if (draw_button2(x1 + 10, y1 + 98, 60, condstr(language !=1, "OK", "确定"))) {
	if string_count("|", pattern) = 0 {
		if (language != 1) message("Please add pipes ( | ) to separate values!", "Error")
		else message("请使用“|”分隔值！", "错误")
		return 1
	}
	windowalpha = 0
	windowclose = 0
	windowopen = 0
	window = 0
	str = songs[song].selection_code
	var arr_data = selection_to_array_ext()
	total_vals = array_length(arr_data)
	val = 0
	pattern = string_digits_symbol(pattern, "|")
	pattern = string(pattern + "|")
	var arp = selection_to_array(pattern)
	arplen = string_count("|", pattern)
		while (val < total_vals) {
			for (i = 0; i < arplen; i++;) {
				val += 3
				if (arr_data[val] + arp[i] > 0 || arr_data[val] + arp[i] < 88) {
					arr_data[val] = arr_data[val] + arp[i]
				}
				val += 4
				while arr_data[val] != -1 {
					val += 2
					if (arr_data[val] + arp[i] > 0 || arr_data[val] + arp[i] < 88) {
						arr_data[val] = arr_data[val] + arp[i]
					}
					val += 4
				}
			val ++
			if val >= total_vals break
			}
		if val >= total_vals break
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
