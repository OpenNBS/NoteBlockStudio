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

function backup_restore_candidates() {
	// Close the search before copying/deleting files or opening native dialogs.
	// This fixed list also keeps backups created later out of this restore pass.
	var files = []
	var file_name = file_find_first(backup_directory + "*.nbs", 0)
	while (file_name != "") {
		array_push(files, file_name)
		file_name = file_find_next()
	}
	file_find_close()
	return files
}

function backup_restore_matches(path, expected_size, expected_hash) {
	if (expected_hash == "" || !file_exists_lib(path)) return false
	if (file_get_size(path) != expected_size) return false
	return sha1_file(path) == expected_hash
}

function backup_restore_file(file_name) {
	var result = { restored: false, source_kept: true }
	var source_path = backup_directory + file_name
	var pending_path = ""
	var write_started = false
	try {
		if (!file_exists_lib(source_path)) return result
		var expected_size = file_get_size(source_path)
		var expected_hash = sha1_file(source_path)
		if (expected_hash == "") return result
		if (!directory_exists_lib(restore_directory)) directory_create_lib(restore_directory)
		if (!directory_exists_lib(restore_directory)) return result

		// Keep incomplete copies out of the restored songs. Use a short staging
		// name so even a source filename at the filesystem limit can be restored.
		var stem = string_copy(filename_change_ext(file_name, ""), 1, 48)
		var suffix = 1
		do {
			pending_path = restore_directory + stem + " (restoring " + string(suffix) + ").pending"
			suffix++
		} until (!file_exists_lib(pending_path) && !directory_exists_lib(pending_path))
		write_started = true
		files_copy_lib(source_path, pending_path)
		if (backup_restore_matches(pending_path, expected_size, expected_hash)) {
			// Existing restored songs may contain different/newer user work.
			// Never overwrite them, even when their names match the backup.
			var destination = restore_directory + file_name
			suffix = 2
			while (file_exists_lib(destination) || directory_exists_lib(destination)) {
				destination = restore_directory + stem + " (restored " + string(suffix) + ").nbs"
				suffix++
			}
			if (file_rename_lib(pending_path, destination)) {
				write_started = false
				if (backup_restore_matches(destination, expected_size, expected_hash)) {
					result.restored = true
					// Delete only this verified source, and only if it still contains
					// the same bytes. A changed source must remain for the next pass.
					if (backup_restore_matches(source_path, expected_size, expected_hash)) files_delete_lib(source_path)
					result.source_kept = file_exists_lib(source_path)
				}
			}
		}
	} catch (e) {
		// Recovery must also work when logging would fail on a full disk.
		show_debug_message("Failed to restore backup " + file_name + ": " + string(e))
	}
	if (write_started) {
		try {
			if (file_exists_lib(pending_path)) files_delete_lib(pending_path)
		} catch (e) {
			show_debug_message("Could not remove incomplete restored copy: " + string(e))
		}
	}
	return result
}

function backup_restore_files(files) {
	var result = { restored_count: 0, retained_count: 0, failed_files: [] }
	for (var i = 0; i < array_length(files); i++) {
		var restored_file = backup_restore_file(files[i])
		if (restored_file.restored) {
			result.restored_count++
			if (restored_file.source_kept) result.retained_count++
		} else {
			array_push(result.failed_files, files[i])
		}
	}
	return result
}

function backup_restore_report(result) {
	var text = condstr(language != 1,
		string(result.restored_count) + condstr(result.restored_count == 1, " file has been restored.", " files have been restored."),
		string(result.restored_count) + " 个文件已恢复。")
	if (array_length(result.failed_files) > 0) {
		text += condstr(language != 1,
			"\n\nThese files could not be restored. Their original backups have not been deleted:\n",
			"\n\n以下文件无法恢复，原始备份未被删除：\n")
		for (var i = 0; i < array_length(result.failed_files); i++) text += "\n" + result.failed_files[i]
		text += condstr(language != 1,
			"\n\nRecovery folder: " + backup_directory + "\nCheck free space and folder permissions, then try again the next time you open Note Block Studio.",
			"\n\n恢复文件夹：" + backup_directory + "\n请检查磁盘可用空间和文件夹权限，下次打开 Note Block Studio 时重试。")
	}
	if (result.retained_count > 0) {
		text += condstr(language != 1,
			"\n\n" + string(result.retained_count) + " original backups were kept because they changed or could not be removed. They may be offered for recovery again.",
			"\n\n" + string(result.retained_count) + " 个原始备份因内容发生变化或无法删除而被保留。下次启动时可能会再次提示恢复。")
	}
	// message() writes a log entry, which may fail for the same full-disk error.
	widget_set_caption(condstr(language != 1, "Auto-recovery", "自动恢复"))
	show_message(text)
	if (result.restored_count > 0) open_url(restore_directory)
	else if (array_length(result.failed_files) > 0) open_url(backup_directory)
}
