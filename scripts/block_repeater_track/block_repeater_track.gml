function block_repeater_track(x, y, z, delay, direction, powered){
	var insnum = ds_list_size(obj_controller.songs[obj_controller.song].instrument_list)
	var dir
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
		buffer_write_int_be(99 - y)
		buffer_write_int_be(z)
		buffer_write_int_be(x)
	TAG_Int("state", insnum * 26 + dir)
	TAG_End()
	totalblocksc++
}