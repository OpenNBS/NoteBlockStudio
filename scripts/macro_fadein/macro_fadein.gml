function macro_fadein() {
	// macro_fadein()
	var str, total_vals, val, decr, maxdecr
	str = songs[song].selection_code
	if (songs[song].selected = 0) return 0
	var arr_data = selection_to_array_ext()
	total_vals = array_length(arr_data)
	val = 0
	maxdecr = 1.0
	decr = maxdecr/(macro_column_count(arr_data) - 1)
	var current_factor = 0.0
	//show_debug_message(string_count("-1", str))
	//for (var i = 0; i < total_vals; i++;) {show_debug_message(arr_data[i])}
	while (val < total_vals) {
		val += 4
		arr_data[val] = ceil(arr_data[val] * current_factor)
		arr_data[val] = max(1, min(arr_data[val], 100))
		val += 3
		while arr_data[val] != -1 {
			val += 3
			arr_data[val] = ceil(arr_data[val] * current_factor)
				arr_data[val] = max(1, min(arr_data[val], 100))
			val += 3
		}
		// Reached end of column; next column
		current_factor += decr
		val ++
	}
	selection_load_from_array(songs[song].selection_x, songs[song].selection_y, arr_data)
	history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)
	if(!keyboard_check(vk_alt)) selection_place(false)



}
