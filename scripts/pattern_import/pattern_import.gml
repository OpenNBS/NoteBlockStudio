function pattern_import() {
	// selection_import([filename, at_mouse_pos])
	// Can successfully read and store all the below into the arrays/variables, but can't seem to display or place the imported selection.
	var a, b, fn, file_ext, nw, temp_colfirst, temp_enda, temp_endb, temp_collast, temp_exists, temp_ins, temp_key, temp_vel, temp_pan, temp_pit, temp_played, byte1, byte2, temp_str, selection_l_temp, at_mouse_pos, loadx, loady;
	fn = ""
	at_mouse_pos = 0
	if (argument_count > 0) fn = argument[0]
	if (argument_count > 1) at_mouse_pos = argument[1]
	loadx = 0
	loady = 0
	if (at_mouse_pos) {
		if (selbx > -1 && selby > -1) {loadx = selbx; loady = selby}
		else {loadx = songs[song].starta; loady = songs[song].startb}
	}
	if (songs[song].selected != 0) return 0
	if (fn = "") {
	    if (!directory_exists_lib(patternfolder)) patternfolder = pattern_directory
	    fn = string(get_open_filename_ext("Note Block Pattern (*.nbp)|*.nbp", "", patternfolder, condstr(language != 1, "Load pattern", "打开分段")))
	}
	if (fn = "" || !file_exists_lib(fn)) return 0

	file_ext = string_lower(filename_ext(fn));
	if (file_ext != ".nbp") {message(condstr(language != 1, "Error: This file is not a pattern.", "错误：该文件不是分段文件。"), condstr(language != 1, "Error", "错误")) return 0}
	if (file_ext = ".nbp") {
		buffer = buffer_import(fn)
	
		song_pat_version = buffer_read_byte()
	//	show_debug_message("song_pat_version " + string(song_pat_version))
		var pat_length = buffer_read_short()
	//	show_debug_message("enda " + string(pat_length))
		var pat_height = buffer_read_short()
	//	show_debug_message("endb " + string(pat_height))
		selection_l_temp = songs[song].selection_l
		songs[song].selection_l = buffer_read_short()
	//	show_debug_message("selection_l " + string(selection_l))
		if (language != 1) {if (song_pat_version < pat_version && show_oldwarning) message("Warning: You are opening an older NBP file. Saving this file will make it incompatible with older Note Block Studio versions.","Warning")}
		else {if (song_pat_version < pat_version && show_oldwarning) message("警告：你正在打开旧版的 NBP 文件。保存此文件会使其与旧版 Note Block Studio 不兼容。","警告")}
		if (language != 1) {if song_pat_version > pat_version message("Warning: You are opening an NBP file created in a later version of Note Block Studio. It may crash when opening.","Warning")}
		else {if song_pat_version > pat_version message("警告：你正在打开在新版 Note Block Studio 里保存的文件。打开时可能会崩溃。","警告")}
		temp_str = buffer_read_string()
		if check_custom_instrument(temp_str) = 0 {
		//	show_debug_message("selection_code " + string(selection_copied))
			selection_copied = temp_str
			selection_extend_length(pat_length)
			selection_extend_height(pat_height)
	
			for (a = 0; a < songs[song].selection_l; a += 1) {
				temp_colfirst[a] = buffer_read_byte_signed()
			    songs[song].selection_colfirst[a] = temp_colfirst[a]
		//		show_debug_message("selection_colfirst " + string(a) + " " + string(selection_colfirst[a]))
				temp_collast[a] = buffer_read_byte_signed()
			    songs[song].selection_collast[a] = temp_collast[a]
		//		show_debug_message("selection_collast " + string(a) + " " + string(selection_collast[a]))
			}
			copied_arraylength = songs[song].selection_arraylength
			copied_arrayheight = songs[song].selection_arrayheight
			copied_colfirstlen = array_length(songs[song].selection_colfirst)
			copied_collastlen = array_length(songs[song].selection_collast)
			selection_load(loadx, loady, selection_copied, false)
		} else {
			songs[song].selection_l = selection_l_temp
			if (language != 1) message("There are more custom instruments in the pattern than what is loaded in the song!", "Error")
			else message("分段内含有比歌曲内更多的自定义音色！", "错误")
			return -1
		}
	}


}
