function macro_reset() {
	// macro_reset()
	var str = songs[song].selection_code
	if (songs[song].selected = 0) return 0
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    if (songs[song].selection_colfirst[a] > -1) {
	        for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	            if (songs[song].selection_exists[a, b]) {
					songs[song].selection_vel[a, b] = 100
					songs[song].selection_pan[a, b] = 100
					songs[song].selection_pit[a, b] = 0
	            }
	        }
	    }
	}
	selection_code_update()
	history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)
	if(!keyboard_check(vk_alt)) selection_place(false)
}
