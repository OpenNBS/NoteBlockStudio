function reset_midi() {
	// reset_midi()
	var a, b;
	midi_copyright = ""
	midi_tempo = 1
	midi_micsecqn = 0
	midi_minpos = -1
	midi_maxpos = 0
	for (a = 0; a < midi_tracks; a += 1) {
	    for (b = 0; b < midi_trackamount[a]; b += 1) {
	        midi_eventx[a, b] = 0
	        midi_eventnote[a, b] = 0
	        midi_eventchannel[a, b] = 0
			midi_eventuntil[a, b] = -1
	    }
	    midi_trackname[a] = ""
	    midi_trackamount[a] = 0
	    midi_tracklength[a] = 0
	}
	midi_channels = 0
	for (a = 0; a < 16; a += 1) {
	    midi_channelpatch[a] = 0
	    midi_channelins[a] = 0
	    midi_channeloctave[a] = 0
	}

	for (a = 0; a < midi_percamount; a += 1) {
	    midi_percnote[a] = 0
	    midi_percins[a] = 0
	    midi_percpitch[a] = 0
	}
	midi_percamount = 0

	midi_tempo_changers = 0
	array_delete(midi_tempo_changer_x, 0, array_length(midi_tempo_changer_x))
	array_delete(midi_tempo_changer_tempo, 0, array_length(midi_tempo_changer_x))
	midi_tempo_changer_x[0] = -1
	midi_tempo_changer_tempo[0] = -1
	

}
