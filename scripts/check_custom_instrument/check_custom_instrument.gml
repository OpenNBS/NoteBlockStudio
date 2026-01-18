function check_custom_instrument(argument0) {
	// check_custom_instrument(string)
	var str, total_vals, val
	str = argument0
	var arr_data = selection_to_array_ext()
	total_vals = array_length(arr_data)
	val = 0
	//show_debug_message(string_count("-1", str))
	//for (var i = 0; i < total_vals; i++;) {show_debug_message(arr_data[i])}
	while (val < total_vals) {
		val += 2
		if arr_data[val] >= ds_list_size(songs[song].instrument_list) {
	//		show_debug_message("custom instrument found")
			return -1
		}
		val += 5
		while arr_data[val] != -1 {
			val += 1
			if arr_data[val] >= ds_list_size(songs[song].instrument_list) {
	//			show_debug_message("custom instrument found")
				return -1
			}
			val += 5
		}
		val ++
	}
	//show_debug_message("no custom instrument found")
	return 0


}
