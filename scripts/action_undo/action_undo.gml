function action_undo() {
	// action_undo()
	var t, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, a, b;
	if (songs[song].historypos = songs[song].historylen) return 0
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
	songs[song].historypos += 1
	songs[song].changed = 1
	switch (t) {		
		case h_addblock: {
		    remove_block(arg0, arg1)
			update_tempo_changes()
			break
		}
		case h_removeblock: {
		    add_block(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
			update_tempo_changes()
			break
		}
		case h_changeblock: {
		    change_block(arg0, arg1, arg7, arg8, arg9, arg10, arg11)
			break
		}
		case h_selectadd: {
		    selection_remove(arg0, arg1, arg2, arg3, 0, 1)
			break
		}
		case h_selectremove: {
		    selection_add(arg0, arg1, arg2 - 1, arg3 - 1, 0, 1)
		    selection_delete(1)
		    selection_load(arg4, arg5, arg6, true)
		    region_code_load(arg0, arg1, arg7)
			break
		}
		case h_selectchange: {
		    selection_delete(1)
		    selection_load(arg3, arg4, arg5, 1)
			break
		}
		case h_selectmove: {
		    songs[song].selection_x = arg2
		    songs[song].selection_y = arg3
			break
		}
		case h_selectpaste: {
		    selection_delete(1)
			break
		}
		case h_select: {
		    selection_place(1)
		    selection_load_ext(arg3, arg4, arg5)
			break
		}
		case h_addlayer: {
			remove_layer(arg0, true)
			break
		}
		case h_removelayer: {
			add_layer(arg0, true, arg1, arg2, arg3, arg4, arg5, arg6)
			break
		}
		case h_swaplayer: {
			shift_layers(arg1, arg0, true)
			break
		}
		case h_stereoize: {
			selection_load(arg0, arg1, arg2, true)
			break
		}
	}
}
