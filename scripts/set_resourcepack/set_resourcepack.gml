function set_resourcepack(pack_name){
	pack_obj = -1
	var dir_no_path = ""
	var using_directory = sounds_directory
	var sounds_json = undefined
	var catalog_sounds_json = undefined
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
	if (pack_name != "Vanilla") {
		catalog_sounds_json = resourcepack_load_sounds_json(pack_root, "minecraft")
		if (resourcepack_sounds_json) sounds_json = catalog_sounds_json
	}
	obj_controller.minecraft_export_pack_root = pack_root
	obj_controller.minecraft_export_sounds_json = catalog_sounds_json
	if (is_struct(catalog_sounds_json)) minecraft_export_set_sound_catalog(catalog_sounds_json, "minecraft", "Resource pack: " + pack_name)
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
	if (!is_undefined(catalog_sounds_json)) resourcepack_auto_map_custom_sounds(pack_root, catalog_sounds_json)
	//for (var i = 0; i < array_length(songs); i++) {
	//	for (var j = 0; j < 16; j++) {
	//		ds_list_replace(songs[i].instrument_list, j, original_instruments[j])
	//	}
	//	songs[i].instrument = songs[i].instrument_list[| 0]
	//}
	current_resource = pack_name
}

function minecraft_export_set_sound_catalog(sounds_json, sound_namespace, source_label) {
	if (!is_struct(sounds_json)) return false;
	var raw_events = variable_struct_get_names(sounds_json)
	var events = []
	for (var i = 0; i < array_length(raw_events); i++) {
		var event_name = raw_events[i]
		if (string_pos(":", event_name) <= 0) event_name = sound_namespace + ":" + event_name
		event_name = minecraft_export_resource_location(event_name)
		if (!minecraft_export_array_contains(events, event_name)) array_push(events, event_name)
	}
	array_sort(events, function(first, second) {
		return (first > second) - (first < second);
	})
	obj_controller.minecraft_export_catalog_events = events
	obj_controller.minecraft_export_catalog_source = source_label
	obj_controller.minecraft_export_catalog_menu_events = []
	obj_controller.minecraft_export_catalog_filter_cache_key = ""
	obj_controller.minecraft_export_catalog_filter_cache_result = undefined
	return true;
}

function minecraft_export_catalog_namespace_from_path(path) {
	var normalized = string_replace_all(path, "\\", "/")
	var lowered = string_lower(normalized)
	var marker = "/assets/"
	var marker_position = string_pos(marker, lowered)
	if (marker_position <= 0 && string_pos("assets/", lowered) == 1) { marker = "assets/"; marker_position = 1 }
	if (marker_position > 0) {
		var remainder = string_copy(normalized, marker_position + string_length(marker), string_length(normalized))
		var separator = string_pos("/", remainder)
		if (separator > 1) return string_copy(remainder, 1, separator - 1);
	}
	return "minecraft";
}

function minecraft_export_asset_root_from_index(path) {
	var normalized = string_replace_all(path, "\\", "/")
	var lowered = string_lower(normalized)
	var marker_position = string_pos("/indexes/", lowered)
	if (marker_position > 0) return string_copy(normalized, 1, marker_position);
	if (string_pos("indexes/", lowered) == 1) return "";
	var parent = filename_dir(path)
	while (string_length(parent) > 0 && (string_char_at(parent, string_length(parent)) == "/" || string_char_at(parent, string_length(parent)) == "\\")) parent = string_delete(parent, string_length(parent), 1)
	var assets_root = filename_dir(parent)
	if (string_length(assets_root) > 0 && string_char_at(assets_root, string_length(assets_root)) != condstr(os_type = os_windows, "\\", "/")) assets_root += condstr(os_type = os_windows, "\\", "/")
	return assets_root;
}

