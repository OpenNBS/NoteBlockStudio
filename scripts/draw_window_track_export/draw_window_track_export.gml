function draw_window_track_export() {
	// draw_window_track_export()
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	var x1, y1, a, b, c, d, str, nsel, tabs, tabstr, tabw, tabtip, menun, menua, menub, block, blocks, c1, c2;
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
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Track Export")
	else draw_text_dynamic(x1 + 8, y1 + 8, "导出直轨")
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
	if (language != 1) {if (draw_checkbox(x1 + 12, y1 + 374, sch_exp_remember, "Remember changes", "Whether to use these settings the\nnext time you export a Schematic.", false, true) && wmenu = 0) sch_exp_remember=!sch_exp_remember}
	else {if (draw_checkbox(x1 + 12, y1 + 374, sch_exp_remember, "记住我的更改", "下次导出结构时是否使用同样的设定。", false, true) && wmenu = 0) sch_exp_remember=!sch_exp_remember}

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
	    draw_sprite(spr_schematic_exp, sch_exp_layout, x1 + 15, y1 + 56)
	    draw_text_dynamic(x1 + 16, y1 + 220, "Layout:")
	    draw_radiobox(x1 + 32, y1 + 240, sch_exp_layout = 1, "Simple walkway", "Generate a simple walkway that stretches\nas far as the length of the song.", 1)
	    draw_text_dynamic(x1 + 16, y1 + 280, "For Minecraft version:")
	    draw_radiobox(x1 + 32, y1 + 300, 1, "1.13+ (Structure Block)", "Create a Structure block file that is compatible with 1.13+.\nOnly the default block choice is supported.", 1)
		if (draw_checkbox(x1 + 170, y1 + 240, sch_exp_includelocked, "Include locked layers", "Whether to include locked layers in the Schematic.", false, true)) sch_exp_includelocked=!sch_exp_includelocked
		if (draw_checkbox(x1 + 170, y1 + 260 + (sch_exp_layout = 0) * 20, command_block, "Use command blocks", "Whether to use command blocks instead of note blocks for a wider octave range.\n(Extra notes pack required)", false, true)) command_block=!command_block
	    draw_text_dynamic(x1 + 380, y1 + 220, "Note blocks:")
	    draw_text_dynamic(x1 + 380, y1 + 220 + 16 * 1, "Repeaters:")
	    draw_text_dynamic(x1 + 380, y1 + 220 + 16 * 2, "Size:")
	    draw_set_halign(fa_right)
	    draw_text_dynamic(x1 + 520, y1 + 220, string(max(0, sch_exp_totalblocks[sch_exp_includelocked])))
	    draw_text_dynamic(x1 + 520, y1 + 220 + 16 * 1, string(66 + songs[song].enda * 9))
	    draw_text_dynamic(x1 + 520, y1 + 220 + 16 * 2, string(39 + songs[song].enda * 2) + "x" + string(98) + "x" + string(19))
	    draw_set_halign(fa_left)
	    draw_text_dynamic(x1 + 380, y1 + 220 + 16 * 3, "Tempo:")
	    draw_radiobox(x1 + 396, y1 + 220 + 16 * 3 + 20, 1, "10 ticks / second", "Generate song at 10 ticks / second", 1)
		} else {
		draw_sprite(spr_schematic_exp, sch_exp_layout, x1 + 15, y1 + 56)
	    draw_text_dynamic(x1 + 16, y1 + 220, "分布:")
	    draw_radiobox(x1 + 32, y1 + 240, 1, "普通过道", "生成过道延伸到歌曲末尾。", 1)
	    draw_text_dynamic(x1 + 16, y1 + 280, "导出为 Minecraft 版本:")
	    draw_radiobox(x1 + 32, y1 + 300, 1, "1.13+", "创建一个兼容 1.13+ 的结构方块文件。", 1)
		if (draw_checkbox(x1 + 170, y1 + 240, sch_exp_includelocked, "包括已静音的层", "是否在结构内包括已静音的层。", false, true)) sch_exp_includelocked=!sch_exp_includelocked
		if (draw_checkbox(x1 + 170, y1 + 260, command_block, "使用命令方块", "是否使用命令方块代替音符盒以获得更广音域。\n（需要更多音符资源包）", false, true)) command_block=!command_block
	    draw_text_dynamic(x1 + 380, y1 + 220, "音符盒:")
	    draw_text_dynamic(x1 + 380, y1 + 220 + 16 * 1, "中继器:")
	    draw_text_dynamic(x1 + 380, y1 + 220 + 16 * 2, "大小:")
	    draw_set_halign(fa_right)
	    draw_text_dynamic(x1 + 520, y1 + 220, string(max(0, sch_exp_totalblocks[sch_exp_includelocked])))
	    draw_text_dynamic(x1 + 520, y1 + 220 + 16 * 1, string(66 + songs[song].enda * 9))
	    draw_text_dynamic(x1 + 520, y1 + 220 + 16 * 2, string(39 + songs[song].enda * 2) + "x" + string(98) + "x" + string(19))
	    draw_set_halign(fa_left)
	    draw_text_dynamic(x1 + 380, y1 + 220 + 16 * 3, "速度:")
	    draw_radiobox(x1 + 396, y1 + 220 + 16 * 3 + 20, 1, "10 红石刻 / 秒", "生成一个 10 红石刻 / 秒 的歌曲", 1)
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
		if (language != 1) {
	    draw_text_dynamic(x1 + 16, y1 + 270, "Block for walkway:")
	    draw_text_dynamic(x1 + 16, y1 + 300, "Block for circuitry:")
		} else {
		draw_text_dynamic(x1 + 16, y1 + 270, "过道所用方块:")
	    draw_text_dynamic(x1 + 16, y1 + 300, "电路所用方块:")
		}
    
	    draw_set_color(c_white)
		if(theme = 2 || (fdark && theme = 3)) draw_set_color(c_dark)
	    draw_rectangle(x1 + 200, y1 + 265, x1 + 200 + 140, y1 + 265 + 21, 0)
	    draw_area(x1 + 200, y1 + 265, x1 + 200 + 140, y1 + 265 + 21)
	    if ((draw_abutton(x1 + 200 + 121, y1 + 267) || (mouse_rectangle(x1 + 200, y1 + 265, 140, 21) && mouse_check_button_pressed(mb_left))) && wmenu = 0) {
	        menun = 1
	        menua = 0
	    }
	    if (language != 1) popup_set_window(x1 + 200, y1 + 265, 140, 21, "The block that should be used for the walkway, \nand everything else that isn't circuitry or ground.")
	    else popup_set_window(x1 + 200, y1 + 265, 140, 21, "用于过道和除电路和地面的方块。")
	    draw_theme_color()
	    draw_text_dynamic(x1 + 204, y1 + 264 + 4, block_get_name(sch_exp_walkway_block, sch_exp_walkway_data))
    
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
	        message("There are no blocks to export!", "Schematic export")
	    } else if (schematic_length() >= 2000 || schematic_width() >= 2000 || schematic_height() >= 256) {
	        message("The Schematic is too big. The maximum size is 2000x2000x256.\nTry changing the \"Repeaters per row\" value to decrease the size.", "Error")
	    } else {
	        track_export()
	    }
	}
	if (draw_button2(x1 + 470 - 80 * 1, y1 + 368, 72, "Cancel") && wmenu = 0 && (windowopen = 1 || theme != 3)) {
		windowclose = 1
	}
	if (draw_button2(x1 + 470 - 80 * 2, y1 + 368, 72, "Use default") && wmenu = 0) {
	    if (question("Are you sure?", "Confirm")) reset_schematic_export(1)
	}
	if (structure = true) {
		if (draw_button2(x1 + 470 - 80 * 4, y1 + 368, 152, "Get extra notes pack", !command_block)) {
			datapack_getextranotes()
		}
	}
	} else {
	if (draw_button2(x1 + 470, y1 + 368, 72, "导出") && wmenu = 0) {
	    if (sch_exp_totalblocks[sch_exp_includelocked] <= 0) {
	        message("没有方块可以导出！", "导出结构")
	    } else {
	        track_export()
	    }
	}
	if (draw_button2(x1 + 470 - 80 * 1, y1 + 368, 72, "取消") && wmenu = 0 && (windowopen = 1 || theme != 3)) {
		windowclose = 1
	}
	if (draw_button2(x1 + 470 - 80 * 2, y1 + 368, 72, "使用默认值") && wmenu = 0) {
	    if (question("你确定吗？", "确定")) reset_schematic_export(1)
	}
	if (structure = true) {
		if (draw_button2(x1 + 470 - 80 * 4, y1 + 368, 152, "保存更多音符资源包", !command_block)) {
			datapack_getextranotes()
		}
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
