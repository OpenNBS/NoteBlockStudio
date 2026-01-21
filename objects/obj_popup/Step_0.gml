if (mouse_check_button(mb_left) || keyboard_check(vk_right) || keyboard_check(vk_left) || mouse_wheel_up_dynamic() || mouse_wheel_down_dynamic()) {
    global.popup = 0
    instance_destroy()
}
if (obj_controller.window != window) {
    global.popup = 0
    instance_destroy()
}

