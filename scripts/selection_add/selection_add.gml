function selection_add() {
	// selection_add(x1, y1, x2, y2, copy, undo[, locked])
	// Adds the given area to the selection.
	var x1, y1, x2, y2, al, ah, ac, a, b, am, sa, sb, nx1, ny1, nx2, ny2, copy, lockedlayer, includelocked;
	x1 = min(argument[0], argument[2])
	y1 = min(argument[1], argument[3])
	x2 = max(argument[0], argument[2])
	y2 = max(argument[1], argument[3])
	x1 = max(0, x1)
	y1 = max(0, y1)
	x2 = median(0, x2, songs[song].enda) + 1
	y2 = median(0, y2, songs[song].endb) + 1
	copy = argument[4]
	includelocked = 0
	if (argument_count > 6) {
		includelocked = argument[6]
	}
	if (x1 > songs[song].enda || y1 > songs[song].endb) return 0
	ac = 0
	nx1 = x2
	ny1 = y2
	nx2 = 0
	ny2 = 0
	for (b = 0; b <= songs[song].endb; b += 1) {
	    lockedlayer[b] = 0
	    if (songs[song].solostr != "") {
	        if (string_count("|" + string(b) + "|", songs[song].solostr) = 0) {
	            lockedlayer[b] = 1
	        } else if (songs[song].layerlock[b] = 1) {
	            lockedlayer[b] = 1
	        }
	    } else if (b < songs[song].endb2) {
	        if (songs[song].layerlock[b] = 1) {
	            lockedlayer[b] = 1
	        }
	    }
	}
	for (a = x1; a < x2; a += 1) {
	    for (b = y1; b < y2; b += 1) {
	        if (lockedlayer[b] = 0 || includelocked) {
	            if (songs[song].song_exists[a, b]) {
	                nx1 = min(nx1, a)
	                ny1 = min(ny1, b)
	                nx2 = max(nx2, a)
	                ny2 = max(ny2, b)
	                ac += 1
	            }
	        }
	    }
	}
	x1 = nx1
	y1 = ny1
	x2 = nx2 + 1
	y2 = ny2 + 1
	al = x2 - x1
	ah = y2 - y1
	if (ac = 0) return 0 // None selected
	if (songs[song].selected = 0) { // Create new
	    songs[song].selection_x = x1
	    songs[song].selection_y = y1
	    songs[song].selection_l = al
	    songs[song].selection_h = ah
		selection_extend_length(al)
		selection_extend_height(ah)
	} else { // Add to existing
	    al = songs[song].selection_l + max(0, songs[song].selection_x - x1) + max(0, x2 - (songs[song].selection_x + songs[song].selection_l))
	    ah = songs[song].selection_h + max(0, songs[song].selection_y - y1) + max(0, y2 - (songs[song].selection_y + songs[song].selection_h))
	    selection_extend_length(al)
		selection_extend_height(ah)
	    if (x1 < songs[song].selection_x || y1 < songs[song].selection_y) { // Move blocks
	        var temp_colfirst, temp_collast, temp_exists, temp_ins, temp_key, temp_vel, temp_pan, temp_pit, temp_played;
	        for (a = 0; a < songs[song].selection_l; a += 1) {
	            if (songs[song].selection_colfirst[a] > -1) {
	                for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	                    if (songs[song].selection_exists[a, b]) {
	                        temp_exists[a, b] = 1
	                        temp_ins[a, b] = songs[song].selection_ins[a, b]
	                        temp_key[a, b] = songs[song].selection_key[a, b]
	                        temp_vel[a, b] = songs[song].selection_vel[a, b]
	                        temp_pan[a, b] = songs[song].selection_pan[a, b]
	                        temp_pit[a, b] = songs[song].selection_pit[a, b]
	                        temp_played[a, b] = songs[song].selection_played[a, b]
	                        songs[song].selection_exists[a, b] = 0
	                        songs[song].selection_ins[a, b] = 0
	                        songs[song].selection_key[a, b] = 0
	                        songs[song].selection_vel[a, b] = 0
	                        songs[song].selection_pan[a, b] = 0
	                        songs[song].selection_pit[a, b] = 0
	                        songs[song].selection_played[a, b] = 0
	                    } else {
	                        temp_exists[a, b] = 0
	                    }
	                }
	            }
	            temp_colfirst[a] = songs[song].selection_colfirst[a]
	            temp_collast[a] = songs[song].selection_collast[a]
	            songs[song].selection_colfirst[a] = -1
	            songs[song].selection_collast[a] = -1
	        }
	        for (a = 0; a < songs[song].selection_l; a += 1) {
	            sa = a + max(0, songs[song].selection_x - x1)
	            if (temp_colfirst[a] > -1) {
	                for (b = temp_colfirst[a]; b <= temp_collast[a]; b += 1) {
	                    sb = b + max(0, songs[song].selection_y - y1)
	                    if (temp_exists[a, b]) {
	                        songs[song].selection_exists[sa, sb] = 1
	                        songs[song].selection_ins[sa, sb] = temp_ins[a, b]
	                        songs[song].selection_key[sa, sb] = temp_key[a, b]
	                        songs[song].selection_vel[sa, sb] = temp_vel[a, b]
	                        songs[song].selection_pan[sa, sb] = temp_pan[a, b]
	                        songs[song].selection_pit[sa, sb] = temp_pit[a, b]
	                        songs[song].selection_played[sa, sb] = temp_played[a, b]
	                    }
	                }
	                songs[song].selection_colfirst[sa] = temp_colfirst[a] + max(0, songs[song].selection_y - y1)
	                songs[song].selection_collast[sa] = temp_collast[a] + max(0, songs[song].selection_y - y1)
	            } else {
	                songs[song].selection_colfirst[sa] = -1
	                songs[song].selection_collast[sa] = -1
	            }
	        }
	    }
	    songs[song].selection_x = min(songs[song].selection_x, x1)
	    songs[song].selection_y = min(songs[song].selection_y, y1)
	    songs[song].selection_l = al
	    songs[song].selection_h = ah
	}
	for (a = x1; a < x2; a += 1) { // Add block to selection 
	    if (songs[song].colamount[a] > 0) {
	        for (b = max(songs[song].colfirst[a], y1); b < min(songs[song].collast[a] + 1, y2); b += 1) {
	            if (lockedlayer[b] = 0 || includelocked) {
	                if (songs[song].song_exists[a, b]) {
	                    sa = a - songs[song].selection_x
	                    sb = b - songs[song].selection_y
	                    if (songs[song].selection_colfirst[sa] = -1) songs[song].selection_colfirst[sa] = sb
	                    songs[song].selection_colfirst[sa] = min(songs[song].selection_colfirst[sa], sb)
	                    songs[song].selection_collast[sa] = max(songs[song].selection_collast[sa], sb)
	                    songs[song].selection_exists[sa, sb] = 1
	                    songs[song].selection_ins[sa, sb] = songs[song].song_ins[a, b]
	                    songs[song].selection_key[sa, sb] = songs[song].song_key[a, b]
	                    songs[song].selection_vel[sa, sb] = songs[song].song_vel[a, b]
	                    songs[song].selection_pan[sa, sb] = songs[song].song_pan[a, b]
	                    songs[song].selection_pit[sa, sb] = songs[song].song_pit[a, b]
	                    songs[song].selection_played[sa, sb] = 0
	                    if (!copy) {
	                        remove_block_select(a, b)
	                    }
	                }
	            }
	        }
	    }
	}
	if (!argument[5]) history_set(h_selectadd, x1, y1, x2, y2, copy)
	songs[song].selected += ac
	selection_code_update()
	update_tempo_changes()



}
