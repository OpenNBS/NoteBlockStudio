function selection_load_from_array(xx, yy, array, protected_events = []){
	// Load a selection code array to the selection data arrays
	
	var ca, cb, h;
	var length = array_length(array)
	if (length == 0) return 0
	var keep_events = array_length(protected_events) > 0
	var event_positions = {}
	for (var i = 0; i < array_length(protected_events); i++) {
		var entry = protected_events[i]
		variable_struct_set(event_positions, string(entry[0]) + ":" + string(entry[1]), true)
	}
	ca = 0
	h = 0
	
	var at = 0
	
	while(at < length) {
	    ca += array[at++]
	    cb = 0
	    while (1) {
			var val = array[at++]
	        if (val == -1) break
	        cb += val
			if (keep_events && (macro_is_event_note(array[at]) || variable_struct_exists(event_positions, string(ca) + ":" + string(cb)))) {
				at += 5
				continue
			}
			remove_block_select(xx + ca, yy + cb)
	        songs[song].selection_exists[ca, cb] = 1
			songs[song].selection_ins[ca, cb] = songs[song].instrument_list[| array[at++] ]
			songs[song].selection_key[ca, cb] = array[at++]
			songs[song].selection_vel[ca, cb] = array[at++]
			songs[song].selection_pan[ca, cb] = array[at++]
			songs[song].selection_pit[ca, cb] = array[at++]
			songs[song].selected += 1
			if (songs[song].selection_colfirst[ca] = -1) songs[song].selection_colfirst[ca] = cb
			songs[song].selection_collast[ca] = cb
			h = max(h, cb)
	    }
	}
	for (var i = 0; i < array_length(protected_events); i++) {
		var entry = protected_events[i]
		var a = entry[0], b = entry[1]
		if (!songs[song].selection_exists[a, b]) songs[song].selected++
		songs[song].selection_exists[a, b] = 1
		songs[song].selection_ins[a, b] = entry[2]
		songs[song].selection_key[a, b] = entry[3]
		songs[song].selection_vel[a, b] = entry[4]
		songs[song].selection_pan[a, b] = entry[5]
		songs[song].selection_pit[a, b] = entry[6]
		if (songs[song].selection_colfirst[a] == -1 || b < songs[song].selection_colfirst[a]) songs[song].selection_colfirst[a] = b
		songs[song].selection_collast[a] = max(songs[song].selection_collast[a], b)
		ca = max(ca, a)
		h = max(h, b)
	}
	if (keep_events) {
		songs[song].selection_arraylength = max(songs[song].selection_arraylength, ca)
		songs[song].selection_arrayheight = max(songs[song].selection_arrayheight, h)
	}

	songs[song].selection_x = xx
	songs[song].selection_y = yy
	songs[song].selection_l = ca + 1
	songs[song].selection_h = h + 1
	selection_code_update()
	selection_expand_layers()
	update_tempo_changes()
}
