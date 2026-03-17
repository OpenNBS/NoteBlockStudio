function copy_bundled_files(){
	if (os_type = os_linux) {
		execute_program("cp", @'-fR "' + filename_dir(bundled_data_directory) + @'/." "' + filename_dir(data_directory) + @'"', true)
		execute_program("cp", @'-fR "' + filename_dir(bundled_songs_directory) + @'/." "' + filename_dir(songs_directory) + @'"', true)
		execute_program("cp", @'-fR "' + filename_dir(bundled_pattern_directory) + @'/." "' + filename_dir(pattern_directory) + @'"', true)
	} else if (os_type = os_macosx) {
		execute_program("cp", @'-fR "' + filename_dir(bundled_data_directory) + @'." "' + filename_dir(data_directory) + @'"', true)
	} else {
		execute_program("Xcopy", @'/E /I /Y "' + filename_dir(bundled_data_directory) + @'" "' + filename_dir(data_directory) + @'"', true)
		execute_program("Xcopy", @'/E /I /Y "' + filename_dir(bundled_songs_directory) + @'" "' + filename_dir(songs_directory) + @'"', true)
		execute_program("Xcopy", @'/E /I /Y "' + filename_dir(bundled_pattern_directory) + @'" "' + filename_dir(pattern_directory) + @'"', true)
	}
	log("Copied bundled files!")
}