function minecraft_export_request_asset_root_access(suggested_root) {
	if (os_type != os_macosx) return "";
	widget_set_caption(condstr(obj_controller.language != 1, "Select the Minecraft assets folder", "选择 Minecraft assets 文件夹"))
	var selected_root = string(get_directory(suggested_root))
	selected_root = string_replace_all(selected_root, "Select the Minecraft assets folder", "")
	selected_root = string_replace_all(selected_root, "选择 Minecraft assets 文件夹", "")
	if (selected_root == "") return "";
	if (string_char_at(selected_root, string_length(selected_root)) != "/") selected_root += "/"
	macos_bookmark_store(selected_root, selected_root, 0)
	macos_bookmark_begin(selected_root)
	if (directory_exists_lib(selected_root + "objects")) return selected_root;
	if (directory_exists_lib(selected_root + "assets/objects")) {
		var resolved_assets_root = selected_root + "assets/"
		macos_bookmark_store(resolved_assets_root, resolved_assets_root, 0)
		macos_bookmark_begin(resolved_assets_root)
		return resolved_assets_root;
	}
	return "";
}

function minecraft_export_restore_sound_catalog() {
	var saved_catalog_path = obj_controller.minecraft_export_catalog_path
	if (saved_catalog_path == "") return false
	if (os_type = os_macosx) {
		macos_bookmark_begin(saved_catalog_path)
		if (obj_controller.minecraft_export_catalog_access_root != "") macos_bookmark_begin(obj_controller.minecraft_export_catalog_access_root)
	}
	return minecraft_export_load_sound_catalog(saved_catalog_path, false)
}

function minecraft_export_load_sound_catalog(catalog_path = "", display_load_error = true) {
	var selected_interactively = (catalog_path == "")
	if (selected_interactively) {
		catalog_path = string(get_open_filename_ext(
			"Minecraft sound catalogs (*.json)|*.json",
			"", "", condstr(obj_controller.language != 1, "Load sounds.json or asset index", "加载 sounds.json 或资产索引")
		))
	}
	if (catalog_path == "") return false;
	if (os_type = os_macosx) {
		if (selected_interactively) macos_bookmark_store(catalog_path, catalog_path, 0)
		macos_bookmark_begin(catalog_path)
		if (obj_controller.minecraft_export_catalog_path == catalog_path && obj_controller.minecraft_export_catalog_access_root != "") {
			macos_bookmark_begin(obj_controller.minecraft_export_catalog_access_root)
		}
	}
	if (!file_exists_lib(catalog_path)) return false;
	try {
		var parsed_json = json_parse(load_text(catalog_path))
		if (!is_struct(parsed_json)) throw("The selected JSON is not an object.")
		var sounds_json = parsed_json
		var sound_namespace = minecraft_export_catalog_namespace_from_path(catalog_path)
		var source_label = filename_name(catalog_path)
		var catalog_access_root = ""
		if (variable_struct_exists(parsed_json, "objects")) {
			var objects = parsed_json[$ "objects"]
			if (!is_struct(objects) || !variable_struct_exists(objects, "minecraft/sounds.json")) throw("The asset index does not contain minecraft/sounds.json.")
			var record = objects[$ "minecraft/sounds.json"]
			if (!is_struct(record) || !variable_struct_exists(record, "hash") || !is_string(record[$ "hash"])) throw("The asset index has no valid sounds.json hash.")
			var object_hash = record[$ "hash"]
			if (string_length(object_hash) < 2) throw("The sounds.json asset hash is invalid.")
			var assets_directory = minecraft_export_asset_root_from_index(catalog_path)
			if (obj_controller.minecraft_export_catalog_path == catalog_path && obj_controller.minecraft_export_catalog_access_root != "") {
				catalog_access_root = obj_controller.minecraft_export_catalog_access_root
			}
			var object_path = assets_directory + "objects" + condstr(os_type = os_windows, "\\", "/") + string_copy(object_hash, 1, 2) + condstr(os_type = os_windows, "\\", "/") + object_hash
			if (!file_exists_lib(object_path) && os_type = os_macosx) {
				var granted_assets_directory = minecraft_export_request_asset_root_access(assets_directory)
				if (granted_assets_directory != "") {
					assets_directory = granted_assets_directory
					catalog_access_root = granted_assets_directory
					object_path = assets_directory + "objects/" + string_copy(object_hash, 1, 2) + "/" + object_hash
				}
			}
			if (!file_exists_lib(object_path)) throw("The hashed sounds.json object could not be found at " + object_path)
			sounds_json = json_parse(load_text(object_path))
			sound_namespace = "minecraft"
			source_label = filename_name(catalog_path) + " asset index"
		}
		if (!minecraft_export_set_sound_catalog(sounds_json, sound_namespace, source_label)) throw("No sound-event catalog could be loaded.")
		obj_controller.minecraft_export_sounds_json = sounds_json
		obj_controller.minecraft_export_pack_root = ""
		obj_controller.minecraft_export_catalog_path = catalog_path
		obj_controller.minecraft_export_catalog_access_root = catalog_access_root
		resourcepack_auto_map_custom_sounds("", sounds_json)
		if (selected_interactively) save_settings()
		return true;
	} catch (error) {
		if (display_load_error) message(condstr(obj_controller.language != 1, "Could not load the sound catalog:\n", "无法加载声音目录：\n") + string(error), condstr(obj_controller.language != 1, "Minecraft sound catalog", "Minecraft 声音目录"))
	}
	return false;
}

