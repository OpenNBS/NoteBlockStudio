function check_ctrl(){
	if (os_type != os_macosx) return keyboard_check(vk_control)
	var command = global.nbs_mouse_state.command
	if (command >= 0) return command != 0
	return (keyboard_check(91) || keyboard_check(92))
}
