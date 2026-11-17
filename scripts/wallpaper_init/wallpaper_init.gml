function wallpaper_init(wallpaper_path = "") {
	can_draw_mica = (os_browser = browser_not_a_browser)
	if (wallpaper_path = "") {
		execute_program(data_directory + "wallpaper.bat", "", true)
		wallpaper_path = data_directory + "Wallpaper.jpg"
		wpaperanchor = 0
	} else {
		wpaperanchor = 1
	}
	wpaperexist = (file_exists(wallpaper_path) && (os_browser = browser_not_a_browser))
	if (wpaperexist) {
		if (sprite_exists(wpaperblur) && wpaperblur != wpaper) sprite_delete(wpaperblur)
		wpaperblur = -1
		if (sprite_exists(wpaper)) sprite_delete(wpaper)
		wpaper = sprite_add(wallpaper_path, 1, 0, 0, 0, 0)
		wpaperexist = sprite_exists(wpaper)
		if (wpaperexist) {
			wpaperside = (display_width / display_height < sprite_get_width(wpaper) / sprite_get_height(wpaper))
			// Surface work waits until Draw.
			wallpaper_prepare_pending = true
		}
	}
}
