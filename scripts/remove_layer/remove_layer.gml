function remove_layer(argument0, argument1) {
	// remove_layer(num, undo)
	// Removes the contents of the layer and shifts up everything below

	var num, solonum, solostrnew, i, char, blocks, xx, name, lock, vol, pan, l
	num = argument0

	// Update solo
	songs[song].solostr = string_replace_all(songs[song].solostr, "|" + string(num) + "|", "")
	solonum = ""
	solostrnew = songs[song].solostr
	if (songs[song].solostr != "") {
		for (i = 1; i <= string_length(songs[song].solostr); i++) {
			char = string_char_at(songs[song].solostr, i)
			if (char = string_digits(char)) {
				solonum += char
			} else if ((char = "|") && (solonum != "") && (real(solonum) > num)) {
				// if number is greater than the layer being removed, subtract one from it
				solostrnew = string_replace_all(solostrnew, "|" + solonum + "|", "|" + string(real(solonum - 1)) + "|")
				solonum = ""
			}
		}
	}
	songs[song].solostr = solostrnew

	// Remove blocks
	selection_place(false)
	selection_add(0, num, songs[song].enda, num, 0, true, true)
	blocks = songs[song].selection_code
	xx = songs[song].selection_x
	name = songs[song].layername[num]
	lock = songs[song].layerlock[num]
	vol = songs[song].layervol[num]
	pan = songs[song].layerstereo[num]
	selection_delete(true)

	// Remove properties
	text_str[num + 100] = ""
	songs[song].layername[num] = ""
	songs[song].layerlock[num] = 0
	songs[song].layervol[num] = 100
	songs[song].layerstereo[num] = 100

	// Shift blocks up
	selection_add(0, num + 1, songs[song].enda, songs[song].endb2, 0, true, true)
	songs[song].selection_y -= 1
	selection_place(true)

	// Shift properties
	for (l = num; l < songs[song].endb2 - 1; l++) {
		songs[song].layername[l] = songs[song].layername[l + 1]
		songs[song].layerlock[l] = songs[song].layerlock[l + 1]
		songs[song].layervol[l] = songs[song].layervol[l + 1]
		songs[song].layerstereo[l] = songs[song].layerstereo[l + 1]
		swap_text_edit(400 + l, 400 + l + 1)
	}

	songs[song].endb2 -= 1

	songs[song].changed = 1
	if (!argument1) history_set(h_removelayer, num, blocks, xx, name, lock, vol, pan)


}
