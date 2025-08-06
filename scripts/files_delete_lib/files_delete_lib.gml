function files_delete_lib(argument0) {
	// file_delete_lib(file, name)

	if (os_type = os_windows) return external_call(lib_file_delete, argument0)
	else return file_delete(argument0)



}
