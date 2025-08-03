function load_reference_audio(){
	audio_destroy_stream(songs[song].reference_audio)
	audio_free_buffer_sound(songs[song].reference_audio)
	buffer_delete(global.__temp_audio_buffer__)
	global.__temp_audio_buffer__ = -1
	songs[song].reference_audio_file = ""
	songs[song].reference_audio = -1
	songs[song].reference_option = 2
	songs[song].reference_offset = 0
	songs[song].reference_sound = -1
	songs[song].reference_volume = 100
	songs[song].reference_audio_file = string(get_open_filename_ext("Supported sounds (*.ogg;*.wav)|*.ogg;*.wav", "", songfolder, condstr(language != 1, "Load reference audio", "打开参考音频")))
	songs[song].reference_audio = -1
	if (filename_ext(songs[song].reference_audio_file) == ".ogg") {
		songs[song].reference_audio = audio_create_stream(songs[song].reference_audio_file)
	} else if (filename_ext(songs[song].reference_audio_file) == ".wav") {
		songs[song].reference_audio = wav_load_buffer(songs[song].reference_audio_file)
	}
	if (songs[song].reference_audio < 0) {
		if (language != 1) message("Couldn't load the file", "Error")
		else message("文件加载失败", "错误")
		songs[song].reference_audio_file = ""
		songs[song].reference_audio = -1
	}
}