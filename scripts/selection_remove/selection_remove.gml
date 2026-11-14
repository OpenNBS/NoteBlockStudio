function selection_remove(argument0, argument1, argument2, argument3, argument4, argument5) {
	// selection_remove(x1, y1, x2, y2, all, undo)
	// Removes the blocks within the given area from the selection.
	var x1, y1, x2, y2, key, ins, a, b, c, sa, sb, vel, pan, pit;
	if (!argument4) {
	    x1 = min(argument0, argument2)
	    y1 = min(argument1, argument3)
	    x2 = max(argument0, argument2)
	    y2 = max(argument1, argument3)
	    x1 = max(0, x1)
	    y1 = max(0, y1)
	    x2 = max(0, x2) + 1
	    y2 = max(0, y2) + 1
	    if (songs[song].selected = 0) return 0
	    ac = 0
	    for (a = x1; a < x2; a += 1) {
	        for (b = y1; b < y2; b += 1) {
	            if (a >= songs[song].selection_x && b >= songs[song].selection_y && a < songs[song].selection_x + songs[song].selection_l && b < songs[song].selection_y + songs[song].selection_h) {
	                if (songs[song].selection_exists[a - songs[song].selection_x, b - songs[song].selection_y]) ac += 1
	            }
	        }
	    }
	    if (ac = 0) return 0 // None selected
	} else {
	    ac = songs[song].selected
	    x1 = songs[song].selection_x
	    y1 = songs[song].selection_y
	    x2 = songs[song].selection_x + songs[song].selection_l
	    y2 = songs[song].selection_y + songs[song].selection_h
	}
	if (!argument5) history_set(h_selectremove, x1, y1, x2, y2, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, region_code_get(x1, y1, x2, y2))
	if (ac = songs[song].selected) {
	    for (a = 0; a < songs[song].selection_l; a += 1) {
	        if (songs[song].selection_colfirst[a] > -1) {
	            for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	                if (songs[song].selection_exists[a, b]) {
	                    ins = songs[song].selection_ins[a, b]
	                    key = songs[song].selection_key[a, b]
	                    vel = songs[song].selection_vel[a, b]
	                    pan = songs[song].selection_pan[a, b]
	                    pit = songs[song].selection_pit[a, b]
	                    sa = songs[song].selection_x + a
	                    sb = songs[song].selection_y + b
	                    add_block_select(sa, sb, ins, key, vel, pan, pit)
	                    songs[song].selection_exists[@ a, b] = 0
	                    songs[song].selection_ins[@ a, b] = 0
	                    songs[song].selection_key[@ a, b] = 0
	                    songs[song].selection_vel[@ a, b] = 0
	                    songs[song].selection_pan[@ a, b] = 0
	                    songs[song].selection_pit[@ a, b] = 0
	                    songs[song].selection_played[@a, b] = 0
	                }
	            }
	            songs[song].selection_colfirst[@ a] = -1
	            songs[song].selection_collast[@ a] = -1
	        }
	    }
	    update_songsize()
	    songs[song].selected = 0
	    songs[song].selection_code = ""
	    songs[song].selection_x = 0
	    songs[song].selection_y = 0
	    songs[song].selection_l = 0
	    songs[song].selection_h = 0
	} else {
	    for (a = x1; a < x2; a += 1) {
	        for (b = y1; b < y2; b += 1) {
	            if (a >= songs[song].selection_x && b >= songs[song].selection_y && a < songs[song].selection_x + songs[song].selection_l && b < songs[song].selection_y + songs[song].selection_h) {
	                sa = a - songs[song].selection_x
	                sb = b - songs[song].selection_y
	                if (sb >= songs[song].selection_colfirst[sa] && sb <= songs[song].selection_collast[sa]) {
	                    if (songs[song].selection_exists[sa, sb]) {
	                        ins = songs[song].selection_ins[sa, sb]
	                        key = songs[song].selection_key[sa, sb]
	                        vel = songs[song].selection_vel[sa, sb]
	                        pan = songs[song].selection_pan[sa, sb]
	                        pit = songs[song].selection_pit[sa, sb]
	                        add_block_select(a, b, ins, key, vel, pan, pit)
	                        songs[song].selection_exists[sa, sb] = 0
	                        songs[song].selection_ins[sa, sb] = 0
	                        songs[song].selection_key[sa, sb] = 0
	                        songs[song].selection_vel[sa, sb] = 0
	                        songs[song].selection_pan[sa, sb] = 0
	                        songs[song].selection_pit[sa, sb] = 0
	                        songs[song].selection_played[sa, sb] = 0
	                        songs[song].selected -= 1
	                        if (songs[song].selection_colfirst[sa] = sb) {
	                            songs[song].selection_colfirst[sa] = -1
	                            for (c = sb; c < songs[song].selection_h; c += 1) {
	                                if (songs[song].selection_exists[sa, c]) {
	                                    songs[song].selection_colfirst[sa] = c
	                                    break
	                                }
	                            }
	                        }
	                        if (songs[song].selection_collast[sa] = sb) {
	                            songs[song].selection_collast[sa] = -1
	                            for (c = sb; c >= 0; c -= 1) {
	                                if (songs[song].selection_exists[sa, c]) {
	                                    songs[song].selection_collast[sa] = c
	                                    break
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	        }
	    }
	    selection_trim()
	    selection_code_update()
	}
	update_tempo_changes()



}
