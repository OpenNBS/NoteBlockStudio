function schematic_end() {
	// schematic_end()

	// Frees DLLs. Should be called in a game end event.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	if (os_type = os_windows) external_free(global.path_gmbinfile);


}
