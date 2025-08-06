function directory_create_lib(argument0) {
	// directory_create_lib(dir)

	if (os_type = os_windows) return external_call(lib_directory_create, argument0)
	else return directory_create(argument0)



}
