function draw_radiobox() {
	// draw_radiobox(x, y, expression, str, tip[, locked])
	var xx, yy, expression, str, tip, m, lock, pressed_in;
	xx = argument[0]
	yy = argument[1]
	expression = argument[2]
	str = argument[3]
	tip = argument[4]
	lock = 0
	if (argument_count > 5)
	    lock = argument[5]
	pressed_in = mouse_press_in_rectangle(xx, yy, 12 + string_width_dynamic(str) + 8, 12)
	if (tip != "") popup_set_window(xx, yy, 12 + string_width_dynamic(str) + 8, 12, tip)
	if (!hires || theme != 3) {
		if (lock = 1) {
		    draw_sprite(spr_radiobox, 4 + expression + 6 * theme + 6 * (theme = 3) * fdark, xx, yy)
		    draw_set_color(make_color_rgb(204, 204, 204))
		    if (theme = 2 || theme = 1) {
		        draw_set_color(c_white)
		        draw_text_dynamic(xx + 19, yy, str)
		        draw_set_color(8421504)
		    }
		    draw_text_dynamic(xx + 18, yy - 1, str)
		    draw_theme_color()
		} else {
		    m = mouse_rectangle(xx, yy, 12 + string_width_dynamic(str) + 8, 12)
		    if (w_isdragging > 0) m = 0
		    if (m) m += (mouse_check_button(mb_left) && pressed_in)
		    draw_sprite(spr_radiobox, m + 6 * theme + 6 * (theme = 3) * fdark, xx, yy)
		    if (expression) draw_sprite_ext(spr_radiobox, 3 + 6 * theme, xx, yy, 1, 1, 0, accent[5] * (theme = 3) - !(theme = 3), draw_get_alpha())
		    draw_text_dynamic(xx + 18, yy - 1, str)
			if (m && pressed_in && mouse_check_button_released(mb_left) && windowsound && theme = 3 && instance_exists(obj_menu)) play_sound(soundinvoke, 45, 100, 50, 0)
		    return (m && pressed_in && mouse_check_button_released(mb_left)) * (!instance_exists(obj_menu))
		}
	} else {
		if (lock = 1) {
			if (fdark) {
				if (expression) draw_set_color(7829367)
				else draw_set_color(0)
			} else {
				if (expression) draw_set_color(8947848)
				else draw_set_color(15987699)
			}
			draw_circle(xx + 5, yy + 6, 6, 0)
			if (fdark) {
				if (expression) draw_set_color(7829367)
				else draw_set_color(3355443)
			} else {
				if (expression) draw_set_color(8947848)
				else draw_set_color(13421772)
			}
			draw_circle(xx + 5, yy + 6, 6, 1)
			if (expression) {
				if (fdark) draw_set_color(0)
				else draw_set_color(16777215)
				draw_circle(xx + 5, yy + 6, 3, 0)
			}
		    draw_set_color(make_color_rgb(204, 204, 204))
		    draw_text_dynamic(xx + 18, yy - 1, str)
		    draw_theme_color()
		} else {
		    m = mouse_rectangle(xx, yy, 12 + string_width_dynamic(str) + 8, 12)
		    if (w_isdragging > 0) m = 0
		    if (m) m += (mouse_check_button(mb_left) && pressed_in)
			if (expression) {
				draw_set_color(accent[5])
			} else {
				if (fdark) {
					if (m == 0) draw_set_color(2105376)
					if (m == 1) draw_set_color(2763306)
					if (m == 2) draw_set_color(2763306)
				} else {
					if (m == 0) draw_set_color(15987699)
					if (m == 1) draw_set_color(15066597)
					if (m == 2) draw_set_color(15066597)
				}
			}
			draw_circle(xx + 5, yy + 6, 6, 0)
			if (fdark) draw_set_color(7829367)
			else draw_set_color(8947848)
			if (!expression) draw_circle(xx + 5, yy + 6, 6, 1)
			if (fdark) {
				if (m == 2) draw_set_color(0)
				if (expression) draw_set_color(2105376)
			} else {
				if (m == 2) draw_set_color(15987699)
				if (expression) draw_set_color(15066597)
			}
			if (m == 2 || expression) draw_circle(xx + 5, yy + 6, 3 + (m == 1 && expression), 0)
			draw_theme_color()
		    draw_text_dynamic(xx + 18, yy - 1, str)
			if (m && pressed_in && mouse_check_button_released(mb_left) && windowsound && theme = 3 && instance_exists(obj_menu)) play_sound(soundinvoke, 45, 100, 50, 0)
		    return (m && pressed_in && mouse_check_button_released(mb_left)) * (!instance_exists(obj_menu))
		}
	}


}
