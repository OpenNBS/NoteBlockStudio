function draw_logs_overlay(width, lines){
	var tempalpha = draw_get_alpha()
	var lineheight = 17
	var height = lines * lineheight
	draw_set_alpha(0.5)
	draw_set_color(0)
	draw_rectangle(rw - width, rh - height, rw, rh, 0)
	draw_set_alpha(1)
	draw_theme_font(0, 0)
	draw_set_color(c_white)
	for (var i = 1; i <= lines; i++) {
		var line_lines = []
		line_lines[0] = ""
		var line_str = log_strs[array_length(log_strs) - i]
		var current_line = 0
		draw_theme_font(0, 0, 1)
		for (var j = 1; j <= string_length(line_str); j++) {
			if (string_width(line_lines[current_line] + string_char_at(line_str, j)) > width - 7) {
				current_line++
				line_lines[current_line] = ""
			}
			line_lines[current_line] += string_char_at(line_str, j)
		}
		draw_theme_font(0, 0)
		for (var j = 0; j <= current_line; j++) {
			if (i - j + current_line <= lines) {
				if (!hires || theme != 3) draw_text(rw - width + 3, rh - lineheight * (i - j + current_line) + 2, line_lines[j])
				else draw_text_transformed(rw - width + 3, rh - lineheight * (i - j + current_line) + 2, line_lines[j], 0.25, 0.25, 0)
			}
		}
		i += current_line
	}
	draw_set_alpha(tempalpha)
}