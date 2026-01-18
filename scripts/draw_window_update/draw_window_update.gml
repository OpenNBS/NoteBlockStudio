function draw_window_update() {
	// draw_window_update()
	var x1, y1, a, n, fullstr, str, strb;
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	if (window = w_update && theme != 3) windowopen = 1
	fullstr = changelogstr
	if (fullstr = 0) {
		if (language != 1) message("Changelist not found!", "Note Block Studio")
		else message("找不到更新历史！", "Note Block Studio")
		if (window = w_update) {
	        window = w_greeting
	    } else {
	        window = 0
	    }
		return 0
	}
	var theme_offset = (theme == 3 ? 0 : 20) // Add extra width to account for the wider font on non-Fluent themes
	x1 = floor(rw / 2 - 250) - theme_offset / 2
	y1 = floor(rh / 2 - 200) + windowoffset
	draw_window(x1, y1, x1 + 500 + theme_offset, y1 + 400)
	draw_theme_font(font_main_bold)
	
	if (language != 1) {
	if (NOT_RUN_FROM_IDE != 1) {
		draw_text_dynamic(x1 + 8, y1 + 8, "Changelist (You're running from the IDE!)")
	} else {
		if (window = w_update) draw_text_dynamic(x1 + 8, y1 + 8, "Update")
		else draw_text_dynamic(x1 + 8, y1 + 8, "Changelist")
	}
	} else {
	if (NOT_RUN_FROM_IDE != 1) {
		draw_text_dynamic(x1 + 8, y1 + 8, "更新历史（正在 IDE 中运行！）")
	} else {
		if (window = w_update) draw_text_dynamic(x1 + 8, y1 + 8, "更新")
		else draw_text_dynamic(x1 + 8, y1 + 8, "更新历史")
	}
	}
	
	draw_theme_font(font_main)
	
	// Refresh changelog button (debug)
	if (NOT_RUN_FROM_IDE != 1) {
		if (draw_button2(x1 + 500 - 144 - 16, y1 + 8 + 24, 72, "Open file")) {
			open_url(data_directory + "changelog.txt");
		}
		if (draw_button2(x1 + 500 - 72 - 8, y1 + 8 + 24, 72, "Refresh")) {
			changelogstr = load_text(data_directory + "changelog.txt");
		}
	}
	
	if (language != 1) {
		if (window = w_update) {
			draw_text_dynamic(x1 + 32, y1 + 32, "Thank you for upgrading to version " + version + "!")
		}
	} else {
		if (window = w_update) {
			draw_text_dynamic(x1 + 32, y1 + 32, "感谢你更新到 " + version + " 版本！")
		}
	}
	if (draw_button2(x1 + 500 - 120 - 8, y1 + 8, 120, language != 1 ? "Watch release video" : "观看更新视频")) {
		if (language != 1) {
			open_url("https://youtu.be/gya4NAQunEc");
		} else {
			open_url("https://www.bilibili.com/video/BV1qWq9Y2ESX/");
		}
	}
	draw_area(x1 + 16, y1 + 58, x1 + 487 + theme_offset, y1 + 357)
	n = string_count("\n", fullstr) 
	for (a = 0; a < n; a += 1) {
	    str[a] = string_copy(fullstr, 1, string_pos("\n", fullstr) - 1)
	    strb[a] = 0
	    if (string_char_at(str[a], 1) = "C") strb[a] = 1
	    fullstr = string_delete(fullstr, 1, string_pos("\n", fullstr))
	}
	for (a = sb_val[update_scrollbar]; a < sb_val[update_scrollbar] + 18; a += 1) {
	    if (a >= n) break
	    if (strb[a]) draw_theme_font(font_main_bold)
	    else draw_theme_font(font_main)
	    if (!hires || obj_controller.theme != 3) draw_text(x1 + 32, y1 + 64 + 16 * (a - sb_val[update_scrollbar]), str[a])
	    else draw_text_transformed(x1 + 32, y1 + 64 + 16 * (a - sb_val[update_scrollbar]), str[a], 0.25, 0.25, 0)
	}
	draw_theme_font(font_main)
	draw_scrollbar(update_scrollbar, x1 + 470 + theme_offset, y1 + 60, 12, 22, n, 0, 1)
	if (draw_button2(x1 + 16, y1 + 365, 96, condstr(language != 1, "Older versions...", "查看更旧版本…"))) {
		open_url(link_changelog)
	}
	if (draw_button2(x1 + 487 - 72 + theme_offset, y1 + 365, 72, condstr(language != 1, "OK", "确认")) && (windowopen = 1 || theme != 3)) {
	    if (window = w_update) {
	        window = w_greeting
			save_settings() // Save new version number
	    } else {
	        windowclose = 1
	    }
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
