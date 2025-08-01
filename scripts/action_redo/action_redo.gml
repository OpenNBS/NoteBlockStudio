function action_redo() {
	// action_redo()
	var t, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14;
	if (songs[song].historypos = 0) return 0
	songs[song].historypos -= 1
	t = songs[song].history[songs[song].historypos, 0]
	arg0 = songs[song].history[songs[song].historypos, 1]
	arg1 = songs[song].history[songs[song].historypos, 2]
	arg2 = songs[song].history[songs[song].historypos, 3]
	arg3 = songs[song].history[songs[song].historypos, 4]
	arg4 = songs[song].history[songs[song].historypos, 5]
	arg5 = songs[song].history[songs[song].historypos, 6]
	arg6 = songs[song].history[songs[song].historypos, 7]
	arg7 = songs[song].history[songs[song].historypos, 8]
	arg8 = songs[song].history[songs[song].historypos, 9]
	arg9 = songs[song].history[songs[song].historypos, 10]
	arg10 = songs[song].history[songs[song].historypos, 11]
	arg11 = songs[song].history[songs[song].historypos, 12]
	arg12 = songs[song].history[songs[song].historypos, 13]
	arg13 = songs[song].history[songs[song].historypos, 14]
	arg14 = songs[song].history[songs[song].historypos, 15]
	songs[song].changed = 1

	switch (t) {
		case h_addblock: {
			add_block(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
			update_tempo_changes()
			break
		}
		case h_removeblock: {
			remove_block(arg0, arg1)
			update_tempo_changes()
			break
		}
		case h_changeblock: {
			change_block(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
			break
		}
		case h_selectadd: {
			selection_add(arg0, arg1, arg2 - 1, arg3 - 1, arg4, 1)
			break
		}
		case h_selectremove: {
			selection_remove(arg0, arg1, arg2, arg3, 0, 1)
			break
		}
		case h_selectchange: {
			selection_delete(1)
			selection_load(arg0, arg1, arg2, 1)
			break
		}
		case h_selectmove: {
			songs[song].selection_x = arg0
			songs[song].selection_y = arg1
			break
		}
		case h_selectpaste: {
			selection_load(arg0, arg1, arg2, 1)
			break
		}
		case h_select: {
			selection_place(1)
			selection_load_ext(arg0, arg1, arg2)
			break
		}
		case h_addlayer: {
			add_layer(arg0, true, arg1, arg2, arg3, arg4, arg5, arg6)
			break
		}
		case h_removelayer: {
			remove_layer(arg0, true)
			break
		}
		case h_swaplayer: {
			shift_layers(arg0, arg1, true)
			break
		}
	}
}
