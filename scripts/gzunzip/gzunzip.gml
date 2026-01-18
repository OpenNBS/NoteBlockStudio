function gzunzip(argument0, argument1) {
	// gzunzip(file, dest)

	if (os_type == os_windows) {
		file_delete(argument1)
		execute_program("cmd", current_directory + "7za.exe x -tgzip \"" + argument0 + "\" -so > \"" + argument1 + "\"", true);
	} else {
		
	}



}
