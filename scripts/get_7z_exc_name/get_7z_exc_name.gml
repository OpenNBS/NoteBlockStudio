function get_7z_exc_name(){
	if (os_type = os_windows) {
		return "7za"
	} else if (os_type = os_macosx) {
		return data_directory + "7zz"
	} else {
		return "7z"
	}
}