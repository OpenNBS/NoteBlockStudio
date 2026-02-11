function set_resourcepack(pack_name){
	pack_obj = -1
	var file = ""
	var dir = ""
	var dir_no_path = ""
	var using_directory = sounds_directory
	var sounds_json
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
			dir = using_directory + "pack_temp" + condstr(os_type = os_windows, "\\", "/")
			dir_no_path = "pack_temp" + condstr(os_type = os_windows, "\\", "/")
		} else {
			dir = using_directory + pack_name + condstr(os_type = os_windows, "\\", "/")
			dir_no_path = "ResourcePacks" + condstr(os_type = os_windows, "\\", "/") + pack_name + condstr(os_type = os_windows, "\\", "/")
		}
	} else {
		dir_no_path = "idkjustloadvanilla"
	}
	log(dir_no_path)
	swap_instrument(0, "Harp", "harp2", "harp", dir_no_path, using_directory)
	swap_instrument(1, "Double Bass", "bassattack", "dbass", dir_no_path, using_directory)
	swap_instrument(2, "Bass Drum", "bd", "bdrum", dir_no_path, using_directory)
	swap_instrument(3, "Snare Drum", "snare", "sdrum", dir_no_path, using_directory)
	swap_instrument(4, "Click", "hat", "click", dir_no_path, using_directory)
	swap_instrument(5, "Guitar", "guitar", "guitar", dir_no_path, using_directory)
	swap_instrument(6, "Flute", "flute", "flute", dir_no_path, using_directory)
	swap_instrument(7, "Bell", "bell", "bell", dir_no_path, using_directory)
	swap_instrument(8, "Chime", "icechime", "icechime", dir_no_path, using_directory)
	swap_instrument(9, "Xylophone", "xylobone", "xylobone", dir_no_path, using_directory)
	swap_instrument(10, "Iron Xylophone", "iron_xylophone", "iron_xylophone", dir_no_path, using_directory)
	swap_instrument(11, "Cow Bell", "cow_bell", "cow_bell", dir_no_path, using_directory)
	swap_instrument(12, "Didgeridoo", "didgeridoo", "didgeridoo", dir_no_path, using_directory)
	swap_instrument(13, "Bit", "bit", "bit", dir_no_path, using_directory)
	swap_instrument(14, "Banjo", "banjo", "banjo", dir_no_path, using_directory)
	swap_instrument(15, "Pling", "pling", "pling", dir_no_path, using_directory)
	swap_instrument(16, "Trumpet", "trumpet", "trumpet", dir_no_path, using_directory)
	swap_instrument(17, "Exposed Trumpet", "trumpet_exposed", "trumpet_exposed", dir_no_path, using_directory)
	swap_instrument(18, "Weathered Trumpet", "trumpet_weathered", "trumpet_weathered", dir_no_path, using_directory)
	swap_instrument(19, "Oxidized Trumpet", "trumpet_oxidized", "trumpet_oxidized", dir_no_path, using_directory)
	//for (var i = 0; i < array_length(songs); i++) {
	//	for (var j = 0; j < 16; j++) {
	//		ds_list_replace(songs[i].instrument_list, j, original_instruments[j])
	//	}
	//	songs[i].instrument = songs[i].instrument_list[| 0]
	//}
	current_resource = pack_name
}

function swap_instrument(index, ins_name, sound_name, vanilla_name, dir_no_path, using_directory){
	var new_ins = -1
	if (file_exists_lib(using_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg")) {
		with (original_instruments[index]) {
			filename = dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg"
			//if (os_type = os_windows) {
				log("audio_file_decode")
				if (file_exists(temp_file)) file_delete(temp_file)
				var ret = audio_file_decode_ogg(using_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg", temp_file);
				if (ret < 0) {
				    if (obj_controller.language != 1) message("Couldn't load the file " + using_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg" + "! Error: " + string(ret), "Error")
				    else message("找不到文件" + using_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg" + "！错误代码：" + string(ret), "错误")
				}

				log("buffer_load")
				sound_buffer_temp = buffer_load(temp_file)
				sound_buffer = buffer_create(buffer_get_size(sound_buffer_temp), buffer_fixed, 2)
				buffer_copy(sound_buffer_temp, 0, buffer_get_size(sound_buffer_temp), sound_buffer, 0)
				sound = audio_create_buffer_sound(sound_buffer, buffer_s16, 44100, 0, buffer_get_size(sound_buffer), audio_stereo)
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
		log("File " + using_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg" + " not found")
		with (original_instruments[index]) {
			filename = vanilla_name + ".ogg"
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
	log(using_directory + dir_no_path + "assets/minecraft/sounds/note/" + sound_name + ".ogg")
}
