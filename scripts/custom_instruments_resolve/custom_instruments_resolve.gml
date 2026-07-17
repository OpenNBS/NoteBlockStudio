function custom_instruments_resolve(source_instruments) {
	// Reuses matching custom instruments and adds only missing definitions.
	// Names are ignored for sounds, but event names must remain distinct.
	var missing_instruments = []

	for (var i = 0; i < array_length(source_instruments); i++) {
		var source_ins = source_instruments[i]
		var source_path = string_replace_all(source_ins.filename, "\\", "/")
		var found = false

		for (var target_index = first_custom_index; target_index < ds_list_size(songs[song].instrument_list); target_index++) {
			var target_ins = songs[song].instrument_list[| target_index]
			var target_path = string_replace_all(target_ins.filename, "\\", "/")
			var target_names_match = (!custom_instrument_is_event(source_ins.name) && !custom_instrument_is_event(target_ins.name)) || target_ins.name == source_ins.name
			if (target_path == source_path && target_ins.key == source_ins.key && target_ins.press == source_ins.press && target_names_match) {
				found = true
				break
			}
		}

		if (!found) {
			var already_missing = false
			for (var m = 0; m < array_length(missing_instruments); m++) {
				var missing_ins = missing_instruments[m]
				var missing_path = string_replace_all(missing_ins.filename, "\\", "/")
				var missing_names_match = (!custom_instrument_is_event(source_ins.name) && !custom_instrument_is_event(missing_ins.name)) || missing_ins.name == source_ins.name
				if (missing_path == source_path && missing_ins.key == source_ins.key && missing_ins.press == source_ins.press && missing_names_match) {
					already_missing = true
					break
				}
			}

			if (!already_missing) array_push(missing_instruments, source_ins)
		}
	}

	var available_instruments = max(0, 240 - songs[song].user_instruments)
	if (array_length(missing_instruments) > available_instruments) {
		return {
			ok: false,
			instrument_map: -1,
			added_count: 0,
			needed_count: array_length(missing_instruments),
			available_count: available_instruments
		}
	}

	for (var m = 0; m < array_length(missing_instruments); m++) {
		var missing_ins = missing_instruments[m]
		var new_ins = new_instrument(missing_ins.name, string_replace_all(missing_ins.filename, "\\", "/"), true, missing_ins.press, missing_ins.key)
		with (new_ins) instrument_load()
		ds_list_add(songs[song].instrument_list, new_ins)
	}

	var instrument_map = ds_map_create()
	for (var i = 0; i < array_length(source_instruments); i++) {
		var source_ins = source_instruments[i]
		var source_path = string_replace_all(source_ins.filename, "\\", "/")
		for (var target_index = first_custom_index; target_index < ds_list_size(songs[song].instrument_list); target_index++) {
			var target_ins = songs[song].instrument_list[| target_index]
			var target_path = string_replace_all(target_ins.filename, "\\", "/")
			var mapped_names_match = (!custom_instrument_is_event(source_ins.name) && !custom_instrument_is_event(target_ins.name)) || target_ins.name == source_ins.name
			if (target_path == source_path && target_ins.key == source_ins.key && target_ins.press == source_ins.press && mapped_names_match) {
				ds_map_add(instrument_map, source_ins.source_index, target_index)
				break
			}
		}
	}

	if (array_length(missing_instruments) > 0) songs[song].changed = true
	return {
		ok: true,
		instrument_map: instrument_map,
		added_count: array_length(missing_instruments),
		needed_count: array_length(missing_instruments),
		available_count: available_instruments
	}
}

function custom_instrument_is_event(instrument_name) {
	// Keep this in sync with the event dispatch in control_step.
	return instrument_name == "Tempo Changer"
		|| instrument_name == "Toggle Rainbow"
		|| instrument_name == "Sound Stopper"
		|| instrument_name == "Show Save Popup"
		|| string_count(string_lower("Change Color to #"), string_lower(instrument_name)) == 1
		|| instrument_name == "Toggle Background Accent"
}
