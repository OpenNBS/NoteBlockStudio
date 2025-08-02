function draw_window_sound_import() {

	// Boilerplate
	windowanim = 1;
	if (theme = 3) draw_set_alpha(windowalpha);
	var x1, y1, a, n;
	
	// Window frame
	var width = 415;
	var height = 310;
	var startx = floor((rw - width) / 2);
	var starty = floor((rh - height) / 2) + windowoffset;
	var x1 = startx;
	var y1 = starty;
	draw_window(x1, y1, x1 + width, y1 + height);
	startx += 8;
	x1 = startx;
	y1 += 8;
	
	// Title
	draw_theme_font(font_main_bold)
	draw_text_dynamic(x1, y1, ((language == 0) ? "Import sounds" : "导入音效"));
	draw_theme_font(font_main)
	
	// Info text
	x1 = startx;
	y1 += 20;
	draw_text_dynamic(
		x1, y1,
		((language == 0) ? 
		"This assistant will help you get sound files from your Minecraft:" + "\n" +
		"Java Edition installation or from the Mojang server." :
		"本向导将帮助您从您的 Minecraft：Java 版或 Mojang 服务器获取音效。"
		)
	)
	y1 += 33
	if (draw_checkbox(x1, y1, sound_import_download_toggle, ((language == 0) ? "Download from Mojang" : "从 Mojang 下载"), "", 0, 1)) sound_import_download_toggle = !sound_import_download_toggle
	y1 += 17
	if (!sound_import_download_toggle) {
		draw_text_dynamic(
			x1, y1,
			((language == 0) ? 
			"Before continuing, ensure you have launched the version you want from" + "\n" +
			"the Minecraft Launcher." + "\n" +
			"Select a version from the list, and then click 'Get sounds' to import the" + "\n" +
			"sounds from that version!" :
			"在开始之前，请确保您从您的启动器至少启动过一次您想要选择的版本。" + "\n" +
			"从列表中选择一个游戏版本，然后点击“获取音效”来导入该版本的音效！"
			)
		)
	
		// Minecraft installation path
		x1 = startx;
		y1 += 76;
		draw_text_dynamic(x1, y1, ((language == 0) ? "1. Set your Minecraft installation path:" : "1. 设定您的.minecraft目录："));
		x1 += 16;
		y1 += 20;
		draw_text_dynamic(x1, y1, string_truncate(mc_install_path, 280, true));
		y1 -= 20;
	
		// Change button
		x1 = startx + width - 72 - 20;
		if (draw_button2(x1, y1, 72, ((language == 0) ? "Change" : "更改"), false, true)) {
			var fn = string(get_save_filename_ext("", 
				((language == 0) ? "Select Minecraft installation directory" : "选择Minecraft安装目录"), 
				mc_install_path, 
				((language == 0) ? "Minecraft installation directory" : "Minecraft安装目录")));
			if (fn != "") {
				mc_install_path = filename_dir(fn);
				mc_install_path = string_replace_all(mc_install_path, "Select Minecraft installation directory", "")
				mc_install_path = string_replace_all(mc_install_path, "选择Minecraft安装目录", "")
				if (os_type != os_windows && string_char_at(mc_install_path, string_length(mc_install_path)) != "/") mc_install_path = mc_install_path + "/"
			}
			update_asset_index_menu();
		}
		y1 += 28;
	
		// Use default button
		if (draw_button2(x1, y1, 72, ((language == 0) ? "Use default" : "使用默认设定"), false, true)) {
			mc_install_path = mc_default_path;
			update_asset_index_menu();
		}
		y1 += 4
		y1 -= 10
	} else {
		draw_text_dynamic(
			x1, y1,
			((language == 0) ? 
			"Before continuing, you will need to fetch the asset indexes of Minecraft" + "\n" +
			"versions from Mojang." + "\n" +
			"Select a version from the list, and then click 'Get sounds' to import the" + "\n" +
			"sounds from that version!" :
			"在开始之前，请从 Mojang 获取 Minecraft 版本的资产索引。" + "\n" +
			"从列表中选择一个游戏版本，然后点击“获取音效”来导入该版本的音效！"
			)
		)
	
		// Minecraft installation path
		x1 = startx;
		y1 += 76;
		draw_text_dynamic(x1, y1, ((language == 0) ? "1. Get asset indexes from Mojang" : "1. 从 Mojang 获取资产索引"));
		x1 += 16;
		y1 += 20;
		//draw_text_dynamic(x1, y1, string_truncate(mc_install_path, 280, true));
		y1 -= 20;
	
		// Get button
		x1 = startx + width - 72 - 20;
		if (draw_button2(x1, y1, 72, ((language == 0) ? "Get" : "获取"), (sound_import_download_toggle && sound_import_status == 1), true)) {
			sound_import_download_stage = 1
			sound_import_download_status = http_get("https://launchermeta.mojang.com/mc/game/version_manifest.json")
			sound_import_download_files_index = 0
		}
		y1 += 28;
		y1 += 4
		y1 -= 10
	}
	
	// Asset index select menu
	x1 = startx;
	y1 += 30;
	draw_text_dynamic(x1, y1, ((language == 0) ? "2. Select the asset list to copy sounds from:" : "2. 选择想从中提取音效的版本："));
	x1 += 16;
	y1 += 20;
	y1 += 1;
	draw_area(x1, y1, x1 + 86, y1 + 20);
	if (sound_import_download_toggle) draw_text_dynamic(x1 + 4, y1 + 4, sound_import_selected_asset_index);
	else draw_text_dynamic(x1 + 4, y1 + 4, get_asset_index_friendly_name(sound_import_selected_asset_index));
	if (draw_abutton(x1 + 86 - 16, y1 + 1, sound_import_menu_str == "" || sound_import_download_files_index > 0)) {
		menu = show_menu_ext("sound_import_asset_index", x1, y1, sound_import_menu_str);
	}
	
	// Status text
	x1 += 86 + 8;
	y1 += 3;
	draw_theme_font(font_main_bold);
	draw_theme_color();
	
	// 0 = idle; 1 = copying; 2 = copying done
	if (sound_import_status == 2) {
		if (theme == 3 && fdark || theme == 2) draw_set_color(c_lime);
		else draw_set_color(c_green);
		draw_text_dynamic(x1, y1, string_format_thousands(sound_import_asset_index_count) + ((language == 0) ? " sounds have been copied!" : " 个音效获取成功！"));
	} else if (sound_import_status == 1) {
		draw_text_dynamic(x1, y1, ((language == 0) ? "Copying sounds... please wait!" : "正在获取音效...... 请稍候！"));
		if (sound_import_download_toggle) draw_text_dynamic(x1, y1 + 14, string(sound_import_download_files_index - 1) + "/" + string(array_length(sound_import_download_files_list)) + ((language == 0) ? " sounds downloaded" : " 个音效已下载"));
	} else {
		if (sound_import_asset_index_count > 0) {
			draw_text_dynamic(x1, y1, string_format_thousands(sound_import_asset_index_count) + ((language == 0) ? " sounds located!" : " 个音效已被找到！"));
		} else if (!sound_import_download_toggle) {
			draw_set_color(c_red);
			draw_text_dynamic(x1, y1 - 7, ((language == 0) ? "No sounds located! Check your" : "未找到音效！请检查您的 Minecraft"));
			draw_text_dynamic(x1, y1 + 7, ((language == 0) ? "Minecraft installation path." : "安装目录。"));
		}
	}
	draw_theme_color();
	draw_theme_font(font_main);
	y1 -= 3;
	
	// Copy sounds button
	x1 = startx + width - 86 - 20;
	var is_locked = sound_import_selected_asset_index == "";
	if (draw_button2(x1, y1, 86, ((language == 0) ? "Get sounds" : "获取音效"), (is_locked || sound_import_status == 1), false)) {
		if (!sound_import_download_toggle) load_asset_index(true);
		else {
			sound_import_download_stage = 2
			if (sound_import_download_files_index = 0) {
				sound_import_download_status = http_get(sound_import_download_version_url_list[sound_import_asset_index_select][1])
				log (sound_import_download_version_url_list[sound_import_asset_index_select][1])
			} else {
				if (sound_import_download_files_index < array_length(sound_import_download_files_list)) {
					sound_import_status = 1
					sound_import_download_stage = 4
					sound_import_download_status = http_get_file(sound_import_download_files_list[sound_import_download_files_index, 0], sound_import_download_files_list[sound_import_download_files_index, 1])
					log (sound_import_download_files_list[sound_import_download_files_index, 0])
					sound_import_download_files_index += 1
				}
			}
		}
	}
	
	// Instrument settings button
	x1 = startx + 12;
	y1 = starty + height - 20 - 12;
	if (draw_button2(x1, y1, 120, ((language == 0) ? "Instrument settings..." : "音色设置......"), (sound_import_download_toggle && sound_import_status == 1), true)) {
		window = w_instruments;
	}
	// Sounds folder button
	x1 += 120 + 12;
	if (draw_button2(x1, y1, 120, ((language == 0) ? "Open Sounds folder" : "打开已获取音效目录"), false, true)) {
		open_url(sounds_directory);
	}
	
	// OK button
	x1 = startx + width - 72 - 8 - 12;
	if (draw_button2(x1, y1, 72, ((language == 0) ? "OK" : "确定"), (sound_import_download_toggle && sound_import_status == 1), false)) {
		sound_import_status = 0;
		windowclose = 1;
	}
}
