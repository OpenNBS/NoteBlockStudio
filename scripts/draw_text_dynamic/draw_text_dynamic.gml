function draw_text_dynamic(x, y, string, force = false){
	// draw_text_dynamic()
	var draw_string = string_compose_display(string)

	// Skip drawing dynamic text when using English
	var o = obj_controller
	if (!force && o.language != 1) {
		if (!o.hires || o.theme != 3) draw_text(x, y, draw_string);
		else draw_text_transformed(x, y, draw_string, 0.25, 0.25, 0);
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
	var halign = draw_get_halign();
	var currentfont = o.currentfont
	var length = string_length(draw_string)
	var is_hires_theme = o.hires && o.theme = 3
	var char, char_code, is_not_ascii, draw_y, uses_dynamic_font;
	var is_not_ascii_prev = -2
	if (halign != fa_left) draw_set_halign(fa_left)
	if (halign != fa_left) {
		for (var i = 1; i <= length; i += 1) {
			char = string_char_at(draw_string, i)
			char_code = ord(char)
			is_not_ascii = is_nonascii(char_code)
			if (is_not_ascii != is_not_ascii_prev) {
				if (is_not_ascii = 1) font_src_dynamic_select(currentfont, char, char_code, true)
				else draw_theme_font(currentfont, is_not_ascii, true)
			} else if (is_not_ascii = 1) {
				font_src_dynamic_select(currentfont, char, char_code, true)
			}
			linewidth[lines] += string_width(char)
			if (char = "\n") {lines += 1 array_push(linewidth, 0)}
			is_not_ascii_prev = is_not_ascii
		}
		lines = 0
		is_not_ascii_prev = -2
	}
	var line_x = x
	if (halign = fa_center) line_x = x - floor(linewidth[0] / 2)
	else if (halign = fa_right) line_x = x - linewidth[0]
	var line_y = y
	for(var i = 1; i <= length; i += 1) {
		char = string_char_at(draw_string, i)
		char_code = ord(char)
		is_not_ascii = is_nonascii(char_code)
		uses_dynamic_font = false
		if (is_not_ascii != is_not_ascii_prev) {
			if (is_not_ascii = 1) uses_dynamic_font = font_src_dynamic_select(currentfont, char, char_code)
			else draw_theme_font(currentfont, is_not_ascii)
		} else if (is_not_ascii = 1) {
			uses_dynamic_font = font_src_dynamic_select(currentfont, char, char_code)
		}
		// Runtime font_add() rasterizes Source Han one logical pixel lower than
		// the equivalent baked fnt_src_* asset in this GameMaker runtime.
		draw_y = line_y - 1 * !(!is_not_ascii) - uses_dynamic_font
		
		if (!is_hires_theme) {
			draw_text(line_x + width, draw_y, char)
		} else {
			var scale = 0.5 - 0.25 * (is_not_ascii != 1)
			draw_text_transformed(line_x + width, draw_y, char, scale, scale, 0)
		}
		width += string_width(char) / (1 + is_hires_theme + 2 * (is_hires_theme && is_not_ascii != 1))
		if (char = "\n") {
			lines += 1
			width = 0
			line_y += 16
			if (halign = fa_center) line_x = x - floor(linewidth[lines] / 2)
			else if (halign = fa_right) line_x = x - linewidth[lines]
		}
		is_not_ascii_prev = is_not_ascii
	}
	if (halign != fa_left) draw_set_halign(halign)
	draw_theme_font(currentfont, 0)
}

function is_nonascii(char_code){
	var code = !(char_code <= 127 || char_code = 1025 || (char_code >= 1040 && char_code <= 1103) || char_code = 1105)
	if (char_code = 8679 || char_code = 8682 || char_code = 8963 || char_code = 8984 || char_code = 8997 || char_code = 9003 || char_code = 11014) code = -1
	return code
}
