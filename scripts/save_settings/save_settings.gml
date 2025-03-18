function save_settings() {
	// save_settings()
	var a;

	if (is_prerelease) {
		ini_open(settings_dev_file)
	} else {
		ini_open(settings_file)
	}

	// Recent songs
	for (a = 0; a < 11; a += 1) {
	    ini_write_string(    "recent", "recent_song_" + string(a) + "_path", recent_song[a])
	    ini_write_real_clean("recent", "recent_song_" + string(a) + "_time", recent_song_time[a])
	}
	// Preferences
	ini_write_string(    "preferences", "last_version",       version)
	ini_write_real_clean("preferences", "check_update",       check_update)
	ini_write_real_clean("preferences", "check_prerelease",   check_prerelease)
	ini_write_real_clean("preferences", "show_welcome",       show_welcome)
	ini_write_real_clean("preferences", "autosave",           autosave)
	ini_write_real_clean("preferences", "autosavemins",       autosavemins)
	ini_write_real_clean("preferences", "theme",              theme)
	ini_write_real_clean("preferences", "blackout",           blackout)
	ini_write_real_clean("preferences", "window_scale",       window_scale)
	ini_write_real_clean("preferences", "refresh_rate",       refreshrate)
	ini_write_string(    "preferences", "song_folder",        songfolder)
	ini_write_string(    "preferences", "pattern_folder",     patternfolder)
	ini_write_string(    "preferences", "show_oldwarning",    show_oldwarning)
	ini_write_real_clean("preferences", "use_colors",         use_colors)
	ini_write_real_clean("preferences", "use_icons",          use_icons)
	ini_write_real_clean("preferences", "use_shapes",         use_shapes)
	ini_write_real_clean("preferences", "show_numbers",       show_numbers)
	ini_write_real_clean("preferences", "show_octaves",       show_octaves)
	ini_write_real_clean("preferences", "show_incompatible",  show_incompatible)
	ini_write_real_clean("preferences", "use_fading",         fade)
	ini_write_real_clean("preferences", "show_layers",        show_layers)
	ini_write_real_clean("preferences", "show_piano",         show_piano)
	ini_write_real_clean("preferences", "keys_to_show",       keysmax)
	ini_write_real_clean("preferences", "show_keynames",      show_keynames)
	ini_write_real_clean("preferences", "show_keynumbers",    show_keynumbers)
	ini_write_real_clean("preferences", "show_keyboard",      show_keyboard)
	ini_write_real_clean("preferences", "show_notechart",     show_notechart)
	ini_write_real_clean("preferences", "show_outofrange",    show_outofrange)
	ini_write_real_clean("preferences", "mousewheel",         mousewheel)
	ini_write_real_clean("preferences", "change_pitch",       changepitch)
	ini_write_real_clean("preferences", "select_lastpressed", select_lastpressed)
	ini_write_real_clean("preferences", "marker_follow",      marker_follow)
	ini_write_real_clean("preferences", "marker_pagebypage",  marker_pagebypage)
	ini_write_real_clean("preferences", "marker_start",       marker_start)
	ini_write_real_clean("preferences", "marker_end",         marker_end)
	ini_write_real_clean("preferences", "show_layer_volumes", realvolume)
	ini_write_real_clean("preferences", "use_stereo",         realstereo)
	//ini_write_real_clean("preferences", "loop_to_bar_end",    looptobarend)
	ini_write_real_clean("preferences", "show_soundcount",    show_soundcount)
	ini_write_real_clean("preferences", "use_bpm",            use_bpm)
	ini_write_real_clean("preferences", "save_version",       save_version)
	ini_write_real_clean("preferences", "channelstoggle",     channelstoggle)
	ini_write_real_clean("preferences", "presence",           presence)
	ini_write_real_clean("preferences", "windowsound",        windowsound)
	ini_write_real_clean("preferences", "fdark",              fdark)
	ini_write_real_clean("preferences", "tapdouble",          tapdouble)
	ini_write_real_clean("preferences", "accent1",            accent1)
	ini_write_real_clean("preferences", "accent2",            accent2)
	ini_write_real_clean("preferences", "accent3",            accent3)
	ini_write_real_clean("preferences", "structure",          structure)
	ini_write_real_clean("preferences", "percentvel",         percentvel)
	ini_write_real_clean("preferences", "addpitch",           addpitch)
	ini_write_real_clean("preferences", "language",           language)
	ini_write_real_clean("preferences", "acrylic",            acrylic)
	ini_write_real_clean("preferences", "taskbar",            taskbar)
	ini_write_real_clean("preferences", "remove_effect",      remove_effect)
	ini_write_real_clean("preferences", "window_icon",        window_icon)
	ini_write_real_clean("preferences", "keynames_flat",      keynames_flat)
	ini_write_real_clean("preferences", "hires",              hires)
	ini_write_string(    "preferences", "current_resource",   current_resource)
	ini_write_real_clean("preferences", "acrylic_successful", acrylic_successful)
	ini_write_real_clean("preferences", "advancedinterface",  advancedinterface)
	ini_write_real_clean("preferences", "wpapernoblur",       wpapernoblur)
	ini_write_real_clean("preferences", "wpapernodim",        wpapernodim)
	ini_write_real_clean("preferences", "noeditingbackground",noeditingbackground)

	// Midi import settings
	ini_write_real_clean("midi_import", "remember",        w_midi_remember)
	ini_write_real_clean("midi_import", "remove_silent",   w_midi_removesilent)
	ini_write_real_clean("midi_import", "name",            w_midi_name)
	ini_write_real_clean("midi_import", "name_patch",      w_midi_name_patch)
	ini_write_real_clean("midi_import", "maxheight",       w_midi_maxheight)
	ini_write_real_clean("midi_import", "enable_velocity", w_midi_vel)
	ini_write_real_clean("midi_import", "tempo",           w_midi_tempo)
	ini_write_real_clean("midi_import", "octave",          w_midi_octave)
	ini_write_real_clean("midi_import", "precision",       w_midi_precision)
	ini_write_real_clean("midi_import", "tempo_changer",   w_midi_tempo_changer)
	ini_write_real_clean("midi_import", "note_duration",   w_midi_note_duration)
	// instruments
	for (a = 0; a < 128; a += 1) {
	    ini_write_real_clean("midi_import", "ins_" + string(a),          midi_ins[a, 1]) // Instrument
	    ini_write_real_clean("midi_import", "ins_" + string(a) + "_oct", midi_ins[a, 2]) // Octave
	}
	// drums
	for (a = 24; a < 88; a += 1) {
	    ini_write_real_clean("midi_import", "drum_" + string(a),          midi_drum[a, 1]) // Instrument
	    ini_write_real_clean("midi_import", "drum_" + string(a) + "_key", midi_drum[a, 2]) // Key
	}

	// Schematic export settings
	ini_write_real_clean("schematic_export", "use_old_format", sch_exp_minecraft_old)
	ini_write_real_clean("schematic_export", "walkway_block",  sch_exp_walkway_block)
	ini_write_real_clean("schematic_export", "walkway_data",   sch_exp_walkway_data)
	ini_write_real_clean("schematic_export", "circuit_block",  sch_exp_circuit_block)
	ini_write_real_clean("schematic_export", "circuit_data",   sch_exp_circuit_data)
	ini_write_real_clean("schematic_export", "ground_block",   sch_exp_ground_block)
	ini_write_real_clean("schematic_export", "ground_data",    sch_exp_ground_data)
	ini_write_real_clean("schematic_export", "layout",         sch_exp_layout)
	ini_write_real_clean("schematic_export", "notes_per_row",  sch_exp_notesperrow)
	ini_write_real_clean("schematic_export", "include_locked", sch_exp_includelocked)
	ini_write_real_clean("schematic_export", "compress",       sch_exp_compress)
	ini_write_real_clean("schematic_export", "loop",           sch_exp_loop)
	ini_write_real_clean("schematic_export", "glass",          sch_exp_glass)
	ini_write_real_clean("schematic_export", "minecart",       sch_exp_minecart)
	ini_write_real_clean("schematic_export", "chest",          sch_exp_chest)
	for (a = 0; a < 256; a += 1) {
		// The default value for ID and data are 1 and 0, respectively, so we may avoid writing these entries
		if (sch_exp_ins_block[a] != 1) {
		    ini_write_real_clean("schematic_export", "ins_block_" + string(a), sch_exp_ins_block[a])
		}
		if (sch_exp_ins_data[a] != 0) {
			ini_write_real_clean("schematic_export", "ins_data_"  + string(a), sch_exp_ins_data[a])
		}
	}
	ini_write_real_clean("schematic_export", "command_block",  command_block)

	// Branch export settings
	ini_write_real_clean("branch_export", "stereo",      sch_exp_stereo)
	ini_write_real_clean("branch_export", "velocity",    sch_exp_velocity)
	ini_write_real_clean("branch_export", "circuitry",   sch_exp_circuitry)
	ini_write_real_clean("branch_export", "vertical",    sch_exp_vertical)
	ini_write_real_clean("branch_export", "polyphony",   sch_exp_polyphony)
	ini_write_real_clean("branch_export", "layer1",      sch_exp_layer1)
	ini_write_real_clean("branch_export", "layer2",      sch_exp_layer2)
	ini_write_real_clean("branch_export", "layer3",      sch_exp_layer3)
	ini_write_real_clean("branch_export", "range_start", sch_exp_range_start)
	ini_write_real_clean("branch_export", "range_end",   sch_exp_range_end)

	// Datapack export settings
	ini_write_string(    "datapack_export", "name",          dat_name)
	ini_write_string(    "datapack_export", "namespace",     dat_namespace)
	ini_write_string(    "datapack_export", "path",          dat_path)
	ini_write_string(    "datapack_export", "source",        dat_source)
	ini_write_real_clean("datapack_export", "mcversion",     dat_mcversion)
	ini_write_real_clean("datapack_export", "use_zip",       dat_usezip)
	ini_write_real_clean("datapack_export", "locked",        dat_includelocked)
	ini_write_real_clean("datapack_export", "out_of_range",  dat_includeoutofrange)
	ini_write_real_clean("datapack_export", "enable_radius", dat_enableradius)
	ini_write_real_clean("datapack_export", "radius",        dat_radius)
	ini_write_real_clean("datapack_export", "looping",       dat_enablelooping)
	ini_write_real_clean("datapack_export", "visualizer",    dat_visualizer)
	ini_write_string(    "datapack_export", "vis_type",      dat_vis_type)
	ini_write_real_clean("datapack_export", "vis_glow",      dat_glow)
	ini_write_real_clean("datapack_export", "vis_x",         dat_xval)
	ini_write_real_clean("datapack_export", "vis_y",         dat_yval)
	ini_write_real_clean("datapack_export", "vis_z",         dat_zval)

	// Keyboard keys
	for (a = 0; a < 88; a += 1) ini_write_real_clean("piano_keys", "piano_key_" + string(a), piano_key[a])

	// Default instrument presses
	for (a = 0; a < first_custom_index; a += 1) {
		var ins = ds_list_find_value(songs[song].instrument_list, a)
		ini_write_real_clean("instruments", "ins_" + string(a) + "_press", ins.press)
	}

	// Warnings
	ini_write_real_clean("warnings", "octaves",    warning_octaves)
	ini_write_real_clean("warnings", "instrument", warning_instrument)
	ini_write_real_clean("warnings", "schematics", warning_schematic)
	ini_write_real_clean("warnings", "tempobox", tutorial_tempobox)
	ini_write_real_clean("warnings", "donate_banner_time", donate_banner_time)

	ini_close()
	return 1



}
