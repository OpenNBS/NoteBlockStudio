function file_exists_lib(argument0) {
	// file_exists_lib(file)

	if (argument0 = "")
	    return 0

	if (os_type = os_windows) return external_call(lib_file_exists, argument0)
	else return file_exists(argument0)



}
