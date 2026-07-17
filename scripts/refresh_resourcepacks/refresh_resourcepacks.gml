function refresh_resourcepacks(){
	resourcepacks = []
	array_push(resourcepacks, new_resourcepack(0, "Vanilla"))
	pack_to_push = file_find_first(resource_directory + "*", fa_directory)
	while (pack_to_push != "") {
		var pack_ext = 0
		var pack_path = resource_directory + pack_to_push
		if (directory_exists(pack_path)) {
			pack_ext = 2
		} else if (string_lower(filename_ext(pack_to_push)) == ".zip") {
			pack_ext = 1
		}
		if (pack_ext != 0) {
			array_push(resourcepacks, new_resourcepack(pack_ext, pack_to_push))
			log("Pushing resource pack " + pack_to_push)
		}
	    pack_to_push = file_find_next()
	}
	file_find_close()
}
