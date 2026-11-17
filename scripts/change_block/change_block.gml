function change_block(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
	// change_block(x, y, ins, key, vel, pan, pit)
	var xx, yy, ins, key, vel, pan, pit;
	xx = argument0
	yy = argument1
	ins = argument2
	key = argument3
	vel = argument4
	pan = argument5
	pit = argument6

	// Manual edits and undo/redo must update the same compatibility counts.
	var pins = songs[song].song_ins[xx, yy]
	var pkey = songs[song].song_key[xx, yy]
	var ppit = songs[song].song_pit[xx, yy]
	if (pins != ins) {
		pins.num_blocks--
		ins.num_blocks++
	}
	if (!pins.user && ins.user) songs[song].block_custom += 1
	if (pins.user && !ins.user) songs[song].block_custom -= 1
	if (pkey >= 33 && pkey <= 57 && (key < 33 || key > 57)) songs[song].block_outside += 1
	if (key >= 33 && key <= 57 && (pkey < 33 || pkey > 57)) songs[song].block_outside -= 1
	if (ppit == 0 && pit != 0) songs[song].block_pitched += 1
	if (ppit != 0 && pit == 0) songs[song].block_pitched -= 1

	songs[song].song_ins[xx, yy] = ins
	songs[song].song_key[xx, yy] = key
	songs[song].song_vel[xx, yy] = vel
	songs[song].song_pan[xx, yy] = pan
	songs[song].song_pit[xx, yy] = pit


}
