function string_width_dynamic(str){
	str = string_compose_display(str)
	var o = obj_controller
	var currentfont = o.currentfont
	var length = string_length(str)
	var line_width = 0
	var max_width = 0
	var is_not_ascii_prev = -2
	var is_hires_theme = o.hires && o.theme = 3
	for (var i = 1; i <= length; i += 1) {
		var char = string_char_at(str, i)
		var char_code = ord(char)
		var is_not_ascii = is_nonascii(char_code)
		if (is_not_ascii = 1) font_src_dynamic_select(currentfont, char, char_code)
		else if (is_not_ascii != is_not_ascii_prev) draw_theme_font(currentfont, is_not_ascii)
		line_width += string_width(char) / (1 + is_hires_theme + 2 * (is_hires_theme && is_not_ascii != 1))
		if (char = "\n") {
			if (line_width >= max_width) max_width = line_width
			line_width = 0
		}
		is_not_ascii_prev = is_not_ascii
	}
	if (line_width >= max_width) max_width = line_width
	draw_theme_font(currentfont)
	return max_width
}
