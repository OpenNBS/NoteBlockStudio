function import_midi() {
	// import_midi()
	var a, b, deltapertick, t, e, channel, note, pos, noteuntil, yy, channelheight, framesps, smpte, ins, stop, vel, forvalue, tempvel, temppan, length, at, fadepercent;
	var patch, include_duration, channel_events, eventlayer, slot, events, entry, layer_ends, fade_mode;
	io_clear()
	reset_add()
	
	if (w_midi_tempo_changer) ds_list_add(songs[song].instrument_list, new_instrument("Tempo Changer", "", true))
	
	deltapertick = (midi_tempo & $7FFF) / 4 / (w_midi_precision + 1)
	// Reserve one layer for each note's complete duration before placing blocks.
	// Combine tracks in time order so overlapping notes keep separate layers.
	for (a = 0; a <= midi_channels; a += 1) {
	    channelheight[a] = 0
	    channel_events[a] = []
	}
	// screen_redraw()
	for (t = 0; t < midi_tracks; t += 1) {
	    for (e = 0; e < midi_trackamount[t]; e += 1) {
	        channel = midi_eventchannel[t, e]
	        eventlayer[t, e] = -1
	        note = median(0, midi_eventnote[t, e] - 21, 87)
			if (w_midi_vel = 1) {
				vel = midi_eventvel[t, e]
			} else vel = 100
	        pos = floor((midi_eventx[t, e] - midi_minpos * w_midi_removesilent) / deltapertick)
	        noteuntil = floor((midi_eventuntil[t, e] - midi_minpos * w_midi_removesilent) / deltapertick)
	        patch = midi_eventpatch[t, e]
	        include_duration = w_midi_note_duration && channel != 9 && patch >= 0 && patch < 128
	        if (include_duration) include_duration = midi_parts[midi_eventpart[t, e]].note_duration && midi_eventuntil[t, e] != -1 && noteuntil > pos
	        stop = 0
	        if (channel = 9) {
	            for (a = 0; a < midi_percamount; a += 1) {
	                if (midi_percnote[a] = midi_eventnote[t, e]) {
	                    if (midi_percins[a] = -1) stop = 1
	                    break
	                }
	            }
	            note = median(0, midi_percpitch[a], 87)
	        } else {
	            stop = (midi_channelins[channel] = -1)
	            note += 12 * midi_channeloctave[channel]
	            note = median(0, note, 87)
	        }
	        if (w_midi_octave) {
	            while (note < 33) note += 12
	            while (note > 57) note -= 12
	        }
	        if (stop = 0 && pos >= 0) {
				forvalue = pos + 1
				if (include_duration) forvalue = noteuntil
				events = channel_events[channel]
				array_push(events, {track: t, event_index: e, start: pos, finish: forvalue, order: array_length(events)})
				channel_events[channel] = events
	        }
	    }
	}
	for (channel = 0; channel <= midi_channels; channel += 1) {
		events = channel_events[channel]
		array_sort(events, function(left, right) {
			if (left.start != right.start) return left.start - right.start
			return left.order - right.order
		})
		layer_ends = []
		for (b = 0; b < array_length(events); b += 1) {
			entry = events[b]
			slot = 0
			while (slot < array_length(layer_ends) && layer_ends[slot] > entry.start) slot += 1
			if (w_midi_maxheight < 20 && slot >= w_midi_maxheight) continue
			layer_ends[slot] = entry.finish
			eventlayer[entry.track, entry.event_index] = slot
		}
		channelheight[channel] = array_length(layer_ends)
	}
	// Place blocks
	for (t = 0; t < midi_tracks; t += 1) {
	    for (e = 0; e < midi_trackamount[t]; e += 1) {
	        channel = midi_eventchannel[t, e]
	        pos = floor((midi_eventx[t, e] - midi_minpos * w_midi_removesilent) / deltapertick)
	        noteuntil = floor((midi_eventuntil[t, e] - midi_minpos * w_midi_removesilent) / deltapertick)
	        patch = midi_eventpatch[t, e]
	        include_duration = w_midi_note_duration && channel != 9 && patch >= 0 && patch < 128
	        if (include_duration) include_duration = midi_parts[midi_eventpart[t, e]].note_duration && midi_eventuntil[t, e] != -1 && noteuntil > pos
	        note = midi_eventnote[t, e] - 21
			if (w_midi_vel = 1) {
				vel = midi_eventvel[t, e]
			} else vel = 100
			if vel >=100 vel = 100
			//log("[MIDI Import]" + string(vel))
	        yy = 0
	        stop = 0
	        if (channel = 9) { // Percussion
	            for (a = 0; a < midi_percamount; a += 1) { // Find instrument
	                if (midi_percnote[a] = midi_eventnote[t, e]) break
	            }
	            ins = midi_percins[a]
	            note = median(0, midi_percpitch[a], 87)
	        } else { // Other
	            ins = midi_channelins[channel]
	            note += 12 * midi_channeloctave[channel]
	            note = median(0, note, 87)
	        }
	        if (w_midi_octave) {
	            while (note < 33) note += 12
	            while (note > 57) note -= 12
	        }
	        if (ins > -1 && eventlayer[t, e] >= 0) {
				yy = eventlayer[t, e]
				for (a = 0; a < channel; a += 1) yy += channelheight[a]
				if (w_midi_tempo_changer) yy += 1
				forvalue = pos + 1
				if (include_duration) forvalue = noteuntil
				fade_mode = -1
				if (include_duration) {
					if (w_midi_note_duration_fade) fade_mode = 0
					else if (midi_is_note_fade(midi_ins[patch, 0], 0)) fade_mode = 1
					else if (midi_is_note_fade(midi_ins[patch, 0], 1)) fade_mode = 2
				}
				for (var i = pos; i < forvalue; i++) {
					at = i - pos
					tempvel = vel
					temppan = 100
					if (fade_mode = 1) {
						tempvel = floor(vel * (at / (noteuntil - pos)))
					} else if (fade_mode = 2) {
						tempvel = floor(vel * ((noteuntil - i) / (noteuntil - pos)))
					} else if (at != 0) {
						// Keep the note head unchanged and fade only the generated tail.
						fadepercent = 50
						if (fade_mode = 0) {
							length = forvalue - pos - 2
							fadepercent = w_midi_note_duration_fade_start
							if (length > 0) fadepercent += (w_midi_note_duration_fade_end - w_midi_note_duration_fade_start) * ((at - 1) / length)
						}
						tempvel = floor(vel * fadepercent / 100)
						if (at % 2 = 0) temppan = 150
						else temppan = 50
					}
					// The head and every tail note use the layer reserved above.
					add_block(i, yy, songs[song].instrument_list[| ins], note, tempvel, temppan, 0)
				}
	        }
	    }
	}
	
	if (w_midi_tempo_changer) {
		for (t = 0; t < midi_tempo_changers; t += 1) {
			pos = floor((midi_tempo_changer_x[t] - midi_minpos * w_midi_removesilent) / deltapertick)
			if (pos < 0) pos = 0
			if (pos < array_length(songs[song].song_exists)) {
				if (!songs[song].song_exists[pos, 0]) add_block(pos, 0, songs[song].instrument_list[| first_custom_index], 39, 100, 100, midi_tempo_changer_tempo[t] * (w_midi_precision + 1))
                else change_block(pos, 0, songs[song].instrument_list[| first_custom_index], 39, 100, 100, midi_tempo_changer_tempo[t] * (w_midi_precision + 1))
			}
		}
	}
	
	// Set tempo
	if (!w_midi_tempo_changer || midi_tempo_changers = 0) {
		if (w_midi_tempo && songs[song].enda > 0 && midi_songlength > 0) {
		    songs[song].real_tempo = median(0.25, 10 / ((midi_songlength) / (songs[song].enda / 10)), 1000)
			songs[song].tempo = songs[song].real_tempo
		    //tempo = floor(tempo * 4) / 4
		}
	} else {
		songs[song].real_tempo = (midi_tempo_changer_tempo[0] * (w_midi_precision + 1)) / 15
		songs[song].tempo = songs[song].real_tempo
	}
	// Name
	if (w_midi_name = 1) {
	    yy = 0
		if (w_midi_tempo_changer) {
			yy += 1
			songs[song].layername[0] = "TempoChgr"
		}
	    for (a = 0; a <= midi_channels; a += 1) {
	        for (b = 0; b < channelheight[a]; b += 1) {
				songs[song].layerstereo[yy] = 100
	            songs[song].layername[yy] = "Channel " + string(a + 1)
	            if (w_midi_name_patch) {
					try {
						songs[song].layername[yy] = midi_ins[midi_channelpatch[a], 3]
						if (songs[song].layername[yy] = "") songs[song].layername[yy] = midi_ins[midi_channelpatch[a], 0]
					}
					catch(e) {
						songs[song].layername[yy] = "Unknown"
					}
	                if (a = 9) songs[song].layername[yy] = "Percussion"
	            }
	            songs[song].layerlock[yy] = 0
	            songs[song].layervol[yy] = 100
	            yy += 1
	        }
	    }
	    songs[song].endb2 = yy
	}
	if (w_midi_remember = 1) {
	    for (a = 0; a < midi_channels; a += 1) {    
			try {
				midi_ins[midi_channelpatch[a], 1] = midi_channelins[a]
				midi_ins[midi_channelpatch[a], 2] = midi_channeloctave[a]
			}
	    }
	    for (a = 0; a < midi_percamount; a += 1) {
			try {
				midi_drum[midi_percnote[a], 1] = midi_percins[a]
				midi_drum[midi_percnote[a], 2] = midi_percpitch[a] - 33
			}
	    }
	} else {
	    w_midi_removesilent = 1
	    w_midi_name = 1
	    w_midi_name_patch = 1
	    w_midi_tab = 0
	    w_midi_maxheight = 2
	    w_midi_tempo = 1
	    w_midi_octave = 1
		w_midi_precision = 0
		w_midi_note_duration_fade = 0
		w_midi_note_duration_fade_start = 50
		w_midi_note_duration_fade_end = 50
	}
	save_settings()
	global.popup = 0
	with (obj_popup) instance_destroy()
	window = 0
	songs[song].changed = 0
	for (a = 0; a < 10000; a += 1) text_exists[a] = 0
	update_tempo_changes()



}
