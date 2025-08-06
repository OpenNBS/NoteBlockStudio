function lib_init() {
	// lib_init()

	var path_file, path_audio, path_window, path_midiinput;


	log("Init libraries")

	path_file = bundled_data_directory + "file.dll"
	path_audio = bundled_data_directory + "audio.dll"
	path_window = bundled_data_directory + "window.dll"
	path_midiinput = bundled_data_directory + "midiinput.dll"

	globalvar lib_open_url, lib_execute, lib_gzunzip, lib_gzzip, lib_program_path;
	globalvar lib_file_rename, lib_file_copy, lib_file_delete, lib_file_exists;
	globalvar lib_directory_create, lib_directory_delete, lib_directory_exists;
	globalvar lib_audio_init, lib_audio_file_decode, lib_audio_file_add, lib_audio_sound_add, lib_audio_start, lib_audio_combine;
	globalvar lib_window_maximize, lib_window_minimize, lib_window_setnormal, lib_window_set_focus, lib_message_yesnocancel, lib_window_set_darkmode, lib_window_unset_darkmode;
	globalvar lib_midi_input_devices, lib_midi_input_device_name;
	globalvar lib_midi_input_key_presses, lib_midi_input_key_press_note, lib_midi_input_key_press_velocity, lib_midi_input_key_press_time;
	globalvar lib_midi_input_key_releases, lib_midi_input_key_release_note, lib_midi_input_key_release_time;
	globalvar lib_midi_input_instrument, lib_midi_input_pitch_wheel, lib_midi_input_control;

	log("File", path_file)

	//lib_open_url = external_define(path_file, "open_url", dll_cdecl, ty_real, 1, ty_string)
	//lib_execute = external_define(path_file, "execute", dll_cdecl, ty_real, 3, ty_string, ty_string, ty_real)
	lib_gzunzip = external_define(path_file, "gzunzip", dll_cdecl, ty_real, 2, ty_string, ty_string)
	lib_gzzip = external_define(path_file, "gzzip", dll_cdecl, ty_real, 2, ty_string, ty_string)
	//lib_program_path = external_define(path_file, "program_path", dll_cdecl, ty_string, 0)
	lib_file_rename = external_define(path_file, "file_rename", dll_cdecl, ty_real, 2, ty_string, ty_string)
	lib_file_copy = external_define(path_file, "file_copy", dll_cdecl, ty_real, 2, ty_string, ty_string)
	lib_file_delete = external_define(path_file, "file_delete", dll_cdecl, ty_real, 1, ty_string)
	lib_file_exists = external_define(path_file, "file_exists", dll_cdecl, ty_real, 1, ty_string)
	lib_directory_create = external_define(path_file, "directory_create", dll_cdecl, ty_real, 1, ty_string)
	lib_directory_delete = external_define(path_file, "directory_delete", dll_cdecl, ty_real, 1, ty_string)
	lib_directory_exists = external_define(path_file, "directory_exists", dll_cdecl, ty_real, 1, ty_string)

	log("Audio", path_file)

	log("audio_init")			lib_audio_init = external_define(path_audio, "audio_init", dll_cdecl, ty_real, 0)
	log("audio_file_decode")	lib_audio_file_decode = external_define(path_audio, "audio_file_decode", dll_cdecl, ty_real, 2, ty_string, ty_string)
	log("audio_start")			lib_audio_start = external_define(path_audio, "audio_start", dll_cdecl, ty_real, 1, ty_string)
	log("audio_file_add")		lib_audio_file_add = external_define(path_audio, "audio_file_add", dll_cdecl, ty_real, 1, ty_string)
	log("audio_sound_add")		lib_audio_sound_add = external_define(path_audio, "audio_sound_add", dll_cdecl, ty_real, 4, ty_real, ty_real, ty_real, ty_real)
	log("audio_combine")		lib_audio_combine = external_define(path_audio, "audio_combine", dll_cdecl, ty_real, 0)

	log("Init audio")
	external_call(lib_audio_init)

	log("Window", path_window)

	lib_window_maximize = external_define(path_window, "window_maximize", dll_cdecl, ty_real, 1, ty_string)
	lib_window_minimize = external_define(path_window, "window_minimize", dll_cdecl, ty_real, 1, ty_string)
	lib_window_setnormal = external_define(path_window, "window_setnormal", dll_cdecl, ty_real, 1, ty_string)
	lib_window_set_focus = external_define(path_window, "window_set_focus", dll_cdecl, ty_real, 1, ty_string)
	lib_message_yesnocancel = external_define(path_window, "message_yesnocancel", dll_cdecl, ty_real, 2, ty_string, ty_string)
	lib_window_set_darkmode = external_define(path_window, "window_set_darkmode", dll_cdecl, ty_real, 1, ty_string)
	lib_window_unset_darkmode = external_define(path_window, "window_unset_darkmode", dll_cdecl, ty_real, 1, ty_string)

	log("Midi input", path_midiinput)

	lib_midi_input_devices = external_define(path_midiinput, "MidiInputDevices", dll_cdecl, ty_real, 0)
	lib_midi_input_device_name = external_define(path_midiinput, "MidiInputDeviceName", dll_cdecl, ty_string, 1, ty_real)
	lib_midi_input_key_presses = external_define(path_midiinput, "MidiInputKeyPresses", dll_cdecl, ty_real, 1, ty_real)
	lib_midi_input_key_press_note = external_define(path_midiinput, "MidiInputKeyPressNote", dll_cdecl, ty_real, 2, ty_real, ty_real)
	lib_midi_input_key_press_velocity = external_define(path_midiinput, "MidiInputKeyPressVelocity", dll_cdecl, ty_real, 2, ty_real, ty_real)
	lib_midi_input_key_press_time = external_define(path_midiinput, "MidiInputKeyPressTime", dll_cdecl, ty_real, 2, ty_real, ty_real)
	lib_midi_input_key_releases = external_define(path_midiinput, "MidiInputKeyReleases", dll_cdecl, ty_real, 1, ty_real)
	lib_midi_input_key_release_note = external_define(path_midiinput, "MidiInputKeyReleaseNote", dll_cdecl, ty_real, 2, ty_real, ty_real)
	lib_midi_input_key_release_time = external_define(path_midiinput, "MidiInputKeyReleaseTime", dll_cdecl, ty_real, 2, ty_real, ty_real)
	lib_midi_input_instrument = external_define(path_midiinput, "MidiInputInstrument", dll_cdecl, ty_real, 1, ty_real)
	lib_midi_input_pitch_wheel = external_define(path_midiinput, "MidiInputPitchWheel", dll_cdecl, ty_real, 1, ty_real)
	lib_midi_input_control = external_define(path_midiinput, "MidiInputControl", dll_cdecl, ty_real, 2, ty_real, ty_real)

	log("Libraries loaded")


}
