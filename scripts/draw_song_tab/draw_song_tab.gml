function draw_song_tab(item, x, tabwidth, hover, close_hover, front = false) {
	var span = tabwidth - 1
	var selected = item == songs[song]
	if (theme != 3) {
		var top = 24 - 5 * (theme == 1 || theme == 2)
		var frame = 3 * (hover == 1 && !selected) + 6 * selected + 10 * theme
		var close_x = x + span - 21
		var close_y = top + 7 + 3 * (theme != 0)
		draw_sprite_ext(spr_songtab, frame, x - 2, top, 1, 1, 0, c_white, 1)
		draw_sprite_ext(spr_songtab, frame + 1, x + 2, top, (tabwidth - 5) / 4, 1, 0, c_white, 1)
		draw_sprite_ext(spr_songtab, frame + 2, x + span - 3, top, 1, 1, 0, c_white, 1)
		draw_sprite_ext(spr_frame4, close_hover + 3 * theme, close_x, close_y, 17 / 16, 1, 0, c_white, 1)
		var pressed_offset = close_hover == 2 && theme != 0
		draw_sprite_ext(spr_closetab, close_hover > 0 && theme == 0,
			close_x + 4 + pressed_offset, close_y + 4 + pressed_offset, 1, 1, 0, -1 + (theme == 1), 1)
	} else {
		var mica = wpaperexist && acrylic && can_draw_mica
		var dark_fill = mica ? !fdark : fdark
		var hover_color = dark_fill ? make_color_rgb(45, 45, 45) : make_color_rgb(233, 233, 233)
		var selected_color = dark_fill ? make_color_rgb(40, 40, 40) : make_color_rgb(249, 249, 249)
		var close_color
		if (dark_fill) close_color = selected ? (close_hover == 2 ? 3158064 : 3487029) : (close_hover == 2 ? 3487029 : 3750201)
		else close_color = selected ? (close_hover == 2 ? 15987699 : 15790320) : (close_hover == 2 ? 15000804 : 14803425)
		if (front) {
			// Keep moving tabs from showing the labels underneath.
			draw_set_alpha(tabdrag ? 1 : 1 - item.tab_progress)
			draw_set_color(fdark ? 2105376 : 15987699)
			draw_rectircle(x, 24, x + span, 57, false)
			draw_set_alpha(1)
		}
		if (mica) draw_set_alpha(0.1)
		if (hover == 1 || selected) {
			draw_set_color(selected ? selected_color : hover_color)
			draw_rectircle(x, 24 + 2 * !selected, x + span, 57, false)
		}
		if (close_hover) {
			draw_set_color(close_color)
			draw_rectircle(x + span - 35, 29, x + span - 4, 52, false)
		}
		draw_set_alpha(1)
		draw_sprite_ext(spr_closetab, 2 + item.changed, x + span - 23 + (os_type == os_windows),
			36 + (os_type == os_windows), 1, 1, 0, -1 + !fdark, 1)
	}

	draw_theme_color()
	draw_theme_font(font_main)
	var title = item.song_title
	var suffix = condstr(theme != 3 && item.changed && item.filename != "" && item.filename != "-player", "*")
	var text_width = span - 40 - 15 * (theme == 3)
	if (string_width_dynamic(title) > text_width) {
		var remaining = text_width - string_width_dynamic("..." + suffix)
		while (title != "" && string_width_dynamic(title) > remaining) {
			title = string_delete(title, string_length(title), 1)
		}
		title += "..."
	}
	draw_text_dynamic(x + 8, get_tab_texty(), title + suffix)
}
