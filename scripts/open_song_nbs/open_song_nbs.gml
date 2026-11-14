function open_song_nbs(fn, sounds_path = "", safeopen = false, replace = false, metadata_path = "") {
	// Parse into temporary data before creating/replacing a tab or resetting the UI.
	// Keep the buffer local: confirming a replacement may save another song.
	var source = -1
	var parsed = undefined
	var error_text = ""
	var reading_metadata = false
	try {
		source = buffer_import(fn)
		if (source < 0) throw("nbs_access_failed")
		parsed = nbs_parse_buffer(source, fn, safeopen)
		if (metadata_path != "") {
			reading_metadata = true
			var metadata_text = load_text(metadata_path)
			if (!is_string(metadata_text)) throw("Could not read song ZIP metadata")
			song_zip_restore_metadata(parsed, source, json_parse(metadata_text))
		}
	} catch (error) {
		show_debug_message("Failed to open NBS song: " + string(error))
		if (source < 0) {
			error_text = condstr(language != 1,
				"Error: Failed to access file. Note Block Studio may not have permission to access the directory.\nPlease try again using the file browser.",
				"错误：访问文件失败。Note Block Studio 可能没有权限访问该目录。\n请通过文件浏览器重试。")
		} else if (reading_metadata) {
			error_text = condstr(language != 1,
				"The song ZIP contains unreadable, unsupported, or mismatched Minecraft sound mappings.\n\nYour existing songs have not been changed.",
				"歌曲 ZIP 中的 Minecraft 声音事件映射无法读取、版本不受支持或与歌曲不匹配。\n\n现有歌曲未被更改。")
		} else if (is_string(error) && error == "nbs_unsupported_version") {
			error_text = condstr(language != 1,
				"This NBS file was created in a later version of Note Block Studio.\nPlease save the song as a version " + string(nbs_version) + " file or lower via the Save Options menu.",
				"此 NBS 文件由新版 Note Block Studio 创建。\n请用保存选项菜单将其保存为 " + string(nbs_version) + " 版本或以下。")
		} else {
			error_text = condstr(language != 1,
				"This song could not be opened because the NBS file is invalid or incomplete.\n\nYour existing songs have not been changed.",
				"此 NBS 文件无效或不完整，无法打开。\n\n现有歌曲未被更改。")
		}
	}
	if (source >= 0) buffer_delete(source)
	if (error_text != "") {
		message(error_text, condstr(language != 1, "Load failed", "打开失败"))
		return -1
	}

	if (show_oldwarning && parsed.properties.song_nbs_version < nbs_version && !isplayer) {
		message(condstr(language != 1,
			"Warning: You are opening an older NBS file. Saving this file will make it incompatible with older Note Block Studio versions.",
			"警告：你正在打开旧版的 NBS 文件。保存此文件会使其与旧版 Note Block Studio 不兼容。"),
			condstr(language != 1, "Warning", "警告"))
	}
	if (replace && !close_song(0, 1)) return -1
	var newsong = create(obj_song)
	array_push(songs, newsong)
	set_song(array_length(songs) - 1)
	reset_add()

	var fields = variable_struct_get_names(parsed.properties)
	for (var i = 0; i < array_length(fields); i++) {
		variable_instance_set(newsong, fields[i], variable_struct_get(parsed.properties, fields[i]))
	}

	// Add blocks in reverse order to improve performance.
	for (var i = array_length(parsed.notes) - 1; i >= 0; --i) {
		var note = parsed.notes[i]
		add_block(note.a, note.b, note.ins, note.key, note.vel, note.pan, note.pit, true)
	}
	for (var b = 0; b < array_length(parsed.layers); b++) {
		var layer_data = parsed.layers[b]
		newsong.layername[b] = layer_data.name
		newsong.layerlock[b] = layer_data.locked
		newsong.layervol[b] = layer_data.volume
		newsong.layerstereo[b] = layer_data.stereo
		text_exists[400 + b] = 1
		newsong.text_exists_song[400 + b] = 1
		text_str[400 + b] = layer_data.name
		newsong.text_str_song[400 + b] = layer_data.name
		text_laststr[400 + b] = "-"
		if (layer_data.volume < 100) realvolume = 1
		newsong.endb2++
	}

	// Preserve v5 when upgrading its 237-240 custom instruments to v6 would
	// overflow the one-byte note instrument ID.
	if (newsong.song_nbs_version == 5 && array_length(parsed.instruments) > nbs_custom_instrument_limit(6)) newsong.save_version = 5
	var missing_sounds = ""
	for (var b = 0; b < array_length(parsed.instruments); b++) {
		var custom = parsed.instruments[b]
		var ins = new_instrument(custom.name, custom.filename, true, custom.press, custom.key)
		if (variable_struct_exists(custom, "minecraft_sound")) {
			ins.minecraft_sound = custom.minecraft_sound
			ins.minecraft_sound_manual = custom.minecraft_sound_manual
		}
		ds_list_add(newsong.instrument_list, ins)
		with (ins) {
			if (!instrument_load(sounds_path) && custom.filename != "") missing_sounds += custom.filename + "\n"
		}
	}
	if (missing_sounds != "") {
		if (question(condstr(language != 1,
			"This song uses custom instruments. However, some sounds could not be loaded:\n\n" + missing_sounds + "\nMake sure that you have put the sounds in the \"Sounds\" folder. Open Instrument settings?",
			"此歌曲使用自定义音色。但是一些音色未能被加载：\n\n" + missing_sounds + "\n确保您已将声音文件放到“Sounds”文件夹。打开音色设置吗？"),
			condstr(language != 1, "Error", "错误"))) window = w_instruments
	}
	if (is_struct(minecraft_export_sounds_json)) resourcepack_auto_map_custom_sounds(minecraft_export_pack_root, minecraft_export_sounds_json)
	return newsong
}

