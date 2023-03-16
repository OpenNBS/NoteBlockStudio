function draw_dragbar(value, max, x, y, length, id, str, kstr, window){
	var a;
	var last_color = draw_get_color()
	draw_theme_color()
	if (theme = 3) {
		draw_set_color(make_color_rgb(154, 154, 154))
		if (fdark) draw_set_color(make_color_rgb(134, 134, 134))
	}
	draw_rectangle(x, y, x + length, y + 2 + (theme = 3), 0)
	draw_set_alpha(0.5 * dropalpha)
	if (theme = 3) {
		draw_rectangle(x - 1, y + 1, x + length + 1, y + 2, 0)
		draw_set_alpha(1 * dropalpha)
		draw_set_color(accent[5])
		draw_rectangle(x, y, floor(x + (value / max) * length + 0.5), y + 2 + (theme = 3), 0)
		draw_set_alpha(0.5 * dropalpha)
		draw_rectangle(x - 1, y + 1, floor(x + (value / max) * length + 0.5), y + 2, 0)
	}
	draw_set_alpha(1 * dropalpha)
	a = ((mouse_rectangle(x + (value / max) * length - 6, y + 1 - 6, 13, 13) || mouse_rectangle(x - 3, y + 1 - 3, length + 6, 6 + (theme = 3))) && window = obj_controller.window)
	if (theme != 3) {
		draw_sprite(spr_icons, 9, x + (value / max) * length - 12, y + 1 - 11)
	} else {
		draw_set_color(c_white)
		if (fdark) draw_set_color(make_color_rgb(69, 69, 69))
		draw_set_alpha(0.5 * dropalpha)
		draw_circle(floor(x + (value / max) * length + 0.5), y + 1, 11, 0)
		draw_set_alpha(1 * dropalpha)
		draw_circle(floor(x + (value / max) * length + 0.5), y + 1, 10, 0)
		draw_set_color(accent[5 + (mouse_rectangle(x + (value / max) * length - 6, y + 1 - 6, 13, 13) * (!mouse_check_button(mb_left)) - ((mouse_rectangle(x + (value / max) * length - 6, y + 1 - 6, 13, 13) || aa = id) && mouse_check_button(mb_left))) * (window = obj_controller.window)])
		draw_set_alpha(0.5 * dropalpha)
		draw_circle(floor(x + (value / max) * length + 0.5), y + 1, 6 + (mouse_rectangle(x + (value / max) * length - 6, y + 1 - 6, 13, 13) * (!mouse_check_button(mb_left)) - ((mouse_rectangle(x + (value / max) * length - 6, y + 1 - 6, 13, 13) || aa = id) && mouse_check_button(mb_left))) * (window = obj_controller.window), 0)
		draw_set_alpha(1 * dropalpha)
		draw_circle(floor(x + (value / max) * length + 0.5), y + 1, 5 + (mouse_rectangle(x + (value / max) * length - 6, y + 1 - 6, 13, 13) * (!mouse_check_button(mb_left)) - ((mouse_rectangle(x + (value / max) * length - 6, y + 1 - 6, 13, 13) || aa = id) && mouse_check_button(mb_left))) * (window = obj_controller.window), 0)
	}
	draw_theme_color()
	if (a || aa = id) {
		curs = cr_handpoint
		if (mouse_check_button(mb_left) && (aa = id || aa = 0)) {
			curs = cr_drag
			aa = id
			if (mouse_x >= x && mouse_x <= x + length) {
				value = ((mouse_x - x) / length) * max
			} else if (mouse_x <= x) {
				value = 0
			} else if (mouse_x >= x + length) {
				value = max
			}
		}
		if (mouse_check_button_released(mb_left)) aa = 0
	}
	draw_set_color(last_color)
	
	if (window = 0) {
		if (mouse_rectangle(x + (value / max) * length - 6, y + 1 - 6, 13, 13) && window = obj_controller.window) {
			draw_popup(mouse_x, y + 20, kstr, true)
		} else if (a || aa = id) {
			draw_popup(mouse_x, y + 20, str, true)
		}
	}
	
	return value;
}