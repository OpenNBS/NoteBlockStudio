function load_settings() {
	// load_settings()
	var a;
	log("Load settings")
	if (is_prerelease && file_exists(settings_dev_file)) {
		ini_open(settings_dev_file);
	} else if (file_exists(settings_file)) {
		ini_open(settings_file);
	} else {
		return;
	}

	// Recent songs
	for (a = 0; a < 11; a += 1) {
	    recent_song[a] =      ini_read_string("recent", "recent_song_" + string(a) + "_path", recent_song[a])
	    recent_song_time[a] = ini_read_string("recent", "recent_song_" + string(a) + "_time", recent_song_time[a])
	}
	// Preferences
	vers =               ini_read_string("preferences", "last_version",       version)
	check_update =       ini_read_real(  "preferences", "check_update",       check_update)
	check_prerelease =   ini_read_real(  "preferences", "check_prerelease",   check_prerelease)
	show_welcome =       ini_read_real(  "preferences", "show_welcome",       show_welcome)
	autosave =           ini_read_real(  "preferences", "autosave",           autosave)
	autosavemins =       ini_read_real(  "preferences", "autosavemins",       autosavemins)
	theme =              ini_read_real(  "preferences", "theme",              theme)
	blackout =           ini_read_real(  "preferences", "blackout",           blackout)
	window_scale =       ini_read_real(  "preferences", "window_scale",       window_scale)
	refreshrate =        ini_read_real(  "preferences", "refresh_rate",       refreshrate)
	show_oldwarning =    ini_read_string("preferences", "show_oldwarning",    show_oldwarning)
	songfolder =         ini_read_string("preferences", "song_folder",        songfolder)
	patternfolder =      ini_read_string("preferences", "pattern_folder",     patternfolder)
	use_colors =         ini_read_real(  "preferences", "use_colors",         use_colors)
	use_icons =          ini_read_real(  "preferences", "use_icons",          use_icons)
	use_shapes =         ini_read_real(  "preferences", "use_shapes",         use_shapes)
	show_numbers =       ini_read_real(  "preferences", "show_numbers",       show_numbers)
	show_octaves =       ini_read_real(  "preferences", "show_octaves",       show_octaves)
	show_incompatible =  ini_read_real(  "preferences", "show_incompatible",  show_incompatible)
	fade =               ini_read_real(  "preferences", "use_fading",         fade)
	show_layers =        ini_read_real(  "preferences", "show_layers",        show_layers)
	show_piano =         ini_read_real(  "preferences", "show_piano",         show_piano)
	keysmax =            ini_read_real(  "preferences", "keys_to_show",       keysmax)
	show_keynames =      ini_read_real(  "preferences", "show_keynames",      show_keynames)
	show_keynumbers =    ini_read_real(  "preferences", "show_keynumbers",    show_keynumbers)
	show_keyboard =      ini_read_real(  "preferences", "show_keyboard",      show_keyboard)
	show_notechart =     ini_read_real(  "preferences", "show_notechart",     show_notechart)
	show_outofrange =    ini_read_real(  "preferences", "show_outofrange",    show_outofrange)
	mousewheel =         ini_read_real(  "preferences", "mousewheel",         mousewheel)
	changepitch =        ini_read_real(  "preferences", "change_pitch",       changepitch)
	select_lastpressed = ini_read_real(  "preferences", "select_lastpressed", select_lastpressed)
	marker_follow =      ini_read_real(  "preferences", "marker_follow",      marker_follow)
	marker_pagebypage =  ini_read_real(  "preferences", "marker_pagebypage",  marker_pagebypage)
	marker_start =       ini_read_real(  "preferences", "marker_start",       marker_start)
	marker_end =         ini_read_real(  "preferences", "marker_end",         marker_end)
	realvolume =         ini_read_real(  "preferences", "show_layer_volumes", realvolume)
	realstereo =         ini_read_real(  "preferences", "use_stereo",         realstereo)
	//looptobarend =       ini_read_real(  "preferences", "loop_to_bar_end",    looptobarend)
	show_soundcount =    ini_read_real(  "preferences", "show_soundcount",    show_soundcount)
	use_bpm =            ini_read_real(  "preferences", "use_bpm",            use_bpm)
	save_version =       ini_read_real(  "preferences", "save_version",       save_version)
	channelstoggle =     ini_read_real(  "preferences", "channelstoggle",     channelstoggle)
	presence =           ini_read_real(  "preferences", "presence",           presence)
	windowsound =        ini_read_real(  "preferences", "windowsound",        windowsound)
	fdark =              ini_read_real(  "preferences", "fdark",              fdark)
	tapdouble =          ini_read_real(  "preferences", "tapdouble",          tapdouble)
	accent1 =            ini_read_real(  "preferences", "accent1",            accent1)
	accent2 =            ini_read_real(  "preferences", "accent2",            accent2)
	accent3 =            ini_read_real(  "preferences", "accent3",            accent3)
	structure =          ini_read_real(  "preferences", "structure",          structure)
	percentvel =         ini_read_real(  "preferences", "percentvel",         percentvel)
	addpitch =           ini_read_real(  "preferences", "addpitch",           addpitch)
	language =           ini_read_real(  "preferences", "language",           language)
	acrylic =            ini_read_real(  "preferences", "acrylic",            acrylic)
	taskbar =            ini_read_real(  "preferences", "taskbar",            taskbar)
	remove_effect =      ini_read_real(  "preferences", "remove_effect",      remove_effect)
	window_icon =        ini_read_real(  "preferences", "window_icon",        window_icon)
	keynames_flat =      ini_read_real(  "preferences", "keynames_flat",      keynames_flat)
	hires =              ini_read_real(  "preferences", "hires",              hires)
	current_resource =   ini_read_string("preferences", "current_resource",   current_resource)
	acrylic_successful = ini_read_real(  "preferences", "acrylic_successful", acrylic_successful)
	advancedinterface  = ini_read_real(  "preferences", "advancedinterface",  advancedinterface)
	wpapernoblur       = ini_read_real(  "preferences", "wpapernoblur",       wpapernoblur)
	wpapernodim        = ini_read_real(  "preferences", "wpapernodim",        wpapernodim)
	noeditingbackground= ini_read_real(  "preferences", "noeditingbackground",noeditingbackground)

	// Midi import settings
	w_midi_remember =     ini_read_real(  "midi_import", "remember",        w_midi_remember)
	w_midi_removesilent = ini_read_real(  "midi_import", "remove_silent",   w_midi_removesilent)
	w_midi_name =         ini_read_real(  "midi_import", "name",            w_midi_name)
	w_midi_name_patch =   ini_read_real(  "midi_import", "name_patch",      w_midi_name_patch)
	w_midi_maxheight =    ini_read_real(  "midi_import", "maxheight",       w_midi_maxheight)
	w_midi_vel =          ini_read_real(  "midi_import", "enable_velocity", w_midi_vel)
	w_midi_tempo =        ini_read_real(  "midi_import", "tempo",           w_midi_tempo)
	w_midi_octave =       ini_read_real(  "midi_import", "octave",          w_midi_octave)
	w_midi_precision =    ini_read_real(  "midi_import", "precision",       w_midi_precision)
	w_midi_tempo_changer =ini_read_real(  "midi_import", "tempo_changer",   w_midi_tempo_changer)
	w_midi_note_duration =ini_read_real(  "midi_import", "note_duration",   w_midi_note_duration)
	// instruments
	for (a = 0; a < 128; a += 1) {
	    midi_ins[a, 1] =  ini_read_real(  "midi_import", "ins_" + string(a),          midi_ins[a, 1]) // Instrument
	   if (midi_ins[a, 1] = 255) // -1
	      midi_ins[a, 1] = -1
	    midi_ins[a, 2] =  ini_read_real(  "midi_import", "ins_" + string(a) + "_oct", midi_ins[a, 2]) // Octave
	   if (midi_ins[a, 2] = 255) // -1
	      midi_ins[a, 2] = -1
	}
	// drums
	for (a = 24; a < 88; a += 1) {
	    midi_drum[a, 1] = ini_read_real(  "midi_import", "drum_" + string(a),          midi_drum[a, 1]) // Instrument
	   if (midi_drum[a, 1] = 255) // -1
	      midi_drum[a, 1] = -1
	    midi_drum[a, 2] = ini_read_real(  "midi_import", "drum_" + string(a) + "_key", midi_drum[a, 2]) // Key
	   if (midi_drum[a, 2] = 255) // -1
	      midi_drum[a, 2] = -1
	}

	// Schematic export settings
	sch_exp_minecraft_old =    ini_read_real("schematic_export", "use_old_format", sch_exp_minecraft_old)
	sch_exp_walkway_block =    ini_read_real("schematic_export", "walkway_block",  sch_exp_walkway_block)
	sch_exp_walkway_data =     ini_read_real("schematic_export", "walkway_data",   sch_exp_walkway_data)
	sch_exp_circuit_block =    ini_read_real("schematic_export", "circuit_block",  sch_exp_circuit_block)
	sch_exp_circuit_data =     ini_read_real("schematic_export", "circuit_data",   sch_exp_circuit_data)
	sch_exp_ground_block =     ini_read_real("schematic_export", "ground_block",   sch_exp_ground_block)
	sch_exp_ground_data =      ini_read_real("schematic_export", "ground_data",    sch_exp_ground_data)
	sch_exp_layout =           ini_read_real("schematic_export", "layout",         sch_exp_layout)
	sch_exp_notesperrow =      ini_read_real("schematic_export", "notes_per_row",  sch_exp_notesperrow)
	sch_exp_includelocked =    ini_read_real("schematic_export", "include_locked", sch_exp_includelocked)
	sch_exp_compress =         ini_read_real("schematic_export", "compress",       sch_exp_compress)
	sch_exp_loop =             ini_read_real("schematic_export", "loop",           sch_exp_loop)
	sch_exp_glass =            ini_read_real("schematic_export", "glass",          sch_exp_glass)
	sch_exp_minecart =         ini_read_real("schematic_export", "minecart",       sch_exp_minecart)
	sch_exp_chest =            ini_read_real("schematic_export", "chest",          sch_exp_chest)
	for (a = 0; a < 256; a += 1) {
	   sch_exp_ins_block[a] = ini_read_real("schematic_export", "ins_block_" + string(a), sch_exp_ins_block[a])
	   sch_exp_ins_data[a] =  ini_read_real("schematic_export", "ins_data_"  + string(a), sch_exp_ins_data[a])
	}
	command_block =            ini_read_real("schematic_export", "command_block",  command_block)

	// Branch export settings
	sch_exp_stereo =      ini_read_real("branch_export", "stereo",      sch_exp_stereo)
	sch_exp_velocity =    ini_read_real("branch_export", "velocity",    sch_exp_velocity)
	sch_exp_circuitry =   ini_read_real("branch_export", "circuitry",   sch_exp_circuitry)
	sch_exp_vertical =    ini_read_real("branch_export", "vertical",    sch_exp_vertical)
	sch_exp_polyphony =   ini_read_real("branch_export", "polyphony",   sch_exp_polyphony)
	sch_exp_layer1 =      ini_read_real("branch_export", "layer1",      sch_exp_layer1)
	sch_exp_layer2 =      ini_read_real("branch_export", "layer2",      sch_exp_layer2)
	sch_exp_layer3 =      ini_read_real("branch_export", "layer3",      sch_exp_layer3)
	sch_exp_range_start = ini_read_real("branch_export", "range_start", sch_exp_range_start)
	sch_exp_range_end =   ini_read_real("branch_export", "range_end",   sch_exp_range_end)

	// Datapack export settings
	dat_name =              ini_read_string("datapack_export", "name",          dat_name)
	dat_namespace =         ini_read_string("datapack_export", "namespace",     dat_namespace)
	dat_path =              ini_read_string("datapack_export", "path",          dat_path)
	dat_source =            ini_read_string("datapack_export", "source",        dat_source)
	dat_usezip =            ini_read_real(  "datapack_export", "use_zip",       dat_usezip)
	dat_mcversion =         ini_read_real(  "datapack_export", "mcversion",     dat_mcversion)
	dat_includelocked =     ini_read_real(  "datapack_export", "locked",        dat_includelocked)
	dat_includeoutofrange = ini_read_real(  "datapack_export", "out_of_range",  dat_includeoutofrange)
	dat_enableradius =      ini_read_real(  "datapack_export", "enable_radius", dat_enableradius)
	dat_radius =            ini_read_real(  "datapack_export", "radius",        dat_radius)
	dat_enablelooping =     ini_read_real(  "datapack_export", "looping",       dat_enablelooping)
	dat_visualizer =        ini_read_real(  "datapack_export", "visualizer",    dat_visualizer)
	dat_vis_type =          ini_read_string("datapack_export", "vis_type",      dat_vis_type)
	dat_glow =              ini_read_real(  "datapack_export", "vis_glow",      dat_glow)
	dat_xval =              ini_read_real(  "datapack_export", "vis_x",         dat_xval)
	dat_yval =              ini_read_real(  "datapack_export", "vis_y",         dat_yval)
	dat_zval =              ini_read_real(  "datapack_export", "vis_z",         dat_zval)

	// Keyboard keys
	for (a = 0; a < 88; a += 1) piano_key[a] = ini_read_real("piano_keys", "piano_key_" + string(a), piano_key[a])

	// Default instrument presses
	for (a = 0; a < first_custom_index; a += 1) {
		var ins = ds_list_find_value(songs[song].instrument_list, a)
		ins.press = ini_read_real("instruments", "ins_" + string(a) + "_press", ins.press)
	}

	// Warnings
	warning_octaves =    ini_read_real("warnings", "octaves",    warning_octaves)
	warning_instrument = ini_read_real("warnings", "instrument", warning_instrument)
	warning_schematic =  ini_read_real("warnings", "schematics", warning_schematic)
	tutorial_tempobox =  ini_read_real("warnings", "tempobox", tutorial_tempobox)
	donate_banner_time = ini_read_real("warnings", "donate_banner_time", donate_banner_time)

	ini_close()
	return 1



}
