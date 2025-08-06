function instrument_load(custom_sounds_path = "") {
	// instrument_load()

	var fn;

	if (filename == "") {
		return false;
	}

	// If a custom Sounds folder is provided, try loading the sound from it.
	// If not provided or the sound doesn't exist there, fall back to the default Sounds folder
	if (custom_sounds_path == "") {
		fn = bundled_sounds_directory + filename;
	} else {
		var custom_fn = custom_sounds_path + filename;
		
		if (file_exists_lib(custom_fn)) {
			fn = custom_fn;
		} else {
			fn = bundled_sounds_directory + filename;
		}
	}

	if (os_type = os_windows) fn = string_replace_all(fn, "/", "\\");

	log("Load instrument", fn)

	if (!file_exists_lib(fn)) {
		return false
	}

	if (os_type = os_windows) {
		log("audio_file_decode")
		var ret = audio_file_decode(fn, temp_file);
		if (ret < 0) {
		    if (language != 1) message("Couldn't load the file " + fn + "! Error: " + string(ret), "Error")
		    else message("找不到文件" + fn + "！错误代码：" + string(ret), "错误")
		    return 0
		}

		log("buffer_load")
		sound_buffer_temp = buffer_load(temp_file)
		sound_buffer = buffer_create(buffer_get_size(sound_buffer_temp), buffer_fixed, 2)
		buffer_copy(sound_buffer_temp, 0, buffer_get_size(sound_buffer_temp), sound_buffer, 0)
		sound = audio_create_buffer_sound(sound_buffer, buffer_s16, 44100, 0, buffer_get_size(sound_buffer), audio_stereo)
		buffer_delete(sound_buffer_temp)
	} else {
		ret = audio_create_stream(fn)
		if (ret < 0) {
		    if (language != 1) message("Couldn't load the file " + fn + "! Error: " + string(ret), "Error")
		    else message("找不到文件" + fn + "！错误代码：" + string(ret), "错误")
		    return 0
		}
		sound = ret
	}

	loaded = true

	return true



}
