function add_block_select(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
	// add_block_select(x, y, ins, key, vel, pan, pit)
	var a, b, c, xx, yy, ins, key, vel, pan, pit;
	xx = argument0
	yy = argument1
	ins = argument2
	key = median(0, argument3, 87)
	vel = argument4
	pan = argument5
	pit = argument6

	// Initialize cells
	if (xx >= songs[song].arraylength) {
	    for (a = songs[song].arraylength; a <= xx; a += 1) {
	        songs[song].colfirst[a] = -1
	        songs[song].collast[a] = -1
	        songs[song].colamount[a] = 0
	        for (b = 0; b < max(yy + 1, songs[song].arrayheight); b += 1) songs[song].song_exists[a, b] = 0
	    }
	    songs[song].arraylength = xx + 1
	}
	if (yy >= songs[song].arrayheight) {
	    for (a = 0; a < songs[song].arraylength; a += 1) {
	        for (b = songs[song].arrayheight; b <= yy; b += 1) {
	            songs[song].rowamount[b] = 0
	            songs[song].song_exists[a, b] = 0
	        }
	    }
	    songs[song].arrayheight = yy + 1
	}

	if (songs[song].song_exists[xx, yy]) remove_block_select(xx, yy)

	// Add block
	songs[song].song_exists[xx, yy] = 1
	songs[song].song_ins[@ xx, yy] = ins
	songs[song].song_key[@ xx, yy] = key
	songs[song].song_vel[@ xx, yy] = vel
	songs[song].song_pan[@ xx, yy] = pan
	songs[song].song_pit[@ xx, yy] = pit
	songs[song].song_played[@ xx, yy] = 0
	songs[song].song_added[@ xx, yy] = 0
	songs[song].colamount[@ xx] += 1
	songs[song].rowamount[@ yy] += 1
	ins.num_blocks++
	if (key < 33 || key > 57) songs[song].block_outside += 1
	if (ins.user) songs[song].block_custom += 1
	if (pit != 0) songs[song].block_pitched += 1
	songs[song].totalblocks += 1

	if (songs[song].colfirst[xx] = -1 || yy < songs[song].colfirst[xx]) songs[song].colfirst[@ xx] = yy
	if (yy > songs[song].collast[xx]) songs[song].collast[@ xx] = yy

	if (xx >= songs[song].enda) songs[song].enda = xx
	if (yy >= songs[song].endb) songs[song].endb = yy
	return 1



}
