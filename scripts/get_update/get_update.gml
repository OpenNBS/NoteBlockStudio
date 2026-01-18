function get_update() {
	// get_update()
	// Attempts to download a newer version if one is available
	// status:
	// 1 - receiving packets (download in progress)
	// 0 - success (download complete)

	if (async_load[? "id"] == update_download) {
		var status = async_load[? "status"]
	    if (status == 1) {
			downloaded_size = async_load[? "sizeDownloaded"]
			total_size = async_load[? "contentLength"]
		} else if (status == 0) {
			// Download was interrupted, may have been successful or not (if connection was interrupted)
			update = 5
			if (file_get_size(update_file) == total_size) {
				if (language != 1) message("Download complete! Click OK to begin installing the update.", "Note Block Studio")
				else message("下载完成！点击“OK”来安装更新。", "Note Block Studio")
				// At this point, the game is paused until the user dismisses the message
				execute_program(update_file, "", false)
				game_end()
			} else {
				if (language != 1) {
				if (question("Failed to download update. Do you want to open the Note Block Studio website and update manually?", "Failed")) {
					open_url(link_website)
				}
				} else {
				if (question("下载更新失败。你想要到 Note Block Studio 官网手动更新吗？", "失败")) {
					open_url(link_website)
				}
				}
			window = w_greeting
			update_download = -1
			update = 1
			}
		}
	}


}
