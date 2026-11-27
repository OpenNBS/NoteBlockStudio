function get_tab_offset(){
	if (array_length(songs) > 1 && !fullscreen) {
		if (theme = 0) return 35
		if (theme = 1) return 30
		if (theme = 2) return 30
		if (theme = 3) return 40
	}
	return 0
}