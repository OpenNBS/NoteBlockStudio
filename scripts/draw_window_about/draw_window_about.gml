function draw_window_about() {
	// draw_window_stats()
	var x1, y1, a;
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	x1 = floor(rw / 2 - 290)
	y1 = floor(rh / 2 - 205) + windowoffset
	draw_window(x1, y1, x1 + 580, y1 + 410)
	draw_theme_font(font_main)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "About")
	else draw_text_dynamic(x1 + 8, y1 + 8, "关于")
	draw_sprite_ext(spr_logo, window_icon, x1 + 80, y1 + 50, 1, 1, 0, c_white, draw_get_alpha())
	draw_set_halign(fa_center)
	draw_theme_font(font_info_med_bold)
	draw_text_dynamic(x1 + 150, y1 + 200, "Note Block Studio")
	draw_theme_font(font_main)
	if (language != 1) {
	if (NOT_RUN_FROM_IDE != 1){
		draw_text_dynamic(x1 + 150, y1 + 217, "Version Local Release" + "\n\nThis program is a continuation of\n Minecraft Note Block Studio, \ncreated by David Andrei. \n\nThis product is not affiliated with\nMojang Studios, Microsoft Studios\nor the game Minecraft.")
	} else {
		draw_text_dynamic(x1 + 150, y1 + 217, "Version " + version + " - Released " + version_date + "\n\nThis program is a continuation of\n Minecraft Note Block Studio, \ncreated by David Andrei. \n\nThis product is not affiliated with\nMojang Studios, Microsoft Studios\nor the game Minecraft.")
	}
	} else {
	if (NOT_RUN_FROM_IDE != 1){
		draw_text_dynamic(x1 + 150, y1 + 217, "本地版本" + "\n\n本程序是 Minecraft Note Block Studio 的延续版本\n原作者 David Andrei\n\n本产品与 Mojang Studios、\nMicrosoft Studios 以及\n游戏 Minecraft 无任何关联。")
	} else {
		draw_text_dynamic(x1 + 150, y1 + 217, "版本" + version + " - 发布于" + version_date + "\n\n本程序是 Minecraft Note Block Studio 的延续版本\n原作者 David Andrei\n\n本产品与 Mojang Studios、\nMicrosoft Studios 以及\n游戏 Minecraft 无任何关联。")
	}
	}
	draw_set_halign(fa_left)
	
	// Credits box
	var xx, yy, w, n, fullstr, str, strb, strurl;
	fullstr = creditsstr;
	xx = x1 + 295
	yy = y1 + 35
	w = 260
	draw_area(xx, yy, xx + w, yy + 322)
	n = string_count("\n", fullstr)
	for (a = 0; a < n; a += 1) {
	    str[a] = string_copy(fullstr, 1, string_pos("\n", fullstr) - 1)
	    strb[a] = 0
		strurl[a] = ""
	    if (string_char_at(str[a], 1) = "*") { // Title
			strb[a] = 1
			str[a] = string_delete(str[a], 1, 1);
		}
		if (string_pos("|", str[a]) > 0) { // Hyperlink
			var split = string_pos("|", str[a])
			strurl[a] = string_copy(str[a], split + 1, string_length(str[a]) - split - 1)
			str[a] = string_copy(str[a], 1, split - 1)
		}
	    fullstr = string_delete(fullstr, 1, string_pos("\n", fullstr))
	}
	for (a = sb_val[credits_scrollbar]; a < sb_val[credits_scrollbar] + 19; a += 1) {
	    if (a >= n) break
		
		var xx2 = xx + (w/2)
		var yy2 = yy + 9 + 16 * (a - sb_val[credits_scrollbar])
		
	    if (strb[a]) {
			draw_theme_font(font_main_bold)
		} else {
			draw_theme_font(font_main)
		}
		draw_set_halign(fa_center)
		
		if (strurl[a] != "") {
			draw_text_url(xx2, yy2, str[a], strurl[a])
		} else {
			if (!hires || obj_controller.theme != 3) draw_text(xx2, yy2, str[a])
			else draw_text_transformed(xx2, yy2, str[a], 0.25, 0.25, 0)
		}
	}
	draw_theme_font(font_main) 
	draw_scrollbar(credits_scrollbar, xx + w - 17, yy + 1, 16, 18, n, 0, 1)
	draw_set_halign(fa_left)
	// End credits box

	if (draw_button2(x1 + 8, y1 + 380, 72, condstr(language != 1, "Website", "官方网站"), false, true)) {
		open_url(link_website)
	}
	if (draw_button2(x1 + 84, y1 + 380, 72, condstr(language != 1, "GitHub", "GitHub"), false, true)) {
		open_url(link_github)
	}
	if (draw_button2(x1 + 160, y1 + 380, 72, condstr(language != 1, "Discord", "Discord"), false, true)) {
		open_url(link_discord)
	}
	if (draw_button2(x1 + 236, y1 + 380, 72, condstr(language != 1, "Twitter", "Twitter"), false, true)) {
		open_url(link_twitter)
	}
	if (draw_button2(x1 + 312, y1 + 380, 72, condstr(language != 1, "YouTube", "YouTube"), false, true)) {
		open_url(link_youtube)
	}
	if (draw_button2(x1 + 388, y1 + 380, 72, condstr(language != 1, "Donate", "捐赠"), false, true)) {
		open_url(link_donate)
	}

	if (draw_button2(x1 + 580 - 72 - 8, y1 + 380, 72, condstr(language != 1, "OK", "确定"), false, false) && (windowopen = 1 || theme != 3)) {
		windowclose = 1
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
