function set_resourcepack(pack_name){
	pack_obj = -1
	var dir_no_path = ""
	var using_directory = sounds_directory
	var sounds_json = undefined
	if (directory_exists(sounds_directory + "pack_temp")) directory_destroy(sounds_directory + "pack_temp")
	if (pack_name != "Vanilla") {
		for (var i = 1; i < array_length(resourcepacks); i++) {
			if (resourcepacks[i].filename = pack_name) pack_obj = i
			log("need " + resourcepacks[i].filename + " found " + pack_name)
		}
		if (pack_obj = -1) {current_resource = "Vanilla"; return set_resourcepack("Vanilla");}
		if (resourcepacks[pack_obj].type = 1) {
			//if (directory_exists(sounds_directory + "pack_temp" + condstr(os_type = os_windows, "\\", "/"))) directory_destroy(sounds_directory + "pack_temp" + condstr(os_type = os_windows, "\\", "/"))
			directory_create(sounds_directory + "pack_temp")
			if (os_type != os_windows) log("unzip" + string(zip_unzip(resource_directory + pack_name, sounds_directory + "pack_temp" + condstr(os_type = os_windows, "\\", "/"))))
			else {
				log("unzip" + string(zip_unzip(resource_directory + pack_name, game_save_id + "pack_temp" + condstr(os_type = os_windows, "\\", "/"))))
				using_directory = game_save_id
			}
			//ExecuteShell("7za e \"" + resource_directory + pack_name + "\" -o \"" + sounds_directory + "pack_temp/\"")
			dir_no_path = "pack_temp" + condstr(os_type = os_windows, "\\", "/")
		} else {
			dir_no_path = "resourcepacks" + condstr(os_type = os_windows, "\\", "/") + pack_name + condstr(os_type = os_windows, "\\", "/")
		}
	} else {
		dir_no_path = "idkjustloadvanilla"
	}
	log(dir_no_path)
	var pack_root = using_directory + dir_no_path
	if (resourcepack_sounds_json && pack_name != "Vanilla") {
		sounds_json = resourcepack_load_sounds_json(pack_root, "minecraft")
	}
	swap_instrument(0, "Harp", "harp2", "harp", dir_no_path, using_directory, sounds_json)
	swap_instrument(1, "Double Bass", "bassattack", "dbass", dir_no_path, using_directory, sounds_json)
	swap_instrument(2, "Bass Drum", "bd", "bdrum", dir_no_path, using_directory, sounds_json)
	swap_instrument(3, "Snare Drum", "snare", "sdrum", dir_no_path, using_directory, sounds_json)
	swap_instrument(4, "Click", "hat", "click", dir_no_path, using_directory, sounds_json)
	swap_instrument(5, "Guitar", "guitar", "guitar", dir_no_path, using_directory, sounds_json)
	swap_instrument(6, "Flute", "flute", "flute", dir_no_path, using_directory, sounds_json)
	swap_instrument(7, "Bell", "bell", "bell", dir_no_path, using_directory, sounds_json)
	swap_instrument(8, "Chime", "icechime", "icechime", dir_no_path, using_directory, sounds_json)
	swap_instrument(9, "Xylophone", "xylobone", "xylobone", dir_no_path, using_directory, sounds_json)
	swap_instrument(10, "Iron Xylophone", "iron_xylophone", "iron_xylophone", dir_no_path, using_directory, sounds_json)
	swap_instrument(11, "Cow Bell", "cow_bell", "cow_bell", dir_no_path, using_directory, sounds_json)
	swap_instrument(12, "Didgeridoo", "didgeridoo", "didgeridoo", dir_no_path, using_directory, sounds_json)
	swap_instrument(13, "Bit", "bit", "bit", dir_no_path, using_directory, sounds_json)
	swap_instrument(14, "Banjo", "banjo", "banjo", dir_no_path, using_directory, sounds_json)
	swap_instrument(15, "Pling", "pling", "pling", dir_no_path, using_directory, sounds_json)
	swap_instrument(16, "Trumpet", "trumpet", "trumpet", dir_no_path, using_directory, sounds_json)
	swap_instrument(17, "Exposed Trumpet", "trumpet_exposed", "trumpet_exposed", dir_no_path, using_directory, sounds_json)
	swap_instrument(18, "Weathered Trumpet", "trumpet_weathered", "trumpet_weathered", dir_no_path, using_directory, sounds_json)
	swap_instrument(19, "Oxidized Trumpet", "trumpet_oxidized", "trumpet_oxidized", dir_no_path, using_directory, sounds_json)
	//for (var i = 0; i < array_length(songs); i++) {
	//	for (var j = 0; j < 16; j++) {
	//		ds_list_replace(songs[i].instrument_list, j, original_instruments[j])
	//	}
	//	songs[i].instrument = songs[i].instrument_list[| 0]
	//}
	current_resource = pack_name
}

