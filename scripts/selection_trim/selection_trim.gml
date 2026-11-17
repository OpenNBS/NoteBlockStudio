function selection_trim() {
	// selection_trim()
	// Removes unneccesary space from selection.
	var x1, y1, x2, y2, a, b, temp_colfirst, temp_collast, temp_exists, temp_ins, temp_vel, temp_pan, temp_key, temp_pit, temp_played;
	selection_expand_columns()
	for (x1 = 0; x1 < songs[song].selection_l; x1 += 1) {
	    if (songs[song].selection_colfirst[x1] > -1) break
	}
	for (x2 = songs[song].selection_l - 1; x2 >= 0; x2 -= 1) {
	    if (songs[song].selection_colfirst[x2] > -1) break
	}
	y1 = songs[song].selection_h
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    if (songs[song].selection_colfirst[a] > -1) y1 = min(songs[song].selection_colfirst[a], y1)
	}
	y2 = 0
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    if (songs[song].selection_collast[a] > -1) y2 = max(songs[song].selection_collast[a], y2)
	}
	x2 += 1
	y2 += 1
	if (x1 > 0 || y1 > 0) {
	    for (a = x1; a < x2; a += 1) {
	        if (songs[song].selection_colfirst[a] > -1) {
	            for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	                if (songs[song].selection_exists[a, b]) {
	                    temp_exists[a - x1, b - y1] = 1
	                    temp_ins[a - x1, b - y1] = songs[song].selection_ins[a, b]
	                    temp_key[a - x1, b - y1] = songs[song].selection_key[a, b]
	                    temp_vel[a - x1, b - y1] = songs[song].selection_vel[a, b]
	                    temp_pan[a - x1, b - y1] = songs[song].selection_pan[a, b]
	                    temp_pit[a - x1, b - y1] = songs[song].selection_pit[a, b]
	                    temp_played[a - x1, b - y1] = songs[song].selection_played[a, b]
	                    songs[song].selection_exists[a, b] = 0
	                    songs[song].selection_ins[a, b] = 0
	                    songs[song].selection_key[a, b] = 0
	                    songs[song].selection_vel[a, b] = 0
	                    songs[song].selection_pan[a, b] = 0
	                    songs[song].selection_pit[a, b] = 0
	                    songs[song].selection_played[a, b] = 0
	                } else {
	                    temp_exists[a - x1, b - y1] = 0
	                }
	            }
	        }
	        temp_colfirst[a - x1] = max(-1, songs[song].selection_colfirst[a] - y1)
	        temp_collast[a - x1] = max(-1, songs[song].selection_collast[a] - y1)
	        songs[song].selection_colfirst[a] = -1
	        songs[song].selection_collast[a] = -1
	    }
	    for (a = 0; a < x2 - x1; a += 1) {
	        if (temp_colfirst[a] > -1) {
	            for (b = temp_colfirst[a]; b <= temp_collast[a]; b += 1) {
	                if (temp_exists[a, b]) {
	                    songs[song].selection_exists[a, b] = 1
	                    songs[song].selection_ins[a, b] = temp_ins[a, b]
	                    songs[song].selection_key[a, b] = temp_key[a, b]
	                    songs[song].selection_vel[a, b] = temp_vel[a, b]
	                    songs[song].selection_pan[a, b] = temp_pan[a, b]
	                    songs[song].selection_pit[a, b] = temp_pit[a, b]
	                    songs[song].selection_played[a, b] = temp_played[a, b]
	                }
	            }
	        }
	        songs[song].selection_colfirst[a] = temp_colfirst[a]
	        songs[song].selection_collast[a] = temp_collast[a]
	    }
	}
	songs[song].selection_x += x1
	songs[song].selection_y += y1
	songs[song].selection_l = x2 - x1
	songs[song].selection_h = y2 - y1



}
