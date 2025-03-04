function gzzip(argument0, argument1) {
	// gzzip(file, dest)

	if (os_type = os_windows) return external_call(lib_gzzip, argument0, argument1)
	else {
		var destname = file_directory + filename_change_ext(filename_name(argument1), "")
		var destext = filename_ext(argument1)
		execute_program("cp", "\"" + argument0 + "\" \"" + destname + "\"", true)
		//if (os_type = os_linux) execute_program(get_7z_exc_name(), "a dummy -tgzip -so \"" + destname + "\" > \"" + argument1 + "\"", true)
		execute_program("gzip", "-c \"" + destname + "\" > \"" + argument1 + "\"", true)
		execute_program("rm", "\"" + destname + "\"", true)
	}



}
