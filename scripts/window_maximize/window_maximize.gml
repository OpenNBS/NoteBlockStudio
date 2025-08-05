function window_maximize() {
	// window_maximize()

	if (os_type = os_windows) return external_call(lib_window_maximize, window_handle())
	else window_zoom(window_handle());



}
