function block_other_track(x, y, z, id, data){
	var insnum = ds_list_size(obj_controller.songs[obj_controller.song].instrument_list)
	if (id = 0) TAG_Int("state", insnum * 26 + 4) //air
	else if (id = 35 && data = 11) TAG_Int("state", insnum * 26 + 3) //blue_wool
	else if (id = 65) TAG_Int("state", insnum * 26 + 5) //ladder
	else if (id = 55) TAG_Int("state", insnum * 26 + 6) //redstone_wire
	else if (id = 75 && data = 5) TAG_Int("state", insnum * 26 + 16) //unlit torch
	else if (id = 76 && data = 5) TAG_Int("state", insnum * 26 + 17) //lit torch
	else if (id = 77) TAG_Int("state", insnum * 26 + 18) //south stone_button
	else if (id = 27) TAG_Int("state", insnum * 26 + 20) //ns powered_rail
	else if (id = 66) TAG_Int("state", insnum * 26 + 22) //ns rail
	else if (id = 75 && data = 1) TAG_Int("state", insnum * 26 + 23) //east unlit walltorch
	else if (id = 76 && data = 1) TAG_Int("state", insnum * 26 + 24) //east lit walltorch
	else if (id = 75 && data = 2) TAG_Int("state", insnum * 26 + 25) //west unlit walltorch
	else if (id = 76 && data = 2) TAG_Int("state", insnum * 26 + 26) //west lit walltorch
	else if (id = 69) TAG_Int("state", insnum * 26 + 27) //south lever
	else if (id = 75 && data = 4) TAG_Int("state", insnum * 26 + 28) //north lit walltorch
	else if (id = 44) TAG_Int("state", insnum * 26 + 29) //top slab
	else {
		for (var i = 0; i < insnum; i++) {
			if (id = obj_controller.sch_exp_ins_block[i] && data = obj_controller.sch_exp_ins_data[i]) {TAG_Int("state", 3 + i); break;}
			else if (i = insnum - 1) {TAG_Int("state", insnum * 26 + 4); break;}
		}
	}
	TAG_List("pos", 3, 3)
		buffer_write_int_be(99 - y)
		buffer_write_int_be(z)
		buffer_write_int_be(x)
	TAG_End()
	totalblocksc++
}