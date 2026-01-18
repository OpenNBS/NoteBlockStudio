function midi_add_note(argument0, argument1, argument2, argument3, argument4) {
	// midi_add(channel, track, position, note)
	var channel, track, pos, note, n, a, exist, vel;
	channel = argument0
	track = argument1
	pos = argument2
	note = argument3
	vel = argument4

	n = midi_trackamount[track]
	if (n = 31999) return 0

	if (pos < midi_minpos || midi_minpos = -1) midi_minpos = pos
	midi_maxpos = max(midi_maxpos, pos)
	midi_eventx[track, n] = pos
	midi_eventnote[track, n] = note
	midi_eventvel[track, n ] = vel
	midi_eventchannel[track, n] = channel
	midi_eventuntil[track, n] = -1
	midi_trackamount[track] += 1
	midi_tracklength[track] = max(midi_tracklength[track], pos)
	midi_channels = max(midi_channels, channel)
	if (channel = 9) {
	    exist = 0
	    for (a = 0; a < midi_percamount; a += 1) {
	        if (midi_percnote[a] = note) {
	            exist = 1
	            break
	        }
	    }
	    if (exist = 0) {
	        midi_percnote[midi_percamount] = note
	        midi_percins[midi_percamount] = 0
	        midi_percpitch[midi_percamount] = 0
	        midi_percamount += 1
	    }
	}



}
