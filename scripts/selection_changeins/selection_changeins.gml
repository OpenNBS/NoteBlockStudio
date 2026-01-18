function selection_changeins(argument0) {
	// selection_changeins(ins)
	var a, b, str, inst;
	inst = argument0
	str = songs[song].selection_code
	if (songs[song].selected = 0) return 0
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    if (songs[song].selection_colfirst[a] > -1) {
	        for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	            if (songs[song].selection_exists[a, b]) {
					songs[song].selection_ins[a, b] = inst
	            }
	        }
	    }
	}
	selection_code_update()
	history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)



}
