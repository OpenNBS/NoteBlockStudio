function midi_set_until(argument0, argument1, argument2, argument3, argument4) {
	// midi_add(channel, track, position, note)
	var channel, track, pos, note, n, a, exist, vel;
	channel = argument0
	track = argument1
	pos = argument2
	note = argument3
	vel = argument4

	n = midi_trackamount[track]
	if (n = 31999) return 0
	if (channel = 9) return 0

	if (pos < midi_minpos || midi_minpos = -1) midi_minpos = pos
	midi_maxpos = max(midi_maxpos, pos)
	for (var i = array_length(midi_eventnote[track]) - 1; i >= 0; i--) {
		if (midi_eventnote[track, i] = note && midi_eventchannel[track, i] = channel) {
			if (midi_eventuntil[track, i] = -1) midi_eventuntil[track, i] = pos
			break
		}
	}



}
