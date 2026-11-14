function draw_window_mp3_export() {
	// draw_window_mp3_export()
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	
	// Window
	var ww = 250;
	var wh = 430;
	var x1 = floor((rw - ww) / 2)
	var y1 = floor((rh - wh) / 2) + windowoffset
	var x2 = x1 + ww
	var y2 = y1 + wh
	draw_window(x1, y1, x2, y2)

	// Title
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Audio Export")
	else draw_text_dynamic(x1 + 8, y1 + 8, "音频导出")
	draw_theme_font(font_main)

	// Header
	if (theme != 3){
		draw_sprite(spr_mp3_exp, sch_exp_layout, x1 + 20, y1)
	} else {
		draw_sprite(spr_mp3_exp_f, fdark, x1 + 20, y1)
	}
	
	x1 += 25
	y1 += 180
	
	// Format
	if (language != 1) draw_text_dynamic(x1, y1, "Output format")
	else draw_text_dynamic(x1, y1, "导出格式")
	y1 += 17
	draw_area(x1, y1, x1 + 140, y1 + 20)
	if (draw_abutton(x1 + 140 - 18, y1 + 1)) {
		var outputstr = check(audio_exp_format == format_mp3) + format_mp3 + "|" +
						check(audio_exp_format == format_wav) + format_wav + "|" +
						//check(audio_exp_format == format_ogg) + format_ogg + "|" +
						check(audio_exp_format == format_aiff) + format_aiff + "|" +
						check(audio_exp_format == format_flac) + format_flac;
	    menu = show_menu_ext("audio_exp_format", x1, y1, outputstr)
	}
	draw_text_dynamic(x1 + 5, y1 + 4, audio_exp_format)
	
	y1 += 40
	
	// Sample rate
	if (language != 1) draw_text_dynamic(x1, y1, "Sampling rate")
	else draw_text_dynamic(x1, y1, "采样率")
	y1 += 17
	draw_area(x1, y1, x1 + 140, y1 + 20)
	if (draw_abutton(x1 + 140 - 18, y1 + 1)) {
		var samplestr = check(audio_exp_sample_rate == 8000) + "8,000 Hz" + "|" +
						check(audio_exp_sample_rate == 11025) + "11,025 Hz" + "|" +
						check(audio_exp_sample_rate == 16000) + "16,000 Hz" + "|" +
					    check(audio_exp_sample_rate == 22050) + "22,050 Hz" + "|" +
						check(audio_exp_sample_rate == 44100) + "44,100 Hz" + "|" +
						check(audio_exp_sample_rate == 48000) + "48,000 Hz" + "|" +
						check(audio_exp_sample_rate == 88200) + "88,200 Hz" + "|" +
						check(audio_exp_sample_rate == 96000) + "96,000 Hz" + "|" +
						check(audio_exp_sample_rate == 176400) + "176,400 Hz" + "|" +
						check(audio_exp_sample_rate == 192000) + "192,000 Hz" + "|" +
						check(audio_exp_sample_rate == 352800) + "352,800 Hz" + "|" +
						check(audio_exp_sample_rate == 384000) + "384,000 Hz";
	    menu = show_menu_ext("audio_exp_sample_rate", x1, y1, samplestr)
	}
	draw_text_dynamic(x1 + 5, y1 + 4, format_sample_rate(audio_exp_sample_rate))
	
	y1 += 40
	
	// Channels
	if (language != 1) draw_text_dynamic(x1, y1, "Channels")
	else draw_text_dynamic(x1, y1, "通道")
	y1 += 17
	if (draw_radiobox(x1, y1, audio_exp_channels == 1, condstr(language != 1, "1 (mono)", "1（单声道）"), condstr(language != 1, "Export the track with a single channel.", "导出单声道的音频。"))) {
		audio_exp_channels = 1
	}
	y1 += 15
	if (draw_radiobox(x1, y1, audio_exp_channels == 2, condstr(language != 1, "2 (stereo)", "2（立体声）"), condstr(language != 1, "Export the track with two channels.", "导出立体声的音频。"))) {
		audio_exp_channels = 2
	}
	
	y1 += 30

	// Locked layers
	if (draw_checkbox(x1, y1, audio_exp_include_locked, condstr(language != 1, "Include locked layers", "包括已静音的层"), condstr(language != 1, "Whether to export locked layers in the audio track.", "是否在音频内包含已静音的层。"), false, true)) audio_exp_include_locked = !audio_exp_include_locked

	// Footer buttons
	x1 = x2 - 8 - 72
	y1 = y2 - 8 - 24
	if (draw_button2(x1, y1, 72, condstr(language != 1, "Export", "导出"), false)) mp3_export()
	x1 -= 77
	if (draw_button2(x1, y1, 72, condstr(language != 1, "Cancel", "取消"), false, true) && (windowopen = 1 || theme != 3)) {
		windowclose = 1
	}
	
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}


function format_sample_rate(value) {
	var str = string(value)
	str = string_insert(",", str, string_length(str) - 2)
	return str + " Hz"
}
