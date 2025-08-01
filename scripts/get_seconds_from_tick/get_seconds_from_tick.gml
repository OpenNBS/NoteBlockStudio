function get_seconds_from_tick(tick) {
    var seconds = 0.0;
    var tc      = songs[song].tempo_changes;
    var len     = array_length(tc);

    for (var i = 1; i < len; i++) {
        var seg_start = tc[i - 1][0];
        var seg_tps   = tc[i - 1][1];           // ticks-per-second

        if (tick < tc[i][0]) {                  // inside this segment
            seconds += (tick - seg_start) / seg_tps;
            return seconds;
        }

        // full segment
        seconds += (tc[i][0] - seg_start) / seg_tps;
    }

    // after last tempo change
    var last_tps = tc[len - 1][1];
    seconds += (tick - tc[len - 1][0]) / last_tps;
    return seconds;
}