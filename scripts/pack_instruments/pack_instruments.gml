function pack_instruments() {
	var title = condstr(language != 1, "Pack instruments", "导出音色")
	var fn = string(get_save_filename_ext("ZIP archive (*.zip)|*.zip",
		condstr(songs[song].filename == "", "", filename_change_ext(songs[song].filename, "") + " - ") + "Instruments.zip",
		"", condstr(language != 1, "Pack instruments to ZIP file", "导出音色至 ZIP 文件")))
	if (fn == "") return false
	fn = enforce_extension(fn, ".zip")

	// Select only the current song's sound files. The shared temp folder may
	// still contain song ZIPs, metadata, and extracted audio from earlier work.
	var filenames = []
	for (var i = first_custom_index; i < ds_list_size(songs[song].instrument_list); i++) {
		var ins = songs[song].instrument_list[| i]
		if (ins.filename == "") continue
		var sound_filename = string_replace_all(ins.filename, "\\", "/")
		if (!file_exists_lib(sounds_directory + sound_filename)) continue
		array_push(filenames, sound_filename)
	}

	var archive_path = game_save_id + "tempinstruments.zip"
	var archive_suffix = 1
	while (file_exists_lib(archive_path) || directory_exists_lib(archive_path)
		|| string_lower(filename_name(archive_path)) == string_lower(filename_name(fn))) {
		archive_path = game_save_id + "tempinstruments-" + string(archive_suffix++) + ".zip"
	}
	var zip_buffer = -1
	var export_succeeded = false
	var count = 0
	try {
		if (array_length(filenames) == 0) throw("No sound files are available to export")
		python_initialize_for_exports()
		// Create a new archive from an explicit list, then replace the chosen
		// output through the same verified writer used by other exports.
		count = python_call_function("datapack_export", "create_sound_zip", [sounds_directory, archive_path, filenames], {})
		if (!is_real(count) || count <= 0)
			throw("Could not create the sound archive")
		zip_buffer = buffer_load(archive_path)
		if (zip_buffer < 0) throw("Could not read the sound archive")
		buffer_seek(zip_buffer, buffer_seek_start, buffer_get_size(zip_buffer))
		export_succeeded = buffer_export(zip_buffer, fn)
		if (!export_succeeded) throw("Could not write the sound archive to its destination")
	} catch (error) {
		show_debug_message("Sound export failed: " + string(error))
		export_succeeded = false
	}
	if (zip_buffer >= 0) buffer_delete(zip_buffer)

	// Never delete the shared song/extraction directory. A late cleanup error
	// must not turn a successfully published archive into a reported failure.
	try {
		if (file_exists_lib(archive_path)) files_delete_lib(archive_path)
	} catch (error) {
		show_debug_message("Could not remove the temporary sound archive: " + string(error))
	}
	if (!export_succeeded) {
		message(condstr(language != 1,
			"The sounds could not be exported.\n\nCheck that the sound files are available and the destination is writable, then try again.",
			"无法导出声音文件。\n\n请确认声音文件可用且保存位置可写，然后重试。"), title)
		return false
	}
	message(condstr(language != 1,
		string(count) + " sound file" + condstr(count == 1, " was", "s were") + " saved!",
		"已导出 " + string(count) + " 个声音文件！"), title)
	return true
}
