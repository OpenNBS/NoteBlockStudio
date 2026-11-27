function nbt_tag_compound(argument0, argument1) {
	// nbt_tag_compound(file, name)
	//  file        GMBinaryFile file handle
	//  name        Name of the tag

	// Writes the beginning of a compound tag.
	// Used when saving schematic files, which are in the NBT (Named Binary Tag) format by Notch.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	var file, name;
	file = argument0;
	name = argument1;

	buffer_write(file, buffer_s8, 10);
	nbt_string_write(file, name);


}
