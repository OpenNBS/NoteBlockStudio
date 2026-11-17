function selection_invert() {
	// invert_selection()
	// Inverts the selection.
	var a, b, ins, key, d, x1, y1, x2, y2, temp_exists, xx, yy, str, vel, pan, pit;
	if (songs[song].selected = 0 && songs[song].totalblocks = 0) return 0
	if (songs[song].selected > 0 && songs[song].totalblocks = 0) {
	    selection_place(0)
	    return 0
	}
	if (songs[song].selected = 0) {
	    select_all(-1, 0)
	    return 0
	}
	selection_extend_length()
	selection_extend_height()
	xx = songs[song].selection_x
	yy = songs[song].selection_y
	str = songs[song].selection_code

	x1 = songs[song].selection_x
	y1 = songs[song].selection_y
	x2 = songs[song].selection_x + songs[song].selection_l
	y2 = songs[song].selection_y + songs[song].selection_h
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    for (b = 0; b < songs[song].selection_h; b += 1) {
	        temp_exists[a, b] = 0
	        if (b >= songs[song].selection_colfirst[a] && b <= songs[song].selection_collast[a]) temp_exists[a, b] = songs[song].selection_exists[a, b]
	    }
	}
	selection_place(1)
	for (a = 0; a <= songs[song].enda; a += 1) {
	    if (songs[song].colamount[a] > 0) {
	        for (b = songs[song].colfirst[a]; b <= songs[song].collast[a]; b += 1) {
	            if (songs[song].song_exists[a, b]) {
	                ins = songs[song].song_ins[a, b]
	                key = songs[song].song_key[a, b]
	                vel = songs[song].song_vel[a, b]
	                pan = songs[song].song_pan[a, b]
	                pit = songs[song].song_pit[a, b]
	                d = 0
	                if (a >= x1 && b >= y1 && a < x2 && b < y2) {
	                    d = temp_exists[a - x1, b - y1]
	                }
	                if (d = 0) {
	                    songs[song].selection_exists[a, b] = 1
	                    songs[song].selection_ins[a, b] = ins
	                    songs[song].selection_key[a, b] = key
	                    songs[song].selection_vel[a, b] = vel
	                    songs[song].selection_pan[a, b] = pan
	                    songs[song].selection_pit[a, b] = pit
	                    songs[song].selection_played[a, b] = 0
	                    if (songs[song].selection_colfirst[a] = -1) songs[song].selection_colfirst[a] = b
	                    songs[song].selection_collast[a] = max(songs[song].selection_collast[a], b)
	                    songs[song].selected += 1
	                    remove_block_select(a, b)
	                }
	            }
	        }
	    }
	}
	songs[song].selection_x = 0
	songs[song].selection_y = 0
	songs[song].selection_l = songs[song].enda + 1
	songs[song].selection_h = songs[song].endb + 1
	selection_trim()
	selection_code_update()
	history_set(h_select, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, xx, yy, str)
	update_tempo_changes()



}