function nbs_read_value(source, type) {
	// Check before buffer_read: an out-of-bounds read is a fatal runner error.
	if (buffer_sizeof(type) > buffer_get_size(source) - buffer_tell(source)) throw("Unexpected end of NBS file")
	return buffer_read(source, type)
}

function nbs_read_string(source) {
	var length = nbs_read_value(source, buffer_s32)
	if (length < 0 || length > buffer_get_size(source) - buffer_tell(source)) throw("Invalid NBS string length")
	var result = ""
	// Preserve the existing byte-to-character decoding used by NBS strings.
	repeat (length) result += chr(buffer_read(source, buffer_u8))
	return result
}

function nbs_parse_buffer(source, fn, safeopen = false) {
	// This stage must not create instances, load sounds, or change editor state.
	var properties = {
		song_nbs_version: 0,
		loop: 0,
		loop_session: 0,
		loopmax: 0,
		loopstart: 0,
	}
	var parsed = {properties: properties, notes: [], layers: [], instruments: []}
	var song_first_custom_index = 0
	var custom_index_diff = 0
	var format4beta = string_count("format4beta", filename_name(fn)) == 1
	if (nbs_read_value(source, buffer_s16) == 0) {
		properties.song_nbs_version = nbs_read_value(source, buffer_u8)
		if (properties.song_nbs_version > nbs_version) throw("nbs_unsupported_version")
		song_first_custom_index = nbs_read_value(source, buffer_u8)
		custom_index_diff = first_custom_index - song_first_custom_index
		if (properties.song_nbs_version >= 3) nbs_read_value(source, buffer_s16)
	} else if (safeopen) {
		throw("Invalid NBS header")
	}
	var format_version = properties.song_nbs_version
	var height = nbs_read_value(source, buffer_s16)
	if (height < 0) throw("Invalid NBS layer count")
	properties.song_name = nbs_read_string(source)
	properties.song_author = nbs_read_string(source)
	properties.song_orauthor = nbs_read_string(source)
	properties.song_desc = nbs_read_string(source)
	properties.real_tempo = nbs_read_value(source, buffer_s16) / 100
	nbs_read_value(source, buffer_u8) // Autosave (deprecated)
	nbs_read_value(source, buffer_u8) // Autosave minutes (deprecated)
	properties.timesignature = median(2, nbs_read_value(source, buffer_u8), 8)
	properties.work_mins = max(0, nbs_read_value(source, buffer_s32))
	properties.work_left = max(0, nbs_read_value(source, buffer_s32))
	properties.work_right = max(0, nbs_read_value(source, buffer_s32))
	properties.work_add = max(0, nbs_read_value(source, buffer_s32))
	properties.work_remove = max(0, nbs_read_value(source, buffer_s32))
	properties.song_midi = nbs_read_string(source)
	if (format_version >= 4) {
		properties.loop = nbs_read_value(source, buffer_u8)
		properties.loop_session = properties.loop
		if (format4beta) {
			properties.loopstart = nbs_read_value(source, buffer_u8)
		} else {
			properties.loopmax = nbs_read_value(source, buffer_u8)
			properties.loopstart = nbs_read_value(source, buffer_s16)
		}
	}

	var notes = []
	var notes_at = 0
	var tick = -1
	while (true) {
		var jump = nbs_read_value(source, buffer_s16)
		if (jump == 0) break
		if (jump < 0) throw("Invalid NBS tick jump")
		tick += jump
		var row = -1
		while (true) {
			jump = nbs_read_value(source, buffer_s16)
			if (jump == 0) break
			if (jump < 0) throw("Invalid NBS layer jump")
			row += jump
			var ins = nbs_read_value(source, buffer_u8)
			if (ins >= song_first_custom_index) ins += custom_index_diff
			var key = nbs_read_value(source, buffer_u8)
			var vel = 100
			var pan = 100
			var pit = 0
			if (format_version >= 4) {
				vel = nbs_read_value(source, buffer_u8)
				pan = nbs_read_value(source, buffer_u8)
				pit = nbs_read_value(source, buffer_s16)
			}
			array_grow_then_set(notes, notes_at++, {a: tick, b: row, ins: ins, key: median(0, key, 87), vel: vel, pan: pan, pit: pit})
		}
	}
	array_resize(notes, notes_at)
	parsed.notes = notes

	// NBS permits ending after all notes or all layers, but never mid-section.
	if (buffer_tell(source) == buffer_get_size(source)) return parsed
	for (var b = 0; b < height; b++) {
		var name = nbs_read_string(source)
		var locked = 0
		if (format_version >= 4 && !format4beta) locked = nbs_read_value(source, buffer_u8)
		var volume = median(0, nbs_read_value(source, buffer_u8), 100)
		var stereo = 100
		if (format_version >= 2) stereo = nbs_read_value(source, buffer_u8)
		array_push(parsed.layers, {name: name, locked: locked, volume: volume, stereo: stereo})
	}
	if (buffer_tell(source) == buffer_get_size(source)) return parsed
	var count = nbs_read_value(source, buffer_u8)
	for (var b = 0; b < count; b++) {
		var name = nbs_read_string(source)
		var filename = nbs_read_string(source)
		var key = nbs_read_value(source, buffer_u8)
		var press = nbs_read_value(source, buffer_u8)
		array_push(parsed.instruments, {name: name, filename: filename, key: key, press: press})
	}
	return parsed
}
