function gzzip(argument0, argument1) {
	// gzzip(file, dest)

	var destname = file_directory + filename_change_ext(filename_name(argument1), "")
	if (os_type = os_windows) {
		file_copy(argument0, destname)
		execute_program("cmd", "\"\"" + current_directory + "7za.exe\" a dummy -tgzip -so \"" + destname + "\" > \"" + argument1 + "\"" + " 2>&1\"", true)
		file_delete(destname)
	}
	else {
		execute_program("cp", "\"" + argument0 + "\" \"" + destname + "\"", true)
		execute_program("gzip", "-c \"" + destname + "\" > \"" + argument1 + "\"", true)
		execute_program("rm", "\"" + destname + "\"", true)
	}



}
