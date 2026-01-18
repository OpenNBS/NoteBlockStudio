function action_cut() {
	// action_cut()
	selection_copied = songs[song].selection_code
	copied_arraylength = songs[song].selection_arraylength
	copied_arrayheight = songs[song].selection_arrayheight
	selection_delete(false)
	clipboard = selection_copied
	songs[song].changed = 1

}
