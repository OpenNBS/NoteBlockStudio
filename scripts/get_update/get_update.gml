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
				var launch_error = windows_update_launch(update_file)
				if (launch_error == 0) {
					game_end()
				} else {
					log("Failed to start update installer", "Windows error " + string(launch_error))
					var launch_message = ""
					var launch_caption = ""
					if (language != 1) {
						launch_message = launch_error == 1223
							? "Installation was canceled. Do you want to open the Note Block Studio website and update manually?"
							: "Failed to start the update installer (Windows error " + string(launch_error) + "). Do you want to open the Note Block Studio website and update manually?"
						launch_caption = "Update not started"
					} else {
						launch_message = launch_error == 1223
							? "安装已取消。你想要到 Note Block Studio 官网手动更新吗？"
							: "无法启动更新安装程序（Windows 错误 " + string(launch_error) + "）。你想要到 Note Block Studio 官网手动更新吗？"
						launch_caption = "未启动更新"
					}
					if (question(launch_message, launch_caption)) {
						if (check_prerelease) open_url(link_releases)
						else open_url(link_website)
					}
					window = w_greeting
					update_download = -1
					update = 1
				}
			} else {
				if (language != 1) {
				if (question("Failed to download update. Do you want to open the Note Block Studio website and update manually?", "Failed")) {
					if (check_prerelease) open_url(link_releases)
					else open_url(link_website)
				}
				} else {
				if (question("下载更新失败。你想要到 Note Block Studio 官网手动更新吗？", "失败")) {
					if (check_prerelease) open_url(link_releases)
					else open_url(link_website)
				}
				}
			window = w_greeting
			update_download = -1
			update = 1
			}
		}
	}


}
