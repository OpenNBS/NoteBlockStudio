function string_width_dynamic(str){
	var lines = 0;
	var linewidth = [0];
	var totalwidth = 0;
	var longline = 0;
	for (var i = 1; i <= string_length(str); i += 1) {
		draw_theme_font(obj_controller.currentfont, is_nonascii(string_ord_at(str, i)))
		linewidth[lines] += string_width(string_char_at(str, i)) / (1 + (obj_controller.hires && obj_controller.theme = 3) + 2 * (obj_controller.hires && obj_controller.theme = 3 && is_nonascii(string_ord_at(str, i)) != 1))
		if (string_char_at(str, i) = "\n") {lines += 1 array_push(linewidth, 0)}
	}
	for (var i = 0; i <= lines; i += 1) {
		if (linewidth[i] >= linewidth[longline]) longline = i
	}
	totalwidth = linewidth[longline]
	var currentfont = obj_controller.currentfont
	draw_theme_font(currentfont)
	return totalwidth
}