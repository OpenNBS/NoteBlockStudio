function download_song_from_url() {
	// Attempts to download a song from a URL
	// Status:
	// 1 - receiving packets (download in progress)
	// 0 - success (download complete)

	if (async_load[? "id"] == song_download_data) {
		var status = async_load[? "status"];
		show_debug_message("Status: " + string(status));
		
	    if (status == 1) { // Downloading, if multiple packets are returned. The status may never be 1 if the server responds immediately
			song_downloaded_size = async_load[? "sizeDownloaded"];
			song_total_size = async_load[? "contentLength"];
			
			if (song_total_size > max_song_download_size) {
				message("This file is too large to be opened via a URL! Please try downloading and manually opening the song.", "Error");
				song_download_data = -1; // Cancel
				game_end();
			} else {
				song_download_status = 1;
			}
		} else if (status == 0) {
			// Download was interrupted, may have been successful or not (if connection was interrupted)
			show_debug_message("Download interrupted; may have been successful our not");
			song_download_data = -1;
			song_download_status = 2;
			
			// The sizeDownloaded and contentLength variables may never be reported if the song is downloaded in one go.
			// To avoid this from happening, we compare the Content-Length response header with the downloaded file's disk size.
			var headers = async_load[? "response_headers"];
			var contentLength = -1;
			var contentDisposition = "";
			var contentType = "";
			if (headers > 0) {
				contentLength = headers[? "Content-Length"];
				contentDisposition = headers[? "Content-Disposition"];
				contentType = headers[? "Content-Type"];
			}
			var writtenFileSize = file_get_size(song_download_file);
			show_debug_message("Written file size: " + string(writtenFileSize));
			
			// Check mimetype to see if response is a valid file
			var invalid_type = false;
			if (!is_undefined(contentType)) {
				if !(contentType == "application/zip" || contentType == "application/octet-stream") {
					invalid_type = true
					show_debug_message("Invalid file type");
				}
			}
			
			// Read file name from Content-Disposition header, if present
			var override_fn = "";
			if (!is_undefined(contentDisposition) && string_count("attachment; filename=", contentDisposition) > 0) { // attachment; filename="<song.nbs>"
				show_debug_message("Content-Disposition: " + contentDisposition)
				
				var firstQuotePos = string_pos("\"", contentDisposition) + 1;
				var lastQuotePos = string_last_pos("\"", contentDisposition);
				override_fn = string_copy(contentDisposition, firstQuotePos, lastQuotePos - firstQuotePos);
			}
			
			if (!invalid_type && contentLength > 0 && writtenFileSize == contentLength) {
				show_debug_message("Download complete!");
				song_downloaded_size = song_total_size; // prevent freezing under 100%
				show_debug_message(override_fn);
				load_song(song_download_file, true); // load as backup file (keep unsaved, don't add to recent etc.)
				if (override_fn != "") {
					song_download_display_name = filename_change_ext(override_fn, ""); // override title bar display name
				}
				files_delete_lib(song_download_file);
			} else {
				if (language != 1) {
					show_message("The song could not be downloaded! Please try again with a different song.");
				} else {
					show_message("歌曲下载失败！请更换歌曲重试。");
				}
				game_end();
			}
		}
	}


}
