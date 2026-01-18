function draw_window_minecraft() {
	// draw_window_minecraft()
	var x1, y1, a, b, c, stabx, stabw, str, nsel;
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	x1 = floor(rw / 2 - 245)
	y1 = floor(rh / 2 - 225) + windowoffset
	draw_window(x1, y1, x1 + 490, y1 + 450)
	if (theme = 3){
	draw_set_color(13421772)
	if (fdark) draw_set_color(3355443)
	draw_roundrect(x1+1,y1+1,x1+488,y1+98,0)
	draw_set_color(c_black)
	draw_theme_color()
	}
	if (language != 1) {
	draw_theme_font(font_main_bold)
	draw_text_dynamic(x1 + 8, y1 + 8, "Minecraft Compatibility")
	draw_theme_font(font_main)
	draw_text_dynamic(x1 + 16, y1 + 32, "Due to the limitations of note blocks, the song must meet certain criteria in order\nto be properly imported into Minecraft.")
	} else {
	draw_theme_font(font_main_bold)
	draw_text_dynamic(x1 + 8, y1 + 8, "Minecraft 兼容性")
	draw_theme_font(font_main)
	draw_text_dynamic(x1 + 16, y1 + 32, "由于音符盒的种种限制，歌曲需要满足特定条件才能导入进 Minecraft。")
	}

	yy = y1 + 50

	b = 8
	if (language != 1) {
	str[0] = "Schematic"
	str[1] = "Data Pack"
	} else {
	str[0] = "Schematic"
	str[1] = "数据包"
	}
	nsel = -1

	// Draw tabs
	for (a = 0; a < 2; a += 1) {
	    c = mouse_rectangle(x1 + b, yy + 28, string_width_dynamic(str[a]) + 12, 18)
	    if (selected_tab_mc = a) {
	        stabx = b - 2
	        stabw = string_width_dynamic(str[a]) + 15
	    } else {
	        draw_sprite(spr_tabbuttons, 0 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b, yy + 28)
	        draw_sprite_ext(spr_tabbuttons, 1 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b + 2, yy + 28, string_width_dynamic(str[a]) / 2 + 4, 1, 0, -1, draw_get_alpha())
	        draw_sprite(spr_tabbuttons, 2 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b + string_width_dynamic(str[a]) + 10, yy + 28)
	        draw_text_dynamic(x1 + b + 6, yy + 30, str[a])
	    }
	    if (mouse_check_button_pressed(mb_left) && c) nsel = a
	    b += string_width_dynamic(str[a]) + 12
	}
	if (theme = 0 || theme = 3) {
	    draw_set_color(c_white)
	    if (theme != 3) draw_rectangle(x1 + 6, yy + 46, x1 + 484, yy + 350, 0) 
	    draw_set_color(make_color_rgb(137, 140, 149))
	    if (theme != 3) draw_rectangle(x1 + 6, yy + 46, x1 + 484, yy + 350, 1)
	    draw_set_color(c_white)
		if (theme = 3) draw_set_color(15987699)
		if (theme = 3 && fdark) draw_set_color(2105376)
		if (theme != 3) {
		draw_rectangle(x1 + stabx, yy + 26, x1 + stabx + stabw, yy + 26 + 20, 0)
		} else {
	    draw_roundrect(x1 + stabx, yy + 26, x1 + stabx + stabw, yy + 26 + 25, 0)
		}
	    draw_set_color(make_color_rgb(137, 140, 149))
	    if (theme != 3) draw_rectangle(x1 + stabx, yy + 26, x1 + stabx + stabw, yy + 26 + 20, 1)
	    draw_set_color(c_white)
		if (theme = 3) draw_set_color(15987699)
		if (theme = 3 && fdark) draw_set_color(2105376)
	    draw_rectangle(x1 + stabx + 1, yy + 46, x1 + stabx + stabw - 1, yy + 47, 0)
	    draw_theme_color()
	    draw_text_dynamic(x1 + stabx + 8, yy + 28, str[selected_tab_mc])
	} else if(theme = 1){
	    draw_sprite(spr_tabbuttons, 12, x1 + stabx - 1, yy + 26)
	    draw_sprite_ext(spr_tabbuttons, 13, x1 + stabx + 1, yy + 26, stabw / 2 - 1, 1, 0, -1, 1)
	    draw_sprite(spr_tabbuttons, 14, x1 + stabx + stabw - 1, yy + 26)
	    draw_text_dynamic(x1 + stabx + 8, yy + 28, str[selected_tab_mc])
		draw_window(x1 + 6, yy + 46, x1 + 484, yy + 350)
	} else {
		draw_set_color(c_dark)
	    draw_rectangle(x1 + 6, yy + 46, x1 + 484, yy + 350, 0) 
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, yy + 46, x1 + 484, yy + 350, 1)
	    draw_set_color(c_dark)
	    draw_rectangle(x1 + stabx, yy + 26, x1 + stabx + stabw, yy + 26 + 20, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + stabx, yy + 26, x1 + stabx + stabw, yy + 26 + 20, 1)
	    draw_set_color(c_dark)
	    draw_rectangle(x1 + stabx + 1, yy + 46, x1 + stabx + stabw - 1, yy + 47, 0)
	    draw_theme_color()
	    draw_text_dynamic(x1 + stabx + 8, yy + 28, str[selected_tab_mc])
	}
	if (nsel > -1) selected_tab_mc = nsel
	selected_tab_mc += keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
	if (selected_tab_mc < 0) selected_tab_mc = 1
	if (selected_tab_mc > 1) selected_tab_mc = 0

	// Draw content
	yy += 65
	if (selected_tab_mc = 0) { // Schematic

		if(songs[song].real_tempo = 10 || songs[song].real_tempo = 5 || songs[song].real_tempo = 2.5){
			// compatible
			if (theme != 3) {
				draw_sprite(spr_yesno, 1, x1 + 25, yy + 8)
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 1 + 3 * fdark, x1 + 25, yy + 8)
					draw_sprite_ext(spr_yesno_f, 1 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 1 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
					draw_sprite_ext(spr_yesno_f_hires, 1 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				}
			}
		} else {
			// not compatible
			if (theme != 3) {
				draw_sprite(spr_yesno, 0, x1 + 25, yy + 8)
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 0 + 3 * fdark, x1 + 25, yy + 8)
					draw_sprite_ext(spr_yesno_f, 0 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 0 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
					draw_sprite_ext(spr_yesno_f_hires, 0 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				}
			}
		}

		draw_theme_font(font_main_bold)
		if (language != 1) draw_text_dynamic(x1 + 45, yy, "The tempo must be either 2.5, 5 or 10 ticks per second.")
		else draw_text_dynamic(x1 + 45, yy, "速度必须为每秒 2.5、5 或 10 红石刻。")
		draw_theme_font(font_main)

		if (songs[song].real_tempo = 10 || songs[song].real_tempo = 5 || songs[song].real_tempo = 2.5) {    
			draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
		    if (language != 1) draw_text_dynamic(x1 + 45, yy + 16, "The tempo is " + string(songs[song].real_tempo) + " ticks per second.")
		    else draw_text_dynamic(x1 + 45, yy + 16, "目前速度为每秒 " + string(songs[song].real_tempo) + " 红石刻。")
		} else {
			draw_set_color(c_red)
		    if (language != 1) draw_text_dynamic(x1 + 45, yy + 16, "The tempo is " + string(songs[song].real_tempo) + " ticks per second.")
		    else draw_text_dynamic(x1 + 45, yy + 16, "目前速度为每秒 " + string(songs[song].real_tempo) + " 红石刻。")
		    if (draw_button2(x1 + 45, yy + 34, 140, condstr(language != 1, "Fix tempo for schematic", "针对 Schematic 调整速度"), 0, 1)) {
		        var otempo = songs[song].real_tempo
		        if (otempo > 10) songs[song].real_tempo = 10 songs[song].changed = 1
		        if (otempo < 10) songs[song].real_tempo = 10 songs[song].changed = 1
		        if (otempo < 7.5) songs[song].real_tempo = 5 songs[song].changed = 1
		        if (otempo < 3.75) songs[song].real_tempo = 2.5 songs[song].changed = 1
		    }
		}
		draw_theme_color()

		yy += 90
		if (theme != 3) {
			draw_sprite(spr_yesno, songs[song].block_outside = 0, x1 + 25, yy + 8)
		} else {
			if (!hires) {
				draw_sprite(spr_yesno_f, (songs[song].block_outside = 0) + 3 * fdark, x1 + 25, yy + 8)
				draw_sprite_ext(spr_yesno_f, (songs[song].block_outside = 0) + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
			} else {
				draw_sprite_ext(spr_yesno_f_hires, (songs[song].block_outside = 0) + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
				draw_sprite_ext(spr_yesno_f_hires, (songs[song].block_outside = 0) + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
			}
		}
		draw_theme_font(font_main_bold)
		if (language != 1) draw_text_dynamic(x1 + 45, yy, "All blocks must be within Minecraft's 2 octave range.")
		else draw_text_dynamic(x1 + 45, yy, "所有方块必须在 Minecraft 的 2 八度范围内。")
		draw_theme_font(font_main)
		if (language != 1) {
		if (songs[song].block_outside > 0) {    
		    draw_set_color(c_red)
		    if (songs[song].block_outside = 1) {
		        draw_text_dynamic(x1 + 45, yy + 16, "There is 1 block outside the 2 octave range.")
		    } else {
		        draw_text_dynamic(x1 + 45, yy + 16, "There are " + string(songs[song].block_outside) + " blocks outside the 2 octave range.")
		    }
		    if (draw_button2(x1 + 45, yy + 34, 120, "Select lower blocks", 0, 1)) {
		        select_outside(true, false)
		        windowclose = 1
		    }
			if (draw_button2(x1 + 175, yy + 34, 120, "Select higher blocks", 0, 1)) {
		        select_outside(false, true)
		        windowclose = 1
		    }
		    if (draw_button2(x1 + 305, yy + 34, 100, "Transpose notes", 0, 1)) {
		        if (question("Transpose notes so that they fall within Minecraft's 2 octaves?", "Transpose notes")) {
		            select_all(-1, 0)
		            selection_transpose()
		            selection_place(0)
		        }
		    }
		} else {
		    draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
		    draw_text_dynamic(x1 + 45, yy + 16, "There are no blocks outside the 2 octave range.")
		}
		draw_theme_color()
		} else {
		if (songs[song].block_outside > 0) {    
		    draw_set_color(c_red)
		    draw_text_dynamic(x1 + 45, yy + 16, "有 " + string(songs[song].block_outside) + " 个方块在 2 八度范围外。")
		    if (draw_button2(x1 + 45, yy + 34, 120, "选择过低的音符", 0, 1)) {
		        select_outside(true, false)
		        windowclose = 1
		    }
			if (draw_button2(x1 + 175, yy + 34, 120, "选择过高的音符", 0, 1)) {
		        select_outside(false, true)
		        windowclose = 1
		    }
		    if (draw_button2(x1 + 305, yy + 34, 100, "转换音符", 0, 1)) {
		        if (question("转换音符使其在 Minecraft 的 2 八度限制内吗？", "转换音符")) {
		            select_all(-1, 0)
		            selection_transpose()
		            selection_place(0)
		        }
		    }
		} else {
		    draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
		    draw_text_dynamic(x1 + 45, yy + 16, "没有方块超出2八度限制。")
		}
		}

		yy += 90
		if (theme != 3) {
			draw_sprite(spr_yesno, songs[song].block_custom = 0, x1 + 25, yy + 8)
		} else {
			if (!hires) {
				draw_sprite(spr_yesno_f, (songs[song].block_custom = 0) + 3 * fdark, x1 + 25, yy + 8)
				draw_sprite_ext(spr_yesno_f, (songs[song].block_custom = 0) + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
			} else {
				draw_sprite_ext(spr_yesno_f_hires, (songs[song].block_custom = 0) + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
				draw_sprite_ext(spr_yesno_f_hires, (songs[song].block_custom = 0) + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
			}
		}
		draw_theme_font(font_main_bold)
		draw_theme_color()
		if (language != 1) draw_text_dynamic(x1 + 45, yy, "No custom instruments may be used.")
		else draw_text_dynamic(x1 + 45, yy, "不可使用任何自定义音色。")
		draw_theme_font(font_main)
		if (language != 1) {
		if (songs[song].block_custom > 0) {    
		    draw_set_color(c_red)
		    if (songs[song].block_custom = 1) draw_text_dynamic(x1 + 45, yy + 16, "There is 1 block with custom instruments.")
		    else draw_text_dynamic(x1 + 45, yy + 16, "There are " + string(songs[song].block_custom) + " blocks with custom instruments.")
		    if (draw_button2(x1 + 45, yy + 34, 160, "Select affected blocks", 0, 1)) {
		        select_custom()
		        windowclose = 1
		    }
		} else {
		    draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
		    draw_text_dynamic(x1 + 45, yy + 16, "There are no blocks with custom instruments.")
		}
		} else {
		if (songs[song].block_custom > 0) {    
		    draw_set_color(c_red)
		    draw_text_dynamic(x1 + 45, yy + 16, "有 " + string(songs[song].block_custom) + " 个方块使用自定义音色。")
		    if (draw_button2(x1 + 45, yy + 34, 160, "选择所指音符", 0, 1)) {
		        select_custom()
		        windowclose = 1
		    }
		} else {
		    draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
		    draw_text_dynamic(x1 + 45, yy + 16, "没有方块使用自定义音色。")
		}
		}
		draw_theme_color()
	
	} else { // Datapack
		draw_theme_font(font_main_bold)
		if (language != 1) draw_text_dynamic(x1 + 45, yy, "Any tempo works when exporting as a data pack.")
		else draw_text_dynamic(x1 + 45, yy, "导出数据包时可使用任意速度。")
		draw_theme_font(font_main)
		if (language != 1) draw_text_dynamic(x1 + 45, yy + 16, "However, the tempos 0.25, 0.5, 1, 1.25, 2, 2.5, 4, 5, 10 and 20 t/s work better.")
		else draw_text_dynamic(x1 + 45, yy + 16, "但是，使用每秒 0.25、0.5、1、1.25、2、2.5、4、5、10 或 20 红石刻的速度更佳。")

		if (songs[song].real_tempo = 20 || songs[song].real_tempo = 10 || songs[song].real_tempo = 5 || songs[song].real_tempo = 4 || songs[song].real_tempo = 2.5 || songs[song].real_tempo = 2 || songs[song].real_tempo = 1.25 || songs[song].real_tempo = 1 || songs[song].real_tempo = 0.5 || songs[song].real_tempo = 0.25) {    
			if (theme != 3) {
				draw_sprite(spr_yesno, 1, x1 + 25, yy + 8)	
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 1 + 3 * fdark, x1 + 25, yy + 8)	
					draw_sprite_ext(spr_yesno_f, 1 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())	
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 1 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())	
					draw_sprite_ext(spr_yesno_f_hires, 1 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())	
				}
			}
			draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
			if (language != 1) draw_text_dynamic(x1 + 45, yy + 32, "The tempo is " + string(songs[song].real_tempo) + " ticks per second.")
			else draw_text_dynamic(x1 + 45, yy + 32, "目前速度为每秒 " + string(songs[song].real_tempo) + " 红石刻。")
		} else {
			if (theme != 3) {
				draw_sprite(spr_yesno, 2, x1 + 25, yy + 8)	
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 2 + 3 * fdark, x1 + 25, yy + 8)	
					draw_sprite_ext(spr_yesno_f, 2 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())	
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 2 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())	
					draw_sprite_ext(spr_yesno_f_hires, 2 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())	
				}
			}
		    draw_set_color(c_orange)
			if (language != 1) draw_text_dynamic(x1 + 45, yy + 32, "The tempo is " + string(songs[song].real_tempo) + " ticks per second.")
			else draw_text_dynamic(x1 + 45, yy + 32, "目前速度为每秒 " + string(songs[song].real_tempo) + " 红石刻。")
			if (draw_button2(x1 + 45, yy + 50, 180, condstr(language != 1, "Optimize tempo for data pack", "针对数据包调整速度"), 0, 1)) {
			    var otempo
				otempo = songs[song].real_tempo
				if (otempo >= 15) songs[song].real_tempo = 20 songs[song].changed = 1
		        if (otempo < 15) songs[song].real_tempo = 10 songs[song].changed = 1
		        if (otempo < 7.5) songs[song].real_tempo = 5 songs[song].changed = 1
		        if (otempo < 4.5) songs[song].real_tempo = 4 songs[song].changed = 1
		        if (otempo < 3.25) songs[song].real_tempo = 2.5 songs[song].changed = 1
				if (otempo < 2.25) songs[song].real_tempo = 2 songs[song].changed = 1
				if (otempo < 1.625) songs[song].real_tempo = 1.25 songs[song].changed = 1
				if (otempo < 1.125) songs[song].real_tempo = 1 songs[song].changed = 1
				if (otempo < 0.75) songs[song].real_tempo = 0.5 songs[song].changed = 1
				if (otempo < 0.375) songs[song].real_tempo = 0.25 songs[song].changed = 1
		    }
		}
		draw_theme_color()

		yy += 90
		draw_theme_font(font_main_bold)
		if (language != 1) draw_text_dynamic(x1 + 45, yy, "Using a resource pack, you may extend the supported range to 6 octaves.")
		else draw_text_dynamic(x1 + 45, yy, "使用数据包，即可将支持范围扩展到 6 个八度。")
		draw_theme_font(font_main)
		if (language != 1) draw_text_dynamic(x1 + 45, yy + 16, "To play without one, all blocks must be within Minecraft's 2 octave range.")	
		else draw_text_dynamic(x1 + 45, yy + 16, "如果不想用，所有方块必须在 Minecraft 的 2 八度限制内。")	
		if (songs[song].block_outside > 0) {
		if (theme != 3) {
			draw_sprite(spr_yesno, 2, x1 + 25, yy + 8)
		} else {
			if (!hires) {
				draw_sprite(spr_yesno_f, 2 + 3 * fdark, x1 + 25, yy + 8)
				draw_sprite_ext(spr_yesno_f, 2 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
			} else {
				draw_sprite_ext(spr_yesno_f_hires, 2 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
				draw_sprite_ext(spr_yesno_f_hires, 2 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
			}
		}
		    draw_set_color(c_orange)
		    if (songs[song].block_outside = 1) {
		        if (language != 1) draw_text_dynamic(x1 + 45, yy + 32, "There is 1 block outside the 2 octave range.")
		        else draw_text_dynamic(x1 + 45, yy + 32, "有 1 个方块在 2 八度范围外。")
		    } else {
		        if (language != 1) draw_text_dynamic(x1 + 45, yy + 32, "There are " + string(songs[song].block_outside) + " blocks outside the 2 octave range.")
		        else draw_text_dynamic(x1 + 45, yy + 32, "有 " + string(songs[song].block_outside) + " 个方块在 2 八度范围外。")
		    }
		    if (draw_button2(x1 + 45, yy + 50, 80, condstr(language != 1, "Select lower", "选择过低音符"), 0, 1)) {
		        select_outside(true, false)
		        windowclose = 1
		    }
			if (draw_button2(x1 + 135, yy + 50, 80, condstr(language != 1, "Select higher", "选择过高音符"), 0, 1)) {
		        select_outside(false, true)
		        windowclose = 1
		    }
		    if (draw_button2(x1 + 225, yy + 50, 100, condstr(language != 1, "Transpose notes", "转换音符"), 0, 1)) {
				if (language != 1) {
		        if (question("Transpose notes so that they fall within Minecraft's 2 octaves?", "Transpose notes")) {
		            select_all(-1, 0)
		            selection_transpose()
		            selection_place(0)
		        }
				} else {
				if (question("转换音符使其在 Minecraft 的 2 八度限制内吗？", "转换音符")) {
		            select_all(-1, 0)
		            selection_transpose()
		            selection_place(0)
		        }
				}
			}
			if (draw_button2(x1 + 335, yy + 50, 120, condstr(language != 1, "Save resource pack", "保存资源包"), 0, 1)) {
				datapack_getextranotes()
			}
		} else {
			if (theme != 3) {
				draw_sprite(spr_yesno, 1, x1 + 25, yy + 8)
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 1 + 3 * fdark, x1 + 25, yy + 8)
					draw_sprite_ext(spr_yesno_f, 1 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 1 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
					draw_sprite_ext(spr_yesno_f_hires, 1 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				}
			}
		    draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
		    if (language != 1) draw_text_dynamic(x1 + 45, yy + 32, "There are no blocks outside the 2 octave range.")
			else draw_text_dynamic(x1 + 45, yy + 32, "没有方块超出 2 八度限制。")
		}
		draw_theme_color()

		yy += 90
		if (language != 1) {
		draw_theme_font(font_main_bold)
		draw_text_dynamic(x1 + 45, yy, "Using a resource pack, you may play custom instruments in Minecraft.")
		draw_theme_font(font_main)
		draw_text_dynamic(x1 + 45, yy + 16, "To play without one, no custom instruments must be used.")
		if (songs[song].block_custom > 0) {
			if (theme != 3) {
				draw_sprite(spr_yesno, 2, x1 + 25, yy + 8)
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 2 + 3 * fdark, x1 + 25, yy + 8)
					draw_sprite_ext(spr_yesno_f, 2 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 2 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
					draw_sprite_ext(spr_yesno_f_hires, 2 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				}
			}
		    draw_set_color(c_orange)
		    if (songs[song].block_custom = 1) draw_text_dynamic(x1 + 45, yy + 32, "There is 1 block with custom instruments.")
		    else draw_text_dynamic(x1 + 45, yy + 32, "There are " + string(songs[song].block_custom) + " blocks with custom instruments.")
			if (draw_button2(x1 + 45, yy + 50, 160, "Select affected blocks", 0, 1)) {
		        select_custom()
		        windowclose = 1
		    }
		} else {
			if (theme != 3) {
				draw_sprite(spr_yesno, 1, x1 + 25, yy + 8)
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 1 + 3 * fdark, x1 + 25, yy + 8)
					draw_sprite_ext(spr_yesno_f, 1 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 1 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
					draw_sprite_ext(spr_yesno_f_hires, 1 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				}
			}
		    draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
		    draw_text_dynamic(x1 + 45, yy + 32, "There are no blocks with custom instruments.")
		}
		} else {
		draw_theme_font(font_main_bold)
		draw_text_dynamic(x1 + 45, yy, "使用数据包，即可在 Minecraft 中使用自定义音色。")
		draw_theme_font(font_main)
		draw_text_dynamic(x1 + 45, yy + 16, "如果不想用，就不能用任何自定义音色。")
		if (songs[song].block_custom > 0) {
			if (theme != 3) {
				draw_sprite(spr_yesno, 2, x1 + 25, yy + 8)
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 2 + 3 * fdark, x1 + 25, yy + 8)
					draw_sprite_ext(spr_yesno_f, 2 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 2 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
					draw_sprite_ext(spr_yesno_f_hires, 2 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				}
			}
		    draw_set_color(c_orange)
		    draw_text_dynamic(x1 + 45, yy + 32, "有 " + string(songs[song].block_custom) + " 个方块使用自定义音色。")
			if (draw_button2(x1 + 45, yy + 50, 160, "选择所指音符", 0, 1)) {
		        select_custom()
		        windowclose = 1
		    }
		} else {
			if (theme != 3) {
				draw_sprite(spr_yesno, 1, x1 + 25, yy + 8)
			} else {
				if (!hires) {
					draw_sprite(spr_yesno_f, 1 + 3 * fdark, x1 + 25, yy + 8)
					draw_sprite_ext(spr_yesno_f, 1 + 6, x1 + 25, yy + 8, 1, 1, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				} else {
					draw_sprite_ext(spr_yesno_f_hires, 1 + 3 * fdark, x1 + 25, yy + 8, 0.25, 0.25, 0, -1, draw_get_alpha())
					draw_sprite_ext(spr_yesno_f_hires, 1 + 6, x1 + 25, yy + 8, 0.25, 0.25, 0, accent[6 - 2 * !fdark], draw_get_alpha())
				}
			}
		    draw_set_color(c_green)
			if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
		    draw_text_dynamic(x1 + 45, yy + 32, "没有方块使用自定义音色。")
		}
		}
		draw_theme_color()
	}
	
	if (draw_button2(x1 + 240 - 36, y1 + 413, 72, condstr(language != 1, "OK", "确定")) && (windowopen = 1 || theme != 3)) windowclose = 1
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
}
