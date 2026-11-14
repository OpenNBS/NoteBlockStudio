function nbt_tag_end(argument0) {
	// nbt_tag_end(file)
	//  file        GMBinaryFile file handle

	// Writes an end tag to the file.
	// Used when saving schematic files, which are in the NBT (Named Binary Tag) format by Notch.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	var file;
	file = argument0;

	buffer_write(file, buffer_s8, 0);


}
