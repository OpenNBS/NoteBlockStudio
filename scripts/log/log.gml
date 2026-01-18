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
    
	// Debug message
	show_debug_message(timestr + cap + valstr)
	array_push(obj_controller.log_strs, timestr + cap + valstr)
    
	// Write to file
	var f = file_text_open_append(log_file);
	if (f < 0)
	    return 0
	file_text_write_string(f, timestr + cap + valstr)
	file_text_writeln(f)
	file_text_close(f)

	return 1




}
