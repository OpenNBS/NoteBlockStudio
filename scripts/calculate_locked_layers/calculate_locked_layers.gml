function calculate_locked_layers() {
	// calculate_locked_layers()
	// populates the 'lockedlayer' array for every layer in the song

	for (c = 0; c <= songs[song].endb; c += 1) {
	    lockedlayer[c] = 0
	    if (songs[song].solostr != "") {
	        if (string_count("|" + string(c) + "|", songs[song].solostr) = 0) {
	            lockedlayer[c] = 1
	        } else if (songs[song].layerlock[c] = 1) {
	            lockedlayer[c] = 1
	        }
	    } else if (c < songs[song].endb2) {
	        if (songs[song].layerlock[c] = 1) {
	            lockedlayer[c] = 1
	        }
	    }
	}


}
