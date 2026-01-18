function schematic_export() {
	// schematic_export()
	var fn, a, b, c, d, p, xx, yy, zz, len, wid, hei, o, chestx, chesty, chestz, signx, signy, signz, nblocks, layers, cyy, y1, insnum, ins;
	var REPEATER, TORCHON, TORCHOFF, WIRE, LADDER, RAIL, POWEREDRAIL, noteblocks, noteblockx, noteblocky, noteblockz, noteblocknote, noteblockins, noteblockpit;
	if (!structure) fn = string(get_save_filename_ext("Minecraft Schematics (*.schematic)|*.schematic", filename_new_ext(songs[song].filename, "") + ".schematic", "", "Export Schematic"))
	else fn = string(get_save_filename_ext("Minecraft Structures (*.nbt)|*.nbt", filename_new_ext(string_replace_all(string_lower(songs[song].filename), " ", "_"), "") + ".nbt", "", "Export Schematic"))
	if (fn = "") return 0
	if (!structure) fn = enforce_extension(fn, ".schematic")
	else fn = enforce_extension(fn, ".nbt")
	//fn = string_replace_all(fn, ".schematic", "")
	//fn += ".schematic"
	o = obj_controller
	window = -1
	with (create(obj_dummy2)) {
	    // Initialize variables
	    REPEATER = 93
	    TORCHON = 76
	    TORCHOFF = 75
	    WIRE = 55
	    LADDER = 65
	    RAIL = 66
	    POWEREDRAIL = 27
	    chestx = -1
	    chesty = -1
	    chestz = -1
		insnum = 0
		ins[0] = "harp"
		ins[1] = "bass"
		ins[2] = "basedrum"
		ins[3] = "snare"
		ins[4] = "hat"
		ins[5] = "guitar"
		ins[6] = "flute"
		ins[7] = "bell"
		ins[8] = "chime"
		ins[9] = "xylophone"
		ins[10] = "iron_xylophone"
		ins[11] = "cow_bell"
		ins[12] = "didgeridoo"
		ins[13] = "bit"
		ins[14] = "banjo"
		ins[15] = "pling"
		for (var a = 0; a < 240; a++) {
			ins[16 + a] = "harp"
		}
		instrument_list = o.songs[o.song].instrument_list
	    layers = ceil(o.sch_exp_maxheight[o.sch_exp_compress] / 4)
	    block_walkway_block = o.sch_exp_walkway_block
	    block_walkway_data = o.sch_exp_walkway_data
	    block_circuit_block = o.sch_exp_circuit_block
	    block_circuit_data = o.sch_exp_circuit_data
	    block_ground_block = o.sch_exp_ground_block
	    block_ground_data = o.sch_exp_ground_data
	    blockspr = o.sch_exp_notesperrow                          // Blocks per row
	    layout = o.sch_exp_layout                                 // Layout number
	    sch_loop = (o.sch_exp_loop && layout = 0)                       // Whether to loop
	    minecart = (o.sch_exp_minecart && layout < 2)               // Whether to add minecart tracks
	    chest = (o.sch_exp_chest && minecart)                     // Whether to add a minecart chest
	    blocksam = o.sch_exp_totalblocks[o.sch_exp_includelocked] // Amount of blocks
	    with (o) {
	        len = schematic_length()
	        wid = schematic_width()
	        hei = schematic_height()
	    }
	    noteblocks = 0
    
	    // Reset
	    for (a = 0; a < len; a += 1) {
	        for (b = 0; b < wid; b += 1) {
	            for (c = 0; c < hei; c += 1) {
	                sch_block_write(a, b, c, 0)
	                sch_data_write(a, b, c, 0)
	            }
	        }
	    }
    
	    // Create floor
	    for (a = 0; a < len; a += 1) {
	        for (b = 0; b < wid; b += 1) {
	            sch_block_write(a, b, 0, block_ground_block)
	            sch_data_write(a, b, 0, block_ground_data)
	        }
	    }
	    if (layout < 2) {
	        // Create pillar with ladder
	        yy = round(wid / 2)
	        cyy = yy
	        for (b = 1; b < hei - 2; b += 1) {
	            for (a = 0; a < 3; a += 1) {
	                block_walkway(1, yy + a, b)
	            }
	            block_other(0, yy + 2, b, LADDER, 2) // ladder
	        }
	        // Create walkway
	        for (a = -minecart; a < 3 + (minecart && layout = 0); a += 1) {
	            for (b = 2; b < len; b += 1) {
	                block_walkway(b, yy + a, hei - 3)
	                if (a = -1) { // Minecart right side
	                    if (b = len - 1 && layout = 1) { // stop
	                        block_walkway(b, yy + a, hei - 2)
	                    } else if (b mod 12 = 2) { // top
	                        block_walkway(b, yy + a, hei - 2)
	                        if (b > 3) block_other(b, yy + a, hei - 1, RAIL, 0)
	                    } else if (b mod 12 = 3) { // slope down
	                        block_other(b, yy - 1, hei - 2, POWEREDRAIL, 4)
	                        block_other(b, yy - 2, hei - 2, TORCHOFF, 5)
	                        block_walkway(b, yy - 2, hei - 3)
	                        block_other(b, yy - 2, hei - 4, TORCHON, 5)
	                    } else if (b mod 12 = 1) { // slope up
	                        block_other(b, yy + a, hei - 2, RAIL, 5)
	                    } else { // normal
	                        block_other(b, yy + a, hei - 2, RAIL, 0)
	                    }
	                }
	            }
	        }
	        if (chest) {
	            chestx = 2
	            chesty = yy - 1
	            chestz = hei - 1
	            block_other(chestx, chesty, chestz, 54, 4)
	        }
	        // Controls
	        block_circuit(1, yy, hei - 2)
	        block_circuit(1, yy + 1, hei - 2)
	        block_other(1, yy, hei - 1, 35, 11) // wool
	        block_other(1, yy + 1, hei - 1, 35, 11)
	        block_other(2, yy, hei - 1, 68, 3) // Button
	        block_other(2, yy + 1, hei - 1, 77, 3)
	        if (sch_loop) {
	            block_other(2, yy, hei - 2, 68, 3)
	            block_other(2, yy + 1, hei - 2, 69, 3 + 8)
	            block_other(1, yy + 1, hei - 3, WIRE, 15)
	            block_circuit(0, yy + 1, hei - 3)
	            block_other(0, yy, hei - 3, TORCHOFF, 1)
	        }
	        signx = 2
	        signy = yy
	        signz = hei - 1
	        // Back
	        block_circuit(0, yy + 1, hei - 2)
	        block_other(0, yy + 1, hei - 1, WIRE, 0)
        
	        block_circuit(0, yy, hei - 2)
	        block_other(0, yy, hei - 1, WIRE, 0)
        
	        block_circuit(0, yy - 1, hei - 2)
	        block_other(0, yy - 1, hei - 1, WIRE, 0)
	        block_other(0, yy - 2, hei - 2, TORCHON, 1)
        
	        block_circuit(0, yy - 2, hei - 4)
	        block_other(0, yy - 2, hei - 3, WIRE, 15)
	        block_other(0, yy - 3, hei - 4, TORCHOFF, 1)
        
	        // Create vertical transmission
	        d = 0
	        for (a = layers - 1; a >= 0; a -= 1) {
	            if (a > 0) {
	                block_other(0, yy - 1 - d, a * 3 + 1, TORCHON, 2)
	                block_circuit(0, yy - 1, a * 3 - 1 + d)
	                block_other(0, yy - 1, a * 3 + d, WIRE, 15)
	                block_other(0, yy - 2, a * 3 - 1 + d, TORCHOFF, 1)
	            }
	            p = 0
	            c = a * 2
	            for (b = yy - 2 - d; b >= 0; b -= 1) {
	                block_circuit(0, b, a * 3 + 1)
	                block_other(0, b, a * 3 + 2, WIRE, 0)
	                p += 1
	                if (c > 0 && b < yy - 3 - d) {
	                    block_repeater(0, b, a * 3 + 2, min(4, c) - 1, 1, 0)
	                    c -= 4
	                    p = 0
	                }
	                if (p = 16 || b = 1) {
	                    block_repeater(0, b, a * 3 + 2, 0, 1, 0)
	                    p = 0
	                }
	            }
	            for (b = 0; b < 4; b += 1) {
	                block_other(b, 0, a * 3 + 2, WIRE, 0)
	                block_circuit(b, 0, a * 3 + 1)
	            }
	            // Add repeaters to even out delay
	            d=!d
	        }
	        // Add note blocks
	        xx = 3
	        yy = 0
	        var circ, rep, dir, nblocks, nblockins, nblockkey, nblockpit, turn, lturnx, lturny, lturndel;
	        rep = 0
	        dir = 1 // 1 or -1
	        circ = 1 // 1 = From, -1 = To
	        // screen_redraw()
	        lturnx = -1
	        lturny = -1
	        lturndel = 0
	        for (a = 0; a <= o.songs[o.song].enda; a += 1) {
	            nblocks = 0
	            rep += 1
	            if (o.sch_exp_tempo = 1) rep += 1
	            if (o.sch_exp_tempo = 2) rep += 3
	            if (o.songs[o.song].colamount[a] > 0) { // Calculate note blocks for this tick
	                for (b = 0; b <= o.songs[o.song].collast[a]; b += 1) {
	                    if (o.songs[o.song].song_exists[a, b] && (o.lockedlayer[b] = 0 || o.sch_exp_includelocked)) {
	                        if ((o.songs[o.song].song_key[a, b] > 32 && o.songs[o.song].song_key[a, b] < 58) || (o.structure && o.command_block && o.songs[o.song].song_key[a, b] >= 9 && o.songs[o.song].song_key[a, b] <= 81)) {
	                            nblockins[nblocks] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b])
	                            nblockkey[nblocks] = o.songs[o.song].song_key[a, b]
	                            nblockpit[nblocks] = o.songs[o.song].song_pit[a, b]
	                            nblocks += 1
	                        } else if (!o.sch_exp_compress) {
	                            nblockins[nblocks] = -1
	                            nblockkey[nblocks] = 0
	                            nblockpit[nblocks] = 0
	                            nblocks += 1 
	                        }
	                    } else if (!o.sch_exp_compress) {
	                        nblockins[nblocks] = -1
	                        nblockkey[nblocks] = 0
	                        nblockpit[nblocks] = 0
	                        nblocks += 1
	                    }
	                }
	            }
	            if (nblocks > 0 || rep = 4) {
	                nblocks -= 1
	                for (b = 0; b < layers; b += 1) { // add blocks
	                    y1 = yy + dir
	                    block_repeater(xx, y1, b * 3 + 2, rep - 1, 3 * (dir = 1) + (dir = -1), 0)
	                    block_circuit(xx, y1, b * 3 + 1)
	                    block_circuit(xx, y1 + dir, b * 3 + 2)
	                    if (b > 0) {
	                        block_circuit(xx, y1, b * 3)
	                        block_circuit(xx, y1 + dir, b * 3)
	                    }
	                    block_circuit(xx, y1 + dir * 2, b * 3 + 1)
	                    if (nblocks > -1) { // Note block #1
	                        block_other(xx, y1 + dir, b * 3 + 1, WIRE, 0)
	                        if (nblockins[nblocks] > -1) {
	                            block_other(xx - 1, y1 + dir * 2, b * 3 + 1, 25, 0)
	                            block_other(xx - 1, y1 + dir * 2, b * 3, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
	                            noteblockx[noteblocks] = xx - 1
	                            noteblocky[noteblocks] = y1 + dir * 2
	                            noteblockz[noteblocks] = b * 3 + 1
	                            noteblocknote[noteblocks] = nblockkey[nblocks] - 33
								noteblockins[noteblocks] = nblockins[nblocks]
								noteblockpit[noteblocks] = nblockpit[nblocks]
	                            noteblocks += 1
	                        }
	                        nblocks -= 1
	                    }
	                    if (nblocks > -1) { // Note block #2
	                        if (nblockins[nblocks] > -1) {
	                            block_other(xx + 1, y1 + dir * 2, b * 3 + 1, 25, 0)
	                            block_other(xx + 1, y1 + dir * 2, b * 3, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
	                            noteblockx[noteblocks] = xx + 1
	                            noteblocky[noteblocks] = y1 + dir * 2
	                            noteblockz[noteblocks] = b * 3 + 1
	                            noteblocknote[noteblocks] = nblockkey[nblocks] - 33
								noteblockins[noteblocks] = nblockins[nblocks]
								noteblockpit[noteblocks] = nblockpit[nblocks]
	                            noteblocks += 1
	                        }
	                        nblocks -= 1
	                    }
	                    if (nblocks > -1) { // Note block #3
	                        if (nblockins[nblocks] > -1) {
	                            block_other(xx - 1, y1 + dir, b * 3 + 2, 25, 0)
	                            block_other(xx - 1, y1 + dir, b * 3 + 1, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
	                            noteblockx[noteblocks] = xx - 1
	                            noteblocky[noteblocks] = y1 + dir
	                            noteblockz[noteblocks] = b * 3 + 2
	                            noteblocknote[noteblocks] = nblockkey[nblocks] - 33
								noteblockins[noteblocks] = nblockins[nblocks]
								noteblockpit[noteblocks] = nblockpit[nblocks]
	                            noteblocks += 1
	                        }
	                        nblocks -= 1
	                    }
	                    if (nblocks > -1) { // Note block #4
	                        if (nblockins[nblocks] > -1) {
	                            block_other(xx + 1, y1 + dir, b * 3 + 2, 25, 0)
	                            block_other(xx + 1, y1 + dir, b * 3 + 1, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
	                            noteblockx[noteblocks] = xx + 1
	                            noteblocky[noteblocks] = y1 + dir
	                            noteblockz[noteblocks] = b * 3 + 2
	                            noteblocknote[noteblocks] = nblockkey[nblocks] - 33
								noteblockins[noteblocks] = nblockins[nblocks]
								noteblockpit[noteblocks] = nblockpit[nblocks]
	                            noteblocks += 1
	                        }
	                        nblocks -= 1
	                    }
	                }
	                rep = 0
	                yy += 2 * dir
	                turn = 0
	                // Switch direction?
	                if (layout = 0) {
	                    if (circ = 1) {
	                        if (dir = 1) {
	                            if (xx = len - 2) {
	                                if (yy >= cyy) {
	                                    circ = -1
	                                    turn = 0
	                                    yy += 1
	                                    for (b = 0; b < layers; b += 1) {
	                                        for (c = 0; c < 2; c += 1) {
	                                            block_circuit(xx, yy + c, b * 3 + 1)
	                                            block_other(xx, yy + c, b * 3 + 2, WIRE, 0)
	                                        }
	                                    }
	                                    yy += 1
	                                }
	                            } else {
	                                turn = (yy >= cyy - 2)
	                            }
	                        }
	                        if (dir = -1) turn = (yy <= 2)
	                    } else {
	                        if (dir = 1) turn = (yy >= wid - 3)
	                        if (dir = -1) turn = (yy <= cyy + 5)
	                    }
	                } else {
	                    if (dir = 1) turn = (yy >= wid - 3)
	                    if (dir = -1) turn = (yy <= 2)
	                }
	                if (a = o.songs[o.song].enda) turn = 0
	                if (turn) {
	                    for (b = 0; b < layers; b += 1) { // Connect to new row
	                        block_other(xx, yy, b * 3 + 1, WIRE, 0)
	                        if (b > 0 && b < layers - 1) block_circuit(xx, yy, b * 4)
	                        block_other(xx, yy + dir, b * 3 + 2, WIRE, 0)
	                        block_circuit(xx, yy + dir, b * 3 + 1)
	                        for (c = 0; c < 4; c += 1) {
	                            block_other(xx + c * circ, yy + dir * 2, b * 3 + 2, WIRE, 0)
	                            block_circuit(xx + c * circ, yy + dir * 2, b * 3 + 1)
	                        }
	                    }
	                    yy += dir * 2
	                    dir = -dir
	                    if (circ = -1 && dir = 1) {
	                        lturnx = xx
	                        lturny = yy - 1
	                        lturndel = (o.songs[o.song].enda - a) - 8
	                    }
	                    xx += 3 * circ
	                    if (xx <= 0) break
	                }
	            }
	        }
	        if (layout = 0 && minecart) {
	            for (b = 2; b < len; b += 1) { // Add minecart to left side
	                if (b = 2) { // stop
	                    block_walkway(b, cyy + 3, hei - 2)
	                } else if (b < lturnx) { // end of song
	                    if (b mod 12 = 6) {
	                        block_other(b, cyy + 3, hei - 2, POWEREDRAIL, 8)
	                        block_other(b, cyy + 2, hei - 2, TORCHON, 5)
	                    } else {
	                        block_other(b, cyy + 3, hei - 2, RAIL, 0)
	                    }
	                } else if (b mod 12 = 6) { // slope down
	                    block_other(b, cyy + 3, hei - 2, POWEREDRAIL, 5)
	                    block_other(b, cyy + 4, hei - 2, TORCHOFF, 5)
	                    block_walkway(b, cyy + 4, hei - 3)
	                    block_other(b, cyy + 4, hei - 4, TORCHON, 5)
	                } else if (b mod 12 = 7) { // top
	                    block_other(b, cyy + 3, hei - 1, RAIL, 0)
	                    block_walkway(b, cyy + 3, hei - 2)
	                } else if (b mod 12 = 8) { // slope down
	                    block_other(b, cyy + 3, hei - 2, RAIL, 4)
	                } else { // normal
	                    block_other(b, cyy + 3, hei - 2, RAIL, 0)
	                }
	            }
	            // Turn
	            block_other(len - 1, cyy - 1, hei - 2, RAIL, 8)
	            block_other(len - 1, cyy, hei - 2, RAIL, 1)
	            block_other(len - 1, cyy + 1, hei - 2, RAIL, 1)
	            block_other(len - 1, cyy + 2, hei - 2, RAIL, 1)
	            block_other(len - 1, cyy + 3, hei - 2, RAIL, 9)
	        }
	        if (sch_loop && lturnx > -1) { // Loop
	            xx = lturnx
	            yy = lturny
	            zz = (layers - 1) * 3
	            block_other(xx, yy, zz + 1, TORCHON, 1)
	            a = 15
	            for (b = xx - 1; b > 3; b -= 1) {
	                if (zz > 0) block_circuit(b, yy, zz)
	                if (lturndel > 0 || a = 0) {
	                    block_repeater(b, yy, zz + 1, median(1, lturndel, 4) - 1, 0, 1)
	                    lturndel -= 4
	                    a = 15
	                } else {
	                    block_other(b, yy, zz + 1, WIRE, a)
	                    block_circuit(b, yy, zz + 2)
	                    a -= 1
	                }
	            }
	            block_other(2, cyy + 1, hei - 4, TORCHON, 5)
	            block_circuit(2, cyy + 1, hei - 5)
	            block_other(2, cyy + 1, hei - 6, TORCHOFF, 4)
	            block_circuit(3, cyy + 1, hei - 6)
	        }
	    } else { // CLASSIC
	        // Floor
	        for (a = 0; a < len; a += 1) {
	            for (b = 0; b < wid - 1; b += 1) {
	                if (a > 0 && b > 0 && a < len - 1 && b < wid - 2 && o.sch_exp_glass) {
	                    block_other(a, b, hei - 3, 20, 0)
	                    block_other(a, b, hei - 3, 20, 0)
	                } else {
	                    block_walkway(a, b, hei - 3)
	                    block_walkway(a, b, hei - 3)
	                }
	            }
	        }
	        // Controls
	        block_walkway(2, wid - 2, hei - 2)
	        block_walkway(3, wid - 2, hei - 2)
	        block_other(2, wid - 2, hei - 1, 35, 11)
	        block_other(3, wid - 2, hei - 1, 35, 11)
	        block_other(2, wid - 3, hei - 1, 68, 5)
	        block_other(3, wid - 3, hei - 1, 77, 1)
	        // Back
	        block_other(3, wid - 1, hei - 1, WIRE, 0)
	        block_circuit(3, wid - 1, hei - 2)
	        block_other(2, wid - 1, hei - 2, WIRE, 0)
	        block_circuit(2, wid - 1, hei - 3)
	        block_other(1, wid - 1, hei - 3, TORCHON, 4)
	        // Layers
	        c = 1
	        for (a = layers - 1; a >= 0; a -= 1) {
	            d = a * 2
	            for (b = wid - 2 - c; b > wid - 8; b -= 1) {
	                block_circuit(1, b, a * 3 + 1)
	                if (d > 0 && b < wid - 2 - c) {
	                    block_repeater(1, b, a * 3 + 2, min(4, d) - 1, 1, 0)
	                    d -= 4
	                } else {
	                    block_other(1, b, a * 3 + 2, WIRE, 0)
	                }
	            }
	            if (a > 0) block_other(1, wid - 1 - c, a * 3 + 1, TORCHON, 2)
	            block_circuit(1, wid - 1, a * 3 + 3 - c)
	            block_other(1, wid - 1, a * 3 + 4 - c, WIRE, 15)
	            block_other(1, wid - 2, a * 3 + 3 - c, TORCHOFF, 1)
	            c=!c
	        }
	        // Ladder
	        for (c = 1; c < hei - 2; c += 1) {
	            block_walkway(0, wid - 2, c)
	            block_other(0, wid - 1, c, 65, 4)
	        }
	        signx = 2
	        signy = wid - 3
	        signz = hei - 1
	        xx = 1
	        yy = wid - 7
	        var rep, dir, nblocks, nblockins, nblockkey, nblockpit, turn;
	        rep = 0
	        dir = -1 // 1 or -1
	        for (a = 0; a <= o.songs[o.song].enda; a += 1) {
	            nblocks = 0
	            rep += 1
	            if (o.sch_exp_tempo = 1) rep += 1
	            if (o.sch_exp_tempo = 2) rep += 3
	            if (o.songs[o.song].colamount[a] > 0) { // Calculate note blocks for this tick
	                for (b = 0; b <= o.songs[o.song].collast[a]; b += 1) {
	                    if (o.songs[o.song].song_exists[a, b] && (o.lockedlayer[b] = 0 || o.sch_exp_includelocked)) {
	                        if ((o.songs[o.song].song_key[a, b] > 32 && o.songs[o.song].song_key[a, b] < 58) || (o.structure && o.command_block && o.songs[o.song].song_key[a, b] >= 9 && o.songs[o.song].song_key[a, b] <= 81)) {
	                            nblockins[nblocks] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b])
	                            nblockkey[nblocks] = o.songs[o.song].song_key[a, b]
	                            nblockpit[nblocks] = o.songs[o.song].song_pit[a, b]
	                            nblocks += 1
	                        } else if (!o.sch_exp_compress) {
	                            nblockins[nblocks] = -1
	                            nblockkey[nblocks] = 0
	                            nblockpit[nblocks] = 0
	                            nblocks += 1 
	                        }
	                    } else if (!o.sch_exp_compress) {
	                        nblockins[nblocks] = -1
	                        nblockkey[nblocks] = 0
	                        nblockpit[nblocks] = 0
	                        nblocks += 1
	                    }
	                }
	            }
	            if (nblocks > 0 || rep = 4) {
	                nblocks -= 1
	                for (b = 0; b < layers; b += 1) { // add blocks
	                    y1 = yy + dir
	                    block_repeater(xx, y1, b * 3 + 2, rep - 1, 3 * (dir = 1) + (dir = -1), 0)
	                    block_circuit(xx, y1, b * 3 + 1)
	                    block_circuit(xx, y1 + dir, b * 3 + 2)
	                    if (b > 0) {
	                        block_circuit(xx, y1, b * 3)
	                        block_circuit(xx, y1 + dir, b * 3)
	                    }
	                    block_circuit(xx, y1 + dir * 2, b * 3 + 1)
	                    if (nblocks > -1) { // Note block #1
	                        block_other(xx, y1 + dir, b * 3 + 1, WIRE, 0)
	                        if (nblockins[nblocks] > -1) {
	                            block_other(xx - 1, y1 + dir * 2, b * 3 + 1, 25, 0)
	                            block_other(xx - 1, y1 + dir * 2, b * 3, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
	                            noteblockx[noteblocks] = xx - 1
	                            noteblocky[noteblocks] = y1 + dir * 2
	                            noteblockz[noteblocks] = b * 3 + 1
	                            noteblocknote[noteblocks] = nblockkey[nblocks] - 33
								noteblockins[noteblocks] = nblockins[nblocks]
								noteblockpit[noteblocks] = nblockpit[nblocks]
	                            noteblocks += 1
	                        }
	                        nblocks -= 1
	                    }
	                    if (nblocks > -1) { // Note block #2
	                        if (nblockins[nblocks] > -1) {
	                            block_other(xx + 1, y1 + dir * 2, b * 3 + 1, 25, 0)
	                            block_other(xx + 1, y1 + dir * 2, b * 3, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
	                            noteblockx[noteblocks] = xx + 1
	                            noteblocky[noteblocks] = y1 + dir * 2
	                            noteblockz[noteblocks] = b * 3 + 1
	                            noteblocknote[noteblocks] = nblockkey[nblocks] - 33
								noteblockins[noteblocks] = nblockins[nblocks]
								noteblockpit[noteblocks] = nblockpit[nblocks]
	                            noteblocks += 1
	                        }
	                        nblocks -= 1
	                    }
	                    if (nblocks > -1) { // Note block #3
	                        if (nblockins[nblocks] > -1) {
	                            block_other(xx - 1, y1 + dir, b * 3 + 2, 25, 0)
	                            block_other(xx - 1, y1 + dir, b * 3 + 1, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
	                            noteblockx[noteblocks] = xx - 1
	                            noteblocky[noteblocks] = y1 + dir
	                            noteblockz[noteblocks] = b * 3 + 2
	                            noteblocknote[noteblocks] = nblockkey[nblocks] - 33
								noteblockins[noteblocks] = nblockins[nblocks]
								noteblockpit[noteblocks] = nblockpit[nblocks]
	                            noteblocks += 1
	                        }
	                        nblocks -= 1
	                    }
	                    if (nblocks > -1) { // Note block #4
	                        if (nblockins[nblocks] > -1) {
	                            block_other(xx + 1, y1 + dir, b * 3 + 2, 25, 0)
	                            block_other(xx + 1, y1 + dir, b * 3 + 1, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
	                            noteblockx[noteblocks] = xx + 1
	                            noteblocky[noteblocks] = y1 + dir
	                            noteblockz[noteblocks] = b * 3 + 2
	                            noteblocknote[noteblocks] = nblockkey[nblocks] - 33
								noteblockins[noteblocks] = nblockins[nblocks]
								noteblockpit[noteblocks] = nblockpit[nblocks]
	                            noteblocks += 1
	                        }
	                        nblocks -= 1
	                    }
	                }
	                rep = 0
	                yy += 2 * dir
	                turn = 0
	                if (dir = 1) turn = (yy >= wid - 4)
	                if (dir = -1) turn = (yy <= 2)
	                if (a = o.songs[o.song].enda) turn = 0
	                if (turn) {
	                    for (b = 0; b < layers; b += 1) { // Connect to new row
	                        block_other(xx, yy, b * 3 + 1, WIRE, 0)
	                        if (b > 0) block_circuit(xx, yy, b * 4)
	                        block_other(xx, yy + dir, b * 3 + 2, WIRE, 0)
	                        block_circuit(xx, yy + dir, b * 3 + 1)
	                        for (c = 0; c < 4; c += 1) {
	                            block_other(xx + c, yy + dir * 2, b * 3 + 2, WIRE, 0)
	                            block_circuit(xx + c, yy + dir * 2, b * 3 + 1)
	                        }
	                    }
	                    yy += dir * 2
	                    dir = -dir
	                    xx += 3
	                }
	            }
	        }
	    }
    
	    // Write to file
	    buffer = buffer_create(8, buffer_grow, 1)
		
		if (!obj_controller.structure) {
	    TAG_Compound("Schematic")
	    TAG_Short("Height", hei)
	    TAG_Short("Length", len)
	    TAG_Short("Width", wid)
	    TAG_List("Entities", minecart, 10)
	    if (minecart) {
	        if (o.sch_exp_minecraft_old)
	            TAG_String("id", "Minecart")
	        else
	            TAG_String("id", "minecraft:minecart")
	        TAG_Byte("OnGround", 0)
	        TAG_Short("Air", 300)
	        TAG_Short("Fire", -1)
	        TAG_Int("Type", 0)
	        TAG_Float("FallDistance", 0)
	        TAG_List("Motion", 3, 6)
	            buffer_write_double_be(0)
	            buffer_write_double_be(0)
	            buffer_write_double_be(0)
	        TAG_List("Pos", 3, 6)
	            buffer_write_double_be(wid - 1 - (cyy - 1 - 0.5))
	            buffer_write_double_be(hei - 1)
	            buffer_write_double_be(3.5)
	        TAG_List("Rotation", 2, 5)
	            buffer_write_float_be(0)
	            buffer_write_float_be(0)
	        TAG_End()
	    }
	    TAG_List("TileEntities", 1 + noteblocks + sch_loop + chest, 10)
	        if (o.sch_exp_minecraft_old)
	            TAG_String("id", "Sign")
	        else
	            TAG_String("id", "minecraft:sign")
	        TAG_Int("x", wid - 1 - signy)
	        TAG_Int("y", signz)
	        TAG_Int("z", signx)
	        if (o.sch_exp_minecraft_old) {
	            TAG_String("Text1", "Song generated")
	            TAG_String("Text2", "by the")
	            TAG_String("Text3", "Note Block")
	            TAG_String("Text4", "Studio")
	        } else {
	            TAG_String("Text1", "{\"text\": \"Song generated\"}")
	            TAG_String("Text2", "{\"text\": \"by the\"}")
	            TAG_String("Text3", "{\"text\": \"Note Block\"}")
	            TAG_String("Text4", "{\"text\": \"Studio\"}")
	        }
	        TAG_End()
	        if (sch_loop) {
	            if (o.sch_exp_minecraft_old)
	                TAG_String("id", "Sign")
	            else
	                TAG_String("id", "minecraft:sign")
	            TAG_Int("x", wid - 1 - signy)
	            TAG_Int("y", signz - 1)
	            TAG_Int("z", signx)
	            if (o.sch_exp_minecraft_old) {
	                TAG_String("Text1", "Looping ON") 
	                TAG_String("Text2", "") 
	                TAG_String("Text3", "")
	                TAG_String("Text4", "Looping OFF")
	            } else {
	                TAG_String("Text1", "{\"text\": \"Looping ON\"}")
	                TAG_String("Text2", "{\"text\": \"\"}")
	                TAG_String("Text3", "{\"text\": \"\"}")
	                TAG_String("Text4", "{\"text\": \"Looping OFF\"}")
	            }
	            TAG_End()
	        }
	        for (a = 0; a < noteblocks; a += 1) {
	            if (o.sch_exp_minecraft_old)
	                TAG_String("id", "Music")
	            else
	                TAG_String("id", "minecraft:noteblock")
	            TAG_Int("x", wid - 1 - noteblocky[a])
	            TAG_Int("y", noteblockz[a])
	            TAG_Int("z", noteblockx[a])
	            TAG_Byte("note", noteblocknote[a])
	            TAG_End()
	        }
	        if (chest) {
	            if (o.sch_exp_minecraft_old)
	                TAG_String("id", "Chest")
	            else
	                TAG_String("id", "minecraft:chest")
	            TAG_Int("x", wid - 1 - chesty)
	            TAG_Int("y", chestz)
	            TAG_Int("z", chestx)
	            TAG_List("Items", 27, 10)
	            for (a = 0; a < 27; a += 1) {
	                if (o.sch_exp_minecraft_old)
	                    TAG_String("id", "328")
	                else
	                    TAG_String("id", "minecraft:minecart")
	                TAG_Short("Damage", 0)
	                TAG_Byte("Count", 1)
	                TAG_Byte("Slot", a)
	                TAG_End()
	            }
	            TAG_End()
	        }
	    TAG_String("Materials", "Alpha")
	    TAG_Byte_Array("Blocks", len * wid * hei)
	    for (c = 0; c < hei; c += 1) {
	        for (a = 0; a < len; a += 1) {
	            for (b = wid - 1; b >= 0; b -= 1) {
	                buffer_write_byte(sch_block_read(a, b, c))
	            }
	        }
	    }
	    TAG_Byte_Array("Data", len * wid * hei)
	    for (c = 0; c < hei; c += 1) {
	        for (a = 0; a < len; a += 1) {
	            for (b = wid - 1; b >= 0; b -= 1) {
	                buffer_write_byte(sch_data_read(a, b, c))
	            }
	        }
	    }
	    TAG_Compound("Version")
	        if (o.sch_exp_minecraft_old) {
	            TAG_String("Name", "1.8")
	            TAG_Byte("Snapshot", 0)
	        } else {
	            TAG_Int("Id", 922)
	            TAG_String("Name", "1.11.2")
	            TAG_Byte("Snapshot", 0)
	        }
	        TAG_End()
	    TAG_End()
		} else {
		TAG_Compound("")
		TAG_Int("DataVersion", 1519)
		TAG_List("size", 3, 3)
			buffer_write_int_be(32)
			buffer_write_int_be(hei)
			if (len <= 32) buffer_write_int_be(len)
			else buffer_write_int_be(32)
		insnum = ds_list_size(instrument_list)
		TAG_List("palette", 29 + insnum * 26, 10)
			TAG_String("Name", "minecraft:" + block_get_namespaced_id(block_walkway_block, block_walkway_data))
			TAG_End()
			TAG_String("Name", "minecraft:" + block_get_namespaced_id(block_circuit_block, block_circuit_data))
			TAG_End()
			TAG_String("Name", "minecraft:" + block_get_namespaced_id(block_ground_block, block_ground_data))
			TAG_End()
			for (a = 0; a < insnum; a += 1) {
				TAG_String("Name", "minecraft:" + block_get_namespaced_id(o.sch_exp_ins_block[a], o.sch_exp_ins_data[a]))
				if (a = 9) {
					TAG_Compound("Properties")
						TAG_String("axis", "y")
						TAG_End()
				}
				TAG_End()
			}
			for (a = 0; a < insnum; a += 1) {
				for (b = 0; b < 25; b += 1) {
					if (!o.command_block) {
						TAG_String("Name", "minecraft:note_block")
						TAG_Compound("Properties")
							TAG_String("instrument", ins[a])
							TAG_String("note", string(b))
							TAG_String("powered", "false")
							TAG_End()
						TAG_End()
					} else {
						TAG_String("Name", "minecraft:command_block")
						TAG_Compound("Properties")
							TAG_String("facing", "up")
							TAG_End()
						TAG_End()
					}
				}
			}
			TAG_String("Name", "minecraft:blue_wool")
			TAG_End()
			TAG_String("Name", "minecraft:air")
			TAG_End()
			TAG_String("Name", "minecraft:ladder")
			TAG_Compound("Properties")
				TAG_String("facing", "north")
				TAG_String("waterlogged", "false")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:redstone_wire")
			TAG_Compound("Properties")
				TAG_String("east", "side")
				TAG_String("north", "side")
				TAG_String("power", "0")
				TAG_String("south", "side")
				TAG_String("west", "side")
				TAG_End()
			TAG_End()
			for (a = 1; a < 5; a += 1) {
				TAG_String("Name", "minecraft:repeater")
				TAG_Compound("Properties")
					TAG_String("delay", string(a))
					TAG_String("facing", "east")
					TAG_String("locked", "false")
					TAG_String("powered", "false")
					TAG_End()
				TAG_End()
			}
			for (a = 1; a < 5; a += 1) {
				TAG_String("Name", "minecraft:repeater")
				TAG_Compound("Properties")
					TAG_String("delay", string(a))
					TAG_String("facing", "west")
					TAG_String("locked", "false")
					TAG_String("powered", "false")
					TAG_End()
				TAG_End()
			}
			TAG_String("Name", "minecraft:repeater")
			TAG_Compound("Properties")
				TAG_String("delay", "4")
				TAG_String("facing", "south")
				TAG_String("locked", "false")
				TAG_String("powered", "true")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:redstone_torch")
			TAG_Compound("Properties")
				TAG_String("lit", "false")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:redstone_torch")
			TAG_Compound("Properties")
				TAG_String("lit", "true")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:stone_button")
			TAG_Compound("Properties")
				TAG_String("face", "wall")
				TAG_String("facing", "south")
				TAG_String("powered", "false")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:oak_wall_sign")
			TAG_Compound("Properties")
				TAG_String("facing", "south")
				TAG_String("waterlogged", "false")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:powered_rail")
			TAG_Compound("Properties")
				TAG_String("powered", "false")
				TAG_String("shape", "north_south")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:chest")
			TAG_Compound("Properties")
				TAG_String("facing", "west")
				TAG_String("type", "single")
				TAG_String("waterlogged", "false")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:rail")
			TAG_Compound("Properties")
				TAG_String("shape", "north_south")
				TAG_String("waterlogged", "false")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:redstone_wall_torch")
			TAG_Compound("Properties")
				TAG_String("lit", "false")
				TAG_String("facing", "east")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:redstone_wall_torch")
			TAG_Compound("Properties")
				TAG_String("lit", "true")
				TAG_String("facing", "east")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:redstone_wall_torch")
			TAG_Compound("Properties")
				TAG_String("lit", "false")
				TAG_String("facing", "west")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:redstone_wall_torch")
			TAG_Compound("Properties")
				TAG_String("lit", "true")
				TAG_String("facing", "west")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:lever")
			TAG_Compound("Properties")
				TAG_String("powered", "true")
				TAG_String("facing", "south")
				TAG_String("face", "wall")
				TAG_End()
			TAG_End()
			TAG_String("Name", "minecraft:redstone_wall_torch")
			TAG_Compound("Properties")
				TAG_String("lit", "true")
				TAG_String("facing", "north")
				TAG_End()
			TAG_End()
		TAG_List("entities", minecart, 10)
		if (minecart) {
	        TAG_List("pos", 3, 6)
	            buffer_write_double_be(wid - 1 - (cyy - 1 - 0.5))
	            buffer_write_double_be(hei - 1)
	            buffer_write_double_be(3.5)
	        TAG_List("blockPos", 3, 3)
	            buffer_write_int_be(wid - 1 - (cyy - 1 - 0.5) - 0.5)
	            buffer_write_int_be(hei - 1)
	            buffer_write_int_be(3)
			TAG_Compound("")
				TAG_Byte("OnGround", 0)
				TAG_Short("Air", 300)
				TAG_Short("Fire", -1)
				TAG_Float("FallDistance", 0)
				TAG_List("Motion", 3, 6)
				    buffer_write_double_be(0)
				    buffer_write_double_be(0)
				    buffer_write_double_be(0)
				TAG_List("Rotation", 2, 5)
				    buffer_write_float_be(0)
				    buffer_write_float_be(0)
				TAG_List("Pos", 3, 6)
					buffer_write_double_be(wid - 1 - (cyy - 1 - 0.5))
					buffer_write_double_be(hei - 1)
					buffer_write_double_be(3.5)
				TAG_End()
			TAG_End()
	    }
		TAG_List("blocks", hei * len * wid + 1 + sch_loop, 10)
			TAG_Compound("nbt")
				TAG_String("Color", "black")
				TAG_String("id", "minecraft:sign")
	            TAG_String("Text1", "{\"text\": \"Song generated\"}")
	            TAG_String("Text2", "{\"text\": \"by the\"}")
	            TAG_String("Text3", "{\"text\": \"Note Block\"}")
	            TAG_String("Text4", "{\"text\": \"Studio\"}")
				TAG_End()
			TAG_List("pos", 3, 3)
				buffer_write_int_be(wid - 1 - signy)
				buffer_write_int_be(signz)
				buffer_write_int_be(signx)
			TAG_Int("state", insnum * 26 + 19)
	        TAG_End()
			if (sch_loop) {
				TAG_Compound("nbt")
					TAG_String("Color", "black")
					TAG_String("id", "minecraft:sign")
				        TAG_String("Text1", "{\"text\": \"Looping ON\"}")
				        TAG_String("Text2", "{\"text\": \"\"}")
				        TAG_String("Text3", "{\"text\": \"\"}")
				        TAG_String("Text4", "{\"text\": \"Looping OFF\"}")
					TAG_End()
				TAG_List("pos", 3, 3)
					buffer_write_int_be(wid - 1 - signy)
					buffer_write_int_be(signz - 1)
					buffer_write_int_be(signx)
				TAG_Int("state", insnum * 26 + 19)
				TAG_End()
			}
			var soundname, soundpitch, soundnote;
			for (a = 0; a < noteblocks; a += 1) {
				if (o.command_block) {
					TAG_Compound("nbt")
						soundname = dat_instrument(noteblockins[a])
						soundpitch = dat_pitch(noteblocknote[a] + 33 + noteblockpit[a] / 100)
						if (noteblocknote[a] + noteblockpit[a] / 100 < 0) soundname += "_-1"
						else if (noteblocknote[a] + noteblockpit[a] / 100 > 24) soundname += "_1"
						TAG_String("Command", "playsound "+ soundname +" block @a ~ ~ ~ 3 " + string(soundpitch))
						TAG_Byte("TrackOutput", 0)
						TAG_Byte("powered", 0)
						TAG_Byte("auto", 0)
						TAG_Byte("conditionMet", 1)
						TAG_Byte("UpdateLastExecution", 1)
						TAG_End()
				}
				TAG_List("pos", 3, 3)
					buffer_write_int_be(wid - 1 - noteblocky[a])
					buffer_write_int_be(noteblockz[a])
					buffer_write_int_be(noteblockx[a])
	            TAG_Int("state", 3 + insnum + (noteblockins[a] * 25 + noteblocknote[a]) * !o.command_block)
	            TAG_End()
	        }
			if (chest) {
				TAG_Compound("nbt")
					TAG_List("Items", 27, 10)
						for (a = 0; a < 27; a += 1) {
							TAG_Byte("Count", 1)
							TAG_String("id", "minecraft:minecart")
							TAG_Byte("Slot", a)
							TAG_End()
						}
					TAG_String("id", "minecraft:chest")
					TAG_End()
				TAG_List("pos", 3, 3)
					buffer_write_int_be(wid - 1 - chesty)
					buffer_write_int_be(chestz)
					buffer_write_int_be(chestx)
				TAG_Int("state", insnum * 26 + 21)
				TAG_End()
			}
			for (c = 0; c < hei; c += 1) {
			    for (a = 0; a < len; a += 1) {
			        for (b = wid - 1; b >= 0; b -= 1) {
						if (sch_block_read(a, b, c) != 25 && sch_block_read(a, b, c) != 54) {
						TAG_List("pos", 3, 3)
							buffer_write_int_be(wid - b - 1)
							buffer_write_int_be(c)
							buffer_write_int_be(a)
						if (sch_block_read(a, b, c) = 0) TAG_Int("state", insnum * 26 + 4) //air
						else if (sch_block_read(a, b, c) = block_walkway_block && sch_data_read(a, b, c) = block_walkway_data) TAG_Int("state", 0) //walkway
						else if (sch_block_read(a, b, c) = block_circuit_block && sch_data_read(a, b, c) = block_circuit_data) TAG_Int("state", 1) //circuit
						else if (sch_block_read(a, b, c) = block_ground_block && sch_data_read(a, b, c) = block_ground_data) TAG_Int("state", 2) //ground
						else if (sch_block_read(a, b, c) = 35 && sch_data_read(a, b, c) = 11) TAG_Int("state", insnum * 26 + 3) //blue_wool
						else if (sch_block_read(a, b, c) = 65) TAG_Int("state", insnum * 26 + 5) //ladder
						else if (sch_block_read(a, b, c) = 55) TAG_Int("state", insnum * 26 + 6) //redstone_wire
						else if (sch_block_read(a, b, c) = 93 && sch_data_read(a, b, c) = 3) TAG_Int("state", insnum * 26 + 7) //east repeater 1
						else if (sch_block_read(a, b, c) = 93 && sch_data_read(a, b, c) = 3 + 4) TAG_Int("state", insnum * 26 + 8) //east repeater 2
						else if (sch_block_read(a, b, c) = 93 && sch_data_read(a, b, c) = 3 + 4 * 2) TAG_Int("state", insnum * 26 + 9) //east repeater 3
						else if (sch_block_read(a, b, c) = 93 && sch_data_read(a, b, c) = 3 + 4 * 3) TAG_Int("state", insnum * 26 + 10) //east repeater 4
						else if (sch_block_read(a, b, c) = 93 && sch_data_read(a, b, c) = 1) TAG_Int("state", insnum * 26 + 11) //west repeater 1
						else if (sch_block_read(a, b, c) = 93 && sch_data_read(a, b, c) = 1 + 4) TAG_Int("state", insnum * 26 + 12) //west repeater 2
						else if (sch_block_read(a, b, c) = 93 && sch_data_read(a, b, c) = 1 + 4 * 2) TAG_Int("state", insnum * 26 + 13) //west repeater 3
						else if (sch_block_read(a, b, c) = 93 && sch_data_read(a, b, c) = 1 + 4 * 3) TAG_Int("state", insnum * 26 + 14) //west repeater 4
						else if (sch_block_read(a, b, c) = 94) TAG_Int("state", insnum * 26 + 15) //south repeater 4
						else if (sch_block_read(a, b, c) = 75 && sch_data_read(a, b, c) = 5) TAG_Int("state", insnum * 26 + 16) //unlit torch
						else if (sch_block_read(a, b, c) = 76 && sch_data_read(a, b, c) = 5) TAG_Int("state", insnum * 26 + 17) //lit torch
						else if (sch_block_read(a, b, c) = 77) TAG_Int("state", insnum * 26 + 18) //south stone_button
						else if (sch_block_read(a, b, c) = 27) TAG_Int("state", insnum * 26 + 20) //ns powered_rail
						else if (sch_block_read(a, b, c) = 66) TAG_Int("state", insnum * 26 + 22) //ns rail
						else if (sch_block_read(a, b, c) = 75 && sch_data_read(a, b, c) = 1) TAG_Int("state", insnum * 26 + 23) //east unlit walltorch
						else if (sch_block_read(a, b, c) = 76 && sch_data_read(a, b, c) = 1) TAG_Int("state", insnum * 26 + 24) //east lit walltorch
						else if (sch_block_read(a, b, c) = 75 && sch_data_read(a, b, c) = 2) TAG_Int("state", insnum * 26 + 25) //west unlit walltorch
						else if (sch_block_read(a, b, c) = 76 && sch_data_read(a, b, c) = 2) TAG_Int("state", insnum * 26 + 26) //west lit walltorch
						else if (sch_block_read(a, b, c) = 69) TAG_Int("state", insnum * 26 + 27) //south lever
						else if (sch_block_read(a, b, c) = 75 && sch_data_read(a, b, c) = 4) TAG_Int("state", insnum * 26 + 28) //north lit walltorch
						else {
							for (var i = 0; i < insnum; i++) {
								if (sch_block_read(a, b, c) = o.sch_exp_ins_block[i] && sch_data_read(a, b, c) = o.sch_exp_ins_data[i]) {TAG_Int("state", 3 + i); break;}
								else if (i = insnum - 1) {TAG_Int("state", insnum * 26 + 4); break;}
							}
						}
						TAG_End()
						}
			        }
			    }
			}
		TAG_End()
		}
	    buffer_save(buffer, temp_file)
	    buffer_delete(buffer)
	    gzzip(temp_file, fn)
	    instance_destroy()
	}
	if (o.language != 1) message("Schematic saved!", "Schematic Export")
	else message("Schematic 已保存！", "导出 Schematic")
	window = w_schematic_export



}
