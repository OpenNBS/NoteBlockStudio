function window_setnormal() {
	// window_setnormal()

	if (os_type = os_windows) return external_call(lib_window_setnormal, window_handle())
	else window_set_size(floor(800 * window_scale), floor(500 * window_scale))



}
