function datapack_getinstextures() {
	//datapack_getinstextures()
	//allows the user to save the resource pack containing note block textures corresponding to the default instruments.

	var fn, src
	if (language != 1) fn = string(get_save_filename_ext("Resource pack (*.zip)|*.zip", "Note Block Textures", "", "Replaces instrument blocks with note block textures."))
	else fn = string(get_save_filename_ext("Resource pack (*.zip)|*.zip", "音符盒纹理", "", "用自定义纹理替换音色方块"))
	if (fn = "") return 0
	fn = enforce_extension(fn, ".zip")

	src = data_directory + "instrumenttextures.zip"

	if file_exists(src) {
		file_copy(src, fn)
		if (language != 1) message("Resource pack saved successfully!", "Saved")
		else message("资源包保存成功！", "保存")
	}
	else {
		if (language != 1) message("File not found!","Error")
		else message("找不到文件！","错误")
	}


}
