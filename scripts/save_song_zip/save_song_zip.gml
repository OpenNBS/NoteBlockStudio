function save_song_zip() {
	var fn, tempdir, ins, src, dst, count, cmd;
	
	if (language != 1) fn = string(get_save_filename_ext("ZIP archive (*.zip)|*.zip", condstr(songs[song].filename == "", "", filename_change_ext(songs[song].filename, ".zip")), "", "Save song with custom sounds"));
	else fn = string(get_save_filename_ext("ZIP archive (*.zip)|*.zip", condstr(songs[song].filename == "", "", filename_change_ext(songs[song].filename, ".zip")), "", "连带自定义音色一起导出"));
	if (fn = "") return 0;
	fn = enforce_extension(fn, ".zip")
	
	tempdir = data_directory + "temp" + condstr(os_type = os_windows, "\\", "/");
	if (directory_exists_lib(tempdir)) {
		directory_delete_lib(tempdir);
	}
	directory_create_lib(tempdir);
	
	// Save instruments
	count = 0;
	for (var i = first_custom_index; i <= ds_list_size(songs[song].instrument_list) - 1; i++) {
		log(string(i) + " " + string(ds_list_size(songs[song].instrument_list)));
		ins = ds_list_find_value(songs[song].instrument_list, i);
		if (ins.filename != "") {
			src = sounds_directory + ins.filename;
			dst = tempdir + "sounds" + condstr(os_type = os_windows, "\\", "/") + ins.filename;
			if (!file_exists_lib(src)) {
				continue;
			}
			log(filename_dir(dst));
			if (!directory_exists_lib(filename_dir(dst))) {
				directory_create_lib(filename_dir(dst));
			}
			files_copy_lib(src, dst);
			count++;
		}
	}
	
	// Save song
	save_song(tempdir + "song.nbs", true);
	
	if (os_type = os_macosx) execute_program("ditto", "-c -k \"" + data_directory + "temp" + "\" \"" + fn + "\"", true);
	else execute_program(get_7z_exc_name(), "a -tzip \"" + fn + "\" \"" + data_directory + "temp" + condstr(os_type = os_windows, "\\", "/") + "*\"", true);
	
	if (!file_exists_lib(fn)) {
		if (language != 1) message("The song could not be saved!", "Error");
		else message("导出歌曲失败！", "错误");
	} else {
		if (language != 1) set_msg("Song saved");
		else set_msg("歌曲已保存");
	}

	directory_delete_lib(tempdir);
	
	// if (language != 1) message(string(count) + " instrument" + condstr(count > 1, "s were", " was") + " saved!", "Pack instruments");
	// else message(string(count) + "个音色已保存！", "导出音色");
}