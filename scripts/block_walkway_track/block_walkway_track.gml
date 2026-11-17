function block_walkway_track(x, y, z){
	if (!obj_controller.structure) {
		sch_block_write(x, y, z, block_walkway_block)
		sch_data_write(x, y, z, block_walkway_data)
		return
	}
	var blockx = 99 - y
	structure_max_x = max(structure_max_x, blockx)
	structure_max_y = max(structure_max_y, z)
	structure_max_z = max(structure_max_z, x)
	TAG_List("pos", 3, 3)
		buffer_write_int_be(blockx)
		buffer_write_int_be(z)
		buffer_write_int_be(x)
	TAG_Int("state", 0)
	TAG_End()
	totalblocksc++
}
