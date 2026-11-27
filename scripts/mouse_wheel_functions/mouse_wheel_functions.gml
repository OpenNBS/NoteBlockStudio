function mouse_wheel_down_dynamic(){
	if (os_type != os_macosx) return mouse_wheel_down()
	if (!macos_scroll_is_trackpad()) return (obj_controller.macos_scroll_temp_dy < 0)
	else return 0
}

function mouse_wheel_up_dynamic(){
	if (os_type != os_macosx) return mouse_wheel_up()
	if (!macos_scroll_is_trackpad()) return (obj_controller.macos_scroll_temp_dy > 0)
	else return 0
}