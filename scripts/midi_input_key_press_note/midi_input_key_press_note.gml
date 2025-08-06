function midi_input_key_press_note(argument0, argument1) {
	//  midi_input_key_press_note(device, key)
	//      device      Number of the device
	//      key         Number of the key press

	//  Returns the note of a key press from a connected MIDI input device.
	//  Note numbers:
	//      http://www.midimountain.com/midi/midi_note_numbers.html
	//  Visual chart:
	//      http://www.midisolutions.com/Figure35.jpg

	//  By David "Davve" Norgren for MIDI input - www.stuffbydavid.com

	if (os_type = os_windows) return external_call(lib_midi_input_key_press_note, argument0, argument1);
	else return midi_keypresses[| argument1][0]



}
