function macro_vibrato() {
	// macro_vibrato()
	var str, total_vals, val, decr
	str = selection_code
	if (selected = 0) return 0
	var arr_data = selection_to_array_ext()
	total_vals = array_length(arr_data)
	val = 0
	decr = 100/macro_column_count(arr_data)
	//for (var i = 0; i < total_vals; i++;) {show_debug_message(arr_data[i])}
	while (val < total_vals) {
		// First column 100
		val += 6
		arr_data[val] = 40
		val ++
		while arr_data[val] != -1 {
			val = val + 5
			arr_data[val] = 40
			val ++
		}
		// Second column 50
		val += 7
		if val >= total_vals break
		arr_data[val] = 0
		val ++
		while arr_data[val] != -1 {
			val = val + 5
			arr_data[val] = 0
			val ++
		}
		// Third column 25
		val += 7
		if val >= total_vals break
		arr_data[val] = -40
		val ++
		while arr_data[val] != -1 {
			val = val + 5
			arr_data[val] = -40
			val ++
		}
		val += 7
		if val >= total_vals break
		arr_data[val] = 0
		val ++
		while arr_data[val] != -1 {
			val = val + 5
			arr_data[val] = 0
			val ++
		}
		val ++
	}
	selection_load_from_array(selection_x, selection_y, arr_data)
	history_set(h_selectchange, selection_x, selection_y, selection_code, selection_x, selection_y, str)
	if(!keyboard_check(vk_alt)) selection_place(false)



}
