function get_os_type_string(){
	switch(os_type) {
		case os_windows: {
			return "Windows"
			break
		}
		case os_macosx: {
			return "macOS"
			break
		}
		case os_linux: {
			return "GNU/Linux"
			break
		}
		default: {
			return "Other OS"
			break
		}
	}
}