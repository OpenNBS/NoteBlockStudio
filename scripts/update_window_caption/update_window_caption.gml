function update_window_caption(song){
	window_set_caption(condstr(
	
							// Condition
							(song.song_download_display_name != ""), 
							
							// String
							song.song_download_display_name, 
							
							// Alternative String
							condstr(
								
								// Condition
								(song.filename = "" || song.filename = "-player") && 
								(song.midiname = "" || !isplayer), 
								
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
								song.filename != "-player", 
								
								// String
								filename_name(song.filename)) + 
								condstr(
								
									// Condition
									(song.filename = "" || song.filename = "-player") && 
									song.midiname != "" && 
									isplayer, 
									
									// String
									song.midiname
									
								) + 
								condstr(
								
									// Condition
									song.changed && 
									song.filename != "" && 
									song.filename != "-player", 
									
									// String
									"*"
									
								)
								
							) + 
							condstr(
							
								// Condition
								os_type != os_macosx, 
								
								// String
								" - Note Block Studio" + 
								condstr(
								
									// Condition
									isplayer, 
									
									// String
									" - Player Mode"
									
								)
								
							)
							
						)
}