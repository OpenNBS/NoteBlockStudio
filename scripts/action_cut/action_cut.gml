function action_cut() {
	// action_cut()
	action_copy()
	selection_delete(false)
	songs[song].changed = 1

}
