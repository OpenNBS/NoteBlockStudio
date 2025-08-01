function get_asset_index_friendly_name(asset_index) {
	if (asset_index == "") return "";
	
	var friendly_name = ds_map_find_value(sound_import_asset_index_names, asset_index);
	if (is_undefined(friendly_name)) {
		friendly_name = ds_map_find_value(sound_import_asset_index_names, "_") + " (" + asset_index + ")";
	}
	
	return friendly_name;
}

function get_assets_dir() {
	var assets_dir = mc_install_path;
	
	if (string_char_at(assets_dir, string_length(assets_dir)) != condstr(os_type = os_windows, "\\", "/")) {
		assets_dir = assets_dir + condstr(os_type = os_windows, "\\", "/")
	}
	
	assets_dir = assets_dir + "assets" + condstr(os_type = os_windows, "\\", "/");
	return assets_dir;
}

function find_asset_indexes() {

	if (!directory_exists(mc_install_path)) {
		if (language != 1) message("No Minecraft installation was found\nat the selected location!", "Sound import");
		else message("在所选位置未找到有Minecraft安装！", "音效导入");
		return [];
	}
	
	// Search for .json files in the assets/ folder
	var assets_dir = get_assets_dir();
	log("Looking for index files at " + assets_dir);
	var asset_indexes = [];
	var file_name = file_find_first(assets_dir + "indexes" + condstr(os_type = os_windows, "\\", "/") + "*.json", 0);
	while (file_name != "") {
	    array_push(asset_indexes, string_replace(file_name, ".json", ""));
		log(file_name);
	    file_name = file_find_next();
	}
	file_find_close();
	
	array_sort(asset_indexes, function(elm1, elm2) {
		var index1 = ds_list_find_index(sound_import_asset_index_names_sort, elm1)
		var index2 = ds_list_find_index(sound_import_asset_index_names_sort, elm2)
		if (index1 == -1) return -1; // Sort newer Minecraft versions at the top
		if (index2 == -1) return 1;
		return index1 < index2;
	});
	
	return asset_indexes;
}


function update_asset_index_menu() {
	sound_import_asset_indexes = find_asset_indexes();
	log(sound_import_asset_indexes);
	
	if (array_length(sound_import_asset_indexes) == 0) {
		sound_import_asset_index_select = 0;
		sound_import_selected_asset_index = "";
		sound_import_asset_index_count = 0;
	} else {
		if (sound_import_asset_index_select > array_length(sound_import_asset_indexes) - 1) {
			sound_import_asset_index_select = 0;
		}
		sound_import_selected_asset_index = sound_import_asset_indexes[sound_import_asset_index_select];
	}	

	// Create menu
	sound_import_menu_str = "";
	for (var i = 0; i < array_length(sound_import_asset_indexes); i++) {
		sound_import_menu_str += check(sound_import_asset_index_select == i);
		sound_import_menu_str += get_asset_index_friendly_name(sound_import_asset_indexes[i]) + "|";
	}
	sound_import_menu_str = string_delete(sound_import_menu_str, string_length(sound_import_menu_str), 1)
	
	// Load selected asset index
	load_asset_index(false);
}


function load_asset_index(copy = false) {
	// Loads an asset index.
	
	// Open and parse asset index
	var assets_dir = get_assets_dir();
	var selected_asset_list = sound_import_selected_asset_index;
	if (selected_asset_list == "") return;
	var asset_index_path = assets_dir + "indexes" + condstr(os_type = os_windows, "\\", "/") + selected_asset_list + ".json";
	if (!file_exists(asset_index_path)) {
		if (language != 1) message("The file for the specified asset index could not be found!", "Note Block Studio")
		else message("未找到该索引所指向的文件！", "Note Block Studio")
		return;
	}
	var file_buffer = buffer_load(asset_index_path);
	var content = buffer_read(file_buffer, buffer_string);
	buffer_delete(file_buffer);
	
	// Get objects in asset index
	var json = json_parse(content);
	var objects = json[$ "objects"];
	
	var count = 0;
	var keys = variable_struct_get_names(objects);
	
	var sounds_mc_subdir = sounds_directory + "minecraft";
	
	if (copy && directory_exists_lib(sounds_mc_subdir)) {
		var isreplace = 0
		if (language != 1) isreplace = message_yesnocancel("An existing folder with imported Minecraft sounds has been found in your Sounds folder. Would you like to replace it?", "Warning")
		else isreplace = message_yesnocancel("在您的Sounds文件夹中发现已经存在一个包含已导入Minecraft音效的文件夹，您想要覆盖它吗？", "警告")
		if (!isreplace) {
			return;
		} else {
			directory_delete_lib(sounds_mc_subdir);
		}
		sound_import_status = 1;
	}
	
	for (var i = array_length(keys) - 1; i >= 0; --i) {
	    var key = keys[i];
		var value = objects[$ key];
	    
		if (string_count("minecraft/sounds/", key) == 0) {
			continue;
		}
		
		// Skip music and records
		if (string_count("music/", key) > 0 || string_count("records/", key) > 0) {
			continue;
		}
		
		var hash = value[$ "hash"];
		//show_debug_message(key + " " + hash);

		if (copy) {
			var src = assets_dir + "objects" + condstr(os_type = os_windows, "\\", "/") + string_copy(hash, 1, 2) + condstr(os_type = os_windows, "\\", "/") + hash;
			var dst = sounds_mc_subdir + string_replace(key, "minecraft/sounds/", condstr(os_type = os_windows, "\\", "/"));
		
			if (!file_exists_lib(src)) {
				continue;
			}
			if (!directory_exists_lib(filename_dir(dst))) {
				directory_create_lib(filename_dir(dst))
			}
			files_copy_lib(src, dst);
		}
		count++;
		
		//show_debug_message(src);
		//show_debug_message(dst);
	}
	
	if (copy) sound_import_status = 2;
	else sound_import_status = 0;
	
	sound_import_asset_index_count = count;
}


