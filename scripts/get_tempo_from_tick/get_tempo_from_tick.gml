function get_tempo_from_tick(tick) {
	for (var i = 1; i < array_length(songs[song].tempo_changes); i++) {
		if (tick < songs[song].tempo_changes[i][0]) return songs[song].tempo_changes[i - 1][1]
	}
	return songs[song].tempo_changes[array_length(songs[song].tempo_changes) - 1][1]
}