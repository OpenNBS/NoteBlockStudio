function macro_replacekey() {
	// macro_replacekey()
	// Replaces all notes with the first note in the selection. Good for batch chord and tremolo edits.
	var str, key
	str = songs[song].selection_code
	if (songs[song].selected = 0) return 0
	var arr_data = selection_to_array_ext()
	key = arr_data[3]
	selection_change(m_key, key, false)
	if(!keyboard_check(vk_alt)) selection_place(false)
}
