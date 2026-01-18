function control_http() {
	// control_http()
	// Handles the check for updates, then attempts to download it if one is available
	
	log ("http callback")
	
	if (sound_import_download_status != pointer_null) {
		sound_import_download()
	}
	
	else if (song_download_data != pointer_null) {
		download_song_from_url()
	}

	else if (check_update && NOT_RUN_FROM_IDE && !is_development) {
		check_updates()
		get_update()
	}
}
