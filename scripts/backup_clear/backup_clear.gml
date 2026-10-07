function backup_clear() {
	// backup_clear()
	// Deletes the backup files stored temporarily for auto-recovery

	var file = ""

	//if (file_exists_lib(backup_file)) {
	//	files_delete_lib(backup_file)
	//}
	while(1) {
		file = file_find_first(backup_directory + "*.nbs", 0)
		if (file = "") break
		
		if (message_yesnocancel("There are still unrecovered songs in your auto-recovery folder. Would you like to recover them the next time you open the program?\n\n(If you click 'No', these files will be deleted permanently!)", "Unsaved files")) {
			break;
		}
		
		files_delete_lib(backup_directory + file)
	}


}

function backup_delete_own_tab() {
	// A display filename is not proof of ownership: other tabs/sessions may use it.
	var path = songs[song].song_backup_path
	if (path == "") return;
	if (file_exists_lib(path)) files_delete_lib(path)
	if (!file_exists_lib(path)) songs[song].song_backup_path = ""
}

function update_backup_name() {
	// Update the label for the next snapshot. Keep the last verified file in place
	// until its replacement is ready, and do not postpone other tabs' backups.
	songs[song].song_backupname = filename_name(filename_change_ext(songs[song].filename, ".nbs"));
}

function backup_step(elapsed_minutes) {
	if (isplayer) return;
	tonextbackup -= elapsed_minutes
	if (tonextbackup > 0 || playing != 0) return;
	tonextbackup = backupmins
	if (!backup_songs()) {
		set_msg(condstr(language != 1,
			"Some songs could not be backed up. Previous recovery files were kept. Check free space and folder permissions.",
			"部分歌曲无法备份。已有的恢复文件已保留。请检查磁盘可用空间和文件夹权限。"))
	}
}

function backup_songs() {
	var succeeded = true
	for (var i = 0; i < array_length(songs); i++) {
		var source_song = songs[i]
		// Include metadata-only edits, selected notes, and songs emptied by edits.
		// An untouched blank tab must not prevent the other tabs from being saved.
		if (!source_song.changed && source_song.totalblocks == 0 && source_song.selected == 0 && source_song.song_backup_path == "") continue
		if (!backup_song(source_song)) succeeded = false
	}
	return succeeded
}

function backup_song(source_song) {
	var pending_path = ""
	var write_started = false
	try {
		if (!directory_exists_lib(backup_directory)) directory_create_lib(backup_directory)
		var source_name = source_song.filename
		if (source_name == "") source_name = source_song.song_backupname
		var stem = string_copy(filename_change_ext(filename_name(source_name), ""), 1, 48)
		var recovery_path
		do {
			source_song.song_backup_generation++
			var name = stem + " (recovery " + string(source_song.song_backupid) + "-" + string(source_song.song_backup_generation) + ").nbs"
			recovery_path = backup_directory + name
			pending_path = recovery_path + ".pending"
		} until (!file_exists_lib(recovery_path) && !file_exists_lib(pending_path) && !file_exists_lib(restore_directory + name))

		// Write to a new path: file_copy cannot replace an existing file. Pending
		// files are excluded from startup recovery until save_song verifies them.
		write_started = true
		if (save_song(pending_path, true, false, undefined, source_song)) {
			if (file_rename_lib(pending_path, recovery_path)) {
				var previous_path = source_song.song_backup_path
				source_song.song_backup_path = recovery_path
				// A crash here leaves two valid snapshots. Never delete the previous
				// one before the new file has been written, verified, and published.
				try {
					if (previous_path != "" && file_exists_lib(previous_path)) files_delete_lib(previous_path)
				} catch (e) {
					show_debug_message("Could not remove previous recovery file: " + string(e))
				}
				return true
			}
		}
	} catch (e) {
		show_debug_message("Failed to back up song: " + string(e))
	}
	if (write_started) {
		try {
			if (file_exists_lib(pending_path)) files_delete_lib(pending_path)
		} catch (e) {
			show_debug_message("Could not remove incomplete recovery file: " + string(e))
		}
	}
	return false
}
