function draw_text_dynamic(x, y, string, force = false){
	// draw_text_dynamic()

	// Skip drawing dynamic text when using English
	var o = obj_controller
	if (!force && o.language != 1) {
		if (!o.hires || o.theme != 3) draw_text(x, y, string);
		else draw_text_transformed(x, y, string, 0.25, 0.25, 0);
		return;
	}
	
	/*
	// Disable dynamic text on Chinese (use Source Han Sans for everything)
	if (obj_controller.language == 1) {
		draw_theme_font(obj_controller.currentfont, true)
	}
	draw_text(x, y - 2 * (obj_controller.language == 1), string);
	return;
	*/
	
	var width = 0;
	var lines = 0;
	var linewidth = [0];
	var totalwidth = 0;
	var longline = 0;
	var halign = draw_get_halign();
	var char, char_code, is_not_ascii, y_offset, font_changed;
	var is_not_ascii_prev = -2
	draw_set_halign(fa_left)
	if (halign != fa_left) {
		for (var i = 1; i <= string_length(string); i += 1) {
			char = string_char_at(string, i)
			char_code = ord(char)
			is_not_ascii = is_nonascii(char_code)
			font_changed = is_not_ascii != is_not_ascii_prev
			if (font_changed) {
				draw_theme_font(o.currentfont, is_not_ascii, true)
			}
			linewidth[lines] += string_width(char)
			if (char = "\n") {lines += 1 array_push(linewidth, 0)}
			is_not_ascii_prev = is_not_ascii
		}
		for (var i = 0; i <= lines; i += 1) {
			if (linewidth[i] >= linewidth[longline]) longline = i
		}
		totalwidth = linewidth[longline]
		lines = 0
		is_not_ascii_prev = -2
	}
	for(var i = 1; i <= string_length(string); i += 1) {
		char = string_char_at(string, i)
		char_code = ord(char)
		is_not_ascii = is_nonascii(char_code)
		font_changed = is_not_ascii != is_not_ascii_prev
		if (font_changed) {
			draw_theme_font(o.currentfont, is_not_ascii)
		}
		y_offset = lines * 16
		
		if (!o.hires || o.theme != 3) {
			if (halign = fa_left) draw_text (x + width, y - 1 * !(!is_not_ascii) + y_offset, char)
			else if (halign = fa_center) draw_text (x - floor(linewidth[lines] / 2) + width, y - 1 * !(!is_not_ascii) + y_offset, char)
			else if (halign = fa_right) draw_text (x - linewidth[lines] + width, y - 1 * !(!is_not_ascii) + y_offset, char)
		} else {
			if (halign = fa_left) draw_text_transformed (x + width, y - 1 * !(!is_not_ascii) + y_offset, char, 0.5 - 0.25 * (is_not_ascii != 1), 0.5 - 0.25 * (is_not_ascii != 1), 0)
			else if (halign = fa_center) draw_text_transformed (x - floor(linewidth[lines] / 2) + width, y - 1 * !(!is_not_ascii) + y_offset, char, 0.5 - 0.25 * (is_not_ascii != 1), 0.5 - 0.25 * (is_not_ascii != 1), 0)
			else if (halign = fa_right) draw_text_transformed (x - linewidth[lines] + width, y - 1 * !(!is_not_ascii) + y_offset, char, 0.5 - 0.25 * (is_not_ascii != 1), 0.5 - 0.25 * (is_not_ascii != 1), 0)
		}
		width += string_width(char) / (1 + (o.hires || o.theme != 3) * (o.theme = 3) + 2 * ((o.hires || o.theme != 3) && is_not_ascii != 1) * (o.theme = 3))
		if (char = "\n") {lines += 1 width = 0}
		is_not_ascii_prev = is_not_ascii
	}
	draw_set_halign(halign)
	draw_theme_font(o.currentfont, 0)
}

function is_nonascii(char_code){
	var code = !(char_code <= 127 || char_code = 1025 || (char_code >= 1040 && char_code <= 1103) || char_code = 1105)
	if (char_code = 8679 || char_code = 8682 || char_code = 8963 || char_code = 8984 || char_code = 8997 || char_code = 9003 || char_code = 11014) code = -1
	return code
}