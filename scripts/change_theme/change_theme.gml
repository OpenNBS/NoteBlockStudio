function change_theme() {
	// change_theme()

	window_set_color(window_background)

	if (theme == 3 && acrylic && !wpaperexist) {
		wallpaper_init()
	}

}

function acrylic_startup_guard_begin() {
	var f = -1
	try {
		f = file_text_open_write(acrylic_startup_guard_file)
		if (f < 0) return false
		file_text_write_string(f, version)
		file_text_close(f)
		return true
	} catch (e) {
		if (f >= 0) {
			try {
				file_text_close(f)
			} catch (close_error) {}
		}
		return false
	}
}

function acrylic_startup_guard_clear() {
	if (!file_exists(acrylic_startup_guard_file)) return true
	return file_delete(acrylic_startup_guard_file)
}

function change_theme_startup_guarded() {
	if (theme != 3 || !acrylic || wpaperexist) {
		change_theme()
		return
	}

	// Fall back to the legacy settings guard only if the marker cannot be created.
	var marker_created = acrylic_startup_guard_begin()
	if (!marker_created) {
		acrylic_successful = 0
		save_settings()
	}

	change_theme()

	acrylic_successful = 1
	if (marker_created) acrylic_startup_guard_clear()
	else {
		save_settings()
		acrylic_startup_guard_clear()
	}
}
