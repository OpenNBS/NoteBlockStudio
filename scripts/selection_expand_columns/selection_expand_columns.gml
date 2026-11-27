function selection_expand_columns(){
	for (var i = array_length(songs[song].selection_colfirst); i < songs[song].selection_l; i++) {
		songs[song].selection_colfirst[i] = -1
		songs[song].selection_collast[i] = -1
		songs[song].selection_exists[i, 0] = 0
		songs[song].selection_ins[i, 0] = 0
		songs[song].selection_key[i, 0] = 0
		songs[song].selection_vel[i, 0] = 0
		songs[song].selection_pan[i, 0] = 0
		songs[song].selection_pit[i, 0] = 0
		songs[song].selection_played[i, 0] = 0
	}
}