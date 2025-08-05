function import_midi() {
	// import_midi()
	var a, b, deltapertick, t, e, channel, note, pos, noteuntil, yy, channelheight, posamount, framesps, smpte, ins, stop, vel, tempy, forvalue, tempvel, temppan, length, at;
	var ins1notes, ins2notes, ins3notes, ins4notes, ins5notes, ins6notes, ins7notes, ins8notes, ins9notes, ins10notes;
	io_clear()
	reset_add()
	
	if (w_midi_tempo_changer) ds_list_add(songs[song].instrument_list, new_instrument("Tempo Changer", "", true))
	
	if (!w_midi_note_duration) {
		for (a = 0; a < midi_tracks; a += 1) {
		    for (b = 0; b < midi_trackamount[a]; b += 1) {
				midi_eventuntil[a, b] = -1
		    }
		}
	}
	
	deltapertick = (midi_tempo & $7FFF) / 4 / (w_midi_precision + 1)
	// Calculate channel heights
	for (a = 0; a <= midi_channels; a += 1) {
	    channelheight[a] = 0
	    posamount[a, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	}
	// Store amount of one note in a tick
	for (b = 0; b < 88; b += 1) {
	    ins1notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins2notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins3notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins4notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins5notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins6notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins7notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins8notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins9notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	    ins10notes[b, floor((midi_maxpos - midi_minpos * w_midi_removesilent) / deltapertick)] = 0
	}
	// screen_redraw()
	for (t = 0; t < midi_tracks; t += 1) {
	    for (e = 0; e < midi_trackamount[t]; e += 1) {
	        channel = midi_eventchannel[t, e]
	        note = median(0, midi_eventnote[t, e] - 21, 87)
			if (w_midi_vel = 1) {
				vel = midi_eventvel[t, e]
			} else vel = 100
	        pos = floor((midi_eventx[t, e] - midi_minpos * w_midi_removesilent) / deltapertick)
	        noteuntil = floor((midi_eventuntil[t, e] - midi_minpos * w_midi_removesilent) / deltapertick)
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
	        if (stop = 0) {
				if (channel = 9 || midi_eventuntil[t, e] = -1 || pos - noteuntil = 0){
		            if (channelheight[channel] < w_midi_maxheight || w_midi_maxheight = 20) {
		                switch (midi_channelins[channel]) {
		                    case 0: {ins1notes[note, pos] = 1 break}
		                    case 1: {ins2notes[note, pos] = 1 break}
		                    case 2: {ins3notes[note, pos] = 1 break}
		                    case 3: {ins4notes[note, pos] = 1 break}
		                    case 4: {ins5notes[note, pos] = 1 break}
		                    case 5: {ins6notes[note, pos] = 1 break}
		                    case 6: {ins7notes[note, pos] = 1 break}
		                    case 7: {ins8notes[note, pos] = 1 break}
		                    case 8: {ins9notes[note, pos] = 1 break}
		                    case 9: {ins10notes[note, pos] = 1 break}
		                }
		                // pos = floor(midi_eventx[t, e] / deltapertick)
		                posamount[channel, pos] += 1
		                channelheight[channel] = max(channelheight[channel], posamount[channel, pos])
		            }
				} else {
					for (a = pos; a < noteuntil; a++) {
						if (channelheight[channel] < w_midi_maxheight || w_midi_maxheight = 20) {
			                switch (midi_channelins[channel]) {
			                    case 0: {ins1notes[note, a] = 1 break}
			                    case 1: {ins2notes[note, a] = 1 break}
			                    case 2: {ins3notes[note, a] = 1 break}
			                    case 3: {ins4notes[note, a] = 1 break}
			                    case 4: {ins5notes[note, a] = 1 break}
			                    case 5: {ins6notes[note, a] = 1 break}
			                    case 6: {ins7notes[note, a] = 1 break}
			                    case 7: {ins8notes[note, a] = 1 break}
			                    case 8: {ins9notes[note, a] = 1 break}
			                    case 9: {ins10notes[note, a] = 1 break}
			                }
			                // a = floor(midi_eventx[t, e] / deltapertick)
			                posamount[channel, a] += 1
			                channelheight[channel] = max(channelheight[channel], posamount[channel, a])
			            }
					}
				}
	        }
	    }
	}
	for (a = 0; a <= floor(midi_maxpos / deltapertick); a += 1) {
	    for (b = 0; b < 88; b += 1) {
	        ins1notes[b, a] = 0
	        ins2notes[b, a] = 0
	        ins3notes[b, a] = 0
	        ins4notes[b, a] = 0
	        ins5notes[b, a] = 0
	        ins6notes[b, a] = 0
	        ins7notes[b, a] = 0
	        ins8notes[b, a] = 0
	        ins9notes[b, a] = 0
	        ins10notes[b, a] = 0
	    }
	}
	// Place blocks
	for (t = 0; t < midi_tracks; t += 1) {
	    for (e = 0; e < midi_trackamount[t]; e += 1) {
	        channel = midi_eventchannel[t, e]
	        pos = floor((midi_eventx[t, e] - midi_minpos * w_midi_removesilent) / deltapertick)
	        noteuntil = floor((midi_eventuntil[t, e] - midi_minpos * w_midi_removesilent) / deltapertick)
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
	        if (ins > -1 && stop = 0) {
				if (channel = 9 || midi_eventuntil[t, e] = -1 || pos - noteuntil = 0) {
		            switch (midi_channelins[channel]) {
		                case 0: {ins1notes[note, pos] = 1 break}
		                case 1: {ins2notes[note, pos] = 1 break}
		                case 2: {ins3notes[note, pos] = 1 break}
		                case 3: {ins4notes[note, pos] = 1 break}
		                case 4: {ins5notes[note, pos] = 1 break}
		                case 5: {ins6notes[note, pos] = 1 break}
		                case 6: {ins7notes[note, pos] = 1 break}
		                case 7: {ins8notes[note, pos] = 1 break}
		                case 8: {ins9notes[note, pos] = 1 break}
		                case 9: {ins10notes[note, pos] = 1 break}
		            }
				} else {
					for (a = pos; a < noteuntil; a++) {
						switch (midi_channelins[channel]) {
			                case 0: {ins1notes[note, a] = 1 break}
			                case 1: {ins2notes[note, a] = 1 break}
			                case 2: {ins3notes[note, a] = 1 break}
			                case 3: {ins4notes[note, a] = 1 break}
			                case 4: {ins5notes[note, a] = 1 break}
			                case 5: {ins6notes[note, a] = 1 break}
			                case 6: {ins7notes[note, a] = 1 break}
			                case 7: {ins8notes[note, a] = 1 break}
			                case 8: {ins9notes[note, a] = 1 break}
			                case 9: {ins10notes[note, a] = 1 break}
			            }
					}
				}
	            // Find y
	            for (a = 0; a < channel; a += 1) yy += channelheight[a]
				if (w_midi_tempo_changer) yy += 1
				tempy = yy
				forvalue = pos + 1
				if (channel != 9 && midi_eventuntil[t, e] != -1 && pos - noteuntil != 0) forvalue = noteuntil
	            // Add block, go lower if failed
				if (midi_is_note_fade(midi_ins[midi_channelpatch[channel], 0], 0)) {
					for (var i = pos; i < forvalue; i++) {
			            a = 0
						yy = tempy
						at = i - pos
						tempvel = 100
						length = noteuntil - pos
						if (length != 0) tempvel = floor(vel * (at / length))
			            while (1) {
			                if (add_block(i, yy, songs[song].instrument_list[| ins], note, tempvel, 100, 0)) break
			                yy += 1
			                a += 1
			                if (a >= w_midi_maxheight && w_midi_maxheight < 20) break
			            }
					}
				} else if (midi_is_note_fade(midi_ins[midi_channelpatch[channel], 0], 1)) {
					for (var i = pos; i < forvalue; i++) {
			            a = 0
						yy = tempy
						at = noteuntil - i
						tempvel = 100
						length = noteuntil - pos
						if (length != 0) tempvel = floor(vel * (at / length))
			            while (1) {
			                if (add_block(i, yy, songs[song].instrument_list[| ins], note, tempvel, 100, 0)) break
			                yy += 1
			                a += 1
			                if (a >= w_midi_maxheight && w_midi_maxheight < 20) break
			            }
					}
				} else {
					for (var i = pos; i < forvalue; i++) {
			            a = 0
						yy = tempy
						tempvel = vel
						temppan = 100
						at = i - pos
						if (at != 0) {
							tempvel = floor(vel * 0.5)
							if (at % 2 = 0) temppan = 150
							else temppan = 50
						}
			            while (1) {
			                if (add_block(i, yy, songs[song].instrument_list[| ins], note, tempvel, temppan, 0)) break
			                yy += 1
			                a += 1
			                if (a >= w_midi_maxheight && w_midi_maxheight < 20) break
			            }
					}
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
	}
	save_settings()
	global.popup = 0
	with (obj_popup) instance_destroy()
	window = 0
	songs[song].changed = 0
	for (a = 0; a < 10000; a += 1) text_exists[a] = 0
	update_tempo_changes()



}
