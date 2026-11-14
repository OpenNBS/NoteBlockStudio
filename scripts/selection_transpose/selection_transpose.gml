function selection_transpose() {
	// selection_transpose()
	var a, b, str, key, am;
	str = songs[song].selection_code
	if (songs[song].selected = 0) return 0
	am = 0
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    if (songs[song].selection_colfirst[a] > -1) {
	        for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	            if (songs[song].selection_exists[a, b]) {
	                key = songs[song].selection_key[a, b]
	                if (key < 33 || key > 57) am += 1
	                while (key < 33) key += 12
	                while (key > 57) key -= 12
	                songs[song].selection_key[a, b] = key
	            }
	        }
	    }
	}
	message(string(am) + " notes were edited.", "Transpose notes")
	selection_code_update()
	history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)



}
