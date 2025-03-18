function control_draw() {
	// control_draw()
	var a, b, c, d, e, f, g, p, l, s, exist, str, str2, m, xx, x1, y1, x2, y2, iconcolor, showmenu, totalcols, totalrows, compx, prev, colr, note_offset;

	var checkplaying = playing - playing_prev
	playing_prev = playing
	
	var current_song = songs[song]
	var tabwidth = 180
	if (179 * array_length(songs) + 30 > rw - 14) tabwidth = (rw - 14 - 30) / array_length(songs) + 1
	
	var song_tab_offset = get_tab_offset()
	
	var song_tab_texty = get_tab_texty()
	
	var remove_emitters_all_schedule = 0

	rw = floor(window_width * (1 / window_scale))
	rh = floor(window_height * (1 / window_scale))
	
	var centerx = floor(rw / 2)
	var centery = floor(rh / 2)
	
	update_window_scale()
	
	if (!mouseover) curs = cr_default
	showmenu = 0
	cursmarker = 0
	compx = 160
	
	draw_set_alpha(1)
	draw_theme_color()
	draw_theme_font(font_main)

	if (theme = 0) window_background = 15790320
	if (theme = 1) window_background = 13160660
	if (theme = 2) window_background = c_dark
	// if (theme = 3) window_background = c_white
	if (theme = 3) window_background = 15987699
	if (theme = 3 && fdark) window_background = 2105376
	draw_clear(window_background)
	if (theme = 3 && acrylic && wpaperexist && can_draw_mica) {
		var wpapertodraw = wpaperblur
		if (wpapernoblur = 1) wpapertodraw = wpaper
		var wpaperscale = 1
		if (wpaperanchor = 0) {
			wpaperscale = (1 / window_scale) * (display_width / sprite_get_width(wpaper)) * (!wpaperside) + (1 / window_scale) * (display_height / sprite_get_height(wpaper)) * (wpaperside)
			draw_sprite_tiled_ext(wpapertodraw, 0,
			0 - window_get_x() * (1 / window_scale) - (sprite_get_width(wpaper) * (display_height / sprite_get_height(wpaper)) - display_width) * (1 / window_scale) * (wpaperside) / 2,
			0 - window_get_y() * (1 / window_scale) - (sprite_get_height(wpaper) * (display_width / sprite_get_width(wpaper)) - display_height) * (1 / window_scale) * (!wpaperside) / 2,
			wpaperscale,
			wpaperscale, -1, 1)
		}
		else if (wpaperanchor = 1) {
			wpaperscale = (1 / window_scale) * (window_width / sprite_get_width(wpaper)) * (!wpaperside) + (1 / window_scale) * (window_height / sprite_get_height(wpaper)) * (wpaperside)
			draw_sprite_ext(wpapertodraw, 0,
			(rw - sprite_get_width(wpaper) * wpaperscale) / 2,
			(rh - sprite_get_height(wpaper) * wpaperscale) / 2,
			wpaperscale,
			wpaperscale, 0, -1, 1)
		}
	}
	if (isplayer) {
		draw_set_color(15790320)
		if (theme = 1) draw_set_color(13160660)
		if (theme = 2) draw_set_color(c_dark)
		if (theme = 3) draw_set_color(15987699)
		if (theme = 3 && acrylic && wpaperexist && can_draw_mica) draw_set_color(15198183)
		if (theme = 3 && fdark) draw_set_color(2105376)
		if (theme = 3 && fdark && acrylic && wpaperexist && can_draw_mica) draw_set_color(1315860)
		if (theme = 3 && acrylic && wpaperexist && can_draw_mica) draw_set_alpha(0.875)
		if (theme != 3 or !wpapernodim) draw_rectangle(0, 0, rw, rh, 0)
		draw_set_alpha(1)
	}

	iconcolor = c_black
	if (theme = 2 || (theme = 3)) iconcolor = c_white

	// Calculate area
	if (!fullscreen && show_layers) {
		totalcols = floor((rw - 8 - 270) / 32)
	} else if (dropmode) {
		totalcols = floor(rh / 32) + 1
	} else {
		totalcols = floor(rw / 32) + 1
	}
	rhval = 270 + song_tab_offset
	if (!show_piano) {
		rhval = 130 + song_tab_offset
	}
	if (fullscreen) {
		rhval = 32
	}
	totalrows = floor((rh - rhval) / 32) - (current_song.reference_audio >= 0 && !fullscreen)
	if (fullscreen) totalrows += 1
	if (min(keysmax, floor((rw - 32) / 39)) != keysshow) {
	    if (!isplayer) startkey = 27 - floor(min(keysmax, floor((rw - 32) / 39)) / 2)
		else startkey = 0
	    sharpkeys = 0
	    for (a = 0; a < startkey; a += 1) {
	        b = a mod 7
	        if (b != 1 && b != 4) sharpkeys += 1
	    }
	}
	keysshow = min(keysmax, floor((rw - 32) / 39))
	x1 = -2
	if (!fullscreen && show_layers) {
		x1 = 264
	}
	if (fullscreen) {
		y1 = -2
	} else {
		y1 = 52 + song_tab_offset
	}
	if ((window = 0 || select > 0) && playing = 0 && !isplayer) {
	    if (mouse_rectangle(x1 + 2, y1 + 34, totalcols * 32, totalrows * 32) || select > 0) {
	        sela = floor((mouse_x - (x1 + 2)) / 32)
	        selb = floor((mouse_y - (y1 + 34)) / 32)
	        curs = cr_handpoint
        
	    }
	    if (mouse_rectangle(x1 + 2 + floor(current_song.marker_pos * 32 - current_song.starta * 32) - 8, y1, 16, totalrows * 32 + 32) && mouse_rectangle(x1 + 2, y1 + 2, totalcols * 32, totalrows * 32 + 64) && select = 0 && window = 0) {
	        cursmarker = 1
	        curs = cr_size_we
	        if (mouse_check_button(mb_left)) {
	            window = w_dragmarker
	        }
	    }
	    if (current_song.section_exists) {
	        if (mouse_rectangle(x1 + 2 + floor(current_song.section_start * 32 - current_song.starta * 32) - 8, y1, 16, totalrows * 32 + 32) && select = 0 && window = 0 && cursmarker = 0) {
	            cursmarker = 1
	            curs = cr_size_we
	            if (mouse_check_button(mb_left)) {
	                window = w_dragsection_start
	            }
	        }
	        if (mouse_rectangle(x1 + 2 + floor(current_song.section_end * 32 - current_song.starta * 32) - 8, y1, 16, totalrows * 32 + 32) && select = 0 && window = 0 && cursmarker = 0) {
	            cursmarker = 1
	            curs = cr_size_we
	            if (mouse_check_button(mb_left)) {
	                window = w_dragsection_end
	            }
	        }
	    }
	    if (mouse_rectangle(x1 + 2 + song_tab_offset, y1 + 2, totalcols * 32, 32) && window = 0) {
	        if (select = 0 && playing = 0 && mouse_check_button_pressed(mb_right)) {
	            if (language != 1) show_menu_ext("section", mouse_x, mouse_y, inactive(!current_song.section_exists) + "Remove section|"+
	                                                inactive(!current_song.section_exists || current_song.section_start > current_song.enda) + "Jump to beginning of section|"+
	                                                inactive(!current_song.section_exists || current_song.section_end > current_song.enda) + "Jump to ending of section|-|"+
	                                                inactive(!current_song.section_exists) + "Select all blocks in section|-|"+
	                                                check(marker_start) + "Start playing in section|"+
	                                                check(marker_end) + "Stop playing after section")
	            else show_menu_ext("section", mouse_x, mouse_y, inactive(!current_song.section_exists) + "移除区间|"+
	                                                inactive(!current_song.section_exists || current_song.section_start > current_song.enda) + "跳到区间开始|"+
	                                                inactive(!current_song.section_exists || current_song.section_end > current_song.enda) + "跳到区间结束|-|"+
	                                                inactive(!current_song.section_exists) + "选中区间内方块|-|"+
	                                                check(marker_start) + "从区间开始播放|"+
	                                                check(marker_end) + "区间后结束播放")
	        }
	        if (mouse_check_button_pressed(mb_left)) {
	            timeline_pressa = current_song.starta + floor((mouse_x - (x1 + 2)) / 32)
	        }
	        if (mouse_check_button_released(mb_left) && aa = 0) {
	            current_song.marker_pos = current_song.starta + (mouse_x - (x1 + 2)) / 32
	        } 
	        if (mouse_check_button(mb_left)) {
	            if (current_song.starta + floor((mouse_x - (x1 + 2)) / 32)<>timeline_pressa && timeline_pressa > -1) {
	                window = w_dragsection_end
	                current_song.section_exists = 1
	                current_song.section_end = current_song.starta + floor((mouse_x - (x1 + 2)) / 32)
	                current_song.section_start = timeline_pressa
	                timeline_pressa = -1
	            }
	        }
	    }
	}
	exist = 0
	if (((sela > -1 && selb > -1) || select > 0) && !isplayer) {
	    if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right) || mouse_check_button_pressed(mb_middle)) clickinarea = 1
	    selbx = current_song.starta + sela
	    selby = current_song.startb + selb
	    if (select = 0 && current_song.selected = 0 && selbx < current_song.arraylength && selby < current_song.arrayheight) {
	        exist = current_song.song_exists[selbx, selby]
	        if (exist && cursmarker = 0) {
	            if (changepitch && (mouse_wheel_up() || mouse_wheel_down())) {
					var diff = mouse_wheel_up() - mouse_wheel_down()
					// If shift is not pressed, do increments of a single key or 10 steps at once.
					if (!keyboard_check(vk_shift) && (editmode != m_key)) {
						diff *= 10
					}
					// If shift is pressed, do increments of a whole octave or fine-tune increments to one step
					if (keyboard_check(vk_shift) && (editmode = m_key)) {
						diff *= 12
					}
					var key = current_song.song_key[selbx, selby]
					var vel = current_song.song_vel[selbx, selby]
					var pan = current_song.song_pan[selbx, selby]
					var pit = current_song.song_pit[selbx, selby]
					if (editmode = m_key) {
						key = median(0, key + diff, 87)
					} else if (editmode = m_vel) {
						vel = median(0, vel + diff, 100)
					} else if (editmode = m_pan) {
						pan = median(0, pan + diff, 200)
					} else if (editmode = m_pit) {
						if (current_song.instrument_list[| ds_list_find_index(current_song.instrument_list, current_song.song_ins[selbx, selby])].name != "Tempo Changer") pit = median(-1200, pit + diff, 1200)
						else pit += diff
					}
					change_block_manual(selbx, selby, current_song.song_ins[selbx, selby], key, vel, pan, pit)
	            }
	        }
	    }
	}
	if (mousewheel = 1 && window = 0 && (exist = 0 || changepitch = 0) && !isplayer && !volume_scroll) {
	    var insindex = ds_list_find_index(current_song.instrument_list, current_song.instrument)
	    if (mouse_wheel_down() && insindex > 0) {
	        insindex--
	        current_song.instrument = current_song.instrument_list[| insindex]
			selected_vel = 100
			selected_pan = 100
			selected_pit = 0
	        play_sound(current_song.instrument, selected_key, 100 ,100, 0)
	    }
	    if (mouse_wheel_up() && insindex < ds_list_size(current_song.instrument_list) - 1) {
	        insindex++
	        current_song.instrument = current_song.instrument_list[| insindex]
			selected_vel = 100
			selected_pan = 100
			selected_pit = 0
	        play_sound(current_song.instrument, selected_key, 100 ,100, 0)
	    }
	}
	if (mousewheel = 2 && window = 0 && (exist = 0 || changepitch = 0) && !isplayer && !volume_scroll) {
	    if (mouse_wheel_down() && selected_key > 0) {
	        selected_key -= 1
			selected_vel = 100
			selected_pan = 100
			selected_pit = 0
	        play_sound(current_song.instrument, selected_key, 100 ,100, 0)
	    }
	    if (mouse_wheel_up() && selected_key < 87) {
	        selected_key += 1
			selected_vel = 100
			selected_pan = 100
			selected_pit = 0
	        play_sound(current_song.instrument, selected_key, 100 ,100, 0)
	    }
	}

	// Draw note blocks
	draw_set_halign(fa_center)
	for (b = 0; b <= totalrows; b += 1) {
	    lockedlayer[current_song.startb + b] = 0
	    if (current_song.solostr != "") {
	        if (string_count("|" + string(current_song.startb + b) + "|", current_song.solostr) = 0) {
	            lockedlayer[current_song.startb + b] = 1
	        } else if (current_song.layerlock[current_song.startb + b] = 1) {
	            lockedlayer[current_song.startb + b] = 1
	        }
	    } else if (current_song.startb + b < current_song.endb2) {
	        if (current_song.layerlock[current_song.startb + b] = 1) {
	            lockedlayer[current_song.startb + b] = 1
	        }
	    }
	}
	if (blackout) {
		draw_set_color(c_black)
		if (!isplayer) {
			draw_rectangle(x1 + 2, y1 + 34, x1 + 2 + 32 * totalcols, y1 + 34 + 32 * totalrows, false)
		} else {
			draw_clear(c_black)
		}
	}
	if (!isplayer && theme = 3 && !blackout) {
		if (noeditingbackground) {
			draw_set_color(15987699)
			if (acrylic && wpaperexist && can_draw_mica) draw_set_color(15198183)
			if (fdark) draw_set_color(2105376)
			if (fdark && acrylic && wpaperexist && can_draw_mica) draw_set_color(1315860)
			if (acrylic && wpaperexist && can_draw_mica) draw_set_alpha(0.875)
			if (!wpapernodim) draw_rectangle(x1 + 2, y1 + 1, x1 + 2 + 32 * totalcols + 16, y1 + 34 + 32 * totalrows + 16, false)
			draw_set_alpha(1)
		} else {
			draw_set_color(16382457)
			if (fdark) draw_set_color(2565927)
			draw_rectangle(x1 + 2, y1 + 34, x1 + 2 + 32 * totalcols, y1 + 34 + 32 * totalrows, false)
		}
	}
	note_offset = floor(((current_song.marker_pos - floor(current_song.marker_pos + 0.5 * !isplayer)) * 32) + 0.5) * ((playing && marker_follow && marker_pagebypage = 2 && (current_song.marker_pos - floor(totalcols / 2 + 0.5) < current_song.enda + 1 && current_song.marker_pos - floor(totalcols / 2 + 0.5) > 0)) || isplayer)
	if (!isplayer) {
	var tempo_changer_display_queue = []
	for (a = 0; a < totalcols; a += 1) {
		if (!blackout) {
			if ((current_song.starta + a) mod (current_song.timesignature * 4) == 0) {
				draw_set_alpha(0.3)
				if (window_scale < 1) draw_set_alpha(0.5) //Issue #254, make the lines more obvious when scaled down
				if (playing && marker_pagebypage = 2 && window_scale < 1) draw_line(x1 + 2 + 32 * a - note_offset, y1 + 34, (x1 + 2 + 32 * a) - note_offset, y1 + 34 + totalrows * 32)
				else draw_rectangle(x1 + 2 + 32 * a - note_offset, y1 + 34, (x1 + 2 + 32 * a) + 1 - note_offset, y1 + 34 + totalrows * 32, false)
			} else {
				draw_set_alpha(0.1)
				if ((current_song.starta + a) mod 4 == 0) draw_set_alpha(0.25)
				draw_line(x1 + 2 + 32 * a - note_offset, y1 + 34, x1 + 2 + 32 * a - note_offset, y1 + 34 + totalrows * 32)
			}
		}
	    for (b = 0; b < totalrows; b += 1) {
	        if (current_song.starta + a <= current_song.enda) {
	            if (current_song.startb + b <= current_song.endb) {
	                if (current_song.colamount[current_song.starta + a] > 0) {
	                    if (current_song.startb + b >= current_song.colfirst[current_song.starta + a] && current_song.startb + b <= current_song.collast[current_song.starta + a]) {
	                        if (current_song.song_exists[current_song.starta + a, current_song.startb + b]) {
	                            s = 0 // Selected
	                            if (fade=0) c = 0.5 * (current_song.song_vel[current_song.starta + a, current_song.startb + b] / 100) + 0.25
								else c = 1
	                            if (lockedlayer[current_song.startb + b] = 0) c += 0.5 * (1 - (min(1000, current_time - current_song.song_played[current_song.starta + a, current_song.startb + b]) / 1000))
	                            if (playing = 0) {
	                                if (select = 1 && lockedlayer[current_song.startb + b] = 0) {
	                                    s = (current_song.starta + a >= min(select_pressa, selbx) && current_song.starta + a <= max(select_pressa, selbx) && current_song.startb + b >= min(select_pressb, selby) && current_song.startb + b <= max(select_pressb, selby))
	                                }
	                                if (fade=0) c += ((selbx = current_song.starta + a && selby = current_song.startb + b && select = 0 && window = 0  && cursmarker = 0) || s) * 0.5
	                            }
	                            draw_block(x1 + 2 + 32 * a - note_offset, y1 + 34 + 32 * b, current_song.song_ins[current_song.starta + a, current_song.startb + b], current_song.song_key[current_song.starta + a, current_song.startb + b], current_song.song_pan[current_song.starta + a, current_song.startb + b], current_song.song_vel[current_song.starta + a, current_song.startb + b], current_song.song_pit[current_song.starta + a, current_song.startb + b], c, s * 0.8)
								if (current_song.instrument_list[| ds_list_find_index(current_song.instrument_list, current_song.song_ins[current_song.starta + a, current_song.startb + b])].name = "Tempo Changer") array_push(tempo_changer_display_queue, [x1 + 2 + 32 * a - note_offset, y1 + 34 + 32 * b, string(abs(current_song.song_pit[current_song.starta + a, current_song.startb + b]))])
							}
	                    }
	                } else {
	                    break
	                }
	            } else {
	                break
	            }
	        } else {
	            break
	        }
	    }
	    draw_theme_color()
	}
	} else if (dropmode) {
	// Drop mode notes
	for (a = 0; a < totalcols; a += 1) {
	    for (b = 0; b <= current_song.endb; b += 1) {
	        if (floor(current_song.starta) + a <= current_song.enda) {
	            if (current_song.startb + b <= current_song.endb) {
	                if (current_song.colamount[current_song.starta + a] > 0) {
	                    if (current_song.startb + b >= current_song.colfirst[current_song.starta + a] && current_song.startb + b <= current_song.collast[current_song.starta + a]) {
	                        if (current_song.song_exists[current_song.starta + a, current_song.startb + b]) {
	                            s = 0 // Selected
	                            if (fade=0) c = 0.5 * (current_song.song_vel[current_song.starta + a, current_song.startb + b] / 100) + 0.25
								else c = 1
	                            //if (lockedlayer[startb + b] = 0) c += 0.5 * (1 - (min(1000, current_time - song_played[starta + a, startb + b]) / 1000))
	                            if (playing = 0) {
	                                //if (select = 1 && lockedlayer[startb + b] = 0) {
	                                //    s = (starta + a >= min(select_pressa, selbx) && starta + a <= max(select_pressa, selbx) && startb + b >= min(select_pressb, selby) && startb + b <= max(select_pressb, selby))
	                                //}
	                                if (fade=0) c += ((selbx = current_song.starta + a && selby = current_song.startb + b && select = 0 && window = 0  && cursmarker = 0) || s) * 0.5
	                            }
								realkey = current_song.song_key[current_song.starta + a, current_song.startb + b] + current_song.song_pit[current_song.starta + a, current_song.startb + b] / 100
	                            draw_block(floor(centerx - (52 * 39) / 2) + floor(19.5 * (realkey + floor(realkey / 12) * 2 + (realkey mod 12 >= 8) + (realkey mod 12 >= 3))) + 4, rh - 154 - a * 32 - 32 + note_offset, current_song.song_ins[current_song.starta + a, current_song.startb + b], current_song.song_key[current_song.starta + a, current_song.startb + b], current_song.song_pan[current_song.starta + a, current_song.startb + b], current_song.song_vel[current_song.starta + a, current_song.startb + b] * (current_song.layervol[b] / 100), current_song.song_pit[current_song.starta + a, current_song.startb + b], c, s * 0.8)
	                        }
	                    }
	                } else {
	                    break
	                }
	            } else {
	                break
	            }
	        } else {
	            break
	        }
	    }
	    draw_theme_color()
	}
	} else {
		try {
		if (current_song.song_exists[current_song.starta + a, current_song.startb + b]) {}
		}
		catch (e) {}
	}
	draw_set_alpha(1)
	draw_set_halign(fa_left)

	if (checkplaying > 0) {
		if (current_song.reference_option > 0 && !audio_is_playing(current_song.reference_sound)) {
			current_song.reference_sound = audio_play_sound(current_song.reference_audio, 1, 0)
			audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
			audio_sound_set_track_position(current_song.reference_sound, current_song.marker_pos / current_song.tempo + current_song.reference_offset / 1000)
		}
	}
	if (checkplaying < 0) {
		for (var i = 0; i < array_length(songs); i++) {
			if (audio_is_playing(songs[i].reference_sound)) audio_stop_sound(songs[i].reference_sound)
		}
	}

	if (current_song.tempo < 0.25) current_song.tempo = 0.25
	if (window = w_dragselection) {
	    current_song.selection_x = current_song.starta + floor((mouse_x - (x1 + 2)) / 32) - select_pressa
	    current_song.selection_y = current_song.startb + floor((mouse_y - (y1 + 34)) / 32) - select_pressb
	    curs = cr_size_all
	}

	// Draw selection
	if (current_song.selected > 0) selection_draw(x1 + 2 - note_offset, y1 + 34, totalcols, totalrows)
	current_song.marker_prevpos = current_song.marker_pos
	if (window = w_dragselection) {
	    if (!mouse_check_button(mb_left)) {
	        current_song.selection_x = max(0, current_song.selection_x)
	        current_song.selection_y = max(0, current_song.selection_y)
	        history_set(h_selectmove, current_song.selection_x, current_song.selection_y, selection_sx, selection_sy)
	        window = w_releasemouse
			selection_expand_layers()
	    }
	}
	if (!isplayer) {

	// Draw locked layers
	for (b = 0; b < totalrows; b += 1) {
	    if (lockedlayer[current_song.startb + b]) draw_sprite_ext(spr_lock, 0, x1 + 2, y1 + 34 + b * 32, totalcols, 1, 0, -1, 0.25)
	}

	// Controls
	if (sela > -1 && selb > -1 && window = 0 && cursmarker = 0 && clickinarea = 1) {
	    if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right)) {
	        if (mouse_check_button_pressed(mb_left) && !check_ctrl() && current_song.selected > 0) {
	            selection_place(0)
	            dontplace = 1
	        }
			if (mouse_check_button_pressed(mb_left) && check_ctrl()) {selection_add(current_song.starta + sela, current_song.startb + selb, current_song.starta + sela, current_song.startb + selb, 0, 0)}
	        select_pressx = mouse_x
	        select_pressy = mouse_y
	        select_pressa = current_song.starta + sela
	        select_pressb = current_song.startb + selb
	    }
	    if (mouse_check_button(mb_left)) {
	        if ((current_song.starta + sela != select_pressa || current_song.startb + selb != select_pressb) && select_pressx != -1) {
	            select = 1
	        }
	    }
	    if (mouse_check_button_released(mb_left)) {
	        if (current_song.selected = 0) {
	            if (dontplace = 0) {
	                if (exist = 1) {
	                    change_block_manual(selbx, selby, current_song.instrument, selected_key, selected_vel, selected_pan, selected_pit)
	                } else {
	                    add_block_manual(current_song.starta + sela, current_song.startb + selb, current_song.instrument, selected_key, selected_vel, selected_pan, selected_pit)
	                    draw_set_halign(fa_center)
	                    draw_block(x1 + 2 + 32 * sela, y1 + 34 + 32 * selb, current_song.instrument, selected_key, selected_vel, selected_pan, selected_pit, 0.5, 0)    
						draw_theme_color()
	                    draw_set_halign(fa_left)
	                    draw_set_alpha(1)
	                }
	            }
	        } else {
	            if (select = 0 && !check_ctrl()) selection_place(0)
	        }
	        dontplace = 0
	    }
		if (mouse_check_button_pressed(mb_middle)) {
			if (exist = 1) {
				selected_key = current_song.song_key[selbx, selby]
				current_song.instrument = current_song.song_ins[selbx, selby]
				if (check_ctrl()) {
					selected_vel = current_song.song_vel[selbx, selby]
					selected_pan = current_song.song_pan[selbx, selby]
					selected_pit = current_song.song_pit[selbx, selby]
				} else {
					selected_vel = 100
					selected_pan = 100
					selected_pit = 0
				}
				play_sound(current_song.instrument, selected_key, selected_vel, selected_pan, selected_pit)
			}
				
		}
		if (mouse_check_button_pressed(mb_right) && check_ctrl()) {selection_remove(current_song.starta + sela, current_song.startb + selb, current_song.starta + sela, current_song.startb + selb, 0, 0)}
	    if (mouse_check_button(mb_right) && !check_ctrl()) {
	        if ((current_song.starta + sela != select_pressa || current_song.startb + selb != select_pressb) && select_pressx != -1) {
	            select = 2
	        } else if (exist = 1) {
	            remove_block_manual(selbx, selby)
	            select_pressx = -1
	        }
	    }
	    if (mouse_check_button_released(mb_right)) {
	        if (current_song.starta + sela = select_pressa && current_song.startb + selb = select_pressb && select_pressx != -1 && !check_ctrl()) {
	            str = ""
	            customstr = ""
				insmenu = 1
	            for (a = 0; a < ds_list_size(current_song.instrument_list); a += 1) {
	                var ins = current_song.instrument_list[| a];
	                if (ins.user) {
	                    if (language != 1) customstr += "...to " + clean(ins.name) + "|"
	                    else customstr += "...为 " + clean(ins.name) + "|"
					} else {
	                    if (language != 1) str += "...to " + clean(ins.name) + "|"
	                    else str += "...为 " + clean(ins.name) + "|"
					}
					if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
						if (language != 1) customstr += "-|More...|\\|"
						else customstr += "-|更多......|\\|"
						insmenu++
					}
				}
	            if (language != 1) menu = show_menu_ext("editext", mouse_x, mouse_y, inactive(current_song.selected = 0) + icon(icons.COPY - (current_song.selected = 0)) + get_hotkey("copy") + "$Copy|"+
	                                      inactive(current_song.selected = 0) + icon(icons.CUT - (current_song.selected = 0)) + get_hotkey("cut") + "$Cut|"+
	                                      inactive(selection_copied = "") + icon(icons.PASTE - (selection_copied = "")) + get_hotkey("paste") + "$Paste|"+
	                                      inactive(current_song.selected = 0) + icon(icons.DELETE - (current_song.selected = 0)) + get_hotkey("delete") + "$Delete|-|"+
	                                      inactive(current_song.totalblocks = 0) + get_hotkey("select_all") + "$Select all|"+
	                                      inactive(current_song.selected = 0) + "Deselect all|"+
	                                      inactive(current_song.selected = 0 && current_song.totalblocks = 0) + get_hotkey("invert_selection") + "$Invert selection|-|"+
	                                      inactive(current_song.totalblocks = 0 || selbx >= current_song.enda) + "Select all to the right ->|"+
	                                      inactive(current_song.totalblocks = 0 || selbx <= 0) + "Select all to the left <-|-|"+
	                                      inactive(current_song.instrument.num_blocks = 0) + "Select all " + clean(current_song.instrument.name) + "|"+
	                                      inactive(current_song.instrument.num_blocks = current_song.totalblocks) + "Select all but " + clean(current_song.instrument.name) + "|-|"+
	                                        inactive(current_song.selected = 0) + get_hotkey("action_1") + "$" + get_mode_actions(1) + "|"+
	                                        inactive(current_song.selected = 0) + get_hotkey("action_2") + "$" + get_mode_actions(2) + "|"+
	                                        inactive(current_song.selected = 0) + get_hotkey("action_3") + "$" + get_mode_actions(3) + "|"+
	                                        inactive(current_song.selected = 0) + get_hotkey("action_4") + "$" + get_mode_actions(4) + "|"+
											condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey("action_5") + "$" + get_mode_actions(5) + "|") +
											condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey("action_6") + "$" + get_mode_actions(6) + "|") +
	                                        inactive(current_song.selected = 0) + "Change instrument...|\\|" + str + condstr(customstr != "", "-|")  + customstr + string_repeat("/|", insmenu) + "-|" +
	                                        inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Expand selection|"+
	                                        inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Compress selection|"+
	                                        inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Macros...|\\||"+
											get_hotkey("tremolo") + "$Tremolo...|"+
											get_hotkey("stereo") + "$Stereo...|"+
											get_hotkey("arpeggio") + "$Arpeggio...|"+
											get_hotkey("portamento") + "$Portamento...|"+
											get_hotkey("vibrato") + "$Vibrato|"+
											get_hotkey("stagger") + "$Stagger...|"+
											get_hotkey("chorus") + "$Chorus|"+
											get_hotkey("volume_lfo") + "$Volume LFO|"+
											get_hotkey("fade_in") + "$Fade in|"+
											get_hotkey("fade_out") + "$Fade out|"+
											get_hotkey("replace_key") + "$Replace key|"+
											get_hotkey("set_velocity") + "$Set velocity...|"+
											get_hotkey("set_panning") + "$Set panning...|"+
											get_hotkey("set_pitch") + "$Set pitch...|"+
											get_hotkey("reset_properties") + "$Reset all properties|"+
											"/|-|"+
	                                        inactive(current_song.selected = 0) + "Transpose notes outside octave range|")
	            else menu = show_menu_ext("editext", mouse_x, mouse_y, inactive(current_song.selected = 0) + icon(icons.COPY - (current_song.selected = 0)) + get_hotkey("copy") + "$复制|"+
	                                      inactive(current_song.selected = 0) + icon(icons.CUT - (current_song.selected = 0)) + get_hotkey("cut") + "$剪切|"+
	                                      inactive(selection_copied = "") + icon(icons.PASTE - (selection_copied = "")) + get_hotkey("paste") + "$粘贴|"+
	                                      inactive(current_song.selected = 0) + icon(icons.DELETE - (current_song.selected = 0)) + get_hotkey("delete") + "$删除|-|"+
	                                      inactive(current_song.totalblocks = 0) + get_hotkey("select_all") + "$全选|"+
	                                      inactive(current_song.selected = 0) + "全不选|"+
	                                      inactive(current_song.selected = 0 && current_song.totalblocks = 0) + get_hotkey("invert_selection") + "$选择反转|-|"+
	                                      inactive(current_song.totalblocks = 0 || selbx >= current_song.enda) + "选择右侧所有 ->|"+
	                                      inactive(current_song.totalblocks = 0 || selbx <= 0) + "选择左侧所有 <-|-|"+
	                                      inactive(current_song.instrument.num_blocks = 0) + "选择所有 " + clean(current_song.instrument.name) + "|"+
	                                      inactive(current_song.instrument.num_blocks = current_song.totalblocks) + "选择所有除了 " + clean(current_song.instrument.name) + "|-|"+
	                                        inactive(current_song.selected = 0) + get_hotkey("action_1") + "$" + get_mode_actions(1) + "|"+
	                                        inactive(current_song.selected = 0) + get_hotkey("action_2") + "$" + get_mode_actions(2) + "|"+
	                                        inactive(current_song.selected = 0) + get_hotkey("action_3") + "$" + get_mode_actions(3) + "|"+
	                                        inactive(current_song.selected = 0) + get_hotkey("action_4") + "$" + get_mode_actions(4) + "|"+
											condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey("action_5") + "$" + get_mode_actions(5) + "|") +
											condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey("action_6") + "$" + get_mode_actions(6) + "|") +
	                                        inactive(current_song.selected = 0) + "更改音色......|\\|" + str + condstr(customstr != "", "-|")  + customstr + string_repeat("/|", insmenu) + "-|" +
	                                        inactive(current_song.selected = 0 || current_song.selection_l = 0) + "扩展选区|"+
	                                        inactive(current_song.selected = 0 || current_song.selection_l = 0) + "压缩选区|"+
	                                        inactive(current_song.selected = 0 || current_song.selection_l = 0) + "快捷键......|\\||"+
											get_hotkey("tremolo") + "$Tremolo...|"+
											get_hotkey("stereo") + "$Stereo...|"+
											get_hotkey("arpeggio") + "$Arpeggio...|"+
											get_hotkey("portamento") + "$Portamento...|"+
											get_hotkey("vibrato") + "$Vibrato|"+
											get_hotkey("stagger") + "$Stagger...|"+
											get_hotkey("chorus") + "$Chorus|"+
											get_hotkey("volume_lfo") + "$Volume LFO|"+
											get_hotkey("fade_in") + "$淡入|"+
											get_hotkey("fade_out") + "$淡出|"+
											get_hotkey("replace_key") + "$替换音|"+
											get_hotkey("set_velocity") + "$设定音量......|"+
											get_hotkey("set_panning") + "$设定声道......|"+
											get_hotkey("set_pitch") + "$设定音高......|"+
											get_hotkey("reset_properties") + "$重置所有属性|"+
											"/|-|"+
	                                        inactive(current_song.selected = 0) + "转换所有超出八度范围的音符|")
	            menu.menuc = selbx
	            menu.pastex = selbx
	            menu.pastey = selby
	        }
	    }
	}
	}
	// Keyboard shortcuts
	if (window = 0 && text_focus = -1) {
	    if (playing = 0) {
	        if (check_ctrl() && !keyboard_check(vk_shift)) {
	            if (keyboard_check_pressed(ord("N")) && !isplayer) new_song()
	            if (keyboard_check_pressed(ord("O"))) {load_song("") current_song = songs[song]}
	            if (keyboard_check_pressed(ord("S")) && !isplayer) save_song(current_song.filename)
	            if (keyboard_check_pressed(ord("A")) && !isplayer) select_all(-1, 0)
	            if (keyboard_check_pressed(ord("A")) && keyboard_check(vk_shift) && !isplayer) selection_place(0)
	            if (keyboard_check_pressed(ord("I")) && !isplayer) selection_invert()
	            if (keyboard_check_pressed(ord("C")) && !isplayer) action_copy()
	            if (keyboard_check_pressed(ord("X")) && !isplayer) action_cut()
	            if (keyboard_check_pressed(ord("V")) && !isplayer) {
	                if (selbx > -1 && selby > -1) action_paste(selbx, selby)
	                else action_paste(current_song.starta, current_song.startb)
	            }
	            if (keyboard_check_pressed(ord("Z")) && !isplayer) action_undo()
	            if (keyboard_check_pressed(ord("Y")) && !isplayer) action_redo()
	            if (keyboard_check_pressed(ord("E")) && !isplayer) mode_action(1)
	            if (keyboard_check_pressed(ord("D")) && !isplayer) mode_action(2)
	            if (keyboard_check_pressed(ord("R")) && !isplayer) mode_action(3)
	            if (keyboard_check_pressed(ord("F")) && !isplayer) mode_action(4)
	            if ((editmode != m_key) && (keyboard_check_pressed(ord("T"))) && !isplayer) mode_action(5)
	            if ((editmode != m_key) && (keyboard_check_pressed(ord("G"))) && !isplayer) mode_action(6)
	            if (keyboard_check_pressed(ord("P")) || (keyboard_check_pressed(188) && os_type = os_macosx)) window = w_preferences
	            if (keyboard_check_pressed(ord("W"))) {close_song(song); current_song = songs[song]}
				if keyboard_check_pressed(ord("0")) {
					window_scale = get_default_window_scale()
					set_msg(condstr(language = 1, "窗口缩放", "Window scale") + " => " + string(window_scale * 100) + "%")
				}
	            if ((os_type != os_macosx && keyboard_check_pressed(187)) || (os_type = os_macosx && keyboard_check_pressed(24)) || (mouse_wheel_up())) {
					if (window_scale >= 0.5 && window_scale < 0.67) {window_scale = 0.67}
					else if (window_scale < 0.75) {window_scale = 0.75}
					else if (window_scale < 0.8) {window_scale = 0.8}
					else if (window_scale < 0.9) {window_scale = 0.9}
					else if (window_scale < 1) {window_scale = 1}
					else if (window_scale < 1.25) {window_scale = 1.25}
					else if (window_scale < 1.5) {window_scale = 1.5}
					else if (window_scale < 1.75) {window_scale = 1.75}
					else if (window_scale < 2) {window_scale = 2}
					else if (window_scale < 2.5) {window_scale = 2.5}
					else if (window_scale < 3) {window_scale = 3}
					else if (window_scale < 3.5) {window_scale = 3.5}
					else if (window_scale < 4) {window_scale = 4}
					set_msg(condstr(language = 1, "窗口缩放", "Window scale") + " => " + string(window_scale * 100) + "%")
				}
	            if ((os_type != os_macosx && keyboard_check_pressed(189)) || (os_type = os_macosx && keyboard_check_pressed(109)) || (mouse_wheel_down())) {
					if (window_scale <= 4 && window_scale > 3.5) {window_scale = 3.5}
					else if (window_scale > 3) {window_scale = 3}
					else if (window_scale > 2.5) {window_scale = 2.5}
					else if (window_scale > 2) {window_scale = 2}
					else if (window_scale > 1.75) {window_scale = 1.75}
					else if (window_scale > 1.5) {window_scale = 1.5}
					else if (window_scale > 1.25) {window_scale = 1.25}
					else if (window_scale > 1) {window_scale = 1}
					else if (window_scale > 0.9) {window_scale = 0.9}
					else if (window_scale > 0.8) {window_scale = 0.8}
					else if (window_scale > 0.75) {window_scale = 0.75}
					else if (window_scale > 0.67) {window_scale = 0.67}
					else if (window_scale > 0.5) {window_scale = 0.5}
					set_msg(condstr(language = 1, "窗口缩放", "Window scale") + " => " + string(window_scale * 100) + "%")
				}
	        }
	        if (keyboard_check_pressed(vk_delete) || (os_type = os_macosx && keyboard_check_pressed(vk_backspace)) && current_song.selected > 0 && !isplayer) {
				selection_delete(0)
				current_song.changed = 1
			}
	        if (sb_sel = 0 && !isplayer) {
	            if (keyboard_check_pressed(vk_home)) current_song.starta = 0
	            if (keyboard_check_pressed(vk_end)) current_song.starta = current_song.enda
	            if (keyboard_check_pressed(vk_pageup)) current_song.starta += totalcols
	            if (keyboard_check_pressed(vk_pagedown)) current_song.starta -= totalcols
	            current_song.starta = median(0, current_song.starta, current_song.enda)
	            sb_val[0] = current_song.starta
	        }
	        if (sb_sel = 1 && !isplayer) {
	            if (keyboard_check_pressed(vk_home)) current_song.startb = 0
	            if (keyboard_check_pressed(vk_end)) current_song.startb = current_song.endb
	            if (keyboard_check_pressed(vk_pageup)) current_song.startb += totalrows
	            if (keyboard_check_pressed(vk_pagedown)) current_song.startb -= totalrows
	            current_song.startb = median(0, current_song.startb, current_song.endb)
	            sb_val[1] = current_song.startb
	        }
	    }
	    if (keyboard_check(vk_right)) forward = 1
	    if (keyboard_check(vk_left)) forward = -1
	    if (keyboard_check_pressed(vk_enter)) {
	        playing = 0
	        current_song.marker_pos = 0
	        current_song.marker_prevpos = 0
			remove_emitters_all_schedule = 1
	    }
		if (keyboard_check_pressed(vk_space)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
	    if (keyboard_check_pressed(vk_f1)) {
	        if (language != 1) open_url("http://www.youtube.com/playlist?list=PL7EA4F0D271DA6E86")
			else open_url("https://www.bilibili.com/video/BV1Mx411a76p")
	    }
		// Instrument shortcuts
		if (keyboard_check_pressed(vk_f5) && keyboard_check(vk_control) && keyboard_check(vk_shift) && theme = 3) {
			rainbowtoggle = !rainbowtoggle
			if (language != 1) {
			if (rainbowtoggle) {
				set_msg("Rainbow mode => ON")
			} else {
				set_msg("Rainbow mode => OFF")
				draw_accent_init()
			}
			} else {
			if (rainbowtoggle) {
				set_msg("炫彩模式 => ON")
			} else {
				set_msg("炫彩模式 => OFF")
				draw_accent_init()
			}
			}
		}
		if (!isplayer) {
	    if (keyboard_check(vk_control)) {
		
			//First 9 (only ctrl)
			if(!keyboard_check(vk_shift)){
			   for (a = 1; a <= 9; a++) {
	             if (keyboard_check_pressed(ord(string(a % 10)))) {
	                current_song.instrument = current_song.instrument_list[| a - 1]
					selected_vel = 100
					selected_pan = 100
					selected_pit = 0
	                play_sound(current_song.instrument, selected_key, 100 ,100, 0)
	             }
	           }
			}else{
			  //Last 7 (ctrl+shift)
			  for (a = 1; a <= 7; a++) {
				if (keyboard_check_pressed(ord(string(a % 10)))) {
					current_song.instrument = current_song.instrument_list[| a + 8]
					selected_vel = 100
					selected_pan = 100
					selected_pit = 0
					play_sound(current_song.instrument, selected_key, 100 ,100, 0)
				}
			  }
		   }
		}
		// Control+Shift Stuff (Macros, Clip Editor)
		if (keyboard_check(vk_control)) {
			if (keyboard_check_pressed(ord("P"))&& keyboard_check(vk_shift)) {
				playing = 0 
				text_exists[59] = 0
				window = w_clip_editor
				}
			if (keyboard_check_pressed(ord("I"))&& keyboard_check(vk_shift)) {
				playing = 0 
				window = w_tempotapper
				}
			// Macro Hotkeys
			if current_song.selected != 0 {
				if (keyboard_check_pressed(ord("A"))&& keyboard_check(vk_shift)) {
					playing = 0 
					window = w_tremolo
					}
				if (keyboard_check_pressed(ord("S"))&& keyboard_check(vk_shift)) {
					playing = 0 
					window = w_stereo
					}
				if (keyboard_check_pressed(ord("D"))&& keyboard_check(vk_shift)) {
					playing = 0 
					window = w_arpeggio
					}
				if (keyboard_check_pressed(ord("F"))&& keyboard_check(vk_shift)) {
					playing = 0 
					window = w_portamento
					}
				if (keyboard_check_pressed(ord("G"))&& keyboard_check(vk_shift)) {
					playing = 0 
					macro_vibrato()
					}
				if (keyboard_check_pressed(ord("H"))&& keyboard_check(vk_shift)) {
					playing = 0 
					window = w_stagger
					}
				if (keyboard_check_pressed(ord("J"))&& keyboard_check(vk_shift)) {
					playing = 0 
					macro_chorus()
					}
				if (keyboard_check_pressed(ord("K"))&& keyboard_check(vk_shift)) {
					playing = 0 
					macro_velocitylfo()
					}
				if (keyboard_check_pressed(ord("Q"))&& keyboard_check(vk_shift)) {
					playing = 0 
					macro_fadein()
					}
				if (keyboard_check_pressed(ord("W"))&& keyboard_check(vk_shift)) {
					playing = 0 
					macro_fadeout()
					}
				if (keyboard_check_pressed(ord("E"))&& keyboard_check(vk_shift)) {
					playing = 0 
					macro_replacekey()
					}
				if (keyboard_check_pressed(ord("R"))&& keyboard_check(vk_shift)) {
					playing = 0 
					window = w_setvelocity
					}
				if (keyboard_check_pressed(ord("T"))&& keyboard_check(vk_shift)) {
					playing = 0 
					window = w_setpanning
					}
				if (keyboard_check_pressed(ord("Y"))&& keyboard_check(vk_shift)) {
					playing = 0 
					window = w_setpitch
					}
				if (keyboard_check_pressed(ord("U"))&& keyboard_check(vk_shift)) {
					playing = 0 
					macro_reset()
					}
			}
		}
		}
	}
	if (keyboard_check_pressed(vk_f7) && playing = 0) {
	    if (refreshrate = 0){
			game_set_speed(60,gamespeed_fps)
			refreshrate = 1
			if (language != 1) set_msg("Max framerate => 60 FPS")
			else set_msg("帧数上限 => 60 FPS")
		} else if (refreshrate = 1) {
			game_set_speed(120,gamespeed_fps)
			refreshrate = 2
			if (language != 1) set_msg("Max framerate => 120 FPS")
			else set_msg("帧数上限 => 120 FPS")
		} else if (refreshrate = 2) {
			game_set_speed(144,gamespeed_fps)
			refreshrate = 3
			if (language != 1) set_msg("Max framerate => 144 FPS")
			else set_msg("帧数上限 => 144 FPS")
		} else if (refreshrate = 3) {
			game_set_speed(240,gamespeed_fps)
			refreshrate = 4
			if (language != 1) set_msg("Max framerate => 240 FPS")
			else set_msg("帧数上限 => 240 FPS")
		} else if (refreshrate = 4) {
			game_set_speed(30,gamespeed_fps)
			refreshrate = 0
			if (language != 1) set_msg("Max framerate => 30 FPS")
			else set_msg("帧数上限 => 30 FPS")
		}
	}
	if (keyboard_check_released(vk_f3) && !debug_option) debug_overlay = !debug_overlay
	if (keyboard_check(vk_f3)) {
		if (keyboard_check_released(ord("C"))){
			window = 0
			debug_option = 1
			set_msg("[Debug] Window => 0")
		}
		if (keyboard_check_released(ord("G"))) {
			window = w_greeting
			debug_option = 1
			set_msg("[Debug] Window => w_greeting")
		}
		if (keyboard_check_released(ord("D"))) {
			debug_overlay_ingame = !debug_overlay_ingame
			show_debug_overlay(debug_overlay_ingame)
			debug_option = 1
		}
		if (keyboard_check_released(ord("L"))) {
			logs_overlay = !logs_overlay
			debug_option = 1
		}
		//if (keyboard_check_released(ord("D")) && isplayer) {
		//	if (!dropmode) window_maximize()
		//	//else window_set_size(floor(800 * window_scale), floor(500 * window_scale))
		//	else window_setnormal()
		//	dropmode = !dropmode
		//	debug_option = 1
		//	set_msg("[Debug] Toggle experimental drop mode")
		//}
	}
	if (keyboard_check_released(vk_f3)) debug_option = 0
	
	if (!isplayer) {
		
	if (keyboard_check_pressed(vk_numpad1)) {
		current_song.reference_option = 0; 
		set_msg("Reference mute"); 
		if (audio_is_playing(current_song.reference_sound)) audio_stop_sound(current_song.reference_sound)
	}
	if (keyboard_check_pressed(vk_numpad2)) {
		current_song.reference_option = 1; 
		set_msg("Reference solo"); 
		if (playing) {
			if (current_song.reference_option > 0 && !audio_is_playing(current_song.reference_sound)) {
				current_song.reference_sound = audio_play_sound(current_song.reference_audio, 1, 0)
				audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
				audio_sound_set_track_position(current_song.reference_sound, current_song.marker_pos / current_song.tempo + current_song.reference_offset / 1000)
			}
		}
	}
	if (keyboard_check_pressed(vk_numpad3)) {
		current_song.reference_option = 2; 
		set_msg("Reference mix")
		if (playing) {
			if (current_song.reference_option > 0 && !audio_is_playing(current_song.reference_sound)) {
				current_song.reference_sound = audio_play_sound(current_song.reference_audio, 1, 0)
				audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
				audio_sound_set_track_position(current_song.reference_sound, current_song.marker_pos / current_song.tempo + current_song.reference_offset / 1000)
			}
		}
	}
	
	// Selecting note blocks
	if (select > 0) {
	    curs = cr_handpoint
	    window = 0.1
	    x2 = mouse_x
	    y2 = mouse_y
	    if (current_song.starta = 0) x2 = max(x1 + 2, mouse_x)
	    if (current_song.startb = 0) y2 = max(y1 + 34, mouse_y)
		if (theme != 3) {
			draw_set_color(c_blue)
			if (select = 2) draw_set_color(c_red)
		} else {
			draw_set_color(14120960)
			if (select = 2) draw_set_color(c_red)
		}
	    draw_set_alpha(0.25)
	    draw_rectangle(select_pressx, select_pressy, x2, y2, 0)
	    draw_set_alpha(1)
	    draw_rectangle(select_pressx, select_pressy, x2, y2, 1)
	    draw_theme_color()
	}

	// Timeline and markers
	if (hires && theme = 3) gpu_set_texfilter(false)
	if (!noeditingbackground) draw_sprite_ext(spr_timeline, (0 + theme = 2 + (fdark && theme = 3)) * !blackout + blackout * 2, x1 + 2, y1 + 2, totalcols * 32 + 18, 1, 0, -1, 1)
	else draw_sprite_ext(spr_timeline, 3, x1 + 2, y1 + 2, totalcols * 32 + 18, 1, 0, -1, 1)
	if (hires && theme = 3) gpu_set_texfilter(true)
	draw_theme_font(font_small)
	draw_set_halign(fa_left)
	draw_theme_color()
	if (blackout) draw_set_color(c_white)
	c = 1
	if (current_song.tempo < 3.5) c = 5
	if (current_song.tempo < 1) c = 10
	if (current_song.tempo < 0.5) c = 30
	if (current_song.tempo > 11) c = 0.5
	if (current_song.tempo > 18) c = 0.25
	a = ceil(current_song.starta / (current_song.tempo * c)) * c
	xx = (ceil(current_song.starta / (current_song.tempo * c)) - (current_song.starta / (current_song.tempo * c))) * (32 * current_song.tempo * c)

	while (xx < totalcols * 32 + 16) {
	    if (a > 0) draw_set_halign(fa_center)
	    if (!hires || obj_controller.theme != 3) draw_text(x1 + 2 + xx - note_offset, y1 + 2, time_str(a))
	    else draw_text_transformed(x1 + 2 + xx - note_offset, y1 + 2, time_str(a), 0.25, 0.25, 0)
	    draw_set_alpha(0.6)
	    draw_line(x1 + 2 + xx - note_offset, y1 + 2 + 12, x1 + 2 + xx - note_offset, y1 + 2 + 15)
	    draw_set_alpha(1)
	    draw_set_halign(fa_left)
	    xx += (32 * current_song.tempo) * c
	    a += c
	}

	for (a = 0; a <= totalcols; a += 1) {
	    b = ((current_song.starta + a) mod 4 == 0)
	    draw_set_alpha(0.6)
	    draw_line(x1 + 2 + 32 * a - note_offset, y1 + 33, x1 + 2 + 32 * a - note_offset, y1 + 30 - 3 * b)
	    draw_set_alpha(1)
	    if (b) {
	        if (a > 0) draw_set_halign(fa_center)
	        if (!hires || obj_controller.theme != 3) draw_text(x1 + 2 + 32 * a - note_offset, y1 + 17, string(current_song.starta + a))
	        else draw_text_transformed(x1 + 2 + 32 * a - note_offset, y1 + 17, string(current_song.starta + a), 0.25, 0.25, 0)
	        draw_set_halign(fa_left)
	    }
	}
	}
	// Marker
	if (playing = 0) metronome_played = -1
	if (playing = 1 || forward<>0) {
	    if (playing = 1) current_song.marker_pos += (current_song.tempo / room_speed) * (1 / currspeed)
	    if (forward != 0) {
	        current_song.marker_pos += (current_song.tempo / room_speed) * (1 / currspeed) * (forward - (forward < 0 && playing = 1))
	    }
		//metronome
		if (metronome && !isplayer) {
			if room_speed >= 60 {
			var pos = floor(current_song.marker_pos -0.1)
			} else pos = floor(current_song.marker_pos -0.4)
			if (current_song.tempo = 30) pos -= 1
			// show_debug_message(marker_pos)
			if ((pos mod 4 == 0) && (metronome_played < pos)) {
				if (pos mod (4 * current_song.timesignature) == 0) {
					ins = soundmetronomeclick
					if (!current_song.loop || pos < current_song.enda + 1) { // avoid double ticks when looping
						if (ins.loaded) play_sound(ins, 45, 100, 100, 0)
					}
				} else {
					ins = soundmetronome
					if (ins.loaded) play_sound(ins, 45, 100, 100, 0)
				}
				metronome_played = pos + 1
			}
		}
		//loop song
		if (current_song.loop_session = 1 && current_song.marker_pos > current_song.enda + 1) { // && (!looptobarend || current_song.marker_pos mod (current_song.timesignature * 4) < 1)
			--timestoloop
			current_song.starta = current_song.loopstart
			current_song.marker_pos = current_song.starta
			metronome_played = -1
			sb_val[scrollbarh] = current_song.starta
			if (current_song.loopmax != 0) {
				if (timestoloop < 0) {
					playing = 0
					current_song.marker_pos = 0
					current_song.marker_prevpos = 0
					timestoloop = real(current_song.loopmax)
				}
			} 
		}
	    if (current_song.marker_pos > current_song.enda + totalcols) {
	        current_song.marker_pos = current_song.enda + totalcols
	        playing = 0
	    }
	    if (marker_end && current_song.marker_pos >= current_song.section_end && current_song.marker_prevpos < current_song.section_end) {
	        current_song.marker_pos = current_song.section_end
	        playing = 0
	    }
	    if (marker_follow = 1 || isplayer) {
	        if (marker_pagebypage = 1 && !isplayer) {
	            if (floor(current_song.marker_pos) >= current_song.starta + totalcols - 1 && current_song.starta < current_song.enda) {
	                current_song.starta = current_song.marker_pos - 1
	                current_song.starta = median(0, current_song.starta, current_song.enda)
	                sb_val[scrollbarh] = current_song.starta
	            }
	            if (floor(current_song.marker_pos) < current_song.starta + 1 && forward = -1 && current_song.starta > 0) {
	                current_song.starta = floor(current_song.marker_pos) - totalcols + 1
	                current_song.starta = median(0, current_song.starta, current_song.enda)
	                sb_val[scrollbarh] = current_song.starta
	            }
	        } else {
	            current_song.starta = median(0, current_song.marker_pos - ceil(totalcols / 2) * !isplayer, current_song.enda)
	            sb_val[scrollbarh] = current_song.starta
	        }
	    }
	}
	if (!isplayer) {
	if (window = w_dragmarker) {
	    current_song.marker_pos = (mouse_x - x1 + 2) / 32 + current_song.starta
	    curs = cr_size_we
	    if (!mouse_check_button(mb_left)) {
	        window = w_releasemouse
	    }
	}
	if (window = w_dragselection || window = w_dragsection_start || window = w_dragsection_end || select > 0) {
	    a = current_song.starta
	    b = current_song.startb
	    if (mouse_x > x1 + 2 + 32 * totalcols - 32) {
	        if (refreshrate >= 2) dragincxr += 0.025
	        else dragincxr += 0.1
	        dragincxr = min(dragincxr, 4)
	        current_song.starta += ceil(dragincxr)
	    } else dragincxr = 0
	    if (mouse_x < x1 + 32) {
	        if (refreshrate >= 2) dragincxl += 0.025
	        else dragincxl += 0.1
	        dragincxl = min(dragincxl, 4)
	        current_song.starta -= ceil(dragincxl)
	    } else dragincxl = 0
	    if (mouse_y > y1 + 34 + totalrows * 32) {
	        if (refreshrate >= 2) dragincyd += 0.025
	        else dragincyd += 0.1
	        dragincyd = min(dragincyd, 4)
	        current_song.startb += ceil(dragincyd)
	    } else dragincyd = 0
	    if (mouse_y < y1 + 34 + 32) {
	        if (refreshrate >= 2) dragincyu += 0.025
	        else dragincyu += 0.1
	        dragincyu = min(dragincyu, 4)
	        current_song.startb -= ceil(dragincyu)
	    } else dragincyu = 0
	    current_song.starta = median(0, current_song.starta, current_song.enda)
	    current_song.startb = median(0, current_song.startb, current_song.endb)
	    if (select > 0) {
	        select_pressx += 32 * (a - current_song.starta)
	        select_pressy += 32 * (b - current_song.startb)
	        // select_pressa += (a - starta)
	        // select_pressb += (b - startb)
	    }
	    sb_val[0] = current_song.starta
	    sb_val[1] = current_song.startb
	}
	// Section
	if (window = w_dragsection_start) {
	    current_song.section_start = current_song.starta + round((mouse_x - (x1 + 2)) / 32)
	    if (!mouse_check_button(mb_left)) {
	        window = w_releasemouse
	        if (current_song.section_end = current_song.section_start) current_song.section_exists = 0
	        a = current_song.section_start
	        current_song.section_start = min(current_song.section_start, current_song.section_end)
	        current_song.section_end = max(a, current_song.section_end)
	    }
	}
	if (window = w_dragsection_end) {
	    current_song.section_end = current_song.starta + round((mouse_x - (x1 + 2)) / 32)
	    if (!mouse_check_button(mb_left)) {
	        window = w_releasemouse
	        if (current_song.section_end = current_song.section_start) current_song.section_exists = 0
	        a = current_song.section_start
	        current_song.section_start = min(current_song.section_start, current_song.section_end)
	        current_song.section_end = max(a, current_song.section_end)
	    }
	}
	if (current_song.section_exists) {
	    current_song.section_start = median(0, current_song.section_start, current_song.enda + totalcols)
	    current_song.section_end = median(0, current_song.section_end, current_song.enda + totalcols)
	    draw_set_alpha(0.25)
	    draw_set_color(c_blue)
	    draw_rectangle(x1 + 2 + floor(current_song.section_start - current_song.starta + 0.5) * 32 - note_offset, y1 + 2, x1 + 2 + floor(current_song.section_end - current_song.starta + 0.5) * 32 - note_offset, y1 + 33, 0)
	    draw_theme_color()
	    draw_set_alpha(1)
	    a = floor(current_song.section_start * 32 - current_song.starta * 32 + 0.5)
	    draw_sprite(spr_marker, 2 + (current_song.section_end < current_song.section_start) * 2, x1 + 2 + floor((a / 32) + 0.5) * 32 - note_offset, y1 + 2)
	    draw_sprite_ext(spr_marker, 3 + (current_song.section_end < current_song.section_start) * 2, x1 + 2 + floor((a / 32) + 0.5) * 32 - note_offset, y1 + 2, 1, (totalrows + 1) * 32 / 15, 0, -1, 1)
	    a = floor(current_song.section_end * 32 - current_song.starta * 32 + 0.5)
	    draw_sprite(spr_marker, 4 - (current_song.section_end < current_song.section_start) * 2, x1 + 2 + floor((a / 32) + 0.5) * 32 - note_offset, y1 + 2)
	    draw_sprite_ext(spr_marker, 5 - (current_song.section_end < current_song.section_start) * 2, x1 + 2 + floor((a / 32) + 0.5) * 32 - note_offset, y1 + 2, 1, (totalrows + 1) * 32 / 15, 0, -1, 1)
	}
	}

	current_song.marker_pos = median(0, current_song.marker_pos, current_song.enda + totalcols)
	if (!isplayer) {
	draw_theme_font(font_main)
	var tempo_str;
	var tempo_prefix = "BPM = ";
	var last_tc_x = 0;
	var last_tc_y = 0;
	for (var tempo_index = array_length(tempo_changer_display_queue) - 1; tempo_index >= 0; tempo_index -= 1) {
		xx = tempo_changer_display_queue[tempo_index][0]
		yy = tempo_changer_display_queue[tempo_index][1]
		tempo_str = tempo_changer_display_queue[tempo_index][2]
		if (xx != last_tc_x) last_tc_y = 0
		if (yy > last_tc_y) {
			draw_sprite(spr_marker, 0 + 8 * (theme = 2 || blackout || (theme = 3 && fdark)), xx, y1 + 2)
			draw_sprite(spr_marker, 1 + 8 * (theme = 2 || blackout || (theme = 3 && fdark)), xx, y1 + 2 + 15)
			draw_set_color(c_white)
			if(theme = 2) draw_set_color(3552822)
			if (theme = 3) draw_set_color(16579836)
			if (theme = 3 && fdark) draw_set_color(2960685)
			draw_rectangle(xx + 10, y1 + 4, xx + 10 + string_width_dynamic(tempo_prefix + tempo_str), y1 + 16, 0)
			draw_area(xx + 9, y1 + 3, xx + 11 + string_width_dynamic(tempo_prefix + tempo_str), y1 + 17)
			draw_theme_color()
			draw_text_dynamic(xx + 10, y1 + 2 + (theme != 3), tempo_prefix + tempo_str)
			last_tc_y = yy
		}
		last_tc_x = xx
	}
	a = floor(current_song.marker_pos * 32 - current_song.starta * 32)
	draw_sprite_ext(spr_marker, 0 + 6 * (theme = 2 || (blackout && theme != 3)) + 8 * (theme = 3), x1 + 2 + a, y1 + 2, 1, 1, 0, accent[3] * (theme = 3) - !(theme = 3), 1)
	draw_sprite_ext(spr_marker, 1 + 6 * (theme = 2 || (blackout && theme != 3)) + 8 * (theme = 3), x1 + 2 + a, y1 + 2, 1 + (window_scale <= 0.5), (totalrows + 1) * 32 / 15, 0, accent[3] * (theme = 3) - !(theme = 3), 1)


	draw_theme_font(font_main)
	if (!fullscreen) {
		draw_set_color(15790320)
		if (theme = 1) draw_set_color(13160660)
		if (theme = 2) draw_set_color(c_dark)
		if (theme = 3) draw_set_color(15987699)
		if (theme = 3 && acrylic && wpaperexist && can_draw_mica) draw_set_color(c_white)
		if (theme = 3 && fdark) draw_set_color(2105376)
		if (theme = 3 && fdark && acrylic && wpaperexist && can_draw_mica) draw_set_color(1315860)
		if (theme = 3 && acrylic && wpaperexist && can_draw_mica) draw_set_alpha(0.875)
		if (theme != 3 or !wpapernodim) {
			draw_rectangle(0, y1 + 3, x1 + 1, rh, 0)
			draw_rectangle(0, 0, rw, y1 + 2, 0)
			draw_rectangle(x1 + 2, y1 + totalrows * 32 + 50 - 15 * (current_song.reference_audio >= 0), rw, rh, 0)
			draw_rectangle(x1 + totalcols * 32 + 18, y1 + 3, rw, y1 + totalrows * 32 + 49, 0)
			draw_rectangle(x1 + totalcols * 32 + 2, y1 + totalrows * 32 + 32, x1 + totalcols * 32 + 2 + 17, y1 + totalrows * 32 + 32 + 18, 0)
		}
		draw_area(x1, y1, x1 + totalcols * 32 + 20, y1 + (totalrows + (current_song.reference_audio >= 0)) * 32 + 52)
		draw_set_alpha(1)
	}
	draw_theme_color()

	// Scrollbars
	if (!fullscreen) {
		current_song.starta = draw_scrollbar(scrollbarh, x1, y1 + (totalrows + (current_song.reference_audio >= 0)) * 32 + 34, 32, totalcols - 1, current_song.enda + totalcols - 1, (exist && changepitch) || mousewheel > 0, 0)
		current_song.startb = draw_scrollbar(scrollbarv, x1 + totalcols * 32 + 2, y1 + 34, 32, totalrows - 1 + (current_song.reference_audio >= 0), current_song.endb + totalrows - 1, (exist && changepitch) || mousewheel > 0, 0)
	} else {
		// horizontal rise animation
		if (mouse_rectangle(0, rh - 25, rw, rh)) {
			if (window = 0 && sbh_anim < 16) sbh_anim += (2 * 30 / room_speed) * (1 / currspeed)
		} else if (sb_drag = -1) {
			if (sbh_anim > 0) sbh_anim -= (2 * 30 / room_speed) * (1 / currspeed)
		}
		// vertical rise animation
		if (mouse_rectangle(rw - 25, 0, rw, rh)) {
			if (window = 0 && sbv_anim < 16) sbv_anim += (2 * 30 / room_speed) * (1 / currspeed)
		} else if (sb_drag = -1) {
			if (sbv_anim > 0) sbv_anim -= (2 * 30 / room_speed) * (1 / currspeed)
		}
		current_song.starta = draw_scrollbar(scrollbarh, 0, rh - sbh_anim, 32, ((rw - 16) / 32) - 1, current_song.enda + totalcols - 2, (exist && changepitch) || mousewheel > 0, 0)
		current_song.startb = draw_scrollbar(scrollbarv, rw - sbv_anim, rhval, 32, ((rh - rhval - 16) / 32) - 1, current_song.endb + totalrows - 2, (exist && changepitch) || mousewheel > 0, 0)
		// the fifth parameters are totalrows & totalcols before rounding: ((rh - rhval) / 32), ((rw - 8) / 32)
		// this is so it stretches to fill the whole width/height of the screen instead of clipping to the note block area size
	}
	// Fullscreen button
	if (fullscreen) {
		xx = rw - sbv_anim
		yy = rh - 16
	} else {
		xx = x1 + totalcols * 32
		yy = y1 + (totalrows + (current_song.reference_audio >= 0)) * 32 + 34
	}
	if (theme = 0) draw_set_color(15790320)
	if (theme = 1) draw_set_color(13160660)
	if (theme = 2) draw_set_color(c_dark)
	if (theme = 3) draw_set_color(15987699)
	if (theme = 3 && fdark) draw_set_color(2105376)
	draw_rectangle(xx, yy, xx + 16, yy + 16, false)
	if (language != 1) {
	if (draw_layericon(7 + fullscreen, xx, yy, condstr(!fullscreen, "Expand workspace", "Return"), 0, 0)) {
		fullscreen = !fullscreen
		if (fullscreen) set_msg("Fullscreen => ON")
		else set_msg("Fullscreen => OFF")
		dontplace = 1
	}
	} else {
	if (draw_layericon(7 + fullscreen, xx, yy, condstr(!fullscreen, "展开编辑区域", "返回"), 0, 0)) {
		fullscreen = !fullscreen
		if (fullscreen) set_msg("全屏模式 => ON")
		else set_msg("全屏模式 => OFF")
		dontplace = 1
	}
	}
	draw_theme_color()

	// Draw layers
	for (b = 0; b < totalrows; b += 1) {
		if (current_song.startb + b >= current_song.endb2) {
		    current_song.layername[current_song.startb + b] = ""
		    current_song.layerlock[current_song.startb + b] = 0
		    current_song.layervol[current_song.startb + b] = 100
			current_song.layerstereo[current_song.startb + b] = 100
		    current_song.rowamount[current_song.startb + b] = 0
		    current_song.endb2 = current_song.startb + b + 1
		}
		x1 = 4
		y1 = 54 + 32 + b * 32 - 1 + song_tab_offset
		if (!fullscreen && show_layers) {
			// Name
			m = mouse_rectangle(x1 + 10, y1 + 10, 75, 13)
		    draw_sprite(spr_layerbox, 0 + (theme = 2) + (2 + fdark) * (theme = 3), x1, y1)
			if (window = 0) {
				if (language != 1) popup_set(x1 + 10, y1 + 10, 75, 13, "The name for this layer")
				else popup_set(x1 + 10, y1 + 10, 75, 13, "本层名称")
			}
			draw_theme_font(font_small)
			prev = current_song.layername[current_song.startb + b]
			if (theme != 3) {
			current_song.layername[current_song.startb + b] = draw_text_edit(400 + current_song.startb + b, current_song.layername[current_song.startb + b], x1 + 11, y1 + 10, 72, 14, 1, 0)
			} else {
			if (language != 1) current_song.layername[current_song.startb + b] = draw_textarea(400 + current_song.startb + b, x1 + 9, y1 + 4, 72, 24, string(current_song.layername[current_song.startb + b]), "The name of this layer.", 3, (0.3 + 0.3 * !fdark) * (acrylic && wpaperexist && can_draw_mica) + (!acrylic || !wpaperexist || !can_draw_mica), 1)
			else current_song.layername[current_song.startb + b] = draw_textarea(400 + current_song.startb + b, x1 + 9, y1 + 4, 72, 24, string(current_song.layername[current_song.startb + b]), "本层的名称。", 3, (0.3 + 0.3 * !fdark) * (acrylic && wpaperexist && can_draw_mica) + (!acrylic || !wpaperexist || !can_draw_mica), 1)
			}
			if (current_song.layername[current_song.startb + b] = "") {
		        draw_set_color(c_gray)
				if(theme = 2 || (fdark && theme = 3)) draw_set_color(make_color_rgb(160, 160, 160))
		        if (language != 1) draw_text_dynamic(x1 + 11, y1 + 10, "Layer " + string(current_song.startb + b + 1))
		        else draw_text_dynamic(x1 + 11, y1 + 10, "第 " + string(current_song.startb + b + 1) + " 层")
		    }
			if (prev != current_song.layername[current_song.startb + b]) current_song.changed = 1
		    draw_theme_color()
		    // Vol
		    if (realvolume) {
		        c = ((dragvolb = current_song.startb + b && window = w_dragvol) || (mouse_rectangle(x1 + 88, y1 + 5, 16, 25) && window = 0))
		        if (current_song.startb + b >= current_song.endb2) {
		            a = 100
		        } else {
		            a = current_song.layervol[current_song.startb + b]
		        }
				if(theme != 3) {
		        draw_sprite_ext(spr_volume, a / 30, x1 + 91, y1 + 11 - c * 5, 1, 1, 0, iconcolor, 0.7)
				} else {
				if (!hires || theme != 3) {
					draw_sprite_ext(spr_volume_f, !fdark, x1 + 91, y1 + 11 - c * 5, 1, 1, 0, iconcolor, 1)
					draw_sprite_ext(spr_volume_f, a / 30 + 2, x1 + 91, y1 + 11 - c * 5, 1, 1, 0, accent[6 - 2 * !fdark], 1)
				} else {
					draw_sprite_ext(spr_volume_f_hires, !fdark, x1 + 91, y1 + 11 - c * 5, 0.25, 0.25, 0, iconcolor, 1)
					draw_sprite_ext(spr_volume_f_hires, a / 30 + 2, x1 + 91, y1 + 11 - c * 5, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
				}
				}
		        if (language != 1) popup_set(x1 + 90, y1 + 5, 12, 17, "Volume of this layer: " + string(a) + "%\n(Click and drag to change)")
		        else popup_set(x1 + 90, y1 + 5, 12, 17, "本层的音量: " + string(a) + "%\n（拖拽来修改）")
		        if (c) {
		        draw_theme_font(font_small)
		            draw_set_halign(fa_center)
		            draw_text_dynamic(x1 + 98, y1 + 18, string(a) + "%")
		            draw_set_halign(fa_left)
		            draw_theme_font(font_main)
		            curs = cr_size_ns
		            if (mouse_check_button_pressed(mb_left)) {
		                window = w_dragvol
		                dragvolb = current_song.startb + b
		                dragvol = current_song.layervol[current_song.startb + b]
		            }
		        }
		    }
			// Stereo
		    if (!realstereo) {
		        c = ((dragstereob = current_song.startb + b && window = w_dragstereo) || (mouse_rectangle(x1 + 108, y1 + 5, 16, 25) && window = 0))
		        if (current_song.startb + b >= current_song.endb2) {
		            a = 100
		        } else {
		            a = current_song.layerstereo[current_song.startb + b]
		        }
				if (theme != 3) {
		        draw_sprite_ext(spr_stereo, a / 50, x1 + 110, y1 + 11 - c * 5, 1, 1, 0, iconcolor, 0.7)
				} else {
				if (!hires || theme != 3) {
					draw_sprite_ext(spr_stereo_f, !fdark, x1 + 110, y1 + 11 - c * 5, 1, 1, 0, iconcolor, 1)
					draw_sprite_ext(spr_stereo_f, a / 50 + 2, x1 + 110, y1 + 11 - c * 5, 1, 1, 0, accent[6 - 2 * !fdark], 1)
				} else {
					draw_sprite_ext(spr_stereo_f_hires, !fdark, x1 + 110, y1 + 11 - c * 5, 0.25, 0.25, 0, iconcolor, 1)
					draw_sprite_ext(spr_stereo_f_hires, a / 50 + 2, x1 + 110, y1 + 11 - c * 5, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
				}
				}
				var stereostr
				if (a > 100) { stereostr = "R " + string(a-100) }
				if (a = 100) { stereostr = condstr(language != 1, "Center", "中央") }
				if (a < 100) { stereostr = "L " + string(-(a-100)) }
		        if (language != 1) popup_set(x1 + 110, y1 + 5, 12, 17, "Stereo pan: " + stereostr + "\n(Click and drag to change)")
		        else popup_set(x1 + 110, y1 + 5, 12, 17, "立体声声道: " + stereostr + "\n（拖拽来修改）")
		        if (c) {
		            draw_theme_font(font_small)
		            draw_set_halign(fa_center)
					if a > 100 {draw_text_dynamic(x1 + 116, y1 + 18, "R " + string(a-100))}
					if a = 100 {draw_text_dynamic(x1 + 116, y1 + 18, condstr(language != 1, "MONO", "单声道"))}
					if a < 100 {draw_text_dynamic(x1 + 116, y1 + 18, "L " + string((a-100)*-1))	}
		            draw_set_halign(fa_left)
		            draw_theme_font(font_small)
		            curs = cr_size_ns
		            if (mouse_check_button_pressed(mb_left)) {
		                window = w_dragstereo
		                dragstereob = current_song.startb + b
		                dragstereo = current_song.layerstereo[current_song.startb + b]
		            }
		        }
			}
		    // Lock button
		    p = 0
		    if (current_song.startb + b < current_song.endb2) p = (current_song.layerlock[current_song.startb + b] = 1)
		    if (draw_layericon(0, x1 + 126-!realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Lock this layer", "静音本层"), 0, p)) {
		        if (current_song.layerlock[current_song.startb + b] = 2) current_song.solostr = string_replace_all(current_song.solostr, "|" + string(current_song.startb + b) + "|", "")
		        if (current_song.layerlock[current_song.startb + b] = 1) {current_song.layerlock[current_song.startb + b] = 0} else {current_song.layerlock[current_song.startb + b] = 1}
				current_song.changed = 1
		    }
		    // Solo button
		    p = 0
		    if (current_song.startb + b < current_song.endb2) p = (current_song.layerlock[current_song.startb + b] = 2)
		    if (draw_layericon(1, x1 + 144 - !realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Solo this layer", "独奏本层"), 0, p)) {
		        if (current_song.layerlock[current_song.startb + b] = 2) {
		            current_song.layerlock[current_song.startb + b] = 0
		            current_song.solostr = string_replace_all(current_song.solostr, "|" + string(current_song.startb + b) + "|", "")
		        } else {
		            current_song.layerlock[current_song.startb + b] = 2
		            current_song.solostr += "|" + string(current_song.startb + b) + "|"
		        }
				current_song.changed = 1
		    }
			// Select all
		    if (draw_layericon(2, x1 + 162 - !realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Select all note blocks in this layer\n(Click and drag to select multiple; click again to deselect)", "选择本层所有方块\n（拖拽可批量选择，再次点选取消选择）"), 0, 0)) {
		        playing = 0
				
				// TODO: replace with array_contains() if we ever upgrade GameMaker...
				var layer_id = current_song.startb + b
				var layer_selected = ds_list_find_index(current_song.selected_layers, layer_id) > -1
				if (layer_selected) {
					selection_remove(0, current_song.startb + b, current_song.enda, current_song.startb + b, 0, 0)
					ds_list_delete_value(current_song.selected_layers, layer_id)
				} else {
					selection_add(0, current_song.startb + b, current_song.enda, current_song.startb + b, 0, 0)
					ds_list_add(current_song.selected_layers, layer_id)
				}
			}
			// Add layer
		    if (draw_layericon(3, x1 + 180 - !realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Add empty layer here\n(Click and drag to add multiple layers)", "新建层\n（拖拽可批量添加）"), 0, 0)) {
		        playing = 0
				add_layer(current_song.startb + b, false)
		    }
			// Remove layer
			if (draw_layericon(4, x1 + 198 - !realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Remove this layer\n(Click and drag to remove multiple layers)", "删除层\n（拖拽可批量删除）"), 0, 0)) {
		        playing = 0
				remove_layer(current_song.startb + b, false)
			}
			// Shift layer up
			if ((current_song.startb + b > 0) && draw_layericon(5, x1 + 216 - !realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Shift layer up\n(Click and drag to shift multiple layers)", "上移本层\n（拖拽可上移多层）"), 0, 0)) {
			    playing = 0
				shift_layers(current_song.startb + b, current_song.startb + b - 1, false)
			}
			// Shift layer down
			if (draw_layericon(6, x1 + 234 - !realvolume-realstereo * 10 - (current_song.startb + b = 0) * 8, y1 + 8, condstr(language != 1, "Shift layer down\n(Click and drag to shift multiple layers)", "下移本层\n（拖拽可下移多层）"), 0, 0)) {
			    playing = 0
				shift_layers(current_song.startb + b, current_song.startb + b + 1, false)
			}
		}
	}
	if (current_song.reference_audio >= 0 && !fullscreen && show_layers) {
		b = totalrows
		x1 = 4
		y1 = 54 + 32 + b * 32 - 1 + song_tab_offset
		draw_sprite(spr_layerbox, 0 + (theme = 2) + (2 + fdark) * (theme = 3), x1, y1)
		draw_theme_color()
		draw_line(x1 + 262, y1, x1 + 262 + totalcols * 32, y1)
		// Name
		m = mouse_rectangle(x1 + 10, y1 + 10, 75, 13)
		draw_theme_color()
		if (language != 1) draw_text_dynamic(x1 + 11, y1 + 10, "Reference")
		else draw_text_dynamic(x1 + 11, y1 + 10, "参考音频")
		draw_theme_color()
		// Vol
		c = ((dragvolb = -2 && window = w_dragvol) || (mouse_rectangle(x1 + 88, y1 + 5, 16, 25) && window = 0))
		a = current_song.reference_volume
		if(theme != 3) {
		draw_sprite_ext(spr_volume, a / 30, x1 + 91, y1 + 11 - c * 5, 1, 1, 0, iconcolor, 0.7)
		} else {
		if (!hires || theme != 3) {
			draw_sprite_ext(spr_volume_f, !fdark, x1 + 91, y1 + 11 - c * 5, 1, 1, 0, iconcolor, 1)
			draw_sprite_ext(spr_volume_f, a / 30 + 2, x1 + 91, y1 + 11 - c * 5, 1, 1, 0, accent[6 - 2 * !fdark], 1)
		} else {
			draw_sprite_ext(spr_volume_f_hires, !fdark, x1 + 91, y1 + 11 - c * 5, 0.25, 0.25, 0, iconcolor, 1)
			draw_sprite_ext(spr_volume_f_hires, a / 30 + 2, x1 + 91, y1 + 11 - c * 5, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
		}
		}
		if (language != 1) popup_set(x1 + 90, y1 + 5, 12, 17, "Volume of reference audio: " + string(a) + "%\n(Click and drag to change)")
		else popup_set(x1 + 90, y1 + 5, 12, 17, "参考音频的音量: " + string(a) + "%\n（拖拽来修改）")
		if (c) {
		draw_theme_font(font_small)
		    draw_set_halign(fa_center)
		    draw_text_dynamic(x1 + 98, y1 + 18, string(a) + "%")
		    draw_set_halign(fa_left)
		    draw_theme_font(font_main)
		    curs = cr_size_ns
		    if (mouse_check_button_pressed(mb_left)) {
		        window = w_dragvol
		        dragvolb = -2
		        dragvol = current_song.reference_volume
		    }
		}
		// Stereo
		c = ((dragstereob = -2 && window = w_dragstereo) || (mouse_rectangle(x1 + 108, y1 + 5, 16, 25) && window = 0))
		a = current_song.reference_offset
		if (theme != 3) {
		draw_sprite_ext(spr_stereo, (median(-2000, a, 2000) + 500) / 1000 + 2, x1 + 110, y1 + 11 - c * 5, 1, 1, 0, iconcolor, 0.7)
		} else {
		if (!hires || theme != 3) {
			draw_sprite_ext(spr_stereo_f, !fdark, x1 + 110, y1 + 11 - c * 5, 1, 1, 0, iconcolor, 1)
			draw_sprite_ext(spr_stereo_f, (median(-2000, a, 2000) + 500) / 1000 + 4, x1 + 110, y1 + 11 - c * 5, 1, 1, 0, accent[6 - 2 * !fdark], 1)
		} else {
			draw_sprite_ext(spr_stereo_f_hires, !fdark, x1 + 110, y1 + 11 - c * 5, 0.25, 0.25, 0, iconcolor, 1)
			draw_sprite_ext(spr_stereo_f_hires, (median(-2000, a, 2000) + 500) / 1000 + 4, x1 + 110, y1 + 11 - c * 5, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
		}
		}
		var stereostr = string(a)
		if (language != 1) popup_set(x1 + 110, y1 + 5, 12, 17, "Reference offset: " + stereostr + " ms\n(Click and drag to change)")
		else popup_set(x1 + 110, y1 + 5, 12, 17, "参考音频偏移: " + stereostr + " 毫秒\n（拖拽来修改）")
		if (c) {
		    draw_theme_font(font_small)
		    draw_set_halign(fa_center)
			draw_text_dynamic(x1 + 116, y1 + 18, string(a) + " ms")
		    draw_set_halign(fa_left)
		    draw_theme_font(font_small)
		    curs = cr_size_ns
		    if (mouse_check_button_pressed(mb_left)) {
		        window = w_dragstereo
		        dragstereob = -2
		        dragstereo = current_song.reference_offset
		    }
		}
		// Lock button
		p = (current_song.reference_option = 0)
		if (draw_layericon(0, x1 + 126 - !realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Mute reference audio", "静音参考音频"), 0, p)) {
		    if (p) {
				current_song.reference_option = 2; 
				if (playing) {
					if (current_song.reference_option > 0 && !audio_is_playing(current_song.reference_sound)) {
						current_song.reference_sound = audio_play_sound(current_song.reference_audio, 1, 0)
						audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
						audio_sound_set_track_position(current_song.reference_sound, current_song.marker_pos / current_song.tempo + current_song.reference_offset / 1000)
					}
				}
		    } else {
				current_song.reference_option = 0; 
				if (audio_is_playing(current_song.reference_sound)) audio_stop_sound(current_song.reference_sound)
		    }
		}
		// Solo button
		p = (current_song.reference_option = 1)
		if (draw_layericon(1, x1 + 144 - !realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Solo reference audio", "独奏参考音频"), 0, p)) {
		    if (p) {
				current_song.reference_option = 2; 
				if (playing) {
					if (current_song.reference_option > 0 && !audio_is_playing(current_song.reference_sound)) {
						current_song.reference_sound = audio_play_sound(current_song.reference_audio, 1, 0)
						audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
						audio_sound_set_track_position(current_song.reference_sound, current_song.marker_pos / current_song.tempo + current_song.reference_offset / 1000)
					}
				}
		    } else {
				current_song.reference_option = 1; 
				if (playing) {
					if (current_song.reference_option > 0 && !audio_is_playing(current_song.reference_sound)) {
						current_song.reference_sound = audio_play_sound(current_song.reference_audio, 1, 0)
						audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
						audio_sound_set_track_position(current_song.reference_sound, current_song.marker_pos / current_song.tempo + current_song.reference_offset / 1000)
					}
				}
		    }
		}
		// Remove layer
		if (draw_layericon(4, x1 + 162 - !realvolume-realstereo * 10, y1 + 8, condstr(language != 1, "Remove reference audio\n(Click and drag to remove multiple layers)", "删除参考音频\n（拖拽可批量删除层）"), 0, 0)) {
		    playing = 0
			current_song.reference_option = 0; 
			if (audio_is_playing(current_song.reference_sound)) audio_stop_sound(current_song.reference_sound)
			audio_destroy_stream(current_song.reference_audio)
			current_song.reference_audio_file = ""
			current_song.reference_audio = -1
			current_song.reference_option = 2
			current_song.reference_offset = 0
			current_song.reference_sound = -1
			current_song.reference_volume = 100
		}
		draw_theme_color()
		draw_theme_font(font_main)
		draw_text_dynamic(x1 + 275, y1 + 10, condstr(language != 1, "Loaded file: ", "已加载音频: ") + current_song.reference_audio_file)
	}
	if (window = w_dragvol) {
		if (dragvolb != -2) {
			prev = current_song.layervol[dragvolb]
			dragvol += (mouse_yprev - mouse_y)
			dragvol = median(0, dragvol, 100)
			if (!keyboard_check(vk_shift)) {
				current_song.layervol[dragvolb] = floor(dragvol / 10) * 10
			} else {
				current_song.layervol[dragvolb] = dragvol
			}
			if (current_song.layervol[dragvolb] != prev) current_song.changed = 1
			if (!mouse_check_button(mb_left)) {
			    window = w_releasemouse
			}
		} else {
			dragvol += (mouse_yprev - mouse_y)
			dragvol = median(0, dragvol, 100)
			if (!keyboard_check(vk_shift)) {
				current_song.reference_volume = floor(dragvol / 10) * 10
			} else {
				current_song.reference_volume = dragvol
			}
			if (audio_is_playing(current_song.reference_audio)) audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
			if (!mouse_check_button(mb_left)) {
			    window = w_releasemouse
			}
		}
	}
	if (window = w_dragstereo) {
		if (dragstereob != -2) {
			prev = current_song.layerstereo[dragstereob]
			dragstereo += (mouse_yprev - mouse_y)
			dragstereo = median(0, dragstereo, 200)
			if (!keyboard_check(vk_shift)) {
				current_song.layerstereo[dragstereob] = floor(dragstereo / 10) * 10
			} else {
				current_song.layerstereo[dragstereob] = dragstereo
			}
			if (current_song.layerstereo[dragstereob] != prev) current_song.changed = 1
			if (!mouse_check_button(mb_left)) {
			    window = w_releasemouse
			}
		} else {
			dragstereo += (mouse_yprev - mouse_y)
			current_song.reference_offset = dragstereo
			if (!mouse_check_button(mb_left)) {
			    window = w_releasemouse
			}
		}
	}
	// Macro Bar
	if (current_song.selected != 0 && show_piano) {
		if (theme != 3) {
			if (show_layers) {
				draw_sprite_ext(spr_iconbar, 0, x1, y1+32,1, 1.3, 0, -1, 1)
				draw_sprite_ext(spr_iconbar, 1, x1, y1+32, 258, 1.3, 0, -1, 1)
				draw_sprite_ext(spr_iconbar, 2, 258, y1+32, 1, 1.3, 0, -1, 1)
			} else {
				draw_sprite_ext(spr_iconbar, 0, x1, y1+52 ,1, 0.75, 0, -1, 1)
				draw_sprite_ext(spr_iconbar, 1, x1, y1+52, 383, 0.75, 0, -1, 1)
				draw_sprite_ext(spr_iconbar, 2, 383, y1+52, 1, 0.75, 0, -1, 1)
			}
		} else {
			draw_set_color(make_color_rgb(70, 70, 70))
			if (show_layers) draw_roundrect(x1, y1 + 32, x1 + 255, y1 + 32 + 38, 1)
			else draw_roundrect(x1, y1 + 52, x1 + 380, y1 + 52 + 21, 1)
		}
		xx = x1 + 6
		var yy = y1+37
		if (!show_layers) yy += 18
		if (draw_macroicon(0, xx, yy, "Tremolo...", 0, 0)) {playing = 0 window = w_tremolo} xx += 25
		if (draw_macroicon(1, xx, yy, "Stereo...", 0, 0)) {playing = 0 window = w_stereo} xx += 25
		if (draw_macroicon(2, xx, yy, "Arpeggio...", 0, 0)) {playing = 0 window = w_arpeggio} xx += 25
		if (draw_macroicon(3, xx, yy, "Portamento...", 0, 0)) {playing = 0 window = w_portamento} xx += 25
		if (draw_macroicon(4, xx, yy, "Vibrato", 0, 0)) {playing = 0 macro_vibrato()} xx += 25
		if (draw_macroicon(5, xx, yy, "Stagger...", 0, 0)) {playing = 0 window = w_stagger} xx += 25
		if (draw_macroicon(6, xx, yy, "Chorus", 0, 0)) {playing = 0 macro_chorus()} xx += 25
		if (draw_macroicon(7, xx, yy, "Volume LFO", 0, 0)) {playing = 0 macro_velocitylfo()} xx += 25
		if (language != 1) {
			if (draw_macroicon(8, xx, yy, "Fade in", 0, 0)) {playing = 0 macro_fadein()} xx += 25
			if (draw_macroicon(9, xx, yy, "Fade out", 0, 0)) {playing = 0 macro_fadeout()} xx += 25
			if (show_layers) {
				xx = x1 + 6
				yy += 16
			}
			if (draw_macroicon(10, xx, yy, "Replace key", 0, 0)) {playing = 0 macro_replacekey()} xx += 25
			if (draw_macroicon(11, xx, yy, "Set velocity...", 0, 0)) {playing = 0 window = w_setvelocity} xx += 25
			if (draw_macroicon(12, xx, yy, "Set panning...", 0, 0)) {playing = 0 window = w_setpanning} xx += 25
			if (draw_macroicon(13, xx, yy, "Set pitch...", 0, 0)) {playing = 0 window = w_setpitch} xx += 25
			if (draw_macroicon(14, xx, yy, "Reset all properties", 0, 0)) {playing = 0 macro_reset()} xx += 25
		} else {
			if (draw_macroicon(8, xx, yy, "淡入", 0, 0)) {playing = 0 macro_fadein()} xx += 25
			if (draw_macroicon(9, xx, yy, "淡出", 0, 0)) {playing = 0 macro_fadeout()} xx += 25
			if (show_layers) {
				xx = x1 + 6
				yy += 16
			}
			if (draw_macroicon(10, xx, yy, "替换音", 0, 0)) {playing = 0 macro_replacekey()} xx += 25
			if (draw_macroicon(11, xx, yy, "设定音量......", 0, 0)) {playing = 0 window = w_setvelocity} xx += 25
			if (draw_macroicon(12, xx, yy, "设定声道......", 0, 0)) {playing = 0 window = w_setpanning} xx += 25
			if (draw_macroicon(13, xx, yy, "设定音高......", 0, 0)) {playing = 0 window = w_setpitch} xx += 25
			if (draw_macroicon(14, xx, yy, "重置所有属性", 0, 0)) {playing = 0 macro_reset()} xx += 25
		}
	}
	} //from the if (!isplayer) up there
	
	if (dropmode && theme = 3) {
		draw_set_color(0)
		draw_set_alpha(0.2 * dropalpha)
		draw_roundrect_ext(0, 0, 530, 90, 20, 20, 0)
		draw_set_alpha(dropalpha)
	}

	// Tabs
	if (!fullscreen) {
		if (theme = 0 && !(isplayer && blackout)) draw_sprite_ext(spr_tabbar, 0, 0, 0, rw, 1, 0, -1, 1)
		tab_x = 1
		draw_theme_font(font_small)
		draw_theme_color()
		if (isplayer && blackout) draw_set_color(c_white)
		if (language != 1) {
			if (draw_tab("File")) {
			    str = ""
			    for (b = 0; b < 11; b += 1) {
			        if (recent_song[b] = "") break
			        c = floor(date_second_span(recent_song_time[b], date_current_datetime()))
			        str += seconds_to_str(c) + "$" + string_truncate(clean(filename_name(recent_song[b])), 310) + "|"
			    }
			    if (!isplayer) show_menu_ext("file", 0, 19, icon(icons.NEW)+get_hotkey("new_song") + "$New song|"+
			                             icon(icons.OPEN)+get_hotkey("open_song") + "$Open song...|Recent songs...|\\|" + str + condstr(recent_song[0] != "", "-|Clear recent songs") + condstr(recent_song[0] = "", "^!No recent songs") + "|/|-|"+
			                             icon(icons.SAVE)+get_hotkey("save_song") + "$Save song|"+
			                             icon(icons.SAVE_AS)+"Save song as a new file...|"+
										 "Save options...|Restore unsaved files...|-|"+
										 "Import...|\\|" + 
											inactive(current_song.selected != 0)+"Pattern...|"+
											"MIDI...|"+
											inactive(os_type != os_windows)+"Schematic...|"+
											"Reference audio...|Background image...|/|"+
										 "Export...|\\|" +
											inactive(current_song.totalblocks = 0 || ds_list_size(current_song.instrument_list) <= first_custom_index) + icon(icons.INSTRUMENTS) + "Song with custom sounds...|" +
											inactive(current_song.selected = 0)+"Pattern...|" +
											inactive(current_song.totalblocks = 0 || os_type != os_windows) + "Audio track...|"+
											inactive(current_song.totalblocks = 0) + "Schematic...|"+
											inactive(current_song.totalblocks = 0) + "Track schematic...|"+
											inactive(current_song.totalblocks = 0 || os_type != os_windows) + "Branch schematic...|"+
											inactive(current_song.totalblocks = 0) + "Data pack...|/|-|" + 
			                             get_hotkey("exit") + "$Exit")
				else show_menu_ext("filep", 0, 19, icon(icons.OPEN)+get_hotkey("open_song") + "$Open song...|Recent songs...|\\|" + str + condstr(recent_song[0] != "", "-|Clear recent songs") + condstr(recent_song[0] = "", "^!No recent songs") + "|/|-|"+"Import from MIDI...|Import from schematic...|-|" + get_hotkey("exit") + "$Exit")
							
			}
			if (!isplayer) if (draw_tab("Edit")) {
			    str = ""
			    customstr = ""
				insmenu = 1
			    for (a = 0; a < ds_list_size(current_song.instrument_list); a += 1) {
			        var ins = current_song.instrument_list[| a];
			        if (ins.user)
			            customstr += "...to " + clean(ins.name) + "|"
			        else
			            str += "...to " + clean(ins.name) + "|"
					if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
						customstr += "-|More...|\\|"
						insmenu++
					}
			    }
			    show_menu_ext("edit", 29, 19, inactive(current_song.historypos = current_song.historylen) + icon(icons.UNDO - (current_song.historypos = current_song.historylen)) + get_hotkey("undo") + "$Undo|"+
			                              inactive(current_song.historypos = 0) + icon(icons.REDO - (current_song.historypos = 0)) + get_hotkey("redo") + "$Redo|-|"+
			                              inactive(current_song.selected = 0) + icon(icons.COPY - (current_song.selected = 0)) + get_hotkey("copy") + "$Copy|"+
			                              inactive(current_song.selected = 0) + icon(icons.CUT - (current_song.selected = 0)) + get_hotkey("cut") + "$Cut|"+
			                              inactive(selection_copied = "") + icon(icons.PASTE - (selection_copied = "")) + get_hotkey("paste") + "$Paste|"+
			                              inactive(current_song.selected = 0) + icon(icons.DELETE - (current_song.selected = 0)) + get_hotkey("delete") + "$Delete|-|"+
			                              inactive(current_song.totalblocks = 0) + get_hotkey("select_all") + "$Select all|"+
			                              inactive(current_song.selected = 0) + "Deselect all|"+
			                              inactive(current_song.selected = 0 && current_song.totalblocks = 0) + get_hotkey("invert_selection") + "$Invert selection|-|"+
			                              inactive(current_song.instrument.num_blocks = 0) + "Select all " + clean(current_song.instrument.name) + "|"+
			                              inactive(current_song.instrument.num_blocks = current_song.totalblocks) + "Select all but " + clean(current_song.instrument.name) + "|-|"+
			                                inactive(current_song.selected = 0) + get_hotkey("action_1") + "$" + get_mode_actions(1) + "|"+
			                                inactive(current_song.selected = 0) + get_hotkey("action_2") + "$" + get_mode_actions(2) + "|"+
			                                inactive(current_song.selected = 0) + get_hotkey("action_3") + "$" + get_mode_actions(3) + "|"+
			                                inactive(current_song.selected = 0) + get_hotkey("action_4") + "$" + get_mode_actions(4) + "|"+
													condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey("action_5") + "$" + get_mode_actions(5) + "|") +
													condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey("action_6") + "$" + get_mode_actions(6) + "|") +
			                                inactive(current_song.selected = 0) + "Change instrument...|\\|" + str + condstr(customstr != "", "-|") + customstr + string_repeat("/|", insmenu) + "-|" +
			                                inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Expand selection|"+
			                                inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Compress selection|"+
			                                inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Macros...|\\||"+ "Tremolo...|"+ "Stereo...|"+ "Arpeggio...|"+ "Portamento...|"+ "Vibrato|"+ "Stagger...|"+ "Chorus|"+ "Volume LFO|"+ "Fade in|"+ "Fade out|"+ "Replace key|"+ "Set velocity...|"+ "Set panning...|"+ "Set pitch...|"+ "Reset all properties|"+ "/|-|"+
			                                inactive(current_song.selected = 0) + "Transpose notes outside octave range")
			}
			if (draw_tab("Settings")) {
			    str = ""
			    customstr = ""
				insmenu = 1
			    for (a = 0; a < ds_list_size(current_song.instrument_list); a++) {
			        var ins = current_song.instrument_list[| a];
			        if (ins.user)
			            customstr += check(current_song.instrument = ins) + clean(ins.name) + "|"
			        else{
						if(a < 9){
							 str += check(current_song.instrument = ins) + get_hotkey("ins_ctrl") + string((a + 1) % 10) + "$" + clean(ins.name) + "|"
						}else{
						  str += check(current_song.instrument = ins) + get_hotkey("ins_ctrl_shift") + string((a + 2) % 10) + "$" + clean(ins.name) + "|"
						}
					}
					if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
						customstr += "-|More...|\\|"
						insmenu++
					}
			    }
			    if (!isplayer) show_menu_ext("settings", 59, 19, "Instrument|\\|" + str + condstr(customstr != "", "-|") + customstr + string_repeat("/|", insmenu) +
			                        icon(icons.INSTRUMENTS)+"Instrument settings...|Import sounds from Minecraft...|/|-|" + icon(icons.INFORMATION) + "Song info...|" + icon(icons.PROPERTIES) + "Song properties...|Song stats...|-|" + icon(icons.MIDI_INPUT) + "MIDI device manager|" + get_hotkey("preferences") + "$Preferences...")
				else show_menu_ext("settingsp", 29, 19, icon(icons.INFORMATION) + "Song info...|" + "Song stats...|-|" + get_hotkey("preferences") + "$Preferences...")
			}
			if (draw_tab("Help")) {
			    show_menu_ext("help", 109 - 30 * isplayer, 19, icon(icons.HELP) + "Tutorial videos|\\|Part 1: Composing note block music|Part 2: Opening MIDI files|Part 3: Importing songs into Minecraft|Part 4: Editing songs made in Minecraft     |-|F1$View all|/|-|" + icon(icons.INTERNET) + "Website...|GitHub...|Discord server...|Report a bug...|Donate...|-|Changelist...|About...")
			}
		} else {
			if (draw_tab("文件")) {
			    str = ""
			    for (b = 0; b < 11; b += 1) {
			        if (recent_song[b] = "") break
			        c = floor(date_second_span(recent_song_time[b], date_current_datetime()))
			        str += seconds_to_str(c) + "$" + string_truncate(clean(filename_name(recent_song[b])), 310) + "|"
			    }
			    if (!isplayer) show_menu_ext("file", 0, 19, icon(icons.NEW)+get_hotkey("new_song") + "$新文件|"+
			                             icon(icons.OPEN)+get_hotkey("open_song") + "$打开歌曲......|最近歌曲......|\\|" + str + condstr(recent_song[0] != "", "-|清除最近歌曲") + condstr(recent_song[0] = "", "^!无最近歌曲") + "|/|-|"+
			                             icon(icons.SAVE)+get_hotkey("save_song") + "$保存歌曲|"+
			                             icon(icons.SAVE_AS)+"另存为|"+
										 "保存选项......|恢复未保存的歌曲......|-|" +
										 "导入......|\\|"+
											inactive(current_song.selected != 0)+"片段......|"+
											"MIDI 文件......|"+
											inactive(os_type != os_windows)+"Schematic 文件......|"+
											"参考音频......|背景图片......|/|"+
										 "导出......|\\|"+
											inactive(current_song.totalblocks = 0 || ds_list_size(current_song.instrument_list) <= first_custom_index) + icon(icons.INSTRUMENTS) + "带自定义音色的歌曲......|"+
											inactive(current_song.selected = 0)+"片段......|"+
											inactive(current_song.totalblocks = 0 || os_type != os_windows) + "音频文件......|"+
											inactive(current_song.totalblocks = 0) + "结构......|"+
											inactive(current_song.totalblocks = 0) + "直轨结构......|"+
											inactive(current_song.totalblocks = 0 || os_type != os_windows) + "分支结构......|"+
											inactive(current_song.totalblocks = 0) + "数据包......|/|-|" +
			                             get_hotkey("exit") + "$退出")
				else show_menu_ext("filep", 0, 19, icon(icons.OPEN)+get_hotkey("open_song") + "$打开歌曲......|最近歌曲......|\\|" + str + condstr(recent_song[0] != "", "-|清除最近歌曲") + condstr(recent_song[0] = "", "^!无最近歌曲") + "|/|-|"+"从 MIDI 文件导入......|从 Schematic 文件导入......|-|" + get_hotkey("exit") + "$退出")
							
			}
			if (!isplayer) if (draw_tab("编辑")) {
			    str = ""
			    customstr = ""
				insmenu = 1
			    for (a = 0; a < ds_list_size(current_song.instrument_list); a += 1) {
			        var ins = current_song.instrument_list[| a];
			        if (ins.user)
			            customstr += "...为 " + clean(ins.name) + "|"
			        else
			            str += "...为 " + clean(ins.name) + "|"
					if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
						customstr += "-|更多......|\\|"
						insmenu++
					}
			    }
			    show_menu_ext("edit", 29, 19, inactive(current_song.historypos = current_song.historylen) + icon(icons.UNDO - (current_song.historypos = current_song.historylen)) + get_hotkey("undo") + "$撤销|"+
			                              inactive(current_song.historypos = 0) + icon(icons.REDO - (current_song.historypos = 0)) + get_hotkey("redo") + "$重做|-|"+
			                              inactive(current_song.selected = 0) + icon(icons.COPY - (current_song.selected = 0)) + get_hotkey("copy") + "$复制|"+
			                              inactive(current_song.selected = 0) + icon(icons.CUT - (current_song.selected = 0)) + get_hotkey("cut") + "$剪切|"+
			                              inactive(selection_copied = "") + icon(icons.PASTE - (selection_copied = "")) + get_hotkey("paste") + "$粘贴|"+
			                              inactive(current_song.selected = 0) + icon(icons.DELETE - (current_song.selected = 0)) + get_hotkey("delete") + "$删除|-|"+
			                              inactive(current_song.totalblocks = 0) + get_hotkey("select_all") + "$全选|"+
			                              inactive(current_song.selected = 0) + "全不选|"+
			                              inactive(current_song.selected = 0 && current_song.totalblocks = 0) + get_hotkey("invert_selection") + "$选择反转|-|"+
			                              inactive(current_song.instrument.num_blocks = 0) + "选择所有 " + clean(current_song.instrument.name) + "|"+
			                              inactive(current_song.instrument.num_blocks = current_song.totalblocks) + "选择所有除了 " + clean(current_song.instrument.name) + "|-|"+
			                                inactive(current_song.selected = 0) + get_hotkey("action_1") + "$" + get_mode_actions(1) + "|"+
			                                inactive(current_song.selected = 0) + get_hotkey("action_2") + "$" + get_mode_actions(2) + "|"+
			                                inactive(current_song.selected = 0) + get_hotkey("action_3") + "$" + get_mode_actions(3) + "|"+
			                                inactive(current_song.selected = 0) + get_hotkey("action_4") + "$" + get_mode_actions(4) + "|"+
													condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey("action_5") + "$" + get_mode_actions(5) + "|") +
													condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey("action_6") + "$" + get_mode_actions(6) + "|") +
			                                inactive(current_song.selected = 0) + "更改音色......|\\|" + str + condstr(customstr != "", "-|") + customstr + string_repeat("/|", insmenu) + "-|" +
			                                inactive(current_song.selected = 0 || current_song.selection_l = 0) + "扩展选区|"+
			                                inactive(current_song.selected = 0 || current_song.selection_l = 0) + "压缩选区|"+
			                                inactive(current_song.selected = 0 || current_song.selection_l = 0) + "快捷键......|\\||"+ "Tremolo...|"+ "Stereo...|"+ "Arpeggio...|"+ "Portamento...|"+ "Vibrato|"+ "Stagger...|"+ "Chorus|"+ "Volume LFO|"+ "淡入|"+ "淡出|"+ "替换音|"+ "设定音量......|"+ "设定声道......|"+ "设定音高......|"+ "重置所有属性|"+ "/|-|"+
			                                inactive(current_song.selected = 0) + "转换所有超出八度范围的音符")
			}
			if (draw_tab("设置")) {
			    str = ""
			    customstr = ""
				insmenu = 1
			    for (a = 0; a < ds_list_size(current_song.instrument_list); a++) {
			        var ins = current_song.instrument_list[| a];
			        if (ins.user)
			            customstr += check(current_song.instrument = ins) + clean(ins.name) + "|"
			        else{
						if(a < 10){
							 str += check(current_song.instrument = ins) + get_hotkey("ins_ctrl") + string((a + 1) % 10) + "$" + clean(ins.name) + "|"
						}else{
						  str += check(current_song.instrument = ins) + get_hotkey("ins_ctrl_shift") + string((a + 1) % 10) + "$" + clean(ins.name) + "|"
						}
					}
					if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
						customstr += "-|更多......|\\|"
						insmenu++
					}
			    }
			    if (!isplayer) show_menu_ext("settings", 59, 19, "音色|\\|" + str + condstr(customstr != "", "-|") + customstr + string_repeat("/|", insmenu) +
			                        icon(icons.INSTRUMENTS)+"音色设置......|从 Minecraft 游戏文件中获取音效......|/|-|" + icon(icons.INFORMATION) + "歌曲信息......|" + icon(icons.PROPERTIES) + "歌曲属性......|歌曲数据......|-|" + icon(icons.MIDI_INPUT) + "MIDI 设备管理器|" + get_hotkey("preferences") + "$首选项......")
				else show_menu_ext("settingsp", 29, 19, icon(icons.INFORMATION) + "歌曲信息......|" + "歌曲数据......|-|" + get_hotkey("preferences") + "$首选项......")
			}
			if (draw_tab("帮助")) {
			    show_menu_ext("help", 109 - 30 * isplayer, 19, icon(icons.HELP) + "教程视频|\\|第 1 集：编写音符盒乐曲|第 2 集：打开 MIDI 文件|第 3 集：将乐曲导入进 Minecraft|第 4 集：编辑在 Minecraft 中创作的乐曲     |-|F1$观看所有|/|-|" + icon(icons.INTERNET) + "官方网站......|GitHub......|Discord 服务器......|反馈 bug......|QQ 群......|捐赠......|-|更新历史......|关于......")
			}
		}

		// Icons
		if (theme != 3) {
			if (dropmode) {
				draw_set_color(15790320)
				if (theme = 1) draw_set_color(13160660)
				if (theme = 2) draw_set_color(c_dark)
				draw_rectangle(0, 20, rw, 49, 0)
			}
			draw_sprite(spr_iconbar, 0, 0, 20 + song_tab_offset)
			draw_sprite_ext(spr_iconbar, 1, 2, 20 + song_tab_offset, (rw - 4), 1, 0, -1, 1)
			draw_sprite(spr_iconbar, 2, rw - 2, 20 + song_tab_offset)
		}
		xx = 6
		yy = 23 + song_tab_offset
		if (language != 1) {
			if (!isplayer) if (draw_icon(icons.NEW, xx, yy, "New song", 0, 0)) {new_song()} if (!isplayer) xx += 25
			if (draw_icon(icons.OPEN, xx, yy, "Open song", 0, 0)) {playing = 0 load_song("") if (isplayer) current_song = songs[song]} xx += 25 + isplayer * 4
			if (!isplayer) if (draw_icon(icons.SAVE, xx, yy, "Save song", 0, 0)) {save_song(current_song.filename)} if (!isplayer) xx += 25 + 4
			draw_separator(xx, yy + 3) xx += 4
			if (draw_icon(icons.PLAY + playing, xx, yy, "Play / Pause song", 0, 0)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
			if (isplayer && !dropmode) if (draw_icon(icons.PLAY + playing, centerx - 12, centery + 50, "Play / Pause song", 0, 0)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
			xx += 25
			if (draw_icon(icons.STOP, xx, yy, "Stop song", 0, 0)) {playing = 0 current_song.marker_pos = 0 current_song.marker_prevpos = 0 timestoloop = real(current_song.loopmax) remove_emitters_all_schedule = 1} xx += 25
			if (isplayer && !dropmode) if (draw_icon(icons.STOP, centerx - 12 - 100, centery + 50, "Stop song", 0, 0)) {playing = 0 current_song.marker_pos = 0 current_song.marker_prevpos = 0 timestoloop = real(current_song.loopmax) remove_emitters_all_schedule = 1}
			forward = 0
			if (draw_icon(icons.BACK, xx, yy, "Rewind song", 0, 0)) {forward = -1} xx += 25
			if (isplayer && !dropmode) if (draw_icon(icons.BACK, centerx - 12 - 50, centery + 50, "Rewind song", 0, 0)) {forward = -1}
			if (draw_icon(icons.FORWARD, xx, yy, "Fast-forward song", 0, 0)) {forward = 1} xx += 25
			if (isplayer && !dropmode) if (draw_icon(icons.FORWARD, centerx - 12 + 50, centery + 50, "Fast-forward song", 0, 0)) {forward = 1}
			if (!isplayer) if (draw_icon(icons.RECORD, xx, yy, "Record key presses", 0, playing > 0 && record)) {playing = 0.25 record=!record} if (!isplayer) xx += 25 
			if (draw_icon(icons.LOOP_INACTIVE + current_song.loop_session, xx, yy, "Toggle looping", 0, 0)) current_song.loop_session = !current_song.loop_session if (!isplayer) xx += 25
			if (isplayer && !dropmode) if (draw_icon(icons.LOOP_INACTIVE + current_song.loop_session, centerx - 12 + 100, centery + 50, "Toggle looping", 0, 0)) current_song.loop_session = !current_song.loop_session if (!isplayer)
			if metronome {
				if (metronome_played == -1 || (metronome_played - 1) mod 8 == 0) metricon = icons.METRONOME_1
				else metricon = icons.METRONOME_2
			} else {
				metricon = icons.METRONOME_INACTIVE
			}
			if (!isplayer) if(draw_icon(metricon, xx, yy, "Toggle metronome", 0, 0)) metronome = !metronome
			xx += 25 + 4
			if (playing = 0) record = 0
			draw_separator(xx, yy + 3) xx += 4
			if (!isplayer) if (draw_icon(icons.EDITMODE_KEY, xx, yy, "Edit note key", 0, editmode = 0)) {editmode = 0} if (!isplayer) xx += 25
			if (!isplayer) if (draw_icon(icons.EDITMODE_VEL, xx, yy, "Edit note velocity", 0, editmode = 1)) {editmode = 1}  if (!isplayer) xx += 25
			if (!isplayer) if (draw_icon(icons.EDITMODE_PAN, xx, yy, "Edit note panning", 0, editmode = 2)) {editmode = 2} if (!isplayer) xx += 25
			if (!isplayer) if (draw_icon(icons.EDITMODE_PIT, xx, yy, "Edit note pitch", 0, editmode = 3)) {editmode = 3} if (!isplayer) xx += 25 + 4
			if (!isplayer) draw_separator(xx, yy + 3) if (!isplayer) xx += 4
		} else {
			if (!isplayer) if (draw_icon(icons.NEW, xx, yy, "新文件", 0, 0)) {new_song()} if (!isplayer) xx += 25
			if (draw_icon(icons.OPEN, xx, yy, "打开歌曲", 0, 0)) {playing = 0 load_song("") if (isplayer) current_song = songs[song]} xx += 25 + isplayer * 4
			if (!isplayer) if (draw_icon(icons.SAVE, xx, yy, "保存歌曲", 0, 0)) {save_song(current_song.filename)} if (!isplayer) xx += 25 + 4
			draw_separator(xx, yy + 3) xx += 4
			if (draw_icon(icons.PLAY + playing, xx, yy, "播放 / 暂停", 0, 0)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
			if (isplayer && !dropmode) if (draw_icon(icons.PLAY + playing, centerx - 12, centery + 50, "播放 / 暂停", 0, 0)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
			xx += 25
			if (draw_icon(icons.STOP, xx, yy, "停止歌曲", 0, 0)) {playing = 0 current_song.marker_pos = 0 current_song.marker_prevpos = 0 timestoloop = real(current_song.loopmax) remove_emitters_all_schedule = 1} xx += 25
			if (isplayer && !dropmode) if (draw_icon(icons.STOP, centerx - 12 - 100, centery + 50, "停止歌曲", 0, 0)) {playing = 0 current_song.marker_pos = 0 current_song.marker_prevpos = 0 timestoloop = real(current_song.loopmax) remove_emitters_all_schedule = 1}
			forward = 0
			if (draw_icon(icons.BACK, xx, yy, "快退", 0, 0)) {forward = -1} xx += 25
			if (isplayer && !dropmode) if (draw_icon(icons.BACK, centerx - 12 - 50, centery + 50, "快退", 0, 0)) {forward = -1}
			if (draw_icon(icons.FORWARD, xx, yy, "快进", 0, 0)) {forward = 1} xx += 25
			if (isplayer && !dropmode) if (draw_icon(icons.FORWARD, centerx - 12 + 50, centery + 50, "快进", 0, 0)) {forward = 1}
			if (!isplayer) if (draw_icon(icons.RECORD, xx, yy, "录制按键", 0, playing > 0 && record)) {playing = 0.25 record=!record} if (!isplayer) xx += 25 
			if (draw_icon(icons.LOOP_INACTIVE + current_song.loop_session, xx, yy, "开关循环", 0, 0)) current_song.loop_session = !current_song.loop_session if (!isplayer) xx += 25
			if (isplayer && !dropmode) if (draw_icon(icons.LOOP_INACTIVE + current_song.loop_session, centerx - 12 + 100, centery + 50, "开关循环", 0, 0)) current_song.loop_session = !current_song.loop_session if (!isplayer)
			if metronome {
				if (metronome_played == -1 || (metronome_played - 1) mod 8 == 0) metricon = icons.METRONOME_1
				else metricon = icons.METRONOME_2
			} else {
				metricon = icons.METRONOME_INACTIVE
			}
			if (!isplayer) if(draw_icon(metricon, xx, yy, "开关节拍器", 0, 0)) metronome = !metronome
			xx += 25 + 4
			if (playing = 0) record = 0
			draw_separator(xx, yy + 3) xx += 4
			if (!isplayer) if (draw_icon(icons.EDITMODE_KEY, xx, yy, "音调模式", 0, editmode = 0)) {editmode = 0} if (!isplayer) xx += 25
			if (!isplayer) if (draw_icon(icons.EDITMODE_VEL, xx, yy, "音量模式", 0, editmode = 1)) {editmode = 1}  if (!isplayer) xx += 25
			if (!isplayer) if (draw_icon(icons.EDITMODE_PAN, xx, yy, "声道模式", 0, editmode = 2)) {editmode = 2} if (!isplayer) xx += 25
			if (!isplayer) if (draw_icon(icons.EDITMODE_PIT, xx, yy, "音高模式", 0, editmode = 3)) {editmode = 3} if (!isplayer) xx += 25 + 4
			if (!isplayer) draw_separator(xx, yy + 3) if (!isplayer) xx += 4
		}

		// Expandable instrument box
		var ins_count = ds_list_size(current_song.instrument_list)
		var ins_icons = median(5, ceil((rw - 920) / 25), ins_count)
		if (ins_icons = ins_count - 1) ins_icons += 1
		var ins_rows = ceil(ins_count / ins_icons)
		if (!isplayer) if (showinsbox) {
			window = w_insbox
			draw_theme_color()
			draw_window(xx - 2, yy - 2, xx + (ins_icons * 25) + 2, yy + (ins_rows * 25) + 2)
			for (a = 0; a < ins_rows; a += 1) {
				for (b = 0; b < ins_icons; b += 1) {
					var insindex = (a * ins_icons + b)
					if (insindex >= ds_list_size(current_song.instrument_list)) break
					var ins = current_song.instrument_list[| insindex];
					if (draw_icon_insbox(insindex, xx + b * 25, yy + a * 25, condstr(language != 1, "Change instrument to ", "更改音色为") + ins.name, true, false, current_song.instrument = ins)) {
						play_sound(ins, selected_key, 100, 100, 0)
						current_song.instrument = ins
						selected_vel = 100
						selected_pan = 100
						selected_pit = 0
						// Set the first instrument of the collapsed row
						insbox_start = min(floor(insindex / ins_icons) * ins_icons, ds_list_size(current_song.instrument_list) - ins_icons)
					}
				}
			}
			// Click away
			if (mouse_check_button_released(mb_left)) && !(mouse_rectangle(xx, yy, ins_icons * 25, ins_rows * 25)) {
				showinsbox = 0
				window = 0
			}
			xx += ins_icons * 25
			// 'Collapse' button
			if (language != 1) draw_icon_insbox(icons.INSBOX_COLLAPSE, xx, yy, "Less instruments", true) // it's a fake button since clicking anywhere works :D
			else draw_icon_insbox(icons.INSBOX_COLLAPSE, xx, yy, "收回音色", true)
			xx += 25
		} else {
			// Ensure current instrument appears
			a = ds_list_find_index(current_song.instrument_list, current_song.instrument)
			if (a < current_song.insbox_start) {
				current_song.insbox_start -= ins_icons
				current_song.insbox_start = floor(current_song.insbox_start / ins_icons) * ins_icons
			} else if (a > current_song.insbox_start + ins_icons - 1) {
				current_song.insbox_start += ins_icons
				current_song.insbox_start = floor(current_song.insbox_start / ins_icons) * ins_icons
			}
			// Prevent overflow
			current_song.insbox_start = median(0, current_song.insbox_start, ds_list_size(current_song.instrument_list) - ins_icons)
			for (a = current_song.insbox_start; a < current_song.insbox_start + ins_icons; a += 1) {
			    var ins = current_song.instrument_list[| a];
			    if (draw_icon_insbox(a, xx, yy, condstr(language != 1, "Change instrument to ", "更改音色为") + ins.name, false, false, current_song.instrument = ins)) {
					play_sound(ins, selected_key, 100, 100, 0)
					current_song.instrument = ins
					selected_vel = 100
					selected_pan = 100
					selected_pit = 0
				}
				xx += 25
			}
			if (ins_icons < ds_list_size(current_song.instrument_list)) {
				if (draw_icon_insbox(icons.INSBOX_EXPAND, xx, yy, condstr(language != 1, "More instruments...", "展开音色......"), false, true, 0)) {showinsbox = 1}
				xx += 25
			}
		}
		if (!isplayer) {xx += 4 draw_separator(xx, yy + 3) xx += 4}
		if (language != 1) {
			while (1) {
				if (!isplayer) {if (draw_icon(icons.UNDO, xx, yy, "Undo the last change", current_song.historypos = current_song.historylen, 0)) {playing = 0 action_undo()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.REDO, xx, yy, "Redo the last undo", current_song.historypos = 0, 0)) {playing = 0 action_redo()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.COPY, xx, yy, "Copy the selected note blocks", current_song.selected = 0, 0)) {playing = 0 action_copy()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.CUT, xx, yy, "Cut the selected note blocks", current_song.selected = 0, 0)) {playing = 0 action_cut()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.PASTE, xx, yy, "Paste the copied note blocks", selection_copied = "", 0)) {playing = 0 action_paste(current_song.starta, current_song.startb)} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.DELETE, xx, yy, "Delete the selected note blocks", current_song.selected = 0, 0)) {playing = 0 action_delete()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {xx += 4 draw_separator(xx, yy + 3) xx += 4 if (xx > rw - 312) break}
				if (draw_icon(icons.INFORMATION, xx, yy, "View song info")) {if (!isplayer) playing = 0 window = w_songinfoedit * !isplayer + w_songinfo * isplayer} xx += 25 if (xx > rw - 312) break
				if (!isplayer) {if (draw_icon(icons.PROPERTIES, xx, yy, "Edit song properties")) {playing = 0 window = w_properties} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.INSTRUMENTS, xx, yy, "Edit instruments")) {playing = 0 window = w_instruments} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.MIDI_INPUT, xx, yy, "MIDI device manager")) {playing = 0 window = w_mididevices} xx += 25 if (xx > rw - 312) break}
				xx += 4 draw_separator(xx, yy + 3) xx += 4 if (xx > rw - 312) break
				if (draw_icon(icons.HELP, xx, yy, "Watch tutorial videos")) {
				    open_url("http://www.youtube.com/playlist?list=PL7EA4F0D271DA6E86")
				} xx += 25 if (xx > rw - 312) break
				if (draw_icon(icons.INTERNET, xx, yy, "Visit the Note Block Studio website")) {open_url(link_website)} xx += 25 if (xx > rw - 312) break
				break
			}
			if (isplayer) if (draw_icon(icons.EDITMODE_KEY, xx, yy, condstr(dropmode, "Exit", "Enter") + " the drop mode", 0, dropmode)) {dropmode = !dropmode if (dropmode) window_maximize() else window_setnormal()} if (isplayer) xx += 25
		} else {
			while (1) {
				if (!isplayer) {if (draw_icon(icons.UNDO, xx, yy, "撤销", current_song.historypos = current_song.historylen, 0)) {playing = 0 action_undo()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.REDO, xx, yy, "重做", current_song.historypos = 0, 0)) {playing = 0 action_redo()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.COPY, xx, yy, "复制", current_song.selected = 0, 0)) {playing = 0 action_copy()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.CUT, xx, yy, "剪切", current_song.selected = 0, 0)) {playing = 0 action_cut()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.PASTE, xx, yy, "粘贴", selection_copied = "", 0)) {playing = 0 action_paste(current_song.starta, current_song.startb)} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.DELETE, xx, yy, "删除", current_song.selected = 0, 0)) {playing = 0 action_delete()} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {xx += 4 draw_separator(xx, yy + 3) xx += 4 if (xx > rw - 312) break}
				if (draw_icon(icons.INFORMATION, xx, yy, "歌曲信息")) {if (!isplayer) playing = 0 window = w_songinfoedit * !isplayer + w_songinfo * isplayer} xx += 25 if (xx > rw - 312) break
				if (!isplayer) {if (draw_icon(icons.PROPERTIES, xx, yy, "歌曲属性")) {playing = 0 window = w_properties} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.INSTRUMENTS, xx, yy, "音色设置")) {playing = 0 window = w_instruments} xx += 25 if (xx > rw - 312) break}
				if (!isplayer) {if (draw_icon(icons.MIDI_INPUT, xx, yy, "MIDI 设备管理器")) {playing = 0 window = w_mididevices} xx += 25 if (xx > rw - 312) break}
				xx += 4 draw_separator(xx, yy + 3) xx += 4 if (xx > rw - 312) break
				if (draw_icon(icons.HELP, xx, yy, "教程视频")) {
				    open_url("https://www.bilibili.com/video/BV1Mx411a76p")
				} xx += 25 if (xx > rw - 312) break
				if (draw_icon(icons.INTERNET, xx, yy, "访问 Note Block Studio 官方网站")) {open_url(link_website)} xx += 25 if (xx > rw - 312) break
				break
			}
			if (isplayer) if (draw_icon(icons.EDITMODE_KEY, xx, yy, condstr(dropmode, "关闭", "开启") + "下落模式", 0, dropmode)) {dropmode = !dropmode if (dropmode) window_maximize() else window_setnormal()} if (isplayer) xx += 25
		}
		if (aa = 2 && mouse_check_button_released(mb_left) && windowsound) {
			play_sound(soundding, 45, 100, 100, 0)
		}
		xx += 8
		var mastervolprev = mastervol
		mastervol = floor(draw_dragbar(mastervol, 1, xx, yy + 10, 100, 2, clamp(mouse_x - xx, 0, 100), condstr(language != 1, "Master Volume: ", "主音量：") + string(floor(mastervol * 100)), 0) * 100 + 0.5) / 100
		if (mastervolprev != mastervol && audio_is_playing(current_song.reference_audio)) audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
		if (mouse_rectangle(xx - 11, yy, 122, 22) && window = 0) {
			volume_scroll = 1
			if (mouse_wheel_up() && mastervol + 0.02 <= 1) {mastervol += 0.02; if (audio_is_playing(current_song.reference_audio)) audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)}
			if (mouse_wheel_down() && mastervol - 0.02 >= 0) {mastervol -= 0.02; if (audio_is_playing(current_song.reference_audio)) audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)}
		} else {
			volume_scroll = 0
		}
		draw_set_alpha(1)
		//if (!isplayer) {
		//	xx += 120
		//	if (draw_button2(xx, yy, 90, condstr(language != 1, "Reference audio", "参考音频"))) {
		//		reference_audio_file = string(get_open_filename_ext("Ogg Vorbis (*.ogg)|*.ogg", "", songfolder, condstr(language != 1, "Load reference audio", "打开参考音频")))
		//		reference_audio = audio_create_stream(reference_audio_file)
		//		if (reference_audio < 0) {
		//		    if (language != 1) message("Couldn't load the file", "Error")
		//		    else message("找不到文件", "错误")
		//			reference_audio_file = ""
		//			reference_audio = -1
		//		}
		//	}
		//	draw_theme_color()
		//	xx += 100
		//	if (reference_audio >= 0) draw_text_dynamic(xx, yy + 5, condstr(language != 1, "Offset (ms): ", "偏移量（毫秒）: "))
		//	xx += 90
		//	if (reference_audio >= 0) reference_offset = median(0, draw_dragvalue(13, xx, yy + 5, reference_offset, 0.5), 1000000)
		//	xx += 30
		//	if (reference_audio >= 0) draw_text_dynamic(xx, yy + 5, condstr(language != 1, "Loaded file: ", "已加载音频: ") + reference_audio_file)
		//}

		// Compatible
		if (!isplayer) {
			draw_separator(rw - 34, 26 + song_tab_offset)
			draw_theme_font(font_main_bold)
			draw_set_halign(fa_right)
			if (current_song.compatible = 1) {
				if (theme != 3) {
					draw_sprite(spr_minecraft, 0, rw - 30, 25 + song_tab_offset)
					draw_sprite(spr_minecraft, 0, rw - 59, 25 + song_tab_offset)
				} else {
					if (!hires) {
						draw_sprite(spr_minecraft_f, fdark * 3, rw - 30, 25 + song_tab_offset)
						draw_sprite(spr_minecraft_f, fdark * 3, rw - 59, 25 + song_tab_offset)
						draw_sprite_ext(spr_minecraft_f, 6, rw - 30, 25 + song_tab_offset, 1, 1, 0, accent[6 - 2 * !fdark], 1)
						draw_sprite_ext(spr_minecraft_f, 6, rw - 59, 25 + song_tab_offset, 1, 1, 0, accent[6 - 2 * !fdark], 1)
					} else {
						draw_sprite_ext(spr_minecraft_f_hires, fdark * 3, rw - 30, 25 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
						draw_sprite_ext(spr_minecraft_f_hires, fdark * 3, rw - 59, 25 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
						draw_sprite_ext(spr_minecraft_f_hires, 6, rw - 30, 25 + song_tab_offset, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
						draw_sprite_ext(spr_minecraft_f_hires, 6, rw - 59, 25 + song_tab_offset, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
					}
				}
				draw_set_color(c_green)
				if (theme == 2 || (theme == 3 && fdark)) draw_set_color(c_lime)
				if (language != 1) draw_text_dynamic(rw - 65, 28 + song_tab_offset, "Fully compatible")
				else draw_text_dynamic(rw - 65, 28 + song_tab_offset, "完全兼容")
				draw_theme_color()
				draw_theme_font(font_main)
				if (language != 1) popup_set(rw - compx, 24 + song_tab_offset, compx, 25, "This song is compatible with both schematics and data packs.\n(Click for more info.)")
				else popup_set(rw - compx, 24 + song_tab_offset, compx, 25, "此歌曲兼容 schematic 和数据包。\n（点击查看更多）")
			} else if (current_song.compatible = 2) {
				if (theme != 3) {
					draw_sprite(spr_minecraft, 0, rw - 30, 25 + song_tab_offset)
					draw_sprite(spr_minecraft, 1, rw - 59, 25 + song_tab_offset)
				} else {
					if (!hires) {
						draw_sprite(spr_minecraft_f, fdark * 3, rw - 30, 25 + song_tab_offset)
						draw_sprite(spr_minecraft_f, 1 + fdark * 3, rw - 59, 25 + song_tab_offset)
						draw_sprite_ext(spr_minecraft_f, 6, rw - 30, 25 + song_tab_offset, 1, 1, 0, accent[6 - 2 * !fdark], 1)
						draw_sprite_ext(spr_minecraft_f, 1 + 6, rw - 59, 25 + song_tab_offset, 1, 1, 0, accent[6 - 2 * !fdark], 1)
					} else {
						draw_sprite_ext(spr_minecraft_f_hires, fdark * 3, rw - 30, 25 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
						draw_sprite_ext(spr_minecraft_f_hires, 1 + fdark * 3, rw - 59, 25 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
						draw_sprite_ext(spr_minecraft_f_hires, 6, rw - 30, 25 + song_tab_offset, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
						draw_sprite_ext(spr_minecraft_f_hires, 1 + 6, rw - 59, 25 + song_tab_offset, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
					}
				}
				draw_set_color(c_orange)
				if (language != 1) draw_text_dynamic(rw - 65, 28 + song_tab_offset, "Data pack only")
				else draw_text_dynamic(rw - 65, 28 + song_tab_offset, "仅限数据包")
				draw_theme_color()
				draw_theme_font(font_main)
				if (language != 1) popup_set(rw - compx, 24 + song_tab_offset, compx, 25, "This song is only compatible with data packs.\n(Click for more info.)")
				else popup_set(rw - compx, 24 + song_tab_offset, compx, 25, "此歌曲仅兼容数据包。\n（点击查看更多）")
			} else {
				if (theme != 3) {
					draw_sprite(spr_minecraft, 2, rw - 30, 25 + song_tab_offset)
					draw_sprite(spr_minecraft, 1, rw - 59, 25 + song_tab_offset)
				} else {
					if (!hires) {
						draw_sprite(spr_minecraft_f, 2 + fdark * 3, rw - 30, 25 + song_tab_offset)
						draw_sprite(spr_minecraft_f, 1 + fdark * 3, rw - 59, 25 + song_tab_offset)
						draw_sprite_ext(spr_minecraft_f, 2 + 6, rw - 30, 25 + song_tab_offset, 1, 1, 0, accent[6 - 2 * !fdark], 1)
						draw_sprite_ext(spr_minecraft_f, 1 + 6, rw - 59, 25 + song_tab_offset, 1, 1, 0, accent[6 - 2 * !fdark], 1)
					} else {
						draw_sprite_ext(spr_minecraft_f_hires, 2 + fdark * 3, rw - 30, 25 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
						draw_sprite_ext(spr_minecraft_f_hires, 1 + fdark * 3, rw - 59, 25 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
						draw_sprite_ext(spr_minecraft_f_hires, 2 + 6, rw - 30, 25 + song_tab_offset, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
						draw_sprite_ext(spr_minecraft_f_hires, 1 + 6, rw - 59, 25 + song_tab_offset, 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
					}
				}
				draw_set_color(c_red)
				if (language != 1) draw_text_dynamic(rw - 65, 28 + song_tab_offset, "Resource pack only")
				else draw_text_dynamic(rw - 65, 28 + song_tab_offset, "仅限资源包")
				draw_theme_color()
				draw_theme_font(font_main)
				if (language != 1) popup_set(rw - compx, 24 + song_tab_offset, compx, 25, "This song is compatible with data packs using a resource pack.\n(Click for more info.)")
				else popup_set(rw - compx, 24 + song_tab_offset, compx, 25, "此歌曲仅兼容带资源包的数据包。\n（点击查看更多）")
			}
			draw_set_halign(fa_left)

			a = mouse_rectangle(rw - compx, 24 + song_tab_offset, compx, 25)
			if (a && window = 0) {
			    curs = cr_handpoint
			    if (mouse_check_button_pressed(mb_left)) {
			        playing = 0
			        record = 0
			        selection_place(0)
			        window = w_minecraft
			    }
			}

			// Status bar
			draw_set_color(make_color_rgb(128, 128, 128))
			if (!fdark || theme != 3) draw_line(0, rh - 24, rw, rh - 24)
			draw_set_color(c_white)
			if (fdark || theme != 3) draw_line(0, rh - 23 - (theme = 3 && fdark), rw, rh - 23 - (theme = 3 && fdark))
			draw_theme_color()
			xx = 4

			if (language != 1) {draw_text_dynamic(xx, rh - 18, "Instrument: " + current_song.instrument.name) xx += 180}
			else {draw_text_dynamic(xx, rh - 18, "音色: " + current_song.instrument.name) xx += 180}
			draw_separator(xx, rh - 20)
			draw_theme_color()

			xx += 4
			if (language != 1) {draw_text_dynamic(xx, rh - 18, "Key: " + get_keyname(selected_key, 1)) xx += 75}
			else {draw_text_dynamic(xx, rh - 18, "音: " + get_keyname(selected_key, 1)) xx += 75}
			draw_separator(xx, rh - 20)
			draw_theme_color()
	
			if (selected_vel != 100 || selected_pan != 100 || selected_pit != 0) {
				xx += 4
				if (language != 1) {draw_text_dynamic(xx, rh - 18, "Velocity: " + string(selected_vel)) xx += 100}
				else {draw_text_dynamic(xx, rh - 18, "音量: " + string(selected_vel)) xx += 100}
				draw_separator(xx, rh - 20)
				draw_theme_color()
	
				xx += 4
				if (language != 1) {draw_text_dynamic(xx, rh - 18, "Panning: " + string(selected_pan - 100)) xx += 95}
				else {draw_text_dynamic(xx, rh - 18, "声道: " + string(selected_pan - 100)) xx += 95}
				draw_separator(xx, rh - 20)
				draw_theme_color()
	
				xx += 4
				if (language != 1) {draw_text_dynamic(xx, rh - 18, "Pitch: " + string(selected_pit)) xx += 85}
				else {draw_text_dynamic(xx, rh - 18, "音高: " + string(selected_pit)) xx += 85}
				draw_separator(xx, rh - 20)
				draw_theme_color()
			}

			xx += 4
			if (language != 1) {draw_text_dynamic(xx, rh - 18, "Tick: " + test(selbx = -1, "None", string(selbx))) xx += 90}
			else {draw_text_dynamic(xx, rh - 18, "位置: " + test(selbx = -1, "无", string(selbx))) xx += 90}
			draw_separator(xx, rh - 20)
			draw_theme_color()

			xx += 4
			if (language != 1) {draw_text_dynamic(xx, rh - 18, "Layer: " + test(selby = -1, "None", string(selby + 1))) xx += 90}
			else {draw_text_dynamic(xx, rh - 18, "层: " + test(selby = -1, "无", string(selby + 1))) xx += 90}
			draw_separator(xx, rh - 20)
			draw_theme_color()

			xx += 4
			if (language != 1) {draw_text_dynamic(xx, rh - 18, "Selected: " + string(current_song.selected) + " / " + string(current_song.totalblocks + current_song.selected)) xx += 160}
			else {draw_text_dynamic(xx, rh - 18, "已选择: " + string(current_song.selected) + " / " + string(current_song.totalblocks + current_song.selected)) xx += 160}
			draw_separator(xx, rh - 20)
			draw_theme_color()

			var hovernote = 0
			if (sela > -1 && selb > -1) {
				if (selbx < current_song.arraylength && selby < current_song.arrayheight) {
					if (current_song.song_exists[selbx, selby]) {
						hovernote = 1
						xx += 4
						if (language != 1) draw_text_dynamic(xx, rh - 18, "Key: " + get_keyname(current_song.song_key[selbx, selby], 1))
						else draw_text_dynamic(xx, rh - 18, "音: " + get_keyname(current_song.song_key[selbx, selby], 1))
						xx += 90
						draw_separator(xx, rh - 20)
						draw_theme_color()
						xx += 4
						if (language != 1) draw_text_dynamic(xx, rh - 18, "Velocity: " + string_format(current_song.song_vel[selbx, selby], 1, 0))
						else draw_text_dynamic(xx, rh - 18, "音量: " + string_format(current_song.song_vel[selbx, selby], 1, 0))
						xx += 110
						draw_separator(xx, rh - 20)
						draw_theme_color()
						xx += 4
						if (language != 1) {
							if (current_song.song_pan[selbx, selby] != 100) {
								draw_text_dynamic(xx, rh - 18, "Panning: " + condstr(current_song.song_pan[selbx, selby] < 100, "L ", "R ") + " " + string(abs(current_song.song_pan[selbx, selby] - 100)))
							} else {
								draw_text_dynamic(xx, rh - 18, "Panning: Center")
							}
						} else {
							if (current_song.song_pan[selbx, selby] != 100) {
								draw_text_dynamic(xx, rh - 18, "声道: " + condstr(current_song.song_pan[selbx, selby] < 100, "L ", "R ") + " " + string(abs(current_song.song_pan[selbx, selby] - 100)))
							} else {
								draw_text_dynamic(xx, rh - 18, "声道: 中央")
							}
						}
						xx += 120
						draw_separator(xx, rh - 20)
						draw_theme_color()
						xx += 4
						if (language != 1) draw_text_dynamic(xx, rh - 18, "Pitch: " + condstr(current_song.song_pit[selbx, selby] > 0, "+") + string_format(current_song.song_pit[selbx, selby], 1, 0) + " cents")
						else draw_text_dynamic(xx, rh - 18, "音高: " + condstr(current_song.song_pit[selbx, selby] > 0, "+") + string_format(current_song.song_pit[selbx, selby], 1, 0) + "微分")
						draw_theme_color()
					}
				}
			}
			if (!hovernote) {
				// Auto-save remaining time
				if (autosave && filename_ext(current_song.filename) = ".nbs") {
					draw_theme_color()
					xx += 4
					if (language != 1) draw_text_dynamic(xx, rh - 18, "Next auto-save: " + string(ceil(tonextsave)) + " minute" + condstr(ceil(tonextsave)<>1, "s"))
					else draw_text_dynamic(xx, rh - 18, "下次自动保存: " + string(ceil(tonextsave)) + " 分钟")
					xx += 210
					draw_separator(xx, rh - 20)
					draw_theme_color()
				}
				// Active sounds count
				if (show_soundcount) {
					xx += 4
					if (sounds > channels) {
						draw_set_color(c_red)
					}
					if (language != 1) draw_text_dynamic(xx, rh - 18, "Sounds: " + string(sounds) + " / " + string(channels))
					else draw_text_dynamic(xx, rh - 18, "声音数: " + string(sounds) + " / " + string(channels))
					draw_theme_color()
				}
			}

			draw_set_halign(fa_right)
			str = ""
			for (a = 0; a < midi_devices; a += 1) str += condstr(a > 0, ", ") + midi_device_names[a] + condstr(midi_device_current = a, condstr(language != 1, " (selected)", "（使用中）"))
			if (language != 1) {
				if (midi_devices = 0) str = "No connected MIDI devices"
				else str = "MIDI devices: " + str
			} else {
				if (midi_devices = 0) str = "无 MIDI 设备"
				else str = "MIDI 设备: " + str
			}
			draw_text_dynamic(rw - 6, rh - 18, str)
			draw_set_halign(fa_left)
		}
	
	}

	if (!fullscreen && show_layers) {
		if (dropmode) draw_set_alpha(dropalpha)
		// Marker position
		if (theme != 3) draw_set_halign(fa_right)
		draw_theme_color()
		if (isplayer && blackout) draw_set_color(c_white)
		if (!isplayer || dropmode) {
		draw_theme_font(font_info_med_bold)
		if (theme != 3) draw_text_dynamic(93, 52 + song_tab_offset, time_str(current_song.marker_pos / current_song.tempo))
		else draw_text_dynamic(93 - 84, 52 + song_tab_offset, time_str(current_song.marker_pos / current_song.tempo))
		} else {
		draw_theme_font(font_info_big)
		if (theme != 3) draw_text_dynamic(centerx + 70, centery - 50 + song_tab_offset, time_str(current_song.marker_pos / current_song.tempo))
		else draw_text_dynamic(centerx - 134 + 70, centery - 50 + song_tab_offset, time_str(current_song.marker_pos / current_song.tempo))
		}

		// Song length
		if (!isplayer || dropmode) {
		draw_theme_font(font_small)
		if (theme != 3) draw_text_dynamic(93, 69 + song_tab_offset, "/ " + time_str(current_song.enda / current_song.tempo))
		else draw_text_dynamic(93 - 67, 69 + song_tab_offset, "/ " + time_str(current_song.enda / current_song.tempo))
		} else {
		if (blackout) draw_set_color(c_white)
		draw_theme_font(font_info_med)
		if (theme != 3) draw_text_dynamic(centerx + 70, centery - 20 + song_tab_offset, "/ " + time_str(current_song.enda / current_song.tempo))
		else draw_text_dynamic(centerx - 91 + 70, centery - 20 + song_tab_offset, "/ " + time_str(current_song.enda / current_song.tempo))
		}
		draw_theme_font(font_main)
		draw_set_halign(fa_left)
		draw_set_alpha(1)
		
		if (isplayer) {
			current_song = songs[song]
			if (!dropmode) {

				current_song.marker_pos = draw_dragbar(current_song.marker_pos, current_song.enda + totalcols, centerx - 200, centery + 25, 400, 1, time_str((clamp(((mouse_x - (centerx - 200)) / 400) * current_song.enda, 0, current_song.enda)) / current_song.tempo), condstr(language != 1, "Song Position", "当前位置"), 0)
				draw_set_halign(fa_left)
				draw_theme_color()
				if (blackout) draw_set_color(c_white)
				draw_theme_font(font_info_med)
				var offset = 0;
				if (current_song.song_author != "") offset += 20
				if (current_song.song_orauthor != "") offset += 15
				
				var title_str = "";
				if (current_song.song_name != "") {
					title_str = current_song.song_name
				} else if (current_song.song_download_display_name != "") {
					title_str = current_song.song_download_display_name
				} else if (current_song.filename != "") {
					title_str = filename_change_ext(filename_name(current_song.filename), "")
				} else if (current_song.midiname != "") {
					title_str = filename_change_ext(current_song.midiname, "")
				}
				
				draw_text_dynamic(centerx - 200, centery - 80 - offset, title_str, true)
				if (current_song.song_author != "") {
					draw_theme_font(font_main_bold)
					draw_text_dynamic(centerx - 200, centery - 60 - offset, current_song.song_author, true)
				}
				if (current_song.song_orauthor != "") {
					if (current_song.song_author == "") offset += 15
					draw_theme_font(font_main)
					draw_set_color(c_gray)
					draw_text_dynamic(centerx - 200, centery - 45 - offset, (language != 1 ? "original by " : "原作者 "), true)
					draw_theme_font(font_main_bold)
					draw_text_dynamic(centerx - 200 + string_width_dynamic(language != 1 ? "original by " : "原作者 "), centery - 45 - offset, current_song.song_orauthor, true)
				}
				draw_theme_font(font_main)
				draw_set_color(c_white)
				dropalpha = 1
			} else {
				draw_set_alpha(dropalpha)
				current_song.marker_pos = draw_dragbar(current_song.marker_pos, current_song.enda + totalcols, 93 - 84 + 100, 52 + 15, 400, 1, time_str((clamp(((mouse_x - (93 - 84 + 100)) / 400) * current_song.enda, 0, current_song.enda)) / current_song.tempo), condstr(language != 1, "Song Position", "当前位置"), 0)
				draw_set_alpha(1)
				if (mouse_x != mouse_xprev || mouse_y != mouse_yprev || mouse_rectangle(0, 0, 530, 90) || window != 0) {
					dropalpha = 1
					dropalphawait = current_time
				} else if (current_time - dropalphawait >= 1500 && dropalpha > 0) {
					if (dropalpha - (1 / (room_speed * currspeed)) * 2 > 0) dropalpha -= (1 / (room_speed * currspeed)) * 2
					else dropalpha = 0
				}
				current_song.starta = current_song.marker_pos
				draw_set_halign(fa_left)
			}
		}

		if (!isplayer) {
		// Bars-beats-sixteenths
		if (!hires || theme != 3) draw_sprite(spr_tempobox, 2 * (theme = 3) + 2 * (fdark && theme = 3), 184, 57 + song_tab_offset)
		else draw_sprite_ext(spr_tempobox_hires, 2 * (theme = 3) + 2 * (fdark && theme = 3), 184, 57 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
		draw_set_halign(fa_right)
		draw_text_dynamic(215, 60 + song_tab_offset, ".")
		draw_text_dynamic(230, 60 + song_tab_offset, ".")
		draw_text_dynamic(210, 60 + song_tab_offset, floor(current_song.marker_pos / (current_song.timesignature * 4)) + 1)
		draw_text_dynamic(225, 60 + song_tab_offset, floor((current_song.marker_pos / 4) mod current_song.timesignature) + 1)
		draw_text_dynamic(240, 60 + song_tab_offset, floor(current_song.marker_pos mod 4) + 1)
		if (language != 1) popup_set(184, 57 + song_tab_offset, 64, 22, "Position of the marker in bars, beats and sixteenths.")
		else popup_set(184, 57 + song_tab_offset, 64, 22, "歌曲的进度（全音、四分、十六分）")

		// Tempo
		draw_set_halign(fa_center)
		if (use_bpm) {
			if (!hires || theme != 3) draw_sprite(spr_tempobox, 1 + 2 * (theme = 3) + 2 * (fdark && theme = 3), 101, 57 + song_tab_offset)
			else draw_sprite_ext(spr_tempobox_hires, 1 + 2 * (theme = 3) + 2 * (fdark && theme = 3), 101, 57 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
		} else {
			if (!hires || theme != 3) draw_sprite(spr_tempobox, 2 * (theme = 3) + 2 * (fdark && theme = 3), 108, 57 + song_tab_offset)
			else draw_sprite_ext(spr_tempobox_hires, 2 * (theme = 3) + 2 * (fdark && theme = 3), 108, 57 + song_tab_offset, 0.25, 0.25, 0, -1, 1)
		}
		
		if (window != w_settempo) {
		if (language != 1) {
		if (use_bpm) {
			bpm = current_song.tempo * 15
			draw_text_dynamic(136, 60 + song_tab_offset, string_format(bpm, 4, 2) + " BPM")
			popup_set(108, 57 + song_tab_offset, 64, 22, "Tempo of the song (measured in beats per minute).\nClick and drag to change. Click to enter value. Right-click for more options.")
		} else {
			draw_text_dynamic(136, 60 + song_tab_offset, string_format(current_song.tempo, 4, 2) + " t / s")
			popup_set(108, 57 + song_tab_offset, 64, 22, "Tempo of the song (measured in ticks per second).\nClick and drag to change. Click to enter value. Right-click for more options.")
		}
		} else {
		if (use_bpm) {
			bpm = current_song.tempo * 15
			draw_text_dynamic(136, 60 + song_tab_offset, string_format(bpm, 4, 2) + " BPM")
			popup_set(108, 57 + song_tab_offset, 64, 22, "歌曲的速度（拍数/分钟）\n拖拽来大致更改，点击来手动输入，右键查看更多选项。")
		} else {
			draw_text_dynamic(136, 60 + song_tab_offset, string_format(current_song.tempo, 4, 2) + " t / s")
			popup_set(108, 57 + song_tab_offset, 64, 22, "歌曲的速度（红石刻/秒）\n拖拽来大致更改，点击来手动输入，右键查看更多选项。")
		}
		}
		draw_set_halign(fa_left)
		a = mouse_rectangle(108, 57 + song_tab_offset, 64, 22)
		var bpm_multiplier = use_bpm ? 15 : 1
		if (a && window = 0) {
			curs = cr_handpoint
			
			// Input
			if (mouse_check_button_released(mb_left)) {
		        window = w_settempo
				text_exists[64] = 0
				text_focus = 64
			}
			// Drag
		    if (mouse_check_button(mb_left) && (mouse_x != mouse_xprev || mouse_y != mouse_yprev)) {
		        curs = cr_size_ns
				tempodrag = current_song.tempo
		        window = w_dragtempo
				if (tutorial_tempobox == 0) {
					if (language != 1) set_msg("Tip: click the tempo box\nto enter a value!", 7.0, 208, 118 + song_tab_offset)
					else set_msg("小贴士：单击速度框可以手动输入！", 7.0, 208, 118 + song_tab_offset)
					tutorial_tempobox = 1
				}
			}

		    if (mouse_check_button_pressed(mb_right)) {
				if (language != 1) menu = show_menu_ext("tempo", mouse_x, mouse_y, check(!use_bpm) + "Ticks per second (t/s)|" +
																check(use_bpm) + "Beats per minute (BPM)|-|" +
																check(current_song.tempo = 10) + string(10 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 12) + string(12 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 14) + string(14 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 16) + string(16 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 18) + string(18 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 20) + string(20 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 30) + string(30 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 60) + string(60 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|-|" +
																"Tempo tapper...")
				else menu = show_menu_ext("tempo", mouse_x, mouse_y, check(!use_bpm) + "红石刻/秒 (t/s)|" +
																check(use_bpm) + "拍数/分钟 (BPM)|-|" +
																check(current_song.tempo = 10) + string(10 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 12) + string(12 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 14) + string(14 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 16) + string(16 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 18) + string(18 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 20) + string(20 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 30) + string(30 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|" +
																check(current_song.tempo = 60) + string(60 * bpm_multiplier) + condstr(use_bpm, " BPM", " t/s") + "|-|" +
																"速度测量器......")
				if (tutorial_tempobox == 2) {
					if (language != 1) set_msg("Way to go!", 5.0, 158, 118 + song_tab_offset)
					else set_msg("干得好！", 5.0, 158, 118 + song_tab_offset)
					tutorial_tempobox = 3
				}
			}
		}
		if (window = w_dragtempo) {
		    curs = cr_size_ns
		    tempodrag += 0.25 * (mouse_yprev - mouse_y) / 3
		    tempodrag = median(0.25, tempodrag, 60)
		    a = current_song.tempo
		    current_song.tempo = floor(tempodrag * 4) / 4
		    if (a != current_song.tempo) current_song.changed = 1
		    if (!mouse_check_button(mb_left)) window = w_releasemouse
		}
		}
		}
		draw_set_halign(fa_left)
	}
	
	// Song Tabs
	if (array_length(songs) > 1 && !fullscreen) {
		if (tabdrag) {
			tabdest = (mouse_x - 7 + (tabwidth - 1) / 2) div (tabwidth - 1)
			if (tabdest >= array_length(songs)) tabdest = array_length(songs)
			if (tabdest < 0) tabdest = 0
		}
		if (theme != 3) {
			draw_sprite_ext(spr_songtab, 9 + 10 * theme, 0, 24 - 5 * (theme = 1 || theme = 2), rw / 4, 1, 0, -1, 1)
		} else {
			draw_theme_color()
			if (wpaperexist && acrylic && can_draw_mica) draw_set_alpha(0.8)
			draw_line(0, 19 + 39, rw, 19 + 39)
			draw_set_alpha(1)
		}
		for (tab = 0; tab < array_length(songs); tab++) {
			tab_str = ""
			taba = (mouse_rectangle(8 + tab * (tabwidth - 1) - 2, 24 + 2, tabwidth - 2, 24 + 5 * (theme = 3)) && (window = 0) && (!tabdrag))
			if (taba && mouse_check_button(mb_left)) taba += 1
			if (taba = 2) {
				set_song(tab)
			}
			if (theme != 3) {
				closea = mouse_rectangle(7 - 20 + (tabwidth - 1) + tab * (tabwidth - 1) - 1, 24 - 5 * (theme = 1 || theme = 2) + 7 + 3 * (theme != 0), 16, 15) * (window = 0) * (!tabdrag)
				if (closea && mouse_check_button(mb_left)) closea++
				draw_sprite_ext(spr_songtab, 0 + 3 * (taba = 1 && tab != song) + 6 * (tab = song) + 10 * theme, 6 + tab * (tabwidth - 1) - 1, 24 - 5 * (theme = 1 || theme = 2), 1, 1, 0, -1, 1)
				draw_sprite_ext(spr_songtab, 1 + 3 * (taba = 1 && tab != song) + 6 * (tab = song) + 10 * theme, 10 + tab * (tabwidth - 1) - 1, 24 - 5 * (theme = 1 || theme = 2), (tabwidth - 5) / 4, 1, 0, -1, 1)
				draw_sprite_ext(spr_songtab, 2 + 3 * (taba = 1 && tab != song) + 6 * (tab = song) + 10 * theme, 5 + (tabwidth - 1) + tab * (tabwidth - 1) - 1, 24 - 5 * (theme = 1 || theme = 2), 1, 1, 0, -1, 1)
				draw_sprite_ext(spr_frame4, closea + 3 * theme, 7 - 20 + (tabwidth - 1) + tab * (tabwidth - 1) - 1, 24 - 5 * (theme = 1 || theme = 2) + 7 + 3 * (theme != 0), 17/16, 1, 0, -1, 1)
				draw_sprite_ext(spr_closetab, (closea > 0 && theme = 0), 7 - 20 + (tabwidth - 1) + tab * (tabwidth - 1) - 1 + 4 + (closea = 2 && theme != 0), 24 - 5 * (theme = 1 || theme = 2) + 7 + 3 * (theme != 0) + 4 + (closea = 2 && theme != 0), 1, 1, 0, -1 + (theme = 1), 1)
			} else {
				closea = mouse_rectangle(7 + (tabwidth - 1) + tab * (tabwidth - 1) - 35, 24 + 5, 30, 22) * (window = 0) * (!tabdrag)
				if (closea && mouse_check_button(mb_left)) closea++
				if (wpaperexist && acrylic && can_draw_mica) {
					if (!fdark) {
						hover_color = make_color_rgb(45, 45, 45)
						sel_color = make_color_rgb(40, 40, 40)
						if (tab = song) {
							if (closea) close_color = make_color_rgb(53, 53, 53)
							if (closea = 2) close_color = make_color_rgb(48, 48, 48)
						} else {
							if (closea) close_color = make_color_rgb(57, 57, 57)
							if (closea = 2) close_color = make_color_rgb(53, 53, 53)
						}
					} else {
						hover_color = make_color_rgb(233, 233, 233)
						sel_color = make_color_rgb(249, 249, 249)
						if (tab = song) {
							if (closea) close_color = make_color_rgb(240, 240, 240)
							if (closea = 2) close_color = make_color_rgb(243, 243, 243)
						} else {
							if (closea) close_color = make_color_rgb(225, 225, 225)
							if (closea = 2) close_color = make_color_rgb(228, 228, 228)
						}
					}
				} else {
					if (fdark) {
						hover_color = make_color_rgb(45, 45, 45)
						sel_color = make_color_rgb(40, 40, 40)
						if (tab = song) {
							if (closea) close_color = make_color_rgb(53, 53, 53)
							if (closea = 2) close_color = make_color_rgb(48, 48, 48)
						} else {
							if (closea) close_color = make_color_rgb(57, 57, 57)
							if (closea = 2) close_color = make_color_rgb(53, 53, 53)
						}
					} else {
						hover_color = make_color_rgb(233, 233, 233)
						sel_color = make_color_rgb(249, 249, 249)
						if (tab = song) {
							if (closea) close_color = make_color_rgb(240, 240, 240)
							if (closea = 2) close_color = make_color_rgb(243, 243, 243)
						} else {
							if (closea) close_color = make_color_rgb(225, 225, 225)
							if (closea = 2) close_color = make_color_rgb(228, 228, 228)
						}
					}
				}
				draw_theme_color()
				if (wpaperexist && acrylic && can_draw_mica) draw_set_alpha(0.1)
				if (taba = 1) draw_set_color(hover_color)
				if (tab = song) draw_set_color(sel_color)
				if (taba = 1 || tab = song) draw_roundrect(7 + tab * (tabwidth - 1), 24 + 2 * (tab != song), 7 + (tabwidth - 1) + tab * (tabwidth - 1), 24 + 40 - 7, 0)
				if (closea) draw_set_color(close_color)
				if (closea) draw_roundrect(7 + (tabwidth - 1) + tab * (tabwidth - 1) - 35, 24 + 5, 7 + (tabwidth - 1) + tab * (tabwidth - 1) - 4, 24 + 28, 0)
				draw_set_alpha(0.5)
				draw_separator(7 + (tabwidth - 1) + tab * (tabwidth - 1) + 1, 24 + 8)
				draw_set_alpha(1)
				draw_sprite_ext(spr_closetab, 2 + (songs[tab].changed), 7 + (tabwidth - 1) + tab * (tabwidth - 1) - 35 + 12 + (os_type = os_windows), 24 + 5 + 7 + (os_type = os_windows), 1, 1, 0, -1 + (!fdark), 1)
			}
			if (taba = 1 && mouse_check_button_released(mb_right)) {
				menutab = tab
				if (language != 1) show_menu_ext("songtab", mouse_x, mouse_y, icon(icons.NEW) + get_hotkey("new_song") + "$New song|-|" + icon(icons.DELETE) + get_hotkey("close_song") + "$Close song|" + inactive(array_length(songs) <= 1) + "Close other songs|" + inactive(tab = array_length(songs) - 1) + "Close songs to the right")
				else show_menu_ext("songtab", mouse_x, mouse_y, icon(icons.NEW) + get_hotkey("new_song") + "$新文件|-|" + icon(icons.DELETE) + get_hotkey("close_song") + "$关闭歌曲|" + inactive(array_length(songs) <= 1) + "关闭其他歌曲|" + inactive(tab = array_length(songs) - 1) + "关闭右侧歌曲")
			}
			draw_theme_color()
			draw_theme_font(font_main)
			tab_str = songs[tab].song_title
			if (theme != 3) {
				if (string_width_dynamic(tab_str) > (tabwidth - 1) - 20 - 20 - 15 * (theme = 3)) {
					while (tab_str != "" && string_width_dynamic(tab_str) > (tabwidth - 1) - 20 - 15 * (theme = 3) - 20 - string_width_dynamic("...") - string_width_dynamic("*") * (songs[tab].changed && songs[tab].filename != "" && songs[tab].filename != "-player")) {
						tab_str = string_delete(tab_str, string_length(tab_str), 1)
					}
					tab_str += "..."
				}
				tab_str += condstr(songs[tab].changed && songs[tab].filename != "" && songs[tab].filename != "-player", "*")
			} else {
				if (string_width_dynamic(tab_str) > (tabwidth - 1) - 20 - 20 - 15 * (theme = 3)) {
					while (tab_str != "" && string_width_dynamic(tab_str) > (tabwidth - 1) - 20 - 15 * (theme = 3) - 20 - string_width_dynamic("...")) {
						tab_str = string_delete(tab_str, string_length(tab_str), 1)
					}
					tab_str += "..."
				}
			}
			draw_text_dynamic(16 + tab * (tabwidth - 1) - 1, song_tab_texty, tab_str)
			
			if (taba = 2 && (mouse_x != mouse_xprev || mouse_y != mouse_yprev)) {
				tabdrag = 1
				draggingtab = tab
				window = w_dragtab
			}
			
			if (closea && mouse_check_button_released(mb_left)) close_song(tab)
		}
		if (tabdrag) {
			draw_set_color(0)
			if (theme = 2 || (theme = 3 && fdark)) draw_set_color(c_white)
			draw_line(7 + tabdest * (tabwidth - 1) + 1 - 1, 24 + 8 - 5 - 5 * (theme != 3), 7 + tabdest * (tabwidth - 1) + 1 - 1, 24 + 8 + 5 - 5 * (theme != 3) + 18)
			curs = cr_drag
		}
		if (tabdrag && mouse_check_button_released(mb_left)) {
			array_insert(songs, tabdest, songs[draggingtab])
			array_delete(songs, draggingtab + (tabdest < draggingtab), 1)
			song = tabdest - (tabdest > draggingtab)
			draggingtab = -1
			//curs = cr_default
			window = 0
		}
		
		// new song button
		var newsongbtnwidth = 32
		taba = (mouse_rectangle(8 + array_length(songs) * (tabwidth - 1) - 2, 24 + 2, newsongbtnwidth - 2, 24 + 5 * (theme = 3)) && (window = 0) && (!tabdrag))
		if (taba && mouse_check_button_released(mb_left) && !tabdrag) taba += 1
		if (taba = 2) {
			new_song()
		}
		if (theme != 3) {
			draw_sprite_ext(spr_songtab, 0 + 3 * (taba = 1) + 10 * theme, 6 + array_length(songs) * (tabwidth - 1) - 1, 24 - 5 * (theme = 1 || theme = 2), 1, 1, 0, -1, 1)
			draw_sprite_ext(spr_songtab, 1 + 3 * (taba = 1) + 10 * theme, 10 + array_length(songs) * (tabwidth - 1) - 1, 24 - 5 * (theme = 1 || theme = 2), (newsongbtnwidth - 5) / 4, 1, 0, -1, 1)
			draw_sprite_ext(spr_songtab, 2 + 3 * (taba = 1) + 10 * theme, 5 + (newsongbtnwidth - 1) + array_length(songs) * (tabwidth - 1) - 1, 24 - 5 * (theme = 1 || theme = 2), 1, 1, 0, -1, 1)
		} else {
			if (wpaperexist && acrylic && can_draw_mica) {
				if (!fdark) {
					hover_color = make_color_rgb(45, 45, 45)
					sel_color = make_color_rgb(40, 40, 40)
				} else {
					hover_color = make_color_rgb(233, 233, 233)
					sel_color = make_color_rgb(249, 249, 249)
				}
			} else {
				if (fdark) {
					hover_color = make_color_rgb(45, 45, 45)
					sel_color = make_color_rgb(40, 40, 40)
				} else {
					hover_color = make_color_rgb(233, 233, 233)
					sel_color = make_color_rgb(249, 249, 249)
				}
			}
			draw_theme_color()
			if (wpaperexist && acrylic && can_draw_mica) draw_set_alpha(0.1)
			if (taba = 1) draw_set_color(hover_color)
			if (tab = song) draw_set_color(sel_color)
			if (taba = 1) draw_roundrect(7 + array_length(songs) * (tabwidth - 1), 24 + 2, 7 + (newsongbtnwidth - 1) + array_length(songs) * (tabwidth - 1), 24 + 40 - 7, 0)
			draw_set_alpha(1)
			draw_sprite_ext(spr_newtab, 0, 7 + array_length(songs) * (tabwidth - 1) + 15 - 6, 24 + 2 + 15 - 7, 1, 1, 0, -1 + (!fdark), 1)
		}
		
		if (draggingtab = -1) tabdrag = 0
	}

	// Piano
	if (!fullscreen && ((show_piano && !isplayer) || dropmode)) {
		if (!dropmode) draw_piano(floor(rw / 2 - (keysshow * 39) / 2), rh - 154, keysshow, totalcols)
		else draw_piano(floor(rw / 2 - (52 * 39) / 2), rh - 154, 52, totalcols)
		var key_count = (dropmode ? 52 : keysshow)
		if (mouse_rectangle(floor(rw / 2 - (key_count * 39) / 2), rh - 162, key_count * 39, 136) && window = 0) curs = cr_handpoint
	}

	// End selecting
	if (select > 0) {
	    if (!mouse_check_button(mb_left) && select = 1) {
	        selection_add(select_pressa, select_pressb, selbx, selby, keyboard_check(vk_alt), 0)
	        window = w_releasemouse
	        select = 0
	        select_pressx = -1
	        select_pressy = -1
	        select_pressa = -1
	        select_pressb = -1
	    }
	    if (select = 2) curs = cr_handpoint
	    if (!mouse_check_button(mb_right) && select = 2) {
	        selection_remove(select_pressa, select_pressb, selbx, selby, 0, 0)
	        window = w_releasemouse
	        select = 0
	        select_pressx = -1
	        select_pressy = -1
	        select_pressa = -1
	        select_pressb = -1
	    }
	}

	if (mouse_check_button_released(mb_left)) {
	    w_isdragging = 0
	}
	if (window = w_releasemouse && !mouse_check_button(mb_left)) {window = 0 windowopen = 0}
	draw_windows()
	if (showmsg) draw_msg()
	if (rainbowtoggle) draw_accent_rainbow()
	if (dndfile != "") {
		if (filename_ext(dndfile) = ".nbp") pattern_import(dndfile, 1)
		else if (lastfile != dndfile) {
			load_song(dndfile)
			lastfile = dndfile
		}
		// Reset dndfile
		file_dnd_set_enabled(false)
		file_dnd_set_enabled(true)
		dndfile = ""
}

	// Draw update progress bar
	if (update == 4) {
		window = -1
		if (language != 1) draw_downloadprogress("Update", "Downloading update...", downloaded_size, total_size)
		else draw_downloadprogress("更新", "正在下载更新......", downloaded_size, total_size)
	}
	
	// Draw song download progress bar
	if (protocol_data != pointer_null && song_download_status < 2) {
		window = -1
		if (language != 1) draw_downloadprogress("Download", "Downloading song...", song_downloaded_size, song_total_size)
		else draw_downloadprogress("下载", "正在下载乐曲......", song_downloaded_size, song_total_size)
	}
	
	// Draw debug overlay
	if (debug_overlay) draw_debug_overlay()
	if (logs_overlay) draw_logs_overlay(500, 40)
	
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) window_set_cursor(curs)
	mouse_xprev = mouse_x
	mouse_yprev = mouse_y
	
	if (remove_emitters_all_schedule) remove_emitters_all()
	
	// Detect when windows have changed
	/*if window != prevwindow {
		show_debug_message(string(window) + " " + string(prevwindow))
	}*/
	prevwindow = window
}