function minecraft_export_catalog_match_text(value) {
	var result = string_lower(string_replace_all(string(value), "\\", "/"))
	if (string_pos("minecraft:", result) == 1) result = string_delete(result, 1, 10)
	var asset_marker = "assets/minecraft/sounds/"
	var asset_marker_position = string_pos(asset_marker, result)
	if (asset_marker_position > 0) result = string_delete(result, 1, asset_marker_position + string_length(asset_marker) - 1)
	if (string_pos("minecraft/", result) == 1) result = string_delete(result, 1, 10)
	if (string_pos("custom/", result) == 1) result = string_delete(result, 1, 7)
	if (string_lower(filename_ext(result)) == ".ogg") result = string_delete(result, string_length(result) - 3, 4)
	result = string_replace_all(result, "/", ".")
	result = string_replace_all(result, "_", ".")
	result = string_replace_all(result, "-", ".")
	result = string_replace_all(result, " ", ".")
	return result
}

function minecraft_export_catalog_relevance(event_name, hint) {
	var candidate = minecraft_export_catalog_match_text(event_name)
	var wanted = minecraft_export_catalog_match_text(hint)
	if (wanted == "") return 0
	if (candidate == wanted) return 100000
	if (string_pos(wanted, candidate) > 0) return 50000 + string_length(wanted)
	if (string_pos(candidate, wanted) > 0) return 40000 + string_length(candidate)
	var relevance_score = 0
	var useful_tokens = 0
	var strongest_token = ""
	var remaining = wanted + "."
	while (remaining != "") {
		var separator = string_pos(".", remaining)
		var token = string_copy(remaining, 1, separator - 1)
		remaining = string_delete(remaining, 1, separator)
		while (string_length(token) > 3 && string_pos(string_char_at(token, string_length(token)), "0123456789") > 0) token = string_delete(token, string_length(token), 1)
		if (string_length(token) < 3 || token == "minecraft" || token == "custom" || token == "sounds" || token == "entity" || token == "block") continue
		useful_tokens++
		if (string_length(token) > string_length(strongest_token)) strongest_token = token
		if (string_pos(token, candidate) > 0) relevance_score += string_length(token) * string_length(token)
	}
	if (useful_tokens == 0) return 0
	// Keep suggestions centered on the instrument's most distinctive word;
	// otherwise generic pieces such as "far" or "blast" pollute the menu.
	if (strongest_token != "" && string_pos(strongest_token, candidate) <= 0) return 0
	return relevance_score
}

