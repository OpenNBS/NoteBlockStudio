function open_song_zip(filename) {

	var dst_path = temp_directory + "nbs\\";
	
	if (directory_exists_lib(dst_path)) {
		directory_delete_lib(dst_path);
	}

	var output = zip_unzip(filename, dst_path);
	if (output < 0) {
		throw("This doesn't appear to be a valid ZIP file!")
	}
	
	var song_path = dst_path + "song.nbs";
	var sounds_path = dst_path + "sounds\\";
	
	if (!file_exists_lib(song_path)) {
		throw("This is not a valid zipped song file!");
	}
	
	open_song_nbs(song_path, sounds_path);
}