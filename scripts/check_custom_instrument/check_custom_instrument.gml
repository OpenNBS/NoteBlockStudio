function check_custom_instrument(argument0) {
	// check_custom_instrument(string)
	var arr_data = selection_to_array(argument0)
	var total_vals = array_length(arr_data)
	var at = 0

	while (at < total_vals) {
		at++ // Column offset
		while (at < total_vals) {
			var row_offset = arr_data[at++]
			if (row_offset == -1) break
			if (at >= total_vals) return -1

			var instrument_index = arr_data[at++]
			if (instrument_index < 0 || instrument_index >= ds_list_size(songs[song].instrument_list)) return -1
			at += 4 // Key, velocity, panning and fine pitch
		}
	}

	return 0
}
