function directory_exists_lib(argument0) {
	// directory_exists_lib(dir)

	if (argument0 = "")
	    return 0

	if (os_type = os_windows) return external_call(lib_directory_exists, argument0)
	else return directory_exists(argument0)



}
