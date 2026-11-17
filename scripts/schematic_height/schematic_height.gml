function schematic_height() {
	// schematic_height()

	var maximum = sch_exp_maxheight[sch_exp_compress]
	if (structure && command_block && sch_exp_layout < 2) maximum = minecraft_export_get_schematic_plan().maximum_slots
	return 4 + 3 * ceil(maximum / 4)



}
