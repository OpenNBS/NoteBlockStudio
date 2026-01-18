function set_song(argument0){
	for (var a = 0; a < 2000; a += 1) {try{songs[song].text_exists_song[a] = text_exists[a]}catch(ee){}; try{songs[song].text_str_song[a] = text_str[a]}catch(ee){}}
	song = argument0
	for (var a = 0; a < 2000; a += 1) {try{text_exists[a] = songs[song].text_exists_song[a]}catch(ee){}; try{text_str[a] = songs[song].text_str_song[a]}catch(ee){}}
	
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
	
	sb_val[0] = songs[song].starta
	sb_val[1] = songs[song].startb
}