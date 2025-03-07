function draw_window_preferences() {
	// draw_window_preferences()
	var x1, y1, a, b, c, as, stabx, stabw, nsel, str, accentclick;
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	nsel = -1
	accentclick = 0
	x1 = floor(rw / 2 - 250)
	y1 = floor(rh / 2 - 255 + isplayer * 50) + windowoffset
	draw_window(x1, y1, x1 + 500, y1 + 510 - isplayer * 100)
	if (theme = 3){
	draw_set_color(15132390)
	if (fdark) draw_set_color(1513239)
	// draw_rectangle(x1+1,y1+30,x1+498,y1+69,0) //48
	draw_set_color(c_black)
	if (fdark) draw_set_color(c_white)
	}
	draw_theme_font(font_main_bold)
		if (theme = 3) draw_theme_font(font_main)
	if (language != 1) draw_text_dynamic(x1 + 8 + (theme = 3) * 2, y1 + 8 + (theme = 3), "Preferences")
	else draw_text_dynamic(x1 + 8 + (theme = 3) * 2, y1 + 8 + (theme = 3), "首选项")
	draw_theme_font(font_main)
		if (theme = 3) draw_theme_font(font_main)
	b = 8 + (theme = 3) * 32
	if (language != 1) {
	str[0] = "General"
	str[1] = "Interface"
	if (!isplayer) {
	str[2] = "Appearance"
	str[3] = "Usability"
	str[4] = "Playback"
	}
	} else {
	str[0] = "通用"
	str[1] = "界面"
	if (!isplayer) {
	str[2] = "外观"
	str[3] = "访问"
	str[4] = "播放"
	}
	}
	if (theme = 3) {
		c = (mouse_check_button(mb_left))
		if (mouse_rectangle(x1, y1 + 30, 40, 40)) {
			draw_set_color(15395562)
			if (fdark) draw_set_color(4539717)
			if (c) {
				draw_set_color(15658734)
				if (fdark) draw_set_color(5789784)
			}
			draw_roundrect(x1 + 1, y1 + 31, x1 + 41, y1 + 67, 0)
			if (mouse_check_button_released(mb_left) && windowopen = 1) {
				if (windowsound && theme = 3) play_sound(soundgoback, 45, 100, 100, 0)
				windowclose = 1
			}
		}
		if (!hires) draw_sprite(spr_back, fdark + 2 * (c && mouse_rectangle(x1, y1 + 30, 40, 40)), x1 + 14, y1 + 30 + 12)
		else draw_sprite_ext(spr_back_hires, fdark + 2 * (c && mouse_rectangle(x1, y1 + 30, 40, 40)), x1 + 14, y1 + 30 + 12, 0.25, 0.25, 0, -1, draw_get_alpha())
	}
	if (theme = 1) {
	    draw_window(x1 + 4, y1 + 45, x1 + 496, y1 + 474 - isplayer * 100)
	}
	if (theme != 3) {
	for (a = 0; a < array_length(str); a += 1) {
	    c = mouse_rectangle(x1 + b, y1 + 28, string_width_dynamic(str[a]) + 12, 18)
	    if (selected_tab = a) {
	        stabx = b - 2
	        stabw = string_width_dynamic(str[a]) + 15
	    } else {
			draw_sprite(spr_tabbuttons, 0 + 3 * c + 6 * theme, x1 + b, y1 + 28)
			draw_sprite_ext(spr_tabbuttons, 1 + 3 * c + 6 * theme, x1 + b + 2, y1 + 28, string_width_dynamic(str[a]) / 2 + 4, 1, 0, -1, draw_get_alpha())
			draw_sprite(spr_tabbuttons, 2 + 3 * c + 6 * theme, x1 + b + string_width_dynamic(str[a]) + 10, y1 + 28)	
	        draw_text_dynamic(x1 + b + 6, y1 + 30, str[a])
	    }
	    if (mouse_check_button_pressed(mb_left) && c) nsel = a
	    b += string_width_dynamic(str[a]) + 12
	}
	if (theme = 0 || theme = 2 || theme = 3) {
	    draw_set_color(c_white)
		if(theme = 2) draw_set_color(c_dark)
	    if (theme != 3) draw_rectangle(x1 + 6, y1 + 46, x1 + 494, y1 + 472 - isplayer * 100, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    if (theme != 3) draw_rectangle(x1 + 6, y1 + 46, x1 + 494, y1 + 472 - isplayer * 100, 1)
	    draw_set_color(c_white)
		if(theme = 2 || (fdark && theme = 3)) draw_set_color(c_dark)
	    if (theme = 3) {
			draw_roundrect(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 25, 0)
		} else {
			draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 0)
		}
	    draw_set_color(make_color_rgb(137, 140, 149))
	    if (theme != 3) draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 1)
	    draw_set_color(c_white)
		if(theme = 2 || (fdark && theme = 3)) draw_set_color(c_dark)
	    draw_rectangle(x1 + stabx + 1, y1 + 46, x1 + stabx + stabw - 1, y1 + 47, 0)
	    draw_theme_color()
	    draw_text_dynamic(x1 + stabx + 8, y1 + 28, str[selected_tab])
	    draw_set_color(make_color_rgb(213, 223, 229))
	    if(theme = 0) draw_roundrect(x1 + 10, y1 + 50, x1 + 490, y1 + 468 - isplayer * 100, 1)
	}else{
	    draw_sprite(spr_tabbuttons, 24, x1 + stabx - 1, y1 + 26)
	    draw_sprite_ext(spr_tabbuttons, 25, x1 + stabx + 1, y1 + 26, stabw / 2 - 1, 1, 0, -1, 1)
	    draw_sprite(spr_tabbuttons, 26, x1 + stabx + stabw - 1, y1 + 26)
	    draw_text_dynamic(x1 + stabx + 8, y1 + 28, str[selected_tab])
	}
	} else {
	draw_theme_font(font_med)
	for (a = 0; a < array_length(str); a += 1) {
		draw_set_color(c_black)
		if (fdark) draw_set_color(c_white)
	    c = mouse_rectangle(x1 + b, y1 + 28 + 21 - 19, string_width_dynamic(str[a]) + 12, 18 + 21)
	    if (selected_tab = a) {
			//draw_set_color(accent[7])
			//if (fdark) draw_set_color(accent[8])
	        //draw_line(x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 8, y1 + 30 + 21 + 18 - 6, x1 + b + 5 + string_width_dynamic(str[a]) / 2 + 8, y1 + 30 + 21 + 18 - 6)
	        //draw_line(x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 8, y1 + 30 + 21 + 20 - 6, x1 + b + 5 + string_width_dynamic(str[a]) / 2 + 8, y1 + 30 + 21 + 20 - 6)
			//draw_set_color(accent[6])
			//if (fdark) draw_set_color(accent[2])
	        //draw_line(x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 7, y1 + 30 + 21 + 18 - 6, x1 + b + 5 + string_width_dynamic(str[a]) / 2 + 7, y1 + 30 + 21 + 18 - 6)
	        //draw_line(x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 8, y1 + 30 + 21 + 19 - 6, x1 + b + 5 + string_width_dynamic(str[a]) / 2 + 8, y1 + 30 + 21 + 19 - 6)
	        //draw_line(x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 7, y1 + 30 + 21 + 20 - 6, x1 + b + 5 + string_width_dynamic(str[a]) / 2 + 7, y1 + 30 + 21 + 20 - 6)
			//draw_set_color(accent[4])
	        //draw_line(x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 6, y1 + 30 + 21 + 18 - 6, x1 + b + 5 + string_width_dynamic(str[a]) / 2 + 6, y1 + 30 + 21 + 18 - 6)
	        //draw_line(x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 7, y1 + 30 + 21 + 19 - 6, x1 + b + 5 + string_width_dynamic(str[a]) / 2 + 7, y1 + 30 + 21 + 19 - 6)
	        //draw_line(x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 6, y1 + 30 + 21 + 20 - 6, x1 + b + 5 + string_width_dynamic(str[a]) / 2 + 6, y1 + 30 + 21 + 20 - 6)
			draw_sprite_ext(spr_tabsel, 2 * hires, x1 + b + 5 + string_width_dynamic(str[a]) / 2 - 6, y1 + 30 + 21 + 18 - 6, 1 - 0.75 * hires, 1 - 0.75 * hires, 0, accent[4], draw_get_alpha())
			draw_set_color(c_black)
			if (fdark) draw_set_color(c_white)
	    }
		if (mouse_check_button(mb_left) && c) {
			// draw_sprite(spr_tabbuttons_f, 6 + 9 * fdark, x1 + b, y1 + 28 + 21 - 19)
			// draw_sprite_ext(spr_tabbuttons_f, 7 + 9 * fdark, x1 + b + 2, y1 + 28 + 21 - 19, string_width_dynamic(str[a]) / 2 + 4, 1, 0, -1, 1)
			// draw_sprite(spr_tabbuttons_f, 8 + 9 * fdark, x1 + b + string_width_dynamic(str[a]) + 10, y1 + 28 + 21 - 19)	
			draw_set_color(7631988)
			if (fdark) draw_set_color(11579568)
			if (selected_tab = a) draw_set_color(10000536)
			if (selected_tab = a && fdark) draw_set_color(10724259)
		} else if (c) {
			// draw_sprite(spr_tabbuttons_f, 0 + 3 * c + 9 * fdark, x1 + b, y1 + 28 + 21 - 19)
			// draw_sprite_ext(spr_tabbuttons_f, 1 + 3 * c + 9 * fdark, x1 + b + 2, y1 + 28 + 21 - 19, string_width_dynamic(str[a]) / 2 + 4, 1, 0, -1, 1)
			// draw_sprite(spr_tabbuttons_f, 2 + 3 * c + 9 * fdark, x1 + b + string_width_dynamic(str[a]) + 10, y1 + 28 + 21 - 19)	
			if (selected_tab = a) draw_set_color(7631988)
			if (selected_tab = a && fdark) draw_set_color(11579568)
		}
	    draw_text_dynamic(x1 + b + 6, y1 + 30 + 21 - 8, str[a])
	    if (mouse_check_button_released(mb_left) && c) nsel = a
	    b += string_width_dynamic(str[a]) + 12
	}
	}
	if (nsel > -1) selected_tab = nsel
	selected_tab += keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
	if (selected_tab < 0) selected_tab = 4
	if (selected_tab > 4) selected_tab = 0
	draw_theme_color()
	if (selected_tab = 0) {
		if (theme = 3) draw_theme_font(font_info_med)
	    if (language != 1) draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 243, 85, "Startup")
	    else draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 243, 85, "启动")
		if (theme = 3) draw_theme_font(font_main)
		if (language != 1) {
			if (draw_checkbox(x1 + 40, y1 + 90 + (theme = 3) * 22, show_welcome, "Show greeting window", "Whether to show the greeting window\nwhen the program is opened.", false, true)) show_welcome=!show_welcome
		} else { 
			if (draw_checkbox(x1 + 40, y1 + 90 + (theme = 3) * 22, show_welcome, "显示欢迎界面", "打开软件时是否显示欢迎界面。", false, true)) show_welcome=!show_welcome
		}
		if (language != 1) {
			if (draw_checkbox(x1 + 40, y1 + 110 + (theme = 3) * 22, check_update, "Check for updates", "Whether to check for any updates\nwhen the program is opened.", false, true)) check_update=!check_update
			if (draw_checkbox(x1 + 60, y1 + 130 + (theme = 3) * 22, check_prerelease, "Check for development versions", "Whether to check for development versions in addition to stable releases.\nDevelopment versions contain the latest improvements, but may be potentially unstable.", !check_update, false)) {
				check_prerelease = !check_prerelease
				if (!is_prerelease && check_prerelease) {
					if (!message_yesnocancel("Development versions are experimental and may be unstable. To avoid data corruption, it's highly recommended that you install Note Block Studio to a separate directory before enabling this option.\n\nProceed?", "Warning")) {
						check_prerelease = !check_prerelease // undo button check
					}
				} else if (is_prerelease && !check_prerelease) {
					if (!message_yesnocancel("You're currently running a development version of Note Block Studio. By disabling this option, you will be prompted to downgrade to the latest stable version the next time you open the program.\n\nProceed?", "Warning")) {
						check_prerelease = !check_prerelease // undo button uncheck
					}
				}
			}
		} else {
			if (draw_checkbox(x1 + 40, y1 + 110 + (theme = 3) * 22, check_update, "检查更新", "打开软件时是否检查更新。", false, true)) check_update=!check_update
			if (draw_checkbox(x1 + 60, y1 + 130 + (theme = 3) * 22, check_prerelease, "检查开发版本", "是否在稳定版之外额外检测开发版。\n开发版本包含最新的内容，但可能不稳定。", !check_update, false)) {
				check_prerelease = !check_prerelease
				if (!is_prerelease && check_prerelease) {
					if (!message_yesnocancel("开发版本仍在测试中，可能会不稳定。为了防止数据损坏，强烈建议您在开启该选项前将 Note Block Studio 安装到一个单独的目录。\n\n继续吗？", "警告")) {
						check_prerelease = !check_prerelease // undo button check
					}
				} else if (is_prerelease && !check_prerelease) {
					if (!message_yesnocancel("您正在运行一个 Note Block Studio 的开发版本。关闭这个选项后，在下次开启此程序时您将会被提示降级至最新的稳定版。\n\n继续吗？", "警告")) {
						check_prerelease = !check_prerelease // undo button uncheck
					}
				}
			}
		}
		if (wmenu = 1 && !mouse_check_button(mb_left)) wmenu = 0
		// Auto-saving
		if (!isplayer) {
		if (theme = 3) draw_theme_font(font_info_med)
		if (language != 1) draw_areaheader(x1 + 278, y1 + 74 + (theme = 3) * 22, 200, 85, "Auto-saving")
		else draw_areaheader(x1 + 278, y1 + 74 + (theme = 3) * 22, 200, 85, "自动保存")
		if (theme = 3) draw_theme_font(font_main)
		as = autosave
		if (language != 1) {if (draw_checkbox(x1 + 296, y1 + 90 + (theme = 3) * 22, autosave, "Enable auto-saving", "Whether the song should automatically\nbe saved every now and then.", false, true)) autosave=!autosave}
		else {if (draw_checkbox(x1 + 296, y1 + 90 + (theme = 3) * 22, autosave, "启用自动保存", "歌曲是否每过一段时间自动保存一次。", false, true)) autosave=!autosave}
		if (as != autosave) {
		    if (autosave = 0) tonextsave = 0
		    if (autosave = 1) tonextsave = autosavemins
		}
		if (autosave = 0) {
		    draw_set_color(c_gray)
		    if (language != 1) draw_text_dynamic(x1 + 326, y1 + 110 + (theme = 3) * 22, "Interval:       minute" + condstr(autosavemins > 1, "s"))
		    else draw_text_dynamic(x1 + 326, y1 + 110 + (theme = 3) * 22, "间隔:            分钟")
			draw_text_dynamic(x1 + 375, y1 + 110 + (theme = 3) * 22, autosavemins)
		    draw_theme_color()
		} else {
			if (language != 1) draw_text_dynamic(x1 + 326, y1 + 110 + (theme = 3) * 22, "Interval:       minute" + condstr(autosavemins > 1, "s"))
		    else draw_text_dynamic(x1 + 326, y1 + 110 + (theme = 3) * 22, "间隔:            分钟")
			as = autosavemins
			autosavemins = median(1, draw_dragvalue(2, x1 + 375, y1 + 110 + (theme = 3) * 22, autosavemins, 1), 60)
			if (autosavemins != a) {tonextsave = autosavemins}
		}
		if (language != 1) popup_set_window(x1 + 326, y1 + 110 + (theme = 3) * 22, 180, 16, "The amount of minutes between each auto-save.")
		else popup_set_window(x1 + 326, y1 + 110 + (theme = 3) * 22, 180, 16, "自动保存中间的间隔。")
		}
	
		
		if (!isplayer) {
		if (theme = 3) draw_theme_font(font_info_med)
		if (language != 1) draw_areaheader(x1 + 22, y1 + 184 + (theme = 3) * 22, 456, 145, "Songs")
		else draw_areaheader(x1 + 22, y1 + 184 + (theme = 3) * 22, 456, 145, "歌曲")
		if (theme = 3) draw_theme_font(font_main)
		if (language != 1) {
		if (draw_checkbox(x1 + 40, y1 + 200 + (theme = 3) * 22, show_oldwarning, "Show warning when opening older songs", "Whether to show a warning when opening a song\nsaved in an older version of Note Block Studio.", false, true)) show_oldwarning = !show_oldwarning
		draw_text_dynamic(x1 + 40, y1 + 230 + (theme = 3) * 22, "Song folder: " + string_truncate(songfolder, 340), true)
	    popup_set_window(x1 + 40, y1 + 230 + (theme = 3) * 22, 430, 18, songfolder)
	    if (draw_button2(x1 + 40, y1 + 246 + (theme = 3) * 22, 76, "Open", 0, 1)) {
	        if (!directory_exists_lib(songfolder)) {
	            message("The indicated folder doesn't exist!", "Error")
	        } else {
	            open_url(songfolder)
	        }
	    }
	    if (draw_button2(x1 + 40 + 84, y1 + 246 + (theme = 3) * 22, 76, "Change", 0, 1)) {
	        message("Select the directory where saving/loading should be opened in.", "")
	        a = string(get_save_filename_ext("", "Select song folder", songfolder, "Song folder"))
	        if (a != "") songfolder = filename_dir(a)
	    }
	    if (draw_button2(x1 + 40 + 84 + 84, y1 + 246 + (theme = 3) * 22, 96, "Use default", 0, 1)) songfolder = songs_directory
	
		draw_text_dynamic(x1 + 40, y1 + 280 + (theme = 3) * 22, "Pattern folder: " + string_truncate(patternfolder, 340), true)
	    popup_set_window(x1 + 40, y1 + 280 + (theme = 3) * 22, 430, 18, patternfolder)
	    if (draw_button2(x1 + 40, y1 + 296 + (theme = 3) * 22, 76, "Open", 0, 1)) {
	        if (!directory_exists_lib(patternfolder)) {
	            message("The indicated folder doesn't exist!", "Error")
	        } else {
	            open_url(patternfolder)
	        }
	    }
	    if (draw_button2(x1 + 40 + 84, y1 + 296 + (theme = 3) * 22, 76, "Change", 0, 1)) {
	        message("Select the directory where patterns can be imported/exported to.", "")
	        a = string(get_save_filename_ext("", "Select patterns folder", patternfolder, "Pattern folder"))
	        if (a != "") patternfolder = filename_dir(a)
	    }
	    if (draw_button2(x1 + 40 + 84 + 84, y1 + 296 + (theme = 3) * 22, 96, "Use default", 0, 1)) patternfolder = pattern_directory
		} else {
		if (draw_checkbox(x1 + 40, y1 + 200 + (theme = 3) * 22, show_oldwarning, "打开旧版格式时提示", "打开在旧版 Note Block Studio 中保存的文件时是否显示警告。", false, true)) show_oldwarning = !show_oldwarning
		draw_text_dynamic(x1 + 40, y1 + 230 + (theme = 3) * 22, "歌曲路径: " + string_truncate(songfolder, 340))
	    popup_set_window(x1 + 40, y1 + 230 + (theme = 3) * 22, 430, 18, songfolder)
	    if (draw_button2(x1 + 40, y1 + 246 + (theme = 3) * 22, 76, "打开", 0, 1)) {
	        if (!directory_exists_lib(songfolder)) {
	            message("该路径不存在！", "错误")
	        } else {
	            open_url(songfolder)
	        }
	    }
	    if (draw_button2(x1 + 40 + 84, y1 + 246 + (theme = 3) * 22, 76, "修改", 0, 1)) {
	        message("选择保存和打开的文件夹", "")
	        a = string(get_save_filename_ext("", "选择歌曲文件夹", songfolder, "歌曲文件夹"))
	        if (a != "") songfolder = filename_dir(a)
	    }
	    if (draw_button2(x1 + 40 + 84 + 84, y1 + 246 + (theme = 3) * 22, 96, "还原默认", 0, 1)) songfolder = songs_directory
	
		draw_text_dynamic(x1 + 40, y1 + 280 + (theme = 3) * 22, "片段路径: " + string_truncate(patternfolder, 340))
	    popup_set_window(x1 + 40, y1 + 280 + (theme = 3) * 22, 430, 18, patternfolder)
	    if (draw_button2(x1 + 40, y1 + 296 + (theme = 3) * 22, 76, "打开", 0, 1)) {
	        if (!directory_exists_lib(patternfolder)) {
	            message("该路径不存在！", "错误")
	        } else {
	            open_url(patternfolder)
	        }
	    }
	    if (draw_button2(x1 + 40 + 84, y1 + 296 + (theme = 3) * 22, 76, "修改", 0, 1)) {
	        message("选择导出和导入片段的文件夹", "")
	        a = string(get_save_filename_ext("", "选择片段文件夹", patternfolder, "片段文件夹"))
	        if (a != "") patternfolder = filename_dir(a)
	    }
	    if (draw_button2(x1 + 40 + 84 + 84, y1 + 296 + (theme = 3) * 22, 96, "还原默认", 0, 1)) patternfolder = pattern_directory
		}
		}
		if (theme = 3) draw_theme_font(font_info_med)
		draw_areaheader(x1 + 22, y1 + 354 + (theme = 3) * 22 - 170 * isplayer, 456, 45, "Discord")
		if (theme = 3) draw_theme_font(font_main)
		if (language != 1) {
		if (draw_checkbox(x1 + 40, y1 + 354 + 16 + (theme = 3) * 22 - 170 * isplayer, presence, "Enable Discord Rich Presence", "Whether to display info about your current\nsong in your Discord status activity.", 0, 1)) {
		    presence = !presence
			if (presence = 1) {
				np_setpresence_timestamps(date_current_datetime(), 0, false);
			}
		}
		} else {
		if (draw_checkbox(x1 + 40, y1 + 354 + 16 + (theme = 3) * 22 - 170 * isplayer, presence, "启用 Discord Rich Presence", "是否在 Discord 个人状态中显示当前歌曲信息。", 0, 1)) {
		    presence = !presence
			if (presence = 1) {
				np_setpresence_timestamps(date_current_datetime(), 0, false);
			}
		}
		}
	} else if (selected_tab = 1) {
		if (theme = 3) draw_theme_font(font_info_med)
	    if (language != 1) draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 218, 140, "Theme")
	    else draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 218, 140, "主题")
		if (theme = 3) draw_theme_font(font_main)
		draw_area(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 5, x1 + 140, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 5)
		if (draw_abutton(x1 + 140 - 17, y1 + 74 + 17 + (theme = 3) * 22 + 5) && wmenu = 0) {
	        if (language != 1) menu = show_menu_ext("theme", x1 + 40, y1 + 74 + 16 + 21 + (theme = 3) * 22 + 5, check(theme = 0) + "Aqua|" + check(theme = 2) + "Dark|" + check(theme = 1) + "90s|" + check(theme = 3) + "Fluent")
	        else menu = show_menu_ext("theme", x1 + 40, y1 + 74 + 16 + 21 + (theme = 3) * 22 + 5, check(theme = 0) + "经典|" + check(theme = 2) + "暗黑|" + check(theme = 1) + "复古|" + check(theme = 3) + "Fluent")
	    }
	    if (language != 1) draw_text_dynamic(x1 + 43, y1 + 74 + 19 + (theme = 3) * 22 + 5, condstr(theme = 0, "Aqua") + condstr(theme = 2, "Dark") + condstr(theme = 1, "90s") + condstr(theme = 3, "Fluent"))
	    else draw_text_dynamic(x1 + 43, y1 + 74 + 19 + (theme = 3) * 22 + 5, condstr(theme = 0, "经典") + condstr(theme = 2, "暗黑") + condstr(theme = 1, "复古") + condstr(theme = 3, "Fluent"))
	    //if (draw_radiobox(x1 + 40, y1 + (theme = 3) * 22 + 164 + 16, theme == 0, "Aqua", "Use the aqua theme.")) {theme = 0 change_theme()}
		//if (draw_radiobox(x1 + 40, y1 + (theme = 3) * 22 + 164 + 16 + 20, theme == 2, "Dark", "Use the dark theme.")) {theme = 2 change_theme()}
	    //if (draw_radiobox(x1 + 40, y1 + (theme = 3) * 22 + 164 + 16 + 20 + 20, theme == 1, "90s", "Use the 90s theme.")) {theme = 1 change_theme()}
	    //if (draw_radiobox(x1 + 40, y1 + (theme = 3) * 22 + 164 + 16 + 20 + 20 + 20, theme == 3, "Fluent", "Use the fluent theme.")) {theme = 3 change_theme()}
		if (language != 1) {
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 20 + 20 + 20 + 25, blackout, "Blackout mode", "Makes the workspace background solid black, so you can\nremove in your video editor when recording the screen.", false, true)) blackout = !blackout
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 20 + 25, windowsound, "Navigation sound", "Whether to play sound effects when navigating the interface.\n(Only applies to the Fluent theme.)", (theme != 3), true)) windowsound = !windowsound
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 25, fdark, "Dark mode", "Whether to use darker colors on the interface.\n(Only applies to the Fluent theme.)", (theme != 3), true)) {fdark = !fdark if (fdark) window_set_darkmode() else window_unset_darkmode()}
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 20 + 20 + 25, acrylic, "Transparency effects", condstr(os_type = os_windows, "Whether to show transparency effects on the interface.\n(Only applies to the Fluent theme.)", "This function only works on the Windows platform."), (theme != 3 || os_type != os_windows), true)) {acrylic = !acrylic change_theme()}
		} else {
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 20 + 20 + 20 + 25, blackout, "全黑模式", "使背景变为纯黑色，可以用于剪辑时扣掉。", false, true)) blackout = !blackout
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 20 + 25, windowsound, "界面音效", "是否在浏览时播放音效。\n（仅限 Fluent 主题）", (theme != 3), true)) windowsound = !windowsound
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 25, fdark, "暗色模式", "是否在界面上使用暗色调。\n（仅限 Fluent 主题）", (theme != 3), true)) {fdark = !fdark if (fdark) window_set_darkmode() else window_unset_darkmode()}
		//if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 20 + 20 + 25, acrylic, "透明效果", condstr(os_type = os_windows, "是否在界面上显示透明效果。\n（仅限 Fluent 主题）", "该功能在非Windows平台不可用。"), (theme != 3 || os_type != os_windows), true)) {acrylic = !acrylic change_theme()}
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 74 + 16 + 20 + 20 + 20 + 25, acrylic, "透明效果", "是否在界面上显示透明效果。\n（仅限 Fluent 主题）", theme != 3, true)) {acrylic = !acrylic change_theme()}
		}
		
		// Accent color picker
		if (theme == 3) {
			var xx = x1 + 160
			var yy = y1 + 98 + (theme = 3) * 22
			if (theme = 1) draw_set_color(13160660)
			if (theme = 2) draw_set_color(c_dark)
			if (theme = 3) draw_set_color(15987699)
			if (theme = 3 && fdark) draw_set_color(2105376)
			accentclick = mouse_rectangle(xx - 2, yy - 2, 17, 17)
			if (accentclick = 1) accentclick += mouse_check_button(mb_left)
			draw_roundrect_ext(xx - 2, yy - 2, xx + 15, yy + 15, 4, 4, false)
			draw_theme_color()
			draw_roundrect_ext(xx - 2, yy - 2, xx + 15, yy + 15, 4, 4, true)
			draw_set_color(accent[3 + (accentclick = 1) * 3 - (accentclick = 2) * 3])
			draw_roundrect_ext(xx, yy, xx + 13, yy + 13, 4, 4, false)
			if (language != 1) popup_set_window(xx - 2, yy - 2, 17, 17, "Click to change the theme's accent color.")
			else popup_set_window(xx - 2, yy - 2, 17, 17, "点击更改此主题的主题色。")
			if (mouse_check_button_released(mb_left) && accentclick) {
				window = w_setaccent
				resetcolor = true
				if (windowsound) play_sound(soundinvoke, 45, 100, 50, 0)
			}
		}
		
		//if (theme = 3) draw_text_dynamic(x1 + 40 + 100, y1 + (theme = 3) * 22 + 164 + 15, "Color")
		//if (theme = 3) {
		//	if (draw_radiobox(x1 + 40 + 100, y1 + (theme = 3) * 22 + 164 + 16 + 20, !fdark, "Light", "Use the light mode.")) fdark = 0
		//	if (draw_radiobox(x1 + 40 + 100, y1 + (theme = 3) * 22 + 164 + 16 + 20 + 20, fdark, "Dark", "Use the dark mode.")) fdark = 1
		//}
		if (theme = 3) draw_theme_font(font_info_med)
	    if (language != 1) draw_areaheader(x1+258,y1+74 + (theme = 3) * 22,220,60,"Max. frame rate")
	    else draw_areaheader(x1+258,y1+74 + (theme = 3) * 22,220,60,"帧率限制")
		if (theme = 3) draw_theme_font(font_main)
		draw_area(x1 + 274, y1 + 74 + 16 + (theme = 3) * 22 + 5, x1 + 374, y1 + 74 + 16 + 20 + (theme = 3) * 22 + 5)
		if (draw_abutton(x1 + 374 - 17, y1 + 74 + 17 + (theme = 3) * 22 + 5) && wmenu = 0) {
	        if (language != 1) menu = show_menu_ext("refreshrate", x1 + 274, y1 + 74 + 16 + 21 + (theme = 3) * 22 + 5, check(refreshrate = 0) + "30FPS|" + check(refreshrate = 1) + "60FPS|" + check(refreshrate = 2) + "120FPS|" + check(refreshrate = 3) + "144FPS|" + check(refreshrate = 4) + "240FPS")
	        else menu = show_menu_ext("refreshrate", x1 + 274, y1 + 74 + 16 + 21 + (theme = 3) * 22 + 5, check(refreshrate = 0) + "30帧|" + check(refreshrate = 1) + "60帧|" + check(refreshrate = 2) + "120帧|" + check(refreshrate = 3) + "144帧|" + check(refreshrate = 4) + "240帧")
	    }
	    if (language != 1) draw_text_dynamic(x1 + 277, y1 + 74 + 19 + (theme = 3) * 22 + 5, condstr(refreshrate = 0, "30FPS") + condstr(refreshrate = 1, "60FPS") + condstr(refreshrate = 2, "120FPS") + condstr(refreshrate = 3, "144FPS") + condstr(refreshrate = 4, "240FPS"))
	    else draw_text_dynamic(x1 + 277, y1 + 74 + 19 + (theme = 3) * 22 + 5, condstr(refreshrate = 0, "30帧") + condstr(refreshrate = 1, "60帧") + condstr(refreshrate = 2, "120帧") + condstr(refreshrate = 3, "144帧") + condstr(refreshrate = 4, "240帧"))
		if (wmenu = 1 && !mouse_check_button(mb_left)) wmenu = 0
	    //if (draw_radiobox(x1+274,y1+164+16 + (theme = 3) * 22,refreshrate == 0,"30FPS","Run the program at 30FPS.")) {
	    //    game_set_speed(30,gamespeed_fps)
		//	refreshrate=0
	    //}
	    //if (draw_radiobox(x1+274,y1+164+16+20 + (theme = 3) * 22,refreshrate == 1,"60FPS","Run the program at 60FPS.")) {
	    //    game_set_speed(60,gamespeed_fps)
		//	refreshrate=1
	    //}
		//if (draw_radiobox(x1+274+64-6,y1+164+16 + (theme = 3) * 22,refreshrate == 2,"120FPS","Run the program at 120FPS.")) {
		//	game_set_speed(120,gamespeed_fps)
		//	refreshrate=2
		//}
		//if (draw_radiobox(x1+274+64-6,y1+164+16+20 + (theme = 3) * 22,refreshrate == 3,"144FPS","Run the program at 144FPS.")) {
		//	game_set_speed(144,gamespeed_fps)
		//	refreshrate=3
		//}
		//if (draw_radiobox(x1+274+128-6,y1+164+16+10 + (theme = 3) * 22,refreshrate == 4,"Unlimited","Run the program with unlimited FPS.\nMay cause very high CPU usage. Use this option with caution!")) {
		//	game_set_speed(114514,gamespeed_fps)
		//	refreshrate=4
		//}

		if (theme = 3) draw_theme_font(font_info_med)
		if (language != 1) draw_areaheader(x1 + 258, y1 + 150 + (theme = 3) * 22, 220, 64, "Window")
		else draw_areaheader(x1 + 258, y1 + 150 + (theme = 3) * 22, 220, 64, "窗口")
		if (theme = 3) draw_theme_font(font_main)
		if (language != 1) draw_text_dynamic(x1 + 276, y1 + 166 + (theme = 3) * 22, "Scale:             %")
		else draw_text_dynamic(x1 + 276, y1 + 166 + (theme = 3) * 22, "缩放:              %")
		window_scale = median(50, draw_dragvalue(19, x1 + 322, y1 + 166 + (theme = 3) * 22, window_scale * 100, (1/power(window_scale, 2)) ), 400) / 100
		if (language != 1) {
		if (draw_button2(x1 + 394, y1 + 161 + (theme = 3) * 22, 72, "Reset", (window_scale == get_default_window_scale()))) {
			window_scale = get_default_window_scale()
		}
		if (draw_checkbox(x1 + 276, y1 + 195 + (theme = 3) * 22, hires, "Optimize for high resolutions", "Whether to use higher resolution textures on the interface.\n" + condstr(theme = 3, "(May reduce performance and reduce readability at lower resolutions.)", "(Only applies to the Fluent theme.)"), (theme != 3), true)) hires = !hires
		} else {
		if (draw_button2(x1 + 394, y1 + 161 + (theme = 3) * 22, 72, "重置", (window_scale == get_default_window_scale()))) {
			window_scale = get_default_window_scale()
		}
		if (draw_checkbox(x1 + 276, y1 + 195 + (theme = 3) * 22, hires, "为高分辨率优化", "是否在界面上使用更高分辨率的纹理。\n" + condstr(theme = 3, "（可能减弱性能并在低分辨率下减小可读性）", "（仅限 Fluent 主题）"), theme != 3, true)) hires = !hires
		}
		if (theme != 3 || (theme != 2 && !fdark)) draw_set_color(c_black)
		else draw_set_color(c_white)
		if (theme = 3) draw_theme_font(font_info_med)
		if (language != 1) draw_areaheader(x1 + 22, y1 + 239 + (theme = 3) * 22, 220, 65, "Language")
		else draw_areaheader(x1 + 22, y1 + 239 + (theme = 3) * 22, 220, 65, "语言")
		if (theme = 3) draw_theme_font(font_main)
		draw_area(x1 + 40, y1 + (theme = 3) * 22 + 239 + 16 + 5, x1 + 140, y1 + (theme = 3) * 22 + 239 + 16 + 20 + 5)
		if (draw_abutton(x1 + 140 - 17, y1 + 239 + 17 + (theme = 3) * 22 + 5) && wmenu = 0) {
	        menu = show_menu_ext("language", x1 + 40, y1 + 239 + 16 + 21 + (theme = 3) * 22 + 5, check(language = 0) + "English|" + check(language = 1) + "简体中文")
	    }
	    draw_text_dynamic(x1 + 43, y1 + 239 + 19 + (theme = 3) * 22 + 5, condstr(language = 0, "English") + condstr(language = 1, "简体中文"))
		if (theme = 3) draw_theme_font(font_info_med)
		if (language != 1) draw_areaheader(x1 + 258, y1 + 239 + (theme = 3) * 22, 220, 65, "Icon")
		else draw_areaheader(x1 + 258, y1 + 239 + (theme = 3) * 22, 220, 65, "图标")
		if (theme = 3) draw_theme_font(font_main)
		if (draw_checkbox(x1 + 276, y1 + (theme = 3) * 22 + 239 + 16 + 5 + 4, window_icon, condstr(language != 1, "Fruity icon", "macOS样式图标"), condstr(language != 1, "Whether to use the a fruity themed icon instead of the regular icon.", "使用macOS风格图标替换普通图标。"), false, true)) window_icon = !window_icon
	} else if (selected_tab = 2) {
		if (language != 1) {
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 456, 196, "Note blocks")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 90, use_colors, "Use colored note blocks", "If the instruments should be identified with\ndifferent colors.")) use_colors=!use_colors
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 110, use_icons, "Show instrument icons", "If the instruments should be identified with\ntheir respective icons.")) use_icons=!use_icons
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 130, use_shapes, "Use different shapes for each instrument", "If the instruments should be identified\nwith different shapes.")) use_shapes=!use_shapes
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 150, show_numbers, "Show key numbers", "Whether to show the amount of right-clicks required\nfor each note block.")) show_numbers=!show_numbers
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 170, show_octaves, "Show octave numbers", "Whether the number of the octave the note block\nis in should be shown.")) show_octaves=!show_octaves
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 190, show_incompatible, "Highlight incompatible note blocks", "Whether to show a red outline on note blocks with\ncustom instruments or outside the 2 octave range.")) show_incompatible=!show_incompatible
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 210, fade, "No fading", "Disables transparency animations on note block sprites")) fade = !fade
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 230, show_layers, "Show layer boxes", "Whether the layer boxes should be shown\non the left side of the workspace.")) show_layers = !show_layers
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 250, remove_effect, "Show effect on removal", "Whether to show a fading border\nwhen removing a note block.")) remove_effect = !remove_effect
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 294 + (theme = 3) * 22, 456, 171, "Piano")
		if (theme = 3) draw_theme_font(font_main)
		if (draw_checkbox(x1 + 40, y1 + 310 + (theme = 3) * 22, show_piano, "Show piano", "Whether the piano should be visible.", false, true)) show_piano = !show_piano
		if (draw_checkbox(x1 + 40, y1 + 350 + (theme = 3) * 22, show_keynames, "Show key names", "If the names of the keys should be shown.")) show_keynames=!show_keynames
	    if (draw_checkbox(x1 + 40, y1 + 370 + (theme = 3) * 22, show_keynumbers, "Show key numbers", "Whether to show the amount of right-clicks required\non each key inside the 2 octave range.")) show_keynumbers=!show_keynumbers
	    if (draw_checkbox(x1 + 40, y1 + 390 + (theme = 3) * 22, show_keyboard, "Show keyboard shortcuts", "Show the keyboard shortcuts of the keys.")) show_keyboard=!show_keyboard
	    if (draw_checkbox(x1 + 40, y1 + 410 + (theme = 3) * 22, show_notechart, "Show note chart when hovering over keys", "Whether to show a note chart\nwhen hovering over the keys.")) show_notechart=!show_notechart
	    if (draw_checkbox(x1 + 40, y1 + 430 + (theme = 3) * 22, show_outofrange, "Highlight out-of-range keys", "Whether to show a red tint on keys\noutside of the 2 octave range.")) show_outofrange=!show_outofrange
	    if (draw_checkbox(x1 + 40, y1 + 450 + (theme = 3) * 22, keynames_flat, "Use flat symbol", "Whether to use the flat symbol (b) instead of\nthe sharp symbol (#) on keynames.")) {keynames_flat=!keynames_flat; if (keynames_flat) {keynames = ["A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab"]} else {keynames = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]}}
	    if (!show_piano) draw_set_color(c_gray)
		draw_text_dynamic(x1 + 70, y1 + 328 + (theme = 3) * 22, "Keys to show:")
		if (show_piano) {
			keysmax = median(20, draw_dragvalue(4, x1 + 150, y1 + 328 + (theme = 3) * 22, keysmax, 2), 50)
		} else {
			draw_text_dynamic(x1 + 150, y1 + 328 + (theme = 3) * 22, keysmax)
		}
		draw_theme_color()
	    popup_set_window(x1 + 70, y1 + 328 + (theme = 3) * 22, 150, 21, "The amount of keys to show. A high number may\nslow down the program on old computers.")
		} else {
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 456, 196, "音符盒")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 90, use_colors, "彩色音符盒", "用音符盒颜色区分音色。")) use_colors=!use_colors
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 110, use_icons, "显示音色图标", "用音色图标区分音色。")) use_icons=!use_icons
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 130, use_shapes, "音符盒形状", "用音符盒形状区分音色。")) use_shapes=!use_shapes
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 150, show_numbers, "显示音符序号", "在音符盒上显示需要按右键次数。")) show_numbers=!show_numbers
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 170, show_octaves, "显示八度序号", "在音符盒上显示第几八度。")) show_octaves=!show_octaves
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 190, show_incompatible, "标记不兼容的音符盒", "在自定义音色或超出 2 八度范围的音符盒周围显示红框。")) show_incompatible=!show_incompatible
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 210, fade, "音符盒不透明", "关闭音符盒上的透明效果。")) fade = !fade
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 230, show_layers, "显示每层操作区", "显示在界面左侧操作每层设定的区域。")) show_layers = !show_layers
		if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 250, remove_effect, "显示删除效果", "删除音符时显示淡出边框效果。")) remove_effect = !remove_effect
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 294 + (theme = 3) * 22, 456, 171, "琴键")
		if (theme = 3) draw_theme_font(font_main)
		if (draw_checkbox(x1 + 40, y1 + 310 + (theme = 3) * 22, show_piano, "显示琴键", "钢琴键是否可见。", false, true)) show_piano = !show_piano
		if (draw_checkbox(x1 + 40, y1 + 350 + (theme = 3) * 22, show_keynames, "显示键名", "显示琴键所对应音的名称。")) show_keynames=!show_keynames
	    if (draw_checkbox(x1 + 40, y1 + 370 + (theme = 3) * 22, show_keynumbers, "显示音符序号", "在 2 八度内的琴键上显示需要按右键次数。")) show_keynumbers=!show_keynumbers
	    if (draw_checkbox(x1 + 40, y1 + 390 + (theme = 3) * 22, show_keyboard, "显示键盘键位", "在琴键上显示绑定的键盘键位。")) show_keyboard=!show_keyboard
	    if (draw_checkbox(x1 + 40, y1 + 410 + (theme = 3) * 22, show_notechart, "在琴键上时显示五线谱对应音符", "在鼠标停留在琴键上时是否显示五线谱。")) show_notechart=!show_notechart
	    if (draw_checkbox(x1 + 40, y1 + 430 + (theme = 3) * 22, show_outofrange, "标记超范围琴键", "是否为在 2 八度之外的琴键上标红。")) show_outofrange=!show_outofrange
	    if (draw_checkbox(x1 + 40, y1 + 450 + (theme = 3) * 22, keynames_flat, "使用降记号", "是否为键名使用降记号（b）而不是升记号（#）。")) {keynames_flat=!keynames_flat; if (keynames_flat) {keynames = ["A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab"]} else {keynames = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]}}
	    if (!show_piano) draw_set_color(c_gray)
		draw_text_dynamic(x1 + 70, y1 + 328 + (theme = 3) * 22, "最多显示键数:")
		if (show_piano) {
			keysmax = median(20, draw_dragvalue(4, x1 + 150, y1 + 328 + (theme = 3) * 22, keysmax, 2), 50)
		} else {
			draw_text_dynamic(x1 + 150, y1 + 328 + (theme = 3) * 22, keysmax)
		}
		draw_theme_color()
	    popup_set_window(x1 + 70, y1 + 328 + (theme = 3) * 22, 150, 21, "同屏显示的琴键数。过多可能会在老电脑上造成卡顿。")
		}
	} else if (selected_tab = 3) {
		if (language != 1) {
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 456, 120, "Mouse wheel")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_radiobox(x1 + 40, y1 + 90 + (theme = 3) * 22, mousewheel = 0, "Use mouse wheel to scroll through the song", "Use the mouse wheel to scroll through\nthe song horizontally or vertically.")) mousewheel = 0
	    if (draw_radiobox(x1 + 40, y1 + 110 + (theme = 3) * 22, mousewheel = 1, "Use mouse wheel to change instrument", "Use the mouse wheel to toggle between\nthe available instruments.")) mousewheel = 1
	    if (draw_radiobox(x1 + 40, y1 + 130 + (theme = 3) * 22, mousewheel = 2, "Use mouse wheel to change key", "Use the mouse wheel to toggle\nbetween the keys on the piano.")) mousewheel = 2
	    if (draw_checkbox(x1 + 40, y1 + 158 + (theme = 3) * 22, changepitch, "Change note properties when scrolling over notes", "Whether scrolling when hovering over a note should change its key,\nvelocity, panning or pitch, according to the currently selected edit mode.")) changepitch=!changepitch
		//draw_text_dynamic(x1 + 40, y1 + 178, "Tip: Hold Shift while scrolling over a note to change a whole octave,\nor fine-tune its velocity, panning or pitch.")
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 220 + (theme = 3) * 22, 456, 105, "Piano")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_checkbox(x1 + 40, y1 + 236 + (theme = 3) * 22, select_lastpressed, "Set selected key to pressed one", "If the selected key should be set\nto the one pressed using the keyboard.")) select_lastpressed=!select_lastpressed
	    draw_text_dynamic(x1 + 40, y1 + 270 + (theme = 3) * 22, "Right-click on keys to change their shortcuts.")
	    if (draw_button2(x1 + 40, y1 + 290 + (theme = 3) * 22, 160, "Reset key shortcuts")) {
	        if (question("Are you sure?", "Confirm")) init_keys()
	    }
		} else {
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 456, 120, "鼠标滚轮")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_radiobox(x1 + 40, y1 + 90 + (theme = 3) * 22, mousewheel = 0, "使用鼠标滚轮移动位置", "使用鼠标滚轮横向或竖向移动编辑区域位置。")) mousewheel = 0
	    if (draw_radiobox(x1 + 40, y1 + 110 + (theme = 3) * 22, mousewheel = 1, "使用鼠标滚轮改变音色", "使用鼠标滚轮切换可用音色。")) mousewheel = 1
	    if (draw_radiobox(x1 + 40, y1 + 130 + (theme = 3) * 22, mousewheel = 2, "使用鼠标滚轮改变音调", "使用鼠标滚轮改变目前使用的音调。")) mousewheel = 2
	    if (draw_checkbox(x1 + 40, y1 + 158 + (theme = 3) * 22, changepitch, "当在音符上使用鼠标滚轮改变音符属性", "在音符上使用鼠标滚轮时是否根据目前模式改变其音调、音量、声道或音高。")) changepitch=!changepitch
		//draw_text_dynamic(x1 + 40, y1 + 178, "Tip: Hold Shift while scrolling over a note to change a whole octave,\nor fine-tune its velocity, panning or pitch.")
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 220 + (theme = 3) * 22, 456, 105, "琴键")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_checkbox(x1 + 40, y1 + 236 + (theme = 3) * 22, select_lastpressed, "选择按下的键", "是否选择按下的键所对应的音。")) select_lastpressed=!select_lastpressed
	    draw_text_dynamic(x1 + 40, y1 + 270 + (theme = 3) * 22, "对琴键右键可更改键位。")
	    if (draw_button2(x1 + 40, y1 + 290 + (theme = 3) * 22, 160, "重置键位")) {
	        if (question("你确定吗？", "确认")) init_keys()
	    }
		}
	} else if (selected_tab = 4) {
		if (language != 1) {
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 456, 145, "Marker")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 90, marker_follow, "Follow marker when playing", "Automatically scroll along with the\nmarker when playing the song.")) marker_follow=!marker_follow
	    if (draw_radiobox(x1 + 70, y1 + (theme = 3) * 22 + 110, marker_pagebypage = 1, "Page by page", "Scroll with the marker every page.", !marker_follow)) marker_pagebypage = 1
	    if (draw_radiobox(x1 + 70, y1 + (theme = 3) * 22 + 130, marker_pagebypage = 0, "Tick by tick", "Scroll with the marker every tick.", !marker_follow)) marker_pagebypage = 0
	    if (draw_radiobox(x1 + 70, y1 + (theme = 3) * 22 + 150, marker_pagebypage = 2, "Frame by frame", "Scroll with the marker every frame.", !marker_follow)) marker_pagebypage = 2
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 170, marker_start, "Start playing in section", "Whether to always start playing\nat the start of the active section.")) marker_start=!marker_start
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 190, marker_end, "Stop playing after section", "Whether to stop playing when the\nmarker passes the active section.")) marker_end=!marker_end
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 244 + (theme = 3) * 22, 218, 120, "Playing")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_checkbox(x1 + 32, y1 + 244 + 16 + (theme = 3) * 22, realvolume, "Show layer volumes", "Whether to show the volume of layers.")) realvolume=!realvolume
		if (draw_checkbox(x1 + 32, y1 + 264 + 16 + (theme = 3) * 22, realstereo, "Disable stereo", "Disables stereo playback.")) realstereo = !realstereo
		//if (draw_checkbox(x1 + 32, y1 + 284 + 16 + (theme = 3) * 22, looptobarend, "Loop to bar end", "Loops to the end of the bar/measure.")) looptobarend = !looptobarend
		if (draw_checkbox(x1 + 32, y1 + 284 + 16 + (theme = 3) * 22, show_soundcount, "Show number of active sounds", "Displays the number of sounds that are\ncurrently playing in the status bar.")) show_soundcount = !show_soundcount
		if (draw_checkbox(x1 + 32, y1 + 304 + 16 + (theme = 3) * 22, channelstoggle, "Use more audio channels", "Whether to increase the number\nof sounds that can play at once.")) channelstoggle = !channelstoggle
		if (draw_checkbox(x1 + 32, y1 + 324 + 16 + (theme = 3) * 22, taskbar, "Enable taskbar indicator", "Whether to display the song\nprogress on the taskbar.")) taskbar = !taskbar
		if (theme = 3) draw_theme_font(font_info_med)
		draw_areaheader(x1 + 233 + 22, y1 + 244 + (theme = 3) * 22, 223, 60, "Tempo unit")
		if (theme = 3) draw_theme_font(font_main)
		if (draw_radiobox(x1 + 233 + 32, y1 + 244 + 16 + (theme = 3) * 22, !use_bpm, "Ticks per second (t/s)", "Display song tempos in ticks per second.")) use_bpm = 0
		if (draw_radiobox(x1 + 233 + 32, y1 + 264 + 16 + (theme = 3) * 22, use_bpm, "Beats per minute (BPM)", "Display song tempos in beats per minute.")) use_bpm = 1
		if (theme = 3) draw_theme_font(font_info_med)
		draw_areaheader(x1 + 233 + 22, y1 + 329 + (theme = 3) * 22, 223, 55 + 23 + 20, "Resource pack")
		if (theme = 3) draw_theme_font(font_main)
		draw_area(x1 + 233 + 22 + 18, y1 + 329 + (theme = 3) * 22 + 16 + 5, x1 + 233 + 22 + 18 + 100, y1 + 329 + (theme = 3) * 22 + 16 + 5 + 20)
		var rp_str = ""
		var display_resource = current_resource
		if (string_width_dynamic(display_resource) > 82) {
			while (display_resource != "" && string_width_dynamic(display_resource) > 82 - string_width("...")) {
				display_resource = string_delete(display_resource, string_length(display_resource), 1)
			}
			display_resource += "..."
		}
		for (var l = 0; l < array_length(resourcepacks); l++) {
			rp_str += check(current_resource = resourcepacks[l].filename)
			rp_str += resourcepacks[l].filename
			if (l != array_length(resourcepacks) - 1) rp_str += "|"
		}
		if (draw_abutton(x1 + 233 + 22 + 18 + 100 - 17, y1 + 329 + (theme = 3) * 22 + 17 + 5) && wmenu = 0) {
			menu = show_menu_ext("resourcepack", x1 + 233 + 22 + 18, y1 + 329 + (theme = 3) * 22 + 16 + 5 + 21, rp_str)
		}
		draw_text_dynamic(x1 + 233 + 22 + 18 + 3, y1 + 329 + (theme = 3) * 22 + 19 + 5, display_resource)
		if (wmenu = 1 && !mouse_check_button(mb_left)) wmenu = 0
		if (draw_button2(x1 + 233 + 22 + 18, y1 + 359 + (theme = 3) * 22 + 19 + 5, 150, "Refresh Resource Packs", 0, 1)) refresh_resourcepacks()
		} else {
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 74 + (theme = 3) * 22, 456, 145, "进度条")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 90, marker_follow, "播放时跟随进度条", "播放歌曲时和进度条一起滚动。")) marker_follow=!marker_follow
	    if (draw_radiobox(x1 + 70, y1 + (theme = 3) * 22 + 110, marker_pagebypage = 1, "按页", "跟随进度条翻页。", !marker_follow)) marker_pagebypage = 1
	    if (draw_radiobox(x1 + 70, y1 + (theme = 3) * 22 + 130, marker_pagebypage = 0, "按刻", "跟随进度条滚动。", !marker_follow)) marker_pagebypage = 0
	    if (draw_radiobox(x1 + 70, y1 + (theme = 3) * 22 + 150, marker_pagebypage = 2, "按帧", "跟随进度条逐帧滚动。", !marker_follow)) marker_pagebypage = 2
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 170, marker_start, "在区间时开始播放", "有区间存在时是否在区间起始处开始播放。")) marker_start=!marker_start
	    if (draw_checkbox(x1 + 40, y1 + (theme = 3) * 22 + 190, marker_end, "在区间后停止播放", "有区间存在时是否在区间结束处停止播放。")) marker_end=!marker_end
		if (theme = 3) draw_theme_font(font_info_med)
	    draw_areaheader(x1 + 22, y1 + 244 + (theme = 3) * 22, 218, 120, "播放")
		if (theme = 3) draw_theme_font(font_main)
	    if (draw_checkbox(x1 + 32, y1 + 244 + 16 + (theme = 3) * 22, realvolume, "显示每层音量", "是否显示每层的音量。")) realvolume=!realvolume
		if (draw_checkbox(x1 + 32, y1 + 264 + 16 + (theme = 3) * 22, realstereo, "关闭立体声", "关闭立体声音效。")) realstereo = !realstereo
		//if (draw_checkbox(x1 + 32, y1 + 284 + 16 + (theme = 3) * 22, looptobarend, "循环至小节尾", "到小节尾再循环。")) looptobarend = !looptobarend
		if (draw_checkbox(x1 + 32, y1 + 284 + 16 + (theme = 3) * 22, show_soundcount, "显示正在播放的声音数", "在状态栏里显示正在播放的声音数。")) show_soundcount = !show_soundcount
		if (draw_checkbox(x1 + 32, y1 + 304 + 16 + (theme = 3) * 22, channelstoggle, "提升声音限制", "提升可同时播放的声音数。")) channelstoggle = !channelstoggle
		if (draw_checkbox(x1 + 32, y1 + 324 + 16 + (theme = 3) * 22, taskbar, "启用任务栏进度", "是否在任务栏显示当前歌曲的进度。")) taskbar = !taskbar
		if (theme = 3) draw_theme_font(font_info_med)
		draw_areaheader(x1 + 233 + 22, y1 + 244 + (theme = 3) * 22, 223, 60, "速度单位")
		if (theme = 3) draw_theme_font(font_main)
		if (draw_radiobox(x1 + 233 + 32, y1 + 244 + 16 + (theme = 3) * 22, !use_bpm, "红石刻 / 秒 (t/s)", "使用每秒几刻显示速度。")) use_bpm = 0
		if (draw_radiobox(x1 + 233 + 32, y1 + 264 + 16 + (theme = 3) * 22, use_bpm, "拍数 / 分钟 (BPM)", "使用每分钟多少拍显示速度。")) use_bpm = 1
		if (theme = 3) draw_theme_font(font_info_med)
		draw_areaheader(x1 + 233 + 22, y1 + 329 + (theme = 3) * 22, 223, 55 + 23 + 20, "资源包")
		if (theme = 3) draw_theme_font(font_main)
		draw_area(x1 + 233 + 22 + 18, y1 + 329 + (theme = 3) * 22 + 16 + 5, x1 + 233 + 22 + 18 + 100, y1 + 329 + (theme = 3) * 22 + 16 + 5 + 20)
		var rp_str = ""
		var display_resource = current_resource
		if (string_width_dynamic(display_resource) > 82) {
			while (display_resource != "" && string_width_dynamic(display_resource) > 82 - string_width("...")) {
				display_resource = string_delete(display_resource, string_length(display_resource), 1)
			}
			display_resource += "..."
		}
		for (var l = 0; l < array_length(resourcepacks); l++) {
			rp_str += check(current_resource = resourcepacks[l].filename)
			rp_str += resourcepacks[l].filename
			if (l != array_length(resourcepacks) - 1) rp_str += "|"
		}
		if (draw_abutton(x1 + 233 + 22 + 18 + 100 - 17, y1 + 329 + (theme = 3) * 22 + 17 + 5) && wmenu = 0) {
			menu = show_menu_ext("resourcepack", x1 + 233 + 22 + 18, y1 + 329 + (theme = 3) * 22 + 16 + 5 + 21, rp_str)
		}
		draw_text_dynamic(x1 + 233 + 22 + 18 + 3, y1 + 329 + (theme = 3) * 22 + 19 + 5, display_resource)
		if (wmenu = 1 && !mouse_check_button(mb_left)) wmenu = 0
		if (draw_button2(x1 + 233 + 22 + 18, y1 + 359 + (theme = 3) * 22 + 19 + 5, 150, "刷新资源包列表", 0, 1)) refresh_resourcepacks()
		}
	}
	
	if (draw_button2(x1 + 420, y1 + 478 - isplayer * 100, 72, condstr(language != 1, "OK", "确定")) || keyboard_check_released(vk_escape) || (prevwindow == window && check_ctrl() && keyboard_check_pressed(ord("P")) || (keyboard_check_pressed(188) && os_type = os_macosx))) {
		if (theme != 3) {
			window = 0
			window_set_cursor(curs)
			save_settings()
		} else {
			if (windowopen = 1) windowclose = 1
		}
	}
}
