function pattern_import() {
	// pattern_import([filename, at_mouse_pos])
	var fn = ""
	var at_mouse_pos = false
	if (argument_count > 0) fn = argument[0]
	if (argument_count > 1) at_mouse_pos = argument[1]

	var loadx = 0
	var loady = 0
	if (at_mouse_pos) {
		if (selbx > -1 && selby > -1) {
			loadx = selbx
			loady = selby
		} else {
			loadx = songs[song].starta
			loady = songs[song].startb
		}
	}

	if (songs[song].selected != 0) return 0
	if (fn == "") {
		if (!directory_exists_lib(patternfolder)) patternfolder = pattern_directory
		fn = string(get_open_filename_ext("Note Block Pattern (*.nbp)|*.nbp", "", patternfolder, condstr(language != 1, "Load pattern", "打开分段")))
	}
	if (fn == "" || !file_exists_lib(fn)) return 0

	var file_ext = string_lower(filename_ext(fn))
	if (file_ext != ".nbp") {
		message(condstr(language != 1, "Error: This file is not a pattern.", "错误：该文件不是分段文件。"), condstr(language != 1, "Error", "错误"))
		return 0
	}

	buffer = buffer_import(fn)
	if (buffer < 0) {
		message(condstr(language != 1, "Error: This pattern could not be opened.", "错误：无法打开此分段文件。"), condstr(language != 1, "Error", "错误"))
		return 0
	}

	song_pat_version = buffer_read_byte()
	if (song_pat_version > pat_version) {
		buffer_delete(buffer)
		message(condstr(language != 1, "This pattern was created in a newer version of Note Block Studio and cannot be opened safely.", "此分段文件由新版 Note Block Studio 创建，无法安全打开。"), condstr(language != 1, "Error", "错误"))
		return -1
	}
	if (song_pat_version < pat_version && show_oldwarning) {
		message(condstr(language != 1, "Warning: You are opening an older NBP file. Saving this file will make it incompatible with older Note Block Studio versions.", "警告：你正在打开旧版的 NBP 文件。保存此文件会使其与旧版 Note Block Studio 不兼容。"), condstr(language != 1, "Warning", "警告"))
	}

	var pat_length = buffer_read_short()
	var pat_height = buffer_read_short()
	var pattern_selection_l = buffer_read_short()
	var selection_code = buffer_read_string()
	var pattern_colfirst = []
	var pattern_collast = []
	for (var a = 0; a < pattern_selection_l; a++) {
		array_push(pattern_colfirst, buffer_read_byte_signed())
		array_push(pattern_collast, buffer_read_byte_signed())
	}

	var pattern_instruments = []
	if (song_pat_version >= 2) {
		var instrument_count = buffer_read_byte()
		for (var i = 0; i < instrument_count; i++) {
			// Buffer reads must stay in file order; struct field evaluation order is not guaranteed.
			var pattern_source_index = buffer_read_short()
			var pattern_instrument_name = buffer_read_string()
			var pattern_instrument_filename = string_replace_all(buffer_read_string(), "\\", "/")
			var pattern_instrument_key = buffer_read_byte()
			var pattern_instrument_press = buffer_read_byte()
			array_push(pattern_instruments, {
				source_index: pattern_source_index,
				name: pattern_instrument_name,
				filename: pattern_instrument_filename,
				key: pattern_instrument_key,
				press: pattern_instrument_press
			})
		}
	}
	buffer_delete(buffer)

	var instrument_map = -1
	var imported_instrument_count = 0
	if (song_pat_version >= 2) {
		var resolve_result = custom_instruments_resolve(pattern_instruments)
		if (!resolve_result.ok) {
			message(condstr(language != 1, "This pattern needs " + string(resolve_result.needed_count) + " new custom instruments, but this song only has room for " + string(resolve_result.available_count) + ".\n\nNo notes were imported.", "此分段需要添加 " + string(resolve_result.needed_count) + " 个自定义音色，但当前歌曲只能再添加 " + string(resolve_result.available_count) + " 个。\n\n未导入任何音符。"), condstr(language != 1, "Import Pattern", "导入分段"))
			return -1
		}
		instrument_map = resolve_result.instrument_map
		imported_instrument_count = resolve_result.added_count
	} else if (check_custom_instrument(selection_code) != 0) {
		message(condstr(language != 1, "This older pattern refers to custom instruments that are not loaded in this song.", "此旧版分段文件使用了当前歌曲中未加载的自定义音色。"), condstr(language != 1, "Error", "错误"))
		return -1
	}

	selection_copied = selection_code
	selection_extend_length(pat_length)
	selection_extend_height(pat_height)
	songs[song].selection_l = pattern_selection_l
	for (var a = 0; a < pattern_selection_l; a++) {
		songs[song].selection_colfirst[a] = pattern_colfirst[a]
		songs[song].selection_collast[a] = pattern_collast[a]
	}
	copied_arraylength = songs[song].selection_arraylength
	copied_arrayheight = songs[song].selection_arrayheight

	selection_load(loadx, loady, selection_copied, false, instrument_map)
	if (instrument_map != -1) ds_map_destroy(instrument_map)

	// Keep the imported pattern reusable in this song or another tab.
	selection_copied = songs[song].selection_code
	clipboard = selection_copied
	copied_from_song = songs[song]
	copied_context_code = selection_copied
	copied_note_count = songs[song].selected
	copied_source_name = filename_name(fn)
	copied_custom_instruments = selection_get_custom_instruments()
	set_msg(condstr(language != 1, "Imported " + string(copied_note_count) + " notes and " + string(imported_instrument_count) + " custom instruments from " + copied_source_name, "从 " + copied_source_name + " 导入了 " + string(copied_note_count) + " 个音符和 " + string(imported_instrument_count) + " 个自定义音色"))

	return true
}
