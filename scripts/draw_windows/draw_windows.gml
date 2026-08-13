function draw_windows() {
	// draw_windows()

	if (window = 0) {
		windowopen = 0
		windowanim = 0
		return 0
	}
	
	if (windowanim = 1) {
		if (theme = 3) {
			draw_set_color(0)
			draw_set_alpha(windowalpha * 0.5)
			draw_rectangle(0, 0, rw, rh, false)
		}
		anim_window_open()
	}

	// Window keyboard shortcuts are captured once per frame. Text editors mark
	// themselves active while drawing so Enter remains available to the editor.
	var keyboard_window = window
	window_text_input_active = false
	window_drawn_this_frame = false
	window_enter_pressed = keyboard_check_pressed(vk_enter)
		&& (windowopen = 1 || theme != 3)
		&& wmenu = 0
		&& !instance_exists(obj_menu)
	window_escape_pressed = keyboard_check_pressed(vk_escape)
		&& (windowopen = 1 || theme != 3)

	// Escape dismisses an open drop-down/context menu before the window itself.
	if (window_escape_pressed && (wmenu != 0 || instance_exists(obj_menu))) {
		with (obj_menu) instance_destroy()
		window = window mod w_menu
		wmenu = 0
		window_escape_pressed = false
	}
	
	draw_set_alpha(windowalpha)
	key_edit = -1
	switch (window mod w_menu) {
	    case w_greeting: draw_window_greeting() break
	    case w_songinfo: draw_window_songinfo() break
	    case w_songinfoedit: draw_window_songinfo() break
	    case w_preferences: draw_window_preferences() break
	    case w_midi: draw_window_midi_import() break
	    case w_schematic_export: draw_window_schematic_export() break
		case w_datapack_export: draw_window_datapack_export() break
		case w_mp3_export: draw_window_mp3_export() break
	    case w_instruments: draw_window_instruments() break
	    case w_stats: draw_window_stats() break
	    case w_properties: draw_window_properties() break
	    case w_about: draw_window_about() break
	    case w_minecraft: draw_window_minecraft() break
	    case w_update: draw_window_update() break
	    case w_changelist: draw_window_update() break
	    case w_mididevices: draw_window_mididevices() break
	    case w_clip_editor: draw_window_clip_editor() break
	    case w_stereo: draw_window_macro_stereo() break
	    case w_arpeggio: draw_window_macro_arpeggio() break
	    case w_tremolo: draw_window_macro_tremolo() break
	    case w_stagger: draw_window_macro_stagger() break
	    case w_portamento: draw_window_macro_portamento() break
	    case w_saveoptions: draw_window_save_options() break
	    case w_setvelocity: draw_window_macro_setvelocity() break
	    case w_setpanning: draw_window_macro_setpanning() break
		case w_setpitch: draw_window_macro_setpitch() break
	    case w_branch_export: draw_window_branch_export() break
	    case w_settempo: draw_window_set_tempo() break
	    case w_tempotapper: draw_window_tempo_tapper() break
	    case w_setaccent: draw_window_set_accent() break
	    case w_track_export: draw_window_track_export() break
		case w_sound_import: draw_window_sound_import() break
		case w_edit_tempo_changer: draw_window_edit_tempo_changer() break
		case w_edit_sound_stopper: draw_window_edit_sound_stopper() break
	}

	// If the window did not already handle Escape, close it without invoking its
	// primary action. Preserve the few dialogs whose Cancel button has cleanup or
	// returns to a parent window.
	if (window_escape_pressed && window_drawn_this_frame && window = keyboard_window) {
		text_focus = -1
		switch (keyboard_window) {
			case w_midi:
				songs[song].midifile = ""
				w_midi_tab = 0
				windowclose = 1
			break
			case w_branch_export:
				selected_tab_sch = 0
				windowclose = 1
			break
			case w_tempotapper:
				taptempo = 0
				tapping = 0
				ltime = 0
				windowclose = 1
			break
			case w_setaccent:
				window = w_preferences
			break
			case w_update:
				window = w_greeting
				save_settings()
			break
			case w_preferences:
				save_settings()
				windowclose = 1
			break
			default:
				windowclose = 1
		}
	}
	draw_set_alpha(1)
}
