function draw_text_dynamic(x, y, string, force = false){
	// draw_text_dynamic()
	var text_entry = text_dynamic_text_get(string)
	var draw_string = text_entry.text

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
	var is_hires_theme = o.hires && o.theme = 3
	var align_layout = undefined
	if (halign != fa_left) draw_set_halign(fa_left)
	if (halign != fa_left) {
		align_layout = text_dynamic_layout_get(text_entry, currentfont, true)
		linewidth = align_layout.line_widths
	}
	var layout = text_dynamic_layout_get(text_entry, currentfont)
	var length = layout.length
	var line_x = x
	if (halign = fa_center) line_x = x - floor(linewidth[0] / 2)
	else if (halign = fa_right) line_x = x - linewidth[0]
	var line_y = y
	var selected_font = draw_get_font()
	for(var i = 0; i < length; i += 1) {
		var char = text_entry.chars[i]
		var is_not_ascii = text_entry.categories[i]
		var font = layout.fonts[i]
		if (selected_font != font) {
			draw_set_font(font)
			selected_font = font
		}
		// Runtime font_add() rasterizes Source Han one logical pixel lower than
		// the equivalent baked fnt_src_* asset in this GameMaker runtime.
		var draw_y = line_y - 1 * !(!is_not_ascii) - layout.dynamic_fonts[i]
		
		if (!is_hires_theme) {
			draw_text(line_x + width, draw_y, char)
		} else {
			var scale = 0.5 - 0.25 * (is_not_ascii != 1)
			draw_text_transformed(line_x + width, draw_y, char, scale, scale, 0)
		}
		width += layout.widths[i] / (1 + is_hires_theme + 2 * (is_hires_theme && is_not_ascii != 1))
		if (char = "\n") {
			lines += 1
			width = 0
			line_y += 16
			if (halign = fa_center) line_x = x - floor(linewidth[lines] / 2)
			else if (halign = fa_right) line_x = x - linewidth[lines]
		}
	}
	if (halign != fa_left) draw_set_halign(halign)
	draw_theme_font(currentfont, 0)
}

function is_nonascii(char_code){
	var code = !(char_code <= 127 || char_code = 1025 || (char_code >= 1040 && char_code <= 1103) || char_code = 1105)
	if (char_code = 8679 || char_code = 8682 || char_code = 8963 || char_code = 8984 || char_code = 8997 || char_code = 9003 || char_code = 11014) code = -1
	return code
}
