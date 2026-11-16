function macro_replacekey() {
	// macro_replacekey()
	// Replaces all notes with the first note in the selection. Good for batch chord and tremolo edits.
	var str, key
	str = songs[song].selection_code
	if (songs[song].selected = 0) return 0
	var arr_data = selection_to_array_ext()
	key = -1
	var at = 0
	while (at < array_length(arr_data)) {
		at++ // Column offset
		while (arr_data[at] != -1) {
			if (!macro_is_event_note(arr_data[at + 1])) {
				key = arr_data[at + 2]
				break
			}
			at += 6
		}
		if (key != -1) break
		at++
	}
	if (key == -1) return 0
	selection_change(m_key, key, false)
	songs[song].changed = 1
	if(!keyboard_check(vk_alt)) selection_place(false)
}
