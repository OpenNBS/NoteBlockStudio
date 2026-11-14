function reference_audio_stop(song_instance) {
	if (song_instance.reference_sound >= 0 && audio_is_playing(song_instance.reference_sound)) {
		audio_stop_sound(song_instance.reference_sound)
	}
	song_instance.reference_sound = -1
	song_instance.reference_state = 0
	song_instance.reference_has_last_position = false
}

function reference_audio_free(song_instance) {
	reference_audio_stop(song_instance)
	if (song_instance.reference_audio >= 0) {
		audio_stop_sound(song_instance.reference_audio)
		// WAV sounds must release their buffer reference before the buffer is deleted.
		if (song_instance.reference_audio_buffer >= 0) audio_free_buffer_sound(song_instance.reference_audio)
		else audio_destroy_stream(song_instance.reference_audio)
	}
	if (song_instance.reference_audio_buffer >= 0 && buffer_exists(song_instance.reference_audio_buffer)) {
		buffer_delete(song_instance.reference_audio_buffer)
	}
	song_instance.reference_audio = -1
	song_instance.reference_audio_buffer = -1
	song_instance.reference_audio_file = ""
}
