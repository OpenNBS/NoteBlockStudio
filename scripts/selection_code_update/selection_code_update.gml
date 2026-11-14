function selection_code_update() {
	// selection_code_update()
	// Updates the selection code
	var a, b, ca, cb;
	
	if (songs[song].selected = 0) {
		ds_list_clear(songs[song].selected_layers)
		return 0
	}
	ca = 0
	
	var _selection_l = songs[song].selection_l
	var _selection_h = songs[song].selection_h
	var _selection_colfirst = songs[song].selection_colfirst
	var _selection_exists = songs[song].selection_exists
	var _selection_ins = songs[song].selection_ins
	var _selection_key = songs[song].selection_key
	var _selection_vel = songs[song].selection_vel
	var _selection_pan = songs[song].selection_pan
	var _selection_pit = songs[song].selection_pit

	
	var str_buffer = buffer_create(16, buffer_grow, 1);
	for (a = 0; a < _selection_l; a += 1) {
	    if (_selection_colfirst[a] > -1) {
			buffer_write(str_buffer, buffer_text, string(ca))
			buffer_write(str_buffer, buffer_text, "|")
	        ca = 0
	        cb = 0
	        for (b = 0; b < _selection_h; b += 1) {
	            if (_selection_exists[a, b]) {
					buffer_write(str_buffer, buffer_text, string(cb))
					buffer_write(str_buffer, buffer_text, "|")
	                cb = 0
					buffer_write(str_buffer, buffer_text, string(ds_list_find_index(songs[song].instrument_list, _selection_ins[a, b])))
					buffer_write(str_buffer, buffer_text, "|")
					buffer_write(str_buffer, buffer_text, string(_selection_key[a, b]))
					buffer_write(str_buffer, buffer_text, "|")
					buffer_write(str_buffer, buffer_text, string(_selection_vel[a, b]))
					buffer_write(str_buffer, buffer_text, "|")
					buffer_write(str_buffer, buffer_text, string(_selection_pan[a, b]))
					buffer_write(str_buffer, buffer_text, "|")
					buffer_write(str_buffer, buffer_text, string(_selection_pit[a, b]))
					buffer_write(str_buffer, buffer_text, "|")
	            }
	            cb += 1
	        }
			buffer_write(str_buffer, buffer_text, "-1|")
	    }
	    ca += 1
	}

	buffer_seek(str_buffer, buffer_seek_start, 0)
	songs[song].selection_code = try_compress_selection(buffer_read(str_buffer, buffer_string))
	buffer_delete(str_buffer)
}
