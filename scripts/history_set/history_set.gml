function history_set() {
	// history_set(type, arg0, arg1, arg2, arg3...)
	var a, b;
	if (songs[song].historypos > 0) {
	    for (a = songs[song].historypos; a < songs[song].historylen + 1; a += 1) {
	        for (b = 0; b < 16; b += 1) {
	            songs[song].history[a - songs[song].historypos, b] = songs[song].history[a, b]
	        }
	    }
	    songs[song].historylen -= songs[song].historypos
	}
	songs[song].historylen += 1
	for (a = songs[song].historylen; a > 0; a -= 1) {
	    for (b = 0; b < 16; b += 1) {
	        songs[song].history[a, b] = songs[song].history[a - 1, b]
	    }
	}
	songs[song].historypos = 0
	songs[song].history[0, 16] = 0
	for (a = 0; a < argument_count; a += 1) songs[song].history[0, a] = argument[a]



}
