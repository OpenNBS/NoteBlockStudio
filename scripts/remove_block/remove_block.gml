function remove_block(argument0, argument1) {
	// remove_block(x, y)
	var xx, yy, ins, a, b;
	xx = argument0
	yy = argument1

	if (songs[song].song_exists[xx, yy] = 0) return 0
	songs[song].song_exists[xx, yy] = 0
	songs[song].song_ins[xx, yy].num_blocks--
	if (songs[song].song_key[xx, yy] < 33 || songs[song].song_key[xx, yy] > 57) songs[song].block_outside -= 1
	if (songs[song].song_ins[xx, yy].user) songs[song].block_custom -= 1
	if (songs[song].song_pit[xx, yy] != 0) songs[song].block_pitched -= 1
	songs[song].song_ins[xx, yy] = 0
	songs[song].song_key[xx, yy] = 0
	songs[song].song_vel[xx, yy] = 0
	songs[song].song_pan[xx, yy] = 0
	songs[song].song_pit[xx, yy] = 0
	songs[song].song_played[xx, yy] = 0
	songs[song].song_added[xx, yy] = 0
	songs[song].colamount[xx] -= 1
	songs[song].rowamount[yy] -= 1
	songs[song].totalblocks -= 1
	if (songs[song].colamount[xx] = 0) {
	    if (songs[song].enda = xx) {
	        for (a = xx; a >= 0; a -= 1) {
	            songs[song].enda = a
	            if (songs[song].colamount[a] > 0) break
	        }
	    }
	}
	if (songs[song].rowamount[yy] = 0) {
	    if (songs[song].endb = yy) {
	        for (b = yy; b >= 0; b -= 1) {
	            songs[song].endb = b
	            if (songs[song].rowamount[b] > 0) break
	        }
	    }
	}
	if (songs[song].colfirst[xx] = yy) {
	    songs[song].colfirst[xx] = -1
	    for (a = 0; a <= songs[song].collast[xx]; a += 1) {
	        if (songs[song].song_exists[xx, a]) {
	            songs[song].colfirst[xx] = a
	            break
	        }
	    }
	}
	if (songs[song].collast[xx] = yy) {
	    songs[song].collast[xx] = -1
	    for (a = yy; a >= 0; a -= 1) {
	        if (songs[song].song_exists[xx, a]) {
	            songs[song].collast[xx] = a
	            break
	        }
	    }
	}

	songs[song].changed = 1



}
