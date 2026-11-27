function pattern_export() {
	// pattern_export()
	var fn, fsave, temp_enda, temp_endb, temp_colfirst, temp_collast, temp_exists, temp_ins, temp_key, temp_vel, temp_pan, temp_pit, temp_played, a, b;
	fn = ""
	if (songs[song].selected == 0) return 0
	if (fn == "") {
		playing = 0
		fsave = filename_name(songs[song].filename)
		if (fsave == "") fsave = condstr(language != 1, "Untitled pattern", "未命名片段")
		fsave = filename_change_ext(fsave, ".nbp")
		if (!directory_exists_lib(patternfolder)) patternfolder = pattern_directory
		fn = string(get_save_filename_ext("Note Block Pattern (*.nbp)|*.nbp", fsave, patternfolder, condstr(language !=1, "Save pattern", "保存分段")))
	    if (fn == "") return 0
	}
	var export_succeeded = false
	buffer = -1
	try {
		var pattern_instruments = selection_get_custom_instruments()
		buffer = buffer_create(8, buffer_grow, 1)
		buffer_write_byte(pat_version)
		//	show_debug_message("pat_version " + string(pat_version))
		buffer_write_short(songs[song].enda)
		//	show_debug_message("enda " + string(enda))
		buffer_write_short(songs[song].endb)
		//	show_debug_message("endb " + string(endb))
		buffer_write_short(songs[song].selection_l)
		//	show_debug_message("selection_l " + string(selection_l))
		// The selection code will be decompressed to keep the file compatible with older versions
		buffer_write_string(try_decompress_selection(songs[song].selection_code))
		//	show_debug_message("selection_code " + string(selection_code))
	
		for (a = 0; a < songs[song].selection_l; a ++) {
			buffer_write_byte(songs[song].selection_colfirst[a])
		//		show_debug_message("selection_colfirst " + string(a) + " " + string(selection_colfirst[a]))
			buffer_write_byte(songs[song].selection_collast[a])
		//		show_debug_message("selection_collast " + string(a) + " " + string(selection_collast[a]))
		}

		// NBP v2 stores only the custom instrument definitions used by this pattern.
		buffer_write_byte(array_length(pattern_instruments))
		for (a = 0; a < array_length(pattern_instruments); a++) {
			var ins = pattern_instruments[a]
			buffer_write_short(ins.source_index)
			buffer_write_string(ins.name)
			buffer_write_string(ins.filename)
			buffer_write_byte(ins.key)
			buffer_write_byte(ins.press)
		}
		export_succeeded = buffer_export(buffer, fn)
	} catch (e) {
		show_debug_message("Failed to export pattern: " + string(e))
	}
	if (buffer >= 0) buffer_delete(buffer)
	buffer = -1
	if (!export_succeeded) {
		// Avoid message(), which writes to the log and can fail on a full disk.
		widget_set_caption(condstr(language != 1, "Pattern export failed", "分段导出失败"))
		show_message(condstr(language != 1,
			"The pattern could not be exported.\n\nCheck that the destination is writable and has enough free disk space, then try again. Your song is still open.",
			"分段无法导出。\n\n请确认保存位置可写且磁盘有足够的可用空间，然后重试。你的歌曲仍保持打开。"))
		return false
	}

	// A pattern contains only the selection. Exporting it does not save the song
	// or change whether the song needs an unsaved-work prompt.
	return true


}
