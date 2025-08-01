function remove_block_manual(argument0, argument1) {
	// remove_block_manual(x, y)
	var xx, yy, ins, key, a, b, vel, pan, pit, ani;
	xx = argument0
	yy = argument1

	if (songs[song].song_exists[xx, yy] = 0) return 0
	songs[song].song_exists[xx, yy] = 0
	ins = songs[song].song_ins[xx, yy]
	key = songs[song].song_key[xx, yy]
	vel = songs[song].song_vel[xx, yy]
	pan = songs[song].song_pan[xx, yy]
	pit = songs[song].song_pit[xx, yy]
	ins.num_blocks--
	if (songs[song].song_key[xx, yy] < 33 || songs[song].song_key[xx, yy] > 57) songs[song].block_outside -= 1
	if (ins.user) songs[song].block_custom -= 1
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
	songs[song].work_remove += 1
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
	history_set(h_removeblock, xx, yy, ins, key, vel, pan, pit)
	if (theme = 3 && remove_effect) {
		ani = create(obj_removeeff)
		ani.xn = xx - songs[song].starta
		ani.yn = yy - songs[song].startb
	}
	songs[song].changed = 1
	if (songs[song].instrument_list[| ds_list_find_index(songs[song].instrument_list, ins)].name = "Tempo Changer") {
		update_tempo_changes()
	}



}
