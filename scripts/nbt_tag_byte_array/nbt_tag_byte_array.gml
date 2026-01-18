function nbt_tag_byte_array(argument0, argument1, argument2) {
	// nbt_tag_byte_array(file, name, len)
	//  file        GMBinaryFile file handle
	//  name        Name of the tag
	//  len         Size of array

	// Writes the beginning of a byte array tag to the file.
	// Used when saving schematic files, which are in the NBT (Named Binary Tag) format by Notch.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	var file, name, len;
	file = argument0;
	name = argument1;
	len = argument2;

	buffer_write(file, buffer_s8, 7);
	nbt_string_write(file, name);
	buffer_write_int_be_ext(file, len);


}
