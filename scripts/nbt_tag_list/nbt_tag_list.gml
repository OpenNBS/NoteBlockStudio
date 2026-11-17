function nbt_tag_list(argument0, argument1, argument2, argument3) {
	// nbt_tag_list(file, name, type, len)
	//  file        GMBinaryFile file handle
	//  name        Name of the tag
	//  type        Type of the tags in the list
	//  len         Amount of entries in the list

	// Writes the beginning of a list tag to the file.
	// Used when saving schematic files, which are in the NBT (Named Binary Tag) format by Notch.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	var file, name, type, len;
	file = argument0;
	name = argument1;
	type = argument2;
	len = argument3;

	buffer_write(file, buffer_s8, 9);
	nbt_string_write(file, name);
	buffer_write(file, buffer_s8, type);
	buffer_write_int_be_ext(file, len);


}
