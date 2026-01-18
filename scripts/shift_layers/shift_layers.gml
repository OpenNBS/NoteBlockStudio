function shift_layers(argument0, argument1, argument2) {
	// shift_layers(layer1, layer2, undo)
	// Shifts the contents and names of two layers

	var l1, l2, tempx, templayer, templayername, templayerlock, templayervol, templayerstereo
	l1 = argument0
	l2 = argument1

	// Add new layer at the end if necessary
	if (l1 >= songs[song].endb2 || l2 >= songs[song].endb2) {
		songs[song].endb2 += 1
		songs[song].layername[songs[song].endb2] = ""
		songs[song].layerlock[songs[song].endb2] = 0
		songs[song].layervol[songs[song].endb2] = 100
		songs[song].layerstereo[songs[song].endb2] = 100
	}

	// Update solo
	if (songs[song].layerlock[l1] = 2 ^^ songs[song].layerlock[l2] = 2) {
		if (songs[song].layerlock[l1] = 2) songs[song].solostr = string_replace_all(songs[song].solostr, "|" + string(l1) + "|", "|" + string(l2) + "|")
		else if (songs[song].layerlock[l2] = 2) songs[song].solostr = string_replace_all(songs[song].solostr, "|" + string(l2) + "|", "|" + string(l1) + "|")
	}

	// Store first layer
	selection_place(false)
	selection_add(0, l1, songs[song].enda, l1, 0, true, true)
	tempx = songs[song].selection_x
	templayer = songs[song].selection_code
	templayername = songs[song].layername[l1]
	templayerlock = songs[song].layerlock[l1]
	templayervol = songs[song].layervol[l1]
	templayerstereo = songs[song].layerstereo[l1]
	selection_delete(true)

	// Move second layer to first
	selection_add(0, l2, songs[song].enda, l2, 0, true, true)
	songs[song].selection_y = l1
	selection_place(true)
	songs[song].layername[l1] = songs[song].layername[l2]
	songs[song].layerlock[l1] = songs[song].layerlock[l2]
	songs[song].layervol[l1] = songs[song].layervol[l2]
	songs[song].layerstereo[l1] = songs[song].layerstereo[l2]

	// Place stored layer into second layer
	selection_load(tempx, l2, templayer, true)
	selection_place(true)
	songs[song].layername[l2] = templayername
	songs[song].layerlock[l2] = templayerlock
	songs[song].layervol[l2] = templayervol
	songs[song].layerstereo[l2] = templayerstereo

	// Swap name boxes
	swap_text_edit(400 + l1, 400 + l2)

	songs[song].changed = 1
	if (!argument2) history_set(h_swaplayer, l1, l2)


}
