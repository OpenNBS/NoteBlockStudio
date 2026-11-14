function block_repeater_track(x, y, z, delay, direction, powered){
	if (!obj_controller.structure) {
		sch_block_write(x, y, z, 93 + powered)
		sch_data_write(x, y, z, delay * 4 + direction)
		return
	}
	var insnum = ds_list_size(obj_controller.songs[obj_controller.song].instrument_list)
	var dir
	var blockx = 99 - y
	structure_max_x = max(structure_max_x, blockx)
	structure_max_y = max(structure_max_y, z)
	structure_max_z = max(structure_max_z, x)
	if (direction = 1) {
		if (delay = 0) dir = 11
		else if (delay = 1) dir = 12
		else if (delay = 2) dir = 13
		else if (delay = 3) dir = 14
	}
	else if (direction = 2) {
		if (delay = 0) dir = 7
		else if (delay = 1) dir = 8
		else if (delay = 2) dir = 9
		else if (delay = 3) dir = 10
	}
	else if (direction = 3) {
		dir = 15
	}
	TAG_List("pos", 3, 3)
		buffer_write_int_be(blockx)
		buffer_write_int_be(z)
		buffer_write_int_be(x)
	TAG_Int("state", insnum * 26 + dir)
	TAG_End()
	totalblocksc++
}
