function reset_schematic_export(argument0) {
	// reset_schematic_export()
	if (!argument0) {
	    selected_tab_sch = 0
	    sch_exp_remember = 1
		sch_br_remember = 1
	}
	for (a = 0; a < ds_list_size(songs[song].instrument_list) + 240; a += 1) {
	    sch_exp_ins_data[a] = 0
	}
	sch_exp_ins_block[0] = 3
	sch_exp_ins_block[1] = 5
	sch_exp_ins_block[2] = 4
	sch_exp_ins_block[3] = 12
	sch_exp_ins_block[4] = 20
	sch_exp_ins_block[5] = 35
	sch_exp_ins_block[6] = 82
	sch_exp_ins_block[7] = 41
	sch_exp_ins_block[8] = 174
	sch_exp_ins_block[9] = 216
	sch_exp_ins_block[10] = 42
	sch_exp_ins_block[11] = 88
	sch_exp_ins_block[12] = 86
	sch_exp_ins_block[13] = 133
	sch_exp_ins_block[14] = 170
	sch_exp_ins_block[15] = 89
	for (var a = 0; a < 240; a++) {
		sch_exp_ins_block[16 + a] = 1
	}

	sch_exp_walkway_block = 1
	sch_exp_walkway_data = 0
	sch_exp_circuit_block = 1
	sch_exp_circuit_data = 0
	sch_exp_ground_block = 1
	sch_exp_ground_data = 0

	sch_exp_minecraft_old = false
	sch_exp_layout = 1 // 0 = Circular walkway, 1 = Simple walkway, 2 = Classic
	sch_exp_stereo = 4
	sch_exp_notesperrow = 20
	sch_exp_layer1 = 1
	sch_exp_layer2 = 1
	sch_exp_layer3 = 1
	sch_exp_polyphony = 0
	sch_exp_includelocked = 0
	sch_exp_compress = 1
	sch_exp_velocity = 1
	sch_exp_circuitry = 1
	sch_exp_vertical = 0
	sch_exp_range_start = 0
	sch_exp_range_end = 0
	sch_exp_loop = 1
	sch_exp_glass = 1
	sch_exp_minecart = 0
	sch_exp_chest = 1
	sch_exp_minecraft_old = false // For pre 1.11




}
