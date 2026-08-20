function save_song() {
	// save_song(fn[, backup, is_autosave])
	var fn, backup, nbsver, f, a, ca, cb, fsave, asave, has_v6_ins;
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
	if (isplayer) return 0
	if ((!backup) && (fn = "" || string_lower(filename_ext(cursong.filename)) != ".nbs")) {
	    playing = 0
	    fsave = filename_name(cursong.filename)
	    if (!directory_exists_lib(songfolder)) songfolder = songs_directory
	    fn = string(get_save_filename_ext("Note Block Songs (*.nbs)|*.nbs", fsave + condstr(filename_ext(cursong.filename) != ".nbs", ".nbs"), songfolder, condstr(language !=1, "Save song", "保存歌曲")))
		log(string_char_at(fn, string_length(fn) - 3))
	    if (fn = "") return 0
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
	
	if (argument_count > 3) {
		nbsver = argument[3];
	}

	if (nbsver < 6) has_v6_ins = song_uses_v6_instruments(cursong)
	var custom_instrument_max = nbs_custom_instrument_limit(nbsver, has_v6_ins)
	if (cursong.user_instruments > custom_instrument_max) {
		if (!backup) {
			message(condstr(language != 1,
				"This song has " + string(cursong.user_instruments) + " custom instruments, but NBS v" + string(nbsver) + " can store at most " + string(custom_instrument_max) + " with the current instrument set.\n\nRemove some custom instruments or choose a compatible save version.",
				"此歌曲包含 " + string(cursong.user_instruments) + " 个自定义音色，但按当前音色配置，NBS v" + string(nbsver) + " 最多只能存储 " + string(custom_instrument_max) + " 个。\n\n请删除部分自定义音色，或选择兼容的保存版本。"),
				condstr(language != 1, "Save failed", "保存失败"))
		}
		return false
	}

	buffer = buffer_create(8, buffer_grow, 1)

	if nbsver >= 1 {
	//First 2 bytes 0 to indicate new nbs format
	buffer_write_short(0)

	buffer_write_byte(nbsver)
	var song_first_custom_index = first_custom_index
	if (nbsver < 6) song_first_custom_index = 16
	buffer_write_byte(song_first_custom_index)
	}

	if nbsver = 0 || nbsver >= 3 {
	//song length (ticks)
	buffer_write_short(cursong.enda)
	}

	//layer count
	buffer_write_short(cursong.endb2)

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

	if nbsver >= 4 {
	buffer_write_byte(cursong.loop)
	buffer_write_byte(cursong.loopmax)
	buffer_write_short(cursong.loopstart)
	}
	
	ca = 0
	var ins = 0
	for (a = 0; a <= cursong.enda; a += 1) {
	    ca += 1
	    if (cursong.colamount[a] > 0) {
	        buffer_write_short(ca)
	        ca = 0
	        cb = 0
	        for (b = 0; b <= cursong.collast[a]; b += 1) {
	            cb += 1
	            if (cursong.song_exists[a, b]) {
	                buffer_write_short(cb)
	                cb = 0
					ins = ds_list_find_index(cursong.instrument_list, cursong.song_ins[a, b])
					if (nbsver < 6 && ins >= 20 && !has_v6_ins) ins -= 4
	                buffer_write_byte(ins)
	                buffer_write_byte(cursong.song_key[a, b])
					if nbsver >= 4 {
					buffer_write_byte(cursong.song_vel[a, b])
					buffer_write_byte(cursong.song_pan[a, b])
					buffer_write_short(cursong.song_pit[a, b])
					}
	            }
	        }
	        buffer_write_short(0)
	    }
	}
	buffer_write_short(0)
	// Layer names
	for (b = 0; b < cursong.endb2; b += 1) {
	    buffer_write_string_int(cursong.layername[b])
		if nbsver >= 4 {
		buffer_write_byte(cursong.layerlock[b])
		}
	    buffer_write_byte(cursong.layervol[b])
		if nbsver >= 2 {
		buffer_write_byte(cursong.layerstereo[b])
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
	var save_succeeded = false
	try {
		save_succeeded = buffer_export(buffer, fn)
	} catch (e) {
		// Avoid writing to the log here: this path can run when the disk is full.
		show_debug_message("Failed to save song: " + string(e))
	}
	buffer_delete(buffer)
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
	} else {
		tonextbackup = backupmins
	}
	return true



}
