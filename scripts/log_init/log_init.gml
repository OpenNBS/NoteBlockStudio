/// log_init()
function log_init() {

	// Write header
	var f = file_text_open_write(log_file);
	if (f < 0)
	{
	    message("Could not access file directory. Try running in administrator mode or re-install.", "Note Block Studio")
	    return false
	}

	file_text_write_string(f, "__ Note Block Studio log __");
	file_text_writeln(f)
	file_text_close(f)
	log_strs = ["__ Note Block Studio log __"]

	// System info
	log("version", version)
	log("version_date", version_date)
	log("gm_runtime_version", gm_runtime_version)
	log("YYC", code_is_compiled())
	log("working_directory", current_directory)
	log("file_directory", file_directory)
	log("OS", get_os_type_string())
	log("os_version", os_version)
	log("os_is_network_connected", os_is_network_connected())
	log("os_get_language", os_get_language())
	log("os_get_region", os_get_region())

	// Environment variable names differ between desktop platforms. Only log
	// variables that are present so unsupported Windows keys do not produce a
	// block of empty values on macOS and Linux.
	var _environment_variables = []
	switch (os_type) {
		case os_windows:
			_environment_variables = [
				"USERDOMAIN",
				"USERNAME",
				"USERPROFILE",
				"APPDATA",
				"NUMBER_OF_PROCESSORS",
				"PROCESSOR_ARCHITECTURE",
				"PROCESSOR_IDENTIFIER",
				"PROCESSOR_LEVEL",
				"PROCESSOR_REVISION"
			]
			break

		case os_macosx:
			_environment_variables = ["USER", "HOME", "TMPDIR", "SHELL"]
			break

		case os_linux:
			_environment_variables = [
				"USER",
				"HOME",
				"SHELL",
				"XDG_CONFIG_HOME",
				"XDG_DATA_HOME",
				"XDG_SESSION_TYPE",
				"XDG_CURRENT_DESKTOP"
			]
			break
	}

	for (var i = 0; i < array_length(_environment_variables); i++) {
		var _name = _environment_variables[i]
		var _value = environment_get_variable(_name)
		if (_value != "") log(_name, _value)
	}

	// os_get_info supplies useful cross-platform details that are not exposed
	// through environment variables on macOS and Linux.
	var _system_info = os_get_info()
	if (_system_info != -1) {
		var _system_info_keys = ["is64bit"]

		if (os_type == os_windows) {
			array_push(_system_info_keys, "video_adapter_description")
			array_push(_system_info_keys, "video_adapter_vendorid")
			array_push(_system_info_keys, "video_adapter_deviceid")
		} else if (os_type == os_macosx || os_type == os_linux) {
			array_push(_system_info_keys, "gl_vendor_string")
			array_push(_system_info_keys, "gl_renderer_string")
			array_push(_system_info_keys, "gl_version_string")
		}

		for (var i = 0; i < array_length(_system_info_keys); i++) {
			var _key = _system_info_keys[i]
			if (ds_map_exists(_system_info, _key)) {
				var _value = _system_info[? _key]
				if (string(_value) != "") log(_key, _value)
			}
		}

		ds_map_destroy(_system_info)
	}

}
