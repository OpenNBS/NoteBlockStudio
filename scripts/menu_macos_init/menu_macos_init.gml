function menu_macos_init(){
	var str, a, b, c;
	if (os_type = os_macosx) {
		macos_menu_clear()
		var current_song = songs[song]
		if (language != 1) {
			macos_create_menu_ext("Help", "help", icon_menubar(icons.HELP) + "Tutorial videos|\\|Part 1: Composing note block music|Part 2: Opening MIDI files|Part 3: Importing songs into Minecraft|Part 4: Editing songs made in Minecraft     |-|F1$View all|/|-|" + icon_menubar(icons.INTERNET) + "Website...|GitHub...|Discord server...|Report a bug...|Donate...|-|Changelist...|About...")
			str = ""
			customstr = ""
			insmenu = 1
			for (a = 0; a < ds_list_size(current_song.instrument_list); a++) {
				var ins = current_song.instrument_list[| a];
				if (ins.user)
				    customstr += check(current_song.instrument = ins) + clean(ins.name) + "|"
				else{
					if(a < 9){
							str += check(current_song.instrument = ins) + get_hotkey_menubar("ins_ctrl") + string((a + 1) % 10) + "$" + clean(ins.name) + "|"
					}else{
						str += check(current_song.instrument = ins) + get_hotkey_menubar("ins_ctrl_shift") + string((a + 2) % 10) + "$" + clean(ins.name) + "|"
					}
				}
				if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
					customstr += "-|More...|\\|"
					insmenu++
				}
			}
			if (!isplayer) macos_create_menu_ext("Settings", "settings", "Instrument|\\|" + str + condstr(customstr != "", "-|") + customstr + string_repeat("/|", insmenu) +
				                icon_menubar(icons.INSTRUMENTS)+"Instrument settings...|Import sounds from Minecraft...|/|-|" + icon_menubar(icons.INFORMATION) + "Song info...|" + icon_menubar(icons.PROPERTIES) + "Song properties...|Song stats...|-|" + icon_menubar(icons.MIDI_INPUT) + "MIDI device manager")
			else macos_create_menu_ext("Settings", "settingsp", icon_menubar(icons.INFORMATION) + "Song info...|" + "Song stats...")
			if (!isplayer) {
				str = ""
				customstr = ""
				insmenu = 1
				for (a = 0; a < ds_list_size(current_song.instrument_list); a += 1) {
				    var ins = current_song.instrument_list[| a];
				    if (ins.user)
				        customstr += "...to " + clean(ins.name) + "|"
				    else
				        str += "...to " + clean(ins.name) + "|"
					if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
						customstr += "-|More...|\\|"
						insmenu++
					}
				}
				// title is "Edit" + no_wide_space, otherwise fails
				macos_create_menu_ext("Edit​", "edit", inactive(current_song.historypos = current_song.historylen) + icon_menubar(icons.UNDO - (current_song.historypos = current_song.historylen)) + get_hotkey_menubar("undo") + "$Undo|"+
				                            inactive(current_song.historypos = 0) + icon_menubar(icons.REDO - (current_song.historypos = 0)) + get_hotkey_menubar("redo") + "$Redo|-|"+
				                            inactive(current_song.selected = 0) + icon_menubar(icons.COPY - (current_song.selected = 0)) + get_hotkey_menubar("copy") + "$Copy|"+
				                            inactive(current_song.selected = 0) + icon_menubar(icons.CUT - (current_song.selected = 0)) + get_hotkey_menubar("cut") + "$Cut|"+
				                            inactive(selection_copied = "") + icon_menubar(icons.PASTE - (selection_copied = "")) + get_hotkey_menubar("paste") + "$Paste|"+
				                            inactive(current_song.selected = 0) + icon_menubar(icons.DELETE - (current_song.selected = 0)) + get_hotkey_menubar("delete") + "$Delete|-|"+
				                            inactive(current_song.totalblocks = 0) + get_hotkey_menubar("select_all") + "$Select all|"+
				                            inactive(current_song.selected = 0) + "Deselect all|"+
				                            inactive(current_song.selected = 0 && current_song.totalblocks = 0) + get_hotkey_menubar("invert_selection") + "$Invert selection|-|"+
				                            inactive(current_song.instrument.num_blocks = 0) + "Select all " + clean(current_song.instrument.name) + "|"+
				                            inactive(current_song.instrument.num_blocks = current_song.totalblocks) + "Select all but " + clean(current_song.instrument.name) + "|-|"+
				                            inactive(current_song.selected = 0) + get_hotkey_menubar("action_1") + "$" + get_mode_actions(1) + "|"+
				                            inactive(current_song.selected = 0) + get_hotkey_menubar("action_2") + "$" + get_mode_actions(2) + "|"+
				                            inactive(current_song.selected = 0) + get_hotkey_menubar("action_3") + "$" + get_mode_actions(3) + "|"+
				                            inactive(current_song.selected = 0) + get_hotkey_menubar("action_4") + "$" + get_mode_actions(4) + "|"+
													condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey_menubar("action_5") + "$" + get_mode_actions(5) + "|") +
													condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey_menubar("action_6") + "$" + get_mode_actions(6) + "|") +
				                            inactive(current_song.selected = 0) + "Change instrument...|\\|" + str + condstr(customstr != "", "-|") + customstr + string_repeat("/|", insmenu) + "-|" +
				                            inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Expand selection|"+
				                            inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Compress selection|"+
				                            inactive(current_song.selected = 0 || current_song.selection_l = 0) + "Macros...|\\||"+ 
											get_hotkey_menubar("tremolo") + "$Tremolo...|"+
											get_hotkey_menubar("stereo") + "$Stereo...|"+
											get_hotkey_menubar("arpeggio") + "$Arpeggio...|"+
											get_hotkey_menubar("portamento") + "$Portamento...|"+
											get_hotkey_menubar("vibrato") + "$Vibrato|"+
											get_hotkey_menubar("stagger") + "$Stagger...|"+
											get_hotkey_menubar("chorus") + "$Chorus|"+
											get_hotkey_menubar("volume_lfo") + "$Volume LFO|"+
											get_hotkey_menubar("fade_in") + "$Fade in|"+
											get_hotkey_menubar("fade_out") + "$Fade out|"+
											get_hotkey_menubar("replace_key") + "$Replace key|"+
											get_hotkey_menubar("set_velocity") + "$Set velocity...|"+
											get_hotkey_menubar("set_panning") + "$Set panning...|"+
											get_hotkey_menubar("set_pitch") + "$Set pitch...|"+
											get_hotkey_menubar("reset_properties") + "$Reset all properties|"+
											"/|-|"+
				                            inactive(current_song.selected = 0) + "Transpose notes outside octave range")
			}
			str = ""
			for (b = 0; b < 11; b += 1) {
				if (recent_song[b] = "") break
				c = floor(date_second_span(recent_song_time[b], date_current_datetime()))
				str += string_truncate(clean(filename_name(recent_song[b])), 310) + "|"
			}
			if (!isplayer) macos_create_menu_ext("File", "file", icon_menubar(icons.NEW)+get_hotkey_menubar("new_song") + "$New song|"+
				                        icon_menubar(icons.OPEN)+get_hotkey_menubar("open_song") + "$Open song...|Recent songs...|\\|" + str + condstr(recent_song[0] != "", "-|Clear recent songs") + condstr(recent_song[0] = "", "^!No recent songs") + "|/|-|"+
				                        icon_menubar(icons.SAVE)+get_hotkey_menubar("save_song") + "$Save song|"+
				                        icon_menubar(icons.SAVE_AS)+"Save song as a new file...|"+
										"Save options...|Restore unsaved files...|-|"+
										"Import...|\\|" + 
										inactive(current_song.selected != 0)+"Pattern...|"+
										"MIDI...|"+
										inactive(os_type != os_windows)+"Schematic...|"+
										"Reference audio...|Background image...|/|"+
										"Export...|\\|" +
										inactive(current_song.totalblocks = 0 || ds_list_size(current_song.instrument_list) <= first_custom_index) + icon_menubar(icons.INSTRUMENTS) + "Song with custom sounds...|" +
										inactive(current_song.selected = 0)+"Pattern...|" +
										inactive(current_song.totalblocks = 0) + "Audio track...|"+
										inactive(current_song.totalblocks = 0) + "Schematic...|"+
										inactive(current_song.totalblocks = 0) + "Track schematic...|"+
										inactive(current_song.totalblocks = 0) + "Branch schematic...|"+
										inactive(current_song.totalblocks = 0) + "Data pack...")
			else macos_create_menu_ext("File", "filep", icon_menubar(icons.OPEN)+get_hotkey_menubar("open_song") + "$Open song...|Recent songs...|\\|" + str + condstr(recent_song[0] != "", "-|Clear recent songs") + condstr(recent_song[0] = "", "^!No recent songs") + "|/|-|"+"Import from MIDI...|Import from schematic...|Import background image...|-|" + get_hotkey_menubar("exit") + "$Exit")
					
		} else {
			macos_create_menu_ext("帮助", "help", icon_menubar(icons.HELP) + "教程视频|\\|第 1 集：编写音符盒乐曲|第 2 集：打开 MIDI 文件|第 3 集：将乐曲导入进 Minecraft|第 4 集：编辑在 Minecraft 中创作的乐曲     |-|F1$观看所有|/|-|" + icon_menubar(icons.INTERNET) + "官方网站......|GitHub......|Discord 服务器......|反馈 bug......|QQ 群......|捐赠......|-|更新历史......|关于......")
			str = ""
			customstr = ""
			insmenu = 1
			for (a = 0; a < ds_list_size(current_song.instrument_list); a++) {
				var ins = current_song.instrument_list[| a];
				if (ins.user)
				    customstr += check(current_song.instrument = ins) + clean(ins.name) + "|"
				else{
					if(a < 10){
							str += check(current_song.instrument = ins) + get_hotkey_menubar("ins_ctrl") + string((a + 1) % 10) + "$" + clean(ins.name) + "|"
					}else{
						str += check(current_song.instrument = ins) + get_hotkey_menubar("ins_ctrl_shift") + string((a + 1) % 10) + "$" + clean(ins.name) + "|"
					}
				}
				if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
					customstr += "-|更多......|\\|"
					insmenu++
				}
			}
			if (!isplayer) macos_create_menu_ext("设置", "settings", "音色|\\|" + str + condstr(customstr != "", "-|") + customstr + string_repeat("/|", insmenu) +
				                icon_menubar(icons.INSTRUMENTS)+"音色设置......|从 Minecraft 游戏文件中获取音效......|/|-|" + icon_menubar(icons.INFORMATION) + "歌曲信息......|" + icon_menubar(icons.PROPERTIES) + "歌曲属性......|歌曲数据......|-|" + icon_menubar(icons.MIDI_INPUT) + "MIDI 设备管理器")
			else macos_create_menu_ext("设置", "settingsp", icon_menubar(icons.INFORMATION) + "歌曲信息......|" + "歌曲数据......")		
			if (!isplayer) {
				str = ""
				customstr = ""
				insmenu = 1
				for (a = 0; a < ds_list_size(current_song.instrument_list); a += 1) {
				    var ins = current_song.instrument_list[| a];
				    if (ins.user)
				        customstr += "...为 " + clean(ins.name) + "|"
				    else
				        str += "...为 " + clean(ins.name) + "|"
					if (a % 25 == 0 && a > 1 && a < ds_list_size(current_song.instrument_list) - 1) {
						customstr += "-|更多......|\\|"
						insmenu++
					}
				}
				macos_create_menu_ext("编辑", "edit", inactive(current_song.historypos = current_song.historylen) + icon_menubar(icons.UNDO - (current_song.historypos = current_song.historylen)) + get_hotkey_menubar("undo") + "$撤销|"+
				                            inactive(current_song.historypos = 0) + icon_menubar(icons.REDO - (current_song.historypos = 0)) + get_hotkey_menubar("redo") + "$重做|-|"+
				                            inactive(current_song.selected = 0) + icon_menubar(icons.COPY - (current_song.selected = 0)) + get_hotkey_menubar("copy") + "$复制|"+
				                            inactive(current_song.selected = 0) + icon_menubar(icons.CUT - (current_song.selected = 0)) + get_hotkey_menubar("cut") + "$剪切|"+
				                            inactive(selection_copied = "") + icon_menubar(icons.PASTE - (selection_copied = "")) + get_hotkey_menubar("paste") + "$粘贴|"+
				                            inactive(current_song.selected = 0) + icon_menubar(icons.DELETE - (current_song.selected = 0)) + get_hotkey_menubar("delete") + "$删除|-|"+
				                            inactive(current_song.totalblocks = 0) + get_hotkey_menubar("select_all") + "$全选|"+
				                            inactive(current_song.selected = 0) + "全不选|"+
				                            inactive(current_song.selected = 0 && current_song.totalblocks = 0) + get_hotkey_menubar("invert_selection") + "$选择反转|-|"+
				                            inactive(current_song.instrument.num_blocks = 0) + "选择所有 " + clean(current_song.instrument.name) + "|"+
				                            inactive(current_song.instrument.num_blocks = current_song.totalblocks) + "选择所有除了 " + clean(current_song.instrument.name) + "|-|"+
				                            inactive(current_song.selected = 0) + get_hotkey_menubar("action_1") + "$" + get_mode_actions(1) + "|"+
				                            inactive(current_song.selected = 0) + get_hotkey_menubar("action_2") + "$" + get_mode_actions(2) + "|"+
				                            inactive(current_song.selected = 0) + get_hotkey_menubar("action_3") + "$" + get_mode_actions(3) + "|"+
				                            inactive(current_song.selected = 0) + get_hotkey_menubar("action_4") + "$" + get_mode_actions(4) + "|"+
													condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey_menubar("action_5") + "$" + get_mode_actions(5) + "|") +
													condstr((editmode != m_key), inactive(current_song.selected = 0) + get_hotkey_menubar("action_6") + "$" + get_mode_actions(6) + "|") +
				                            inactive(current_song.selected = 0) + "更改音色......|\\|" + str + condstr(customstr != "", "-|") + customstr + string_repeat("/|", insmenu) + "-|" +
				                            inactive(current_song.selected = 0 || current_song.selection_l = 0) + "扩展选区|"+
				                            inactive(current_song.selected = 0 || current_song.selection_l = 0) + "压缩选区|"+
				                            inactive(current_song.selected = 0 || current_song.selection_l = 0) + "快捷键......|\\||"+ 
											get_hotkey_menubar("tremolo") + "$Tremolo...|"+
											get_hotkey_menubar("stereo") + "$Stereo...|"+
											get_hotkey_menubar("arpeggio") + "$Arpeggio...|"+
											get_hotkey_menubar("portamento") + "$Portamento...|"+
											get_hotkey_menubar("vibrato") + "$Vibrato|"+
											get_hotkey_menubar("stagger") + "$Stagger...|"+
											get_hotkey_menubar("chorus") + "$Chorus|"+
											get_hotkey_menubar("volume_lfo") + "$Volume LFO|"+
											get_hotkey_menubar("fade_in") + "$淡入|"+
											get_hotkey_menubar("fade_out") + "$淡出|"+
											get_hotkey_menubar("replace_key") + "$替换音|"+
											get_hotkey_menubar("set_velocity") + "$设定音量......|"+
											get_hotkey_menubar("set_panning") + "$设定声道......|"+
											get_hotkey_menubar("set_pitch") + "$设定音高......|"+
											get_hotkey_menubar("reset_properties") + "$重置所有属性|"+
											"/|-|"+
				                            inactive(current_song.selected = 0) + "转换所有超出八度范围的音符")
			}
			str = ""
			for (b = 0; b < 11; b += 1) {
				if (recent_song[b] = "") break
				c = floor(date_second_span(recent_song_time[b], date_current_datetime()))
				str += string_truncate(clean(filename_name(recent_song[b])), 310) + "|"
			}
			if (!isplayer) macos_create_menu_ext("文件", "file", icon_menubar(icons.NEW)+get_hotkey_menubar("new_song") + "$新文件|"+
				                        icon_menubar(icons.OPEN)+get_hotkey_menubar("open_song") + "$打开歌曲......|最近歌曲......|\\|" + str + condstr(recent_song[0] != "", "-|清除最近歌曲") + condstr(recent_song[0] = "", "^!无最近歌曲") + "|/|-|"+
				                        icon_menubar(icons.SAVE)+get_hotkey_menubar("save_song") + "$保存歌曲|"+
				                        icon_menubar(icons.SAVE_AS)+"另存为|"+
										"保存选项......|恢复未保存的歌曲......|-|" +
										"导入......|\\|"+
										inactive(current_song.selected != 0)+"片段......|"+
										"MIDI 文件......|"+
										inactive(os_type != os_windows)+"Schematic 文件......|"+
										"参考音频......|背景图片......|/|"+
										"导出......|\\|"+
										inactive(current_song.totalblocks = 0 || ds_list_size(current_song.instrument_list) <= first_custom_index) + icon_menubar(icons.INSTRUMENTS) + "带自定义音色的歌曲......|"+
										inactive(current_song.selected = 0)+"片段......|"+
										inactive(current_song.totalblocks = 0) + "音频文件......|"+
										inactive(current_song.totalblocks = 0) + "结构......|"+
										inactive(current_song.totalblocks = 0) + "直轨结构......|"+
										inactive(current_song.totalblocks = 0) + "分支结构......|"+
										inactive(current_song.totalblocks = 0) + "数据包......")
			else macos_create_menu_ext("文件", "filep", icon_menubar(icons.OPEN)+get_hotkey_menubar("open_song") + "$打开歌曲......|最近歌曲......|\\|" + str + condstr(recent_song[0] != "", "-|清除最近歌曲") + condstr(recent_song[0] = "", "^!无最近歌曲") + "|/|-|"+"从 MIDI 文件导入......|从 Schematic 文件导入......|导入背景图片......|-|" + get_hotkey_menubar("exit") + "$退出")
				
		}
	}
}