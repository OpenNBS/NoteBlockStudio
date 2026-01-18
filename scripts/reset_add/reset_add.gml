function reset_add() {
	// reset_add()
	var a, b;

	// File
	songs[song].song_midi = songs[song].midifile
	songs[song].midifile = ""

	// Playback
	playing = 0
	tempodrag = 10
	metronome = 0
	metronome_played = -1
	fade = 0

	// Selecting
	timeline_pressa = -1

	// Layers
	editline = 0
	dragvolb = 0
	realstereo = 0

	// Piano
	key_edit = -1

	// Interface
	window = 0
	global.popup = 0
	delay = 0
	mouse_xprev = mouse_x
	mouse_yprev = mouse_y
	sb_val[0] = 0
	sb_val[1] = 0
	sb_val[2] = 0
	sb_val[3] = 0
	sb_sel = 0
	for (a = 0; a < 10000; a += 1) text_exists[a] = 0
	insselect = -1
	insedit = -1

}
