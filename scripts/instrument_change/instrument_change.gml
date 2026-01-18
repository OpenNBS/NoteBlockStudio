function instrument_change(ins) {
	var fn, newfn;
	if (language != 1) fn = string(get_open_filename_ext("Supported sounds (*.ogg;*.wav;*.mp3)|*.ogg;*.wav;*.mp3", "", sounds_directory, "Load sound file"))
	else fn = string(get_open_filename_ext("Supported sounds (*.ogg;*.wav;*.mp3)|*.ogg;*.wav;*.mp3", "", sounds_directory, "打开声音文件"))
	if (file_exists_lib(fn)) {
		if (string_count(sounds_directory, fn) > 0) {
			// Sound is already in the Sounds folder or in a subfolder
			newfn = fn;
		} else {
			// Sound is elsewhere, copy to root of Sounds folder
			newfn = sounds_directory + filename_name(fn);
			files_copy_lib(fn, newfn)
		}
		if (string_copy(ins.name, 0, 19) == "Custom instrument #") {
			ins.name = filename_change_ext(filename_name(newfn), "")
			text_exists[70 + ds_list_find_index(songs[song].instrument_list, ins)] = 0
		}
	    songs[song].changed = true
	    with (ins) {
	        filename = string_delete(newfn, 1, string_length(sounds_directory))
			if (os_type = os_windows) filename = string_replace_all(filename, "\\", "/")
	        if (loaded)
	            instrument_free()
	        instrument_load()
	    }
	}
}