function reference_audio_stop(song_instance) {
	if (song_instance.reference_sound >= 0 && audio_is_playing(song_instance.reference_sound)) {
		audio_stop_sound(song_instance.reference_sound)
	}
	song_instance.reference_sound = -1
	song_instance.reference_state = 0
	song_instance.reference_has_last_position = false
}
