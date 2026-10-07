function buffer_export(argument0, argument1) {
	// buffer_export(buffer, fn)
	var staged_path = ""
	var previous_path = ""
	var write_started = false
	var previous_moved = false
	var replacement_installed = false
	var succeeded = false

	try {
		// Verify exactly the bytes written, excluding unused buffer capacity.
		var expected_size = buffer_tell(argument0)
		var expected_hash = buffer_sha1(argument0, 0, expected_size)
		if (expected_hash == "") return false

		// Stage beside the destination so every rename stays on the same volume.
		// Leave files from an interrupted save alone, including its previous copy.
		var stem = filename_path(argument1) + string_copy(filename_name(argument1), 1, 48)
		var suffix = 1
		do {
			staged_path = stem + " (saving " + string(suffix) + ").tmp"
			previous_path = stem + " (previous " + string(suffix) + ").bak"
			suffix++
		} until (staged_path != argument1 && previous_path != argument1
			&& !file_exists_lib(staged_path) && !directory_exists_lib(staged_path)
			&& !file_exists_lib(previous_path) && !directory_exists_lib(previous_path))

		write_started = true
		buffer_save_ext(argument0, staged_path, 0, expected_size)
		if (buffer_export_matches(staged_path, expected_size, expected_hash)) {
			var ready = true
			if (file_exists_lib(argument1)) {
				previous_moved = file_rename_lib(argument1, previous_path)
				ready = previous_moved
			}
			if (ready) {
				replacement_installed = file_rename_lib(staged_path, argument1)
				if (replacement_installed) succeeded = buffer_export_matches(argument1, expected_size, expected_hash)
			}
		}
	} catch (e) {
		// Avoid writing to the log here: this path can run when the disk is full.
		show_debug_message("Failed to export buffer: " + string(e))
	}

	if (!succeeded) {
		try {
			if (replacement_installed) files_delete_lib(argument1)
			if (previous_moved && !file_rename_lib(previous_path, argument1)) {
				show_debug_message("Could not restore previous file. It remains at: " + previous_path)
			}
		} catch (e) {
			show_debug_message("Failed to roll back save. Previous file: " + previous_path + ". " + string(e))
		}
	}

	// Delete the previous copy only after the installed file has been verified.
	// Cleanup failure must not turn a successful save into a reported failure.
	try {
		if (succeeded && previous_moved) files_delete_lib(previous_path)
		if (write_started && file_exists_lib(staged_path)) files_delete_lib(staged_path)
	} catch (e) {
		show_debug_message("Could not clean up save files: " + string(e))
	}
	return succeeded
}

function buffer_export_matches(path, expected_size, expected_hash) {
	if (!file_exists_lib(path) || file_get_size(path) != expected_size) return false
	return sha1_file(path) == expected_hash
}
