function toggle_playing(argument0) {
	// toggle_playing(cols)
	var xx, a, b, c, d, e;
	playing=!playing
	if (playing) macos_menu_last_refresh = -1
	else macos_menu_last_refresh = current_time
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
		songs[song].tempo = get_tempo_from_tick(xx)
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
						var insname = songs[song].instrument_list[| ds_list_find_index(songs[song].instrument_list, songs[song].song_ins[xx, b])].name
						if (insname = "Tempo Changer") songs[song].tempo = floor(abs(e)) / 15
						else if (insname = "Toggle Rainbow") {rainbowtoggle = !rainbowtoggle draw_accent_init()}
						else if (insname = "Sound Stopper") {remove_emitters_all(floor(e), panning_velocity_to_short(d, c))}
						else if (insname = "Show Save Popup") set_msg("Song saved")
						else if (string_count(string_lower("Change Color to #"), string_lower(insname)) = 1) {
							draw_set_accent(real("0x" + string_copy(insname, 18, 2)), real("0x" + string_copy(insname, 20, 2)), real("0x" + string_copy(insname, 22, 2)))
							log("Change Color to " + string_copy(insname, 18, 2) + " " + string_copy(insname, 20, 2) + " " + string_copy(insname, 22, 2))
						}
						else if (insname = "Toggle Background Accent") backgroundaccent = !backgroundaccent
	                    else if (a) {
	                        if (songs[song].song_ins[xx, b].loaded && songs[song].reference_option != 1) play_sound(songs[song].song_ins[xx, b], songs[song].song_key[xx, b], c , d, e)
	                        if (songs[song].song_ins[xx, b].press) key_played[songs[song].song_key[xx, b]] = current_time
	                        songs[song].song_played[xx, b] = current_time
	                    }
	                }
	            }
	        }
	    }
	} else {
		timestoloop = real(songs[song].loopmax)
	}



}
