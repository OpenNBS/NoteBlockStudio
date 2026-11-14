function load_text(argument0) {
	// load_text(filename)
	// Loads a text file into a string.

	if (file_exists_lib(argument0)) {

	    var file, str

	    file = file_text_open_read(argument0)
		// A file may exist without being readable (for example, outside a
		// macOS file-picker grant). Keep the same failure result as a missing file.
		if (file < 0) return 0
	    str = ""

	    while (!file_text_eof(file)) {
	        str += file_text_readln(file)
	    }

	    file_text_close(file)
	
		return str

	} else {
	
		return 0

	}


}
