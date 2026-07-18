function mouse_rectangle(argument0, argument1, argument2, argument3) {
	// mouse_rectangle(x, y, w, h)
	return (mouse_x >= argument0 && mouse_y >= argument1 && mouse_x < argument0 + argument2 && mouse_y < argument1 + argument3)
}

function mouse_press_in_rectangle(argument0, argument1, argument2, argument3) {
	// Whether the current left mouse press began in this rectangle and window.
	return (obj_controller.mousepress_window = obj_controller.window &&
		obj_controller.mousepress_x >= argument0 && obj_controller.mousepress_y >= argument1 &&
		obj_controller.mousepress_x < argument0 + argument2 && obj_controller.mousepress_y < argument1 + argument3)
}

function mouse_rectangle_click(argument0, argument1, argument2, argument3) {
	// A click is only valid when both the press and release are in the same rectangle.
	return (mouse_rectangle(argument0, argument1, argument2, argument3) &&
		mouse_press_in_rectangle(argument0, argument1, argument2, argument3) &&
		mouse_check_button_released(mb_left))
}
