function calculate_size() {
	var a, b, c;
	if (language != 1) {
	if (warning_schematic == 0) {
		message("The exported schematic is currently only compatible with Minecraft: Java Edition 1.12 and below. To import it in 1.13 and above, please use the export to structure block function.\n\nThis warning will never be shown again.", "Warning")
		warning_schematic = 1
		save_settings()
	}
	if (songs[song].block_outside > 0) {
	    if (!question("Some note blocks are outside of Minecraft's 2 octave limit. Do you want to export a Schematic anyway, ignoring the affected blocks?", "Minecraft Compatibility")) return 0
	}
	if (songs[song].block_custom > 0) {
	    if (!question("Some note blocks have a custom instrument assigned to them. Export anyway?", "Minecraft Compatibility")) return 0
	}
	if (songs[song].block_pitched > 0) {
	    if (!question("Some note blocks have fine pitch tuning, which isn't supported in note blocks. Export anyway?", "Minecraft Compatibility")) return 0
	}
	if (songs[song].real_tempo != 10 && songs[song].real_tempo != 5 && songs[song].real_tempo != 2.5) {
	    message("The tempo of the song is not compatible with Minecraft. As a result, the playback speed of the song in-game will differ from the one in the program.", "Tempo")
	}
	selection_place(0)
	if (songs[song].totalblocks - songs[song].block_outside <= 0) {
	    message("There are no blocks to export!", "Error")
	    return 0
	}
	} else {
	if (warning_schematic == 0) {
		message("导出的 schematic 目前之和 Minecraft: Java Edition 1.12 及以下兼容。如想在 1.13 和以上使用，请使用结构方块格式导出。\n\n此警告将不再提示。", "警告")
		warning_schematic = 1
		save_settings()
	}
	if (songs[song].block_outside > 0) {
	    if (!question("一些方块在 Minecraft 的2八度范围外。你想无视这些方块导出 Schematic 吗？", "Minecraft 兼容性")) return 0
	}
	if (songs[song].block_custom > 0) {
	    if (!question("一些方块带有自定义音色。继续导出吗？", "Minecraft 兼容性")) return 0
	}
	if (songs[song].block_pitched > 0) {
	    if (!question("一些方块带有音符盒不支持的微分音。继续导出吗？", "Minecraft 兼容性")) return 0
	}
	if (songs[song].real_tempo != 10 && songs[song].real_tempo != 5 && songs[song].real_tempo != 2.5) {
	    message("歌曲的速度与 Minecraft 不兼容。所以，在游戏内的播放会和软件内的有差别。", "速度")
	}
	selection_place(0)
	if (songs[song].totalblocks - songs[song].block_outside <= 0) {
	    message("没有方块可以导出！", "错误")
	    return 0
	}
	}
	// x = include locked
	// y = tempo
	sch_exp_enda[0] = 0
	sch_exp_enda[1] = 0
	sch_exp_totalblocks[0] = 0
	sch_exp_totalblocks[1] = 0
	sch_exp_repeaters[0, 0] = 0
	sch_exp_repeaters[0, 1] = 0
	sch_exp_repeaters[0, 2] = 0
	sch_exp_repeaters[1, 0] = 0
	sch_exp_repeaters[1, 1] = 0
	sch_exp_repeaters[1, 2] = 0

	// x = compress layers
	sch_exp_maxheight[0] = 0
	sch_exp_maxheight[1] = 0

	var sch_colamount, cnt;
	// Calculate locked layers
	calculate_locked_layers()

	// Calculate maximum height and note block count
	for (a = 0; a <= songs[song].enda; a += 1) {
	    if (songs[song].colamount[a] > 0) {
	        c = 0
	        d = 0
	        for (b = songs[song].colfirst[a]; b <= songs[song].collast[a]; b += 1) {
	            if (songs[song].song_exists[a, b]) {
	                if (songs[song].song_key[a, b] > 32 && songs[song].song_key[a, b] < 58) {
	                    c += 1
	                    sch_exp_totalblocks[1] += 1
	                    if (lockedlayer[b] = 0) {
	                        d += 1
	                        sch_exp_totalblocks[0] += 1
	                    }
	                }
	            }
	        }
	        sch_exp_maxheight[0] = max(sch_exp_maxheight[0], songs[song].collast[a]) // Don't compress
	        sch_exp_maxheight[1] = max(sch_exp_maxheight[1], c) // Compress
	        sch_colamount[1, a] = c
	        sch_colamount[0, a] = d
	        if (c > 0) scp_exp_enda[1] = a
	        if (d > 0) scp_exp_enda[0] = a
	    }
	}

	// Calculate amount of repeaters
	cnt[0, 0] = 0 // 1 repeater = 4 ticks
	cnt[0, 1] = 0 // 1 repeater = 2 ticks
	cnt[0, 2] = 0 // 1 repeater = 1 tick
	cnt[1, 0] = 0
	cnt[1, 1] = 0
	cnt[1, 2] = 0
	for (a = 0; a <= songs[song].enda; a += 1) {
	    for (b = 0; b < 2; b += 1) {
	        if (a <= scp_exp_enda[b]) {
	            sch_exp_repeaters[b, 2] += 1
	            if (sch_colamount[b, a] > 0) {
	                sch_exp_repeaters[b, 0] += 1
	                cnt[b, 0] = 0
	                sch_exp_repeaters[b, 1] += 1
	                cnt[b, 1] = 0
	            } else {
	                cnt[b, 0] += 1
	                cnt[b, 1] += 1
	            }
	            if (cnt[b, 0] = 4) {
	                sch_exp_repeaters[b, 0] += 1
	                cnt[b, 0] = 0
	            }
	            if (cnt[b, 1] = 2) {
	                sch_exp_repeaters[b, 1] += 1
	                cnt[b, 1] = 0
	            }
	        }
	    }
	}
	sch_exp_tempo = 0 // 0 = 10, 1 = 5, 2 = 2.5
	if (songs[song].real_tempo > 10) sch_exp_tempo = 0
	if (songs[song].real_tempo < 10) sch_exp_tempo = 0
	if (songs[song].real_tempo < 7.5) sch_exp_tempo = 1
	if (songs[song].real_tempo < 3.75) sch_exp_tempo = 2
	return 1



}
