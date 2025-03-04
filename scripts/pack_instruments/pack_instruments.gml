// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pack_instruments() {
	var fn, tempdir, ins, src, dst, count;
	log(songs[song].song_name)
	if (language != 1) fn = string(get_save_filename_ext("ZIP archive (*.zip)|*.zip", condstr(songs[song].filename == "", "", filename_change_ext(songs[song].filename, "") + " - ") + "Instruments.zip", "", "Pack instruments to ZIP file"));
	else fn = string(get_save_filename_ext("ZIP archive (*.zip)|*.zip", condstr(songs[song].filename == "", "", filename_change_ext(songs[song].filename, "") + " - ") + "Instruments.zip", "", "导出音色至 ZIP 文件"));
	if (fn = "") return 0;
	fn = enforce_extension(fn, ".zip")
	
	tempdir = data_directory + "temp" + condstr(os_type = os_windows, "\\", "/");
	if (directory_exists_lib(tempdir)) {
		directory_delete_lib(tempdir);
	}
	directory_create_lib(tempdir);
	
	count = 0;
	for (var i = first_custom_index; i <= ds_list_size(songs[song].instrument_list) - 1; i++) {
		log(string(i) + " " + string(ds_list_size(songs[song].instrument_list)))
		ins = ds_list_find_value(songs[song].instrument_list, i);
		if (ins.filename != "") {
			src = sounds_directory + ins.filename;
			dst = tempdir + ins.filename;
			if (!file_exists_lib(src)) {
				continue;
			}
			log(filename_dir(dst))
			if (!directory_exists_lib(filename_dir(dst))) {
				directory_create_lib(filename_dir(dst))
			}
			files_copy_lib(src, dst);
			count++;
		}
	}
	
	if (os_type = os_macosx) execute_program("ditto", "-c -k \"" + data_directory + "temp" + "\" \"" + fn + "\"", true);
	else execute_program(get_7z_exc_name(), "a -tzip \"" + fn + "\" \"" + data_directory + "temp" + condstr(os_type = os_windows, "\\", "/") + "*\"", true)
	directory_delete_lib(tempdir);
	if (language != 1) message(string(count) + " instrument" + condstr(count > 1, "s were", " was") + " saved!", "Pack instruments");
	else message(string(count) + "个音色已保存！", "导出音色");
	
}
