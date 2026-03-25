function selection_draw(argument0, argument1, argument2, argument3) {
	// selection_draw(x, y, w, h)
	// Draws the selection.
	var xs, ys, x1, y1, x2, y2, w, h, sa, sb, salpha, a, b, c, d, e, xx;
	x1 = songs[song].selection_x
	y1 = songs[song].selection_y
	x2 = x1 + songs[song].selection_l
	y2 = y1 + songs[song].selection_h
	xs = argument0
	ys = argument1
	w = argument2
	h = argument3
	draw_set_halign(fa_center)
	// Play
	if ((floor(songs[song].marker_pos) != floor(songs[song].marker_prevpos) || (songs[song].marker_prevpos == 0 && songs[song].marker_pos != songs[song].marker_prevpos)) && songs[song].marker_pos >= songs[song].selection_x && songs[song].marker_pos < songs[song].selection_x + songs[song].selection_l) {
	    xx = floor(songs[song].marker_pos) - songs[song].selection_x
	    if (songs[song].selection_colfirst[xx] > -1) {
	        for (b = songs[song].selection_colfirst[xx]; b <= songs[song].selection_collast[xx]; b += 1) {
	            if (songs[song].selection_exists[xx, b]) {
	                a = 1
	                if (songs[song].selection_y + b < songs[song].endb2) c = (songs[song].layervol[songs[song].selection_y + b] / 100) * songs[song].selection_vel[xx,b]
					if (songs[song].selection_y + b < songs[song].endb2) {
						if songs[song].layerstereo[songs[song].selection_y + b] = 100 {
								d = songs[song].selection_pan[xx,b]
						} else d = (songs[song].layerstereo[songs[song].selection_y + b] + songs[song].selection_pan[xx,b]) / 2
					}
					if (songs[song].selection_y + b < songs[song].endb2) e = songs[song].selection_pit[xx,b]
	                if (songs[song].solostr != "") {
	                    if (string_count("|" + string(songs[song].selection_y + b) + "|", songs[song].solostr) = 0) {
	                        a = 0
	                    } else if (songs[song].layerlock[songs[song].selection_y + b] = 1) {
	                        a = 0
	                    }
	                } else if (songs[song].selection_y + b < songs[song].endb2) {
	                    if (songs[song].layerlock[songs[song].selection_y + b] = 1) {
	                        a = 0
	                    }
	                }
	                if (a) {
	                    if (songs[song].selection_ins[xx, b].loaded && songs[song].reference_option != 1) play_sound(songs[song].selection_ins[xx, b], songs[song].selection_key[xx, b], c , d, e)
	                    if (songs[song].selection_ins[xx, b].press) key_played[songs[song].selection_key[xx, b]] = current_time
	                    songs[song].selection_played[xx, b] = current_time
	                }
	            }
	        }
	    }
	}

	if (x1 > songs[song].starta + w || y1 > songs[song].startb + h || x2 <= songs[song].starta || y2 <= songs[song].startb) return 0 // Outside
	for (a = max(songs[song].starta, x1); a < min(songs[song].starta + w, x2); a += 1) {
	    sa = a - songs[song].selection_x
	    if (songs[song].selection_colfirst[sa] > -1) {
	        for (b = max(songs[song].startb, y1); b < min(songs[song].startb + h, y2); b += 1) {
	            sb = b - songs[song].selection_y
	            if (sb >= songs[song].selection_colfirst[sa] && sb <= songs[song].selection_collast[sa]) {
	                if (songs[song].selection_exists[sa, sb]) {
	                    salpha = selection_alpha
	                    if (window < 1) {
	                        if (select = 2) {
	                            if (is_inside(a, b, select_pressa, select_pressb, selbx, selby)) salpha = 0.5 * 0.625
	                        } else if (select = 0 && !cursmarker && playing = 0) {
	                            if (mouse_rectangle(xs + (a - songs[song].starta) * 32, ys + (b - songs[song].startb) * 32, 32, 32)) {
	                                salpha = selection_alpha * (0.8 * (selection_alpha > 0.4) - 0.08 * (selection_alpha > 0.4))
	                                curs = cr_size_all
	                                if (mouse_check_button_pressed(mb_left)) {
	                                    window = w_dragselection
	                                    select_pressa = sa
	                                    select_pressb = sb
	                                    selection_sx = songs[song].selection_x
	                                    selection_sy = songs[song].selection_y
	                                }
	                            }
	                        }
	                    } else if (window = w_dragselection) {
	                        salpha = selection_alpha * (0.8 * (selection_alpha > 0.4) - 0.08 * (selection_alpha > 0.4))
	                    }
	//                    salpha += 0.1 * (1 - (min(1000, current_time - selection_played[sa, sb]) / 1000))
	                    draw_block(xs + (a - songs[song].starta) * 32, ys + (b - songs[song].startb) * 32, songs[song].selection_ins[sa, sb], songs[song].selection_key[sa, sb], songs[song].selection_pan[sa, sb], songs[song].selection_vel[sa, sb], songs[song].selection_pit[sa, sb], 1, salpha)
	                }
	            }
	        }
	    }
	}
	// draw_set_color(c_red)
	// draw_rectangle(xs + (selection_x - starta) * 32, ys + (selection_y - startb) * 32, xs + (selection_x + selection_l - starta) * 32, ys + (selection_y + selection_h - startb) * 32, 1)
	draw_set_halign(fa_left)
	draw_set_alpha(1)
	draw_theme_color()



}
