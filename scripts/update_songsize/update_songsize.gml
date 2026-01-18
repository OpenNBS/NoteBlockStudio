function update_songsize() {
	// update_songsize()
	var xx, yy;
	xx = songs[song].enda
	yy = songs[song].endb
	if (songs[song].colamount[xx] = 0) {
	    for (a = xx; a >= 0; a -= 1) {
	        songs[song].enda = a
	        if (songs[song].colamount[a] > 0) break
	    }
	}
	if (songs[song].rowamount[yy] = 0) {
	    for (b = yy; b >= 0; b -= 1) {
	        songs[song].endb = b
	        if (songs[song].rowamount[b] > 0) break
	    }
	}



}
