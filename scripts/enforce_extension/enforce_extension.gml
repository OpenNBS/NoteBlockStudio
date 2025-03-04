function enforce_extension(path, ext){
	if (filename_ext(path) != ext) path += ext
	return path
}