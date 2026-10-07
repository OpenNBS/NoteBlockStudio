function close_song(){
	var sid = argument[0]
	var nonew = 0
	var noconfirm = 0
	if (argument_count > 1) {
		nonew = argument[1]
	}
	if (argument_count > 2) {
		noconfirm = argument[2]
	}
	if (!noconfirm) {
		var previous_song = song
		if (song != sid) set_song(sid)
		var decision = confirm(0, sid)
		if (song != previous_song) set_song(previous_song)
		if (decision < 0) return false
		// Clean up before destroying the owner. Forced shutdown closes manage
		// backups in control_end(), which may need to retain them for recovery.
		backup_delete_own_tab(songs[sid])
	}
	for (var a = 0; a < 2000; a += 1) {try{songs[song].text_exists_song[a] = text_exists[a]}catch(ee){}; try{songs[song].text_str_song[a] = text_str[a]}catch(ee){}}
	for (var i = first_custom_index; i < ds_list_size(songs[sid].instrument_list); i++)
	with (songs[sid].instrument_list[| i]) {instrument_free(); instance_destroy()}
	instance_destroy(songs[sid])
	array_delete(songs, sid, 1)
	if (song > sid || song >= array_length(songs)) song--
	if (array_length(songs) = 0 && (!nonew || noconfirm)) {
		new_song()
	}
	for (var a = 0; a < 2000; a += 1) {try{text_exists[a] = songs[song].text_exists_song[a]}catch(ee){}; try{text_str[a] = songs[song].text_str_song[a]}catch(ee){}}
	return true
}
