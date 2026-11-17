function dat_writefile(argument0, argument1) {
	// dat_writefile(str, path)
	// writes file to path

	var str, path, file

	str = argument0
	path = argument1

	// Text is UTF-8: byte length can exceed string_length for song descriptions.
	file = buffer_create(0, buffer_grow, 1)
	var succeeded = false
	try {
		buffer_write(file, buffer_text, str)
		succeeded = buffer_export(file, path)
	} catch (e) {
		buffer_delete(file)
		throw e
	}
	buffer_delete(file)
	if (!succeeded) throw "Could not write data pack file: " + path
	return true


}
