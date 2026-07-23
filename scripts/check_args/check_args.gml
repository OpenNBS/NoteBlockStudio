function check_args(arg_type = "", do_return_value = false){
	var p_num = parameter_count()
	if (arg_type != "") {
		for (var i = 0; i <= p_num; i += 1) {
			if (parameter_string(i) = arg_type) {
				if (!do_return_value) return 1
				else if (i = p_num) return -1
				else if (string_char_at(parameter_string(i + 1), 0) = "-") return -1
				else return parameter_string(i + 1)
			}
		}
	} else {
		for (var i = 1; i < p_num; i += 1) {
			if (string_char_at(parameter_string(i), 0) != "-" && (i = 0 || check_boolean_arg(parameter_string(i - 1)))) return parameter_string(i)
		}
	}
	if (do_return_value) return -1
	return 0
}

function is_song_path_arg(arg) {
	if (!is_string(arg)) return false
	var file_ext = string_lower(filename_ext(arg))
	return file_ext == ".mid" || file_ext == ".midi" || file_ext == ".schematic" || file_ext == ".nbs" || file_ext == ".zip"
}

function find_song_path_arg() {
	var p_num = parameter_count()
	for (var i = 0; i <= p_num; i += 1) {
		var arg = parameter_string(i)
		if (is_song_path_arg(arg)) return arg
	}
	return ""
}

function check_boolean_arg(arg_type) {
	var boolean_args = ["--player", "-p"]
	if (string_char_at(arg_type, 0) != "-") return 1
	for (var i = 0; i < array_length(boolean_args); i++) {
		if (arg_type = boolean_args[i]) return 1
	}
	return 0
}
