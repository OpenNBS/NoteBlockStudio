function load_reference_audio(){
	var fn = string(get_open_filename_ext("Supported sounds (*.ogg;*.wav)|*.ogg;*.wav", "", songfolder, condstr(language != 1, "Load reference audio", "打开参考音频")))
	if (fn = "" || !file_exists_lib(fn)) return 0
	// Ogg is a container; FLAC and Opus streams cannot be played by the Vorbis decoder.
	if (string_lower(filename_ext(fn)) == ".ogg" && !reference_audio_is_vorbis(fn)) {
		if (language != 1) message("This file is not a supported Ogg Vorbis file. Please export it as Ogg Vorbis or an 8-bit/16-bit PCM WAV file.", "Unsupported audio format")
		else message("此文件不是受支持的 Ogg Vorbis 音频。请将其导出为 Ogg Vorbis 或 8 位/16 位 PCM WAV 文件。", "不支持的音频格式")
		return 0
	}
	audio_destroy_stream(songs[song].reference_audio)
	audio_free_buffer_sound(songs[song].reference_audio)
	buffer_delete(songs[song].reference_audio_buffer)
	global.__temp_audio_buffer__ = -1
	songs[song].reference_audio_buffer = -1
	songs[song].reference_audio_file = ""
	songs[song].reference_audio = -1
	songs[song].reference_option = 2
	songs[song].reference_offset = 0
	songs[song].reference_sound = -1
	songs[song].reference_state = 0
	songs[song].reference_has_last_position = false
	songs[song].reference_last_position = 0
	songs[song].reference_volume = 100
	songs[song].reference_audio_file = fn
	songs[song].reference_audio = -1
	if (string_lower(filename_ext(songs[song].reference_audio_file)) == ".ogg") {
		songs[song].reference_audio = audio_create_stream(songs[song].reference_audio_file)
	} else if (string_lower(filename_ext(songs[song].reference_audio_file)) == ".wav") {
		songs[song].reference_audio = wav_load_buffer(songs[song].reference_audio_file)
	}
	songs[song].reference_audio_buffer = global.__temp_audio_buffer__
	if (songs[song].reference_audio < 0) {
		if (language != 1) message("Couldn't load the file", "Error")
		else message("文件加载失败", "错误")
		songs[song].reference_audio_file = ""
		songs[song].reference_audio = -1
	}
}

function reference_audio_is_vorbis(path) {
	var file = file_bin_open(path, 0)
	if (file < 0) return false
	var size = file_bin_size(file)
	var pos = 0
	var is_vorbis = false

	// Inspect the initial stream headers only, including multiplexed Ogg files.
	while (pos + 27 <= size) {
		file_bin_seek(file, pos)
		var capture = ""
		for (var i = 0; i < 4; i++) capture += chr(file_bin_read_byte(file))
		if (capture != "OggS") break
		if (file_bin_read_byte(file) != 0) break
		var flags = file_bin_read_byte(file)
		if ((flags & 2) == 0 || (flags & 1) != 0) break

		file_bin_seek(file, pos + 26)
		var segments = file_bin_read_byte(file)
		var body = pos + 27 + segments
		if (segments == 0 || body > size) break
		var first_segment = file_bin_read_byte(file)
		var body_size = first_segment
		for (var i = 1; i < segments; i++) body_size += file_bin_read_byte(file)
		if (body + body_size > size) break

		if (first_segment >= 7) {
			file_bin_seek(file, body)
			var packet_type = file_bin_read_byte(file)
			var codec = ""
			for (var i = 0; i < 6; i++) codec += chr(file_bin_read_byte(file))
			if (packet_type == 1 && codec == "vorbis") {
				is_vorbis = true
				break
			}
		}
		pos = body + body_size
	}

	file_bin_close(file)
	return is_vorbis
}