function minecraft_export_filter_sound_catalog(query, maximum_results, hints = []) {
	var active_hints = []
	if (string(query) != "") array_push(active_hints, query)
	else for (var i = 0; i < array_length(hints); i++) if (string(hints[i]) != "") array_push(active_hints, hints[i])
	var filter_cache_key = string(maximum_results) + "|" + string(query)
	for (var i = 0; i < array_length(active_hints); i++) filter_cache_key += "|" + string(active_hints[i])
	if (obj_controller.minecraft_export_catalog_filter_cache_key == filter_cache_key && !is_undefined(obj_controller.minecraft_export_catalog_filter_cache_result)) {
		return obj_controller.minecraft_export_catalog_filter_cache_result
	}
	var ranked = []
	for (var i = 0; i < array_length(obj_controller.minecraft_export_catalog_events); i++) {
		var event_name = obj_controller.minecraft_export_catalog_events[i]
		var relevance_score = 0
		for (var h = 0; h < array_length(active_hints); h++) relevance_score = max(relevance_score, minecraft_export_catalog_relevance(event_name, active_hints[h]))
		if (relevance_score > 0) array_push(ranked, { event: event_name, relevance: relevance_score })
	}
	array_sort(ranked, function(first, second) {
		if (first.relevance != second.relevance) return second.relevance - first.relevance
		return (first.event > second.event) - (first.event < second.event)
	})
	var matches = []
	for (var i = 0; i < min(maximum_results, array_length(ranked)); i++) array_push(matches, ranked[i].event)
	var filter_result = { events: matches, total: array_length(ranked) }
	obj_controller.minecraft_export_catalog_filter_cache_key = filter_cache_key
	obj_controller.minecraft_export_catalog_filter_cache_result = filter_result
	return filter_result
}

function resourcepack_auto_map_custom_sounds(pack_root, sounds_json) {
	// Convert minecraft/... custom asset paths to their unique sounds.json event.
	// Never mistake the asset path itself for a /playsound resource location.
	if (!is_struct(sounds_json)) return;
	var mapping_targets = []
	var wanted_assets = {}
	for (var song_index = 0; song_index < array_length(obj_controller.songs); song_index++) {
		var song_instance = obj_controller.songs[song_index]
		for (var instrument_index = obj_controller.first_custom_index; instrument_index < ds_list_size(song_instance.instrument_list); instrument_index++) {
			var instrument = song_instance.instrument_list[| instrument_index]
			if (minecraft_export_is_event(instrument)) continue
			if (variable_instance_exists(instrument, "minecraft_sound_manual") && instrument.minecraft_sound_manual) continue
			var asset = string_lower(string_replace_all(instrument.filename, "\\", "/"))
			while (string_pos("../", asset) == 1) asset = string_delete(asset, 1, 3)
			if (string_pos("minecraft/", asset) != 1) continue
			asset = "assets/minecraft/sounds/" + string_copy(asset, 11, string_length(asset))
			if (string_lower(filename_ext(asset)) != ".ogg") asset += ".ogg"
			array_push(mapping_targets, { instrument_ref: instrument, asset_path: asset })
			variable_struct_set(wanted_assets, asset, true)
		}
	}
	if (array_length(mapping_targets) == 0) return;

	// Resolve every event once, then look up every instrument in O(1). The old
	// instrument x event nested scan made large vanilla asset indexes stall.
	var asset_matches = {}
	var event_names = variable_struct_get_names(sounds_json)
	for (var event_index = 0; event_index < array_length(event_names); event_index++) {
		var event_name = event_names[event_index]
		var full_event_name = condstr(string_pos(":", event_name) > 0, event_name, "minecraft:" + event_name)
		var event_assets = resourcepack_event_asset_list(pack_root, sounds_json, event_name, "minecraft", 0, {})
		for (var asset_index = 0; asset_index < array_length(event_assets); asset_index++) {
			var event_asset = event_assets[asset_index]
			if (!variable_struct_exists(wanted_assets, event_asset)) continue
			if (!variable_struct_exists(asset_matches, event_asset)) variable_struct_set(asset_matches, event_asset, full_event_name)
			else if (variable_struct_get(asset_matches, event_asset) != full_event_name) variable_struct_set(asset_matches, event_asset, "")
		}
	}
	for (var target_index = 0; target_index < array_length(mapping_targets); target_index++) {
		var target = mapping_targets[target_index]
		if (!variable_struct_exists(asset_matches, target.asset_path)) continue
		var matched_event = variable_struct_get(asset_matches, target.asset_path)
		if (matched_event == "") continue
		target.instrument_ref.minecraft_sound = matched_event
		target.instrument_ref.minecraft_sound_manual = false
	}
	obj_controller.sch_command_plan = undefined
}

