function check_updates() {
	// check_updates()
	// Handles the update checking
	// update values:
	// -1: unable to check for update
	// 0: checking
	// 1: update found
	// 2: up to date
	// 4: downloading update

	if (async_load[? "id"] = update_http) {
		
		// CHECK RECEIVED DATA:
		// show_debug_message(async_load[? "result"])
		// show_debug_message(async_load[? "status"])
		// show_debug_message(async_load[? "http_status"])
		
		var status = async_load[? "status"];
		
		if (status == -1) { // error
			update = -1
			return;
		}
		
		else if (status == 0) { // success
			
			if (async_load[? "http_status"] != 200) { // other status codes (403 - rate limit, etc.)
				update = -1;
				return;
			}
			
			else {
				update_http = -1;
			
			    var res = async_load[? "result"];
				res = json_parse(res);

				var release = -1;
				if (check_prerelease) {
					// Get first (latest) release on list, whether it's a release OR pre-release
					release = res[0];
				} else {
					release = res;
				}
			
				if (release != -1) {
					var new_version = string_replace(release.tag_name, "v", "");
					if (new_version == version) {
						update = 2;
					} else {
						if (question(condstr(language != 1, "Version " + new_version + " is available! Do you want to download it?", "版本 " + new_version + " 可用！是否现在下载？"), condstr(language != 1, "Update available!", "更新可用！"))) {
							if (os_type = os_windows) {
								var download_url = release.assets[0].browser_download_url;
								update_download = http_get_file(download_url, update_file);
								update = 4;
							} else if (os_type = os_macosx) {
								open_url("https://testflight.apple.com/join/hg58hwbM")
							} else {
								open_url("https://github.com/OpenNBS/NoteBlockStudio/releases")
							}
						} else {
							update = 1;
						}
					}
				} else update = -1;
			
			}
		}
	}
}
