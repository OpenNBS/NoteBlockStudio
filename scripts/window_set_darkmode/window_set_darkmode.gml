function window_set_darkmode() {
	// window_set_darkmode()

	if (os_type = os_windows) {
		return external_call(lib_window_set_darkmode, window_handle())
	}


}