function resourcepack_load_sounds_json(pack_root, sound_namespace) {
	var sounds_json_path = pack_root + "assets/" + sound_namespace + "/sounds.json"
	if (!file_exists_lib(sounds_json_path)) return undefined

	try {
		var contents = load_text(sounds_json_path)
		var parsed_json = json_parse(contents)
		if (is_struct(parsed_json)) return parsed_json
	} catch (e) {
		log("Couldn't parse resource pack sounds.json", sounds_json_path, e)
	}

	return undefined
}

function resourcepack_sound_asset_path(sound_reference, default_namespace) {
	var sound_namespace = default_namespace
	var sound_path = string_replace_all(sound_reference, "\\", "/")
	var namespace_separator = string_pos(":", sound_path)
	if (namespace_separator > 0) {
		sound_namespace = string_copy(sound_path, 1, namespace_separator - 1)
		sound_path = string_copy(sound_path, namespace_separator + 1, string_length(sound_path))
	}
	while (string_length(sound_path) > 0 && string_char_at(sound_path, 1) == "/") {
		sound_path = string_delete(sound_path, 1, 1)
	}
	if (sound_namespace == "" || sound_path == "") return ""
	if (string_lower(filename_ext(sound_path)) != ".ogg") sound_path += ".ogg"
	return "assets/" + sound_namespace + "/sounds/" + sound_path
}

function resourcepack_resolve_sound(pack_root, sounds_json, sound_event, sound_namespace, depth) {
	if (depth > 8 || !is_struct(sounds_json)) return undefined

	var event_namespace = sound_namespace
	var event_name = sound_event
	var namespace_separator = string_pos(":", event_name)
	if (namespace_separator > 0) {
		event_namespace = string_copy(event_name, 1, namespace_separator - 1)
		event_name = string_copy(event_name, namespace_separator + 1, string_length(event_name))
		if (event_namespace != sound_namespace) {
			sounds_json = resourcepack_load_sounds_json(pack_root, event_namespace)
			if (!is_struct(sounds_json)) return undefined
		}
	}

	if (!variable_struct_exists(sounds_json, event_name)) return undefined
	var sound_definition = sounds_json[$ event_name]
	if (!is_struct(sound_definition) || !variable_struct_exists(sound_definition, "sounds")) return undefined

	var sound_entries = sound_definition[$ "sounds"]
	if (!is_array(sound_entries)) sound_entries = [sound_entries]
	var fallback_sound = undefined

	for (var i = 0; i < array_length(sound_entries); i++) {
		var sound_entry = sound_entries[i]
		var sound_reference = ""
		var sound_type = "file"
		var sound_pitch = 1

		if (is_string(sound_entry)) {
			sound_reference = sound_entry
		} else if (is_struct(sound_entry) && variable_struct_exists(sound_entry, "name")) {
			sound_reference = sound_entry[$ "name"]
			if (!is_string(sound_reference)) continue
			if (variable_struct_exists(sound_entry, "type") && is_string(sound_entry[$ "type"])) {
				sound_type = string_lower(sound_entry[$ "type"])
			}
			if (variable_struct_exists(sound_entry, "pitch") && is_real(sound_entry[$ "pitch"]) && sound_entry[$ "pitch"] > 0) {
				sound_pitch = sound_entry[$ "pitch"]
			}
		} else {
			continue
		}

		var resolved_sound = undefined
		if (sound_type == "event") {
			resolved_sound = resourcepack_resolve_sound(pack_root, sounds_json, sound_reference, event_namespace, depth + 1)
		} else {
			var resolved_file = resourcepack_sound_asset_path(sound_reference, event_namespace)
			if (resolved_file != "") resolved_sound = { relative_file: resolved_file, pitch: 1 }
		}

		if (is_undefined(resolved_sound)) continue
		resolved_sound.pitch *= sound_pitch
		// NBS uses one sample per instrument, so prefer the first entry whose file is in the pack.
		if (is_undefined(fallback_sound)) fallback_sound = resolved_sound
		if (file_exists_lib(pack_root + resolved_sound.relative_file)) return resolved_sound
	}

	return fallback_sound
}

