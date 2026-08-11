function buffer_export(argument0, argument1) {
	// buffer_export(buffer, fn)
	var expected_size = buffer_tell(argument0)

	try {
		// Never copy a stale or incomplete temporary file over the destination.
		if (file_exists_lib(temp_file)) {
			files_delete_lib(temp_file)
			if (file_exists_lib(temp_file)) return false
		}

		buffer_save(argument0, temp_file)
		if (!file_exists_lib(temp_file)) return false

		var exported_size = file_get_size(temp_file)
		if (exported_size < expected_size) return false

		if (argument1 != temp_file) files_copy_lib(temp_file, argument1)
		if (!file_exists_lib(argument1)) return false
		if (file_get_size(argument1) != exported_size) return false

		var exported_hash = sha1_file(temp_file)
		if (exported_hash == "") return false
		return sha1_file(argument1) == exported_hash
	} catch (e) {
		// Avoid writing to the log here: this path can run when the disk is full.
		show_debug_message("Failed to export buffer: " + string(e))
		return false
	}
}
