function check_unsaved(){
	for (var i = 0; i < array_length(songs); i++) {
		//log ("changed: " + string(songs[i].changed))
		if (songs[i].changed) return 1
	}
	return 0
}