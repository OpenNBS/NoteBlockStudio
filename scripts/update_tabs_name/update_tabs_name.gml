function update_tabs_name(){
	for (var nn = 0; nn < array_length(songs); nn++) {
		songs[nn].song_title = condstr(
									
									// Condition
									(songs[nn].filename = "" || songs[nn].filename = "-player") && 
									(songs[nn].midiname = "" || !isplayer), 
									
									// String
									condstr(
										
										// Condition
										language != 1, 
										
										// String
										"Unsaved song", 
										
										// Alternative String
										"新文件"
										
									)
									
								) + 
								condstr(
								
									// Condition
									songs[nn].filename != "-player", 
									
									// String
									filename_name(songs[nn].filename)
									
								) + 
								condstr(
								
									// Condition
									(songs[nn].filename = "" || songs[nn].filename = "-player") && 
									songs[nn].midiname != "" && 
									isplayer, 
									
									// String
									songs[nn].midiname
									
								)
	}
}