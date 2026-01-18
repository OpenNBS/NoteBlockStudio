function save_unsaved() {
	// save_unsaved()

	var a, gameend, songid;
	playing = 0
	songid = song

	if (songs[songid].changed && !isplayer) {
	    save_song(backup_directory + "" + condstr(songs[songid].filename != "", filename_name(songs[songid].filename), filename_name(songs[songid].song_backupname)) + ".nbs", true)
	}



}
