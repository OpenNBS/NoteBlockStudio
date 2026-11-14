function open_song_zip(filename, replace = false) {

	var dst_path = temp_directory_included + "nbs" + condstr(os_type = os_windows, "\\", "/");
	
	if (directory_exists_lib(dst_path)) {
		directory_delete_lib(dst_path);
	}

	var song_path = dst_path + "song.nbs";
	var metadata_path = dst_path + "song.metadata.json";
	// Some runtimes leave nonempty extraction folders behind. These files
	// must come from this archive, especially when opening a legacy ZIP.
	var song_files = [song_path, metadata_path]
	for (var i = 0; i < array_length(song_files); i++) {
		if (file_exists_lib(song_files[i])) files_delete_lib(song_files[i])
		if (file_exists_lib(song_files[i])) throw(condstr(language != 1,
			"Could not clear the previous song ZIP's temporary files.",
			"无法清除上一个歌曲 ZIP 的临时文件。"))
	}

	var output = zip_unzip(filename, dst_path);
	if (output < 0) {
		throw("This doesn't appear to be a valid ZIP file!")
	}
	
	var sounds_path = dst_path + "sounds" + condstr(os_type = os_windows, "\\", "/");
	
	if (!file_exists_lib(song_path)) {
		throw("This is not a valid zipped song file!");
	}
	
	return open_song_nbs(song_path, sounds_path, 0, replace, file_exists_lib(metadata_path) ? metadata_path : "");
}

function song_zip_restore_metadata(parsed_song, source, metadata) {
	// Validate before any tabs are created/replaced. The hash binds positional
	// mappings to these exact NBS bytes, including duplicate instrument names.
	if (!is_struct(metadata)
		|| !variable_struct_exists(metadata, "schema_version") || metadata.schema_version != 1
		|| !variable_struct_exists(metadata, "nbs_sha1") || !is_string(metadata.nbs_sha1)
		|| metadata.nbs_sha1 != buffer_sha1(source, 0, buffer_get_size(source))
		|| !variable_struct_exists(metadata, "minecraft_sound_mappings") || !is_array(metadata.minecraft_sound_mappings)) {
		throw("Invalid or mismatched song ZIP metadata")
	}
	var mappings = metadata.minecraft_sound_mappings
	if (array_length(mappings) != array_length(parsed_song.instruments)) throw("Invalid song ZIP instrument count")
	for (var i = 0; i < array_length(mappings); i++) {
		var mapping = mappings[i]
		if (!is_struct(mapping)
			|| !variable_struct_exists(mapping, "minecraft_sound") || !is_string(mapping.minecraft_sound)
			|| !variable_struct_exists(mapping, "minecraft_sound_manual")) {
			throw("Invalid song ZIP sound mapping")
		}
		// LTS json_parse can return JSON booleans as numeric 0/1.
		var manual = mapping.minecraft_sound_manual
		if ((!is_bool(manual) && !is_real(manual)) || (manual != 0 && manual != 1)) throw("Invalid song ZIP mapping flag")
		var instrument = parsed_song.instruments[i]
		// Reserved event instruments never get a Minecraft sound-event mapping.
		if (custom_instrument_is_event(instrument.name)) continue
		instrument.minecraft_sound = mapping.minecraft_sound
		instrument.minecraft_sound_manual = manual == true
	}
}
