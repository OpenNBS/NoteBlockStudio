function selection_expand_layers(){
	if (songs[song].selection_y + songs[song].selection_h - 1 >= songs[song].endb2) {
		for (i = songs[song].endb2; i < songs[song].selection_y + songs[song].selection_h; i++) {
			songs[song].layername[i] = ""
			songs[song].layerlock[i] = 0
			songs[song].layervol[i] = 100
			songs[song].layerstereo[i] = 100
			songs[song].rowamount[i] = 0
			songs[song].endb2 = i + 1
		}
	}
}