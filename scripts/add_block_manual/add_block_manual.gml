function add_block_manual(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
	// add_block_manual(x, y, ins, key, vel, pan, pit)
	var a, b, c, xx, yy, ins, key, vel, pan, pit;
	xx = argument0
	yy = argument1
	ins = argument2
	key = argument3
	vel = argument4
	pan = argument5
	pit = argument6
	if (xx >= 32000) return 0

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

	if (songs[song].song_exists[xx, yy]) return 0

	if ((key < 33  || key > 57) && warning_octaves = 0) {
	    if (language != 1) message("NOTE: Since this block is outside the 2 octave limit, you won't be able to import it into Minecraft without a resource pack.\n\nThis warning will never be shown again.", "Warning")
	    else message("注意：由于此方块在 2 八度的范围外，您将无法不使用资源包将该歌曲导入进 Minecraft 中。\n此消息将不再提示。", "警告")
	    warning_octaves = 1
		save_settings()
	} else if (ins.user && warning_instrument = 0) {
	    if (language != 1) message("NOTE: Since this block has a custom instrument, you won't be able to import it into Minecraft without mods or resource packs.\n\nThis warning will never be shown again.", "Warning")
	    else message("注意：由于此方块包含自定义音色，您将无法不使用模组或资源包将该歌曲导入进 Minecraft 中。\n此消息将不再提示。", "警告")
	    warning_instrument = 1
		save_settings()
	}

	// Add block
	songs[song].song_exists[xx, yy] = 1
	songs[song].song_ins[xx, yy] = ins
	songs[song].song_key[xx, yy] = key
	songs[song].song_vel[xx, yy] = vel
	songs[song].song_pan[xx, yy] = pan
	songs[song].song_pit[xx, yy] = pit
	songs[song].song_played[xx, yy] = 0
	songs[song].song_added[xx, yy] = current_time
	songs[song].colamount[xx] += 1
	songs[song].rowamount[yy] += 1
	ins.num_blocks++
	if (key < 33 || key > 57) songs[song].block_outside += 1
	if (ins.user) songs[song].block_custom += 1
	if (pit != 0) songs[song].block_pitched += 1
	songs[song].totalblocks += 1
	songs[song].changed = 1
	songs[song].work_add += 1
	if (songs[song].colfirst[xx] = -1 || yy < songs[song].colfirst[xx]) songs[song].colfirst[xx] = yy
	if (yy > songs[song].collast[xx]) songs[song].collast[xx] = yy

	if (xx >= songs[song].enda) songs[song].enda = xx
	if (yy >= songs[song].endb) songs[song].endb = yy

	if (ins.loaded) play_sound(ins, key, vel, pan, pit)
	history_set(h_addblock, xx, yy, ins, key, vel, pan, pit)
	
	if (songs[song].instrument_list[| ds_list_find_index(songs[song].instrument_list, ins)].name = "Tempo Changer") {
		tempo_changer_sel_x = xx
		tempo_changer_sel_y = yy
		tempo_changer_set_tempo = int64(songs[song].tempo * 15)
		tempo_changer_sel_ins = ins
		songs[song].song_pit[xx, yy] = int64(songs[song].tempo * 15)
		text_exists[59] = 0
		window = w_edit_tempo_changer
	}
	
	return 1



}
