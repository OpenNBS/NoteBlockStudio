function selection_expand() {
	// selection_expand()
	var str, nw, temp_colfirst, temp_collast, temp_exists, temp_ins, temp_key, temp_vel, temp_pan, temp_pit, temp_played, sa;
	str = songs[song].selection_code
	if (songs[song].selected = 0) return 0
	nw = songs[song].selection_l * 2
	selection_extend_length(nw)
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    if (songs[song].selection_colfirst[a] > -1) {
	        for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	            if (songs[song].selection_exists[a, b]) {
	                temp_exists[a, b] = 1
	                temp_ins[a, b] = songs[song].selection_ins[a, b]
	                temp_key[a, b] = songs[song].selection_key[a, b]
	                temp_vel[a, b] = songs[song].selection_vel[a, b]
	                temp_pan[a, b] = songs[song].selection_pan[a, b]
	                temp_pit[a, b] = songs[song].selection_pit[a, b]
	                temp_played[a, b] = songs[song].selection_played[a, b]
	                songs[song].selection_exists[a, b] = 0
	                songs[song].selection_ins[a, b] = 0
	                songs[song].selection_key[a, b] = 0
	                songs[song].selection_vel[a, b] = 0
	                songs[song].selection_pan[a, b] = 0
	                songs[song].selection_pit[a, b] = 0
	                songs[song].selection_played[a, b] = 0
	            } else {
	                temp_exists[a, b] = 0
	            }
	        }
	    }
	    temp_colfirst[a] = songs[song].selection_colfirst[a]
	    temp_collast[a] = songs[song].selection_collast[a]
	    songs[song].selection_colfirst[a] = -1
	    songs[song].selection_collast[a] = -1
	}
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    sa = a * 2
	    if (temp_colfirst[a] > -1) {
	        for (b = temp_colfirst[a] ;b <= temp_collast[a] ;b += 1) {
	            if (temp_exists[a, b]) {
	                songs[song].selection_exists[sa, b] = 1
	                songs[song].selection_ins[sa, b] = temp_ins[a, b]
	                songs[song].selection_key[sa, b] = temp_key[a, b]
	                songs[song].selection_vel[sa, b] = temp_vel[a, b]
	                songs[song].selection_pan[sa, b] = temp_pan[a, b]
	                songs[song].selection_pit[sa, b] = temp_pit[a, b]
	                songs[song].selection_played[sa, b] = temp_played[a, b]
	            }
	        }
	        songs[song].selection_colfirst[sa] = temp_colfirst[a]
	        songs[song].selection_collast[sa] = temp_collast[a]
	    } else {
	        songs[song].selection_colfirst[sa] = -1
	        songs[song].selection_collast[sa] = -1
	    }
	}
	songs[song].selection_l = nw
	selection_code_update()
	history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)



}
