function draw_window_set_tempo() {
	// draw_window_set_tempo()
	var bpm_multiplier = use_bpm ? 15 : 1
	var input = string_format(songs[song].real_tempo * bpm_multiplier, 0, 2)
	var song_tab_offset = 0
	if (array_length(songs) > 1 && !fullscreen) {
		if (theme = 0) song_tab_offset = 35
		if (theme = 1) song_tab_offset = 30
		if (theme = 2) song_tab_offset = 30
		if (theme = 3) song_tab_offset = 40
	}
	var xx, w
	if (!use_bpm) {
		xx = 108
		w = 64
	} else {
		xx = 101
		w = 74
	}
	draw_set_alpha(1)
	if (language != 1) input = draw_inputbox(64, xx, 57 + song_tab_offset, w, input, "Enter the new tempo (in " + condstr(use_bpm, "beats per minute", "ticks per second") + ")", (0.3 + 0.3 * !fdark) * (acrylic && wpaperexist) + (!acrylic || !wpaperexist))
	else input = draw_inputbox(64, xx, 57 + song_tab_offset, w, input, "输入新速度（" + condstr(use_bpm, "拍数 / 分钟", "红石刻 / 秒") + "）", (0.3 + 0.3 * !fdark) * (acrylic && wpaperexist) + (!acrylic || !wpaperexist))
	
	// Prevent closing the box if last mouse press was on top of it
	if (mouse_check_button_pressed(mb_left)) {
		settempo = mouse_rectangle(xx, 57 + song_tab_offset, w, 22)
	}
	
	var otempo = songs[song].real_tempo;
	
	// Set tempo and close
	if ((mouse_check_button_released(mb_left) && !settempo && !mouse_rectangle(xx, 57 + song_tab_offset, w, 22)) || keyboard_check_pressed(vk_enter)) {
		try {
			songs[song].real_tempo = real(string_digits_symbol(string_replace(input, ",", "."), ".") / bpm_multiplier)
		} catch (e) {
			// Input is invalid, don't change the tempo!
		} finally {
			if (songs[song].real_tempo >= 1000) {
				songs[song].real_tempo /= 100
			} else if (songs[song].real_tempo >= 100) {
				songs[song].real_tempo /= 10
			}
			songs[song].real_tempo = median(0.25, songs[song].real_tempo, 60)
		}
		if (songs[song].real_tempo != otempo) {
			changed = 1
		}
		update_tempo_changes()
		settempo = 0
		text_focus = -1
		window = 0
	}
	
	// Cancel
	if (keyboard_check_pressed(vk_escape)) {
		settempo = 0
		text_focus = -1
		window = 0
	}
	
	if (window == 0) {
		// Immediately after closing window
		if (tutorial_tempobox == 1) {
			if (language != 1) set_msg("Good! Right-clicking the box\nwill show some handy options.", 7.0, 228, 118 + song_tab_offset)
			else set_msg("很好！右键点击此框可以显示更多选项。", 7.0, 228, 118 + song_tab_offset)
			tutorial_tempobox = 2
		}
	}
}

