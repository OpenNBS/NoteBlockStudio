function window_setnormal() {
	// window_setnormal()

	if (os_type = os_windows) return external_call(lib_window_setnormal, window_handle())
	else if (macos_is_retina()) window_set_size(floor(800 * window_scale / 2), floor(500 * window_scale / 2))
	else if (os_type = os_macosx) window_set_size(floor(800 * window_scale), floor(500 * window_scale))



}
