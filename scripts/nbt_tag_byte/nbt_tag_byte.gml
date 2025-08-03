function nbt_tag_byte(argument0, argument1, argument2) {
	// nbt_tag_byte(file, name, val)
	//  file        GMBinaryFile file handle
	//  name        Name of the tag
	//  val         Value to write

	// Writes a byte tag to the file.
	// Used when saving schematic files, which are in the NBT (Named Binary Tag) format by Notch.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	var file, name, val;
	file = argument0;
	name = argument1;
	val = argument2;

	buffer_write(file, buffer_s8, 1);
	nbt_string_write(file, name);
	buffer_write(file, buffer_s8, val);


}
