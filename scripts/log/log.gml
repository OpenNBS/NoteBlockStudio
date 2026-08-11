/// log(string [, values...])
/// @desc Prints values to the log file
/// @arg string
/// @arg values...
function log() {

	var cap, timestr, valstr;
	cap = string(argument[0])
	valstr = ""

	// Time
	timestr = date_time_string(date_current_datetime()) + " "

	// Values
	if (argument_count > 1)
	{
	    valstr = ": "
	    for (var a = 1; a < argument_count; a++)
		{
	        valstr += string(argument[a])
	        if (a < argument_count - 1)
	            valstr += ", "
	    }
	}
    
	var line = timestr + cap + valstr
	show_debug_message(line)
	array_push(obj_controller.log_strs, line)

	if (obj_controller.log_startup_buffering) {
		array_push(obj_controller.log_startup_lines, line)
		return 1
	}

	// Write to file. Logging must not crash the app when the disk is full.
	var f = -1
	try {
		f = file_text_open_append(log_file)
		if (f < 0) return 0
		file_text_write_string(f, line)
		file_text_writeln(f)
		file_text_close(f)
		return 1
	} catch (e) {
		show_debug_message("Failed to write log file: " + string(e))
		if (f >= 0) {
			try {
				file_text_close(f)
			} catch (close_error) {}
		}
		return 0
	}
}

function log_flush() {
	if (!obj_controller.log_startup_buffering) return 1

	var lines = obj_controller.log_startup_lines
	obj_controller.log_startup_lines = []
	obj_controller.log_startup_buffering = false
	if (array_length(lines) == 0) return 1

	var f = -1
	try {
		f = file_text_open_append(log_file)
		if (f < 0) return 0
		for (var i = 0; i < array_length(lines); i++) {
			file_text_write_string(f, lines[i])
			file_text_writeln(f)
		}
		file_text_close(f)
		return 1
	} catch (e) {
		show_debug_message("Failed to flush log file: " + string(e))
		if (f >= 0) {
			try {
				file_text_close(f)
			} catch (close_error) {}
		}
		return 0
	}
}
