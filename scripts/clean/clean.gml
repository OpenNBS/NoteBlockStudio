function clean(argument0) {
	// clean(str)
	var str;
	str = argument0
	// Empty menu entries are collapsed by the menu parser and shift item indices.
	if (str = "") str = "[empty]"
	str = string_replace_all(str, "|", "l")
	str = string_replace_all(str, "^!", "!")
	str = string_replace_all(str, "~", " - ")
	str = string_replace_all(str, "$", "S")
	return str



}
