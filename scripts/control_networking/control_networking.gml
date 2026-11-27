function control_networking(){
	if (async_load[? "type"] == network_type_data) {
		var temp_buffer = async_load[? "buffer"];
		var type = buffer_read(temp_buffer, buffer_u8)
		if (type = 10) {
			load_song(buffer_read(temp_buffer, buffer_string))
		}
		buffer_delete(temp_buffer)
	}
}