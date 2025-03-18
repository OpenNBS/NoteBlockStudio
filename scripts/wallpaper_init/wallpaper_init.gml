function wallpaper_init(wallpaper_path = "") {
	var tempsurf, wpaperwidth;
	can_draw_mica = (os_browser = browser_not_a_browser)
	if (wallpaper_path = "") {
		execute_program("cmd", "\"" + data_directory + "wallpaper.bat", true)
		wallpaper_path = data_directory + "Wallpaper.jpg"
		wpaperanchor = 0
	} else {
		wpaperanchor = 1
	}
	wpaperexist = (file_exists(wallpaper_path) && (os_browser = browser_not_a_browser))
	if (wpaperexist) {
		if (sprite_exists(wpaper)) sprite_delete(wpaper)
		wpaper = sprite_add(wallpaper_path, 1, 0, 0, 0, 0)
		if (display_width / display_height < sprite_get_width(wpaper) / sprite_get_height(wpaper)) wpaperside = 1
		wpaperwidth = (sprite_get_width(wpaper) / sprite_get_height(wpaper)) * 720
		tempsurf = surface_create(wpaperwidth, 720)
		surface_set_target(tempsurf)
		try {
			draw_sprite_ext(wpaper, 0, 0, 0, 720 / sprite_get_height(wpaper), 720 / sprite_get_height(wpaper), 0, -1, 1)
		}
		catch(e) {
			can_draw_mica = 0
		}
		surface_reset_target()
		sprite_delete(wpaper)
		try {
			wpaper = sprite_create_from_surface(tempsurf, 0, 0, wpaperwidth, 720, 0, 1, 0, 0)
		}
		catch(e) {
			can_draw_mica = 0
		}
		surface_free(tempsurf)
		wpaperblur = sprite_create_blur_alt(wpaper, 0.25, sprite_get_width(wpaper), sprite_get_height(wpaper), 300, 8, 16)
	}
}
