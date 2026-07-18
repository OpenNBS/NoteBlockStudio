function copy_bundled_directory(source, destination) {
	if (os_type = os_windows) {
		execute_program("Xcopy", @'/E /I /Y "' + filename_dir(source) + @'" "' + filename_dir(destination) + @'"', true)
	} else if (os_type = os_macosx || os_type = os_linux) {
		execute_program("cp", @'-fR "' + filename_dir(source) + @'/." "' + filename_dir(destination) + @'"', true)
	} else {
		directory_copy(source, destination)
	}
}

function copy_bundled_file(source, destination) {
	if (!file_exists(source)) return
	if (file_exists(destination)) file_delete(destination)
	file_copy(source, destination)
}

function copy_bundled_files(copy_data = true, copy_songs = true, copy_patterns = true) {
	if (copy_data) {
		directory_create(data_directory)
		copy_bundled_directory(bundled_sounds_directory, sounds_directory)
		copy_bundled_file(bundled_data_directory + "wallpaper.bat", data_directory + "wallpaper.bat")
		copy_bundled_file(bundled_data_directory + "Wallpaper.jpg", data_directory + "Wallpaper.jpg")
		copy_bundled_file(bundled_data_directory + "changelog.txt", data_directory + "changelog.txt")
	}

	// Songs and patterns intentionally stay in ~/Music on macOS.
	if (os_type != os_macosx) {
		if (copy_songs) copy_bundled_directory(bundled_songs_directory, songs_directory)
		if (copy_patterns) copy_bundled_directory(bundled_pattern_directory, pattern_directory)
	}

	show_debug_message("Copied bundled user files!")
}

function remove_legacy_copied_libraries() {
	if (os_type != os_windows) return

	var legacy_libraries = [
		"audio.dll",
		"file.dll",
		"gmbinaryfile.dll",
		"midiinput.dll",
		"window.dll"
	]

	for (var i = 0; i < array_length(legacy_libraries); i++) {
		var legacy_path = data_directory + legacy_libraries[i]
		if (file_exists(legacy_path)) file_delete(legacy_path)
	}
}
