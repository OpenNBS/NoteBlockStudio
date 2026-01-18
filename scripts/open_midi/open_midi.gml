function open_midi() {
	// open_midi(filename)
	// http://faydoc.tripod.com / formats / mid.htm
	// http://dogsbodynet.com / fileformats / midi.html
	var fn, r, t, p, x1, y1;
	var trackend, delta, event, eventtype, channel, lasteventtype, lastchannel, newsong, replace;
	fn = argument[0]
	replace = isplayer
	if (argument_count > 1) {
		replace = argument[1]
	}
	//if (confirm() < 0) return 0
	if (fn = "") {
		if (language != 1) fn = string(get_open_filename_ext("MIDI Sequences (*.mid)|*.midi;*.mid", "", "", "Import from MIDI"))
		else fn = string(get_open_filename_ext("MIDI Sequences (*.mid)|*.midi;*.mid", "", "", "从 MIDI 导入"))
	}
	if (fn = "" || !file_exists_lib(fn)) return 0
	reset_add()
	buffer = buffer_import(fn)

	r = buffer_read_string_byte(4)
	if (r != "MThd") {
	    if (!question("Error loading MIDI file:\n\nFirst 4 bytes must be MThd.\n\nContinue anyway?", "Error")) {
	        reset_midi() buffer_delete(buffer) return 0
	    }
	}

	r = buffer_read_int_be()
	if (r!=$6) {message("Error loading MIDI file:\n\nHeader size must be 00 00 00 06", "Error") reset_midi() buffer_delete(buffer) return 0}

	r = buffer_read_short_be()
	if (r != 0 && r != 1 && r != 2) {message("Error loading MIDI file:\n\nFormat not supported.", "Error") reset_midi() buffer_delete(buffer) return 0}
	for (var a = 0; a < 2000; a += 1) {try{songs[song].text_exists_song[a] = text_exists[a]}catch(ee){}; try{songs[song].text_str_song[a] = text_str[a]}catch(ee){}}
	if (replace) close_song(0, 1)
	newsong = create(obj_song)
	array_push(songs, newsong)
	song = array_length(songs) - 1
	for (var a = 0; a < 2000; a += 1) {try{text_exists[a] = songs[song].text_exists_song[a]}catch(ee){}; try{text_str[a] = songs[song].text_str_song[a]}catch(ee){}}

	midi_tracks = buffer_read_short_be()
	newsong.midifile = filename_name(fn)
	newsong.midiname = filename_name(fn)
	midi_trackamount[midi_tracks] = 0
	reset_midi()
	midi_tempo = buffer_read_short_be()
	window = -1
	// screen_redraw()
	for (t = 0; t < midi_tracks; t += 1) {
	    // draw_loading("Loading MIDI", "", file_bin_position(f) / totalsize)
	    r = buffer_read_string_byte(4) 
	    if (r != "MTrk") {message("Error loading MIDI file:\n\nTrack chunk must begin with MTrk.", "Error") reset_midi() buffer_delete(buffer) return 0}
	    r = buffer_read_int_be()
	    trackend = buffer_tell(buffer) + r
	    p = 0
	    while(buffer_tell(buffer) < trackend) { // Loop through track
	        // Delta time
	        delta = buffer_read_varlen()
	        p += delta
	        // Event type and channel
	        event = buffer_read_byte() 
	        if (event = $FF) { // Meta event
	            meta = buffer_read_byte()
	            switch (meta) {
	                case $0: { // Sequence number (crap)
	                    repeat (buffer_read_varlen()) buffer_read_byte()
	                    break
	                }
	                case $1: { // Text event (crap)
	                    r = buffer_read_varlen()
	                    buffer_read_string_byte(r)
	                    break
	                }
	                case $2: { // Copyright
	                    r = buffer_read_varlen()
	                    midi_copyright = buffer_read_string_byte(r)
	                    break
	                }
	                case $3: { // Track name
	                    r = buffer_read_varlen()
	                    midi_trackname[t] = buffer_read_string_byte(r)
	                    break
	                }
	                case $4: { // Instrument name (crap)
	                    r = buffer_read_varlen()
	                    buffer_read_string_byte(r)
	                    break
	                }
	                case $5: { // Lyrics (crap)
	                    r = buffer_read_varlen()
	                    buffer_read_string_byte(r)
	                    break
	                }
	                case $6: { // Marker (crap)
	                    r = buffer_read_varlen()
	                    buffer_read_string_byte(r)
	                    break
	                }
	                case $7: { // Cuepoint (crap)
	                    r = buffer_read_varlen()
	                    buffer_read_string_byte(r)
	                    break
	                }
	                case $20: { // MIDI Channel prefix (crap)
	                    repeat (buffer_read_varlen()) buffer_read_byte()
	                    break
	                }
	                case $2F: { // End of track (crap)
	                    repeat (buffer_read_varlen()) buffer_read_byte()
	                    break
	                }
	                case $51: { // Tempo
	                    buffer_read_byte()
	                    var v1, v2, v3;
	                    v1 = buffer_read_byte()
	                    v2 = buffer_read_byte()
	                    v3 = buffer_read_byte()
						midi_tempo_changer_x[midi_tempo_changers] = p
						midi_tempo_changer_tempo[midi_tempo_changers] = 60000000 / (v1 * 256 * 256 + v2 * 256 + v3)
						midi_tempo_changers++
	                    if (midi_micsecqn = 0) midi_micsecqn = v1 * 256 * 256 + v2 * 256 + v3
	                    break
	                }
	                case $54: { // SMPTEOffset (crap)
	                    repeat (buffer_read_varlen()) buffer_read_byte()
	                    break
	                }
	                case $58: { // Time signature (crap)
	                    repeat (buffer_read_varlen()) buffer_read_byte()
	                    break
	                }
	                case $59: { // Key and scale (crap)
	                    repeat (buffer_read_varlen()) buffer_read_byte()
	                    break
	                }
	                case $7F: { // Sequencer Specific (crap)
	                    repeat (buffer_read_varlen()) buffer_read_byte()
	                    break
	                }
	                default: { // Unknown
	                    repeat (buffer_read_varlen()) buffer_read_byte()
	                    break
	                }
	            }
	        } else if (event = $F0) { // Exclusive event (crap)
	            repeat (buffer_read_varlen()) buffer_read_byte()
	        } else if (event = $F7) { // Exclusive event (crap)
	            repeat (buffer_read_varlen()) buffer_read_byte()
	        } else if (event = $F0) { // Exclusive event (crap)
	            repeat (buffer_read_varlen()) buffer_read_byte()
	        } else if (event != $F8 && event != $FA && event != $FB && event != $FC) { // MIDI EVENT
	            eventtype = (event & $F0)>>4
	            channel = event & $F
	            if (event & $80 != $80) {
	                eventtype = lasteventtype
	                channel = lastchannel
	                buffer_seek(buffer, 0, buffer_tell(buffer) - 1)
	            } else {
	                lasteventtype = eventtype
	                lastchannel = channel
	            }
	            switch (eventtype) {
	                case $8: { // Note off, (NOT) useless
	                    var note, vel
						note = buffer_read_byte()
						vel = buffer_read_byte()
						midi_set_until(channel, t, p, note, vel)
						break
	                }
	                case $9: { // Note on
	                    var note, vel;
	                    note = buffer_read_byte()
	                    vel = buffer_read_byte()
                    
	                    if (vel > 0)
	                        midi_add_note(channel, t, p, note, vel) //-21
						else
							midi_set_until(channel, t, p, note, vel)
	                    break
	                }
	                case $A: { // Note aftertouch (useless)
	                    repeat (2) buffer_read_byte()
	                    break
	                }
	                case $B: { // Controller (useless)
	                    repeat (2) buffer_read_byte()
	                    break
	                }
	                case $C: { // Program change
	                    midi_channelpatch[channel] = buffer_read_byte()
	                    break
	                }
	                case $D: { // Channel aftertouch (useless)
	                    buffer_read_byte()
	                    break
	                }
	                case $E: { // Pitch bend (useless)
	                    repeat (2) buffer_read_byte()
	                    break
	                }
	                default: { // Unknown
	                    message("Error loading MIDI file:\n\nUnknown MIDI event", "Error")
	                    reset_midi()
	                    buffer_delete(buffer)
	                    return 0
	                    break
	                }
	            }
	        }
	    }
	}
	/*var str;
	str = ""
	str += "Finished loading!" + chr(10)
	str += "Tracks: " + string(midi_tracks) + chr(10)
	for (a = 0 a < midi_tracks a += 1) str += (a < 9) * "0" + string(a + 1) + ". " + midi_trackname[a] + chr(10) + "    a:" + string(midi_trackamount[a]) + chr(10)
	str += midi_copyright
	show_debug_message(str)*/

	buffer_delete(buffer)
	window = w_midi
	sb_val[midi_sb1] = 0
	sb_val[midi_sb2] = 0
	sb_val[midi_sb3] = 0
	for (a = 0; a < 16; a += 1) { // Load channel settings from database
		try {
			midi_channelins[a] = midi_ins[midi_channelpatch[a], 1]
			midi_channeloctave[a] = midi_ins[midi_channelpatch[a], 2]
		}
		catch(e) {
			midi_channelins[a] = -1
			midi_channeloctave[a] = 0
		}
	}
	for (a = 0; a < midi_percamount; a += 1) { // Load percussion settings from database
		try {
		    midi_percins[a] = midi_drum[midi_percnote[a], 1]
		    midi_percpitch[a] = midi_drum[midi_percnote[a], 2] + 33
		}
		catch(e) {
			midi_percins[a] = -1
			midi_percpitch[a] = 33
		}
	}
	/* // CODE FOR TESTING INSTRUMENTS
	midi_channels = 127
	for (a = 0 a < 128 a += 1) {
	    midi_channelpatch[a] = a
	    midi_channelins[a] = 0
	    midi_channeloctave[a] = 0
	}

	midi_percamount = 0
	for (a = 24 a < 88 a += 1) {
	    midi_percnote[a - 24] = a
	    midi_percins[a - 24] = midi_drum[a, 1]
	    midi_percpitch[a - 24] = midi_drum[a, 2]
	}
	midi_percamount = a - 24*/
	midi_songlength = (midi_micsecqn * ((midi_maxpos - midi_minpos * w_midi_removesilent) / (midi_tempo & $7FFF))) / 1000000
	return 1



}
