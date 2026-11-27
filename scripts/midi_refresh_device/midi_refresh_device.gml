function midi_refresh_device(){
	midi_devices = midi_input_devices()
	for (var a = 0; a < midi_devices; a += 1) midi_device_names[a] = midi_input_device_name(a)
	if (midi_devices_old != midi_devices) midi_set_device(0)
	midi_devices_old = midi_devices
}