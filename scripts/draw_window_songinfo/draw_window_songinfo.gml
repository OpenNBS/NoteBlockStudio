function draw_window_songinfo() {
	// draw_window_songinfo()
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	var x1, y1, a, b, n, str, w, h, yy, w1, w2, w3, w4, w5, w6, col, r, g, b, str2, cut;
	with (obj_popup) instance_destroy()
	global.popup = 0
	col[0] = 16728176
	col[1] = 16737419
	col[2] = 16737419

	str[0] = songs[song].song_name
	if (language != 1) {if (str[0] = "") str[0] = "Untitled song"}
	else {if (str[0] = "") str[0] = "无名歌曲"}

	str[1] = songs[song].song_author
	str[2] = songs[song].song_orauthor
	str[3] = songs[song].song_midi
	draw_theme_font(font_info_big)
	w = max(string_width_dynamic(str[0]) + 32, 400)
	draw_theme_font(font_info_med_bold)
	w2 = string_width_dynamic(str[1])
	w4 = string_width_dynamic(str[2])
	draw_theme_font(font_main_bold)
	w6 = string_width_dynamic(str[3])
	if (language != 1) {
	draw_theme_font(font_info_med)
	w1 = string_width_dynamic("Created by ")
	w3 = string_width_dynamic("Originally created by ")
	draw_theme_font(font_main)
	w5 = string_width_dynamic("Imported from ")
	} else {
	draw_theme_font(font_info_med)
	w1 = string_width_dynamic("作者：")
	w3 = string_width_dynamic("原作者：")
	draw_theme_font(font_main)
	w5 = string_width_dynamic("导入自：")
	}
	w = max(w1 + w2 + 32, w)
	w = max(w3 + w4 + 32, w)
	w = max(w5 + w6 + 32, w)
	draw_theme_font(font_main)
	var songdescwrap, songdeschei;
	songdescwrap = string_word_wrap(songs[song].song_desc, 216)
	songdeschei = string_height_dynamic(songdescwrap)

	h = songdeschei + 90
	if (songs[song].song_desc != "")
	    h += 32
	if (str[1] != "")
	    h += 16
	if (str[2] != "")
	    h += 16
	if (songs[song].song_midi != "")
	    h += 10
	if (window = w_songinfoedit)
	    h += 32
	x1 = floor(rw / 2 - w / 2)
	y1 = floor(rh / 2 - h / 2) + windowoffset
	draw_window(x1, y1, x1 + w, y1 + h)

	draw_theme_font(font_info_big)
	draw_set_halign(fa_center)
	draw_theme_color()
	draw_text_dynamic(x1 + floor(w / 2) + 1, y1 + 16 + 1, str[0])
	draw_set_color(col[0])
	if (theme = 3) draw_set_color(accent[3])
	draw_text_dynamic(x1 + floor(w / 2), y1 + 16, str[0])
	draw_theme_font(font_info_med)
	draw_theme_color()
	yy = y1 + 16
	if (songs[song].song_author != "") {
	    yy += 32
	    if (language != 1) draw_text_dynamic(x1 + floor(w / 2 - w2 / 2), yy, "Created by ")
	    else draw_text_dynamic(x1 + floor(w / 2 - w2 / 2), yy, "作者：")
	    draw_theme_font(font_info_med_bold)
	    draw_text_dynamic(x1 + floor(w / 2 + w1 / 2) + 1, yy + 1, str[1])
	    draw_set_color(col[1])
		if (theme = 3) draw_set_color(accent[3])
	    draw_text_dynamic(x1 + floor(w / 2 + w1 / 2), yy, str[1])
	}
	if (songs[song].song_orauthor != "") {
	    yy += 20
		if (songs[song].song_author = "") yy += 12
	    draw_theme_font(font_info_med)
	    draw_theme_color()
	    if (language != 1) draw_text_dynamic(x1 + floor(w / 2 - w4 / 2), yy, "Originally created by ")
	    else draw_text_dynamic(x1 + floor(w / 2 - w4 / 2), yy, "原作者：")
	    draw_theme_font(font_info_med_bold)
	    draw_text_dynamic(x1 + floor(w / 2 + w3 / 2) + 1, yy + 1, str[2])
		draw_set_color(col[2])
		if (theme = 3) draw_set_color(accent[3])
	    draw_text_dynamic(x1 + floor(w / 2 + w3 / 2), yy, str[2])
	}
	
	draw_theme_color()
	if (songs[song].song_midi != "") {
	    draw_theme_font(font_main)
		if (language != 1) a = string_width_dynamic("Imported from ")
		else a = string_width_dynamic("导入自：")
		draw_theme_font(font_main_bold)
		b = string_width_dynamic(songs[song].song_midi)
		draw_theme_font(font_main_bold)
		draw_text_dynamic(x1 + floor(w / 2 + a / 2), y1 + h - 34 - 32 * (window = w_songinfoedit), string(songs[song].song_midi))
		draw_theme_font(font_main)
		if (language != 1) draw_text_dynamic(x1 + floor(w / 2 - b / 2), y1 + h - 34 - 32 * (window = w_songinfoedit), "Imported from ")
		else draw_text_dynamic(x1 + floor(w / 2 - b / 2), y1 + h - 34 - 32 * (window = w_songinfoedit), "导入自：")
	}
	draw_theme_font(font_main)
	if (language != 1) draw_text_dynamic(x1 + floor(w / 2), y1 + h - 20 - 32 * (window = w_songinfoedit), condstr(window = w_songinfo, "Click anywhere to dismiss") + condstr(window = w_songinfoedit, "This message is shown when the file is opened."))
	else draw_text_dynamic(x1 + floor(w / 2), y1 + h - 20 - 32 * (window = w_songinfoedit), condstr(window = w_songinfo, "点击任意位置以关闭") + condstr(window = w_songinfoedit, "此信息在打开文件时显示。"))
	draw_set_halign(fa_left)
	if (songs[song].song_desc != "") {
	    yy += 35
	    if (theme = 0) {
	        draw_set_color(c_white)
	        draw_rectangle(x1 + floor(w / 2) - 118, yy, x1 + floor(w / 2) + 118, yy + 16 + songdeschei, 0)
	        draw_set_color(make_color_rgb(137, 140, 149))
	        draw_rectangle(x1 + floor(w / 2) - 118, yy, x1 + floor(w / 2) + 118, yy + 16 + songdeschei, 1)
		} else if (theme = 3) {
	        draw_set_color(make_color_rgb(70, 70, 70))
	        draw_roundrect(x1 + floor(w / 2) - 118, yy, x1 + floor(w / 2) + 118, yy + 16 + songdeschei, 1)
	    } else {
	        draw_frame(x1 + floor(w / 2) - 118, yy, x1 + floor(w / 2) + 118, yy + 16 + songdeschei)
	    }
	    draw_theme_color()
	    draw_text_dynamic(x1 + floor(w / 2) - 110, yy + 8, songdescwrap)
	}

	if (window = w_songinfoedit) {
		if (language != 1) {
	    if (draw_button2(x1 + floor(w / 2) - 70, y1 + h - 30, 70, "Edit")) window = w_properties
	    if (draw_button2(x1 + floor(w / 2) + 5, y1 + h - 30, 70, "OK") && (windowopen = 1 || theme != 3)) windowclose = 1
		} else {
	    if (draw_button2(x1 + floor(w / 2) - 70, y1 + h - 30, 70, "修改")) window = w_properties
	    if (draw_button2(x1 + floor(w / 2) + 5, y1 + h - 30, 70, "确定") && (windowopen = 1 || theme != 3)) windowclose = 1
		}
	} else {
	    if (mouse_check_button_pressed(mb_left)) {
			windowopen = 1
			windowclose = 1
		}
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
