function update_tempo_changes(){
	var tempo_changes = []
	var current_song = songs[song]
	array_push(tempo_changes, [0, max(0.25, current_song.real_tempo), 0])
	for (var a = 0; a <= current_song.enda; a += 1) {
	    if (current_song.colamount[a] > 0) {
	        for (var b = 0; b <= current_song.collast[a]; b += 1) {
	            if (current_song.song_exists[a, b]) {
					try {
		                if (current_song.song_ins[a, b] > 15 && current_song.instrument_list[| ds_list_find_index(current_song.instrument_list, current_song.song_ins[a, b])].name = "Tempo Changer") {
							if (tempo_changes[array_length(tempo_changes) - 1][0] = a) array_pop(tempo_changes)
							// Cache elapsed time once, while rebuilding the tempo map.
							var seconds = 0
							if (array_length(tempo_changes) > 0) {
								var previous = tempo_changes[array_length(tempo_changes) - 1]
								seconds = previous[2] + (a - previous[0]) / previous[1]
							}
							var tempo_tps = max(0.25, floor(abs(current_song.song_pit[a, b])) / 15)
							array_push(tempo_changes, [a, tempo_tps, seconds])
						}
					} catch (e) {
						log("error: " + string(current_song.song_ins[a, b]))
					}
	            }
	        }
	    }
	}
	current_song.tempo_changes = tempo_changes
	log(string(tempo_changes))
}