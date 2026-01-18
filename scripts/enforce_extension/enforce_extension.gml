function enforce_extension(path, ext){
	if (string_lower(filename_ext(path)) != ext) path += ext
	return path
}