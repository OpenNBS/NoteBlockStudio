function save_song() {
	// save_song(fn[, backup])
	var fn, backup, nbsver, f, a, ca, cb, fsave;
	fn = argument[0]
	backup = false
	var cursong = songs[song]
	if (argument_count > 1) {
		backup = argument[1]
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
	if ((!backup) && (cursong.selected > 0)) selection_place(0)

	if (backup) {
		nbsver = nbs_version
	} else {
		nbsver = save_version
	}

	buffer = buffer_create(8, buffer_grow, 1)

	if nbsver >= 1 {
	//First 2 bytes 0 to indicate new nbs format
	buffer_write_short(0)

	buffer_write_byte(nbsver)
	buffer_write_byte(first_custom_index)
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
	                buffer_write_byte(ds_list_find_index(cursong.instrument_list, cursong.song_ins[a, b]))
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
	buffer_write_byte(cursong.user_instruments)
	for (b = 0; b < ds_list_size(cursong.instrument_list); b++) {
	    var ins = cursong.instrument_list[| b];
	    if (ins.user) {
	        buffer_write_string_int(ins.name)
	        buffer_write_string_int(ins.filename)
	        buffer_write_byte(ins.key)
	        buffer_write_byte(ins.press)
	    }
	}
	buffer_export(buffer, fn)
	buffer_delete(buffer)

	if (!backup) {
		cursong.filename = fn
		update_backup_name()
		cursong.changed = false
		if (autosave) tonextsave = autosavemins
		add_to_recent(fn)
		if (language != 1) set_msg("Song saved")
		else set_msg("歌曲已保存")
	} else {
		tonextbackup = backupmins
	}

	return true



}
