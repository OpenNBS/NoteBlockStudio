function draw_navigationview(x, y, labels, selected, count = -1) {
	var o = obj_controller
	if (count < 0) count = array_length(labels)
	var result = -1
	var active = o.windowopen == 1 && !o.windowclose && o.wmenu == 0
		&& !instance_exists(obj_menu) && o.w_isdragging == 0
	var previous_font = draw_get_font()
	var previous_type = o.currentfont
	var previous_color = draw_get_color()
	var previous_halign = draw_get_halign()
	var previous_valign = draw_get_valign()
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_theme_font(font_med)

	var hover = active && mouse_rectangle(x, y, 40, 40)
	var pressed = hover && nbs_mouse_check_button(mb_left) && mouse_press_in_rectangle(x, y, 40, 40)
	if (hover) {
		draw_set_color(o.fdark ? 4539717 : 15395562)
		if (pressed) draw_set_color(o.fdark ? 5789784 : 15658734)
		draw_rectircle(x + 1, y + 1, x + 41, y + 37, false)
		if (mouse_rectangle_click(x, y, 40, 40)) {
			if (o.windowsound) play_sound(soundgoback, 45, 100, 100, 0)
			// Use the dialog's existing Cancel cleanup.
			o.window_escape_pressed = true
			o.window_enter_pressed = false
		}
	}
	var scale = o.hires ? 0.25 : 1
	draw_sprite_ext(o.hires ? spr_back_hires : spr_back, o.fdark + 2 * pressed,
		x + 14, y + 12, scale, scale, 0, c_white, draw_get_alpha())

	var item_x = x + 40
	for (var i = 0; i < count; i++) {
		var width = string_width_dynamic(labels[i])
		hover = active && mouse_rectangle(item_x, y, width + 12, 39)
		pressed = hover && nbs_mouse_check_button(mb_left)
			&& mouse_press_in_rectangle(item_x, y, width + 12, 39)
		if (selected == i) {
			draw_sprite_ext(spr_tabsel, 2 * o.hires, item_x + width / 2 - 1, y + 33,
				scale, scale, 0, o.accent[4], draw_get_alpha())
		}
		draw_theme_color()
		if (pressed || (hover && selected == i)) draw_set_color(o.fdark ? 11579568 : 7631988)
		if (pressed && selected == i) draw_set_color(o.fdark ? 10724259 : 10000536)
		draw_text_dynamic(item_x + 6, y + 13, labels[i])
		if (hover && mouse_rectangle_click(item_x, y, width + 12, 39)) result = i
		item_x += width + 12
	}

	draw_set_font(previous_font)
	o.currentfont = previous_type
	draw_set_color(previous_color)
	draw_set_halign(previous_halign)
	draw_set_valign(previous_valign)
	return result
}
