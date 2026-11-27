function nbt_string_write(argument0, argument1) {
	// nbt_string_write(file, string)
	//  file        GMBinaryFile file handle
	//  string      String to write

	// Writes a string to the file.
	// Used when saving schematic files, which are in the NBT (Named Binary Tag) format by Notch.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	var file, str;
	file = argument0;
	str = argument1;

	var p;
	buffer_write_short_be_ext(file, string_length(str));
	for (p = 0; p < string_length(str); p += 1) buffer_write(file, buffer_s8, ord(string_char_at(str, p + 1)))


}
