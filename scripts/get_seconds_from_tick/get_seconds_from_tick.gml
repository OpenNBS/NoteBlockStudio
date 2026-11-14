// Find the last tempo change at or before a tick without scanning the song.
function get_tempo_change_index(tick) {
	var tc = songs[song].tempo_changes
	var low = 0
	var high = array_length(tc) - 1
	while (low < high) {
		var middle = floor((low + high + 1) / 2)
		if (tc[middle][0] <= tick) low = middle
		else high = middle - 1
	}
	return low
}

function get_seconds_from_tick(tick) {
	var entry = songs[song].tempo_changes[get_tempo_change_index(tick)]
	return entry[2] + (tick - entry[0]) / entry[1]
}
