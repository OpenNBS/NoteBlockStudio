/// @description  new_instrument(name, filename, user, [press, key])
/// @function  new_instrument
/// @param name
/// @param  filename
/// @param  user
/// @param  [press
/// @param  key]
function new_instrument() {

	var ins = create(obj_instrument);

	ins.name = argument[0]
	ins.filename = argument[1]
	ins.user = argument[2]
	if (argument_count > 3)
	    ins.press = argument[3]
	else
	    ins.press = false
	if (argument_count > 4)
	    ins.key = argument[4]
	else
	    ins.key = 45

	if (ins.user)
	    songs[song].user_instruments++

	ins.loaded = false
	ins.num_blocks = 0
	ins.sound_buffer = -1
	ins.sound = -1
	ins.sound_duration = 0
	ins.resourcepack_pitch = 1
	// Export-only Minecraft sound-event mapping. Functional/event instruments
	// intentionally keep this blank; ordinary custom instruments are lazily
	// populated from their display name and may be edited in Instrument Settings.
	ins.minecraft_sound = ""
	ins.minecraft_sound_manual = false

	return ins



}

function nbs_custom_instrument_limit(format_version, includes_v6_instruments = false) {
	// Note instrument IDs are stored as a single byte. NBS v5 starts custom
	// instruments at 16, while v6 starts them after the 20 built-in instruments.
	var limit
	if (format_version < 5) limit = 18
	else if (format_version < 6) limit = 240
	else limit = 256 - first_custom_index

	// Older formats save the four v6 instruments as custom instruments.
	if (format_version < 6 && includes_v6_instruments) limit -= 4
	return max(0, limit)
}

function song_uses_v6_instruments(song_instance) {
	// Built-in instruments are shared across tabs, so num_blocks is not a
	// per-song count. Check this song's notes, including its floating selection.
	var selection_x = max(0, song_instance.selection_x)
	var selection_y = max(0, song_instance.selection_y)
	for (var tick = 0; tick <= song_instance.enda; tick++) {
		if (song_instance.colamount[tick] == 0) continue
		for (var row_index = song_instance.colfirst[tick]; row_index <= song_instance.collast[tick]; row_index++) {
			if (!song_instance.song_exists[tick, row_index]) continue
			var sx = tick - selection_x
			var sy = row_index - selection_y
			if (song_instance.selected > 0 && sx >= 0 && sx < song_instance.selection_l && sy >= 0 && sy < song_instance.selection_h && song_instance.selection_exists[sx, sy]) continue
			var instrument_index = ds_list_find_index(song_instance.instrument_list, song_instance.song_ins[tick, row_index])
			if (instrument_index >= 16 && instrument_index < 20) return true
		}
	}
	if (song_instance.selected > 0) {
		for (var tick = 0; tick < song_instance.selection_l; tick++) {
			if (song_instance.selection_colfirst[tick] < 0) continue
			for (var row_index = song_instance.selection_colfirst[tick]; row_index <= song_instance.selection_collast[tick]; row_index++) {
				if (!song_instance.selection_exists[tick, row_index]) continue
				var instrument_index = ds_list_find_index(song_instance.instrument_list, song_instance.selection_ins[tick, row_index])
				if (instrument_index >= 16 && instrument_index < 20) return true
			}
		}
	}
	return false
}
