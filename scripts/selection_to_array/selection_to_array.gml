function selection_to_array(str) {
	// selection_to_array(str)
	var array = []
	var at = 0
	var sel_str = try_decompress_selection(str)
	var main_str = string_delete(sel_str, string_length(sel_str), 1)
	
	var main_str_len = string_length(main_str)
	var main_str_buffer = string_buffer_create(main_str)
	var element_buffer = buffer_create(1, buffer_grow, 1)
	var pipe_ord = ord("|")
	var prev_pipe_pos = -1
	var pipe_pos = 0
	while (true) {
		pipe_pos = buffer_pos_char(main_str_buffer, main_str_len, pipe_ord, pipe_pos)
		var element_size = pipe_pos - prev_pipe_pos - 1
		if (element_size > 0) {
			array_grow_then_set(array, at++, real(buffer_substr_copy(main_str_buffer, prev_pipe_pos+1, element_size, element_buffer)))
		}
		if (pipe_pos >= main_str_len) {
			break
		}
		prev_pipe_pos = pipe_pos
		pipe_pos++
	}
	array_resize(array, at)
	buffer_delete(main_str_buffer)
	buffer_delete(element_buffer)
	
	return array
}
