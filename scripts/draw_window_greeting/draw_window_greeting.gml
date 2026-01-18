function draw_window_greeting() {
	// draw_window_greeting()
	var x1, y1, a, b, c, d, e, m;
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	x1 = floor(rw / 2 - 350)
	y1 = floor(rh / 2 - 210) + windowoffset
	
	if (donate_banner) {
		x1 += 700;
		y1 += 210 - 100;
		var hover_badge = mouse_rectangle(x1, y1, 150, 120)
		var hover_x = mouse_rectangle(x1 + 120, y1 + 3, 16, 16)
		gpu_set_tex_filter(false)
		draw_sprite(spr_donate, hover_x ? 1 : 0, x1, y1);
		draw_sprite(spr_donate, (language == 1) ? 3 : 2, x1, y1);
		gpu_set_tex_filter(true)
		//popup_set_window(x1, y1, 150, 20, "Click to open our Open Collective\n page in your browser!");
		if (hover_badge) {
			curs = cr_handpoint;
			if (mouse_check_button_released(mb_left)) {
				if (hover_x) { // X button
					if (language != 1) message("Developing Note Block Studio takes a lot of unpaid volunteering time. If you can, please consider supporting us in the future! =)\n\n(You can find that option at any time in Help > Donate.)", "Note Block Studio");
					else message("开发Note Block Studio完全基于我们用爱发电。如果情况允许，请考虑在以后小小的支持我们一下！(～￣▽￣)～\n\n（您可以随时在帮助 > 捐赠中找到该选项。）", "Note Block Studio")
					donate_banner_time = date_inc_month(date_current_datetime(), 1);
					donate_banner = 0;
					save_settings();
				} else {
					open_url(link_donate);
				}
			}
		}
		x1 -= 700;
		y1 -= 210 - 100;
	}
	
	draw_window(x1, y1, x1 + 700, y1 + 430)
	draw_sprite_ext(spr_logo, window_icon, x1 + 64, y1 + 50, 1, 1, 0, c_white, draw_get_alpha())
	draw_theme_font(font_info_med_bold)
	draw_text_center(x1 + 132, y1 + 213, "Note Block Studio")
	draw_theme_font(font_main_bold)
	var dev_label_offset = (is_prerelease) ? 15 : 0
	if (NOT_RUN_FROM_IDE != 1) {
		if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "Running from the GameMaker IDE.")
		else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "在 IDE 中运行")
	} else if (is_development) {
		if (os_type = os_windows || os_type = os_linux) {
			if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "Update checking disabled.")
			else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "检查更新不可用")
		} else if (os_type = os_macosx) {
			if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "Updates managed by TestFlight app.")
			else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "由 TestFlight 应用管理更新")
		}
	} else if (check_update) {
		if (update_success) {
	        draw_set_color(c_lime)
			if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "Successfully updated!")
	        else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "更新成功！")
	    } else {
		    if (update = -1) {
		        draw_set_color(c_red)
				if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "Could not check for updates")
		        else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "检查更新失败")
		    }
		    else if (update = 0) {
		        //draw_set_color(c_gray)
				if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "Checking for updates...")
		        else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "正在检查更新……")
		    }
		    else if (update = 1) {
		        draw_set_color(33023)
				if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "There is an update available!")
		        else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "有新版本！")
		    }
		    else if (update = 2) {
		        draw_set_color(c_green)
				if (theme == 2) draw_set_color(c_lime)
				if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "You are using the latest version!")
		        else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "已为最新版本！")
		    }
		}
	} else {
	    draw_set_color(c_red)
		if (language != 1) draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "Update checking disabled by user.")
	    else draw_text_center(x1 + 132, y1 + 248 + dev_label_offset, "检查更新未开启")
	}
	draw_theme_font(font_main)
	draw_theme_color()
	if (NOT_RUN_FROM_IDE != 1) {
		if (language != 1) draw_text_center(x1 + 132, y1 + 233, "Version Local Release")
		else draw_text_center(x1 + 132, y1 + 233, "本地版本")
	} else {
		if (language != 1) draw_text_center(x1 + 132, y1 + 233, "Version " + version + " - Released " + version_date)
		else draw_text_center(x1 + 132, y1 + 233, "版本 " + version + " - 发布于 " + version_date)
	}
	if (is_prerelease) {
		if (language != 1) draw_text_center(x1 + 132, y1 + 248, "(Development version)")
		else draw_text_center(x1 + 132, y1 + 248, "（开发版本）")
	}
	if (language != 1) draw_text_center(x1 + 132, y1 + 280 + dev_label_offset, "An open-source Minecraft music maker")
	else draw_text_center(x1 + 132, y1 + 280 + dev_label_offset, "一个开源的 Minecraft 音乐制作软件")
	draw_set_color(make_color_rgb(62, 144, 255))
	draw_text_url(x1 + 132, y1 + 296 + dev_label_offset, "noteblock.studio", link_website)
	draw_theme_color()
	//if (language != 1) draw_text_center(x1 + 132, y1 + 340 + dev_label_offset, "Original created by David Andrei")
	//else draw_text_center(x1 + 132, y1 + 340 + dev_label_offset, "原作者 David Andrei")
	//draw_text_url(x1 + 132, y1 + 356 + dev_label_offset, "stuffbydavid.com", "https://www.stuffbydavid.com")
	var theme_pipe_offset = (theme != 3) * 2 // move |'s to the left by 2px to compensate for wider font
	if (language != 1) draw_text_center(x1 + 132, y1 + 340 + dev_label_offset, "Follow OpenNBS:")
	else draw_text_center(x1 + 132, y1 + 340 + dev_label_offset, "关注 OpenNBS：")
	draw_text_url(x1 + 80, y1 + 356 + dev_label_offset, "Discord", link_discord)
	draw_text_dynamic(x1 + 104 - theme_pipe_offset, y1 + 356 + dev_label_offset, "|")
	draw_text_url(x1 + 128, y1 + 356 + dev_label_offset, "Twitter", link_twitter)
	draw_text_dynamic(x1 + 150 - theme_pipe_offset, y1 + 356 + dev_label_offset, "|")
	draw_text_url(x1 + 180, y1 + 356 + dev_label_offset, "YouTube", link_youtube)

	draw_text_url(x1 + 108 - (language == 1) * 20, y1 + 372 + dev_label_offset, "GitHub", link_github)
	draw_text_dynamic(x1 + 131 - (language == 1) * 22 - theme_pipe_offset, y1 + 372 + dev_label_offset, "|")
	if (language == 1) draw_text_url(x1 + 133, y1 + 372 + dev_label_offset, "QQ 群", link_qq_group)
	if (language == 1) draw_text_dynamic(x1 + 131 + 22 - theme_pipe_offset, y1 + 372 + dev_label_offset, "|")
	if (language != 1) draw_text_url(x1 + 156, y1 + 372 + dev_label_offset, "Donate", link_donate)
	else draw_text_url(x1 + 156 + 15, y1 + 372 + dev_label_offset, "捐赠", link_donate)
	draw_set_color(c_white)
	
	if (fdark && theme = 3) draw_set_color(0)
	draw_line(x1 + 270, y1 + 24, x1 + 270, y1 + 396)
	draw_set_alpha(0.25)
	if (theme = 3) draw_set_alpha(0.25 * windowalpha)
	draw_theme_color()
	draw_line(x1 + 269, y1 + 24, x1 + 269, y1 + 396)
	draw_set_alpha(1)
	if (theme = 3) draw_set_alpha(windowalpha)
	draw_theme_color()
	if (language != 1) draw_text_dynamic(x1 + 290, y1 + 20, "What do you want to do?")
	else draw_text_dynamic(x1 + 290, y1 + 20, "要做什么？")

	b = x1 + 300
	c = y1 + 48
	if (!isplayer) {
	a = mouse_rectangle(b, c, 224, 32)
	a += (a && (mouse_check_button(mb_left) || mouse_check_button_released(mb_left)))
	if (!hires || theme != 3) draw_sprite(spr_frame2, a + 3 * theme + 3 * (fdark && theme = 3), b, c)
	else draw_sprite_ext(spr_frame2_hires, a + 3 * fdark, b, c, 0.25, 0.25, 0, -1, draw_get_alpha())
	if (theme != 3) {
		draw_sprite(spr_bigicons, 0, b + (a > 1), c + (a > 1))
	} else {
		if (!hires) {
			if (!fdark) draw_sprite(spr_bigicons_f, 0, b + (a > 1), c + (a > 1))
			else draw_sprite(spr_bigicons_d, 0, b + (a > 1), c + (a > 1))
		} else {
			if (!fdark) draw_sprite_ext(spr_bigicons_f_hires, 0, b + (a > 1), c + (a > 1), 0.25, 0.25, 0, -1, draw_get_alpha())
			else draw_sprite_ext(spr_bigicons_d_hires, 0, b + (a > 1), c + (a > 1), 0.25, 0.25, 0, -1, draw_get_alpha())
		}
	}
	if (language != 1) draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1), "Create a new song")
	else draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1), "创建歌曲")
	if (a = 2 && mouse_check_button_released(mb_left) && (windowopen = 1 || theme != 3)) {
		if (windowsound && theme = 3) play_sound(soundgoback, 45, 100, 100, 0)
		windowclose = 1
	}

	c += 44
	}
	b = x1 + 300
	a = mouse_rectangle(b, c, 224, 32)
	a += (a && (mouse_check_button(mb_left) || mouse_check_button_released(mb_left)))
	if (!hires || theme != 3) draw_sprite(spr_frame2, a + 3 * theme + 3 * (fdark && theme = 3), b, c)
	else draw_sprite_ext(spr_frame2_hires, a + 3 * fdark, b, c, 0.25, 0.25, 0, -1, draw_get_alpha())
	if (theme != 3) {
		draw_sprite(spr_bigicons, 1, b + (a > 1), c + (a > 1))
	} else {
		if (!hires) {
			if (!fdark) draw_sprite(spr_bigicons_f, 1, b + (a > 1), c + (a > 1))
			else draw_sprite(spr_bigicons_d, 1, b + (a > 1), c + (a > 1))
		} else {
			if (!fdark) draw_sprite_ext(spr_bigicons_f_hires, 1, b + (a > 1), c + (a > 1), 0.25, 0.25, 0, -1, draw_get_alpha())
			else draw_sprite_ext(spr_bigicons_d_hires, 1, b + (a > 1), c + (a > 1), 0.25, 0.25, 0, -1, draw_get_alpha())
		}
	}
	if (language != 1) draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1), "Load a song")
	else draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1), "打开歌曲")
	if (a = 2 && mouse_check_button_released(mb_left)) {
		if (windowsound && theme = 3) play_sound(soundinvoke, 45, 100, 50, 0)
		windowalpha = 0
		windowclose = 0
		windowopen = 0
	    load_song("", 0, 1)
	    return 1
	}
	b = x1 + 320
	for (a = 0; a < 11; a += 1) {
	    if (recent_song[a] = "") break
	    if (a = 0) {
	        c += 36
	        if (language != 1) draw_text_dynamic(b - 20, c, "Recent songs:")
	        else draw_text_dynamic(b - 20, c, "最近歌曲：")
	        c += 16
	    }

	    popup_set_window(b, c, 320, 16, recent_song[a])
	    m = mouse_rectangle(b, c, 320, 16)
	    m += m && mouse_check_button(mb_left)
	    if (m > 0 && mouse_check_button_released(mb_left)) {
			if (windowsound && theme = 3) play_sound(soundinvoke, 45, 100, 50, 0)
	        if (!file_exists_lib(recent_song[a])) {
	            if (language != 1) message("Could not find file:\n" + recent_song[a], "Error")
	            else message("找不到文件：\n" + recent_song[a], "错误")
	            for (d = 0; d < 10; d += 1) {
	                if (recent_song[d] = recent_song[a]) {
	                    for (e = d; e < 10; e += 1) {
	                        recent_song[e] = recent_song[e + 1]
	                        recent_song_time[e] = recent_song_time[e + 1]
	                    }
	                }
	            }
	            recent_song[10] = ""
	            recent_song_time[10] = 0
	        } else {
				windowalpha = 0
				windowclose = 0
				windowopen = 0
	            load_song(recent_song[a], 0, 1)
	        }
	    }
	    if (!hires || theme != 3) draw_sprite(spr_frame5, theme * 3 + m + 3 * (fdark && theme = 3), b, c)
	    else draw_sprite_ext(spr_frame5_hires, m + 3 * fdark, b, c, 0.25, 0.25, 0, -1, draw_get_alpha())
	    draw_text_dynamic(b + 2 + (m = 2), c + 1 + (m = 2), string_truncate(filename_name(recent_song[a]), 220), true)
	    draw_set_halign(fa_right)
	    draw_text_dynamic(b + 316 + (m = 2), c + 1 + (m = 2), seconds_to_str(floor(date_second_span(recent_song_time[a], date_current_datetime()))))
	    draw_set_halign(fa_left)
	    c += 16
	}
	c += 10
	if (recent_song[0] = "")
	 c += 34
	b = x1 + 300
	
	// Note Block World button
	a = mouse_rectangle(b, c, 224 * 1.5, 32)
	a += (a && (mouse_check_button(mb_left) || mouse_check_button_released(mb_left)))
	if (!hires || theme != 3) draw_sprite_ext(spr_frame2, a + 3 * theme + 3 * (fdark && theme = 3), b, c, 1.5, 1, 0, -1, 1)
	else draw_sprite_ext(spr_frame2_hires, a + 3 * fdark, b, c, 0.25 * 1.5, 0.25, 0, -1, draw_get_alpha())
	if (theme != 3) {
		draw_sprite(spr_bigicons, 6, b + (a > 1), c + (a > 1))
	} else {
		if (!hires) {
			if (!fdark) draw_sprite(spr_bigicons_f, 6, b + (a > 1), c + (a > 1))
			else draw_sprite(spr_bigicons_d, 6, b + (a > 1), c + (a > 1))
		} else {
			if (!fdark) draw_sprite_ext(spr_bigicons_f_hires, 6, b + (a > 1), c + (a > 1), 0.25, 0.25, 0, -1, draw_get_alpha())
			else draw_sprite_ext(spr_bigicons_d_hires, 6, b + (a > 1), c + (a > 1), 0.25, 0.25, 0, -1, draw_get_alpha())
		}
	}
	if (language != 1) draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1) - 7, "Browse songs made by the community");
	else draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1) - 7, "浏览社区制作的歌曲");
	
	// New badge
	draw_set_color(accent[4]);
	b += (-16);
	c += 8;
	draw_roundrect_ext(b + 300 - 18, c - 7, b + 300 + 20, c + 8, 15, 15, false);
	draw_set_color(c_white);
	draw_theme_font(font_main_bold);
	draw_text_dynamic(b + 300 - 14, c - 6, "NEW!");
	draw_theme_font(font_main);
	b -= (-16);
	c -= 8;
	
	draw_set_color(c_gray);
	if (language != 1) draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1) + 7, "Go to noteblock.world");
	else draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1) + 7, "前往 noteblock.world");
	draw_theme_color();
	if (a = 2 && mouse_check_button_released(mb_left)) {
		if (windowsound && theme = 3) play_sound(soundinvoke, 45, 100, 50, 0)
		open_url("https://noteblock.world/");
	    return 1;
	}
	c += 44;
	
	a = mouse_rectangle(b, c, 224, 32)
	a += (a && (mouse_check_button(mb_left) || mouse_check_button_released(mb_left)))
	if (!hires || theme != 3) draw_sprite(spr_frame2, a + 3 * theme + 3 * (fdark && theme = 3), b, c)
	else draw_sprite_ext(spr_frame2_hires, a + 3 * fdark, b, c, 0.25, 0.25, 0, -1, draw_get_alpha())
	if (theme != 3) {
		draw_sprite(spr_bigicons, 2, b + (a > 1), c + (a > 1))
	} else {
		if (!hires) {
			if (!fdark) draw_sprite(spr_bigicons_f, 2, b + (a > 1), c + (a > 1))
			else draw_sprite(spr_bigicons_d, 2, b + (a > 1), c + (a > 1))
		} else {
			if (!fdark) draw_sprite_ext(spr_bigicons_f_hires, 2, b + (a > 1), c + (a > 1), 0.25, 0.25, 0, -1, draw_get_alpha())
			else draw_sprite_ext(spr_bigicons_d_hires, 2, b + (a > 1), c + (a > 1), 0.25, 0.25, 0, -1, draw_get_alpha())
		}
	}
	if (language != 1) draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1), "Generate song out of MIDI file")
	else draw_text_dynamic(b + 48 + (a > 1), c + 9 + (a > 1), "从 MIDI 文件生成")
	if (a = 2 && mouse_check_button_released(mb_left)) {
		if (windowsound && theme = 3) play_sound(soundinvoke, 45, 100, 50, 0)
		windowalpha = 0
		windowclose = 0
		windowopen = 0
		open_midi("", 1)
	}

	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) {
		window_set_cursor(curs)
		if (array_length(text_mouseover) = 0) window_set_cursor(cr_default)
	}
	if (!isplayer) if (draw_icon(4, x1 + 700 - 40, y1 + 430 - 40, condstr(language != 1, "Player Mode", "播放器模式"), 0, 0, 1)) {
		isplayer = 1 //Go into player mode if button is pressed in the greeting screen
		//window_set_size(floor(800 * window_scale), floor(500 * window_scale))
		if (!port_taken) network_destroy(server_socket)
		else network_destroy(client_socket)
		window_setnormal()
	}
}
