function pattern_export() {
	// pattern_export()
	var fn, fsave, temp_enda, temp_endb, temp_colfirst, temp_collast, temp_exists, temp_ins, temp_key, temp_vel, temp_pan, temp_pit, temp_played, a, b;
	fn = ""
	if (songs[song].selected = 0) return 0
	if (fn = "") {
		playing = 0
		fsave = filename_change_ext(filename_name(songs[song].filename), ".nbp")
		if (!directory_exists_lib(patternfolder)) patternfolder = pattern_directory
		fn = string(get_save_filename_ext("Note Block Pattern (*.nbp)|*.nbp", fsave, patternfolder, condstr(language !=1, "Save pattern", "保存分段")))
	    if (fn = "") return 0
	}
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
	buffer_export(buffer, fn)
	buffer_delete(buffer)
	songs[song].changed = false

	return true


}
