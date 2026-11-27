function branch_export() {
	// branch_export()
	var a, b, c, o
	var fn = string(get_save_filename_ext("Minecraft Schematics (*.schematic)|*.schematic", filename_new_ext(songs[song].filename, "") + ".schematic", "", "Export Branch Schematic"))
	if (fn = "") return 0
	fn = enforce_extension(fn, ".schematic")
	o = obj_controller
	window = -1
	// Start the schematic
	schematic_start();
	var mySchematic = schematic_create();

	// Calculate the length of this schematic
	var sch_wid, sch_len, sch_hei, range_len, lineloc
	range_len = sch_exp_range_end - sch_exp_range_start + 1
	sch_len = range_len * 2

	if sch_exp_velocity = 1 {
		sch_wid = 35
		sch_hei = 2
	} else sch_wid = 3
	if sch_exp_polyphony = 1 sch_hei = 2 else sch_hei = 3

	schematic_size(mySchematic, sch_wid, sch_len + 1, sch_hei )

	if sch_exp_circuitry = 1 {
		// Setup Main Line.

		if sch_exp_velocity = 1 lineloc = 17 else lineloc = 1 
		schematic_fill(mySchematic, lineloc, 0, 0, lineloc, sch_len - 1, 0, sch_exp_circuit_block, sch_exp_circuit_data)

		// Repeater / Block Pattern

		for (a = 0; a < sch_len; a+= 2) {
			schematic_cell_set(mySchematic, lineloc, a, 1, 93, 3)
		}
		for (a = 1; a < sch_len; a+= 2) {
			schematic_cell_set(mySchematic, lineloc, a, 1, sch_exp_circuit_block, sch_exp_circuit_data)
		}
	}
	// Magic future-proofing polyphony / layer value array converter

	for (a = 0; a < sch_exp_polyphony; a++) {
		sch_exp_layer[a] = sch_exp_layer_index[a] - 1
	}

	// Calculate which note blocks are to be stored in the array

	var nblockins, nblockvel, accepted
	sch_exp_totalnoteblocks = 0
	for (a = 0; a < sch_exp_polyphony; a ++) {
		var ticks = 0
		//show_debug_message("LAYER")
		for (b = 0; b < range_len; b ++) {
			accepted = 0
			if (o.songs[o.song].song_exists[sch_exp_range_start + b, sch_exp_layer[a]]) {
				if (o.songs[o.song].song_key[sch_exp_range_start + b, sch_exp_layer[a]] > 32 && o.songs[o.song].song_key[sch_exp_range_start + b, sch_exp_layer[a]] < 58) {
					switch (sch_exp_stereo) {
						case 1: if o.songs[o.song].song_pan[sch_exp_range_start + b, sch_exp_layer[a]] > 100 accepted = 1; // Right Notes
						break;
						case 2: if o.songs[o.song].song_pan[sch_exp_range_start + b, sch_exp_layer[a]] < 100 accepted = 1; // Left Notes
						break;
						case 3: if o.songs[o.song].song_pan[sch_exp_range_start + b, sch_exp_layer[a]] = 100 accepted = 1; // Center Notes
						break;
						case 4: accepted = 1; // All Notes
						break;
					}
				} else {
					message("Error: Some notes are out of range!\nFix the fine pitch, or change it to a custom instrument with a higher/lower sound.", "Error")
					window = w_branch_export
					return 0
				}
			} 
			if accepted = 1 {
				nblocknote[a, ticks] = o.songs[o.song].song_key[sch_exp_range_start + b, sch_exp_layer[a]] 
				nblockins[a, ticks] = ds_list_find_index(o.songs[o.song].instrument_list, o.songs[o.song].song_ins[sch_exp_range_start + b, sch_exp_layer[a]])
				nblockvel[a, ticks] = o.songs[o.song].song_vel[sch_exp_range_start + b, sch_exp_layer[a]]
				nblockkey[a, ticks] = nblocknote[a, ticks] - 33
				sch_exp_totalnoteblocks ++
				accepted = 0
			} else {
				nblocknote[a, ticks] = 0
				nblockins[a, ticks] = 0
				nblockvel[a, ticks] = 0
				nblockkey[a, ticks] = 0
			}
			log("WROTE nblocknote" + string(a) + "," + string(ticks) + " val " + string(nblocknote[a, ticks]))
			noteblockzvel[a, ticks] = 0
			noteblockxpos[a, ticks] = 0
			ticks ++
		}
	}

	// Add note blocks to structure

	var offset, zvel, direc, xpos
	for (a = 0; a < sch_exp_polyphony; a ++) { // layer count
		b = 1
		if a = 0 offset = 0 if a = 1 offset = 1 if a = 2 offset = -1
		for (c = 0; c < range_len; c ++) { // tick count
			if nblocknote[a, c] != 0 { // if note in array exists on this tick
				xpos = range_len * 2 - b // invert x coordinates (b) for NBT data only
				if sch_exp_velocity = 0 {
					schematic_cell_set(mySchematic, lineloc + offset, b, 1, 25, 0)
					schematic_cell_set(mySchematic, lineloc + offset, b, 0, sch_exp_ins_block[nblockins[a, c]], 0)
					noteblockx[a, c] = xpos
					noteblocky[a, c] = 1
					noteblockz[a, c] = lineloc + offset
				} else { // Calulate note block Z and X positions, populate them into an array, then lay down the circuitry.
					zvel = round(32 - nblockvel[a, c]/100 * 32) + 1 
					if zvel <= 18 && zvel >= 16 zvel = 15
					if zvel > 17 direc = -1 else direc = 1
					noteblockzvel[a, c] = zvel
					noteblockxpos[a, c] = xpos
					if sch_exp_circuitry = 1 {
						schematic_fill(mySchematic, lineloc, b, 0, zvel, b, 0, sch_exp_circuit_block, sch_exp_circuit_data) // Connects a redstone line to the block
						schematic_fill(mySchematic, lineloc + -direc, b, 1, zvel, b, 1, 55, 0)
					}
				}
			}
			b += 2
		}
	}

	if sch_exp_velocity = 1 { // When polyphony is 1 or 2, make velocity independent.
		for (a = 0; a < sch_exp_polyphony; a ++) {
			b = 1
			if a = 0 offset = 0 if a = 1 offset = 1 if a = 2 offset = -1
			for (c = 0; c < range_len; c ++) {
				if nblocknote[a, c] != 0 { // if note in array exists on this tick
					xpos = range_len * 2 - b // invert x coordinates (b) for NBT data only
					var freespace = 0
					if sch_exp_polyphony = 2 { // Various checks if note blocks conflict.
						var layer_correction = 0
						if noteblockzvel[0, c] != noteblockzvel[1, c] { // Adds some redstone next to the noteblock if the velocity is different
							if noteblockzvel[0, c] != 0 j = 0 else if noteblockzvel[1, c] != 0 j = 1
							if j != 0 {
								schematic_cell_set(mySchematic, noteblockzvel[j, c], b, 1, sch_exp_circuit_block, sch_exp_circuit_data)
								schematic_cell_set(mySchematic, noteblockzvel[j, c], b, 2, 55, 0)
								if noteblockzvel[0, c] != 0 && noteblockzvel[1, c] != 0 {
									if noteblockzvel[0, c] > lineloc && noteblockzvel[0, c] < noteblockzvel[1, c]  layer_correction = 1
									else if noteblockzvel[0, c] < lineloc && noteblockzvel[0, c] > noteblockzvel[1, c] layer_correction = 1
								}
							}
						}
						if layer_correction = 1 { // Alter layer 0's position and add connecting redstone.
							freespace ++ 
							schematic_cell_set(mySchematic, noteblockzvel[0, c], b, 1, sch_exp_circuit_block, sch_exp_circuit_data)
							schematic_cell_set(mySchematic, noteblockzvel[0, c], b, 2, 55, 0)
							schematic_cell_set(mySchematic, noteblockzvel[0, c], b + freespace, 1, 25, 0)
							schematic_cell_set(mySchematic, noteblockzvel[0, c], b + freespace, 0, sch_exp_ins_block[nblockins[a, c]], 0)
							noteblockx[0, c] = noteblockxpos[0, c] - freespace
							layer_correction = 0
							freespace = 0
						}
					}
					if sch_exp_polyphony != 3 {
						schematic_cell_set(mySchematic, noteblockzvel[a, c], b + offset, 1, 25, 0)
						schematic_cell_set(mySchematic, noteblockzvel[a, c], b + offset, 0, sch_exp_ins_block[nblockins[a, c]], 0)
						noteblockx[a, c] = noteblockxpos[a, c] - offset
						noteblocky[a, c] = 1
						noteblockz[a, c] = noteblockzvel[a, c]
					}
					if sch_exp_polyphony = 3 { // if polyphony = 3 then base all velocity values off layer 0.
						if a = 1 var fix = 1 else fix = 0 // only offset the 2nd layer
						var shiftblock = 0
						var j = 0
						if noteblockzvel[0, c] != 0 j = 0 else if noteblockzvel[1, c] != 0 j = 1 else if noteblockzvel[2, c] != 0 j = 2
						if noteblockzvel[0, c] = 0 {
							schematic_cell_set(mySchematic, noteblockzvel[j, c], b, 1, sch_exp_circuit_block, sch_exp_circuit_data) // Adds some redstone next to the chosen layer's noteblock
							schematic_cell_set(mySchematic, noteblockzvel[j, c], b, 2, 55, 0)
						}
						if a = 2 {
							if noteblockzvel[2, c] > 17 shiftblock = 1 else shiftblock = -1
						}
						schematic_cell_set(mySchematic, noteblockzvel[j, c] + shiftblock, b + fix, 1, 25, 0)
						schematic_cell_set(mySchematic, noteblockzvel[j, c] + shiftblock, b + fix, 2, 0, 0)
						schematic_cell_set(mySchematic, noteblockzvel[j, c] + shiftblock, b + fix, 0, sch_exp_ins_block[nblockins[a, c]], 0)
						noteblockx[a, c] = noteblockxpos[j, c] - fix
						noteblocky[a, c] = 1
						noteblockz[a, c] = noteblockzvel[j, c] + shiftblock
					}
				}
				b += 2
			}
		}
	}
	log("total note blocks = " + string(sch_exp_totalnoteblocks))
	schematic_save(mySchematic, fn);
	schematic_destroy(mySchematic);
	schematic_end();
	message("Schematic saved!", "Schematic Export")
	window = w_branch_export


}
