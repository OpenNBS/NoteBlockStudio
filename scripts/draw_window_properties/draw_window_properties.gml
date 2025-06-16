function draw_window_properties() {
	// draw_window_properties()
	
	if (window != prevwindow || loopend = 0) {
		// Initialize loop end to current last tick of the song
		loopend = enda + 1
	}
	
	var x1, y1, a; 
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	text_exists[0] = 0
	x1 = floor(rw / 2 - 220)
	y1 = floor(rh / 2 - 240) + windowoffset
	draw_window(x1, y1, x1 + 440, y1 + 420)
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Song Properties")
	else draw_text_dynamic(x1 + 8, y1 + 8, "歌曲属性")
	draw_theme_font(font_main)
	if (theme = 0) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 434, y1 + 379, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 434, y1 + 379, 1)
	}
	if (language != 1) draw_areaheader(x1 + 22, y1 + 48, 396, 200, "Information")
	else draw_areaheader(x1 + 22, y1 + 48, 396, 200, "信息")

	if (language != 1) draw_text_dynamic(x1 + 32, y1 + 67, "Song name:")
	else draw_text_dynamic(x1 + 32, y1 + 67, "歌曲名:")
	a = song_name
	if (language != 1) song_name = draw_inputbox(1, x1 + 158, y1 + 64, 240, song_name, "The name of the song.")
	else song_name = draw_inputbox(1, x1 + 158, y1 + 64, 240, song_name, "歌曲的名称。")
	if (song_name = "") {
	    draw_set_color(c_gray)
	    if (language != 1) draw_text_dynamic(x1 + 161, y1 + 68, "Untitled song")
	    else draw_text_dynamic(x1 + 161, y1 + 68, "无名歌曲")
	    draw_theme_color()
	}
	if (a != song_name) changed = 1

	if (language != 1) draw_text_dynamic(x1 + 32, y1 + 67 + 23, "Song author:")
	else draw_text_dynamic(x1 + 32, y1 + 67 + 23, "作者:")
	a = song_author
	if (language != 1) song_author = draw_inputbox(2, x1 + 158, y1 + 64 + 23, 240, song_author, "The name of the creator of the song.")
	else song_author = draw_inputbox(2, x1 + 158, y1 + 64 + 23, 240, song_author, "歌曲作者的名称。")
	if (a != song_author) changed = 1

	if (language != 1) draw_text_dynamic(x1 + 32, y1 + 67 + 23 * 2, "Original song author:")
	else draw_text_dynamic(x1 + 32, y1 + 67 + 23 * 2, "原作者:")
	a = song_orauthor
	if (language != 1) song_orauthor = draw_inputbox(3, x1 + 158, y1 + 64 + 23 * 2, 240, song_orauthor, "The name of the creator of the original song\n(Leave empty if you composed the song yourself.)")
	else song_orauthor = draw_inputbox(3, x1 + 158, y1 + 64 + 23 * 2, 240, song_orauthor, "歌曲原作者的名称。（如果是自作曲就留空）")
	if (a != song_orauthor) changed = 1

	if (language != 1) draw_text_dynamic(x1 + 32, y1 + 67 + 23 * 3, "Description:")
	else draw_text_dynamic(x1 + 32, y1 + 67 + 23 * 3, "简介:")
	a = song_desc
	if (language != 1) song_desc = draw_textarea(4, x1 + 158, y1 + 64 + 23 * 3, 240, 100, song_desc, "Enter a description for your song.")
	else song_desc = draw_textarea(4, x1 + 158, y1 + 64 + 23 * 3, 240, 100, song_desc, "为你的歌曲输入简介。")
	if (a != song_desc) changed = 1

	draw_theme_color()
	if (language != 1) draw_areaheader(x1 + 22, y1 + 268, 396, 105, "Playback")
	else draw_areaheader(x1 + 22, y1 + 268, 396, 85, "播放")

	if (language != 1) draw_text_dynamic(x1 + 37, y1 + 285, "Time signature:")
	else draw_text_dynamic(x1 + 37, y1 + 285, "拍号:")
	a = timesignature
	timesignature = median(2, draw_dragvalue(3, x1 + 135, y1 + 285, timesignature, 1), 8)
	if (a != timesignature) changed = 1
	draw_text_dynamic(x1 + 135 + string_width_dynamic(string(timesignature)), y1 + 285, " / 4")
	if (language != 1) popup_set_window(x1 + 37, y1 + 283, 110, 18, "The time signature of the song.")
	else popup_set_window(x1 + 37, y1 + 283, 110, 18, "乐曲的拍号。")

	a = loop
	if (language != 1) {if (draw_checkbox(x1 + 252, y1 + 285, loop, "Enable looping", "Whether to loop this song back to"+br+"the start at the end of playback.", false, true)) loop=!loop}
	else {if (draw_checkbox(x1 + 252, y1 + 285, loop, "启用循环", "是否在播放结尾循环至开始处。", false, true)) loop=!loop}
	if (a != loop) changed = 1
	if (!loop) draw_set_color(c_gray)
	if (language != 1) draw_text_dynamic(x1 + 252, y1 + 305, "Loop start tick:")
	else draw_text_dynamic(x1 + 252, y1 + 305, "循环开始刻:")
	a = loopstart
	if (loop) {
		loopstart = median(0, draw_dragvalue(7, x1 + 340, y1 + 305, loopstart, 0.5), obj_controller.enda)
	} else {
		draw_text_dynamic(x1 + 340, y1 + 305, loopstart)
	}
	if (a != loopstart) changed = 1
	
	// Loop end tick
	if (!loop) draw_set_color(c_gray)
	if (language != 1) draw_text_dynamic(x1 + 252, y1 + 325, "Loop end tick:")
	else draw_text_dynamic(x1 + 252, y1 + 325, "循环结束刻:")	
	a = loopend
	if (loop) {
		loopend = median(enda + 1, draw_dragvalue(20, x1 + 340, y1 + 325, loopend, 0.5), obj_controller.enda + 16 + 1)
	} else {
		draw_text_dynamic(x1 + 340, y1 + 325, loopend)
	}
	if (loop && loopend > enda + 1) {
		draw_set_color(c_orange)
		draw_theme_font(font_small_bold)
		draw_text_dynamic(x1 + 25, y1 + 390, "[!]")
		draw_theme_font(font_small)
		if (language != 1) draw_text_dynamic(x1 + 40 + (theme != 3) * 2, y1 + 390 + (theme == 3), "A silent note will be added to extend the length of the song.")
		else draw_text_dynamic(x1 + 40 + (theme != 3) * 2, y1 + 390 + (theme == 3), "歌曲结尾将会自动添加一个 0 音量音符用于延长歌曲结尾。")
		draw_theme_font(font_main)
		draw_theme_color()
	}
	if (a != loopend) changed = 1

	if (language != 1) draw_text_dynamic(x1 + 252, y1 + 345, "Times to loop:")
	else draw_text_dynamic(x1 + 252, y1 + 345, "循环次数:")
	a = loopmax
	if (loop) {
		loopmax = median(0, draw_dragvalue(13, x1 + 340, y1 + 345, loopmax, 0.5), 10)
	} else {
		draw_text_dynamic(x1 + 340, y1 + 345, loopmax)
	}
	if (language != 1) {if (loopmax = 0) draw_text_dynamic(x1 + 360, y1 + 345, "(infinite)")}
	else {if (loopmax = 0) draw_text_dynamic(x1 + 360, y1 + 345, "（无限）")}
	if (a != loopmax) changed = 1
	timestoloop = loopmax

	draw_theme_color()

	if (draw_button2(x1 + 430 - 72, y1 + 386, 72, condstr(language != 1, "OK", "确定")) && (windowopen = 1 || theme != 3)) {
		
		if (loopend != enda + 1) {
			show_debug_message("Loop end changed; adding extra note");
			add_block(loopend - 1, 0, instrument_list[| 0], 45, 0, 100, 0)
		}
		
		windowclose = 1
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {		
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
