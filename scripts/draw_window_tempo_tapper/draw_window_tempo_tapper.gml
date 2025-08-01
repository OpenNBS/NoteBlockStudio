function draw_window_tempo_tapper() {
	// draw_window_tempo_tapper()
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	var x1, y1, e, ltempo, ctempo, ins
	curs = cr_default
	text_exists[0] = 0
	x1 = floor(rw / 2 - 80)
	y1 = floor(rh / 2 - 80) + windowoffset
	draw_window(x1, y1, x1 + 140, y1 + 130)
	ltempo = taptempo
	ins = soundmetronome
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Tempo tapper")
	else draw_text_dynamic(x1 + 8, y1 + 8, "速度测量器")
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 92, 1)
	}
	if (language != 1) {
		if (use_bpm) draw_areaheader(x1 + 10, y1 + 43, 120, 35, "BPM (T to tap)")
		else draw_areaheader(x1 + 10, y1 + 43, 120, 35, "t/s (T to tap)")
	} else {
		if (use_bpm) draw_areaheader(x1 + 10, y1 + 43, 120, 35, "BPM (按 T 打速度)")
		else draw_areaheader(x1 + 10, y1 + 43, 120, 35, "t/s (按 T 打速度)")
	}

	//tempoo = draw_textarea(57, x1 + 15, y1 + 50, 113, 25, string(tempoo), "Will always floor to integer if using BPM.") 
	if (keyboard_check_pressed(ord("T"))) {
		if (tapping) taptempo = ((60 / ((current_time - ltime) / 1000)) + ltempo * taps) / ((taps + 1) * (ltempo != 0) + (!ltempo))
		if (floor(60 / ((current_time - ltime) / 1000) + 0.5) <= ltempo / 2 && ltempo != 0) {
			taptempo = 0
			taps = 0
		}
		tapping = 1
		ltime = current_time
		taps += 1
		if (ins.loaded) play_sound(ins, 45, 100, 100, 0)
	}
	ctempo = floor(taptempo + 0.5)
	if (tapping && taptempo != 0) {
		if (use_bpm) draw_text_dynamic(x1 + 60, y1 + 55, ctempo)
		else draw_text_dynamic(x1 + 60, y1 + 55, ctempo / 15)
	}
	if (language != 1) {if(draw_checkbox(x1 + 15, y1 + 80, tapdouble, "Double tempo", "Double the tempo to apply.", 0, 1)) tapdouble = !tapdouble}
	else {if(draw_checkbox(x1 + 15, y1 + 80, tapdouble, "双倍速度", "应用时使速度 x2。", 0, 1)) tapdouble = !tapdouble}

	draw_theme_color()
	if (draw_button2(x1 + 10, y1 + 98, 60, condstr(language != 1, "OK", "确认")) && (windowopen = 1 || theme != 3)) {
		try {
			songs[song].real_tempo = (ctempo * (1 + tapdouble)) / 15
			changed = 1
			taptempo = 0
			tapping = 0
			ltime = 0
			windowclose = 1
		}
		catch(e) {
			if (language != 1) message("An error occurred.", "Tempo tapper")
			else message("发生了一个错误。", "速度测量器")
		}
	}
	if (draw_button2(x1 + 70, y1 + 98, 60, condstr(language != 1, "Cancel", "取消"))) {
		taptempo = 0
		tapping = 0
		ltime = 0
		windowclose = 1
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
