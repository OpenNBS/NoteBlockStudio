function refresh_resourcepacks(){
	resourcepacks = []
	array_push(resourcepacks, new_resourcepack(0, "Vanilla"))
	pack_to_push = file_find_first(resource_directory + "*", fa_directory)
	var pack_ext = 0
	while (pack_to_push != "") {
		if (pack_to_push = "please_put_your_note_block_sound_resource_packs_here.txt") {
			pack_to_push = file_find_next()
			continue
		}
		if (filename_ext(pack_to_push) = ".zip") pack_ext = 1
		else if (filename_ext(pack_to_push) = "") pack_ext = 2
		else if (directory_exists(resource_directory + pack_to_push)) pack_ext = 2
	    if (pack_ext != 0) array_push(resourcepacks, new_resourcepack(pack_ext, pack_to_push))
		log("Pushing resource pack " + pack_to_push)
	    pack_to_push = file_find_next()
	}
	file_find_close()
}