function directory_delete_lib(argument0) {
	// directory_delete_lib(dir)

	if (os_type = os_windows) return external_call(lib_directory_delete, argument0)
	else return directory_destroy(argument0)



}
