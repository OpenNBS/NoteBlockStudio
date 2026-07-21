function instrument_change(ins) {
	var fn, newfn, relative_filename;
	if (language != 1) fn = string(get_open_filename_ext("Supported sounds (*.ogg;*.wav)|*.ogg;*.wav", "", sounds_directory, "Load sound file"))
	else fn = string(get_open_filename_ext("Supported sounds (*.ogg;*.wav)|*.ogg;*.wav", "", sounds_directory, "打开声音文件"))
	if (file_exists_lib(fn)) {
		var fn_path = string_replace_all(fn, "\\", "/")
		var sounds_path = string_replace_all(sounds_directory, "\\", "/")
		var bundled_sounds_path = string_replace_all(bundled_sounds_directory, "\\", "/")
		var fn_compare = fn_path
		var sounds_compare = sounds_path
		var bundled_sounds_compare = bundled_sounds_path
		if (os_type = os_windows) {
			fn_compare = string_lower(fn_compare)
			sounds_compare = string_lower(sounds_compare)
			bundled_sounds_compare = string_lower(bundled_sounds_compare)
		}

		if (string_copy(fn_compare, 1, string_length(sounds_compare)) == sounds_compare) {
			// Sound is already in the Sounds folder or in a subfolder
			newfn = fn;
			relative_filename = string_delete(fn_path, 1, string_length(sounds_path))
		} else if (string_copy(fn_compare, 1, string_length(bundled_sounds_compare)) == bundled_sounds_compare) {
			// Preserve the bundled Sounds subfolder when copying to the user Sounds folder
			relative_filename = string_delete(fn_path, 1, string_length(bundled_sounds_path))
			newfn = sounds_directory + string_replace_all(relative_filename, "/", condstr(os_type = os_windows, "\\", "/"))
			if (!directory_exists_lib(filename_dir(newfn))) {
				directory_create_lib(filename_dir(newfn))
			}
			files_copy_lib(fn, newfn)
		} else {
			// Sound is elsewhere, copy to root of Sounds folder
			relative_filename = filename_name(fn)
			newfn = sounds_directory + relative_filename;
			files_copy_lib(fn, newfn)
		}
		if (string_copy(ins.name, 0, 19) == "Custom instrument #") {
			ins.name = filename_change_ext(filename_name(newfn), "")
			text_exists[70 + ds_list_find_index(songs[song].instrument_list, ins)] = 0
		}
	    songs[song].changed = true
	    with (ins) {
	        filename = relative_filename
	        if (loaded)
	            instrument_free()
	        instrument_load()
	    }
	}
}
