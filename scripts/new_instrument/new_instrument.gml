/// @description  new_instrument(name, filename, user, [press, key])
/// @function  new_instrument
/// @param name
/// @param  filename
/// @param  user
/// @param  [press
/// @param  key]
function new_instrument() {

	var ins = create(obj_instrument);

	ins.name = argument[0]
	ins.filename = argument[1]
	ins.user = argument[2]
	if (argument_count > 3)
	    ins.press = argument[3]
	else
	    ins.press = false
	if (argument_count > 4)
	    ins.key = argument[4]
	else
	    ins.key = 45

	if (ins.user)
	    songs[song].user_instruments++

	ins.loaded = false
	ins.num_blocks = 0
	ins.sound_buffer = -1
	ins.sound = -1

	return ins



}
