function midi_is_note_fade(name, fadetype){
	// 0: fade in
	// 1: fade out
	var array;
	if (fadetype) array = midi_fadeout
	else array = midi_fadein
	for (var i = 0; i < array_length(array); i++) {
		if (name = array[i]) return 1
	}
	return 0
}