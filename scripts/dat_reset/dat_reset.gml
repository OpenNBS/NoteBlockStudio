function dat_reset(argument0) {
	// dat_reset(mode)
	// Resets datapack preferences to default

	if (!argument0) {
		selected_tab_dat = 0
		dat_remember = 1
	}
	dat_name = ""
	dat_namespace = ""
	dat_path = ""
	dat_source = "record"
	dat_allowed_sources = minecraft_export_default_allowed_sources()
	dat_mcversion = 1  // Default to 1.21+
	dat_usezip = 1
	dat_includelocked = 0
	dat_includeoutofrange = 0
	dat_enableradius = 0
	dat_radius = 16
	dat_radiusvalue = 0
	dat_enablelooping = 0
	dat_remember = 1
	dat_vis_type = "Arc"
	dat_glow = 1
	dat_yval = 100
	dat_xval = 0
	dat_zval = 0
	dat_visualizer = 0


}
