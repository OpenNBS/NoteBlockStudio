function init_midi() {
	// init_midi()
	midi_instruments()
	var a;
	midi_copyright = ""
	midi_tempo = 1

	midi_percamount = 0
	midi_percnote[0] = 0
	midi_percins[0] = 0
	midi_percpitch[0] = 0

	midi_micsecqn = 0
	midi_minpos = -1
	midi_maxpos = 0
	midi_trackname[0] = ""
	midi_trackamount[0] = 0
	midi_tracklength[0] = 0
	midi_tracks = 0
	midi_channels = 0
	midi_parts = []
	midi_part_lookup = {}
	for (a = 0; a < 16; a += 1) {
	    midi_channelpatch[a] = 0
	    midi_channelins[a] = 0
	    midi_channeloctave[a] = 0
	}
	
	midi_tempo_changer_x[0] = -1
	midi_tempo_changer_tempo[0] = -1

}