function swap_instrument(index, ins_name, sound_name, vanilla_name, dir_no_path, using_directory, sounds_json){
	var new_ins = -1
	var sound_asset_path = "assets/minecraft/sounds/note/" + sound_name + ".ogg"
	var sound_pitch = 1
	var pack_root = using_directory + dir_no_path
	if (!is_undefined(sounds_json)) {
		var resolved_sound = resourcepack_resolve_sound(pack_root, sounds_json, dat_instrument(index), "minecraft", 0)
		if (!is_undefined(resolved_sound)) {
			sound_asset_path = resolved_sound.relative_file
			sound_pitch = resolved_sound.pitch
		}
	}
	var sound_file = pack_root + sound_asset_path
	if (file_exists_lib(sound_file)) {
		with (original_instruments[index]) {
			filename = dir_no_path + sound_asset_path
			resourcepack_pitch = sound_pitch
			//if (os_type = os_windows) {
				log("audio_file_decode")
				if (file_exists(temp_file)) file_delete(temp_file)
				var ret = audio_file_decode_ogg(sound_file, temp_file);
				if (ret < 0) {
				    if (obj_controller.language != 1) message("Couldn't load the file " + sound_file + "! Error: " + string(ret), "Error")
				    else message("找不到文件" + sound_file + "！错误代码：" + string(ret), "错误")
				}

				log("buffer_load")
				sound_buffer_temp = buffer_load(temp_file)
				sound_buffer = buffer_create(buffer_get_size(sound_buffer_temp), buffer_fixed, 2)
				buffer_copy(sound_buffer_temp, 0, buffer_get_size(sound_buffer_temp), sound_buffer, 0)
				sound = audio_create_buffer_sound(sound_buffer, buffer_s16, 44100, 0, buffer_get_size(sound_buffer), audio_stereo)
				sound_duration = real(buffer_get_size(sound_buffer)) / (44100 * 4)
				buffer_delete(sound_buffer_temp)
			//} else {
			//	ret = audio_create_stream(bundled_sounds_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg")
			//	if (ret < 0) {
			//	    if (obj_controller.language != 1) message("Couldn't load the file " + bundled_sounds_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg" + "! Error: " + string(ret), "Error")
			//	    else message("找不到文件" + bundled_sounds_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg" + "！错误代码：" + string(ret), "错误")
			//	    return 0
			//	}
			//	sound = ret
			//}
		}
	} else {
		log("File " + sound_file + " not found")
		with (original_instruments[index]) {
			filename = vanilla_name + ".ogg"
			resourcepack_pitch = sound_pitch
			//if (os_type = os_windows) {
				log("audio_file_decode")
				if (file_exists(temp_file)) file_delete(temp_file)
				var ret = audio_file_decode_ogg(sounds_directory + vanilla_name + ".ogg", temp_file);
				if (ret < 0) {
				    if (obj_controller.language != 1) message("Couldn't load the file " + sounds_directory + vanilla_name + ".ogg" + "! Error: " + string(ret), "Error")
				    else message("找不到文件" + sounds_directory + vanilla_name + ".ogg" + "！错误代码：" + string(ret), "错误")
				}

				log("buffer_load")
				sound_buffer_temp = buffer_load(temp_file)
				sound_buffer = buffer_create(buffer_get_size(sound_buffer_temp), buffer_fixed, 2)
				buffer_copy(sound_buffer_temp, 0, buffer_get_size(sound_buffer_temp), sound_buffer, 0)
				sound = audio_create_buffer_sound(sound_buffer, buffer_s16, 44100, 0, buffer_get_size(sound_buffer), audio_stereo)
				sound_duration = real(buffer_get_size(sound_buffer)) / (44100 * 4)
				buffer_delete(sound_buffer_temp)
			//} else {
			//	ret = audio_create_stream(bundled_sounds_directory + vanilla_name + ".ogg")
			//	if (ret < 0) {
			//	    if (obj_controller.language != 1) message("Couldn't load the file " + bundled_sounds_directory + vanilla_name + ".ogg" + "! Error: " + string(ret), "Error")
			//	    else message("找不到文件" + bundled_sounds_directory + vanilla_name + ".ogg" + "！错误代码：" + string(ret), "错误")
			//	    return 0
			//	}
			//	sound = ret
			//}
		}
	}
	log(sound_file)
}
