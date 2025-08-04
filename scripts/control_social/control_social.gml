function control_social(){
	log("social callback")
	if (async_load[? "id"] == "GM_MENU") {
		log("menu callback")
		var uid = async_load[? "uid"]
		log ("uid: "  + uid)
		if (uid == "app_settings") {
			if (window = 0) window = w_preferences
		} else {
			var menu_index = -1
			var menu_index_str = ""
			var digit = -1
			var i = -1
			for (var i = string_length(uid); i > 0; i--) {
				digit = string_char_at(uid, i)
				try {
					real(digit)
				} catch (e) {
					break
				}
				menu_index_str = digit + menu_index_str
			}
			if (menu_index_str != "") {
				menu_index = real(menu_index_str)
				menu_shown = string_copy(uid, 0, i - 1)
				window += w_menu
				menu_click(menu_index)
				macos_menu_last_refresh = current_time
			}
		}
	} else if (async_load[? "id"] == "GM_MENU_EVENT"){
		log("menu event callback")
		var event = async_load[? "event"]
		log ("event: "  + event)
		if (event == "open") {
			menu_macos_init()
			playing = 0
		}
	} else if (async_load[? "id"] == "FILE_OPEN"){
		var file = async_load[? "path"]
		if (file != "" && (filename_ext(file) = ".mid" || filename_ext(file) = ".midi" || filename_ext(file) = ".schematic" || filename_ext(file) = ".nbs" || filename_ext(file) = ".zip")) {
			load_song(file)
		}
	}
}