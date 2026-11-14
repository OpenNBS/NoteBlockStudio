function track_export() {
	// track_export()
	var fn, a, b, c, d, p, xx, yy, zz, len, wid, hei, o, chestx, chesty, chestz, signx, signy, signz, nblocks, layers, cyy, y1, x1, insnum, ins, repeats, remain, replen, blockamount, nbamount, cpan, cpanvol, cvol, blocktagpos, sizepos, channels, row_index, row, track_tick_delay;
	var REPEATER, TORCHON, TORCHOFF, WIRE, LADDER, RAIL, POWEREDRAIL, SLAB, noteblocks, noteblockx, noteblocky, noteblockz, noteblocknote, noteblockins, noteblockpit, command_plan, export_end;
	structure = (sch_exp_format <= 1)
	sch_exp_minecraft_old = (sch_exp_format = 3)
	if (structure) fn = string(get_save_filename_ext("Minecraft Structures (*.nbt)|*.nbt", filename_new_ext(string_replace_all(string_lower(songs[song].filename), " ", "_"), "") + ".nbt", "", "Export Track"))
	else fn = string(get_save_filename_ext("Minecraft Schematics (*.schematic)|*.schematic", filename_new_ext(songs[song].filename, "") + ".schematic", "", "Export Track"))
	if (fn = "") return 0
	if (structure) fn = enforce_extension(fn, ".nbt")
	else fn = enforce_extension(fn, ".schematic")
	o = obj_controller
	command_plan = undefined
	if (structure && command_block) {
		command_plan = minecraft_export_prepare_track_plan(minecraft_export_get_schematic_plan(true))
		if (array_length(command_plan.rows) <= 0) {
			message(condstr(language != 1, "There are no sound commands to export!", "没有声音命令可以导出！"), condstr(language != 1, "Schematic export", "导出结构"))
			return 0
		}
		// Modern structure NBT uses signed 32-bit dimensions and this exporter writes
		// its block list sparsely. Do not apply the legacy dense-array 2000x2000x256
		// guard here; GameMaker's grow-buffer capacity is the effective limit.
		var planned_track_height = max(20, ceil(command_plan.track_maximum_slots / 4) * 4 + 4)
		var planned_track_length = 40 + command_plan.last_command_grid * 2
		if (planned_track_length > 2147483647 || planned_track_height > 2147483647) {
			message(condstr(language != 1, "The Track dimensions exceed the signed 32-bit Structure NBT limit.", "直轨尺寸超过了结构 NBT 的 32 位有符号整数限制。"), condstr(language != 1, "Error", "错误"))
			return 0
		}
	}
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
		SLAB = 44
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
		ins[16] = "trumpet"
		ins[17] = "trumpet_exposed"
		ins[18] = "trumpet_weathered"
		ins[19] = "trumpet_oxidized"
		for (var a = 0; a < 240; a++) {
			ins[20 + a] = "harp"
		}
			instrument_list = o.songs[o.song].instrument_list
			command_plan = undefined
			if (o.structure && o.command_block) command_plan = o.sch_command_plan
	    layers = is_struct(command_plan) ? max(1, ceil(command_plan.track_maximum_slots / 4)) : 4
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
		blocksam = is_struct(command_plan) ? array_length(command_plan.rows) : o.sch_exp_totalblocks[o.sch_exp_includelocked] // Amount of blocks
		totalblocksc = 0
		export_end = is_struct(command_plan) ? command_plan.last_command_grid : o.songs[o.song].enda
		track_tick_delay = (o.sch_exp_tempo == 0) ? 0 : ((o.sch_exp_tempo == 1) ? 1 : 3)
	    with (o) {
	        len = 40 + export_end * 2
	        wid = 99
	        hei = max(20, layers * 4 + 4)
	    }
	    noteblocks = 0
		//repeats = (len div 100) + 1
		//remain = len mod 100
	    yy = round(wid / 2) - 1
	    cyy = yy
		signx = 2
		signy = yy
		signz = hei - 1
		if (o.structure) {
			structure_max_x = 99 - signy
			structure_max_y = signz
			structure_max_z = signx
		} else {
			structure_max_x = signx
			structure_max_y = signy
			structure_max_z = signz
		}
		
	    // Write to file
	    buffer = buffer_create(8, buffer_grow, 1)

		if (!o.structure) {
			for (a = 0; a < len + 2; a += 1) {
				for (b = 0; b < 100; b += 1) {
					for (c = 0; c < hei; c += 1) {
						sch_block_write(a, b, c, 0)
						sch_data_write(a, b, c, 0)
					}
				}
			}
		}

		if (o.structure) {
		TAG_Compound("")
		TAG_Int("DataVersion", 1519)
		TAG_List("size", 3, 3)
			sizepos = buffer_tell(buffer)
			buffer_write_int_be(wid)
			buffer_write_int_be(hei)
			buffer_write_int_be(len)
		insnum = ds_list_size(instrument_list)
		TAG_List("palette", 30 + insnum * 26, 10)
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
					TAG_String("facing", "north")
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
				TAG_String("delay", "0")
				TAG_String("facing", "east")
				TAG_String("locked", "false")
				TAG_String("powered", "false")
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
			TAG_String("Name", "minecraft:smooth_stone_slab")
			TAG_Compound("Properties")
				TAG_String("type", "top")
				TAG_End()
			TAG_End()
		TAG_List("entities", 0, 10)
		blocktagpos = buffer_tell(buffer)
		TAG_List("blocks", 114514, 10)
		log("blocktagpos: " + string(blocktagpos))
			TAG_Compound("nbt")
				TAG_String("Color", "black")
				TAG_String("id", "minecraft:sign")
	            TAG_String("Text1", "{\"text\": \"Song generated\"}")
	            TAG_String("Text2", "{\"text\": \"by the\"}")
	            TAG_String("Text3", "{\"text\": \"Note Block\"}")
	            TAG_String("Text4", "{\"text\": \"Studio\"}")
				TAG_End()
			TAG_List("pos", 3, 3)
				buffer_write_int_be(99 - signy)
				buffer_write_int_be(signz)
				buffer_write_int_be(signx)
			TAG_Int("state", insnum * 26 + 19)
	        TAG_End()
			totalblocksc++
		} else {
			sch_block_write(signx, signy, signz, 68)
			sch_data_write(signx, signy, signz, 3)
		}

	    // Create walkway
	    for (a = 0; a < 3; a += 1) {
	        for (b = 2; b < len + 2; b += 1) {
	            block_walkway_track(b, yy + a, hei - 3)
	        }
	    }
		// Controls
		block_circuit_track(1, yy, hei - 2)
		block_circuit_track(1, yy + 1, hei - 2)
		block_other_track(1, yy, hei - 1, 35, 11) // wool
		block_other_track(1, yy + 1, hei - 1, 35, 11)
		block_other_track(2, yy + 1, hei - 1, 77, 3)
		// Back
		block_circuit_track(0, yy + 1, hei - 2)
		block_other_track(0, yy + 1, hei - 1, WIRE, 0)
		block_other_track(0, yy, hei - 2, TORCHON, 1)
			
		block_other_track(0, yy, hei - 3, WIRE, 0)
		block_circuit_track(0, yy, hei - 4)
		block_other_track(0, yy + 1, hei - 4, TORCHOFF, 2)
			
		block_other_track(0, yy + 1, hei - 5, WIRE, 0)
		block_circuit_track(0, yy + 1, hei - 6)
			
		for (a = 0; a < 13; a++) {
			block_repeater_track(1 + 2 * a, yy + 1, hei - 5 - a, 0, 2, 0)
			block_other_track(2 + 2 * a, yy + 1, hei - 5 - a, WIRE, 0)
			block_circuit_track(1 + 2 * a, yy + 1, hei - 6 - a)
			block_circuit_track(2 + 2 * a, yy + 1, hei - 6 - a)
		}
			
		for (a = 0; a < 4; a++) {
			block_repeater_track(27 + a * 2, yy + 1, hei - 18, 0, 2, 0)
			block_circuit_track(27 + a * 2, yy + 1, hei - 19)
			block_circuit_track(28 + a * 2, yy + 1, hei - 18)
		}
			
		for (a = 0; a < 11; a++) {
			block_circuit_track(34, yy - a, hei - 19)
			block_other_track(34, yy - a, hei - 18, WIRE, 0)
			block_circuit_track(34, yy + 2 + a, hei - 19)
			block_other_track(34, yy + 2 + a, hei - 18, WIRE, 0)
		}
			
		for (a = 0; a < 12; a++) {
			block_circuit_track(34, yy - 11 - a, hei - 18)
			if (a != 4) block_other_track(34, yy - 11 - a, hei - 17, WIRE, 0)
			else block_repeater_track(34, yy - 11 - a, hei - 17, 0, 1, 0)
			block_circuit_track(34, yy + 13 + a, hei - 18)
			if (a != 4) block_other_track(34, yy + 13 + a, hei - 17, WIRE, 0)
			else block_repeater_track(34, yy + 13 + a, hei - 17, 0, 3, 0)
		}
			
		for (a = 0; a < 12; a++) {
			block_circuit_track(34, yy - 23 - a, hei - 17)
			if (a != 8) block_other_track(34, yy - 23 - a, hei - 16, WIRE, 0)
			else block_repeater_track(34, yy - 23 - a, hei - 16, 0, 1, 0)
			block_circuit_track(34, yy + 25 + a, hei - 17)
			if (a != 8) block_other_track(34, yy + 25 + a, hei - 16, WIRE, 0)
			else block_repeater_track(34, yy + 25 + a, hei - 16, 0, 3, 0)
		}
			
		for (a = 0; a < 12; a++) {
			block_circuit_track(34, yy - 35 - a, hei - 16)
			block_other_track(34, yy - 35 - a, hei - 15, WIRE, 0)
			block_circuit_track(34, yy + 37 + a, hei - 16)
			block_other_track(34, yy + 37 + a, hei - 15, WIRE, 0)
		}
			
		block_circuit_track(35, yy - 11, hei - 18)
		block_circuit_track(36, yy - 11, hei - 18)
		block_circuit_track(37, yy - 11, hei - 18)
		block_circuit_track(35, yy - 11 - 12, hei - 17)
		block_circuit_track(36, yy - 11 - 12, hei - 17)
		block_circuit_track(37, yy - 11 - 12, hei - 17)
		block_circuit_track(35, yy - 11 - 12 - 12, hei - 16)
		block_circuit_track(36, yy - 11 - 12 - 12, hei - 16)
		block_circuit_track(37, yy - 11 - 12 - 12, hei - 16)
		block_circuit_track(35, yy - 11 - 12 - 12 - 12, hei - 16)
		block_circuit_track(36, yy - 11 - 12 - 12 - 12, hei - 15)
		block_circuit_track(37, yy - 11 - 12 - 12 - 12, hei - 15)
		block_circuit_track(34, yy - 11 - 12 - 12 - 12, hei - 15)
		block_circuit_track(35, yy + 11 + 2, hei - 18)
		block_circuit_track(36, yy + 11 + 2, hei - 18)
		block_circuit_track(37, yy + 11 + 2, hei - 18)
		block_circuit_track(35, yy + 11 + 12 + 2, hei - 17)
		block_circuit_track(36, yy + 11 + 12 + 2, hei - 17)
		block_circuit_track(37, yy + 11 + 12 + 2, hei - 17)
		block_circuit_track(35, yy + 11 + 12 + 12 + 2, hei - 16)
		block_circuit_track(36, yy + 11 + 12 + 12 + 2, hei - 16)
		block_circuit_track(37, yy + 11 + 12 + 12 + 2, hei - 16)
		block_circuit_track(35, yy + 11 + 12 + 12 + 12 + 2, hei - 16)
		block_circuit_track(36, yy + 11 + 12 + 12 + 12 + 2, hei - 15)
		block_circuit_track(37, yy + 11 + 12 + 12 + 12 + 2, hei - 15)
		block_circuit_track(34, yy + 11 + 12 + 12 + 12 + 2, hei - 15)
		block_circuit_track(35, yy + 1, hei - 19)
		block_circuit_track(36, yy + 1, hei - 18)
		block_circuit_track(37, yy + 1, hei - 19)
			
		block_other_track(36, yy - 11, hei - 17, WIRE, 0)
		block_other_track(37, yy - 11, hei - 17, WIRE, 0)
		block_other_track(36, yy - 11 - 12, hei - 16, WIRE, 0)
		block_other_track(37, yy - 11 - 12, hei - 16, WIRE, 0)
		block_other_track(36, yy - 11 - 12 - 12, hei - 15, WIRE, 0)
		block_other_track(37, yy - 11 - 12 - 12, hei - 15, WIRE, 0)
		block_other_track(36, yy - 11 - 12 - 12 - 12, hei - 14, WIRE, 0)
		block_other_track(37, yy - 11 - 12 - 12 - 12, hei - 14, WIRE, 0)
		block_other_track(36, yy + 11 + 2, hei - 17, WIRE, 0)
		block_other_track(37, yy + 11 + 2, hei - 17, WIRE, 0)
		block_other_track(36, yy + 11 + 12 + 2, hei - 16, WIRE, 0)
		block_other_track(37, yy + 11 + 12 + 2, hei - 16, WIRE, 0)
		block_other_track(36, yy + 11 + 12 + 12 + 2, hei - 15, WIRE, 0)
		block_other_track(37, yy + 11 + 12 + 12 + 2, hei - 15, WIRE, 0)
		block_other_track(36, yy + 11 + 12 + 12 + 12 + 2, hei - 14, WIRE, 0)
		block_other_track(37, yy + 11 + 12 + 12 + 12 + 2, hei - 14, WIRE, 0)
		block_other_track(37, yy + 1, hei - 18, WIRE, 0)
			
		block_repeater_track(35, yy - 11, hei - 17, 2, 2, 0)
		block_repeater_track(35, yy - 11 - 12, hei - 16, 1, 2, 0)
		block_repeater_track(35, yy - 11 - 12 - 12, hei - 15, 0, 2, 0)
		block_repeater_track(35, yy - 11 - 12 - 12 - 12, hei - 15, 0, 2, 0)
		block_repeater_track(35, yy + 11 + 2, hei - 17, 2, 2, 0)
		block_repeater_track(35, yy + 11 + 12 + 2, hei - 16, 1, 2, 0)
		block_repeater_track(35, yy + 11 + 12 + 12 + 2, hei - 15, 0, 2, 0)
		block_repeater_track(35, yy + 11 + 12 + 12 + 12 + 2, hei - 15, 0, 2, 0)
		block_repeater_track(35, yy + 1, hei - 18, 2, 2, 0)
			
		for (a = 0; a < 4; a++) {
			for (b = 0; b < 13; b++) {
				block_other_track(37 + (b mod 2 = 0), yy - 11 - 12 * a, hei - 17 + b + a, SLAB, 2)
				block_other_track(37 + (b mod 2 = 0), yy - 11 - 12 * a, hei - 16 + b + a, WIRE, 2)
				block_other_track(37 + (b mod 2 = 0), yy + 11 + 12 * a + 2, hei - 17 + b + a, SLAB, 2)
				block_other_track(37 + (b mod 2 = 0), yy + 11 + 12 * a + 2, hei - 16 + b + a, WIRE, 2)
			}
			for (b = 0; b < 4; b++) {
				block_circuit_track(39, yy - 11 - 12 * a, hei - 17 + 4 * b + a)
				block_repeater_track(39, yy - 11 - 12 * a, hei - 16 + 4 * b + a, 0, 2, 0)
				block_circuit_track(39, yy + 11 + 12 * a + 2, hei - 17 + 4 * b + a)
				block_repeater_track(39, yy + 11 + 12 * a + 2, hei - 16 + 4 * b + a, 0, 2, 0)
			}
		}
			
		for (b = 0; b < 13; b++) {
			block_other_track(37 + (b mod 2 = 0), yy + 1, hei - 18 + b, SLAB, 2)
			block_other_track(37 + (b mod 2 = 0), yy + 1, hei - 17 + b, WIRE, 2)
		}
		for (b = 0; b < 4; b++) {
			block_circuit_track(39, yy + 1, hei - 18 + 4 * b)
			block_repeater_track(39, yy + 1, hei - 17 + 4 * b, 0, 2, 0)
		}
		
		// Add note blocks
		xx = -1 + 40
		var circ, rep, dir, turn, lturnx, lturny, lturndel, adds;
		var nblocks, nblocksl1, nblocksl2, nblocksl3, nblocksl4, nblocksr1, nblocksr2, nblocksr3, nblocksr4;
		var nblockins, nblockinsl1, nblockinsl2, nblockinsl3, nblockinsl4, nblockinsr1, nblockinsr2, nblockinsr3, nblockinsr4;
		var nblockkey, nblockkeyl1, nblockkeyl2, nblockkeyl3, nblockkeyl4, nblockkeyr1, nblockkeyr2, nblockkeyr3, nblockkeyr4;
		var nblockpit, nblockpitl1, nblockpitl2, nblockpitl3, nblockpitl4, nblockpitr1, nblockpitr2, nblockpitr3, nblockpitr4;
		rep = 0
		dir = 1 // 1 or -1
		circ = 1 // 1 = From, -1 = To
		// screen_redraw()
		lturnx = -1
		lturny = -1
		lturndel = 0
		noteblocks = 0
		noteblockx = 0
		noteblocky = 0
		noteblockz = 0
		noteblocknote = 0
		noteblockins = 0
		noteblockpit = 0
		for (a = 0; a <= export_end; a += 1) {
		    nblocks = 0
			nblockins = 0
			nblockkey = 0
			nblockpit = 0
			nblocksl1 = 0
			nblockinsl1 = 0
			nblockkeyl1 = 0
			nblockpitl1 = 0
			nblocksl2 = 0
			nblockinsl2 = 0
			nblockkeyl2 = 0
			nblockpitl2 = 0
			nblocksl3 = 0
			nblockinsl3 = 0
			nblockkeyl3 = 0
			nblockpitl3 = 0
			nblocksl4 = 0
			nblockinsl4 = 0
			nblockkeyl4 = 0
			nblockpitl4 = 0
			nblocksr1 = 0
			nblockinsr1 = 0
			nblockkeyr1 = 0
			nblockpitr1 = 0
			nblocksr2 = 0
			nblockinsr2 = 0
			nblockkeyr2 = 0
			nblockpitr2 = 0
			nblocksr3 = 0
			nblockinsr3 = 0
			nblockkeyr3 = 0
			nblockpitr3 = 0
			nblocksr4 = 0
			nblockinsr4 = 0
			nblockkeyr4 = 0
			nblockpitr4 = 0
		    rep += 1
			if (is_struct(command_plan)) {
				channels = command_plan.track_rows_by_grid[a]
				for (row_index = 0; row_index < array_length(channels[0]); row_index++) {
					row = channels[0][row_index]
					nblockinsl4[nblocksl4] = row.instrument; nblockkeyl4[nblocksl4] = 33; nblockpitl4[nblocksl4] = row.index; nblocksl4++
				}
				for (row_index = 0; row_index < array_length(channels[1]); row_index++) {
					row = channels[1][row_index]
					nblockinsl3[nblocksl3] = row.instrument; nblockkeyl3[nblocksl3] = 33; nblockpitl3[nblocksl3] = row.index; nblocksl3++
				}
				for (row_index = 0; row_index < array_length(channels[2]); row_index++) {
					row = channels[2][row_index]
					nblockinsl2[nblocksl2] = row.instrument; nblockkeyl2[nblocksl2] = 33; nblockpitl2[nblocksl2] = row.index; nblocksl2++
				}
				for (row_index = 0; row_index < array_length(channels[3]); row_index++) {
					row = channels[3][row_index]
					nblockinsl1[nblocksl1] = row.instrument; nblockkeyl1[nblocksl1] = 33; nblockpitl1[nblocksl1] = row.index; nblocksl1++
				}
				for (row_index = 0; row_index < array_length(channels[4]); row_index++) {
					row = channels[4][row_index]
					nblockins[nblocks] = row.instrument; nblockkey[nblocks] = 33; nblockpit[nblocks] = row.index; nblocks++
				}
				for (row_index = 0; row_index < array_length(channels[5]); row_index++) {
					row = channels[5][row_index]
					nblockinsr1[nblocksr1] = row.instrument; nblockkeyr1[nblocksr1] = 33; nblockpitr1[nblocksr1] = row.index; nblocksr1++
				}
				for (row_index = 0; row_index < array_length(channels[6]); row_index++) {
					row = channels[6][row_index]
					nblockinsr2[nblocksr2] = row.instrument; nblockkeyr2[nblocksr2] = 33; nblockpitr2[nblocksr2] = row.index; nblocksr2++
				}
				for (row_index = 0; row_index < array_length(channels[7]); row_index++) {
					row = channels[7][row_index]
					nblockinsr3[nblocksr3] = row.instrument; nblockkeyr3[nblocksr3] = 33; nblockpitr3[nblocksr3] = row.index; nblocksr3++
				}
				for (row_index = 0; row_index < array_length(channels[8]); row_index++) {
					row = channels[8][row_index]
					nblockinsr4[nblocksr4] = row.instrument; nblockkeyr4[nblocksr4] = 33; nblockpitr4[nblocksr4] = row.index; nblocksr4++
				}
		    } else if (o.songs[o.song].colamount[a] > 0) { // Calculate note blocks for this tick
		        for (b = 0; b <= o.songs[o.song].collast[a]; b += 1) {
		            if (o.songs[o.song].song_exists[a, b] && (o.lockedlayer[b] = 0 || o.sch_exp_includelocked)) {
		                if ((o.songs[o.song].song_key[a, b] > 32 && o.songs[o.song].song_key[a, b] < 58) || (o.structure && o.command_block && o.songs[o.song].song_key[a, b] >= 9 && o.songs[o.song].song_key[a, b] <= 81)) {
							if (o.songs[o.song].layerstereo[b] = 100) cpan = o.songs[o.song].song_pan[a, b]
							else cpan = (o.songs[o.song].layerstereo[b] + o.songs[o.song].song_pan[a, b]) / 2
							cvol = (o.songs[o.song].layervol[b] / 100) * o.songs[o.song].song_vel[a, b]
							cpanvol = (cpan - 100) * cvol + 100
		                    nblockinsl4[nblocksl4] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.0 && cvol <= 0.2) || (cpanvol >= 180)) - !((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.0 && cvol <= 0.2) || (cpanvol >= 180))
		                    nblockkeyl4[nblocksl4] = o.songs[o.song].song_key[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.0 && cvol <= 0.2) || (cpanvol >= 180))
		                    nblockpitl4[nblocksl4] = o.songs[o.song].song_pit[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.0 && cvol <= 0.2) || (cpanvol >= 180))
		                    nblocksl4 += 1
		                    nblockinsl3[nblocksl3] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.2 && cvol <= 0.4) || (cpanvol >= 160 && cpanvol < 180)) - !((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.2 && cvol <= 0.4) || (cpanvol >= 160 && cpanvol < 180))
		                    nblockkeyl3[nblocksl3] = o.songs[o.song].song_key[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.2 && cvol <= 0.4) || (cpanvol >= 160 && cpanvol < 180))
		                    nblockpitl3[nblocksl3] = o.songs[o.song].song_pit[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.2 && cvol <= 0.4) || (cpanvol >= 160 && cpanvol < 180))
		                    nblocksl3 += 1
		                    nblockinsl2[nblocksl2] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.4 && cvol <= 0.6) || (cpanvol >= 140 && cpanvol < 160)) - !((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.4 && cvol <= 0.6) || (cpanvol >= 140 && cpanvol < 160))
		                    nblockkeyl2[nblocksl2] = o.songs[o.song].song_key[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.4 && cvol <= 0.6) || (cpanvol >= 140 && cpanvol < 160))
		                    nblockpitl2[nblocksl2] = o.songs[o.song].song_pit[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 0 && cpan <= 80)) && cvol > 0.4 && cvol <= 0.6) || (cpanvol >= 140 && cpanvol < 160))
		                    nblocksl2 += 1
		                    nblockinsl1[nblocksl1] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * ((((cpan > 80 && cpan < 120 && cvol <= 0.8) || (cpan > 0 && cpan <= 80)) && cvol > 0.6) || (cpanvol >= 120 && cpanvol < 140)) - !((((cpan > 80 && cpan < 120 && cvol <= 0.8) || (cpan > 0 && cpan <= 80)) && cvol > 0.6) || (cpanvol >= 120 && cpanvol < 140))
		                    nblockkeyl1[nblocksl1] = o.songs[o.song].song_key[a, b] * ((((cpan > 80 && cpan < 120 && cvol <= 0.8) || (cpan > 0 && cpan <= 80)) && cvol > 0.6) || (cpanvol >= 120 && cpanvol < 140))
		                    nblockpitl1[nblocksl1] = o.songs[o.song].song_pit[a, b] * ((((cpan > 80 && cpan < 120 && cvol <= 0.8) || (cpan > 0 && cpan <= 80)) && cvol > 0.6) || (cpanvol >= 120 && cpanvol < 140))
		                    nblocksl1 += 1
			                nblockins[nblocks] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * (cpan > 80 && cpan < 120 && cvol > 0.8) - !(cpan > 80 && cpan < 120 && cvol > 0.8)
			                nblockkey[nblocks] = o.songs[o.song].song_key[a, b] * (cpan > 80 && cpan < 120 && cvol > 0.8)
			                nblockpit[nblocks] = o.songs[o.song].song_pit[a, b] * (cpan > 80 && cpan < 120 && cvol > 0.8)
			                nblocks += 1
		                    nblockinsr1[nblocksr1] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * ((((cpan > 80 && cpan < 120 && cvol <= 0.8) || (cpan > 120 && cpan <= 200)) && cvol > 0.6) || (cpanvol > 60 && cpanvol <= 80)) - !((((cpan > 80 && cpan < 120 && cvol <= 0.8) || (cpan > 120 && cpan <= 200)) && cvol > 0.6) || (cpanvol > 60 && cpanvol <= 80))
		                    nblockkeyr1[nblocksr1] = o.songs[o.song].song_key[a, b] * ((((cpan > 80 && cpan < 120 && cvol <= 0.8) || (cpan > 120 && cpan <= 200)) && cvol > 0.6) || (cpanvol > 60 && cpanvol <= 80))
		                    nblockpitr1[nblocksr1] = o.songs[o.song].song_pit[a, b] * ((((cpan > 80 && cpan < 120 && cvol <= 0.8) || (cpan > 120 && cpan <= 200)) && cvol > 0.6) || (cpanvol > 60 && cpanvol <= 80))
		                    nblocksr1 += 1
		                    nblockinsr2[nblocksr2] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.4 && cvol <= 0.6) || (cpanvol > 40 && cpanvol <= 60)) - !((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.4 && cvol <= 0.6) || (cpanvol > 40 && cpanvol <= 60))
		                    nblockkeyr2[nblocksr2] = o.songs[o.song].song_key[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.4 && cvol <= 0.6) || (cpanvol > 40 && cpanvol <= 60))
		                    nblockpitr2[nblocksr2] = o.songs[o.song].song_pit[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.4 && cvol <= 0.6) || (cpanvol > 40 && cpanvol <= 60))
		                    nblocksr2 += 1
		                    nblockinsr3[nblocksr3] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.2 && cvol <= 0.4) || (cpanvol > 20 && cpanvol <= 40)) - !((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.2 && cvol <= 0.4) || (cpanvol > 20 && cpanvol <= 40))
		                    nblockkeyr3[nblocksr3] = o.songs[o.song].song_key[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.2 && cvol <= 0.4) || (cpanvol > 20 && cpanvol <= 40))
		                    nblockpitr3[nblocksr3] = o.songs[o.song].song_pit[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.2 && cvol <= 0.4) || (cpanvol > 20 && cpanvol <= 40))
		                    nblocksr3 += 1
		                    nblockinsr4[nblocksr4] = ds_list_find_index(other.songs[other.song].instrument_list, o.songs[o.song].song_ins[a, b]) * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.0 && cvol <= 0.2) || (cpanvol <= 20)) - !((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.0 && cvol <= 0.2) || (cpan <= 20))
		                    nblockkeyr4[nblocksr4] = o.songs[o.song].song_key[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.0 && cvol <= 0.2) || (cpanvol <= 20))
		                    nblockpitr4[nblocksr4] = o.songs[o.song].song_pit[a, b] * ((((cpan > 80 && cpan < 120) || (cpan > 120 && cpan <= 200)) && cvol > 0.0 && cvol <= 0.2) || (cpanvol <= 20))
		                    nblocksr4 += 1
						}
					}
		        }
		    }
		    nblocks -= 1
		    nblocksl1 -= 1
		    nblocksl2 -= 1
		    nblocksl3 -= 1
		    nblocksl4 -= 1
		    nblocksr1 -= 1
		    nblocksr2 -= 1
		    nblocksr3 -= 1
		    nblocksr4 -= 1
			adds = 1
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocks > -1) { // Note block #1
		            if (nblockins[nblocks] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkey[nblocks] - 33
						noteblockins[noteblocks] = nblockins[nblocks]
						noteblockpit[noteblocks] = nblockpit[nblocks]
		                noteblocks += 1
		            }
		            nblocks -= 1
		        }
		        if (nblocks > -1) { // Note block #2
		            if (nblockins[nblocks] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkey[nblocks] - 33
						noteblockins[noteblocks] = nblockins[nblocks]
						noteblockpit[noteblocks] = nblockpit[nblocks]
		                noteblocks += 1
		            }
		            nblocks -= 1
		        }
		        if (nblocks > -1) { // Note block #3
		            if (nblockins[nblocks] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkey[nblocks] - 33
						noteblockins[noteblocks] = nblockins[nblocks]
						noteblockpit[noteblocks] = nblockpit[nblocks]
		                noteblocks += 1
		            }
		            nblocks -= 1
		        }
		        if (nblocks > -1) { // Note block #4
		            if (nblockins[nblocks] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockins[nblocks]], o.sch_exp_ins_data[nblockins[nblocks]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkey[nblocks] - 33
						noteblockins[noteblocks] = nblockins[nblocks]
						noteblockpit[noteblocks] = nblockpit[nblocks]
		                noteblocks += 1
		            }
		            nblocks -= 1
		        }
		    }
			adds = 2
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir - 12
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocksl1 > -1) { // Note block #1
		            if (nblockinsl1[nblocksl1] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsl1[nblocksl1]], o.sch_exp_ins_data[nblockinsl1[nblocksl1]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyl1[nblocksl1] - 33
						noteblockins[noteblocks] = nblockinsl1[nblocksl1]
						noteblockpit[noteblocks] = nblockpitl1[nblocksl1]
		                noteblocks += 1
		            }
		            nblocksl1 -= 1
		        }
		        if (nblocksl1 > -1) { // Note block #2
		            if (nblockinsl1[nblocksl1] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsl1[nblocksl1]], o.sch_exp_ins_data[nblockinsl1[nblocksl1]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyl1[nblocksl1] - 33
						noteblockins[noteblocks] = nblockinsl1[nblocksl1]
						noteblockpit[noteblocks] = nblockpitl1[nblocksl1]
		                noteblocks += 1
		            }
		            nblocksl1 -= 1
		        }
		        if (nblocksl1 > -1) { // Note block #3
		            if (nblockinsl1[nblocksl1] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsl1[nblocksl1]], o.sch_exp_ins_data[nblockinsl1[nblocksl1]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyl1[nblocksl1] - 33
						noteblockins[noteblocks] = nblockinsl1[nblocksl1]
						noteblockpit[noteblocks] = nblockpitl1[nblocksl1]
		                noteblocks += 1
		            }
		            nblocksl1 -= 1
		        }
		        if (nblocksl1 > -1) { // Note block #4
		            if (nblockinsl1[nblocksl1] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsl1[nblocksl1]], o.sch_exp_ins_data[nblockinsl1[nblocksl1]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyl1[nblocksl1] - 33
						noteblockins[noteblocks] = nblockinsl1[nblocksl1]
						noteblockpit[noteblocks] = nblockpitl1[nblocksl1]
		                noteblocks += 1
		            }
		            nblocksl1 -= 1
		        }
		    }
			adds = 3
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir - 12 - 12
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocksl2 > -1) { // Note block #1
		            if (nblockinsl2[nblocksl2] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsl2[nblocksl2]], o.sch_exp_ins_data[nblockinsl2[nblocksl2]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyl2[nblocksl2] - 33
						noteblockins[noteblocks] = nblockinsl2[nblocksl2]
						noteblockpit[noteblocks] = nblockpitl2[nblocksl2]
		                noteblocks += 1
		            }
		            nblocksl2 -= 1
		        }
		        if (nblocksl2 > -1) { // Note block #2
		            if (nblockinsl2[nblocksl2] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsl2[nblocksl2]], o.sch_exp_ins_data[nblockinsl2[nblocksl2]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyl2[nblocksl2] - 33
						noteblockins[noteblocks] = nblockinsl2[nblocksl2]
						noteblockpit[noteblocks] = nblockpitl2[nblocksl2]
		                noteblocks += 1
		            }
		            nblocksl2 -= 1
		        }
		        if (nblocksl2 > -1) { // Note block #3
		            if (nblockinsl2[nblocksl2] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsl2[nblocksl2]], o.sch_exp_ins_data[nblockinsl2[nblocksl2]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyl2[nblocksl2] - 33
						noteblockins[noteblocks] = nblockinsl2[nblocksl2]
						noteblockpit[noteblocks] = nblockpitl2[nblocksl2]
		                noteblocks += 1
		            }
		            nblocksl2 -= 1
		        }
		        if (nblocksl2 > -1) { // Note block #4
		            if (nblockinsl2[nblocksl2] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsl2[nblocksl2]], o.sch_exp_ins_data[nblockinsl2[nblocksl2]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyl2[nblocksl2] - 33
						noteblockins[noteblocks] = nblockinsl2[nblocksl2]
						noteblockpit[noteblocks] = nblockpitl2[nblocksl2]
		                noteblocks += 1
		            }
		            nblocksl2 -= 1
		        }
		    }
			adds = 4
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir - 12 - 12 - 12
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocksl3 > -1) { // Note block #1
		            if (nblockinsl3[nblocksl3] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsl3[nblocksl3]], o.sch_exp_ins_data[nblockinsl3[nblocksl3]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyl3[nblocksl3] - 33
						noteblockins[noteblocks] = nblockinsl3[nblocksl3]
						noteblockpit[noteblocks] = nblockpitl3[nblocksl3]
		                noteblocks += 1
		            }
		            nblocksl3 -= 1
		        }
		        if (nblocksl3 > -1) { // Note block #2
		            if (nblockinsl3[nblocksl3] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsl3[nblocksl3]], o.sch_exp_ins_data[nblockinsl3[nblocksl3]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyl3[nblocksl3] - 33
						noteblockins[noteblocks] = nblockinsl3[nblocksl3]
						noteblockpit[noteblocks] = nblockpitl3[nblocksl3]
		                noteblocks += 1
		            }
		            nblocksl3 -= 1
		        }
		        if (nblocksl3 > -1) { // Note block #3
		            if (nblockinsl3[nblocksl3] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsl3[nblocksl3]], o.sch_exp_ins_data[nblockinsl3[nblocksl3]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyl3[nblocksl3] - 33
						noteblockins[noteblocks] = nblockinsl3[nblocksl3]
						noteblockpit[noteblocks] = nblockpitl3[nblocksl3]
		                noteblocks += 1
		            }
		            nblocksl3 -= 1
		        }
		        if (nblocksl3 > -1) { // Note block #4
		            if (nblockinsl3[nblocksl3] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsl3[nblocksl3]], o.sch_exp_ins_data[nblockinsl3[nblocksl3]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyl3[nblocksl3] - 33
						noteblockins[noteblocks] = nblockinsl3[nblocksl3]
						noteblockpit[noteblocks] = nblockpitl3[nblocksl3]
		                noteblocks += 1
		            }
		            nblocksl3 -= 1
		        }
		    }
			adds = 5
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir - 12 - 12 - 12 - 12
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocksl4 > -1) { // Note block #1
		            if (nblockinsl4[nblocksl4] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsl4[nblocksl4]], o.sch_exp_ins_data[nblockinsl4[nblocksl4]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyl4[nblocksl4] - 33
						noteblockins[noteblocks] = nblockinsl4[nblocksl4]
						noteblockpit[noteblocks] = nblockpitl4[nblocksl4]
		                noteblocks += 1
		            }
		            nblocksl4 -= 1
		        }
		        if (nblocksl4 > -1) { // Note block #2
		            if (nblockinsl4[nblocksl4] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsl4[nblocksl4]], o.sch_exp_ins_data[nblockinsl4[nblocksl4]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyl4[nblocksl4] - 33
						noteblockins[noteblocks] = nblockinsl4[nblocksl4]
						noteblockpit[noteblocks] = nblockpitl4[nblocksl4]
		                noteblocks += 1
		            }
		            nblocksl4 -= 1
		        }
		        if (nblocksl4 > -1) { // Note block #3
		            if (nblockinsl4[nblocksl4] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsl4[nblocksl4]], o.sch_exp_ins_data[nblockinsl4[nblocksl4]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyl4[nblocksl4] - 33
						noteblockins[noteblocks] = nblockinsl4[nblocksl4]
						noteblockpit[noteblocks] = nblockpitl4[nblocksl4]
		                noteblocks += 1
		            }
		            nblocksl4 -= 1
		        }
		        if (nblocksl4 > -1) { // Note block #4
		            if (nblockinsl4[nblocksl4] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsl4[nblocksl4]], o.sch_exp_ins_data[nblockinsl4[nblocksl4]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyl4[nblocksl4] - 33
						noteblockins[noteblocks] = nblockinsl4[nblocksl4]
						noteblockpit[noteblocks] = nblockpitl4[nblocksl4]
		                noteblocks += 1
		            }
		            nblocksl4 -= 1
		        }
		    }
			adds = 2
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir + 12
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocksr1 > -1) { // Note block #1
		            if (nblockinsr1[nblocksr1] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsr1[nblocksr1]], o.sch_exp_ins_data[nblockinsr1[nblocksr1]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyr1[nblocksr1] - 33
						noteblockins[noteblocks] = nblockinsr1[nblocksr1]
						noteblockpit[noteblocks] = nblockpitr1[nblocksr1]
		                noteblocks += 1
		            }
		            nblocksr1 -= 1
		        }
		        if (nblocksr1 > -1) { // Note block #2
		            if (nblockinsr1[nblocksr1] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsr1[nblocksr1]], o.sch_exp_ins_data[nblockinsr1[nblocksr1]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyr1[nblocksr1] - 33
						noteblockins[noteblocks] = nblockinsr1[nblocksr1]
						noteblockpit[noteblocks] = nblockpitr1[nblocksr1]
		                noteblocks += 1
		            }
		            nblocksr1 -= 1
		        }
		        if (nblocksr1 > -1) { // Note block #3
		            if (nblockinsr1[nblocksr1] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsr1[nblocksr1]], o.sch_exp_ins_data[nblockinsr1[nblocksr1]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyr1[nblocksr1] - 33
						noteblockins[noteblocks] = nblockinsr1[nblocksr1]
						noteblockpit[noteblocks] = nblockpitr1[nblocksr1]
		                noteblocks += 1
		            }
		            nblocksr1 -= 1
		        }
		        if (nblocksr1 > -1) { // Note block #4
		            if (nblockinsr1[nblocksr1] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsr1[nblocksr1]], o.sch_exp_ins_data[nblockinsr1[nblocksr1]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyr1[nblocksr1] - 33
						noteblockins[noteblocks] = nblockinsr1[nblocksr1]
						noteblockpit[noteblocks] = nblockpitr1[nblocksr1]
		                noteblocks += 1
		            }
		            nblocksr1 -= 1
		        }
		    }
			adds = 3
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir + 12 + 12
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocksr2 > -1) { // Note block #1x
		            if (nblockinsr2[nblocksr2] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsr2[nblocksr2]], o.sch_exp_ins_data[nblockinsr2[nblocksr2]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyr2[nblocksr2] - 33
						noteblockins[noteblocks] = nblockinsr2[nblocksr2]
						noteblockpit[noteblocks] = nblockpitr2[nblocksr2]
		                noteblocks += 1
		            }
		            nblocksr2 -= 1
		        }
		        if (nblocksr2 > -1) { // Note block #2
		            if (nblockinsr2[nblocksr2] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsr2[nblocksr2]], o.sch_exp_ins_data[nblockinsr2[nblocksr2]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyr2[nblocksr2] - 33
						noteblockins[noteblocks] = nblockinsr2[nblocksr2]
						noteblockpit[noteblocks] = nblockpitr2[nblocksr2]
		                noteblocks += 1
		            }
		            nblocksr2 -= 1
		        }
		        if (nblocksr2 > -1) { // Note block #3
		            if (nblockinsr2[nblocksr2] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsr2[nblocksr2]], o.sch_exp_ins_data[nblockinsr2[nblocksr2]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyr2[nblocksr2] - 33
						noteblockins[noteblocks] = nblockinsr2[nblocksr2]
						noteblockpit[noteblocks] = nblockpitr2[nblocksr2]
		                noteblocks += 1
		            }
		            nblocksr2 -= 1
		        }
		        if (nblocksr2 > -1) { // Note block #4
		            if (nblockinsr2[nblocksr2] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsr2[nblocksr2]], o.sch_exp_ins_data[nblockinsr2[nblocksr2]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyr2[nblocksr2] - 33
						noteblockins[noteblocks] = nblockinsr2[nblocksr2]
						noteblockpit[noteblocks] = nblockpitr2[nblocksr2]
		                noteblocks += 1
		            }
		            nblocksr2 -= 1
		        }
		    }
			adds = 4
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir + 12 + 12 + 12
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocksr3 > -1) { // Note block #1
		            if (nblockinsr3[nblocksr3] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsr3[nblocksr3]], o.sch_exp_ins_data[nblockinsr3[nblocksr3]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyr3[nblocksr3] - 33
						noteblockins[noteblocks] = nblockinsr3[nblocksr3]
						noteblockpit[noteblocks] = nblockpitr3[nblocksr3]
		                noteblocks += 1
		            }
		            nblocksr3 -= 1
		        }
		        if (nblocksr3 > -1) { // Note block #2
		            if (nblockinsr3[nblocksr3] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsr3[nblocksr3]], o.sch_exp_ins_data[nblockinsr3[nblocksr3]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyr3[nblocksr3] - 33
						noteblockins[noteblocks] = nblockinsr3[nblocksr3]
						noteblockpit[noteblocks] = nblockpitr3[nblocksr3]
		                noteblocks += 1
		            }
		            nblocksr3 -= 1
		        }
		        if (nblocksr3 > -1) { // Note block #3
		            if (nblockinsr3[nblocksr3] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsr3[nblocksr3]], o.sch_exp_ins_data[nblockinsr3[nblocksr3]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyr3[nblocksr3] - 33
						noteblockins[noteblocks] = nblockinsr3[nblocksr3]
						noteblockpit[noteblocks] = nblockpitr3[nblocksr3]
		                noteblocks += 1
		            }
		            nblocksr3 -= 1
		        }
		        if (nblocksr3 > -1) { // Note block #4
		            if (nblockinsr3[nblocksr3] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsr3[nblocksr3]], o.sch_exp_ins_data[nblockinsr3[nblocksr3]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyr3[nblocksr3] - 33
						noteblockins[noteblocks] = nblockinsr3[nblocksr3]
						noteblockpit[noteblocks] = nblockpitr3[nblocksr3]
		                noteblocks += 1
		            }
		            nblocksr3 -= 1
		        }
		    }
			adds = 5
		    for (b = 0; b < layers + 0; b += 1) { // add blocks
		        y1 = yy + dir + 12 + 12 + 12 + 12
				x1 = xx
		        block_repeater_track(x1 + 2, y1, b * 4 + 2 + adds, track_tick_delay, 2, 0)
		        block_circuit_track(x1 + dir, y1, b * 4 + 2 + adds)
		        block_circuit_track(x1 + 2, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir, y1, b * 4 + adds)
		        block_circuit_track(x1 + dir * 2, y1, b * 4 + 1 + adds)
		        block_other_track(x1 + dir, y1, b * 4 + 1 + adds, WIRE, 0)
		        if (nblocksr4 > -1) { // Note block #1
		            if (nblockinsr4[nblocksr4] > -1) {
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 - 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsr4[nblocksr4]], o.sch_exp_ins_data[nblockinsr4[nblocksr4]])
						block_circuit_track(x1 + dir * 2, y1 - 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyr4[nblocksr4] - 33
						noteblockins[noteblocks] = nblockinsr4[nblocksr4]
						noteblockpit[noteblocks] = nblockpitr4[nblocksr4]
		                noteblocks += 1
		            }
		            nblocksr4 -= 1
		        }
		        if (nblocksr4 > -1) { // Note block #2
		            if (nblockinsr4[nblocksr4] > -1) {
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + 1 + adds, 25, 0)
		                block_other_track(x1 + dir * 2, y1 + 1, b * 4 + adds, o.sch_exp_ins_block[nblockinsr4[nblocksr4]], o.sch_exp_ins_data[nblockinsr4[nblocksr4]])
						block_circuit_track(x1 + dir * 2, y1 + 1, b * 4 - 1 + adds)
		                noteblockx[noteblocks] = x1 + dir * 2
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 1 + adds
		                noteblocknote[noteblocks] = nblockkeyr4[nblocksr4] - 33
						noteblockins[noteblocks] = nblockinsr4[nblocksr4]
						noteblockpit[noteblocks] = nblockpitr4[nblocksr4]
		                noteblocks += 1
		            }
		            nblocksr4 -= 1
		        }
		        if (nblocksr4 > -1) { // Note block #3
		            if (nblockinsr4[nblocksr4] > -1) {
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 - 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsr4[nblocksr4]], o.sch_exp_ins_data[nblockinsr4[nblocksr4]])
						block_circuit_track(x1 + dir, y1 - 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 - 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyr4[nblocksr4] - 33
						noteblockins[noteblocks] = nblockinsr4[nblocksr4]
						noteblockpit[noteblocks] = nblockpitr4[nblocksr4]
		                noteblocks += 1
		            }
		            nblocksr4 -= 1
		        }
		        if (nblocksr4 > -1) { // Note block #4
		            if (nblockinsr4[nblocksr4] > -1) {
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 2 + adds, 25, 0)
		                block_other_track(x1 + dir, y1 + 1, b * 4 + 1 + adds, o.sch_exp_ins_block[nblockinsr4[nblocksr4]], o.sch_exp_ins_data[nblockinsr4[nblocksr4]])
						block_circuit_track(x1 + dir, y1 + 1, b * 4 + adds)
		                noteblockx[noteblocks] = x1 + dir
		                noteblocky[noteblocks] = y1 + 1
		                noteblockz[noteblocks] = b * 4 + 2 + adds
		                noteblocknote[noteblocks] = nblockkeyr4[nblocksr4] - 33
						noteblockins[noteblocks] = nblockinsr4[nblocksr4]
						noteblockpit[noteblocks] = nblockpitr4[nblocksr4]
		                noteblocks += 1
		            }
		            nblocksr4 -= 1
		        }
		    }
		    rep = 0
		    xx += 2 * dir
		    turn = 0
		}
    
		if (o.structure) {
			for (a = 0; a < noteblocks; a += 1) {
				TAG_Compound("nbt") // the non-command-block setting still needs this part because of magic
					if (o.command_block) TAG_String("id", "minecraft:command_block")
					if (o.command_block) TAG_String("Command", command_plan.rows[noteblockpit[a]].command)
					else TAG_String("Command", "")
					TAG_Byte("TrackOutput", 0)
					TAG_Byte("powered", 0)
					TAG_Byte("auto", 0)
					TAG_Byte("conditionMet", 1)
					TAG_Byte("UpdateLastExecution", 1)
					TAG_End()
				TAG_List("pos", 3, 3)
					structure_max_x = max(structure_max_x, 99 - noteblocky[a])
					structure_max_y = max(structure_max_y, noteblockz[a])
					structure_max_z = max(structure_max_z, noteblockx[a])
					buffer_write_int_be(99 - noteblocky[a])
					buffer_write_int_be(noteblockz[a])
					buffer_write_int_be(noteblockx[a])
		            TAG_Int("state", 3 + insnum + (noteblockins[a] * 25 + noteblocknote[a]) * !o.command_block)
		            TAG_End()
				totalblocksc++
		        }
			TAG_End()
			blockamount = totalblocksc
			buffer_seek(buffer, buffer_seek_start, sizepos)
			if (o.sch_exp_format = 1) {
				buffer_write_int_be(structure_max_x + 1)
				buffer_write_int_be(structure_max_y + 1)
				buffer_write_int_be(structure_max_z + 1)
			} else {
				buffer_write_int_be(min(structure_max_x + 1, 32))
				buffer_write_int_be(min(structure_max_y + 1, 32))
				buffer_write_int_be(min(structure_max_z + 1, 32))
			}
			buffer_seek(buffer, buffer_seek_start, blocktagpos)
			TAG_List("blocks", blockamount, 10)
		} else {
			len = max(len, structure_max_x + 1)
			wid = max(100, structure_max_y + 1)
			hei = max(hei, structure_max_z + 1)

			TAG_Compound("Schematic")
			TAG_Short("Height", hei)
			TAG_Short("Length", len)
			TAG_Short("Width", wid)
			TAG_List("Entities", 0, 10)
			TAG_List("TileEntities", 1 + noteblocks, 10)
				if (o.sch_exp_minecraft_old) TAG_String("id", "Sign")
				else TAG_String("id", "minecraft:sign")
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
				for (a = 0; a < noteblocks; a += 1) {
					if (o.sch_exp_minecraft_old) TAG_String("id", "Music")
					else TAG_String("id", "minecraft:noteblock")
					TAG_Int("x", wid - 1 - noteblocky[a])
					TAG_Int("y", noteblockz[a])
					TAG_Int("z", noteblockx[a])
					TAG_Byte("note", noteblocknote[a])
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
		}
	    buffer_save(buffer, temp_file)
	    buffer_delete(buffer)
		log("totalblocksc: " + string(totalblocksc))
		totalblocksc = 0
	    gzzip(temp_file, fn)
		if (is_struct(command_plan)) minecraft_export_log_report(command_plan, o.sch_command_source, "Track command-block structure")
	    instance_destroy()
	}
	if (o.language != 1) message(condstr(structure, "Structure saved!", "Schematic saved!"), "Track Export")
	else message(condstr(structure, "结构已保存！", "Schematic 已保存！"), "导出直轨")
	window = w_track_export



}
