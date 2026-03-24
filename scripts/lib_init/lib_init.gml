function lib_init() {
	// lib_init()

	var path_window;


	log("Init libraries")

	path_window = bundled_data_directory + "window.dll"

	globalvar lib_open_url, lib_execute, lib_gzunzip, lib_gzzip, lib_program_path;
	globalvar lib_file_rename, lib_file_copy, lib_file_delete, lib_file_exists;
	globalvar lib_directory_create, lib_directory_delete, lib_directory_exists;
	globalvar lib_audio_init, lib_audio_file_decode, lib_audio_file_add, lib_audio_sound_add, lib_audio_start, lib_audio_combine;
	globalvar lib_window_maximize, lib_window_minimize, lib_window_setnormal, lib_window_set_focus, lib_message_yesnocancel, lib_window_set_darkmode, lib_window_unset_darkmode;
	globalvar lib_midi_input_devices, lib_midi_input_device_name;
	globalvar lib_midi_input_key_presses, lib_midi_input_key_press_note, lib_midi_input_key_press_velocity, lib_midi_input_key_press_time;
	globalvar lib_midi_input_key_releases, lib_midi_input_key_release_note, lib_midi_input_key_release_time;
	globalvar lib_midi_input_instrument, lib_midi_input_pitch_wheel, lib_midi_input_control;

	log("Window", path_window)

	lib_window_maximize = external_define(path_window, "window_maximize", dll_cdecl, ty_real, 1, ty_string)
	lib_window_minimize = external_define(path_window, "window_minimize", dll_cdecl, ty_real, 1, ty_string)
	lib_window_setnormal = external_define(path_window, "window_setnormal", dll_cdecl, ty_real, 1, ty_string)
	lib_window_set_focus = external_define(path_window, "window_set_focus", dll_cdecl, ty_real, 1, ty_string)
	lib_message_yesnocancel = external_define(path_window, "message_yesnocancel", dll_cdecl, ty_real, 2, ty_string, ty_string)
	lib_window_set_darkmode = external_define(path_window, "window_set_darkmode", dll_cdecl, ty_real, 1, ty_string)
	lib_window_unset_darkmode = external_define(path_window, "window_unset_darkmode", dll_cdecl, ty_real, 1, ty_string)

	log("Libraries loaded")


}
