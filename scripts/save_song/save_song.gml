function save_song() {
	// save_song(fn[, backup, is_autosave, format_version, source_song])
	// source_song lets recovery serialize an inactive tab without changing the UI.
	var fn, backup, nbsver, f, a, b, ca, cb, fsave, asave, has_v6_ins;
	fn = argument[0];
	backup = false;
	asave = false;
	has_v6_ins = false;
	var cursong = songs[song];
	if (argument_count > 1) {
		backup = argument[1];
	}
	if (argument_count > 2) {
		asave = argument[2];
	}
	if (argument_count > 4) {
		cursong = argument[4];
		if (!backup && cursong != songs[song]) return false
	}
	if (isplayer) return 0
	if ((!backup) && (fn == "" || string_lower(filename_ext(cursong.filename)) != ".nbs")) {
	    playing = 0
	    fsave = filename_name(cursong.filename)
		if (fsave == "") fsave = condstr(language != 1, "Untitled song", "未命名歌曲")
		fsave = filename_change_ext(fsave, ".nbs")
	    if (!directory_exists_lib(songfolder)) songfolder = songs_directory
	    fn = string(get_save_filename_ext("Note Block Songs (*.nbs)|*.nbs", fsave, songfolder, condstr(language !=1, "Save song", "保存歌曲")))
		log(string_char_at(fn, string_length(fn) - 3))
	    if (fn == "") return 0
	}
	if (!backup && !asave) warn_working_directory_path(fn)
	if ((!backup) && (cursong.selected > 0) && (!asave)) selection_place(0)

	if (backup) {
		nbsver = nbs_version
		// A v5 song may validly contain 237-240 custom instruments. Keep its
		// backup in v5 because v6 has only 236 byte-sized custom IDs available.
		if (cursong.user_instruments > nbs_custom_instrument_limit(nbsver)) nbsver = 5
	} else {
		nbsver = cursong.save_version
	}
	
	if (argument_count > 3 && !is_undefined(argument[3])) {
		nbsver = argument[3];
	}

	if (nbsver < 6) has_v6_ins = song_uses_v6_instruments(cursong)
	var custom_instrument_max = nbs_custom_instrument_limit(nbsver, has_v6_ins)
	var instrument_limit_version = nbsver
	if (nbsver < 6 && has_v6_ins && cursong.user_instruments > custom_instrument_max) instrument_limit_version = nbs_version
	if (cursong.user_instruments > custom_instrument_max) {
		if (!backup) {
			message(condstr(language != 1,
				"This song has " + string(cursong.user_instruments) + " custom instruments, but NBS v" + string(instrument_limit_version) + " can store at most " + string(custom_instrument_max) + " with the current instrument set.\n\nRemove some custom instruments or choose a compatible save version.",
				"此歌曲包含 " + string(cursong.user_instruments) + " 个自定义音色，但按当前音色配置，NBS v" + string(instrument_limit_version) + " 最多只能存储 " + string(custom_instrument_max) + " 个。\n\n请删除部分自定义音色，或选择兼容的保存版本。"),
				condstr(language != 1, "Save failed", "保存失败"))
		}
		return false
	}

	// Backups and autosaves include the floating selection without placing it,
	// changing history, or switching tabs. Selected notes take precedence over
	// notes beneath them, matching selection_place().
	var include_selection = cursong.selected > 0
	var selection_x = max(0, cursong.selection_x)
	var selection_y = max(0, cursong.selection_y)
	var saved_end = cursong.enda
	var saved_layers = cursong.endb2
	if (include_selection) {
		saved_end = max(saved_end, selection_x + cursong.selection_l - 1)
		saved_layers = max(saved_layers, selection_y + cursong.selection_h)
	}
	var save_succeeded = false
	buffer = -1
	try {
		buffer = buffer_create(8, buffer_grow, 1)

		if (nbsver >= 1) {
		//First 2 bytes 0 to indicate new nbs format
		buffer_write_short(0)

		buffer_write_byte(nbsver)
		var song_first_custom_index = first_custom_index
		if (nbsver < 6) song_first_custom_index = 16
		buffer_write_byte(song_first_custom_index)
		}

		if (nbsver == 0 || nbsver >= 3) {
		//song length (ticks)
		buffer_write_short(saved_end)
		}

		//layer count
		buffer_write_short(saved_layers)

		buffer_write_string_int(cursong.song_name)
		buffer_write_string_int(cursong.song_author)
		buffer_write_string_int(cursong.song_orauthor)
		buffer_write_string_int(cursong.song_desc)

		buffer_write_short(cursong.real_tempo * 100)
		// Per-song auto-save is deprecated. It is only written to
		// the file to preserve auto-save behavior on older versions
		buffer_write_byte(autosave)
		buffer_write_byte(autosavemins)
		buffer_write_byte(cursong.timesignature)

		buffer_write_int(floor(cursong.work_mins))
		buffer_write_int(cursong.work_left)
		buffer_write_int(cursong.work_right)
		buffer_write_int(cursong.work_add)
		buffer_write_int(cursong.work_remove)

		buffer_write_string_int(cursong.song_midi)

		if (nbsver >= 4) {
		buffer_write_byte(cursong.loop)
		buffer_write_byte(cursong.loopmax)
		buffer_write_short(cursong.loopstart)
		}
	
		ca = 0
		var ins = 0
		for (a = 0; a <= saved_end; a += 1) {
			ca += 1
			var grid_last = -1
			if (a < cursong.arraylength && cursong.colamount[a] > 0) grid_last = cursong.collast[a]
			var sx = a - selection_x
			var selected_column = include_selection && sx >= 0 && sx < cursong.selection_l && cursong.selection_colfirst[sx] >= 0
			var selected_last = -1
			if (selected_column) selected_last = selection_y + cursong.selection_collast[sx]
			var wrote_column = false
			cb = 0
			for (b = 0; b <= max(grid_last, selected_last); b += 1) {
				cb += 1
				var sy = b - selection_y
				var selected_note = selected_column && sy >= cursong.selection_colfirst[sx] && sy <= cursong.selection_collast[sx] && cursong.selection_exists[sx, sy]
				var grid_note = b <= grid_last && cursong.song_exists[a, b]
				if (selected_note || grid_note) {
					if (!wrote_column) {
						buffer_write_short(ca)
						ca = 0
						wrote_column = true
					}
					buffer_write_short(cb)
					cb = 0
					var note_instrument = selected_note ? cursong.selection_ins[sx, sy] : cursong.song_ins[a, b]
					ins = ds_list_find_index(cursong.instrument_list, note_instrument)
					if (nbsver < 6 && ins >= 20 && !has_v6_ins) ins -= 4
					buffer_write_byte(ins)
					buffer_write_byte(selected_note ? cursong.selection_key[sx, sy] : cursong.song_key[a, b])
					if (nbsver >= 4) {
						buffer_write_byte(selected_note ? cursong.selection_vel[sx, sy] : cursong.song_vel[a, b])
						buffer_write_byte(selected_note ? cursong.selection_pan[sx, sy] : cursong.song_pan[a, b])
						buffer_write_short(selected_note ? cursong.selection_pit[sx, sy] : cursong.song_pit[a, b])
					}
				}
			}
			if (wrote_column) buffer_write_short(0)
		}
		buffer_write_short(0)
		// Layer names
		for (b = 0; b < saved_layers; b += 1) {
		    buffer_write_string_int(b < cursong.endb2 ? cursong.layername[b] : "")
			if (nbsver >= 4) {
			buffer_write_byte(b < cursong.endb2 ? cursong.layerlock[b] : 0)
			}
		    buffer_write_byte(b < cursong.endb2 ? cursong.layervol[b] : 100)
			if (nbsver >= 2) {
			buffer_write_byte(b < cursong.endb2 ? cursong.layerstereo[b] : 100)
			}
		}

		// Custom instruments
		var user_ins = cursong.user_instruments
		if (has_v6_ins) user_ins += 4
		buffer_write_byte(user_ins)
		for (b = 0; b < ds_list_size(cursong.instrument_list); b++) {
		    var ins = cursong.instrument_list[| b];
		    if (ins.user || (has_v6_ins && b > 15 && b < 20)) {
		        buffer_write_string_int(ins.name)
		        buffer_write_string_int(ins.filename)
		        buffer_write_byte(ins.key)
		        buffer_write_byte(ins.press)
		    }
		}
		save_succeeded = buffer_export(buffer, fn)
	} catch (e) {
		// Avoid writing to the log here: this path can run when the disk is full.
		show_debug_message("Failed to save song: " + string(e))
	}
	if (buffer >= 0) buffer_delete(buffer)
	buffer = -1

	if (!save_succeeded) {
		if (!backup) {
			var error_text = condstr(language != 1,
				"The song could not be saved.\n\nCheck that the destination is writable and has enough free disk space, then try again. Your changes are still open in Note Block Studio.",
				"歌曲无法保存。\n\n请确认保存位置可写且磁盘有足够的可用空间，然后重试。你的更改仍保留在 Note Block Studio 中。")
			var error_title = condstr(language != 1, "Save failed", "保存失败")
			try {
				message(error_text, error_title)
			} catch (e) {
				// message() writes to the log first, which may also fail on a full disk.
				widget_set_caption(error_title)
				show_message(error_text)
			}
		}
		return false
	}

	if (!backup) {
		cursong.filename = fn;
		update_backup_name();
		cursong.changed = false;
		if (autosave) tonextsave = autosavemins;
		add_to_recent(fn);
		if (asave) {	
			if (language != 1) set_msg("Song auto saved");
			else set_msg("歌曲自动保存");
		} else {
			if (language != 1) set_msg("Song saved");
			else set_msg("歌曲已保存");
		}
	}
	return true



}
