function selection_extend_length(new_length = undefined){
	if (is_undefined(new_length)) {
		new_length = songs[song].enda
	}
	if (new_length > songs[song].selection_arraylength) { // New length
	    for (a = new_length; a >= songs[song].selection_arraylength + 1; --a) {
	        songs[song].selection_colfirst[@ a] = -1
	        songs[song].selection_collast[@ a] = -1
	        for (b = songs[song].selection_arrayheight; b >= 0; --b) {
	            songs[song].selection_exists[@ a, b] = 0
	        }
	    }
	    songs[song].selection_arraylength = new_length
	}
}