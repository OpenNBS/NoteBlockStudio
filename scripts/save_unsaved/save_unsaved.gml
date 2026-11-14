function save_unsaved() {
	// Save a fresh shutdown recovery file. Return its path only after verification.
	// Keep the existing backup: it may be the only good copy if this write fails.
	if (isplayer || !songs[song].changed) return ""
	var recovery_path = ""
	var recovery_write_started = false
	try {
		playing = 0
		if (!directory_exists_lib(backup_directory)) directory_create_lib(backup_directory)
		var source_name = songs[song].filename
		if (source_name == "") source_name = songs[song].song_backupname
		var recovery_stem = string_copy(filename_change_ext(filename_name(source_name), ""), 1, 48) + " (unsaved on exit)"
		recovery_path = backup_directory + recovery_stem + ".nbs"
		var recovery_number = 2
		// Avoid names already moved to restored/ by an earlier recovery as well.
		while (file_exists_lib(recovery_path) || file_exists_lib(restore_directory + filename_name(recovery_path))) {
			recovery_path = backup_directory + recovery_stem + " " + string(recovery_number) + ".nbs"
			recovery_number++
		}
		// Selected/moved notes are stored outside the song grid until placed.
		if (songs[song].selected > 0) selection_place(0)
		recovery_write_started = true
		if (save_song(recovery_path, true)) return recovery_path
	} catch (e) {
		show_debug_message("Failed to save shutdown recovery: " + string(e))
	}
	// Do not offer a partial new file as a successful recovery on the next launch.
	if (recovery_write_started) {
		try {
			if (file_exists_lib(recovery_path)) files_delete_lib(recovery_path)
		} catch (e) {
			show_debug_message("Failed to remove incomplete shutdown recovery: " + string(e))
		}
	}
	return ""
}
