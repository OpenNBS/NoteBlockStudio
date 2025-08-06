function midi_input_devices() {
	//  midi_input_devices()

	//  Returns the amount of connected devices.

	//  By David "Davve" Norgren for MIDI input - www.stuffbydavid.com

	if (os_type = os_windows) return external_call(lib_midi_input_devices)
	else return rtmidi_probe_ins()



}
