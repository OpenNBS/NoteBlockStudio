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
	var stopper_changes = []
	if (!argument2) stopper_changes = sound_stopper_layer_changes(h_swaplayer, l1, l2)
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
	if (!argument2) {
		sound_stopper_layer_restore(stopper_changes, true)
		history_set(h_swaplayer, l1, l2, stopper_changes)
	}


}

// Record only changed stoppers, before moving any notes. History stores both
// positions and exact values so undo/redo does not depend on the preference.
function sound_stopper_layer_changes(kind, layer1, layer2 = -1) {
	var changes = []
	if (!sound_stopper_follow_layers) return changes
	var current_song = songs[song]
	var edited_layer = layer1 + 1
	for (var tick = 0; tick <= current_song.enda; tick++) {
		if (current_song.colamount[tick] <= 0) continue
		var first_layer = current_song.colfirst[tick]
		var last_layer = current_song.collast[tick]
		if (kind == h_swaplayer) {
			first_layer = max(first_layer, min(layer1, layer2))
			last_layer = min(last_layer, max(layer1, layer2))
		}
		for (var layer_index = first_layer; layer_index <= last_layer; layer_index++) {
			if (!current_song.song_exists[tick, layer_index]) continue
			if (current_song.song_ins[tick, layer_index].name != "Sound Stopper") continue
			var old_start = current_song.song_pit[tick, layer_index]
			var old_pan = current_song.song_pan[tick, layer_index]
			var old_vel = current_song.song_vel[tick, layer_index]
			var start_layer = floor(old_start)
			var end_layer = panning_velocity_to_short(old_pan, old_vel)
			// Zero/negative starts are global. Empty ranges remain disabled.
			if (start_layer <= 0 || end_layer < start_layer) continue
			var new_layer = layer_index
			var new_start = start_layer
			var new_end = end_layer
			if (kind == h_addlayer) {
				if (layer_index >= layer1) new_layer++
				if (edited_layer <= start_layer) new_start++
				if (edited_layer <= end_layer) new_end++
			} else if (kind == h_removelayer) {
				if (layer_index == layer1) continue // The layer's own history restores these notes.
				if (layer_index > layer1) new_layer--
				if (edited_layer < start_layer) new_start--
				if (edited_layer <= end_layer) new_end--
			} else if (kind == h_swaplayer) {
				if (layer_index == layer1) new_layer = layer2
				else if (layer_index == layer2) new_layer = layer1
				else continue
				// Preserve the range width at the file format's layer limits.
				var offset = clamp(new_layer - layer_index, 1 - start_layer, 32767 - end_layer)
				new_start += offset
				new_end += offset
			}
			if (new_end < new_start) {
				new_start = 1
				new_end = 0 // Empty, never global.
			} else {
				new_start = clamp(new_start, 1, 32767)
				new_end = clamp(new_end, new_start, 32767)
			}
			if (new_start == start_layer && new_end == end_layer) continue
			var packed_end = short_to_panning_velocity(new_end)
			array_push(changes, [tick, layer_index, new_layer, old_start, old_pan, old_vel, new_start, packed_end[0], packed_end[1]])
		}
	}
	return changes
}

function sound_stopper_layer_restore(changes, forward) {
	if (!is_array(changes)) return
	var current_song = songs[song]
	for (var i = 0; i < array_length(changes); i++) {
		var entry = changes[i]
		var tick = entry[0]
		var layer_index = entry[forward ? 2 : 1]
		var value_index = forward ? 6 : 3
		current_song.song_pit[tick, layer_index] = entry[value_index]
		current_song.song_pan[tick, layer_index] = entry[value_index + 1]
		current_song.song_vel[tick, layer_index] = entry[value_index + 2]
	}
}
