function action_paste(argument0, argument1) {
	// action_paste(x, y)
	var xx, yy;
	xx = argument0
	yy = argument1

	var cross_song = copied_from_song != -1 && copied_context_code == selection_copied && copied_from_song != songs[song]
	var instrument_map = -1
	var copied_instrument_count = 0

	if (cross_song) {
		var resolve_result = custom_instruments_resolve(copied_custom_instruments)
		if (!resolve_result.ok) {
			message(condstr(language != 1, "This selection needs " + string(resolve_result.needed_count) + " new custom instruments, but this song only has room for " + string(resolve_result.available_count) + ".\n\nNo notes were pasted.", "此选区需要添加 " + string(resolve_result.needed_count) + " 个自定义音色，但当前歌曲只能再添加 " + string(resolve_result.available_count) + " 个。\n\n未粘贴任何音符。"), condstr(language != 1, "Paste", "粘贴"))
			return 0
		}
		instrument_map = resolve_result.instrument_map
		copied_instrument_count = resolve_result.added_count
	}

	if (copied_arraylength > songs[song].selection_arraylength) { // New length
	    for (var a = songs[song].selection_arraylength + 1; a <= copied_arraylength; a += 1) {
	        songs[song].selection_colfirst[a] = -1
	        songs[song].selection_collast[a] = -1
	        for (var b = 0; b <= songs[song].selection_arrayheight; b += 1) {
	            songs[song].selection_exists[a, b] = 0
	        }
	    }
	    songs[song].selection_arraylength = copied_arraylength
	}
	if (copied_arrayheight > songs[song].selection_arrayheight) { // New height
	    for (var a = 0; a <= songs[song].selection_arraylength; a += 1) {
	        for (var b = songs[song].selection_arrayheight + 1; b <= copied_arrayheight; b += 1) {
	            songs[song].selection_exists[a, b] = 0
	        }
	    }
	    songs[song].selection_arrayheight = copied_arrayheight
	}
	selection_load(xx, yy, selection_copied, false, instrument_map)
	if (instrument_map != -1) ds_map_destroy(instrument_map)
	history_set(h_selectpaste, xx, yy, songs[song].selection_code)
	songs[song].changed = 1

	if (cross_song) {
		set_msg(condstr(language != 1, "Copied " + string(copied_note_count) + " notes and " + string(copied_instrument_count) + " custom instruments from " + copied_source_name, "从 " + copied_source_name + " 复制了 " + string(copied_note_count) + " 个音符和 " + string(copied_instrument_count) + " 个自定义音色"))
	}


}
