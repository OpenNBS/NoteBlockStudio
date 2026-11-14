function selection_load(argument0, argument1, argument2, argument3) {
	// selection_load(x, y, code, undo)
	// Loads the selection from the string.
	var xx, yy, str, ca, cb, val, h;
	xx = argument0
	yy = argument1
	str = try_decompress_selection(argument2)
	selection_place(argument3)
	if (str = "") return 0
	ca = 0
	h = 0
	var instrument_map = -1
	var invalid_instrument = false
	if (argument_count > 4) instrument_map = argument[4]
	
	var str_len = string_length(str)
	var str_buffer = string_buffer_create(str)
	var val_buffer = buffer_create(1, buffer_grow, 1)
	
	var pipe_pos = buffer_pos_char(str_buffer, str_len, "|")
	var prev_pipe_pos = -1
	do {
		val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
		prev_pipe_pos = pipe_pos
	    ca += val
	    cb = 0
	    while (1) {
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
	        if (val == -1) break
	        cb += val
	        songs[song].selection_exists[ca, cb] = 1
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
			if (instrument_map != -1 && val >= first_custom_index) {
				if (ds_map_exists(instrument_map, val)) val = instrument_map[? val]
				else {
					val = 0
					invalid_instrument = true
				}
			}
			if (val < 0 || val >= ds_list_size(songs[song].instrument_list)) {
				val = 0
				invalid_instrument = true
			}
	        songs[song].selection_ins[ca, cb] = songs[song].instrument_list[| val]
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
	        songs[song].selection_key[ca, cb] = val
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
			songs[song].selection_vel[ca, cb] = val
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
			songs[song].selection_pan[ca, cb] = val
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
			songs[song].selection_pit[ca, cb] = val
	        songs[song].selected += 1
	        if (songs[song].selection_colfirst[ca] = -1) songs[song].selection_colfirst[ca] = cb
	        songs[song].selection_collast[ca] = cb
	        h = max(h, cb)
	    }
		pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
	} until (pipe_pos >= str_len)
	buffer_delete(str_buffer)
	buffer_delete(val_buffer)
	
	songs[song].selection_x = xx
	songs[song].selection_y = yy
	songs[song].selection_l = ca + 1
	songs[song].selection_h = h + 1
	selection_code_update()
	selection_expand_layers()
	if (invalid_instrument) set_msg(condstr(language != 1, "Some notes used unavailable instruments and were changed to Harp", "部分音符使用了不可用的音色，已替换为 Harp"))
	return !invalid_instrument
}
