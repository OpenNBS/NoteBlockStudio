function load_song() {
	// load_song(fn [, backup])
	var fn, backup, file_ext, newsong, replace, start
	fn = argument[0]
	start = false
	backup = false
	replace = isplayer
	if (argument_count > 1) {
		backup = argument[1]
	}
	if (argument_count > 2) {
		replace = argument[2]
	}
	if (argument_count > 3) {
		start = argument[3]
	}
	//if (confirm() < 0) return 0
	if (!backup && fn = "") {
	    if (!directory_exists_lib(songfolder)) songfolder = songs_directory
	    fn = string(get_open_filename_ext("Note Block Songs (*.nbs)|*.nbs|MIDI Sequences (*.mid)|*.mid;*.midi|Minecraft Schematics (*.schematic)|*.schematic|ZIP archive (*.zip)|*.zip", "", songfolder, condstr(language != 1, "Load song", "打开歌曲")))
		if (os_type = os_macosx) macos_bookmark_store(fn, fn, 0)
	} else {
		if (os_type = os_macosx) macos_bookmark_begin(fn)
	}
	if (fn = "" || !file_exists_lib(fn)) return 0

	// When not opening from auto-recovery, delete the backup file
	if (!backup) {
		//backup_clear()
	}
	reset_add()
	file_ext = filename_ext(fn)
	if (file_ext = ".mid" || file_ext = ".midi") {
	    open_midi(fn)
	    return 1
	}
	else if (file_ext = ".schematic") {
	    open_schematic(fn)
	    return 1
	}
	else if (file_ext = ".zip") {
		try {
			newsong = open_song_zip(fn, replace)
	
			if (newsong <= 0) return -1;
		} catch (e) {
			message(e, "Error")
			return 1;
		}
	}
	else if (file_ext = ".nbs") {
		newsong = open_song_nbs(fn, "", 0, replace)
	
		if (newsong <= 0) return -1;
	} else {
		message(condstr(language != 1, "Error: This file cannot be opened in this program.", "警告：本软件无法打开此类型文件。"), condstr(language != 1, "Error", "错误"))
		return 0;
	}
		
	if (!backup) {
		add_to_recent(fn)
		if (window != w_instruments && newsong.song_name != "") window = w_songinfo
		newsong.filename = fn
		newsong.song_backupname = filename_name(filename_change_ext(newsong.filename, ".nbs"));
		newsong.changed = 0
	}
	else {
		newsong.changed = 1
	}
	//backup_clear()
	blocks_set_instruments()
	io_clear()
	update_tempo_changes()
	newsong.tempo = newsong.real_tempo

}
