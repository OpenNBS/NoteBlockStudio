function add_block() {
	// add_block(x, y, ins, key, vel, pan, pit)
	var a, b, c, xx, yy, ins, key, vel, pan, pit, insnum;
	xx = argument[0]
	yy = argument[1]
	ins = argument[2]
	key = median(0, argument[3], 87)
	vel = argument[4]
	pan = argument[5]
	pit = argument[6]
	if (argument_count > 7) {
		insnum = argument[7]
	}
	else
		insnum = false
		
	if (xx < 0) return 0

	// Initialize cells
	if (xx >= songs[song].arraylength) {
	    for (a = xx; a >= songs[song].arraylength; --a) {
	        songs[song].colfirst[@ a] = -1
	        songs[song].collast[@ a] = -1
	        songs[song].colamount[@ a] = 0
	        for (b = max(yy + 1, songs[song].arrayheight) - 1; b >= 0; --b) songs[song].song_exists[@ a, b] = 0
	    }
	    songs[song].arraylength = xx + 1
	}
	if (yy >= songs[song].arrayheight) {
	    for (a = songs[song].arraylength - 1; a >= 0; --a) {
	        for (b = yy; b >= songs[song].arrayheight; --b) {
	            songs[song].rowamount[@ b] = 0
	            songs[song].song_exists[@ a, b] = 0
	        }
	    }
	    songs[song].arrayheight = yy + 1
	}

	if (songs[song].song_exists[xx, yy]) return 0

	// Add block
	songs[song].song_exists[@ xx, yy] = 1
	songs[song].song_ins[@ xx, yy] = ins
	songs[song].song_key[@ xx, yy] = key
	songs[song].song_vel[@ xx, yy] = vel
	songs[song].song_pan[@ xx, yy] = pan
	songs[song].song_pit[@ xx, yy] = pit
	songs[song].song_played[@ xx, yy] = 0
	songs[song].song_added[@ xx, yy] = 0
	songs[song].colamount[@ xx] += 1
	songs[song].rowamount[@ yy] += 1
	if (!insnum) {
	    ins.num_blocks++
	    if (ins.user) songs[song].block_custom += 1
	}
	if (key < 33 || key > 57) songs[song].block_outside += 1
	if (pit != 0) songs[song].block_pitched += 1
	songs[song].totalblocks += 1

	if (songs[song].colfirst[xx] = -1 || yy < songs[song].colfirst[xx]) songs[song].colfirst[xx] = yy
	if (yy > songs[song].collast[xx]) songs[song].collast[@ xx] = yy

	if (xx >= songs[song].enda) songs[song].enda = xx
	if (yy >= songs[song].endb) songs[song].endb = yy
	return 1



}
