function warn_working_directory_path(path) {
	if (path == "" || working_directory == "") return

	var selected_path = string_replace_all(path, "\\", "/")
	var working_path = string_replace_all(working_directory, "\\", "/")
	if (string_char_at(working_path, string_length(working_path)) != "/") working_path += "/"

	if (os_type == os_windows) {
		selected_path = string_lower(selected_path)
		working_path = string_lower(working_path)
	}

	if (string_copy(selected_path, 1, string_length(working_path)) != working_path) return

	message(
		condstr(
			language != 1,
			"GameMaker redirects all file access in Note Block Studio's program folder to its user-data folder. The selected file will therefore be loaded from or saved to this folder instead:\n\n" + game_save_id + "\n\nTo access the file you intended, choose a location outside Note Block Studio's program folder.",
			"GameMaker 会将 Note Block Studio 程序目录中的所有文件访问重定向到其用户数据目录。因此，所选文件实际上会从以下目录读取或保存到以下目录：\n\n" + game_save_id + "\n\n如需访问预期的文件，请选择 Note Block Studio 程序目录之外的位置。"
		),
		condstr(language != 1, "Program folder redirected", "程序目录已重定向")
	)
}
