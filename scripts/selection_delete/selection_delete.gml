function selection_delete(argument0) {
	// selection_delete(undo)
	// Deletes the selection and the blocks in it.
	var a, b, ani, totalcols, totalrows;
	if (!fullscreen && show_layers) {
		totalcols = floor((rw - 8 - 270) / 32)
	} else {
		totalcols = floor(rw / 32) + 1
	}
	totalrows = floor((rh - rhval) / 32)
	songs[song].changed = 1
	if (songs[song].selected = 0) return 0
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    if (songs[song].selection_colfirst[a] > -1) {
	        for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	            if (songs[song].selection_exists[a, b]) {
	                songs[song].selection_exists[a, b] = 0
	                songs[song].selection_ins[a, b] = 0
	                songs[song].selection_key[a, b] = 0
	                songs[song].selection_vel[a, b] = 0
	                songs[song].selection_pan[a, b] = 0
	                songs[song].selection_pit[a, b] = 0
	                songs[song].selection_played[a, b] = 0
					if (theme = 3 && remove_effect && songs[song].selection_x + a >= songs[song].starta && songs[song].selection_x + a < songs[song].starta + totalcols && songs[song].selection_y + b >= songs[song].startb && songs[song].selection_y + b < songs[song].startb + totalrows) {
						ani = create(obj_removeeff)
						ani.xn = songs[song].selection_x + a - songs[song].starta
						ani.yn = songs[song].selection_y + b - songs[song].startb
					}
	            }
	        }
	        songs[song].selection_colfirst[a] = -1
	        songs[song].selection_collast[a] = -1
	    }
	}
	songs[song].selected = 0
	if (!argument0) history_set(h_selectchange, 0, 0, "", songs[song].selection_x, songs[song].selection_y, songs[song].selection_code)
	songs[song].selection_code = ""
	songs[song].selection_x = 0
	songs[song].selection_y = 0
	songs[song].selection_l = 0
	songs[song].selection_h = 0
	update_songsize()



}
