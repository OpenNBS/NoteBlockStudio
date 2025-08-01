function selection_load_from_array(xx, yy, array){
	// Load a selection code array to the selection data arrays
	
	var ca, cb, h;
	var length = array_length(array)
	if (length == 0) return 0
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

	songs[song].selection_x = xx
	songs[song].selection_y = yy
	songs[song].selection_l = ca + 1
	songs[song].selection_h = h + 1
	selection_code_update()
	selection_expand_layers()
	update_tempo_changes()
}