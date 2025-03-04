function datapack_export() {
	// datapack_export()
	var fn, o
	o = obj_controller

	if (language != 1) {
	if (o.dat_usezip) fn = string(get_save_filename_ext("ZIP archive (*.zip)|*.zip", dat_name + ".zip", "", "Data Pack Export"))
	else fn = string(get_save_filename_ext("Data Pack Folder", dat_name, "", "Data Pack Export"))
	} else {
	if (o.dat_usezip) fn = string(get_save_filename_ext("ZIP archive (*.zip)|*.zip", dat_name + ".zip", "", "导出数据包"))
	if (o.dat_usezip) fn = fn + condstr(filename_ext(fn) != ".zip", ".zip")
	else fn = string(get_save_filename_ext("数据包目录", dat_name, "", "导出数据包"))
	}
	if (fn = "") return 0
	fn = enforce_extension(fn, ".zip")

	window = -1
	calculate_locked_layers()

	with (create(obj_dummy2)) {
		// Initialize variables
		var name = string_path(o.dat_name)
		var namespace = string_path(o.dat_namespace)
		var path = dat_getpath(o.dat_path)
		var objective = "nbs_" + string_copy(string_lettersdigits(o.dat_name), 1, 10)
		var tag = objective
		
		// https://minecraft.wiki/w/Pack_format
		var pack_format = (o.dat_mcversion == 0) ? 41 : 48
		// https://minecraft.wiki/w/Java_Edition_1.21#Command_format_2
		var function_registry = (o.dat_mcversion == 0) ? "functions" : "function";

		var playspeed = min(round(o.songs[o.song].tempo * 4), 120)
		var rootfunction = "0_" + string(power(2, floor(log2(o.songs[o.song].enda))+1)-1)
		var tempdir
		var functionpath
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
	
		// Create folder structure
		tempdir = data_directory + "tempdatapack" + condstr(os_type = os_windows, "\\", "/")
		if (directory_exists_lib(tempdir)) {
			directory_delete_lib(tempdir)
		}
		functiondir = dat_makefolders(path, namespace, function_registry)
	
		//pack.mcmeta
		inputString = "{\n\t\"pack\": {\n\t\t\"pack_format\": " + string(pack_format) + ",\n\t\t\"description\": \"" + o.dat_name + "\\nMade with Note Block Studio\"\n\t}\n}"
		dat_writefile(inputString, tempdir + "pack.mcmeta")
	
		//Minecraft folder:
	
		//load.json
		inputString = "{\"values\": [\"" + functionpath + "load\"]}"
		dat_writefile(inputString, tempdir + "data\\minecraft\\tags\\" + function_registry + "\\load.json")
	
		//tick.json
		inputString = "{\"values\": [\"" + functionpath + "tick\"]}"
		dat_writefile(inputString, tempdir + "data\\minecraft\\tags\\" + function_registry + "\\tick.json")
	
		//Song folder:
	
		//load.mcfunction
		inputString = "scoreboard objectives add " + objective + " dummy" + br
		inputString += "scoreboard objectives add " + objective + "_t dummy" + br
		inputString += "scoreboard players set speed " + objective + " " + string(playspeed)
		dat_writefile(inputString, functiondir + "load.mcfunction")
	
		//tick.mcfunction
		inputString = "execute as @a[tag=" + tag + "] run scoreboard players operation @s " + objective + " += speed " + objective + br
		if(o.dat_enableradius) inputString += "execute as @a[tag=" + tag + "] run function " + functionpath + "tree/" + rootfunction
		else inputString += "execute as @a[tag=" + tag + "] at @s run function " + functionpath + "tree/" + rootfunction
		dat_writefile(inputString, functiondir + "tick.mcfunction")
	
		//play.mcfunction
		inputString = "tag @s add " + tag + br
		inputString += "scoreboard players set @s " + objective + "_t -1" + br
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
		inputString += "scoreboard players reset @s " + objective + "_t"
		if (add_teams) {
			inputString += br + "function " + functionpath + "remove_teams"
		}
		dat_writefile(inputString, functiondir + "stop.mcfunction")
	
		//uninstall.mcfunction
		inputString = "tag @e remove " + tag + br
		inputString += "scoreboard objectives remove " + objective + br
		inputString += "scoreboard objectives remove " + objective + "_t" + br
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
		dat_generate(functionpath, functiondir, objective)
	
		// Execute shell command to create ZIP, or to move temp folder to location
		if (o.dat_usezip) {
			if (os_type = os_macosx) execute_program("ditto", "-c -k \"" + data_directory + "tempdatapack" + "\" \"" + fn + "\"", true);
			else execute_program(get_7z_exc_name(), "a -tzip \"" + fn + "\" \"" + data_directory + "tempdatapack" + condstr(os_type = os_windows, "\\", "/") + "*\"", true)
		} else {
			if (os_type = os_windows) execute_program("cmd", "\"" + data_directory + "move.bat\" \"" + fn + "\\\"", true)
			else execute_program("cp", "-r \"" + data_directory + "tempdatapack\" \"" + fn + "/\"", true);
		}
	
		directory_delete_lib(tempdir)
		instance_destroy()
	}

	if (language != 1) message("Data pack saved!" + br + br + br + "To play the song in-game, use:" + br + br + "/function " + functionpath + "play" + br + "/function " + functionpath + "pause" + br + "/function " + functionpath + "stop" + br + br + br + "To play the song using a command block or function, use:" + br + br + "/execute as @p at @s run function " + functionpath + "play" + br + br + "(Replace @p with the player(s) you want to play the song to.)" + br + br + br + "If you wish to uninstall it from your world, run:" + br + br + "/function " + functionpath + "uninstall" + br + br + "and then remove it from the 'datapacks' folder.","Data Pack Export")
	else message("数据包已保存！" + br + br + "如想在游戏内播放，使用命令：" + br + br + "/function " + functionpath + "play" + br + "/function " + functionpath + "pause" + br + "/function " + functionpath + "stop" + br + br + "如果你想从你的世界中卸载它，" + br + "使用命令：" + br + br + "/function " + functionpath + "uninstall" + br + br + "然后从“datapacks”文件夹" + br + "取出就行了。","导出数据包")
	window = w_datapack_export


}
