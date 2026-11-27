function selection_get_custom_instruments() {
	// Returns snapshots of the custom instruments used by the current selection.
	var custom_instruments = []

	for (var a = 0; a < songs[song].selection_l; a++) {
		if (songs[song].selection_colfirst[a] > -1) {
			for (var b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b++) {
				if (songs[song].selection_exists[a, b]) {
					var ins = songs[song].selection_ins[a, b]
					if (ins.user) {
						var source_index = ds_list_find_index(songs[song].instrument_list, ins)
						var already_added = false
						for (var i = 0; i < array_length(custom_instruments); i++) {
							if (custom_instruments[i].source_index == source_index) {
								already_added = true
								break
							}
						}

						if (!already_added) {
							array_push(custom_instruments, {
								source_index: source_index,
								name: ins.name,
								filename: string_replace_all(ins.filename, "\\", "/"),
								key: ins.key,
								press: ins.press
							})
						}
					}
				}
			}
		}
	}

	return custom_instruments
}
