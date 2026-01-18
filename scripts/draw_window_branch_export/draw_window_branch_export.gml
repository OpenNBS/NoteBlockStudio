function draw_window_branch_export() {
	// draw_window_branch_export()
	var x1, y1, a, b, c, d, str, nsel, tabs, tabstr, tabw, tabtip, menun, menua, menub, block, c1, c2;
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	x1 = floor(rw / 2 - 275)
	y1 = floor(rh / 2 - 200) + windowoffset
	draw_window(x1, y1, x1 + 550, y1 + 400)
	if (theme = 3){
	draw_set_color(13421772)
	if (fdark) draw_set_color(3355443)
	draw_roundrect(x1+1,y1+1,x1+548,y1+48,0)
	draw_set_color(c_black)
	draw_theme_color()
	}
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Branch Export")
	else draw_text_dynamic(x1 + 8, y1 + 8, "导出分支")
	draw_theme_font(font_main)

	b = 8
	if (language != 1) {
	str[0] = "Design"
	str[1] = "Blocks"
	} else {
	str[0] = "设计"
	str[1] = "方块"
	}
	nsel = -1
	menun = -1
	if (language != 1) {if (draw_checkbox(x1 + 12, y1 + 374, sch_br_remember, "Remember changes", "Whether to use these settings the\nnext time you export a branch.", false, true) && wmenu = 0) sch_br_remember=!sch_br_remember}
	else {if (draw_checkbox(x1 + 12, y1 + 374, sch_br_remember, "记住我的更改", "下次导出分支时是否使用同样的设定。", false, true) && wmenu = 0) sch_br_remember=!sch_br_remember}

	if (theme = 1) draw_window(x1 + 4, y1 + 45, x1 + 496 + 50, y1 + 364)
	for (a = 0; a < 2; a += 1) {
	    c = mouse_rectangle(x1 + b, y1 + 28, string_width_dynamic(str[a]) + 12, 18)
	    if (selected_tab_sch = a) {
	        stabx = b - 2
	        stabw = string_width_dynamic(str[a]) + 15
	    } else {
	        draw_sprite(spr_tabbuttons, 0 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b, y1 + 28)
	        draw_sprite_ext(spr_tabbuttons, 1 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b + 2, y1 + 28, string_width_dynamic(str[a]) / 2 + 4, 1, 0, -1, draw_get_alpha())
	        draw_sprite(spr_tabbuttons, 2 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b + string_width_dynamic(str[a]) + 10, y1 + 28)
	        draw_text_dynamic(x1 + b + 6, y1 + 30, str[a])
	    }
	    if (mouse_check_button_pressed(mb_left) && c && wmenu = 0) nsel = a
	    b += string_width_dynamic(str[a]) + 12
	}
	if (theme = 0 || theme = 3) {
	    draw_set_color(c_white)
	    if (theme != 3) draw_rectangle(x1 + 6, y1 + 46, x1 + 494 + 50, y1 + 362, 0) 
	    draw_set_color(make_color_rgb(137, 140, 149))
	    if (theme != 3) draw_rectangle(x1 + 6, y1 + 46, x1 + 494 + 50, y1 + 362, 1)
	    draw_set_color(c_white)
		if (theme = 3) draw_set_color(15987699)
		if (theme = 3 && fdark) draw_set_color(2105376)
		if (theme != 3) {
	    draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 0)
		} else {
		draw_roundrect(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 25, 0)
		}
	    draw_set_color(make_color_rgb(137, 140, 149))
	    if (theme != 3) draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 1)
	    draw_set_color(c_white)
		if (theme = 3) draw_set_color(15987699)
		if (theme = 3 && fdark) draw_set_color(2105376)
	    draw_rectangle(x1 + stabx + 1, y1 + 46, x1 + stabx + stabw - 1, y1 + 47, 0)
	    draw_theme_color()
	    draw_text_dynamic(x1 + stabx + 8, y1 + 28, str[selected_tab_sch])
	} else if(theme = 1){
	    draw_sprite(spr_tabbuttons, 24, x1 + stabx - 1, y1 + 26)
	    draw_sprite_ext(spr_tabbuttons, 25, x1 + stabx + 1, y1 + 26, stabw / 2 - 1, 1, 0, -1, 1)
	    draw_sprite(spr_tabbuttons, 26, x1 + stabx + stabw - 1, y1 + 26)
	    draw_text_dynamic(x1 + stabx + 8, y1 + 28, str[selected_tab_sch])
	}else{
		draw_set_color(c_dark)
	    draw_rectangle(x1 + 6, y1 + 46, x1 + 494 + 50, y1 + 362, 0) 
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 46, x1 + 494 + 50, y1 + 362, 1)
	    draw_set_color(c_dark)
	    draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 1)
	    draw_set_color(c_dark)
	    draw_rectangle(x1 + stabx + 1, y1 + 46, x1 + stabx + stabw - 1, y1 + 47, 0)
	    draw_theme_color()
	    draw_text_dynamic(x1 + stabx + 8, y1 + 28, str[selected_tab_sch])
	}
	if (nsel > -1) selected_tab_sch = nsel
	selected_tab_sch += keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
	if (selected_tab_sch < 0) selected_tab_sch = 1
	if (selected_tab_sch > 1) selected_tab_sch = 0
	if (selected_tab_sch = 0) {
		if (language != 1) {
	    draw_sprite(spr_schematic_br, 0, x1 + 15, y1 + 56)
	    draw_text_dynamic(x1 + 16, y1 + 220, "Layout:")
		if (draw_radiobox(x1 + 32, y1 + 240, sch_exp_stereo = 4, "All", "Exports all notes.")) sch_exp_stereo = 4
		if (draw_radiobox(x1 + 32, y1 + 260, sch_exp_stereo = 3, "Center", "Only exports notes which have no panning values.")) sch_exp_stereo = 3
	    if (draw_radiobox(x1 + 32, y1 + 280, sch_exp_stereo = 2, "Left", "Only exports notes that have left stereo values.")) sch_exp_stereo = 2
	    if (draw_radiobox(x1 + 32, y1 + 300, sch_exp_stereo = 1, "Right", "Only exports notes that have right stereo values.")) sch_exp_stereo = 1
	
		draw_text_dynamic(x1 + 170, y1 + 220, "Polyphony:")
		sch_exp_polyphony = median(1, draw_dragvalue(18, x1 + 260, y1 + 220, sch_exp_polyphony, 1), 3)
	    draw_text_dynamic(x1 + 170, y1 + 240, "Main layer:")
	    sch_exp_layer1 = median(1, draw_dragvalue(15, x1 + 260, y1 + 240, sch_exp_layer1, 1), sch_exp_maxheight[0] + 1)
		sch_exp_layer_index[0] = sch_exp_layer1
		draw_text_dynamic(x1 + 170, y1 + 260, "Chord layer 1:")
		draw_text_dynamic(x1 + 170, y1 + 280, "Chord layer 2:")
		if (sch_exp_polyphony > 1 ) {
			sch_exp_layer2 = median(1, draw_dragvalue(16, x1 + 260, y1 + 260, sch_exp_layer2, 1), sch_exp_maxheight[0] + 1)
			sch_exp_layer_index[1] = sch_exp_layer2
		} else {
			draw_text_dynamic(x1 + 260, y1 + 260, "None")
		}
		if sch_exp_polyphony > 2 {
			sch_exp_layer3 = median(1, draw_dragvalue(17, x1 + 260, y1 + 280, sch_exp_layer3, 1), sch_exp_maxheight[0] + 1)
			sch_exp_layer_index[2] = sch_exp_layer3
		} else {
			draw_text_dynamic(x1 + 260, y1 + 280, "None")
		}
	    if (draw_checkbox(x1 + 170, y1 + 300, sch_exp_velocity, "Enable velocity", "Whether to position the note blocks differently due to their velocity.\nIt's recommended that each layer's velocity should be the same when polyphony is higher than 1.", false, true)) sch_exp_velocity=!sch_exp_velocity
		if sch_exp_velocity = 1 var schwidth = 35 else schwidth = 1
		if sch_exp_polyphony > 1 && sch_exp_velocity = 0 var schwidth = 3
	    if (draw_checkbox(x1 + 170, y1 + 320, sch_exp_circuitry, "Export circuitry", "Whether to export the ground, repeaters, and redstone.", true, true)) sch_exp_circuitry=!sch_exp_circuitry
		draw_text_dynamic(x1 + 380, y1 + 240 + 16, "Size:")
	    draw_set_halign(fa_right)
	    draw_text_dynamic(x1 + 520, y1 + 240 + 16, string(songs[song].enda * 2 + 4) + "x" + string(2) + "x" + string(schwidth))
		draw_set_halign(fa_left)
		draw_text_dynamic(x1 + 380, y1 + 280, "Range:")
		sch_exp_range_start = draw_inputbox(55,x1 + 380, y1 + 300,40,sch_exp_range_start,"Start Tick")
		sch_exp_range_end = draw_inputbox(56,x1 + 425, y1 + 300,40,sch_exp_range_end,"End Tick")
	    draw_set_halign(fa_left)
		} else {
		draw_sprite(spr_schematic_br, 0, x1 + 15, y1 + 56)
	    draw_text_dynamic(x1 + 16, y1 + 220, "分布：")
		if (draw_radiobox(x1 + 32, y1 + 240, sch_exp_stereo = 4, "全部", "导出所有音符。")) sch_exp_stereo = 4
		if (draw_radiobox(x1 + 32, y1 + 260, sch_exp_stereo = 3, "中间", "只导出没有立体声的音符。")) sch_exp_stereo = 3
	    if (draw_radiobox(x1 + 32, y1 + 280, sch_exp_stereo = 2, "左部分", "只导出偏向左声道的音符。")) sch_exp_stereo = 2
	    if (draw_radiobox(x1 + 32, y1 + 300, sch_exp_stereo = 1, "右部分", "只导出偏向右声道的音符。")) sch_exp_stereo = 1
	
		draw_text_dynamic(x1 + 170, y1 + 220, "复音数：")
		sch_exp_polyphony = median(1, draw_dragvalue(18, x1 + 260, y1 + 220, sch_exp_polyphony, 1), 3)
	    draw_text_dynamic(x1 + 170, y1 + 240, "主层数：")
	    sch_exp_layer1 = median(1, draw_dragvalue(15, x1 + 260, y1 + 240, sch_exp_layer1, 1), sch_exp_maxheight[0] + 1)
		sch_exp_layer_index[0] = sch_exp_layer1
		draw_text_dynamic(x1 + 170, y1 + 260, "和弦层 1：")
		draw_text_dynamic(x1 + 170, y1 + 280, "和弦层 2：")
		if (sch_exp_polyphony > 1 ) {
			sch_exp_layer2 = median(1, draw_dragvalue(16, x1 + 260, y1 + 260, sch_exp_layer2, 1), sch_exp_maxheight[0] + 1)
			sch_exp_layer_index[1] = sch_exp_layer2
		} else {
			draw_text_dynamic(x1 + 260, y1 + 260, "无")
		}
		if sch_exp_polyphony > 2 {
			sch_exp_layer3 = median(1, draw_dragvalue(17, x1 + 260, y1 + 280, sch_exp_layer3, 1), sch_exp_maxheight[0] + 1)
			sch_exp_layer_index[2] = sch_exp_layer3
		} else {
			draw_text_dynamic(x1 + 260, y1 + 280, "无")
		}
	    if (draw_checkbox(x1 + 170, y1 + 300, sch_exp_velocity, "开启音量变化", "是否改变音符盒摆放的位置来改变音量。\n复音数高于1时每层建议音量一样。", false, true)) sch_exp_velocity=!sch_exp_velocity
		if sch_exp_velocity = 1 var schwidth = 35 else schwidth = 1
		if sch_exp_polyphony > 1 && sch_exp_velocity = 0 var schwidth = 3
	    if (draw_checkbox(x1 + 170, y1 + 320, sch_exp_circuitry, "导出电路", "是否导出地面、中继器和红石。", true, true)) sch_exp_circuitry=!sch_exp_circuitry
		draw_text_dynamic(x1 + 380, y1 + 240 + 16, "大小：")
	    draw_set_halign(fa_right)
	    draw_text_dynamic(x1 + 520, y1 + 240 + 16, string(songs[song].enda * 2 + 4) + "x" + string(2) + "x" + string(schwidth))
		draw_set_halign(fa_left)
		draw_text_dynamic(x1 + 380, y1 + 280, "范围：")
		sch_exp_range_start = draw_inputbox(55,x1 + 380, y1 + 300,40,sch_exp_range_start,"起始刻")
		sch_exp_range_end = draw_inputbox(56,x1 + 425, y1 + 300,40,sch_exp_range_end,"结束刻")
	    draw_set_halign(fa_left)
		}
	} else {
	    if (theme = 1) {
	        draw_set_color(c_white)
	        draw_rectangle(x1 + 10, y1 + 52, x1 + 539, y1 + 255, 0)
	        draw_set_color(make_color_rgb(137, 140, 149))
	        draw_rectangle(x1 + 10, y1 + 52, x1 + 539, y1 + 255, 1)
	        draw_theme_color()
	    } else {
	        draw_set_color(make_color_rgb(137, 140, 149))
	        draw_rectangle(x1 + 11, y1 + 52, x1 + 538, y1 + 256, 1)
	    }
		if (language != 1) {
	    tabs = 3
	    tabstr[0] = "Instrument"
	    tabtip[0] = "The name of the instrument."
	    tabw[0] = 252
	    tabstr[1] = "Block"
	    tabtip[1] = "The ID of the block that should be placed\nbelow note blocks of the instrument."
	    tabw[1] = 60
	    tabstr[2] = "Block name"
	    tabtip[2] = "The name of the block that should be\nplaced below note blocks of the instrument."
	    tabw[2] = 220
		} else {
		tabs = 3
	    tabstr[0] = "音色"
	    tabtip[0] = "音色的名称。"
	    tabw[0] = 252
	    tabstr[1] = "方块"
	    tabtip[1] = "放在对应音色的音符盒下的方块ID。"
	    tabw[1] = 60
	    tabstr[2] = "方块名称"
	    tabtip[2] = "放在对应音色的音符盒下的方块名称。"
	    tabw[2] = 220
		}
	    for (a = 0; a < 9; a += 1) {
	        b = floor(sb_val[sch_exp_scrollbar] + a)
	        if (b >= ds_list_size(songs[song].instrument_list)) break
	        var ins = songs[song].instrument_list[| b];
	        draw_theme_color()
	        draw_text_dynamic(x1 + 12 + 4, y1 + 74 + 20 * a, ins.name)
	        draw_text_dynamic(x1 + 12 + 4 + tabw[0], y1 + 74 + 20 * a, string(sch_exp_ins_block[b]) + ", " + string(sch_exp_ins_data[b]))
	        if (draw_abutton(x1 + 12 + 4 + tabw[0] + tabw[1] - 25, y1 + 72 + 20 * a) && wmenu = 0) {
	            menun = 0
	            menua = a
	            menub = b
	        }
	        draw_text_dynamic(x1 + 12 + 4 + tabw[0] + tabw[1], y1 + 74 + 20 * a, block_get_name(sch_exp_ins_block[b], sch_exp_ins_data[b]))
	        draw_set_color(12632256)
	        draw_line(x1 + 12, y1 + 90 + 20 * a, x1 + 528, y1 + 90 + 20 * a)
	    }
	    draw_set_color(12632256)
	    draw_line(x1 + 9 + tabw[0], y1 + 70, x1 + 9 + tabw[0], y1 + 70 + 20 * a)
	    draw_line(x1 + 8 + tabw[0] + tabw[1], y1 + 70, x1 + 8 + tabw[0] + tabw[1], y1 + 70 + 20 * a)
	    draw_scrollbar(sch_exp_scrollbar, x1 + 524, y1 + 71, 17, 9, ds_list_size(songs[song].instrument_list), 0, 1)
	    xx = x1 + 524 + 16
	    for (a = tabs - 1; a >= 0; a -= 1) {
	        draw_window(xx - tabw[a], y1 + 51, xx, y1 + 51 + 20, 1)
	        popup_set_window(xx - tabw[a], y1 + 51, tabw[a], 20, tabtip[a])
	        draw_text_dynamic(xx - tabw[a] + 4, y1 + 54, tabstr[a])
	        xx -= tabw[a] - 1
	    }
	    draw_theme_color()
	
	    if (language != 1) draw_text_dynamic(x1 + 16, y1 + 300, "Block for circuitry: ")
	    else draw_text_dynamic(x1 + 16, y1 + 300, "电路所用方块：")
    
	    draw_set_color(c_white)
		if(theme = 2 || (fdark && theme = 3)) draw_set_color(c_dark)
	    draw_rectangle(x1 + 200, y1 + 265 + 30, x1 + 200 + 140, y1 + 265 + 21 + 30, 0)
	    draw_area(x1 + 200, y1 + 265 + 30, x1 + 200 + 140, y1 + 265 + 21 + 30)
	    if ((draw_abutton(x1 + 200 + 121, y1 + 267 + 30) || (mouse_rectangle(x1 + 200, y1 + 265 + 30, 140, 21) && mouse_check_button_pressed(mb_left))) && wmenu = 0) {
	        menun = 1
	        menua = 1
	    }
	    if (language != 1) popup_set_window(x1 + 200, y1 + 265 + 30, 140, 21, "The block that should be used for the circuitry.")
	    else popup_set_window(x1 + 200, y1 + 265 + 30, 140, 21, "为电路用的方块。")
	    draw_theme_color()
	    draw_text_dynamic(x1 + 204, y1 + 264 + 4 + 30, block_get_name(sch_exp_circuit_block, sch_exp_circuit_data))
	
	}
	if (language != 1) {
	if (draw_button2(x1 + 470, y1 + 368, 72, "Export") && wmenu = 0) {
	    if (sch_exp_totalblocks[sch_exp_includelocked] <= 0) {
	        message("There are no blocks to export!", "Branch export")
	    } else if sch_exp_range_end = 0 || sch_exp_range_start = "" || sch_exp_range_end = "" {
			message("Please enter a range!", "Branch export")
		} else if real(sch_exp_range_start) > real(sch_exp_range_end) {
			message("Starting tick must be lower than ending tick!", "Branch export")
		} else if real(sch_exp_range_end) > songs[song].enda {
			message("The ending tick is larger than the song!\nThe size of the song is " + string(songs[song].enda) + ".", "Branch export")
		}
		else {
			sch_exp_range_start = real(sch_exp_range_start)
			sch_exp_range_end = real(sch_exp_range_end)
	        branch_export()
	    }
	}
	if (draw_button2(x1 + 470 - 80 * 1, y1 + 368, 72, "Cancel") && wmenu = 0 && (windowopen = 1 || theme != 3)) {
		windowclose = 1
		selected_tab_sch = 0
	}
	if (draw_button2(x1 + 470 - 80 * 2, y1 + 368, 72, "Use default") && wmenu = 0) {
	    if (question("Are you sure?", "Confirm")) reset_schematic_export(1)
	}
	} else {
	if (draw_button2(x1 + 470, y1 + 368, 72, "导出") && wmenu = 0) {
	    if (sch_exp_totalblocks[sch_exp_includelocked] <= 0) {
	        message("没有方块可以导出！", "导出分支")
	    } else if sch_exp_range_end = 0 || sch_exp_range_start = "" || sch_exp_range_end = "" {
			message("请输入范围！", "导出分支")
		} else if real(sch_exp_range_start) > real(sch_exp_range_end) {
			message("起始刻必须小于结束刻！", "导出分支")
		} else if real(sch_exp_range_end) > songs[song].enda {
			message("结束刻超出歌曲长度！\n歌曲长度为" + string(songs[song].enda) + "。", "导出分支")
		}
		else {
			sch_exp_range_start = real(sch_exp_range_start)
			sch_exp_range_end = real(sch_exp_range_end)
	        branch_export()
	    }
	}
	if (draw_button2(x1 + 470 - 80 * 1, y1 + 368, 72, "取消") && wmenu = 0 && windowopen = 1) {
		windowclose = 1
		selected_tab_sch = 0
	}
	if (draw_button2(x1 + 470 - 80 * 2, y1 + 368, 72, "使用默认值") && wmenu = 0) {
	    if (question("你确定吗？", "确定")) reset_schematic_export(1)
	}
	}
	if (wmenu = 1 && !mouse_check_button(mb_left)) wmenu = 0

	draw_theme_font(font_small)
	if (menun > -1) {
	    if (menun = 0) {
	        if (menub = 0) {
	            b = 0
	            block[b, 0] = 0 block[b, 1] = 0 b += 1
	            block[b, 0] = 2 block[b, 1] = 0 b += 1
	            block[b, 0] = 3 block[b, 1] = 0 b += 1
	            block[b, 0] = 18 block[b, 1] = 0 b += 1
	            block[b, 0] = 19 block[b, 1] = 0 b += 1
	        } else if (menub = 1) {
	            b = 0
	            block[b, 0] = 5 block[b, 1] = 0 b += 1
	            block[b, 0] = 17 block[b, 1] = 0 b += 1
	            block[b, 0] = 25 block[b, 1] = 0 b += 1
	            block[b, 0] = 47 block[b, 1] = 0 b += 1
	        } else if (menub = 2) {
	            b = 0
	            block[b, 0] = 1 block[b, 1] = 0 b += 1
	            block[b, 0] = 4 block[b, 1] = 0 b += 1
	            block[b, 0] = 7 block[b, 1] = 0 b += 1
	            block[b, 0] = 14 block[b, 1] = 0 b += 1
	            block[b, 0] = 15 block[b, 1] = 0 b += 1
	            block[b, 0] = 16 block[b, 1] = 0 b += 1
	            block[b, 0] = 21 block[b, 1] = 0 b += 1
	            block[b, 0] = 22 block[b, 1] = 0 b += 1
	            block[b, 0] = 24 block[b, 1] = 0 b += 1
	            block[b, 0] = 48 block[b, 1] = 0 b += 1
	            block[b, 0] = 49 block[b, 1] = 0 b += 1
	            block[b, 0] = 73 block[b, 1] = 0 b += 1
	            block[b, 0] = 87 block[b, 1] = 0 b += 1
	            block[b, 0] = 89 block[b, 1] = 0 b += 1
	        } else if (menub = 3) {
	            b = 0
	            block[b, 0] = 12 block[b, 1] = 0 b += 1
	            block[b, 0] = 13 block[b, 1] = 0 b += 1
	            block[b, 0] = 88 block[b, 1] = 0 b += 1
	        } else if (menub = 4) {
	            b = 0
	            block[b, 0] = 20 block[b, 1] = 0 b += 1
	        } else if (menub = 5) {
	            b = 0
	            block[b, 0] = 35 block[b, 1] = 0 b += 1
	            for (a = 0; a < 16; a += 1) {block[b + a, 0] = 35 block[b + a, 1] = a} b += 16
	        } else if (menub = 6) {
	            b = 0
	            block[b, 0] = 82 block[b, 1] = 0 b += 1
	        } else if (menub = 7) {
	            b = 0
	            block[b, 0] = 41 block[b, 1] = 0 b += 1
	        } else if (menub = 8) {
	            b = 0
	            block[b, 0] = 174 block[b, 1] = 0 b += 1
	        } else if (menub = 9) {
	            b = 0
	            block[b, 0] = 216 block[b, 1] = 0 b += 1
	        } else {
	            b = 0
	            for (a = 0; a < 256; a += 1) {
	                if (a = 35 || a = 95 || a = 159) {
	                    block[b, 0] = a block[b, 1] = 0 b += 1
	                    for (c = 0; c < 16; c += 1) {block[b + c, 0] = a block[b + c, 1] = c} b += 16
	                } else if (block_get_name(a, 0) != "") {
	                    block[b, 0] = a block[b, 1] = 0 b += 1
	                }
	            }
	        }
	        str = ""
	        d = 0
	        sm = 0
	        for (a = 0; a < b; a += 1) {
	            if (block[a, 0] = 35) {
	                str += "Wool|\\|"
	                for (c = 0; c < 16; c += 1) str += check(sch_exp_ins_block[menub] = 35 && sch_exp_ins_data[menub] = c) + "35, " + string(c) + "$" + block_get_name(35, c) + "|"
	                str += "/|"
	                a += 16
	            } else if (block[a, 0] = 95) {
	                str += "Stained glass|\\|"
	                for (c = 0; c < 16; c += 1) str += check(sch_exp_ins_block[menub] = 95 && sch_exp_ins_data[menub] = c) + "95, " + string(c) + "$" + block_get_name(95, c) + "|"
	                str += "/|"
	                a += 16
	            } else if (block[a, 0] = 159) {
	                str += "Colored Terracotta|\\|"
	                for (c = 0; c < 16; c += 1) str += check(sch_exp_ins_block[menub] = 159 && sch_exp_ins_data[menub] = c) + "159, " + string(c) + "$" + block_get_name(159, c) + "|"
	                str += "/|"
	                a += 16
	            } else {
	                str += check(sch_exp_ins_block[menub] = block[a, 0]) + string(block[a, 0]) + ", " + string(block[a, 1]) + "$" + block_get_name(block[a, 0], block[a, 1]) + "|"
	            }
	            d++
	            if (d % 25 = 0 && a < b - 1) {
	                if (language != 1) str += "-|More...|\\|"
	                else str += "-|更多......|\\|"
	                sm++
	            }
	        }
	        str += string_repeat("/|", sm)
	        //clipboard_set_text(str)
	        menu = show_menu_ext("schexport_insblock", x1 + 9 + tabw[0], y1 + 90 + 20 * menua, str)
	        menu.menub = menub
	    }
	    if (menun = 1) {
	        b = 0
	        for (a = 0; a < 256; a += 1) {
	            if ((a = 20 || a = 25) && menua = 1) continue
	            if (a = 35 || a = 95 || a = 159) {
	                block[b, 0] = a block[b, 1] = 0 b += 1
	                for (c = 0; c < 16; c += 1) {block[b + c, 0] = b block[b + c, 1] = c} b += 16
	            } else if (block_get_name(a, 0) != "") {
	                block[b, 0] = a block[b, 1] = 0 b += 1
	            }
	        }
	        str = ""
	        if (menua = 0) {c1 = sch_exp_walkway_block c2 = sch_exp_walkway_data}
	        if (menua = 1) {c1 = sch_exp_circuit_block c2 = sch_exp_circuit_data}
	        if (menua = 2) {c1 = sch_exp_ground_block c2 = sch_exp_ground_data}
	        d = 0
	        sm = 0
	        for (a = 0; a < b; a += 1) {
	            if (block[a, 0] = 35) {
	                str += "Wool|\\|"
	                for (c = 0; c < 16; c += 1) str += check(c1 = 35 && c2 = c) + "35, " + string(c) + "$" + block_get_name(35, c) + "|"
	                str += "/|"
	                a += 16
	            } else if (block[a, 0] = 95) {
	                str += "Stained Glass|\\|"
	                for (c = 0; c < 16; c += 1) str += check(c1 = 95 && c2 = c) + "95, " + string(c) + "$" + block_get_name(95, c) + "|"
	                str += "/|"
	                a += 16
	            } else if (block[a, 0] = 159) {
	                str += "Colored Terracotta|\\|"
	                for (c = 0; c < 16; c += 1) str += check(c1 = 159 && c2 = c) + "159, " + string(c) + "$" + block_get_name(159, c) + "|"
	                str += "/|"
	                a += 16
	            } else {
	                str += check(c1 = block[a, 0]) + string(block[a, 0]) + ", " + string(block[a, 1]) + "$" + block_get_name(block[a, 0], block[a, 1]) + "|"
	            }
	            d++
	            if (d%25 = 0  && a < b - 1) {
	                if (language != 1) str += "-|More...|\\|"
	                else str += "-|更多......|\\|"
	                sm++
	            }
	        }
	        str += string_repeat("/|", sm)
	        menu = show_menu_ext("schexport_block", x1 + 200, y1 + 265 + 20 + 30 * menua, str)
	        menu.menua = menua
	    }
	}
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
