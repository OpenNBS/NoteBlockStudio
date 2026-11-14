function update_window_icon(){
	if (icon_display && os_type = os_windows) {
		if (window_icon) window_set_icon_raw(window_handle(), buffer_get_address(icon_buffer), buffer_get_address(icon_size_buffer))
		else window_reset_icon_raw(window_handle())
	}
}