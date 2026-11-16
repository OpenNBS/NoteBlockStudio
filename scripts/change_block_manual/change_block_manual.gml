function change_block_manual(argument0, argument1, argument2, argument3, argument4, argument5, argument6, show_event_dialog = true) {
	// change_block_manual(x, y, ins, key, vel, pan, pit)
	var xx, yy, ins, key, vel, pan, pit, pins, pkey, pvel, ppan, ppit, is_event;
	xx = argument0
	yy = argument1
	ins = argument2
	key = argument3
	vel = argument4
	pan = argument5
	pit = argument6
	pins = songs[song].song_ins[xx, yy]
	pkey = songs[song].song_key[xx, yy]
	pvel = songs[song].song_vel[xx, yy]
	ppan = songs[song].song_pan[xx, yy]
	ppit = songs[song].song_pit[xx, yy]
	var insname = ins.name
	is_event = pins.name == insname
	if (show_event_dialog && (insname == "Tempo Changer" || insname == "Sound Stopper")) {
		// Keep the proposed values in the dialog until the user confirms.
		tempo_changer_sel_key = is_event ? pkey : key
		tempo_changer_sel_vel = is_event ? pvel : vel
		tempo_changer_sel_pan = is_event ? ppan : pan
	}

	if (ins.loaded) play_sound(ins, key, (songs[song].layervol[yy] / 100 ) * vel, (songs[song].layerstereo[yy] + pan) / 2, pit)

	if (show_event_dialog && insname = "Tempo Changer") {
		tempo_changer_sel_x = xx
		tempo_changer_sel_y = yy
		if (is_event) tempo_changer_set_tempo = songs[song].song_pit[xx, yy]
		else tempo_changer_set_tempo = int64(songs[song].tempo * 15)
		tempo_changer_sel_ins = ins
		text_exists[59] = 0
		window = w_edit_tempo_changer
	} else if (show_event_dialog && insname = "Sound Stopper") {
		tempo_changer_sel_x = xx
		tempo_changer_sel_y = yy
		if (is_event) {
			sound_stopper_set_start = songs[song].song_pit[xx, yy]
			sound_stopper_set_until = panning_velocity_to_short(songs[song].song_pan[xx, yy], songs[song].song_vel[xx, yy])
		} else {
			sound_stopper_set_start = yy + 1
			sound_stopper_set_until = yy + 1
		}
		tempo_changer_sel_ins = ins
		text_exists[59] = 0
		text_exists[60] = 0
		window = w_edit_sound_stopper
	} else {
		change_block(xx, yy, ins, key, vel, pan, pit)
		history_set(h_changeblock, xx, yy, ins, key, vel, pan, pit, pins, pkey, pvel, ppan, ppit)
		songs[song].changed = 1

		if (!pins.user && ins.user) songs[song].block_custom += 1
		if (pins.user && !ins.user) songs[song].block_custom -= 1
		if (pkey >= 33 && pkey <= 57 && (key < 33 || key > 57)) songs[song].block_outside += 1
		if (key >= 33 && key <= 57 && (pkey < 33 || pkey > 57)) songs[song].block_outside -= 1
		if (ppit = 0 && pit != 0) songs[song].block_pitched += 1
		if (ppit != 0 && pit = 0) songs[song].block_pitched -= 1
		if (insname == "Tempo Changer" || pins.name == "Tempo Changer") update_tempo_changes()
	}
	


}
