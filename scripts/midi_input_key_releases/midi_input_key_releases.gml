function midi_input_key_releases(argument0) {
	//  midi_input_key_releases(device)
	//      device      Number of the device

	//  Returns the amount of key releases from a connected MIDI input since this function was last called.
	//  Use the other midi_input_key_release_* functions to get info about the key releases.

	//  By David "Davve" Norgren for MIDI input - www.stuffbydavid.com

	return ds_list_size(midi_keyreleases)



}
