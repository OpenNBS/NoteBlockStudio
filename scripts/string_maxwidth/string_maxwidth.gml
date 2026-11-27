function string_maxwidth(argument0, argument1) {
	// string_maxwidth(str, w)
	var str, maxw, w, c, truncate_start, char, text_entry, layout, first_char, last_char;
	str = argument0
	maxw = argument1
	truncate_start = false
	if (argument_count > 2) {
		truncate_start = argument[2]
	}
	var o = obj_controller
	var currentfont = o.currentfont
	var length = string_length(str)
	w = 0
	if (truncate_start) {
		first_char = length + 1
		for (c = length; c >= 1; c -= 1) {
			char = string_char_at(str, c)
			text_entry = text_dynamic_text_get(char)
			layout = text_dynamic_layout_get(text_entry, currentfont)
			w += layout.max_width
			if (char = "\n") w = 0
			if (w > maxw) break
			first_char = c
		}
		draw_theme_font(currentfont)
		return string_copy(str, first_char, length - first_char + 1)
	} else {
		last_char = 0
		for (c = 1; c <= length; c += 1) {
			char = string_char_at(str, c)
			text_entry = text_dynamic_text_get(char)
			layout = text_dynamic_layout_get(text_entry, currentfont)
		    w += layout.max_width
		    if (char = "\n") w = 0
		    if (w > maxw) break
		    last_char = c
		}
		draw_theme_font(currentfont)
		return string_copy(str, 1, last_char)
	}
}
