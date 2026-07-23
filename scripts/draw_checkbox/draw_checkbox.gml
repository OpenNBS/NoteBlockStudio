function draw_checkbox() {
	// draw_checkbox(x, y, expression, str, tip[, locked[, is_switch]])
	var xx, yy, expression, str, tip, m, lock, is_switch, x_offset, pressed_in;
	xx = argument[0]
	yy = argument[1]
	expression = argument[2]
	str = argument[3]
	tip = argument[4]
	lock = 0
	if (argument_count > 5) {
	    lock = argument[5]
	}
	if (theme == 3 && argument_count > 6) {
		is_switch = argument[6];
	} else {
		is_switch = false;
	}
	x_offset = is_switch ? 31 : 18;
	pressed_in = mouse_press_in_rectangle(xx, yy, 26 + string_width_dynamic(str) + 8, 13)
	
	if (tip != "") popup_set_window(xx, yy, 13 + string_width_dynamic(str) + 8, 13, tip)
	if (!hires || theme != 3) {
		if (lock = 1) {
			if (is_switch) {
				if (!expression) draw_sprite(spr_switch, 6 + 8 * (fdark), xx, yy)
				if (expression) draw_sprite(spr_switch, 7 + 8 * (fdark), xx, yy)
			} else {
				draw_sprite(spr_checkbox, 4 + expression + 6 * theme + 6 * (fdark) * (theme = 3), xx, yy)
				draw_set_color(make_color_rgb(204, 204, 204))
			}
			draw_set_color(make_color_rgb(204, 204, 204))			
			if (theme = 2 || theme = 1) {
			    draw_set_color(c_white)
			    draw_text_dynamic(xx + x_offset + 1, yy, str)
			    draw_set_color(8421504)
			}
			draw_text_dynamic(xx + x_offset, yy - 1, str)
			draw_theme_color()
		} else {
		
			m = mouse_rectangle(xx, yy, 26 + string_width_dynamic(str) + 8, 13)
			if (w_isdragging > 0) m = 0
			if (m) m += (mouse_check_button(mb_left) && pressed_in) * (!instance_exists(obj_menu))
			if (is_switch) {
				if (!expression) draw_sprite(spr_switch, m + 8 * (fdark), xx, yy)
				if (expression) draw_sprite_ext(spr_switch, m + 3, xx, yy, 1, 1, 0, accent[5 + 2 * (m = 1) + 3 * (m = 2)], draw_get_alpha())
			} else {
				draw_sprite(spr_checkbox, m + 6 * theme + 6 * (fdark) * (theme = 3), xx, yy)
				if (expression) draw_sprite_ext(spr_checkbox, 3 + 6 * theme, xx, yy, 1, 1, 0, accent[5 + 2 * (m = 1) + 3 * (m = 2)] * (theme = 3) - !(theme = 3), draw_get_alpha())
			}
			draw_text_dynamic(xx + x_offset, yy - 1, str)
			if (m && pressed_in && mouse_check_button_released(mb_left) && windowsound && theme = 3 && !instance_exists(obj_menu)) play_sound(soundinvoke, 45, 100, 50, 0)
			return (m && pressed_in && mouse_check_button_released(mb_left)) * (!instance_exists(obj_menu))
		}
	} else {
		if (lock = 1) {
			if (is_switch) {
				if (fdark) {
					if (expression) draw_set_color(3355443)
					else draw_set_color(0)
				} else {
					if (expression) draw_set_color(14935011)
					else draw_set_color(15987699)
				}
				draw_roundrect_ext(xx - 1, yy - 1, xx + 25, yy + 12, 12, 12, 0)
				if (fdark) draw_set_color(3684408)
				else draw_set_color(13092807)
				if (!expression) draw_roundrect_ext(xx, yy, xx + 24, yy + 11, 6 * window_scale * (window_scale > 1 && window_scale <= 2) + 6 * (window_scale <= 1) + 12 * (window_scale > 2), 6 * window_scale * (window_scale > 1 && window_scale <= 2) + 6 * (window_scale <= 1) + 12 * (window_scale > 2), 1)
				if (expression) {
					if (fdark) draw_set_color(5000268)
					else draw_set_color(13421772)
					draw_roundrect_ext(xx + 15, yy + 3, xx + 22, yy + 10, 12, 12, 0)
				} else {
					if (fdark) draw_set_color(3684408)
					else draw_set_color(13092807)
					draw_roundrect_ext(xx + 2, yy + 2, xx + 9, yy + 9, 12, 12, 0)
				}
			} else {
				if (fdark) {
					if (expression) draw_set_color(3355443)
					else draw_set_color(0)
				} else {
					if (expression) draw_set_color(8947848)
					else draw_set_color(15987699)
				}
				draw_roundrect_ext(xx - 1, yy - 1, xx + 12, yy + 12, 4, 4, 0)
				if (fdark) draw_set_color(3684408)
				else draw_set_color(13421772)
				if (!expression) draw_roundrect_ext(xx - 1, yy - 1, xx + 12, yy + 12, 2, 2, 1)
				if (expression) {
					if (fdark) {
						draw_set_color(0)
						draw_line_width(xx + 2, yy + 5, xx + 4, yy + 8, 1)
						draw_line_width(xx + 4, yy + 8, xx + 9, yy + 3, 1)
					} else {
						draw_set_color(16777215)
						draw_line_width(xx + 2, yy + 5, xx + 4, yy + 8, 1)
						draw_line_width(xx + 4, yy + 8, xx + 9, yy + 3, 1)
					}
				}
			}
			draw_set_color(make_color_rgb(204, 204, 204))	
			draw_text_dynamic(xx + x_offset, yy - 1, str)
			draw_theme_color()
		} else {
			m = mouse_rectangle(xx, yy, 26 + string_width_dynamic(str) + 8, 13)
			if (w_isdragging > 0) m = 0
			if (m) m += (mouse_check_button(mb_left) && pressed_in) * (!instance_exists(obj_menu))
			if (is_switch) {
				//if (!expression) draw_sprite(spr_switch, m + 8 * (fdark), xx, yy)
				//if (expression) draw_sprite_ext(spr_switch, m + 3, xx, yy, 1, 1, 0, accent[5 + 2 * (m = 1) + 3 * (m = 2)], draw_get_alpha())
				if (fdark) {
					if (expression) {
						draw_set_color(accent[5 + 2 * (m = 1) + 3 * (m = 2)])
					} else {
						if (m == 0) draw_set_color(2105376)
						if (m == 1) draw_set_color(2763306)
						if (m == 2) draw_set_color(3158064)
					}
				} else {
					if (expression) {
						draw_set_color(accent[5 + 2 * (m = 1) + 3 * (m = 2)])
					} else {
						if (m == 0) draw_set_color(15987699)
						if (m == 1) draw_set_color(15066597)
						if (m == 2) draw_set_color(14474460)
					}
				}
				draw_roundrect_ext(xx - 1, yy - 1, xx + 25, yy + 12, 12, 12, 0)
				if (fdark) draw_set_color(13421772)
				else draw_set_color(3355443)
				if (!expression) draw_roundrect_ext(xx, yy, xx + 24, yy + 11, 6 * window_scale * (window_scale > 1 && window_scale <= 2) + 6 * (window_scale <= 1) + 12 * (window_scale > 2), 6 * window_scale * (window_scale > 1 && window_scale <= 2) + 6 * (window_scale <= 1) + 12 * (window_scale > 2), 1)
				if (expression) {
					if (fdark) draw_set_color(2105376)
					else draw_set_color(15987699)
					draw_roundrect_ext(xx + 15 - (m == 2), yy + 2, xx + 22, yy + 9, 12, 12, 0)
				} else {
					if (fdark) draw_set_color(13421772)
					else draw_set_color(3355443)
					draw_roundrect_ext(xx + 2, yy + 2, xx + 9 + (m == 2), yy + 9, 12, 12, 0)
				}
			} else {
				//draw_sprite(spr_checkbox, m + 6 * theme + 6 * (fdark) * (theme = 3), xx, yy)
				//if (expression) draw_sprite_ext(spr_checkbox, 3 + 6 * theme, xx, yy, 1, 1, 0, accent[5 + 2 * (m = 1) + 3 * (m = 2)] * (theme = 3) - !(theme = 3), draw_get_alpha())
				if (fdark) {
					if (expression) {
						draw_set_color(accent[5 + 2 * (m = 1) + 3 * (m = 2)])
					} else {
						if (m == 0) draw_set_color(2105376)
						if (m == 1) draw_set_color(2763306)
						if (m == 2) draw_set_color(3158064)
					}
				} else {
					if (expression) {
						draw_set_color(accent[5 + 2 * (m = 1) + 3 * (m = 2)])
					} else {
						if (m == 0) draw_set_color(15987699)
						if (m == 1) draw_set_color(15066597)
						if (m == 2) draw_set_color(14474460)
					}
				}
				draw_roundrect_ext(xx - 1, yy - 1, xx + 12, yy + 12, 4, 4, 0)
				if (fdark) draw_set_color(10066329)
				else draw_set_color(8947848)
				if (m == 2) {
					if (fdark) draw_set_color(5000268)
					else draw_set_color(11711154)
				}
				if (!expression) draw_roundrect_ext(xx - 1, yy - 1, xx + 12, yy + 12, 2, 2, 1)
				if (expression) {
					if (fdark) {
						draw_set_color(2105376)
						draw_line_width(xx + 2, yy + 5, xx + 4, yy + 8, 1)
						draw_line_width(xx + 4, yy + 8, xx + 9, yy + 3, 1)
					} else {
						draw_set_color(15987699)
						draw_line_width(xx + 2, yy + 5, xx + 4, yy + 8, 1)
						draw_line_width(xx + 4, yy + 8, xx + 9, yy + 3, 1)
					}
				}
			}
			draw_theme_color()
			draw_text_dynamic(xx + x_offset, yy - 1, str)
			if (m && pressed_in && mouse_check_button_released(mb_left) && windowsound && theme = 3 && !instance_exists(obj_menu)) play_sound(soundinvoke, 45, 100, 50, 0)
			return (m && pressed_in && mouse_check_button_released(mb_left)) * (!instance_exists(obj_menu))
		}
	}
}
