function mp3_export() {
	// mp3_export()

	var fn, err, a, b;
	
	// Report missing instruments
	var missing_str = ""
	for (var i = 0; i < ds_list_size(songs[song].instrument_list); i++) {
		var ins = songs[song].instrument_list[| i]
		if (!ins.loaded && ins.filename != "" && ins.num_blocks > 0) {
			missing_str += ins.filename + "\n"
		}
	}
	if (missing_str != "") {
		if (!question(condstr(language != 1, "Some sounds could be not be loaded and will be missing from the exported track:\n\n" + missing_str + "\nWould you like to export anyway?",
		                                     "某些音频由于无法加载，将从导出后的文件中缺失：\n\n" + missing_str + "\n继续导出吗？"), condstr(language != 1, "Audio export", "音频导出"))) {
			return 0
		}
	}
	
	var output_format = audio_exp_format
	var output_ext = "." + string_lower(output_format)

	fn = string(get_save_filename_ext(output_format + " files (*" + output_ext + ")|*" + output_ext, filename_new_ext(songs[song].filename, "") + output_ext, filename_path(songs[song].filename), condstr(language != 1, "Export audio track", "导出音频文件")))
	if (fn = "") return 0

	save_song(temp_file, true, false, 5);
	
	var args = [temp_file, fn]
	var kwargs = {
		default_sound_path: sounds_directory,
		custom_sound_path: sounds_directory,
		ignore_missing_instruments: true,
		format: string_lower(output_format),
		sample_rate: audio_exp_sample_rate,
		channels: audio_exp_channels,
		exclude_locked_layers: !audio_exp_include_locked
	}
	
	try {
		var result = python_call_function("audio_export", "main", args, kwargs);
	} catch (e) {
		if (language != 1) message("An error occurred while exporting the song:\n\n" + e, "Note Block Studio")
		else message("导出歌曲时发生错误：\n\n" + e, "Note Block Studio")
		return -1;
	}

	if (language != 1) {if (question("Track saved! Do you want to open it?", "Audio Export")) open_url(fn)}
	else {if (question("音频已保存！现在打开吗？", "音频导出")) open_url(fn)}



}
