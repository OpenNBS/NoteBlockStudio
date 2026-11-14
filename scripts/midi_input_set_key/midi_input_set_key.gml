function midi_input_set_key(argument0, argument1) {
	// midi_input_set_key(key, totalcols)

	var ins, key, vel, d, k, keys, releases, c, b, totalcols;
	key = argument0
	totalcols = argument1
	for (d = 0; d < midi_devices; d += 1) {
		ins = mididevice_instrument[d]
		if (ins > -3) {
		    if (!key_midipress[key]) {
		        for (k = 0; k < midi_keys[d]; k += 1) {
		            if (midi_input_key_press_note(d, k) = key + 21) {
						vel = min(midi_input_key_press_velocity(d, k), 100)
		                if (ins = -1) ins = songs[song].instrument
		                if (ins >= 0) play_sound(ins, key, vel ,100, 0)
		                if (select_lastpressed) {selected_key = key; selected_vel = 100; selected_pan = 100; selected_pit = 0}
		                if (playing = 0.25) toggle_playing(totalcols)
		                if (playing && record) {
		                    b = 0
		                    while (!add_block_manual(ceil(songs[song].marker_pos), b, ins, key, vel, 100, 0)) b += 1
		                    songs[song].song_played[round(songs[song].marker_pos), b] = current_time
		                }
		                key_midipress[key] = 1
		                key_press[key] = 1
		                break
		            }
		        }      
			}
		    if (key_midipress[key]) {
		        for (k = 0; k < midi_releases[d]; k += 1) {
		            if (midi_input_key_release_note(d, k) = key + 21) {
		                key_midipress[key] = 0
		                key_press[key] = 0
		                break
		            }
		        }
		    }
		}
	}
}
