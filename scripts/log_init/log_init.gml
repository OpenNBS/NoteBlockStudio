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
	log("OS", test(false, "Mac", "Windows"))
	log("os_version", os_version)
	log("os_is_network_connected", os_is_network_connected())
	log("os_get_language", os_get_language())
	log("os_get_region", os_get_region())
	log("USERDOMAIN", environment_get_variable("USERDOMAIN"))
	log("USERNAME", environment_get_variable("USERNAME"))
	log("USERPROFILE", environment_get_variable("USERPROFILE"))
	log("APPDATA", environment_get_variable("APPDATA"))
	log("NUMBER_OF_PROCESSORS", environment_get_variable("NUMBER_OF_PROCESSORS"))
	log("PROCESSOR_ARCHITECTURE", environment_get_variable("PROCESSOR_ARCHITECTURE"))
	log("PROCESSOR_IDENTFIER", environment_get_variable("PROCESSOR_IDENTFIER"))
	log("PROCESSOR_LEVEL", environment_get_variable("PROCESSOR_LEVEL"))
	log("PROCESSOR_REVISION", environment_get_variable("PROCESSOR_REVISION"))



}
