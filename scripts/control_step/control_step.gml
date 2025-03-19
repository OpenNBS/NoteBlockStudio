function control_step() {
	var current_song = songs[song]
	
	var targetspeed = 1000000 / room_speed
	currspeed = targetspeed / delta_time
	
	if (1 / currspeed > 100.0) { // Cancel lag compensation if too much time has elapsed (i.e. dragging window, resizing etc.)
		currspeed = 1.0
	}
	
	update_window()
	if (os_version > 393217 && os_type = os_windows){
	if (songs[song].enda = 0 || !taskbar) {
		window_noprogress(window_handle())
	} else {
		if (playing) window_normal(window_handle())
		else window_paused(window_handle())
		window_value(window_handle(), songs[song].marker_pos, songs[song].enda)
	}
	}
	if (current_time - pingtime >= 1000){
	if (presence && obj_presence.ready) {
		if (NOT_RUN_FROM_IDE != 1) np_setpresence(condstr(songs[song].totalblocks > 0, string_format_thousands(songs[song].totalblocks) + " note" + condstr(songs[song].totalblocks > 1, "s") + " placed"), "Debugging", condstr(window_icon, "note", "noteflat"), "")
		else np_setpresence(condstr(songs[song].totalblocks > 0, string_format_thousands(songs[song].totalblocks) + " note" + condstr(songs[song].totalblocks > 1, "s") + condstr(!isplayer, " placed")), condstr((songs[song].filename = "" || songs[song].filename = "-player") && !isplayer, "Unsaved song") + condstr(songs[song].filename != "" && songs[song].filename != "-player" && !isplayer, "Editing ") + condstr(((songs[song].filename != "" && songs[song].filename != "-player") || songs[song].midiname != "") && isplayer, "Listening to ") + condstr(songs[song].filename != "-player", filename_name(songs[song].filename)) + condstr((songs[song].filename = "" || songs[song].filename = "-player") && songs[song].midiname != "" && isplayer, songs[song].midiname), condstr(window_icon, "note", "noteflat"), "")
	} else {
		np_clearpresence()
	}
	pingtime = current_time
	}
	if (window_icon != last_icon) {
		icon_time = current_time
		icon_display = 1
	}
	if (current_time - icon_time >= 1000 && icon_time != -1) {
		icon_display = 0
		icon_time = -1
	}
	last_icon = window_icon
	
	if (channelstoggle) channels = 1024
	else channels = 256
	audio_channel_num(channels)
	update_window_icon()
	
	if (mouse_check_button_pressed(mb_left)) {
		mousepress_x = mouse_x
		mousepress_y = mouse_y
	}
	
	if (is_mobile()) {
		if (text_focus != text_focus_last){
			if (text_focus = -1) keyboard_virtual_hide()
			else if (text_focus_last = -1) keyboard_virtual_show(kbv_type_ascii, kbv_returnkey_default, kbv_autocapitalize_none, false)
		}
	}
	
	// handle midi messages
	var b,i,listMessage;
	ds_list_clear(midiMessages)//midiMessages is a ds_list that was created previously, and holds all MIDI messages that came in on this step
	b = rtmidi_check_message()	
	while b > 0 {
		listMessage = ds_list_create()
		for (i = 0; i < b; i += 1){	
			ds_list_add(listMessage,rtmidi_get_message(i))		
			}		
		ds_list_add(midiMessages,listMessage)	
		b = rtmidi_check_message()	
	}
	for (i = 0; i < ds_list_size(midiMessages); i++) {
		var midi_status = midiMessages[| i][| 0]
		var midi_msg1 = midiMessages[| i][| 1]
		var midi_msg2 = midiMessages[| i][| 2]
		ds_list_destroy(midiMessages[| i])
		
		if (midi_status == 144 && midi_msg2 == 0) midi_status = 128; // Key press at volume 0 = release
	    switch (midi_status) {
	        case 128: { // Key release (msg1: note)
	            //key.time = time;
	            ds_list_add(midi_keyreleases, midi_msg1);
	            break;
	        }
	        case 144: { // Key press (msg1: note, msg2: velocity)
	            //key.time = time;
	            ds_list_add(midi_keypresses, [midi_msg1, midi_msg2]);
	            break;
	        }
	        //case 11: { // Control (msg1: type, msg2: data)
	        //    devices.at(deviceN).control[midi_msg1] = midi_msg2;
	        //    break;
	        //}
	        //case 12: { // Patch change (msg1: patch)
	        //    if (time - devices.at(deviceN).lastMessage < 100) break; // Patch change sends two messages? Only first one is correct
	        //    devices.at(deviceN).instrument = midi_msg1;
	        //    devices.at(deviceN).lastMessage = time;
	        //    break;
	        //}
	        //case 14: { // Pitch wheel change (msg2: value)
	        //    devices.at(deviceN).pitchWheel = midi_msg2;
	        //    break;
	        //}
	    }
		// show_debug_message("status: " + string(midi_status) + ", msg1: " + string(midi_msg1) + ", msg2: " + string(midi_msg2))
	}
	
	// update tabs name and window title accordingly
	update_tabs_name()
	update_window_caption(current_song)
	
	update_refreshrate()
	
	// time dependent updates
	editline += 30 / (room_speed) * (1 / currspeed)
	if (editline > 60) editline = 0
	if (delay > 0) delay -= 1 / (room_speed / 20)
	if (delay < 0) delay = 0
	if (!isplayer) {
		current_song.work_mins += 1 / (room_speed * 60)  * (1 / currspeed)
	}
	
	// get drag and drop files
	file_dnd_set_files("*.nbs;*.mid;*.midi;*.nbp;*.zip", 1, 0, 0)
	dndfile = file_dnd_get_files()

	// remove sound instances that are time to remove
	remove_emitters()

	// update minecraft compatible status
	update_compatible(current_song)
	
	sela = -1
	selb = -1
	selbx = -1
	selby = -1
	if (window = 0) {
	    if (mouse_check_button_pressed(mb_left)) {
	        if (!isplayer) current_song.work_left += 1
	        key_edit = -1
	    }
	    if (mouse_check_button_pressed(mb_right)) {
			if (!isplayer) current_song.work_right += 1
		}
	}

	if (key_edit > -1) {
	    if (!show_keyboard) key_edit = -1
	    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_escape)) {
	        piano_key[key_edit] = 0
	        key_edit = -1
			save_settings()
	    } else if (keyboard_check_pressed(vk_anykey)) {
	        piano_key[key_edit] = keyboard_lastkey
	        key_edit = -1
			save_settings()
	    }
	}

	if (!isplayer) {
	// Autosave
	if (autosave && filename_ext(current_song.filename) = ".nbs") {
	    tonextsave -= 1 / room_speed / 60 * (1 / currspeed)
	    if (tonextsave <= 0 && playing == 0) {
			tonextsave = autosavemins
			save_song(current_song.filename, true)
		}
	}

	// Auto-recovery
	if (current_song.totalblocks > 0) {
		tonextbackup -= 1 / room_speed / 60 * (1 / currspeed)
		if (tonextbackup <= 0 && playing == 0) {
		    for (var sss = 0; sss < array_length(songs); sss++) {
                if (filename_name(songs[sss].filename) != "") {
                    songs[sss].song_backupname = filename_name(filename_change_ext(songs[sss].filename, ".nbs"));
                } else {
                    songs[sss].song_backupname = "Unsaved song " + string(songs[sss].song_backupid) + ".nbs"
                }
                save_song(backup_directory + songs[sss].song_backupname, true)
			}
			tonextbackup = backupmins
		}
	}

	// Toggle fullscreen
	if (keyboard_check_pressed(vk_f11)) {
		fullscreen = !fullscreen
		if (language != 1) {
		if (fullscreen) set_msg("Fullscreen => ON")
		else set_msg("Fullscreen => OFF")
		} else {
		if (fullscreen) set_msg("全屏模式 => 开启")
		else set_msg("全屏模式 => 关闭")
		}
	}
	}
	
	// Toggle blackout mode
	if (keyboard_check_pressed(vk_f10)) {
		blackout = !blackout
		if (language != 1) {
		if (blackout) set_msg("Blackout mode => ON")
		else set_msg("Blackout mode => OFF")
		} else {
		if (blackout) set_msg("全黑模式 => 开启")
		else set_msg("全黑模式 => 关闭")
		}
	}
	
	// Play column
	if (floor(current_song.marker_pos) != floor(current_song.marker_prevpos) && floor(current_song.marker_pos) <= current_song.enda && (floor(current_song.marker_pos) != current_song.section_end || window = w_dragmarker || forward<>0 || marker_end = 0 || current_song.marker_prevpos >= current_song.section_end)) {
	    var diff = floor(current_song.marker_pos) - floor(current_song.marker_prevpos)
	    var start
	    if (!playing || diff < 0 || diff > 3) {
	        start = floor(current_song.marker_pos)
	    } else {
	        start = floor(current_song.marker_prevpos) + 1
	    }
	    for (i = start; i <= floor(current_song.marker_pos); i++) {
	        xx = i
		    if (current_song.colamount[xx] > 0) {
		        for (b = current_song.colfirst[xx]; b <= current_song.collast[xx]; b += 1) {
		            if (current_song.song_exists[xx, b]) {
		                a = 1
						c = 1
						d = 0
						e = 0
		                if (b < current_song.endb2) {
							c = (current_song.layervol[b] /100) * current_song.song_vel[xx, b]
							if current_song.layerstereo[b] = 100 {
								d = current_song.song_pan[xx, b]
							} else { 
								d = (current_song.layerstereo[b] + current_song.song_pan[xx, b]) / 2
							}
							e = current_song.song_pit[xx, b]
						}
		                if (current_song.solostr != "") {
		                    if (string_count("|" + string(b) + "|", current_song.solostr) = 0) {
		                        a = 0
		                    } else if (current_song.layerlock[b] = 1) {
		                        a = 0
		                    }
		                } else if (b < current_song.endb2) {
		                    if (current_song.layerlock[b] = 1) {
		                        a = 0
		                    }
		                }
		                if (record = 1 && playing = 1) {
		                    if (current_time - current_song.song_added[xx, b] < 1000) a = 0
		                }
		                if (a) {
							var insname = current_song.instrument_list[| ds_list_find_index(current_song.instrument_list, current_song.song_ins[xx, b])].name
		                    if (current_song.song_ins[xx, b].loaded && c > 0 && current_song.reference_option != 1) play_sound(current_song.song_ins[xx, b], current_song.song_key[xx, b], c , d, e, b + 1)
							if (insname = "Tempo Changer") current_song.tempo = floor(abs(e)) / 15
							if (insname = "Toggle Rainbow") {rainbowtoggle = !rainbowtoggle draw_accent_init()}
							if (insname = "Sound Stopper") {remove_emitters_all(floor(e), floor(d - 100))}
							if (insname = "Show Save Popup") set_msg("Song saved")
							if (string_count(string_lower("Change Color to #"), string_lower(insname)) = 1) {
								draw_set_accent(real("0x" + string_copy(insname, 17, 2)), real("0x" + string_copy(insname, 19, 2)), real("0x" + string_copy(insname, 21, 2)))
								show_debug_message("Change Color to " + string(real("0x" + string_copy(insname, 17, 2))) + string(real("0x" + string_copy(insname, 19, 2))) + string(real("0x" + string_copy(insname, 21, 2))))
							}
		                    if (current_song.song_ins[xx, b].press || isplayer) key_played[current_song.song_key[xx, b]] = current_time
		                    current_song.song_played[xx, b] = current_time
		                }
		            }
		        }
		    }
		}
	}
	if (wpaperanchor = 1) wpaperside = (window_width / window_height < sprite_get_width(wpaper) / sprite_get_height(wpaper))
}
