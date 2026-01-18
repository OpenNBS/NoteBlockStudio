function check_ctrl(){
	if (os_type != os_macosx) return keyboard_check(vk_control)
	else return (keyboard_check(91) || keyboard_check(92))
}