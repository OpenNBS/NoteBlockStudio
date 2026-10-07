/// @description  control_end()
/// @function  control_end
function control_end() {
	
	if (!destroy_self) {
		var clear_backups = quit_confirmed
		if (!quit_confirmed) {
			clear_backups = true
			for (var i = array_length(songs) - 1; i >= 0; i--) {
				set_song(i)
				if (!confirm_shutdown_song()) clear_backups = false
			}
		}
		// Finish every save decision before deleting anything. Two tabs can share
		// a backup name, so retain all existing backups if any song needs recovery.
		for (var i = array_length(songs) - 1; i >= 0; i--) {
			set_song(i)
			if (!isplayer && clear_backups) backup_delete_own_tab()
			close_song(i, 1, 1)
		}
	
		save_settings()
	}
	font_src_dynamic_shutdown()
	surface_effects_shutdown()
	if (variable_instance_exists(id, "wpaperblur") && sprite_exists(wpaperblur) && wpaperblur != wpaper) sprite_delete(wpaperblur)
	if (variable_instance_exists(id, "wpaper") && sprite_exists(wpaper)) sprite_delete(wpaper)
	nbs_mouse_shutdown()
	rtmidi_deinit()
	log_flush()
	if (variable_instance_exists(id, "python_initialized") && python_initialized) {
		_python_finalize()
		python_initialized = false
	}

}

function confirm_quit() {
	// Call before game_end(), while Cancel and a failed save can keep NBS open.
	if (destroy_self || isplayer) return true
	if (quit_prompting) return false
	quit_prompting = true
	var previous_song = song
	var can_quit = true
	try {
		for (var i = array_length(songs) - 1; i >= 0; i--) {
			set_song(i)
			if (confirm(true, i, true) < 0) {
				can_quit = false
				break
			}
		}
	} catch (e) {
		can_quit = false
		show_debug_message("Failed to prepare to quit: " + string(e))
		// Avoid message(), which writes to the log and can fail on a full disk.
		widget_set_caption(condstr(language != 1, "Save failed", "保存失败"))
		show_message(condstr(language != 1,
			"The song could not be saved. Note Block Studio will stay open so you can try saving to another location.",
			"歌曲无法保存。Note Block Studio 将保持打开，以便你尝试保存到其他位置。"))
	}
	quit_prompting = false
	if (can_quit) set_song(previous_song)
	return can_quit
}

function request_quit() {
	if (!confirm_quit()) {
		if (os_type == os_macosx) macos_quit_reply(false)
		return false
	}
	quit_confirmed = true
	if (os_type == os_macosx) macos_quit_reply(true)
	game_end()
	return true
}

function confirm_shutdown_song() {
	// Native window/app closes can reach Game End without request_quit().
	// Returning from Game End cannot cancel that exit, so preserve failed saves.
	var result = -1
	try {
		result = confirm(true)
	} catch (e) {
		show_debug_message("Failed to save during shutdown: " + string(e))
	}
	if (result >= 0 || !songs[song].changed) return true

	while (true) {
		var recovery_path = save_unsaved()
		if (recovery_path != "") {
			widget_set_caption(condstr(language != 1, "Unsaved song recovered", "已保留未保存的歌曲"))
			show_message(condstr(language != 1,
				"Note Block Studio is already closing. Your unsaved changes were saved to this recovery file:\n\n" + recovery_path + "\n\nYou can recover it the next time you open Note Block Studio.",
				"Note Block Studio 已进入退出流程。你的未保存更改已保存到以下恢复文件：\n\n" + recovery_path + "\n\n下次打开 Note Block Studio 时可以恢复此文件。"))
			return false
		}

		// If neither save destination is writable, give the user a chance to free
		// space or choose another location before explicitly discarding this work.
		var retry_save = question(condstr(language != 1,
			"Note Block Studio is already closing, but this song and a new recovery copy could not be saved.\n\nTry saving to another location?\n\nChoose No to exit without the latest changes. Existing recovery files will be kept.",
			"Note Block Studio 已进入退出流程，但无法保存此歌曲，也无法创建新的恢复副本。\n\n是否尝试保存到其他位置？\n\n选择“No”将退出并放弃最新更改。已有的恢复文件将被保留。"),
			condstr(language != 1, "Song not saved", "歌曲尚未保存"))
		if (!retry_save) return false
		try {
			if (save_song("")) return true
		} catch (e) {
			show_debug_message("Failed to retry save during shutdown: " + string(e))
		}
	}
}
