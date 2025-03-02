function draw_window_edit_tempo_changer() {
	// draw_window_setpanning()
	var x1, y1, a, b, str, total_vals, val, decr, inc, temp_tempo, e, pins, pkey, pvel, ppan, ppit;
	if (tempo_changer_sel_x = -1) {
		window = 0
		return 0
	}
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	text_exists[0] = 0
	x1 = floor(rw / 2 - 80)
	y1 = floor(rh / 2 - 80) + windowoffset
	pins = songs[song].song_ins[tempo_changer_sel_x, tempo_changer_sel_y]
	pkey = songs[song].song_key[tempo_changer_sel_x, tempo_changer_sel_y]
	pvel = songs[song].song_vel[tempo_changer_sel_x, tempo_changer_sel_y]
	ppan = songs[song].song_pan[tempo_changer_sel_x, tempo_changer_sel_y]
	ppit = songs[song].song_pit[tempo_changer_sel_x, tempo_changer_sel_y]
	draw_window(x1, y1, x1 + 140, y1 + 130)
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Set Tempo")
	else draw_text_dynamic(x1 + 8, y1 + 8, "设置速度")
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 1)
	}
	if (language != 1) draw_areaheader(x1 + 10, y1 + 40, 120, 35, "Tempo (BPM)")
	else draw_areaheader(x1 + 10, y1 + 40, 120, 35, "速度（BPM）")
	if (language != 1) tempo_changer_set_tempo = draw_textarea(59, x1 + 15, y1 + 50, 113, 25, string(tempo_changer_set_tempo), "Must be an integer larger than zero.") 
	else tempo_changer_set_tempo = draw_textarea(59, x1 + 15, y1 + 50, 113, 25, string(tempo_changer_set_tempo), "必须是一个正整数。") 
	
	draw_theme_color()
	if (draw_button2(x1 + 10, y1 + 98, 60, condstr(language != 1, "OK", "确定"))) {
		try {
			temp_tempo = int64(tempo_changer_set_tempo)
			if (temp_tempo > 0) {
				songs[song].song_pit[@ tempo_changer_sel_x, tempo_changer_sel_y] = temp_tempo
				history_set(h_changeblock, tempo_changer_sel_x, tempo_changer_sel_y, tempo_changer_sel_ins, songs[song].song_key[tempo_changer_sel_x, tempo_changer_sel_y], songs[song].song_vel[tempo_changer_sel_x, tempo_changer_sel_y], songs[song].song_pan[tempo_changer_sel_x, tempo_changer_sel_y], temp_tempo, pins, pkey, pvel, ppan, ppit)
				tempo_changer_sel_x = -1
				tempo_changer_sel_y = -1
				tempo_changer_set_tempo = -1
				tempo_changer_sel_ins = -1
				windowalpha = 0
				windowclose = 0
				windowopen = 0
				window = 0
				windowprogress = 0
			} else {
				if (language != 1) message("Invalid value!", "Set Tempo")
				else message("非法数值！", "设置速度")
			}
		}
		catch (e) {
			if (language != 1) message("Invalid value!", "Set Tempo")
			else message("非法数值！", "设置速度")
		}
	}
	if (draw_button2(x1 + 70, y1 + 98, 60, condstr(language !=1, "Cancel", "取消")) && (windowopen = 1 || theme != 3)) {
		windowclose = 1
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
