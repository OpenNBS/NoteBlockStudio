function remove_block_select(argument0, argument1) {
	// remove_block_select(x, y)
	var xx, yy;
	xx = argument0
	yy = argument1

	if (xx >= songs[song].arraylength || yy >= songs[song].arrayheight || songs[song].song_exists[xx, yy] == 0) return 0
	songs[song].song_exists[@ xx, yy] = 0
	songs[song].song_ins[xx, yy].num_blocks--
	if (songs[song].song_key[xx, yy] < 33 || songs[song].song_key[xx, yy] > 57) songs[song].block_outside -= 1
	if (songs[song].song_ins[xx, yy].user) songs[song].block_custom -= 1
	if (songs[song].song_pit[xx, yy] != 0) songs[song].block_pitched -= 1

	songs[song].song_ins[@ xx, yy] = 0
	songs[song].song_key[@ xx, yy] = 0
	songs[song].song_vel[@ xx, yy] = 0
	songs[song].song_pan[@ xx, yy] = 0
	songs[song].song_pit[@ xx, yy] = 0
	songs[song].song_played[@ xx, yy] = 0
	songs[song].song_added[@ xx, yy] = 0
	songs[song].colamount[@ xx] -= 1
	songs[song].rowamount[@ yy] -= 1
	songs[song].totalblocks -= 1
	


}
