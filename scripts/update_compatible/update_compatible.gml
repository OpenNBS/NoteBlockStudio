function update_compatible(song){
	if (song.selected = 0) {
		if (song.block_outside = 0 && song.block_custom = 0) {
			if ((song.real_tempo = 10 || song.real_tempo = 5 || song.real_tempo = 2.5) && song.block_pitched = 0) song.compatible = 1
			else song.compatible = 2
		} else song.compatible = 0
	}
}