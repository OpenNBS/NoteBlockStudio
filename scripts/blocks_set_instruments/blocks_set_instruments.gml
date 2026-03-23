/// @description  blocks_set_instruments()
/// @function  blocks_set_instruments
function blocks_set_instruments() {

	var a, b;
	var invalid_ins = 0

	for (a = 0; a <= songs[song].enda; a += 1) {
	    if (songs[song].colamount[a] > 0) {
	        for (b = 0; b <= songs[song].collast[a]; b += 1) {
	            if (songs[song].song_exists[a, b]) {
	                songs[song].song_ins[a, b] = songs[song].instrument_list[| songs[song].song_ins[a, b]]
					if (!instance_exists(songs[song].song_ins[a, b])) {
						songs[song].song_ins[a, b] = songs[song].instrument_list[| 0]
						invalid_ins = 1
					}
	                songs[song].song_ins[a, b].num_blocks++
	                if (songs[song].song_ins[a, b].user) songs[song].block_custom++
	            }
	        }
	    }
	}
	
	if (invalid_ins) {
		if (language = 0) message("Notes with invalid instrument values exist in this song, they will be replaced with Harp.", "Load Song")
		else message("歌曲内存在有非法音色值的音符，这些音符会被 Harp 替换。", "打开歌曲")
	}



}
