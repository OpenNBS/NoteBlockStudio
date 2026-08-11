/// @description  control_end()
/// @function  control_end
function control_end() {
	
	if (!destroy_self) {
		if (!isplayer) backup_delete_own_tab()
		for (var i = array_length(songs) - 1; i >= 0; i--) {
			set_song(i)
			confirm(1)
			if (!isplayer) backup_delete_own_tab()
			close_song(i, 1, 1)
		}
	
		save_settings()
	}
	font_src_dynamic_shutdown()
	rtmidi_deinit()
	log_flush()
	if (variable_instance_exists(id, "python_initialized") && python_initialized) {
		_python_finalize()
		python_initialized = false
	}

}
