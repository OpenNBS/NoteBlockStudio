function register_url_protocol() {

	// We don't want to register the debug executable as a handler
	if (!NOT_RUN_FROM_IDE) return;

	// Get NBS executable filename (first command line argument)
	var nbs_executable = string_replace_all(parameter_string(0), "/", "\\");
	
	// Register URL protocol
	// see: https://stackoverflow.com/a/38205984/9045426
	
	var cmd1 = ["reg", "add \"HKCU\\SOFTWARE\\Classes\\nbs\" /v \"URL Protocol\" /f"];
	var cmd2 = ["reg", "add \"HKCU\\SOFTWARE\\Classes\\nbs\\shell\\open\\command\" /ve /t REG_SZ /d \"\\\"" + nbs_executable + "\\\" \\\"--protocol-launcher\\\" \\\"%1\\\"\" /f"];

	// To save the headache of parsing this:
	//
	// cmd1 creates a string key with value "URL Protocol" in the \nbs key root.
	//
	// cmd2 creates a string key (/t REG_SZ) at the default location (/ve) whose value is the command
	// to run when the nbs:// URL protocol is launched (NBS executable path + one argument given with %1),
	// forcefully overwriting the key if it exists without asking (/f).
	//
	// Triple-escaped quotes make this look much worse than necessary.
	// The command to run is "<nbs_path>" "%1" - we must encase each argument within quotes to avoid %20
	// being expanded into spaces. Then, the whole command must be encased within quotes so it's parsed as
	// a single argument by the reg utility, so inner quotes are escaped (\"). Then we must escape all quotes
	// for the GameMaker string, so inner quotes become \\\" (double-backslash to enter a literal backslash,
	// then a quote escaped with a third backslash).
	//
	// We write to HKCU instead of HKCR since it doesn't require admin privileges!
	// see: https://stackoverflow.com/a/53181/9045426

	log("Registering executable as nbs:// protocol handler")

	execute_program(cmd1[0], cmd1[1], true);
	execute_program(cmd2[0], cmd2[1], true);
}