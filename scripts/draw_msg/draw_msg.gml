function draw_msg(){
	draw_set_alpha(msgalpha)
	var x1, x2, y1, y2, str, fnt;
	str = msgcontent
	fnt = currentfont
	draw_theme_font(font_info_med_bold)
	var text_width = string_width_dynamic(str), text_height = string_height_dynamic(str)
	x1 = (msgx + (rw + 1) * (msgx = -1) - text_width) / 2
	x2 = (msgx + (rw + 1) * (msgx = -1) + text_width) / 2
	y1 = msgy + (rh * 0.8 + 1) * (msgy = -1)
	y2 = msgy + (rh * 0.8 + 1) * (msgy = -1) - 20
	var glass_drawn = false
	if (theme == 3 && acrylic && liquid_glass) {
		var material = liquid_glass_settings("menu", fdark, menu_glass_material)
		var glass_width = max(text_width + 20, material.corner_radius * 2)
		var glass_height = max(40, text_height + 20, material.corner_radius * 2)
		glass_drawn = draw_liquid_glass(application_surface, (x1 + x2 - glass_width) * 0.5,
			y1 - 10 - glass_height * 0.5, glass_width, glass_height, material)
	}
	if (!glass_drawn) {
		draw_set_color(7368816)
		if (theme = 3 && msgalpha >= 0.5 && acrylic) draw_surface_blur(application_surface, x1 - 10, y1 - 30, x2 - x1 + 20, 40, 12)
		var rectircle_shader = undefined
		if (theme = 3) {
			rectircle_shader = __rectircle_begin()
			draw_rectircle(x1 - 10, y1 + 10, x2 + 10, y2 - 10, 1)
		}
		draw_set_color(15790320)
		if (theme = 1) draw_set_color(13160660)
		if (theme = 2) draw_set_color(c_dark)
		if (theme = 3 && !fdark) draw_set_color(15987699)
		if (theme = 3 && fdark) draw_set_color(2105376)
		if (theme != 3) {
			draw_area(x1 - 10, y1 + 10, x2 + 10, y2 - 10)
			draw_rectangle(x1 + 2 - 10, y1 + 10, x2 - 3 + 10, y2 - 1 - 10, 0)
		} else {
			draw_set_alpha(msgalpha * (0.6 + 0.4 * !acrylic))
			draw_rectircle(x1 - 10, y1 + 10, x2 + 10, y2 - 10, 0)
			draw_set_alpha(msgalpha)
			draw_set_color(7368816)
			draw_rectircle(x1 - 10, y1 + 10, x2 + 10, y2 - 10, 1)
		}
		__rectircle_end(rectircle_shader)
		if (theme = 3 && acrylic) draw_acrylic_texture(x1 - 10, y1 - 30, x2 - x1 + 20, 40)
	}
	draw_theme_color()
	draw_text_dynamic(x1, y1 - 10 - text_height / 2, str)
	if (current_time - msgstart >= (msgtime * 1000)){
		if (msgalpha > 0) {
			msgalpha -= 1/7.5 * (30 / room_speed) * (1 / currspeed)
		} else {
			msgalpha = 0
			showmsg = 0
		}
	}
	draw_theme_font(fnt)
	draw_set_alpha(1)
}
