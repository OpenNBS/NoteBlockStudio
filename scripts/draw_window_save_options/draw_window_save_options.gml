function draw_window_save_options() {
	// draw_window_save_options()
	var x1, y1, min_version;
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	text_exists[0] = 0
	x1 = floor(rw / 2 - 72)
	y1 = floor(rh / 2 - 90) + windowoffset
	draw_window(x1, y1, x1 + 140, y1 + 162)
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Save options")
	else draw_text_dynamic(x1 + 8, y1 + 8, "保存选项")
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 132, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 132, 1)
	}
	draw_theme_color()
	
	min_version = 0
	if (songs[song].user_instruments > 18) {
		min_version = 5
	}
	save_version = max(save_version, min_version)

	if (language != 1) {
	//if (draw_radiobox(x1 + 15, y1 + 20, save_version = 6, "v6", "Added UTF-8 support, includes the TPS / BPM setting (In development)", min_version > 6 || true)) save_version = 6
	if (draw_radiobox(x1 + 15, y1 + 35, save_version = 5, "v5", "Increases custom instrument limit\nAllows custom sounds in subfolders", min_version > 5)) save_version = 5
	if (draw_radiobox(x1 + 15, y1 + 50, save_version = 4, "v4", "Includes note velocity/pan/pitch and looping", min_version > 4)) save_version = 4
	if (draw_radiobox(x1 + 15, y1 + 65, save_version = 3, "v3", "Includes song length", min_version > 3)) save_version = 3
	if (draw_radiobox(x1 + 15, y1 + 80, save_version = 2, "v2", "Includes layer panning", min_version > 2)) save_version = 2
	if (draw_radiobox(x1 + 15, y1 + 95, save_version = 1, "v1", "Includes custom instrument index", min_version > 1)) save_version = 1
	if (draw_radiobox(x1 + 15, y1 + 110, save_version = 0, "Classic", "Doesn't have any of the above, but works on all versions.", min_version > 0)) save_version = 0

	if (draw_button2(x1 + 40, y1 + 135, 60, "OK") && (windowopen = 1 || theme != 3)) {
		if save_version != nbs_version question("Some of the song's data will be lost if you save in a previous version! Are you sure?", "Confirm")
		songs[song].changed = 1
		windowclose = 1
		}
	} else {
	//if (draw_radiobox(x1 + 15, y1 + 20, save_version = 6, "v6", "增加UTF-8支持、包含TPS / BPM设置（正在开发中）", min_version > 6 || true)) save_version = 6
	if (draw_radiobox(x1 + 15, y1 + 35, save_version = 5, "v5", "增加自定义音色限制、允许自定义文件在子目录", min_version > 5)) save_version = 5
	if (draw_radiobox(x1 + 15, y1 + 50, save_version = 4, "v4", "包含音符音量、声道、音高和循环", min_version > 4)) save_version = 4
	if (draw_radiobox(x1 + 15, y1 + 65, save_version = 3, "v3", "包含歌曲长度", min_version > 3)) save_version = 3
	if (draw_radiobox(x1 + 15, y1 + 80, save_version = 2, "v2", "包含层声道数据", min_version > 2)) save_version = 2
	if (draw_radiobox(x1 + 15, y1 + 95, save_version = 1, "v1", "包含自定义乐器序号", min_version > 1)) save_version = 1
	if (draw_radiobox(x1 + 15, y1 + 110, save_version = 0, "经典", "上面的都没有，但所有版本都兼容。", min_version > 0)) save_version = 0

	if (draw_button2(x1 + 40, y1 + 135, 60, "确定") && (windowopen = 1 || theme != 3)) {
		if save_version != nbs_version question("如果你保存在旧版本的话一些歌曲信息将会丢失！你确定吗？", "确定")
		songs[song].changed = 1
		windowclose = 1
		}
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
