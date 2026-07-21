function string_width_dynamic(str){
	str = string_compose_display(str)
	var lines = 0;
	var linewidth = [0];
	var totalwidth = 0;
	var longline = 0;
	for (var i = 1; i <= string_length(str); i += 1) {
		var char = string_char_at(str, i)
		var char_code = ord(char)
		var is_not_ascii = is_nonascii(char_code)
		if (is_not_ascii = 1) font_src_dynamic_select(obj_controller.currentfont, char, char_code)
		else draw_theme_font(obj_controller.currentfont, is_not_ascii)
		linewidth[lines] += string_width(char) / (1 + (obj_controller.hires && obj_controller.theme = 3) + 2 * (obj_controller.hires && obj_controller.theme = 3 && is_not_ascii != 1))
		if (char = "\n") {lines += 1 array_push(linewidth, 0)}
	}
	for (var i = 0; i <= lines; i += 1) {
		if (linewidth[i] >= linewidth[longline]) longline = i
	}
	totalwidth = linewidth[longline]
	var currentfont = obj_controller.currentfont
	draw_theme_font(currentfont)
	return totalwidth
}
