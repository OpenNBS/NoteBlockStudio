function try_decompress_selection(str){
	// Decompress a base64-encoded selection code and return the uncompressed string.
	// Return the original string if the input string is not compressed.
	
	if (str == "") {
		return str
	}
	
	var pipe_pos = string_pos("|", str)
	if (pipe_pos == 0) { // Base64-encoded string cannot contain the '|' character
		var ret = str
		var str_buffer = buffer_base64_decode(str)
		var decompress_buffer = buffer_decompress(str_buffer)
		if (decompress_buffer != -1) {
			ret = buffer_read(decompress_buffer, buffer_string)
		} else {
			log("Cannot decompress buffer")
		}
		buffer_delete(decompress_buffer)
		buffer_delete(str_buffer)
		return ret
	} else {
		return str
	}
}