function midi_input_key_press_velocity(argument0, argument1) {
	//  midi_input_key_press_velocity(device, key)
	//      device      Number of the device
	//      key         Number of the key press

	//  Returns the velocity (volume) of a key press from a connected MIDI input device.
	//  Values are 1 - 100 and can be affected by how hard the key was hit (if the device supports it).

	//  By David "Davve" Norgren for MIDI input - www.stuffbydavid.com

	if (os_type = os_windows) return external_call(lib_midi_input_key_press_velocity, argument0, argument1);
	else return midi_keypresses[| argument1][1]



}
