function draw_window_macro_stagger() {
	// draw_window_macro_stagger()
	var x1, y1, a, b, i, pattern, str, total_vals, val, arplen, maxlength, conf;
	if (songs[song].selected == 0) {
		window = 0
		return 0
	}
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	text_exists[0] = 0
	x1 = floor(rw / 2 - 80)
	y1 = floor(rh / 2 - 70) + windowoffset
	draw_window(x1, y1, x1 + 150, y1 + 160)
	draw_theme_color()
	draw_theme_font(font_main_bold)
	draw_text_dynamic(x1 + 8, y1 + 8, "Stagger")
	draw_theme_color()
	pattern = ""
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 11, y1 + 26, x1 + 154, y1 + 102, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 11, y1 + 26, x1 + 154, y1 + 102, 1)
	}
	if (language != 1) draw_areaheader(x1 + 15, y1 + 53, 120, 35, "Pattern")
	else draw_areaheader(x1 + 15, y1 + 53, 120, 35, "规律")

	pattern = draw_textarea(58, x1 + 20, y1 + 60, 113, 25, string(pattern), condstr(language != 1, "Must separate relative keys with pipes.", "必须用“|”分割值。")) 
	draw_theme_font(font_main)
	if (language != 1) draw_text_dynamic(x1 + 25, y1 + 92,"This may replace \nlower note blocks!")
	else draw_text_dynamic(x1 + 25, y1 + 92,"这可能会替换低的音符！")
	if (draw_button2(x1 + 15, y1 + 128, 60, condstr(language != 1, "OK", "确定"))) {
		if string_count("|", pattern) = 0 {
			if (language != 1) message("Please add pipes ( | ) to separate values!", "Error")
			else message("请使用“|”分隔值！", "错误")
			return -1
		}
		if string_count("-", pattern) != 0 {
			if (language != 1) message("Stagger can only extend downwards!", "Error")
			else message("Stagger 只能向下延伸！", "错误")
			return -1
		}
		windowalpha = 0
		windowclose = 0
		windowopen = 0
		window = 0
		str = songs[song].selection_code
		var arr_data = selection_to_array_ext()
		total_vals = array_length(arr_data)
		val = 0
		conf = 0
		pattern = string_digits_symbol(pattern, "|")
		pattern = string(pattern + "|")
		var arp = selection_to_array(pattern)
		arplen = string_count("|", pattern)

		maxlength = 0;
	
		var patlen = array_length(arp);
		for (i = 0; i < patlen; i++) { // Calculate highest number in given pattern
		    if (arp[i] > arp[maxlength]) {
		        maxlength = i;
		    }
		}
		for (a = 0; a < songs[song].selection_arraylength; a++) {  // Expand array entries by highest number
		    for (b = 0; b <= arp[maxlength]; b ++) {
		        songs[song].selection_exists[a, b] = 0
		    }
		}

		songs[song].selection_arrayheight = arp[maxlength]

		while (val < total_vals) {
			for (i = 0; i < arplen; i++;) {
				val += 1
				arr_data[val] = arr_data[val] + arp[i]
				val += 6
				while arr_data[val] != -1 {
					arr_data[val] = arr_data[val] + arp[i]
					val += 6
				}
			val ++
			if val >= total_vals break
			}
		if val >= total_vals break
		}
		var sel_x = songs[song].selection_x
		var sel_y = songs[song].selection_y
		selection_delete(true)
		selection_load_from_array(sel_x, sel_y, arr_data)
		history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)
		if(!keyboard_check(vk_alt)) selection_place(false)
	}
	if (draw_button2(x1 + 75, y1 + 128, 60, condstr(language != 1, "Cancel", "取消")) && (windowopen = 1 || theme != 3)) {windowclose = 1}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
