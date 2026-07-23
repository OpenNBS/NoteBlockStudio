function action_copy() {
	// action_copy()
	selection_copied = songs[song].selection_code
	copied_arraylength = songs[song].selection_arraylength
	copied_arrayheight = songs[song].selection_arrayheight
	clipboard = selection_copied

	// Keep enough song and instrument context to safely paste into another tab.
	copied_from_song = songs[song]
	copied_context_code = selection_copied
	copied_note_count = songs[song].selected
	copied_source_name = filename_name(songs[song].filename)
	if (copied_source_name == "" || copied_source_name == "-player") copied_source_name = songs[song].song_backupname
	copied_custom_instruments = selection_get_custom_instruments()


}
