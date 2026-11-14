function draw_abutton(argument0, argument1, lock=false) {
	// draw_abutton(x, y)
	var xx, yy, m, pressed_in;
	xx = argument0
	yy = argument1
	pressed_in = mouse_press_in_rectangle(xx, yy, 17, 18)
	m = !lock && mouse_rectangle(xx, yy, 17, 18) && sb_drag = -1 && w_isdragging = 0
	if (m) m += (nbs_mouse_check_button(mb_left) && pressed_in)
	if (hires && theme == 3) {
		var previous_color = draw_get_color()
		var border_color = fdark ? 7829367 : 8947848
		var fill_color = m == 2 ? border_color : (fdark ? 2105376 : 15987699)
		var rectircle_shader = __rectircle_begin()
		draw_set_color(fill_color)
		draw_rectircle(xx, yy, xx + 17, yy + 18, false, 8)
		if (m == 1) {
			draw_set_color(fdark ? 3355443 : 13421772)
			draw_rectircle(xx + 1, yy + 1, xx + 16, yy + 17, true, 7)
		}
		draw_set_color(border_color)
		draw_rectircle(xx, yy, xx + 17, yy + 18, true, 8)
		__rectircle_end(rectircle_shader)
		// dont use sprite for arrow
		draw_set_color(m == 2 ? c_white : (fdark ? c_ltgray : c_dkgray))
		draw_primitive_begin(pr_trianglestrip)
		draw_vertex(xx + 4, yy + 8)
		draw_vertex(xx + 5, yy + 7)
		draw_vertex(xx + 8.5, yy + 12.5)
		draw_vertex(xx + 8.5, yy + 11)
		draw_vertex(xx + 13, yy + 8)
		draw_vertex(xx + 12, yy + 7)
		draw_primitive_end()
		draw_set_color(previous_color)
	} else {
		draw_sprite(spr_button_arrow, m + 3 * theme + 3 * (fdark && theme = 3), xx, yy)
	}
	if (!lock) return (m && pressed_in && nbs_mouse_check_button_released(mb_left))



}
