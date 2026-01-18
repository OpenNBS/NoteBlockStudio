function draw_window_stats() {
	// draw_window_stats()
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	var x1, y1, a, n;
	x1 = floor(rw / 2 - 150)
	y1 = floor(rh / 2 - 200) + windowoffset
	draw_window(x1, y1, x1 + 300, y1 + 400)
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Song Stats")
	else draw_text_dynamic(x1 + 8, y1 + 8, "歌曲数据")
	draw_theme_font(font_main)
	if (!theme) {
	    draw_set_color(c_white)
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 294, y1 + 362, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 26, x1 + 294, y1 + 362, 1)
	}
	if (language != 1) draw_areaheader(x1 + 16, y1 + 40, 264, 150, "Note blocks")
	else draw_areaheader(x1 + 16, y1 + 40, 264, 150, "音符盒")
	draw_scrollbar(statscrollbarv, x1 + 260, y1 + 48, 18, 5, ds_list_size(songs[song].instrument_list), 0, 1)
	for (a = 0; a < 5; a += 1) {
	    var ins;
	    n = floor(sb_val[statscrollbarv]) + a
	    if (n >= ds_list_size(songs[song].instrument_list)) break
	    ins = songs[song].instrument_list[| n];
		if (ins.user) {
			draw_icon_customins(x1 + 32, y1 + 64 + 18 * a, n - first_custom_index, 1, true, 1)
		} else {
			if (hires && theme = 3) gpu_set_texfilter(false)
			draw_sprite(spr_instrumenticons, n, x1 + 32, y1 + 64 + 18 * a)
			if (hires && theme = 3) gpu_set_texfilter(true)
		}
	    draw_text_dynamic(x1 + 50, y1 + 65 + 18 * a, "x" + string(ins.num_blocks) + " (" + string(floor(ins.num_blocks / max(0.001, songs[song].totalblocks) * 100)) + "%)")
	    popup_set_window(x1 + 32, y1 + 64 + 18 * a, 100, 18, ins.name)
	}
	if (language != 1) {
	draw_text_dynamic(x1 + 32, y1 + 156, "Total: " + string(songs[song].totalblocks))
	draw_areaheader(x1 + 16, y1 + 210, 264, 140, "Work stats")
	draw_text_dynamic(x1 + 32, y1 + 226, "Minutes spent:\nLeft clicks:\nRight clicks:\nBlocks created:\nBlocks deleted:")
	draw_set_halign(fa_right)
	draw_text_dynamic(x1 + 260, y1 + 226, string(floor(songs[song].work_mins)) + "\n" + string(songs[song].work_left) + "\n" + string(songs[song].work_right) + "\n" + string(songs[song].work_add) + "\n" + string(songs[song].work_remove))
	draw_set_halign(fa_left)
	if (!isplayer && draw_button2(x1 + 200, y1 + 320, 72, "Reset")) {
	    if (question("Are you sure? This cannot be undone.", "Confirm")) {
	        songs[song].work_mins = 0
	        songs[song].work_left = 0
	        songs[song].work_right = 0
	        songs[song].work_add = 0
	        songs[song].work_remove = 0
	        songs[song].changed = 1
	    }
	}
	if (draw_button2(x1 + 220, y1 + 368, 72, "OK") && (windowopen = 1 || theme != 3)) windowclose = 1
	} else {
	draw_text_dynamic(x1 + 32, y1 + 156, "总共: " + string(songs[song].totalblocks))
	draw_areaheader(x1 + 16, y1 + 210, 264, 140, "工作数据")
	draw_text_dynamic(x1 + 32, y1 + 226, "所用分钟:\n左键次数:\n右键次数:\n已放方块:\n已删方块:")
	draw_set_halign(fa_right)
	draw_text_dynamic(x1 + 260, y1 + 226, string(floor(songs[song].work_mins)) + "\n" + string(songs[song].work_left) + "\n" + string(songs[song].work_right) + "\n" + string(songs[song].work_add) + "\n" + string(songs[song].work_remove))
	draw_set_halign(fa_left)
	if (!isplayer && draw_button2(x1 + 200, y1 + 320, 72, "重置")) {
	    if (question("你确定吗？这将无法恢复。", "确定")) {
	        songs[song].work_mins = 0
	        songs[song].work_left = 0
	        songs[song].work_right = 0
	        songs[song].work_add = 0
	        songs[song].work_remove = 0
	        songs[song].changed = 1
	    }
	}
	if (draw_button2(x1 + 220, y1 + 368, 72, "确定") && (windowopen = 1 || theme != 3)) windowclose = 1
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
