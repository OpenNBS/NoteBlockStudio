function toggle_playing(argument0) {
	// toggle_playing(cols)
	var xx, a, b, c, d, e;
	playing=!playing
	if (playing = 1) {
	    if (songs[song].marker_pos = songs[song].enda + argument0) songs[song].marker_pos = 0
	    if (marker_start && songs[song].section_exists) songs[song].marker_pos = songs[song].section_start
	    if (marker_follow = 1) {
	        if (marker_pagebypage = 1 && (songs[song].starta + argument0 - 2 < songs[song].marker_pos || songs[song].starta > songs[song].marker_pos)) {
	            songs[song].starta = median(0, songs[song].marker_pos - 1, songs[song].enda)
	            sb_val[scrollbarh] = songs[song].starta
	        }
	        if (marker_pagebypage = 0 || marker_pagebypage = 2) {
	            songs[song].starta = median(0, songs[song].marker_pos - floor(argument0 / 2), songs[song].enda)
	            sb_val[scrollbarh] = songs[song].starta
	        }
	    }
	    songs[song].marker_prevpos = songs[song].marker_pos
	    metronome_played = -1
	    // PLAY COL
	    xx = floor(songs[song].marker_pos)
	    if (xx <= songs[song].enda) {
	        if (songs[song].colamount[xx] > 0) {
	            for (b = songs[song].colfirst[xx]; b <= songs[song].collast[xx]; b += 1) {
	                if (songs[song].song_exists[xx, b]) {
	                    a = 1
						e = 0
						if (b < songs[song].endb2) {
							c = (songs[song].layervol[b] / 100 ) * songs[song].song_vel[xx, b]
							if songs[song].layerstereo[b] = 100 {
								d = songs[song].song_pan[xx, b]
							} else d = (songs[song].layerstereo[b] + songs[song].song_pan[xx, b]) / 2
							e = songs[song].song_pit[xx, b]
						}
	                    if (songs[song].solostr != "") {
	                        if (string_count("|" + string(b) + "|", songs[song].solostr) = 0) {
	                            a = 0
	                        } else if (songs[song].layerlock[b] = 1) {
	                            a = 0
	                        }
	                    } else if (b < songs[song].endb2) {
	                        if (songs[song].layerlock[b] = 1) {
	                            a = 0
	                        }
	                    }
	                    if (a) {
	                        if (songs[song].song_ins[xx, b].loaded) play_sound(songs[song].song_ins[xx, b], songs[song].song_key[xx, b], c , d, e)
							if (songs[song].instrument_list[| ds_list_find_index(songs[song].instrument_list, songs[song].song_ins[xx, b])].name = "Tempo Changer") songs[song].tempo = floor(abs(e)) / 15
							if (songs[song].instrument_list[| ds_list_find_index(songs[song].instrument_list, songs[song].song_ins[xx, b])].name = "Toggle Rainbow") {rainbowtoggle = !rainbowtoggle draw_accent_init()}
	                        if (songs[song].song_ins[xx, b].press) key_played[songs[song].song_key[xx, b]] = current_time
	                        songs[song].song_played[xx, b] = current_time
	                    }
	                }
	            }
	        }
	    }
	} else {
		timestoloop = real(loopmax)
	}



}
