function reference_audio_sync(song_instance, force_resync) {
	var state_stopped = 0
	var state_waiting = 1
	var state_playing = 2
	var state_finished = 3

	if (playing <= 0 || song_instance.reference_option <= 0 || song_instance.reference_audio < 0) {
		reference_audio_stop(song_instance)
		return
	}

	var target_position = get_seconds_from_tick(song_instance.marker_pos) + song_instance.reference_offset / 1000
	var moved_back = song_instance.reference_has_last_position && target_position < song_instance.reference_last_position - 0.05
	song_instance.reference_last_position = target_position
	song_instance.reference_has_last_position = true

	// A negative track position represents silence before the reference audio starts.
	if (target_position < 0) {
		if (song_instance.reference_sound >= 0 && audio_is_playing(song_instance.reference_sound)) {
			audio_stop_sound(song_instance.reference_sound)
		}
		song_instance.reference_sound = -1
		song_instance.reference_state = state_waiting
		return
	}

	var reference_length = audio_sound_length(song_instance.reference_audio)
	if (reference_length > 0 && target_position >= reference_length) {
		if (song_instance.reference_sound >= 0 && audio_is_playing(song_instance.reference_sound)) {
			audio_stop_sound(song_instance.reference_sound)
		}
		song_instance.reference_sound = -1
		song_instance.reference_state = state_finished
		return
	}

	force_resync = force_resync || moved_back
	if (song_instance.reference_state == state_playing) {
		if (!audio_is_playing(song_instance.reference_sound)) {
			song_instance.reference_sound = -1
			song_instance.reference_state = state_finished
		} else {
			var actual_position = audio_sound_get_track_position(song_instance.reference_sound)
			if (force_resync || abs(actual_position - target_position) > 0.1) {
				audio_sound_set_track_position(song_instance.reference_sound, target_position)
			}
			audio_sound_gain(song_instance.reference_sound, (song_instance.reference_volume * mastervol) / 100, 0)
			return
		}
	}

	if (force_resync && song_instance.reference_state == state_finished) {
		song_instance.reference_state = state_stopped
	}
	if (song_instance.reference_state == state_finished) return

	audio_sound_gain(song_instance.reference_audio, (song_instance.reference_volume * mastervol) / 100, 0)
	song_instance.reference_sound = audio_play_sound(song_instance.reference_audio, 1, 0)
	if (song_instance.reference_sound >= 0) {
		audio_sound_set_track_position(song_instance.reference_sound, target_position)
		song_instance.reference_state = state_playing
	} else {
		song_instance.reference_state = state_finished
	}
}