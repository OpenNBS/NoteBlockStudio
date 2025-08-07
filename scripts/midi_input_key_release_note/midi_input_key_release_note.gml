function midi_input_key_release_note(argument0, argument1) {
	//  midi_input_key_release_note(device, key)
	//      device      Number of the device
	//      key         Number of the key release

	//  Returns the note of a key release from a connected MIDI input device.
	//  Note numbers:
	//      http://www.midimountain.com/midi/midi_note_numbers.html
	//  Visual chart:
	//      http://www.midisolutions.com/Figure35.jpg

	//  By David "Davve" Norgren for MIDI input - www.stuffbydavid.com

	return midi_keyreleases[| argument1]



}
