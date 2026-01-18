function select_outside(argument0, argument1) {
	// select_outside(lower, higher)
	// Selects all the note blocks below and/or above the 2 octave range.
	var a, b, str, ins, key, vel, pan, pit;
	str = songs[song].selection_code
	if (songs[song].selected > 0) selection_place(1)
	selection_extend_length()
	selection_extend_height()
	for (a = 0; a <= songs[song].enda; a += 1) {
	    if (songs[song].colamount[a] > 0) {
	        for (b = songs[song].colfirst[a]; b <= songs[song].collast[a]; b += 1) {
	            if (songs[song].song_exists[a, b]) {
	                ins = songs[song].song_ins[a, b]
	                key = songs[song].song_key[a, b]
	                vel = songs[song].song_vel[a, b]
	                pan = songs[song].song_pan[a, b]
	                pit = songs[song].song_pit[a, b]
	                if ((argument0 && key < 33) || (argument1 && key > 57)) {
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
	songs[song].starta = songs[song].selection_x
	sb_val[0] = songs[song].starta
	history_set(h_select, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, 0, 0, songs[song].selection_code)
	update_tempo_changes()



}
