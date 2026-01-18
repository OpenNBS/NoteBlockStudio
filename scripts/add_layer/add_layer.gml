function add_layer() {
	// add_layer(num, undo[, blocks, x, lock, vol, pan])

	var num, solonum, solostrnew, i, char, blocks, xx, name, lock, vol, pan, l

	num = argument[0]
	if (argument_count > 2) {
		blocks = argument[2]
		xx = argument[3]
		name = argument[4]
		lock = argument[5]
		vol = argument[6]
		pan = argument[7]
	}
	else {
		blocks = ""
		xx = 0
		name = ""
		lock = 0
		vol = 100
		pan = 100
	}

	// Update solo
	solonum = ""
	solostrnew = ""
	if (songs[song].solostr != "") {
		for (i = 1; i <= string_length(songs[song].solostr); i++) {
			char = string_char_at(songs[song].solostr, i)
			if (char = string_digits(char)) {
				solonum += char
			} else if ((char = "|") && (solonum != "")) {
				if (real(solonum) > num) {
					// if number is greater than the layer being added, add one to it
					solostrnew += "|" + string(real(solonum) + 1) + "|"
				} else {
					solostrnew += "|" + solonum + "|"
				}
				solonum = ""
			}
		}
	}
	if (lock == 2) solostrnew += "|" + string(num) + "|"
	songs[song].solostr = solostrnew

	// Shift blocks down
	selection_place(false)
	selection_add(0, num, songs[song].enda, songs[song].endb2, 0, true, true)
	songs[song].selection_y += 1
	selection_place(true)

	// Set properties on last layer (will be shifted up)
	text_str[songs[song].endb2 + 400] = ""
	songs[song].layername[songs[song].endb2] = ""
	songs[song].layerlock[songs[song].endb2] = 0
	songs[song].layervol[songs[song].endb2] = 100
	songs[song].layerstereo[songs[song].endb2] = 100
	songs[song].endb2 += 1

	// Shift properties
	for (l = songs[song].endb2; l > num; l--) {
		songs[song].layername[l] = songs[song].layername[l - 1]
		songs[song].layerlock[l] = songs[song].layerlock[l - 1]
		songs[song].layervol[l] = songs[song].layervol[l - 1]
		songs[song].layerstereo[l] = songs[song].layerstereo[l - 1]
		swap_text_edit(400 + l, 400 + l - 1)
	}
	songs[song].solostr = string_replace_all(songs[song].solostr, "|" + string(num) + "|", "|" + string(num + 1) + "|")

	// Place layer back
	if (blocks != "") {
		selection_load(xx, num, blocks, true)
		selection_place(true)
	}
	text_str[num + 400] = name
	songs[song].layername[num] = name
	songs[song].layerlock[num] = lock
	songs[song].layervol[num] = vol
	songs[song].layerstereo[num] = pan

	songs[song].changed = 1
	if (!argument[1]) history_set(h_addlayer, num, blocks, xx, name, lock, vol, pan)


}
