function file_rename_lib(argument0, argument1) {
	// file_rename_lib(file, name)

	if (argument0 = "" || argument0 = argument1)
	    return 0

	if (os_type = os_windows) return external_call(lib_file_rename, argument0, argument1)
	else return file_rename(argument0, argument1)



}
