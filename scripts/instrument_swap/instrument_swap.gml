function instrument_swap(ins1, ins2) {
	var a, b, ins, index1, index2;
	
	index1 = ds_list_find_index(songs[song].instrument_list, ins1)
	index2 = ds_list_find_index(songs[song].instrument_list, ins2)
	
	ds_list_replace(songs[song].instrument_list, index1, ins2)
	ds_list_replace(songs[song].instrument_list, index2, ins1)
	
	text_str[70 + index1] = ins2.name
	text_str[70 + index2] = ins1.name
	text_exists[70 + index1] = 0
	text_exists[70 + index2] = 0
	
	for (a = 0; a <= songs[song].enda; a += 1) {
		if (songs[song].colamount[a] > 0) {
			for (b = songs[song].colfirst[a]; b <= songs[song].collast[a]; b += 1) {
			    if (songs[song].song_exists[a, b]) {
					ins = ds_list_find_index(songs[song].instrument_list, songs[song].song_ins[a, b])
					if (ins == index1) {
						songs[song].song_ins[a, b] = ins2
					}
					else if (ins == index2) {
						songs[song].song_ins[a, b] = ins1
					}
				}
			}
		}
	}
	
	songs[song].changed = 1
}