function resourcepack_event_asset_list(pack_root, sounds_json, sound_event, sound_namespace, recursion_depth, visited_events) {
	var result_assets = []
	if (recursion_depth > 8 || !is_struct(sounds_json)) return result_assets
	var event_namespace = sound_namespace
	var event_name = sound_event
	var namespace_separator = string_pos(":", event_name)
	if (namespace_separator > 0) {
		event_namespace = string_copy(event_name, 1, namespace_separator - 1)
		event_name = string_copy(event_name, namespace_separator + 1, string_length(event_name))
		if (event_namespace != sound_namespace) {
			sounds_json = resourcepack_load_sounds_json(pack_root, event_namespace)
			if (!is_struct(sounds_json)) return result_assets
		}
	}
	var visited_key = event_namespace + ":" + event_name
	if (variable_struct_exists(visited_events, visited_key)) return result_assets
	variable_struct_set(visited_events, visited_key, true)
	if (!variable_struct_exists(sounds_json, event_name)) return result_assets
	var definition = sounds_json[$ event_name]
	if (!is_struct(definition) || !variable_struct_exists(definition, "sounds")) return result_assets
	var entries = definition[$ "sounds"]
	if (!is_array(entries)) entries = [entries]
	for (var i = 0; i < array_length(entries); i++) {
		var entry = entries[i]
		var reference = ""
		var reference_type = "file"
		if (is_string(entry)) reference = entry
		else if (is_struct(entry) && variable_struct_exists(entry, "name") && is_string(entry[$ "name"])) {
			reference = entry[$ "name"]
			if (variable_struct_exists(entry, "type") && is_string(entry[$ "type"])) reference_type = string_lower(entry[$ "type"])
		}
		if (reference == "") continue
		if (reference_type == "event") {
			var referenced_assets = resourcepack_event_asset_list(pack_root, sounds_json, reference, event_namespace, recursion_depth + 1, visited_events)
			for (var asset_index = 0; asset_index < array_length(referenced_assets); asset_index++) {
				if (!minecraft_export_array_contains(result_assets, referenced_assets[asset_index])) array_push(result_assets, referenced_assets[asset_index])
			}
		} else {
			var resolved_asset_path = string_lower(string_replace_all(resourcepack_sound_asset_path(reference, event_namespace), "\\", "/"))
			if (resolved_asset_path != "" && !minecraft_export_array_contains(result_assets, resolved_asset_path)) array_push(result_assets, resolved_asset_path)
		}
	}
	return result_assets
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

function resourcepack_resolve_sound(pack_root, sounds_json, sound_event, sound_namespace, recursion_depth) {
	if (recursion_depth > 8 || !is_struct(sounds_json)) return undefined

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
			resolved_sound = resourcepack_resolve_sound(pack_root, sounds_json, sound_reference, event_namespace, recursion_depth + 1)
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
