function macro_chorus() {
	// macro_chorus()
	var str, total_vals, val;
	str = songs[song].selection_code
	var arr_data = selection_to_array_ext()
	window = 0
	total_vals = array_length(arr_data)
	log(str)
	val = 0
	while (val < total_vals) {
		val += 5
		arr_data[val] = 140
		val ++
		arr_data[real(val)] = arr_data[real(val)] + real(5)
		val ++
		if arr_data[val] = -1 {
			if (language != 1) message("There must be exactly two layers worth of note blocks in every applicable tick!", "Error")
			else message("应用的每刻内必须有两层方块！", "错误")
			return 1
		}
		val += 4
		arr_data[val] = 60
		val++
		arr_data[real(val)] = arr_data[real(val)] + real(-5)
		val ++
		if (arr_data[val] = -1) val++
		else {
			val--
			for(var i = 0; i >= 0; i++) { //inf loop
				val += 5
				arr_data[val] = 100 + 40 * power(-1, i)
				val ++
				arr_data[real(val)] = arr_data[real(val)] + real(5) * power(-1, i)
				val ++
				if arr_data[val] = -1 {
					val++
					break
				} else {
					val--
				}
			}
		}
	}
	selection_load_from_array(songs[song].selection_x, songs[song].selection_y, arr_data)
	history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)
	if(!keyboard_check(vk_alt)) selection_place(false)


}
