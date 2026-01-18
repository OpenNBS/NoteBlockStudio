function draw_window_datapack_export() {
	// draw_window_datapack_export()
	var x1, y1, a, b, c, d, str, nsel, tabs, tabstr, tabw, tabtip, menun, menua, menub, block, blocks, c1, c2
	windowanim = 1
	if (theme = 3) draw_set_alpha(windowalpha)
	curs = cr_default
	x1 = floor(rw / 2 - 275)
	y1 = floor(rh / 2 - 215) + windowoffset
	draw_window(x1, y1, x1 + 550, y1 + 430)
	if (theme = 3){
	draw_set_color(13421772)
	if (fdark) draw_set_color(3355443)
	draw_roundrect(x1+1,y1+1,x1+548,y1+48,0)
	draw_set_color(c_black)
	draw_theme_color()
	}
	draw_theme_font(font_main_bold)
	if (language != 1) draw_text_dynamic(x1 + 8, y1 + 8, "Data Pack Export")
	else draw_text_dynamic(x1 + 8, y1 + 8, "导出数据包")
	draw_theme_font(font_main) 

	b = 8
	if (language != 1) {
	str[0] = "Settings"
	str[1] = "Visualizer"
	} else {
	str[0] = "设置"
	str[1] = "效果"
	}
	nsel = -1
	menun = -1
	for (a = 0; a < 2; a += 1) {
	    c = mouse_rectangle(x1 + b, y1 + 28, string_width_dynamic(str[a]) + 12, 18)
	    if (selected_tab_dat = a) {
	        stabx = b - 2
	        stabw = string_width_dynamic(str[a]) + 15
	    } else {
	        draw_sprite(spr_tabbuttons, 0 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b, y1 + 28)
	        draw_sprite_ext(spr_tabbuttons, 1 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b + 2, y1 + 28, string_width_dynamic(str[a]) / 2 + 4, 1, 0, -1, draw_get_alpha())
	        draw_sprite(spr_tabbuttons, 2 + 3 * c + 6 * theme + 9 * (fdark && theme = 3), x1 + b + string_width_dynamic(str[a]) + 10, y1 + 28)
	        draw_text_dynamic(x1 + b + 6, y1 + 30, str[a])
	    }
	    if (mouse_check_button_pressed(mb_left) && c && wmenu = 0) nsel = a
	    b += string_width_dynamic(str[a]) + 12
	}
	//Background panel
	if (theme = 0 || theme = 3) {
	    draw_set_color(c_white)
	    if (theme != 3) draw_rectangle(x1 + 6, y1 + 46, x1 + 494 + 50, y1 + 362, 0) 
	    draw_set_color(make_color_rgb(137, 140, 149))
	    if (theme != 3) draw_rectangle(x1 + 6, y1 + 46, x1 + 494 + 50, y1 + 362, 1)
	    draw_set_color(c_white)
		if (theme = 3) draw_set_color(15987699)
		if (theme = 3 && fdark) draw_set_color(2105376)
		if (theme != 3) {
	    draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 0)
		} else {
		draw_roundrect(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 25, 0)
		}
	    draw_set_color(make_color_rgb(137, 140, 149))
	    if (theme != 3) draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 1)
	    draw_set_color(c_white)
		if (theme = 3) draw_set_color(15987699)
		if (theme = 3 && fdark) draw_set_color(2105376)
	    draw_rectangle(x1 + stabx + 1, y1 + 46, x1 + stabx + stabw - 1, y1 + 47, 0)
	    draw_theme_color()
	    draw_text_dynamic(x1 + stabx + 8, y1 + 28, str[selected_tab_dat])
	} else if(theme = 1){
	    draw_sprite(spr_tabbuttons, 24, x1 + stabx - 1, y1 + 26)
	    draw_sprite_ext(spr_tabbuttons, 25, x1 + stabx + 1, y1 + 26, stabw / 2 - 1, 1, 0, -1, 1)
	    draw_sprite(spr_tabbuttons, 26, x1 + stabx + stabw - 1, y1 + 26)
	    draw_text_dynamic(x1 + stabx + 8, y1 + 28, str[selected_tab_dat])
	}else{
		draw_set_color(c_dark)
	    draw_rectangle(x1 + 6, y1 + 46, x1 + 494 + 50, y1 + 392, 0) 
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + 6, y1 + 46, x1 + 494 + 50, y1 + 392, 1)
	    draw_set_color(c_dark)
	    draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 0)
	    draw_set_color(make_color_rgb(137, 140, 149))
	    draw_rectangle(x1 + stabx, y1 + 26, x1 + stabx + stabw, y1 + 26 + 20, 1)
	    draw_set_color(c_dark)
	    draw_rectangle(x1 + stabx + 1, y1 + 46, x1 + stabx + stabw - 1, y1 + 47, 0)
	    draw_theme_color()
	    draw_text_dynamic(x1 + stabx + 8, y1 + 28, str[selected_tab_dat])
	}
	if (nsel > -1) selected_tab_dat = nsel
	selected_tab_dat += keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
	if (selected_tab_dat < 0) selected_tab_dat = 1
	if (selected_tab_dat > 1) selected_tab_dat = 0
	if (language != 1) {
	if (selected_tab_dat = 0) {
		draw_sprite(spr_datapack_exp, 2, x1 + 66, y1 + -40)
		draw_theme_color()

		//Name
		draw_text_dynamic(x1 + 16, y1 + 208, "Unique name:")
		if (songs[song].song_name != "") dat_name = songs[song].song_name
		else if (songs[song].filename != "" && songs[song].filename != "-player") dat_name = string_copy(filename_name(songs[song].filename), 1, string_length(filename_name(songs[song].filename))-4)
		else dat_name = ""
		dat_name = draw_inputbox(50,x1 + 16, y1 + 225,145,dat_name,"This name will be used in the command"+br+"for playing the song inside the game.")

		//Namespace
		draw_set_color(c_gray)
		if ((string_path(dat_name) != "") && (string_path(dat_namespace) != "")) draw_theme_color()
		draw_text_dynamic(x1 + 16, y1 + 255, "Namespace:")
		draw_theme_color()
		dat_namespace = draw_inputbox(51,x1 + 16, y1 + 272,145,dat_namespace,"(optional) Use this to place the functions under a custom namespace."+br+"If empty, namespace will be the name of the song.")

		//Path
		draw_set_color(c_gray)
		if ((string_path(dat_name) != "") && (string_path(dat_namespace) != "") && dat_getpath(dat_path) != "") draw_theme_color()
		draw_text_dynamic(x1 + 16, y1 + 301, "Path:")
		draw_theme_color()
		dat_path = draw_inputbox(52,x1 + 16, y1 + 318,145,dat_path,"(optional) Path to the song from the main function"+br+"folder. You can use '/' to add subfolders.")

		//Preview
		draw_text_dynamic(x1 + 16, y1 + 348, "Command preview:")
		draw_theme_font(font_main_bold)
		if (string_path(dat_name) = "") draw_set_color(c_gray)
		draw_text_dynamic(x1 + 16, y1 + 365, dat_preview(dat_name, dat_namespace, dat_path))
		draw_theme_font(font_main)
		draw_theme_color()

		//Source
		draw_text_dynamic(x1 + 187, y1 + 208, "Sound source")
		if (draw_radiobox(x1 + 192, y1 + 228, dat_source = "ambient", "ambient", "Controlled by Ambient/Environment slider")) dat_source = "ambient"
		if (draw_radiobox(x1 + 192, y1 + 247, dat_source = "block", "block", "Controlled by Blocks slider")) dat_source = "block"
		if (draw_radiobox(x1 + 192, y1 + 266, dat_source = "hostile", "hostile", "Controlled by Hostile Creatures slider")) dat_source = "hostile"
		if (draw_radiobox(x1 + 192, y1 + 285, dat_source = "master", "master", "Controlled by Master Volume slider")) dat_source = "master"
		if (draw_radiobox(x1 + 192, y1 + 304, dat_source = "music", "music", "Controlled by Music slider")) dat_source = "music"
		if (draw_radiobox(x1 + 264, y1 + 228, dat_source = "neutral", "neutral", "Controlled by Friendly Creatures slider")) dat_source = "neutral"
		if (draw_radiobox(x1 + 264, y1 + 247, dat_source = "player", "player", "Controlled by Players slider")) dat_source = "player"
		if (draw_radiobox(x1 + 264, y1 + 266, dat_source = "record", "record", "Controlled by Jukebox/Note Blocks slider")) dat_source = "record"
		if (draw_radiobox(x1 + 264, y1 + 285, dat_source = "voice", "voice", "Controlled by Voice/Speech slider")) dat_source = "voice"
		if (draw_radiobox(x1 + 264, y1 + 304, dat_source = "weather", "weather", "Controlled by Weather slider")) dat_source = "weather"

		// Minecraft version
		draw_text_dynamic(x1 + 187, y1 + 334, "Minecraft version")
		if (draw_radiobox(x1 + 192, y1 + 354, dat_mcversion == 0, "1.13-1.20", "Export to Minecraft: Java Edition\nversions 1.13 to 1.20.6.")) dat_mcversion = 0
		if (draw_radiobox(x1 + 192, y1 + 374, dat_mcversion == 1, "1.21+", "Export to Minecraft: Java Edition\nversions 1.21 and above.")) dat_mcversion = 1

		//Export as ZIP
		if (draw_checkbox(x1 + 192, y1 + 404, dat_usezip, "Export as ZIP", "Whether to export the data pack as a ZIP file."+br+"If unchecked, it will be saved as a folder instead.", false, true)) dat_usezip=!dat_usezip

		//Locked layers
		if (draw_checkbox(x1 + 362, y1 + 213, dat_includelocked, "Include locked layers", "Whether to include locked layers in the data pack.", false, true)) dat_includelocked=!dat_includelocked

		//Out-of-range notes
		if (draw_checkbox(x1 + 362, y1 + 238, dat_includeoutofrange, "Include out-of-range notes", "Whether to include notes that don't fall into the 2 octave range supported by"+br+"Minecraft. This will require an additional resource pack you can get below.", false, true)) dat_includeoutofrange = !dat_includeoutofrange

		//Radius
		if (draw_checkbox(x1 + 362, y1 + 263, dat_enableradius, "Nearby listening", "Whether to let all players in a given"+br+"radius hear the music as well.", false, true)) dat_enableradius = !dat_enableradius

		if(dat_enableradius) { 
			dat_radius = median(16, draw_dragvalue(6, x1 + 490, y1 + 283, dat_radius, 2),100000) 
			dat_radiusvalue = 1 + (dat_radius - 16) * 0.06
		}
		else draw_set_color(c_gray) draw_text_dynamic(x1 + 490, y1 + 283, dat_radius)
		draw_text_dynamic(x1 + 380, y1 + 283, "Radius (in blocks):")
		popup_set_window(x1 + 380, y1 + 279, 125, 21, "Radius in which players will be able to hear the music")
		draw_theme_color()

		//Looping
		if (draw_checkbox(x1 + 362, y1 + 313, dat_enablelooping, "Enable looping", "If enabled, the song will loop at the"+br+"end of playback instead of stopping.", false, true)) dat_enablelooping = !dat_enablelooping
		if(dat_enablelooping) { 
			songs[song].loopstart = median(0, draw_dragvalue(7, x1 + 490, y1 + 333, songs[song].loopstart, 0.5), obj_controller.songs[song].enda)
		}
		else draw_set_color(c_gray) draw_text_dynamic(x1 + 490, y1 + 333, songs[song].loopstart)
		draw_text_dynamic(x1 + 380, y1 + 333, "Loop start:")
		popup_set_window(x1 + 380, y1 + 329, 125, 21, "Tick the song will jump to at the end of playback")
		draw_theme_color()
	
		//Get extra notes button
		if (draw_button2(x1 + 380, y1 + 362, 152, "Get extra notes pack", !dat_includeoutofrange, 1)) {
			datapack_getextranotes()
		}
	
	} else {
		if (draw_checkbox(x1 + 33, y1 + 55, dat_visualizer, "Enable visualizer", "NOTE: Please use a VOID world as falling blocks will pile up!", false, true)) dat_visualizer=!dat_visualizer
		//Type
		draw_sprite(spr_datapack_exp, 1, x1 + 125, y1 + 55)
		draw_text_dynamic(x1 + 33, y1 + 75, "Visualizer type")
		if (draw_radiobox(x1 + 33, y1 + 95, dat_vis_type = "Arc", "Arc", "Use Arc visualizer.")) dat_vis_type = "Arc"
		if (draw_radiobox(x1 + 33, y1 + 115, dat_vis_type = "Fall", "Fall", "Use Fall visualizer.")) dat_vis_type = "Fall"
		if (draw_radiobox(x1 + 33, y1 + 135, dat_vis_type = "Rise", "Rise", "Use Rise visualizer.")) dat_vis_type = "Rise"
		if (draw_radiobox(x1 + 33, y1 + 155, dat_vis_type = "Bounce", "Bounce", "Use Bounce visualizer.")) dat_vis_type = "Bounce"
		if (draw_radiobox(x1 + 33, y1 + 175, dat_vis_type = "Piano Roll", "Piano Roll", "Use Piano Roll visualizer.")) dat_vis_type = "Piano Roll"
		if (draw_radiobox(x1 + 33, y1 + 195, dat_vis_type = "Fountain", "Fountain", "Use Fountain visualizer.")) dat_vis_type = "Fountain"
		if (draw_radiobox(x1 + 33, y1 + 215, dat_vis_type = "Rittai Onkyou", "Rittai Onkyou", "Use Rittai Onkyou visualizer.")) dat_vis_type = "Rittai Onkyou"
		if (draw_checkbox(x1 + 33, y1 + 235, dat_glow, "Add glow", "Whether to add a glowing effect to each note block.")) dat_glow=!dat_glow
		draw_text_dynamic(x1 + 33, y1 + 255, "Spawn height:")
		dat_yval = median(0, draw_dragvalue(11, x1 + 33, y1 + 275, dat_yval, 0.5), 255)
		draw_text_dynamic(x1 + 33, y1 + 295, "Position in map:")
		draw_text_dynamic(x1 + 33, y1 + 318, "X value:")
		dat_xval = draw_inputbox(53,x1 + 83, y1 + 315,40,dat_xval,"X value")
		draw_text_dynamic(x1 + 33, y1 + 338, "Z value:")
		dat_zval = draw_inputbox(54,x1 + 83, y1 + 335,40,dat_zval,"Z value")
		//Get note block textures button
		if (draw_button2(x1 + 13, y1 + 360, 152, "Get note block textures", 0, 1)) {
			datapack_getinstextures()
		}
	}
	if (wmenu = 1 && !mouse_check_button(mb_left)) wmenu = 0

	//Submit button
	if (draw_button2(x1 + 470, y1 + 398, 72, "Export", false)) {
		if(string_lettersdigits(dat_name) != "") {
			if(string_count("/", dat_getpath(dat_path)) >= 5) {
				message("Path can only contain up to 5 subfolders", "Error")
			} else {
				datapack_export()
			}
		}else{
			message("Please enter a valid name for the data pack","Error")
		}
	}

	//Remember changes
	if (draw_checkbox(x1 + 12, y1 + 404, dat_remember, "Remember changes", "Whether to use these settings the\nnext time you export a data pack.", false, true) && wmenu = 0) dat_remember = !dat_remember

	//Use default
	if (draw_button2(x1 + 310, y1 + 398, 72, "Use default") && wmenu = 0) {
	    if (question("Are you sure?", "Confirm")) dat_reset(1)
	}

	//Cancel button
	if (draw_button2(x1 + 390, y1 + 398, 72, "Cancel", false) && (windowopen = 1 || theme != 3)) {
		windowclose = 1
	}
	} else {
	if (selected_tab_dat = 0) {
		draw_sprite(spr_datapack_exp, 2, x1 + 66, y1 + -40)
		draw_theme_color()

		//Name
		draw_text_dynamic(x1 + 16, y1 + 208, "唯一名称:")
		if (songs[song].song_name != "") dat_name = songs[song].song_name
		else if (songs[song].filename != "" && songs[song].filename != "-player") dat_name = string_copy(filename_name(songs[song].filename), 1, string_length(filename_name(songs[song].filename))-4)
		else dat_name = ""
		dat_name = draw_inputbox(50,x1 + 16, y1 + 225,145,dat_name,"该名称会作为在游戏里播放使用的命令名称。")

		//Namespace
		draw_set_color(c_gray)
		if ((string_path(dat_name) != "") && (string_path(dat_namespace) != "")) draw_theme_color()
		draw_text_dynamic(x1 + 16, y1 + 255, "命名空间:")
		draw_theme_color()
		dat_namespace = draw_inputbox(51,x1 + 16, y1 + 272,145,dat_namespace,"（可选）将命令名称更改到自定义命名空间下。"+br+"如为空，命名空间会设为歌曲名称。")

		//Path
		draw_set_color(c_gray)
		if ((string_path(dat_name) != "") && (string_path(dat_namespace) != "") && dat_getpath(dat_path) != "") draw_theme_color()
		draw_text_dynamic(x1 + 16, y1 + 301, "路径:")
		draw_theme_color()
		dat_path = draw_inputbox(52,x1 + 16, y1 + 318,145,dat_path,"（可选）从“functions”文件夹到歌曲的路径。"+br+"用“/”来套文件夹。")

		//Preview
		draw_text_dynamic(x1 + 16, y1 + 348, "命令预览:")
		draw_theme_font(font_main_bold)
		if (string_path(dat_name) = "") draw_set_color(c_gray)
		draw_text_dynamic(x1 + 16, y1 + 365, dat_preview(dat_name, dat_namespace, dat_path))
		draw_theme_font(font_main)
		draw_theme_color()

		//Source
		draw_text_dynamic(x1 + 187, y1 + 208, "声音类型")
		if (draw_radiobox(x1 + 192, y1 + 228, dat_source = "ambient", "环境", "由环境音量控制")) dat_source = "ambient"
		if (draw_radiobox(x1 + 192, y1 + 247, dat_source = "block", "方块", "由方块音量控制")) dat_source = "block"
		if (draw_radiobox(x1 + 192, y1 + 266, dat_source = "hostile", "敌对", "由敌对生物音量控制")) dat_source = "hostile"
		if (draw_radiobox(x1 + 192, y1 + 285, dat_source = "master", "主源", "由主音量控制")) dat_source = "master"
		if (draw_radiobox(x1 + 192, y1 + 304, dat_source = "music", "音乐", "由音乐音量控制")) dat_source = "music"
		if (draw_radiobox(x1 + 264, y1 + 228, dat_source = "neutral", "中立", "由友好生物音量控制")) dat_source = "neutral"
		if (draw_radiobox(x1 + 264, y1 + 247, dat_source = "player", "玩家", "由玩家音量控制")) dat_source = "player"
		if (draw_radiobox(x1 + 264, y1 + 266, dat_source = "record", "唱片", "由唱片机/音符盒音量控制")) dat_source = "record"
		if (draw_radiobox(x1 + 264, y1 + 285, dat_source = "voice", "语音", "由语音音量控制")) dat_source = "voice"
		if (draw_radiobox(x1 + 264, y1 + 304, dat_source = "weather", "天气", "由天气音量控制")) dat_source = "weather"

		// Minecraft version
		draw_text_dynamic(x1 + 187, y1 + 334, "Minecraft 版本")
		if (draw_radiobox(x1 + 192, y1 + 354, dat_mcversion == 0, "1.13-1.20", "导出至 Minecraft: Java 版\n版本 1.13 至 1.20.6。")) dat_mcversion = 0
		if (draw_radiobox(x1 + 192, y1 + 374, dat_mcversion == 1, "1.21+", "导出至 Minecraft: Java 版\n版本 1.21 及以上。")) dat_mcversion = 1

		//Export as ZIP
		if (draw_checkbox(x1 + 192, y1 + 404, dat_usezip, "导出为 ZIP", "是否导出为 ZIP 格式的文件。"+br+"如关闭，将导出为文件夹。", false, true)) dat_usezip=!dat_usezip

		//Locked layers
		if (draw_checkbox(x1 + 362, y1 + 213, dat_includelocked, "包括已静音的层", "是否在数据包内包括已静音的层。", false, true)) dat_includelocked=!dat_includelocked

		//Out-of-range notes
		if (draw_checkbox(x1 + 362, y1 + 238, dat_includeoutofrange, "包括超范围音符", "是否包括超过 Minecraft 的 2 八度限制的音符。"+br+"此选项需要安装额外的数据包。", false, true)) dat_includeoutofrange = !dat_includeoutofrange

		//Radius
		if (draw_checkbox(x1 + 362, y1 + 263, dat_enableradius, "共享音乐", "是否共享音乐给一定范围内的玩家。", false, true)) dat_enableradius = !dat_enableradius

		if(dat_enableradius) { 
			dat_radius = median(16, draw_dragvalue(6, x1 + 490, y1 + 283, dat_radius, 2),100000) 
			dat_radiusvalue = 1 + (dat_radius - 16) * 0.06
		}
		else draw_set_color(c_gray) draw_text_dynamic(x1 + 490, y1 + 283, dat_radius)
		draw_text_dynamic(x1 + 380, y1 + 283, "范围（方块）:")
		popup_set_window(x1 + 380, y1 + 279, 125, 21, "玩家能听到音乐的范围。")
		draw_theme_color()

		//Looping
		if (draw_checkbox(x1 + 362, y1 + 313, dat_enablelooping, "启用循环", "如果开启，歌曲播放到最后将会循环。", false, true)) dat_enablelooping = !dat_enablelooping
		if(dat_enablelooping) { 
			songs[song].loopstart = median(0, draw_dragvalue(7, x1 + 490, y1 + 333, songs[song].loopstart, 0.5), obj_controller.songs[song].enda)
		}
		else draw_set_color(c_gray) draw_text_dynamic(x1 + 490, y1 + 333, songs[song].loopstart)
		draw_text_dynamic(x1 + 380, y1 + 333, "循环开始:")
		popup_set_window(x1 + 380, y1 + 329, 125, 21, "播放完循环时回到的时刻。")
		draw_theme_color()
	
		//Get extra notes button
		if (draw_button2(x1 + 380, y1 + 362, 152, "保存更多音符资源包", !dat_includeoutofrange, 1)) {
			datapack_getextranotes()
		}
	
	} else {
		if (draw_checkbox(x1 + 33, y1 + 55, dat_visualizer, "启用效果器", "注意：请使用一个虚空地图不然方块就会堆起来！", false, true)) dat_visualizer=!dat_visualizer
		//Type
		draw_sprite(spr_datapack_exp, 1, x1 + 125, y1 + 55)
		draw_text_dynamic(x1 + 33, y1 + 75, "效果类型")
		if (draw_radiobox(x1 + 33, y1 + 95, dat_vis_type = "Arc", "弧形", "使用弧形效果器。")) dat_vis_type = "Arc"
		if (draw_radiobox(x1 + 33, y1 + 115, dat_vis_type = "Fall", "下落", "使用下落效果器。")) dat_vis_type = "Fall"
		if (draw_radiobox(x1 + 33, y1 + 135, dat_vis_type = "Rise", "上升", "使用上升效果器。")) dat_vis_type = "Rise"
		if (draw_radiobox(x1 + 33, y1 + 155, dat_vis_type = "Bounce", "弹跳", "使用弹跳效果器。")) dat_vis_type = "Bounce"
		if (draw_radiobox(x1 + 33, y1 + 175, dat_vis_type = "Piano Roll", "钢琴", "使用钢琴式效果器。")) dat_vis_type = "Piano Roll"
		if (draw_radiobox(x1 + 33, y1 + 195, dat_vis_type = "Fountain", "喷泉", "使用喷泉效果器。")) dat_vis_type = "Fountain"
		if (draw_radiobox(x1 + 33, y1 + 215, dat_vis_type = "Rittai Onkyou", "立体", "使用立体音效效果器。")) dat_vis_type = "Rittai Onkyou"
		if (draw_checkbox(x1 + 33, y1 + 235, dat_glow, "发光效果", "是否为每个音符盒添加发光效果。")) dat_glow=!dat_glow
		draw_text_dynamic(x1 + 33, y1 + 255, "生成高度:")
		dat_yval = median(0, draw_dragvalue(11, x1 + 33, y1 + 275, dat_yval, 0.5), 255)
		draw_text_dynamic(x1 + 33, y1 + 295, "地图中位置:")
		draw_text_dynamic(x1 + 33, y1 + 318, "X值:")
		dat_xval = draw_inputbox(53,x1 + 83, y1 + 315,40,dat_xval,"X值")
		draw_text_dynamic(x1 + 33, y1 + 338, "Z值:")
		dat_zval = draw_inputbox(54,x1 + 83, y1 + 335,40,dat_zval,"Z值")
		//Get note block textures button
		if (draw_button2(x1 + 13, y1 + 360, 152, "保存音符盒资源包", 0, 1)) {
			datapack_getinstextures()
		}
	}
	if (wmenu = 1 && !mouse_check_button(mb_left)) wmenu = 0

	//Submit button
	if (draw_button2(x1 + 470, y1 + 398, 72, "导出", false)) {
		if(string_lettersdigits(dat_name) != "") {
			if(string_count("/", dat_getpath(dat_path)) >= 5) {
				message("路径最多只能套五个文件夹", "错误")
			} else {
				datapack_export()
			}
		}else{
			message("请输入一个有效的数据包名","错误")
		}
	}

	//Remember changes
	if (draw_checkbox(x1 + 12, y1 + 404, dat_remember, "记住我的更改", "下次导出数据包时是否使用同样的设定。", false, true) && wmenu = 0) dat_remember = !dat_remember

	//Use default
	if (draw_button2(x1 + 310, y1 + 398, 72, "使用默认值") && wmenu = 0) {
	    if (question("你确定吗？", "确定")) dat_reset(1)
	}

	//Cancel button
	if (draw_button2(x1 + 390, y1 + 398, 72, "取消", false) && (windowopen = 1 || theme != 3)) {
		windowclose = 1
	}
	}
}
