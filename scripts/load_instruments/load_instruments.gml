function load_instruments(argument0) {
	// load_instruments(filename)
	// Loads custom instruments from a song and adds them to the current song.

	var fn, a, b, nbsver, height;
	fn = argument0
	if (fn = "") {
	    if (!directory_exists_lib(songfolder)) songfolder = songs_directory
	    fn = string(get_open_filename_ext("Note Block Songs (*.nbs)|*.nbs", "", songfolder, "Load instruments from song"))
	}
	if (fn = "" || !file_exists_lib(fn)) return 0
	buffer = buffer_import(fn)
	
	if (buffer_read_short() == 0) {
		nbsver = buffer_read_byte()
	} else {
		nbsver = 0
	}

	// Future version
	if (nbsver > nbs_version) {
		message("Warning: You are opening an NBS file created in a later version of Note Block Studio.\nPlease save the song as a version " + string(nbs_version) + " file or lower via the Save Options menu.","Error")
		return -1
	}

	// Header
	if (nbsver >= 1) buffer_read_byte()		// Custom instrument index
	if (nbsver >= 3) buffer_read_short()	// Song length
	height = buffer_read_short()
	buffer_read_string_int()	// Song name
	buffer_read_string_int()	// Soung author
	buffer_read_string_int()	// Song original author
	buffer_read_string_int()	// Song description
	buffer_read_short()			// Tempo
	buffer_read_byte()			// Autosave
	buffer_read_byte()			// Autosave minutes
	buffer_read_byte()			// Time signature
	buffer_read_int()			// Minutes spent
	buffer_read_int()			// Left-clicks
	buffer_read_int()			// Right-clicks
	buffer_read_int()			// Blocks added
	buffer_read_int()			// Blocks removed
	buffer_read_string_int()	// MIDI filename
	if (nbsver >= 4) {
		buffer_read_byte()		// Loop
		buffer_read_byte()		// Loop count
		buffer_read_short()		// Loop start tick
	}

	// Note blocks
	while (true) {
	    a = buffer_read_short()
	    if (a = 0) break
	    while (true) {
	        a = buffer_read_short()
	        if (a = 0) break
	        buffer_read_byte()		// Instrument
	        buffer_read_byte()		// Key
			if (nbsver >= 4) {
				buffer_read_byte()	// Velocity
				buffer_read_byte()	// Pan
				buffer_read_short()	// Pitch
			}
	    }
	}
	if (buffer_is_eof()) {
		message("This file does not contain any custom instruments.", "Error")
		return 0
	}

	// Layers
	for (b = 0; b < height; b++) {
	    buffer_read_string_int()			// Layer name
		if (nbsver >= 4) buffer_read_byte()	// Layer lock
	    buffer_read_byte()					// Layer volume
		if (nbsver >= 2) buffer_read_byte()	// Layer stereo
	}
	if (buffer_is_eof()) {
		message("This file does not contain any custom instruments.", "Error")
		return 0
	}

	// Instruments
	a = buffer_read_byte()
	if (a = 0) {
	    message("This file does not contain any custom instruments.", "Error")
	    return 0
	}
	for (b = 0; b < a; b++) {
	    var name = buffer_read_string_int()
	    var filename = buffer_read_string_int()
	    var key = buffer_read_byte()
	    var press = buffer_read_byte()
	    var ins = new_instrument(name, filename, true, press, key)
	    with (ins)
	        instrument_load()
	    ds_list_add(songs[song].instrument_list, ins)
	}
	songs[song].changed = true




}
