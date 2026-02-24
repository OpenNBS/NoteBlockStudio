function instrument_remove(ins) {
	selection_place(0)
	if (songs[song].instrument_list[| ds_list_find_index(songs[song].instrument_list, ins)].name == "Tempo Changer") songs[song].tempo_changes = [[0, 10]]
	for (a = 0; a <= songs[song].enda; a += 1) {
		if (songs[song].colamount[a] > 0) {
			for (b = songs[song].colfirst[a]; b <= songs[song].collast[a]; b += 1) {
			    if (songs[song].song_exists[a, b] && songs[song].song_ins[a, b] = ins) {
					remove_block(a, b)
				}
			}
		}
	}
	
	// Remove this instrument from MIDI devices that might be using it
	for (d = 0; d < midi_devices; d += 1) {
		var midi_ins = mididevice_instrument[d]
		if (midi_ins == ins) {
			mididevice_instrument[d] = -1; // fall back to 'Use selected'
		}
	}
	
	with (ins) {
		instrument_free()
		ds_list_delete_value(other.songs[other.song].instrument_list, ins)
		instance_destroy()
	}
	
	// Reset text boxes to update the instrument name
	for (var i = ds_list_find_index(songs[song].instrument_list, ins); i <= ds_list_size(songs[song].instrument_list); i++) {
		text_exists[70 + i] = -1
	}
	
	songs[song].user_instruments--
	songs[song].changed = 1
}