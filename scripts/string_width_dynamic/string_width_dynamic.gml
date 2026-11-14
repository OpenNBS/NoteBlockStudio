function string_width_dynamic(str){
	var o = obj_controller
	var currentfont = o.currentfont
	var text_entry = text_dynamic_text_get(str)
	var layout = text_dynamic_layout_get(text_entry, currentfont)
	draw_theme_font(currentfont)
	return layout.max_width
}
