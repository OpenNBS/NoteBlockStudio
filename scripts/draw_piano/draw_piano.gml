function draw_piano(argument0, argument1, argument2, argument3) {
	// draw_piano(x, y, keys, totalcols)
	var a, b, c, d, t, out, xx, yy, k, alpha, down, c1, c2, k1, k2, showclicks1, showclicks2, col, selectedkey, totalcols;
	draw_set_color(0)
	xx = argument0
	yy = argument1
	k = argument2
	totalcols = argument3
	b = 0
	d = -1
	selectedkey = -1
	alpha = max(0, 3 - startkey) * !isplayer + 3 * isplayer
	for (a = 0; a < midi_devices; a += 1) {
		midi_keys[a] = midi_input_key_presses(a)
		midi_releases[a] = midi_input_key_releases(a)
	}
	for (a = 0; a < k; a += 1) {
	    c = (startkey + a) mod 7
	    if (a > 0 && c != 2 && c != 5) { // Sharp key to the left
	        c1 = startkey + sharpkeys + b
	        c2 = startkey + sharpkeys + b + 1
			if (c1 >= 88) continue
	        k1 = show_keyboard && piano_key[c1] > 0
	        k2 = show_keyboard && piano_key[c2] > 0
	        if (window = 0 && mouse_rectangle(xx + 39 * a, yy, 39, 128)) {
	            if (!mouse_rectangle(xx + 39 * a - 12, yy - 7, 25, 71) && (!mouse_rectangle(xx + 39 * a + 27, yy - 7, 25, 71) || (a = k - 1 || c = 1 || c = 4))) {
	                if (show_notechart && c2 > 6 && c2 < 69 && playing = 0 && !isplayer) draw_notechart(xx + 39 * a + 18, yy - 32, startkey + a, 0) //handle all white keys except C and F
	                if (mouse_check_button_pressed(mb_right) && show_keyboard) key_edit = c2
	                // Check mouse clicks
	                t = key_click[c2]
	                key_click[c2] = (mouse_check_button(mb_left))
	                if (t = 0 && key_click[c2]) {
	                    selectedkey = c2
	                    play_sound(songs[song].instrument, c2, 100 ,100, 0)
	                }
	                if (a = k - 1) d = 1
	                if (a = 0) d = 0
	            } else {
	                key_click[c2] = 0
	            }
	        } else {
	            key_click[c2] = 0
	        }
	        if (window = 0 && mouse_rectangle(xx + 39 * a - 12, yy - 7, 25, 71)) {
	            if (show_notechart && !keynames_flat && c1 > 6 && c1 < 70 && playing = 0 && !isplayer) draw_notechart(xx + 39 * a - 12 + 12, yy - 32, startkey + a - 1, 1) //handles all sharps
				if (show_notechart && keynames_flat && c1 > 5 && c1 < 69 && playing = 0 && !isplayer) draw_notechart(xx + 39 * a - 12 + 12, yy - 32, startkey + a, 1) //handles all flats
				if (mouse_check_button_pressed(mb_right) && show_keyboard) key_edit = c1
	            t = key_click[c1]
	            key_click[c1] = mouse_check_button(mb_left)
	            if (t = 0 && key_click[c1]) {
	                selectedkey = c1
	                play_sound(songs[song].instrument, c1, 100 ,100, 0)
	            }
	        } else {
	            key_click[c1] = 0
	        }
			
	        // White
	        out = (c2 < 33 || c2 > 57)
			showclicks2 = !out && show_keynumbers
	        col = c_white
	        down[1] = 0
			if (!isplayer) {
				if (show_outofrange && out) col = 8224255
				if (selected_key = c2 && playing = 0) {if (theme != 3) col = 16753828 else col = accent[7]}
			}
	        if (current_time - key_played[c2] < 300) {col = merge_color(col, c_yellow, 1 - (current_time - key_played[c2]) / 300) down[1] = ((current_time - key_played[c2]) / 300) * 2 if (down[1] > 1) down[1] = 2 - down[1] down[1] = floor(down[1] * 3) / 3}
	        if (key_midipress[c2] || key_press[c2] || key_click[c2]) down[1] = 0.75
			draw_piano_key(false, xx + 39 * a, yy + floor(7 * down[1]), col, alpha, c2, k2, showclicks2, down[1])
			
	        // Black
	        down[0] = 0
	        out = (c1 < 33 || c1 > 57)
			showclicks1 = !out && show_keynumbers
	        col = c_white
			if (!isplayer) {
				if (show_outofrange && out) col = 8224255
				if (selected_key = c1 && playing = 0) {if (theme != 3) col = 16753828 else col = accent[7]}
			}
	        if (current_time - key_played[c1] < 300) {col = merge_color(col, c_yellow, 1 - (current_time - key_played[c1]) / 300) down[0] = ((current_time - key_played[c1]) / 300) * 2 if (down[0] > 1) down[0] = 2 - down[0] down[0] = floor(down[0] * 3) / 3}
	        if (key_midipress[c1] || key_press[c1] || key_click[c1]) down[0] = 0.75
			draw_piano_key(true, xx + 39 * a - 19, yy - 7, col, alpha, c1, k1, showclicks1, down[0])
			
	        b += 2
	    } else { // No sharp keys
	        c1 = startkey + sharpkeys + b
	        k1 = (show_keyboard && piano_key[c1] > 0)
	        if (window = 0 && mouse_rectangle(xx + 39 * a, yy, 39, 128)) {
	            if (!mouse_rectangle(xx + 39 * a + 27, yy - 7, 25, 71) || (a = k - 1 || c = 1 || c = 4)) {
	                if (show_notechart && c1 > 6 && c1 < 69 && playing = 0) draw_notechart(xx + 39 * a + 18, yy - 32, startkey + a, 0) //handles C and F
	                if (mouse_check_button_pressed(mb_right) && show_keyboard) key_edit = c1
	                t = key_click[c1]
	                key_click[c1] = mouse_check_button(mb_left)
	                if (t = 0 && key_click[c1]) {
	                    selectedkey = c1
	                    play_sound(songs[song].instrument, c1, 100 ,100, 0)
	                }
	                if (a = k - 1) d = 1
	                if (a = 0) d = 0
	            } else {
	                key_click[c1] = 0
	            }
	        } else {
	            key_click[c1] = 0
	        }
	        out = (c1 < 33 || c1 > 57)
			showclicks1 = !out && show_keynumbers
	        col = c_white
	        down = 0
			if (!isplayer) {
				if (show_outofrange && out) col = 8224255
				if (selected_key = c1 && playing = 0) {if (theme != 3) col = 16753828 else col = accent[7]}
			}
	        if (current_time - key_played[c1] < 300) {col = merge_color(col, c_yellow, 1 - (current_time - key_played[c1]) / 300) down = ((current_time - key_played[c1]) / 300) * 2 if (down > 1) down = 2 - down down = floor(down * 3) / 3}
	        if (key_midipress[c1] || key_press[c1] || key_click[c1]) down = 0.75
			draw_piano_key(false, xx + 39 * a, yy + floor(7 * down), col, alpha, c1, k1, showclicks1, down)
	        b += 1
	    }
	    if (a < 3 && alpha < 3 && !isplayer) alpha += 1
	    if (a > k - min(5, 54 - (startkey + k)) && !isplayer) alpha -= 1
	}
	if (selectedkey > -1) {selected_key = selectedkey; selected_vel = 100; selected_pan = 100; selected_pit = 0}
	draw_set_alpha(1)
	if (d = 0 && startkey > 0 && !mouse_check_button(mb_left)) {
	    a = startkey mod 7
	    if (delay = 0) {
	        sharpkeys -= (a != 2 && a != 5)
	        startkey -= 1
	        delay = 2
	    }
	}
	if (d = 1 && !mouse_check_button(mb_left)) {
	    a = startkey mod 7
	    if (delay = 0 && startkey + k < 52) {
	        sharpkeys += (a != 1 && a != 4)
	        startkey += 1
	        delay = 2
	    }
	}
	// Check key presses
	if (window = 0 && text_focus = -1 && key_edit = -1 && !check_ctrl()) {
	for (a = 0; a <= 87; a += 1) {
	    if (piano_key[a] > 0) {
	        if (key_press[a] = 0 && keyboard_check(piano_key[a])) {
	            if (select_lastpressed) {selected_key = a; selected_vel = 100; selected_pan = 100; selected_pit = 0}
	            if (record = 0) play_sound(songs[song].instrument, a, 100 ,100, 0)
	            if (playing = 0.25) toggle_playing(totalcols)
	            if (playing && record) {
	                b = 0
	                while (!add_block_manual(ceil(songs[song].marker_pos), b, songs[song].instrument, a, 100, 100, 0)) b += 1
	                songs[song].song_played[round(songs[song].marker_pos), b] = current_time
	            }
	        }
	        key_press[a] = keyboard_check(piano_key[a])
	    }
	    midi_input_set_key(a, totalcols)
	}
	}
	ds_list_clear(midi_keypresses)
	ds_list_clear(midi_keyreleases)
	draw_set_color(0)



}
