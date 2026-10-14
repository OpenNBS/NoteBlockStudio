function datapack_runtime_objective(pack_name, functionpath) {
	// Scoreboard objective names, including the _t/_s suffixes, must stay at or
	// below 16 characters. Include a compact hash of the full resource path so
	// two enabled exports with the same song name cannot drive the same scores.
	var identity = string_lower(functionpath + pack_name)
	var hash_value = 0
	for (var i = 1; i <= string_length(identity); i++) hash_value = (hash_value * 131 + ord(string_char_at(identity, i))) mod 1679616
	var digits = "0123456789abcdefghijklmnopqrstuvwxyz"
	var hash_text = ""
	for (var i = 0; i < 4; i++) {
		hash_text = string_char_at(digits, (hash_value mod 36) + 1) + hash_text
		hash_value = floor(hash_value / 36)
	}
	return "nbs_" + string_copy(string_lettersdigits(pack_name), 1, 5) + "_" + hash_text
}

function datapack_export() {
	// datapack_export()
	var fn, o
	o = obj_controller

	var title = condstr(language != 1, "Data Pack Export", "导出数据包")
	if (o.dat_usezip) {
		fn = string(get_save_filename_ext("ZIP archive (*.zip)|*.zip", dat_name + ".zip", "", title))
		if (fn == "") return false
		fn = enforce_extension(fn, ".zip")
	} else {
		// A folder picker grants access to the directory and its children.
		var folder_title = condstr(language != 1,
			"Choose where to create the data pack folder", "选择数据包文件夹的保存位置")
		var parent = string(os_type == os_macosx
			? macos_choose_directory(folder_title) : get_directory_alt(folder_title, ""))
		if (parent == "") return false
		var folder_name = filename_name(string_replace_all(dat_name, "\\", "/"))
		fn = parent + "/" + folder_name
		if (directory_exists_lib(fn) && !question(condstr(language != 1,
			"Replace matching files in this data pack folder? Other files will be kept.\n\n" + fn,
			"替换此数据包文件夹中的同名文件？其他文件将保留。\n\n" + fn), title)) return false
	}
	var tempdir = game_save_id + "tempdatapack/"
	var archive_path = game_save_id + "tempdatapack.zip"
	var functionpath = ""
	var export_succeeded = false
	var export_error = ""

	window = -1
	calculate_locked_layers()

	with (create(obj_dummy2)) {
	try {
		// Initialize variables
		var name = string_path(o.dat_name)
		var namespace = string_path(o.dat_namespace)
		var path = dat_getpath(o.dat_path)
		var objective
		var tag
		
		// https://minecraft.wiki/w/Pack_format
		var pack_format = (o.dat_mcversion == 0) ? 41 : 48
		// https://minecraft.wiki/w/Java_Edition_1.21#Command_format_2
		var function_registry = (o.dat_mcversion == 0) ? "functions" : "function";

		var sound_plan = minecraft_export_build_plan(
			"datapack", o.dat_source, o.dat_allowed_sources, o.dat_includelocked,
			o.dat_includeoutofrange, o.dat_enableradius, false, 10,
			o.dat_enablelooping, true
		)
		var playspeed = minecraft_export_snapped_speed(minecraft_export_tempo_at_tick(o.songs[o.song], 0, o.dat_includelocked))
		var rootfunction = "0_" + string(power(2, floor(log2(max(1, o.songs[o.song].enda)))+1)-1)
		var functiondir
		var inputString
		var add_teams = (o.dat_visualizer && o.dat_glow)
	
		if namespace = "" {
			path = ""
			namespace = name
			functionpath = namespace+":"
		} else if path = "" {
			path = name
			functionpath = namespace+":"+path+"/"
		} else {
			path += "/" + name
			functionpath = namespace+":"+path+"/"
		}
		objective = datapack_runtime_objective(o.dat_name, functionpath)
		tag = objective
	
		// Create folder structure
		if (directory_exists_lib(tempdir)) {
			directory_delete_lib(tempdir)
		}
		if (directory_exists_lib(tempdir)) throw "Could not clear the temporary data pack folder"
		functiondir = dat_makefolders(tempdir, path, namespace, function_registry)
	
		//pack.mcmeta
		inputString = json_stringify({pack: {pack_format: pack_format, description: o.dat_name + "\nMade with Note Block Studio"}})
		dat_writefile(inputString, tempdir + "pack.mcmeta")
	
		//Minecraft folder:
	
		//load.json
		inputString = "{\"values\": [\"" + functionpath + "load\"]}"
		dat_writefile(inputString, tempdir + "data/minecraft/tags/" + function_registry + "/load.json")
	
		//tick.json
		inputString = "{\"values\": [\"" + functionpath + "tick\"]}"
		dat_writefile(inputString, tempdir + "data/minecraft/tags/" + function_registry + "/tick.json")
	
		//Song folder:
	
		//load.mcfunction
		inputString = "scoreboard objectives add " + objective + " dummy" + br
		inputString += "scoreboard objectives add " + objective + "_t dummy" + br
		inputString += "scoreboard objectives add " + objective + "_s dummy"
		dat_writefile(inputString, functiondir + "load.mcfunction")
	
		//tick.mcfunction
		inputString = "execute as @a[tag=" + tag + "] run scoreboard players operation @s " + objective + " += @s " + objective + "_s" + br
		if(o.dat_enableradius) inputString += "execute as @a[tag=" + tag + "] run function " + functionpath + "tree/" + rootfunction
		else inputString += "execute as @a[tag=" + tag + "] at @s run function " + functionpath + "tree/" + rootfunction
		dat_writefile(inputString, functiondir + "tick.mcfunction")
	
		//play.mcfunction
		inputString = "tag @s add " + tag + br
		inputString += "scoreboard players add @s " + objective + " 0" + br
		inputString += "execute unless score @s " + objective + "_t matches -2147483648..2147483647 run scoreboard players set @s " + objective + "_t -1" + br
		inputString += "scoreboard players add @s " + objective + "_s 0" + br
		inputString += "execute if score @s " + objective + "_s matches ..0 run scoreboard players set @s " + objective + "_s " + string(playspeed) + br
		if (add_teams) {
			inputString += "function " + functionpath + "add_teams"
		}
		dat_writefile(inputString, functiondir + "play.mcfunction")
	
		//pause.mcfunction
		inputString = "tag @s remove " + tag
		dat_writefile(inputString, functiondir + "pause.mcfunction")
	
		//stop.mcfunction
		inputString = "tag @s remove " + tag + br
		inputString += "scoreboard players reset @s " + objective + br
		inputString += "scoreboard players reset @s " + objective + "_t" + br
		inputString += "scoreboard players reset @s " + objective + "_s"
		if (add_teams) {
			inputString += br + "function " + functionpath + "remove_teams"
		}
		dat_writefile(inputString, functiondir + "stop.mcfunction")

		//restart.mcfunction
		inputString = "function " + functionpath + "stop" + br
		inputString += "function " + functionpath + "play"
		dat_writefile(inputString, functiondir + "restart.mcfunction")
	
		//uninstall.mcfunction
		inputString = "tag @e remove " + tag + br
		inputString += "scoreboard objectives remove " + objective + br
		inputString += "scoreboard objectives remove " + objective + "_t" + br
		inputString += "scoreboard objectives remove " + objective + "_s" + br
		if (add_teams) {
			inputString += "kill @e[type=falling_block,tag=nbs]" + br
			inputString += "function " + functionpath + "remove_teams" + br
		}
		if (o.dat_usezip) {
			inputString += "datapack disable \"file/" + filename_name(fn) + "\"" + br
		} else {
			inputString += "datapack disable \"" + filename_name(fn) + "\"" + br
		}
		inputString += "tellraw @s [\"\",{\"text\":\"[NBS] \",\"color\":\"gold\",\"bold\":true},{\"text\":\"Data pack \",\"color\":\"yellow\"},{\"text\":\"" + filename_name(fn) + "\",\"color\":\"gold\",\"underlined\":true},{\"text\":\" uninstalled successfully. You may now remove it from your data pack folder.\",\"color\":\"yellow\"}]"
		dat_writefile(inputString, functiondir + "uninstall.mcfunction")
	
		if (add_teams) {
			//add_teams.mcfunction
			inputString = "team add nbs_1" + br
			inputString += "team add nbs_2" + br
			inputString += "team add nbs_3" + br
			inputString += "team add nbs_4" + br
			inputString += "team add nbs_5" + br
			inputString += "team add nbs_6" + br
			inputString += "team add nbs_7" + br
			inputString += "team add nbs_8" + br
			inputString += "team add nbs_9" + br
			inputString += "team add nbs_10" + br
			inputString += "team add nbs_11" + br
			inputString += "team add nbs_12" + br
			inputString += "team add nbs_13" + br
			inputString += "team add nbs_14" + br
			inputString += "team add nbs_15" + br
			inputString += "team add nbs_16" + br
			inputString += "team add nbs_17" + br
			inputString += "team modify nbs_1 color dark_gray" + br
			inputString += "team modify nbs_2 color red" + br
			inputString += "team modify nbs_3 color black" + br
			inputString += "team modify nbs_4 color yellow" + br
			inputString += "team modify nbs_5 color light_purple" + br
			inputString += "team modify nbs_6 color green" + br
			inputString += "team modify nbs_7 color dark_red" + br
			inputString += "team modify nbs_8 color dark_aqua" + br
			inputString += "team modify nbs_9 color dark_green" + br
			inputString += "team modify nbs_10 color blue" + br
			inputString += "team modify nbs_11 color aqua" + br
			inputString += "team modify nbs_12 color dark_blue" + br
			inputString += "team modify nbs_13 color dark_gray" + br
			inputString += "team modify nbs_14 color dark_green" + br
			inputString += "team modify nbs_15 color gray" + br
			inputString += "team modify nbs_16 color gold" + br
			inputString += "team modify nbs_17 color white"
			dat_writefile(inputString, functiondir + "add_teams.mcfunction")
		
			//remove_teams.mcfunction
			inputString = "team remove nbs_1" + br
			inputString += "team remove nbs_2" + br
			inputString += "team remove nbs_3" + br
			inputString += "team remove nbs_4" + br
			inputString += "team remove nbs_5" + br
			inputString += "team remove nbs_6" + br
			inputString += "team remove nbs_7" + br
			inputString += "team remove nbs_8" + br
			inputString += "team remove nbs_9" + br
			inputString += "team remove nbs_10" + br
			inputString += "team remove nbs_11" + br
			inputString += "team remove nbs_12" + br
			inputString += "team remove nbs_13" + br
			inputString += "team remove nbs_14" + br
			inputString += "team remove nbs_15" + br
			inputString += "team remove nbs_16" + br
			inputString += "team remove nbs_17"
			dat_writefile(inputString, functiondir + "remove_teams.mcfunction")
		}
	
		//Generate binary tree and notes
		dat_generate(functionpath, functiondir, objective, sound_plan)
		minecraft_export_log_report(sound_plan, o.dat_source, "Data pack")
	
		// Package in-process so errors reach GML and paths need no shell quoting.
		python_initialize_for_exports()
		if (o.dat_usezip) {
			if (file_exists_lib(archive_path)) files_delete_lib(archive_path)
			if (python_call_function("datapack_export", "create_zip", [tempdir, archive_path], {}) != true)
				throw "Could not create the data-pack archive"
			var zip_buffer = buffer_load(archive_path)
			if (zip_buffer < 0) throw "Could not read the data-pack archive"
			try {
				buffer_seek(zip_buffer, buffer_seek_start, buffer_get_size(zip_buffer))
				export_succeeded = buffer_export(zip_buffer, fn)
			} catch (e) {
				buffer_delete(zip_buffer)
				throw e
			}
			buffer_delete(zip_buffer)
		} else {
			export_succeeded = python_call_function("datapack_export", "copy_folder", [tempdir, fn], {}) == true
		}
		if (!export_succeeded) throw "Could not write the data pack to its destination"
	} catch (e) {
		export_error = string(e)
		export_succeeded = false
	}
		instance_destroy()
	}

	// Cleanup is limited to our staging files. A cleanup error does not invalidate
	// an export that has already been verified at the chosen destination.
	try {
		if (directory_exists_lib(tempdir)) directory_delete_lib(tempdir)
		if (file_exists_lib(archive_path)) files_delete_lib(archive_path)
	} catch (e) {
		show_debug_message("Could not remove data-pack staging files: " + string(e))
	}
	window = w_datapack_export
	if (!export_succeeded) {
		show_debug_message("Data-pack export failed: " + export_error)
		widget_set_caption(title)
		show_message(condstr(language != 1,
			"The data pack could not be exported.\n\nCheck that the destination is writable and has enough free space, then try again.",
			"无法导出数据包。\n\n请确认保存位置可写且有足够的可用空间，然后重试。"))
		return false
	}

	if (language != 1) message("Data pack saved!" + br + fn + br + br + "To play the song in-game, use:" + br + br + "/function " + functionpath + "play" + br + "/function " + functionpath + "pause" + br + "/function " + functionpath + "stop" + br + br + br + "To play the song using a command block or function, use:" + br + br + "/execute as @p at @s run function " + functionpath + "play" + br + br + "(Replace @p with the player(s) you want to play the song to.)" + br + br + br + "If you wish to uninstall it from your world, run:" + br + br + "/function " + functionpath + "uninstall" + br + br + "and then remove it from the 'datapacks' folder.","Data Pack Export")
	else message("数据包已保存！" + br + fn + br + br + "如想在游戏内播放，使用命令：" + br + br + "/function " + functionpath + "play" + br + "/function " + functionpath + "pause" + br + "/function " + functionpath + "stop" + br + br + "如果你想从你的世界中卸载它，" + br + "使用命令：" + br + br + "/function " + functionpath + "uninstall" + br + br + "然后从“datapacks”文件夹" + br + "取出就行了。","导出数据包")
	return true

}
