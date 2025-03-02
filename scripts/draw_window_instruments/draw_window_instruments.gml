function draw_window_instruments() {
	// draw_window_instruments()
	var x1, y1, a, b, c, str, menun, menua, menub, prev, tempo_changer_exists;
	var cursong = songs[song]
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	menun = -1
	x1 = floor(rw / 2 - 275)
	y1 = floor(rh / 2 - 175) + windowoffset
	draw_window(x1, y1, x1 + 550, y1 + 350)
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 10, y1 + 8, "Instrument Settings")
	else draw_text_dynamic(x1 + 10, y1 + 8, "音色设置")
	draw_theme_font(font_main)
	if (language != 1) draw_text_dynamic(x1 + 12, y1 + 31, "These settings only apply to this song. To import the settings from another\nsong, click \"Import\". The sound files must be located in the \"Sounds\" folder.")
	else draw_text_dynamic(x1 + 12, y1 + 31, "这些设定只针对当前歌曲。如需从其他歌曲导入音色，点击“导入”。音色文件\n必须放在“Sounds”文件夹里。")
	draw_set_color(c_white)
	if(theme = 2) draw_set_color(c_dark)
	if (fdark && theme = 3) draw_set_color(2829099)
	draw_rectangle(x1 + 12, y1 + 66, x1 + 535, y1 + 310, 0)
	if (!theme) {
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 12, y1 + 66, x1 + 535, y1 + 310, 1)
	} else {
	    if (theme != 3) draw_area(x1 + 11, y1 + 65, x1 + 535, y1 + 312)
	    else draw_area(x1 + 11, y1 + 67, x1 + 535, y1 + 312)
	}
	tempo_changer_exists = 0
	for (a = 0; a < ds_list_size(songs[song].instrument_list); a++) {
		if (songs[song].instrument_list[| a].name == "Tempo Changer") {
			tempo_changer_exists = 1
			break
		}
	}
	if (mouse_rectangle(x1 + 11, y1 + 67, 524, 245) && mouse_check_button_released(mb_right)) show_menu_ext("add_tempo_changer", mouse_x, mouse_y, inactive(tempo_changer_exists) + condstr(language != 1, "Add tempo changer", "添加变速器"))
	if (language != 1) {
	if (draw_button2(x1 + 455, y1 + 9, 80, "Import", 0, 1)) load_instruments("")
	if (draw_button2(x1 + 455, y1 + 36, 80, "Open Folder", 0, 1)) open_url(sounds_directory)
	// Tabs
	draw_window(x1 + 13 + 194 + 160 + 80, y1 + 67, x1 + 14 + 194 + 160 + 80 + 88 - 1, y1 + 67 + 20, 1)
	popup_set_window(x1 + 13 + 194 + 160 + 80 - 1, y1 + 67, 88, 20, "Whether notes of this type should be\npressed when the marker reaches them.")
	draw_text_dynamic(x1 + 18 + 194 + 160 + 80 - 1, y1 + 70, "Press")
	draw_window(x1 + 13 + 194 + 160, y1 + 67, x1 + 14 + 194 + 160 + 80, y1 + 67 + 20, 1)
	popup_set_window(x1 + 13 + 194 + 160, y1 + 67, 80, 20, "The default key pitch of the sound file.")
	draw_text_dynamic(x1 + 18 + 194 + 160, y1 + 70, "Pitch")
	draw_window(x1 + 13 + 194, y1 + 67, x1 + 14 + 194 + 160, y1 + 67 + 20, 1)
	popup_set_window(x1 + 13 + 194, y1 + 67, 160, 20, "The sound file of this instrument.")
	draw_text_dynamic(x1 + 18 + 194, y1 + 70, "Sound")
	draw_window(x1 + 13 - 2, y1 + 67, x1 + 14 + 194, y1 + 67 + 20, 1)
	popup_set_window(x1 + 13 - 2, y1 + 67, 194, 20, "The name of this instrument.")
	draw_text_dynamic(x1 + 18 - 2, y1 + 70, "Name")
	} else {
	if (draw_button2(x1 + 455, y1 + 9, 80, "导入", 0, 1)) load_instruments("")
	if (draw_button2(x1 + 455, y1 + 36, 80, "打开目录", 0, 1)) open_url(sounds_directory)
	draw_window(x1 + 13 + 194 + 160 + 80, y1 + 67, x1 + 14 + 194 + 160 + 80 + 88 - 1, y1 + 67 + 20, 1)
	popup_set_window(x1 + 13 + 194 + 160 + 80 - 1, y1 + 67, 88, 20, "播放该音色时是否在琴键上显示。")
	draw_text_dynamic(x1 + 18 + 194 + 160 + 80 - 1, y1 + 70, "显示")
	draw_window(x1 + 13 + 194 + 160, y1 + 67, x1 + 14 + 194 + 160 + 80, y1 + 67 + 20, 1)
	popup_set_window(x1 + 13 + 194 + 160, y1 + 67, 80, 20, "声音的默认音调。")
	draw_text_dynamic(x1 + 18 + 194 + 160, y1 + 70, "音调")
	draw_window(x1 + 13 + 194, y1 + 67, x1 + 14 + 194 + 160, y1 + 67 + 20, 1)
	popup_set_window(x1 + 13 + 194, y1 + 67, 160, 20, "此音色的声音文件。")
	draw_text_dynamic(x1 + 18 + 194, y1 + 70, "声音")
	draw_window(x1 + 13 - 2, y1 + 67, x1 + 14 + 194, y1 + 67 + 20, 1)
	popup_set_window(x1 + 13 - 2, y1 + 67, 194, 20, "此音色的名称。")
	draw_text_dynamic(x1 + 18 - 2, y1 + 70, "名称")
	}
	
	var sounds = 0;
	for (var i = first_custom_index; i <= ds_list_size(cursong.instrument_list) - 1; i++) {
		var ins = ds_list_find_value(cursong.instrument_list, i)
		if (ins.filename != "" && ins.loaded) {
			sounds++
		}
	}
	if (language != 1) {if (draw_button2(x1 + 12, y1 + 318, 86, "Export sounds", (cursong.user_instruments == 0 || sounds == 0))) pack_instruments()}
	else {if (draw_button2(x1 + 12, y1 + 318, 86, "导出音色", (cursong.user_instruments == 0 || sounds == 0))) pack_instruments()}
	c = 0
	if (draw_button2(x1 + 110, y1 + 318, 80, condstr(language != 1, "Add", "添加"), cursong.user_instruments >= 240) && wmenu = 0) {
	    cursong.changed = true
	    insselect = ds_list_size(cursong.instrument_list)
	    ds_list_add(cursong.instrument_list, new_instrument("Custom instrument #" + string(cursong.user_instruments + 1), "", true))
	    c = 1
	}
	var userselect = -1;
	if (insselect > -1 && cursong.instrument_list[| insselect].user)
	    userselect = cursong.instrument_list[| insselect]
	if (language != 1) {
	if (draw_button2(x1 + 194, y1 + 318, 80, "Remove", userselect < 0) && wmenu = 0) {
		if ((userselect.num_blocks == 0) || (message_yesnocancel("This will remove " + string(userselect.num_blocks) + " block" + condstr(userselect.num_blocks > 1, "s") + " using this instrument and cannot be undone. Confirm?", "Warning"))) {
			instrument_remove(userselect)
			insselect = min(ds_list_size(cursong.instrument_list) - 1, insselect)
			if (cursong.instrument = userselect)
				cursong.instrument = cursong.instrument_list[| 0]
				selected_vel = 100
				selected_pan = 100
				selected_pit = 0
			c = 1
		}
	}
	if (draw_button2(x1 + 278, y1 + 318, 80, "Shift up", (userselect < 0) || (cursong.user_instruments <= 1) || (insselect == first_custom_index)) && wmenu = 0) {
		insselect -= 1
		instrument_swap(userselect, cursong.instrument_list[| insselect])
		c = 1
	}
	if (draw_button2(x1 + 362, y1 + 318, 80, "Shift down", (userselect < 0) || (cursong.user_instruments <= 1) || (insselect == ds_list_size(cursong.instrument_list) - 1) && wmenu = 0)) {
		insselect += 1
		instrument_swap(userselect, cursong.instrument_list[| insselect])
		c = 1
	}
	if (draw_button2(x1 + 456, y1 + 318, 80, "OK") && wmenu = 0 && (windowopen = 1 || theme != 3)) {
		windowclose = 1
		if (save_version < 5 && cursong.user_instruments > 18) {
			message("This song contains more than 18 instruments and cannot be saved in version " + string(save_version) + ". The save version will be changed to " + string(nbs_version) + ".", "Note Block Studio")
			save_version = nbs_version
		}
		save_settings()
	}
	} else {
	if (draw_button2(x1 + 194, y1 + 318, 80, "移除", userselect < 0) && wmenu = 0) {
		if ((userselect.num_blocks == 0) || (message_yesnocancel("这将移除使用该音色的 " + string(userselect.num_blocks) + " 个方块并且不能撤销。确定吗？", "警告"))) {
			instrument_remove(userselect)
			insselect = min(ds_list_size(cursong.instrument_list) - 1, insselect)
			if (cursong.instrument = userselect)
				cursong.instrument = cursong.instrument_list[| 0]
				selected_vel = 100
				selected_pan = 100
				selected_pit = 0
			c = 1
		}
	}
	if (draw_button2(x1 + 278, y1 + 318, 80, "上移", (userselect < 0) || (cursong.user_instruments <= 1) || (insselect == first_custom_index)) && wmenu = 0) {
		insselect -= 1
		instrument_swap(userselect, cursong.instrument_list[| insselect])
		c = 1
	}
	if (draw_button2(x1 + 362, y1 + 318, 80, "下移", (userselect < 0) || (cursong.user_instruments <= 1) || (insselect == ds_list_size(cursong.instrument_list) - 1) && wmenu = 0)) {
		insselect += 1
		instrument_swap(userselect, cursong.instrument_list[| insselect])
		c = 1
	}
	if (draw_button2(x1 + 456, y1 + 318, 80, "确定") && wmenu = 0 && (windowopen = 1 || theme != 3)) {
		windowclose = 1
		if (save_version < 5 && cursong.user_instruments > 18) {
			message("此歌曲含有多于18个音色，无法保存为版本 " + string(save_version) + "。将保存为版本 " + string(nbs_version) + "。", "Note Block Studio")
			save_version = nbs_version
		}
		save_settings()
	}
	}
	if (mouse_check_button_pressed(mb_left)) {
	    insedit = -1
	}
	if (mouse_check_button_released(mb_left) && c = 0) {
	    if (!mouse_rectangle(x1 + 14, y1 + 88, 476, min(ds_list_size(cursong.instrument_list) * 20, 220)) && (!mouse_rectangle(x1 + 14, y1 + 318, 476, 24))) {
			insselect = -1
		}
	}
	// Instruments
	for (a = 0; a <= 10; a += 1) {
	    b = floor(sb_val[3]) + a
	    if (b >= ds_list_size(cursong.instrument_list)) break
	    var ins = cursong.instrument_list[| b];
	    if (insselect = b) {
	        draw_set_color(10512468)
	        draw_rectangle(x1 + 14, y1 + 106 + 20 * a - 20, x1 + 520, y1 + 106 + 20 * a, 0)
	    }
	    draw_set_color(12632256)
	    draw_line(x1 + 14, y1 + 106 + 20 * a, x1 + 520, y1 + 106 + 20 * a)
	    draw_set_color(make_color_rgb(120, 120, 120))
	    if (ins.user) draw_theme_color()
	    if (insselect = b) draw_set_color(c_white)
	    // INS NAME
		prev = ins.name
	    ins.name = draw_text_edit(70 + b, ins.name, x1 + 18, y1 + 90 + 20 * a, 178, 20, 1, b < first_custom_index)
		if (ins.name != prev) cursong.changed = 1
	    // INS SOUND
	    draw_set_color(make_color_rgb(120, 120, 120))
	    if (ins.user) {draw_theme_color()}
	    if (!ins.loaded) draw_set_color(c_red)
	    if (insselect = b) draw_set_color(c_white)
		if (language != 1) {
	    draw_text_dynamic(x1 + 18 + 194, y1 + 90 + 20 * a, condstr(ins.filename = "", "None") + string_truncate(ins.filename, 144, true))
	    if (ins.filename = "") popup_set_window(x1 + 14 + 194, y1 + 88 + 20 * a, 160, 20, "No sound file has been selected\nfor this instrument.")
	    else if (!ins.loaded) popup_set_window(x1 + 14 + 194, y1 + 88 + 20 * a, 160, 20, "This sound file could not be found.")
		} else {
		draw_text_dynamic(x1 + 18 + 194, y1 + 90 + 20 * a, condstr(ins.filename = "", "无") + string_truncate(ins.filename, 144, true))
	    if (ins.filename = "") popup_set_window(x1 + 14 + 194, y1 + 88 + 20 * a, 160, 20, "该音色未指定声音文件。")
	    else if (!ins.loaded) popup_set_window(x1 + 14 + 194, y1 + 88 + 20 * a, 160, 20, "找不到该声音文件。")
		}
	    if (mouse_rectangle(x1 + 14 + 194, y1 + 88 + 20 * a, 160, 20) && insselect = b && wmenu = 0) {
	        if (mouse_check_button_pressed(mb_left)) {
	            if (ins.user) {
					instrument_change(ins)
	            } else {
	                if (language != 1) message("The sound file for this instrument cannot be changed.", "Error")
	                else message("无法更改该音色的声音文件。", "错误")
	            }
	        }
	        if (ins.user) curs = cr_handpoint
	    }
	    // INS KEY
	    draw_set_color(make_color_rgb(120, 120, 120))
	    if (ins.user) {draw_theme_color()}
	    if (insselect = b) draw_set_color(c_white)
	    if (ins.user) {
	        if (draw_abutton(x1 + 18 + 194 + 216, y1 + 88 + 20 * a) && wmenu = 0) {
	            var key, oct;
	            str = ""
	            key = 0
	            oct = 0
	            if (language != 1) str += "Octave 0|\\|"
	            else str += "0 八度|\\|"
	            while (1) {
	                str += check(ins.key = key) + get_keyname(key, 1) + "|"
	                key += 1
	                if (key = 88) break
	                if ((key - 3) mod 12 = 0) {
	                    oct += 1
	                    if (language != 1) str += "/|Octave " + string(oct) + "|\\|"
	                    else str += "/|" + string(oct) + " 八度|\\|"
	                }
	            }
	            str += "/"
	            menu = show_menu_ext("instruments_pitch", x1 + 18 + 194 + 155, y1 + 106 + 20 * a, str)
	            menu.menub = b
	        }
	    }
	    draw_text_dynamic(x1 + 18 + 194 + 160, y1 + 90 + 20 * a, get_keyname(ins.key, 1))
	    // INS PRESS
	    draw_theme_color()
	    if (insselect = b) draw_set_color(c_white)
	    if (draw_abutton(x1 + 18 + 194 + 175 + 112, y1 + 88 + 20 * a) && wmenu = 0) {
	        if (language != 1) menu = show_menu_ext("instruments_press", x1 + 18 + 194 + 235, y1 + 106 + 20 * a, check(ins.press) + "Yes|" + check(!ins.press) + "No")
	        else menu = show_menu_ext("instruments_press", x1 + 18 + 194 + 235, y1 + 106 + 20 * a, check(ins.press) + "是|" + check(!ins.press) + "否")
	        menu.menub = b
	    }
	    if (language != 1) draw_text_dynamic(x1 + 18 + 194 + 160 + 80, y1 + 90 + 20 * a, test(ins.press, "Yes", "No"))
	    else draw_text_dynamic(x1 + 18 + 194 + 160 + 80, y1 + 90 + 20 * a, test(ins.press, "是", "否"))
	    if (mouse_rectangle(x1 + 14, y1 + 88 + 20 * a, 460, 20) && wmenu = 0) {
	        if (mouse_check_button_pressed(mb_left)) {
	            insselect = b
	        }
	    }
	}
	if (wmenu = 1 && !mouse_check_button(mb_left)) wmenu = 0
	draw_set_color(12632256)
	draw_line(x1 + 13 + 194, y1 + 87, x1 + 13 + 194, y1 + 86 + 20 * a)
	draw_line(x1 + 13 + 194 + 160, y1 + 87, x1 + 13 + 194 + 160, y1 + 86 + 20 * a)
	draw_line(x1 + 13 + 194 + 160 + 80, y1 + 87, x1 + 13 + 194 + 160 + 80, y1 + 86 + 20 * a)
	draw_scrollbar(insscrollbar, x1 + 14 + 194 + 160 + 80 + 70, y1 + 88, 21, 9, ds_list_size(cursong.instrument_list) - 2, 0, 1)
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
	
}
