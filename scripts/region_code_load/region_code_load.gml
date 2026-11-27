function region_code_load(argument0, argument1, argument2) {
	// region_code_load(x, y, code)
	// Loads the specified code into the x, y position.
	//show_debug_message("region_code_load " + argument2)
	var xx, yy, str, ca, cb, val, ins, key, vel, pan, pit;
	xx = argument0
	yy = argument1
	str = try_decompress_selection(argument2)
	if (str = "") return 0
	ca = 0
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
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
	        var ins = songs[song].instrument_list[| val]
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
	        var key = val
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
			var vel = val
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
			var pan = val
	        pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
			val = real(buffer_substr_copy(str_buffer, prev_pipe_pos + 1, pipe_pos - prev_pipe_pos - 1, val_buffer))
			prev_pipe_pos = pipe_pos
			var pit = val
	        add_block(xx + ca, yy + cb, ins, key, vel, pan, pit)
	    }
		pipe_pos = buffer_pos_char(str_buffer, str_len, "|", pipe_pos + 1)
	} until (pipe_pos >= str_len)
	buffer_delete(str_buffer)
	buffer_delete(val_buffer)
	update_tempo_changes()
	
}
