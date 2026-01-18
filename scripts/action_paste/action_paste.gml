function action_paste(argument0, argument1) {
	// action_paste(x, y)
	var xx, yy;
	xx = argument0
	yy = argument1
	if (copied_arraylength > songs[song].selection_arraylength) { // New length
	    for (var a = songs[song].selection_arraylength + 1; a <= copied_arraylength; a += 1) {
	        songs[song].selection_colfirst[a] = -1
	        songs[song].selection_collast[a] = -1
	        for (var b = 0; b <= songs[song].selection_arrayheight; b += 1) {
	            songs[song].selection_exists[a, b] = 0
	        }
	    }
	    songs[song].selection_arraylength = copied_arraylength
	}
	if (copied_arrayheight > songs[song].selection_arrayheight) { // New height
	    for (var a = 0; a <= songs[song].selection_arraylength; a += 1) {
	        for (var b = songs[song].selection_arrayheight + 1; b <= copied_arrayheight; b += 1) {
	            songs[song].selection_exists[a, b] = 0
	        }
	    }
	    songs[song].selection_arrayheight = copied_arrayheight
	}
	selection_load(xx, yy, selection_copied, false)
	history_set(h_selectpaste, xx, yy, songs[song].selection_code)
	songs[song].changed = 1


}
