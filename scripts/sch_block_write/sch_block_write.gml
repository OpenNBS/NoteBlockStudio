function sch_block_write(argument0, argument1, argument2, argument3) {
	// sch_block_write(x, y, z, val)

	var xx, yy, zz, val, t;
	xx = argument0;
	yy = argument1;
	zz = argument2;
	val = argument3;

	if (variable_instance_exists(id, "structure_max_x")) {
		structure_max_x = max(structure_max_x, xx)
		structure_max_y = max(structure_max_y, yy)
		structure_max_z = max(structure_max_z, zz)
	}

	t = xx * 2000 * 256 + zz * 2000 + yy;
	d = sqrt(2000 * 256 * 2000);
	sch_block[t div d, t mod d] = val



}
