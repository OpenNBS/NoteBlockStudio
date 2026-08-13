function draw_window() {
	// draw_window(x1, y1, x2, y2[, sml])
	window_drawn_this_frame = true
	var x1, y1, x2, y2, sml;
	x1 = argument[0]
	y1 = argument[1]
	x2 = argument[2]
	y2 = argument[3]
	sml = 0
	if (argument_count > 4) {
		sml = argument[4]
	}
	draw_set_color(15790320)
	if (theme = 1) draw_set_color(13160660)
	if (theme = 2) draw_set_color(c_dark)
	if (theme = 3 && !fdark) draw_set_color(15987699)
	if (theme = 3 && fdark) draw_set_color(2105376)
	if (theme = 3 && sml = 0) {
		if (sml = 0) {
			draw_sprite(spr_shadow, 0 + 8, x1 - 16, y1 - 16)
			draw_sprite_ext(spr_shadow, 1 + 8, x1 - 16, y1, 1, y2 - y1, 0, -1, draw_get_alpha())
			draw_sprite(spr_shadow, 2 + 8, x1 - 16, y2)
			draw_sprite_ext(spr_shadow, 3 + 8, x1, y2, x2 - x1, 1, 0, -1, draw_get_alpha())
			draw_sprite(spr_shadow, 4 + 8, x2, y2)
			draw_sprite_ext(spr_shadow, 5 + 8, x2, y1, 1, y2 - y1, 0, -1, draw_get_alpha())
			draw_sprite(spr_shadow, 6 + 8, x2, y1 - 16)
			draw_sprite_ext(spr_shadow, 7 + 8, x1, y1 - 16, x2 - x1, 1, 0, -1, draw_get_alpha())
		}
		draw_set_color(15987699)
		if (fdark) draw_set_color(2105376)
		draw_roundrect(x1, y1, x2 - 1, y2 - 1, 0)
		//draw_set_color(7368816)
		draw_set_color(4144959)
		draw_roundrect(x1, y1, x2 - 1, y2 - 1, 1)
	} else {
		draw_rectangle(x1, y1, x2 - 1, y2 - 1, 0)
		if (hires && theme = 3) gpu_set_texfilter(false)
		draw_sprite(spr_interface2, 0 + 8 * theme + 8 * (theme = 3) * fdark, x1, y1)
		draw_sprite_ext(spr_interface2, 1 + 8 * theme + 8 * (theme = 3) * fdark, x1, y1 + 2, 1, (y2 - y1 - 4) / 2, 0, -1, draw_get_alpha())
		draw_sprite(spr_interface2, 2 + 8 * theme + 8 * (theme = 3) * fdark, x1, y2 - 2)
		draw_sprite_ext(spr_interface2, 3 + 8 * theme + 8 * (theme = 3) * fdark, x1 + 2, y2 - 2, (x2 - x1 - 4) / 2, 1, 0, -1, draw_get_alpha())
		draw_sprite(spr_interface2, 4 + 8 * theme + 8 * (theme = 3) * fdark, x2 - 2, y2 - 2)
		draw_sprite_ext(spr_interface2, 5 + 8 * theme + 8 * (theme = 3) * fdark, x2 - 2, y1 + 2, 1, (y2 - y1 - 4) / 2, 0, -1, draw_get_alpha())
		draw_sprite(spr_interface2, 6 + 8 * theme + 8 * (theme = 3) * fdark, x2 - 2, y1)
		draw_sprite_ext(spr_interface2, 7 + 8 * theme + 8 * (theme = 3) * fdark, x1 + 2, y1, (x2 - x1 - 4) / 2, 1, 0, -1, draw_get_alpha())
		if (hires && theme = 3) gpu_set_texfilter(true)
	}
	draw_theme_color()


}
