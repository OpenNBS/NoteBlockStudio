function reset() {
	// reset()
	var a, b;

	// File
	songs[song].filename = ""
	songs[song].changed = 0
	songs[song].song_midi = songs[song].midifile
	songs[song].midifile = ""
	songs[song].song_download_display_name = ""

	// Playback
	playing = 0
	tempodrag = 10
	metronome = 0
	metronome_played = -1
	fade = 0

	// Selecting
	select = 0
	timeline_pressa = -1

	// Layers
	editline = 0
	dragvolb = 0
	realstereo = 0

	// Piano
	selected_key = 39
	key_edit = -1

	// Interface
	window = 0
	editmode = 0
	selected_tab = 0
	global.popup = 0
	mouse_xprev = mouse_x
	mouse_yprev = mouse_y
	sb_val[0] = 0
	sb_val[1] = 0
	sb_val[2] = 0
	sb_val[3] = 0
	sb_sel = 0
	for (a = 0; a < 10000; a += 1) text_exists[a] = 0

	selected_vel = 100
	selected_pan = 100
	selected_pit = 0
	insselect = -1
	insedit = -1

	// Macros
	stereo_reverse = 0
	tremolotype = 0
	trem_spacing = 1
	fade_auto = 1
	leg_dec = 20
	leg_sus = 20
	port_cent = 0
	porta_reverse = 0
	stereo_width = 50
	setvel = 100
	setpan = 0
	setpit = 0

	// Saving
	save_version = nbs_version
	tonextsave = 0
	tonextbackup = 0
	backup_delete_own_tab()
	songs[song].song_backupname = "Unsaved song " + string(song_backupid) + ".nbs"


}
