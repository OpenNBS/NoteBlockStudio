function draw_window_properties() {
	// draw_window_properties()
	
	if (window != prevwindow) {
		// Initialize loop end to current last tick of the song
		songs[song].loopend = songs[song].enda + 1
	}
	
	var x1, y1, a; 
	var cursong = songs[song]
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
	a = cursong.song_name
	if (language != 1) cursong.song_name = draw_inputbox(1, x1 + 158, y1 + 64, 240, cursong.song_name, "The name of the song.")
	else cursong.song_name = draw_inputbox(1, x1 + 158, y1 + 64, 240, cursong.song_name, "歌曲的名称。")
	if (cursong.song_name = "") {
	    draw_set_color(c_gray)
	    if (language != 1) draw_text_dynamic(x1 + 161, y1 + 68, "Untitled song")
	    else draw_text_dynamic(x1 + 161, y1 + 68, "无名歌曲")
	    draw_theme_color()
	}
	if (a != cursong.song_name) cursong.changed = 1

	if (language != 1) draw_text_dynamic(x1 + 32, y1 + 67 + 23, "Song author:")
	else draw_text_dynamic(x1 + 32, y1 + 67 + 23, "作者:")
	a = cursong.song_author
	if (language != 1) cursong.song_author = draw_inputbox(2, x1 + 158, y1 + 64 + 23, 240, cursong.song_author, "The name of the creator of the song.")
	else cursong.song_author = draw_inputbox(2, x1 + 158, y1 + 64 + 23, 240, cursong.song_author, "歌曲作者的名称。")
	if (a != cursong.song_author) cursong.changed = 1

	if (language != 1) draw_text_dynamic(x1 + 32, y1 + 67 + 23 * 2, "Original song author:")
	else draw_text_dynamic(x1 + 32, y1 + 67 + 23 * 2, "原作者:")
	a = cursong.song_orauthor
	if (language != 1) cursong.song_orauthor = draw_inputbox(3, x1 + 158, y1 + 64 + 23 * 2, 240, cursong.song_orauthor, "The name of the creator of the original song\n(Leave empty if you composed the song yourself.)")
	else cursong.song_orauthor = draw_inputbox(3, x1 + 158, y1 + 64 + 23 * 2, 240, cursong.song_orauthor, "歌曲原作者的名称。（如果是自作曲就留空）")
	if (a != cursong.song_orauthor) cursong.changed = 1

	if (language != 1) draw_text_dynamic(x1 + 32, y1 + 67 + 23 * 3, "Description:")
	else draw_text_dynamic(x1 + 32, y1 + 67 + 23 * 3, "简介:")
	a = cursong.song_desc
	if (language != 1) cursong.song_desc = draw_textarea(4, x1 + 158, y1 + 64 + 23 * 3, 240, 100, cursong.song_desc, "Enter a description for your song.")
	else cursong.song_desc = draw_textarea(4, x1 + 158, y1 + 64 + 23 * 3, 240, 100, cursong.song_desc, "为你的歌曲输入简介。")
	if (a != cursong.song_desc) cursong.changed = 1

	draw_theme_color()
	if (language != 1) draw_areaheader(x1 + 22, y1 + 268, 396, 105, "Playback")
	else draw_areaheader(x1 + 22, y1 + 268, 396, 85, "播放")

	if (language != 1) draw_text_dynamic(x1 + 37, y1 + 285, "Time signature:")
	else draw_text_dynamic(x1 + 37, y1 + 285, "拍号:")
	a = cursong.timesignature
	cursong.timesignature = median(2, draw_dragvalue(3, x1 + 135, y1 + 285, cursong.timesignature, 1), 8)
	if (a != cursong.timesignature) cursong.changed = 1
	draw_text_dynamic(x1 + 135 + string_width_dynamic(string(cursong.timesignature)), y1 + 285, " / 4")
	if (language != 1) popup_set_window(x1 + 37, y1 + 283, 110, 18, "The time signature of the song.")
	else popup_set_window(x1 + 37, y1 + 283, 110, 18, "乐曲的拍号。")

	a = cursong.loop
	if (language != 1) {if (draw_checkbox(x1 + 252, y1 + 285, cursong.loop, "Enable looping", "Whether to loop this song back to"+br+"the start at the end of playback.", false, true)) cursong.loop=!cursong.loop}
	else {if (draw_checkbox(x1 + 252, y1 + 285, cursong.loop, "启用循环", "是否在播放结尾循环至开始处。", false, true)) cursong.loop=!cursong.loop}
	if (a != cursong.loop) cursong.changed = 1
	if (!cursong.loop) draw_set_color(c_gray)
	if (language != 1) draw_text_dynamic(x1 + 252, y1 + 305, "Loop start tick:")
	else draw_text_dynamic(x1 + 252, y1 + 305, "循环开始刻:")
	a = cursong.loopstart
	if (cursong.loop) {
		cursong.loopstart = median(0, draw_dragvalue(7, x1 + 340, y1 + 305, cursong.loopstart, 0.5), cursong.enda)
	} else {
		draw_text_dynamic(x1 + 340, y1 + 305, cursong.loopstart)
	}
	if (a != cursong.loopstart) cursong.changed = 1
	
	// Loop end tick
	if (!cursong.loop) draw_set_color(c_gray)
	if (language != 1) draw_text_dynamic(x1 + 252, y1 + 325, "Loop end tick:")
	else draw_text_dynamic(x1 + 252, y1 + 325, "循环结束刻:")	
	a = cursong.loopend
	if (cursong.loop) {
		cursong.loopend = median(cursong.enda + 1, draw_dragvalue(20, x1 + 340, y1 + 325, cursong.loopend, 0.5), cursong.enda + 16 + 1)
	} else {
		draw_text_dynamic(x1 + 340, y1 + 325, cursong.loopend)
	}
	if (cursong.loopend != cursong.enda + 1) {
		draw_set_color(c_orange)
		draw_theme_font(font_small_bold)
		draw_text_dynamic(x1 + 25, y1 + 390, "[!]")
		draw_theme_font(font_small)
		if (language != 1) draw_text_dynamic(x1 + 40 + (theme != 3) * 2, y1 + 390 + (theme == 3), "A silent note will be added to extend the length of the song.")
		else draw_text_dynamic(x1 + 40 + (theme != 3) * 2, y1 + 390 + (theme == 3), "歌曲结尾将会自动添加一个 0 音量音符用于延长歌曲结尾。")
		draw_theme_font(font_main)
		draw_theme_color()
	}
	if (a != cursong.loopend) cursong.changed = 1

	if (language != 1) draw_text_dynamic(x1 + 252, y1 + 345, "Times to loop:")
	else draw_text_dynamic(x1 + 252, y1 + 345, "循环次数:")
	a = cursong.loopmax
	if (cursong.loop) {
		cursong.loopmax = median(0, draw_dragvalue(13, x1 + 340, y1 + 345, cursong.loopmax, 0.5), 10)
	} else {
		draw_text_dynamic(x1 + 340, y1 + 345, cursong.loopmax)
	}
	if (language != 1) {if (cursong.loopmax = 0) draw_text_dynamic(x1 + 360, y1 + 345, "(infinite)")}
	else {if (cursong.loopmax = 0) draw_text_dynamic(x1 + 360, y1 + 345, "（无限）")}
	if (a != cursong.loopmax) cursong.changed = 1
	timestoloop = cursong.loopmax

	draw_theme_color()

	if (draw_button2(x1 + 430 - 72, y1 + 386, 72, condstr(language != 1, "OK", "确定")) && (windowopen = 1 || theme != 3)) {
		
		if (cursong.loopend != cursong.enda + 1) {
			show_debug_message("Loop end changed; adding extra note");
			add_block(cursong.loopend - 1, 0, cursong.instrument_list[| 0], 45, 0, 100, 0)
		}
		
		windowclose = 1
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {		
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
