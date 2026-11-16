function macro_column_count(arr_data, length = undefined){
	if (is_undefined(length)) {
		length = array_length(arr_data)
	}
	
	var count = 0
	for (var i = 0; i < length; ++i) {
		if (arr_data[i] == -1) {
			++count
		}
	}
	return count
}

function macro_is_event_note(instrument_index) {
	var insname = songs[song].instrument_list[| instrument_index].name
	return insname == "Tempo Changer" || insname == "Sound Stopper"
}

// Keep control events in place when a macro repeats or moves musical notes.
function macro_event_notes_get() {
	var events = []
	var s = songs[song]
	for (var a = 0; a < s.selection_l; a++) {
		if (s.selection_colfirst[a] < 0) continue
		for (var b = s.selection_colfirst[a]; b <= s.selection_collast[a]; b++) {
			if (!s.selection_exists[a, b]) continue
			var ins = s.selection_ins[a, b]
			if (ins.name == "Tempo Changer" || ins.name == "Sound Stopper") {
				array_push(events, [a, b, ins, s.selection_key[a, b], s.selection_vel[a, b], s.selection_pan[a, b], s.selection_pit[a, b]])
			}
		}
	}
	return events
}
