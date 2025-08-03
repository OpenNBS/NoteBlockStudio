function nbt_tag_short(argument0, argument1, argument2) {
	// nbt_tag_short(file, name, val)
	//  file        GMBinaryFile file handle
	//  name        Name of the tag
	//  val         Value to write

	// Writes a signed short integer tag to the file.
	// Used when saving schematic files, which are in the NBT (Named Binary Tag) format by Notch.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	var file, name, val;
	file = argument0;
	name = argument1;
	val = argument2;

	buffer_write(file, buffer_s8, 2);
	nbt_string_write(file, name);
	buffer_write_short_be_ext(file, val);


}
