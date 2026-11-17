function macos_is_retina(){
	return (os_type = os_macosx && get_default_window_scale() > 1.1)
}