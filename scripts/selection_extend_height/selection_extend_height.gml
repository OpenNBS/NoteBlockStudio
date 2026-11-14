function selection_extend_height(new_height = undefined){
	if (is_undefined(new_height)) {
		new_height = songs[song].endb
	}
	if (new_height > songs[song].selection_arrayheight) { // New height
	    for (var a = songs[song].selection_arraylength; a >= 0; --a) {
	        for (var b = new_height; b >= songs[song].selection_arrayheight + 1; --b) {
	            songs[song].selection_exists[@ a, b] = 0
	        }
	    }
	    songs[song].selection_arrayheight = new_height
	}
}