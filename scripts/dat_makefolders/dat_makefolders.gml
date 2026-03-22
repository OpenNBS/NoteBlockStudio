function dat_makefolders(path, namespace, function_registry) {
	//dat_makefolders(path, namespace)
	//create folder structure prior to creating the datapack files
	//returns: functiondir

	var i

	var folders = []
	var foldercount = 0
	var str = ""
	if path != "" {
		for (i = 1; i <= string_length(path); i++) {			
			var char = string_char_at(path, i)
			if (char = "/") {
				folders[foldercount] = str
				foldercount++
				str = ""
			} else {
				str += char
				folders[foldercount] = str
			}
		}
	}

	var tempdir = game_save_id + "TempDatapack\\"
	if (directory_exists_lib(tempdir)) directory_delete_lib(tempdir)

	directory_create_lib(tempdir)
	directory_create_lib(tempdir + "data\\")
	directory_create_lib(tempdir + "data\\minecraft\\")
	directory_create_lib(tempdir + "data\\minecraft\\tags\\")
	directory_create_lib(tempdir + "data\\minecraft\\tags\\" + function_registry + "\\")
	directory_create_lib(tempdir + "data\\" + namespace +"\\")

	var functiondir = tempdir + "data\\" + namespace + "\\" + function_registry + "\\"
	directory_create_lib(functiondir)

	// Dinamically create function folder
	if (array_length_1d(folders) > 0) {
		for (i = 0; i <= foldercount; i++) {
			functiondir += folders[i] + "\\"
			directory_create_lib(functiondir)
		}
	}
	directory_create_lib(functiondir + "notes")
	directory_create_lib(functiondir + "tree")

	return functiondir


}
