function download_song_start(download_url) {
	
		var download_url_noparams = download_url;
		var params_pos = string_last_pos("?", download_url);
		if (params_pos > 0) {
			download_url_noparams = string_copy(download_url, 1, params_pos - 1);
		}
		
		// var a1 = download_url;
		// var a2 = download_url_noparams;
		// var a3 = string(string_last_pos(".nbs", download_url_noparams));
		// var a4 = string(string_last_pos(".zip", download_url_noparams));
		// var a5 = string(string_length(download_url_noparams) - 3);
		// show_message(a1 + br + a2 + br + a3 + br + a4 + br + a5);
		
		var len = string_length(download_url_noparams);
		
		var is_nbs = string_last_pos(".nbs", download_url_noparams) == len - 3;
		var is_zip = string_last_pos(".zip", download_url_noparams) == len - 3;
		if (!(is_nbs || is_zip)) {
			if (language != 1) message("Couldn't verify if the file you're trying to open is a valid song!", "Note Block Studio")
			else message("所打开的文件不属于可以读取的格式！", "Note Block Studio")
			game_end()
		} else {
			var song_download_ext = string_copy(download_url_noparams, string_last_pos(".", download_url_noparams), string_length(download_url_noparams));
			
			// Set download path to song.nbs or song.zip
			song_download_file = filename_change_ext(downloaded_song_file, song_download_ext)
			
			// Set displayed filename to the server's file name
			songs[song].song_download_display_name = string_copy(download_url_noparams, string_last_pos("/", download_url_noparams) + 1, string_length(download_url_noparams));
			
			// Init download
			log(string(song_download_data));
			song_download_data = http_get_file(download_url, song_download_file);
			log(string(song_download_data));

		}
}