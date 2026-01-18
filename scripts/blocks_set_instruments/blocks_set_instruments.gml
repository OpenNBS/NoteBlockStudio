/// @description  blocks_set_instruments()
/// @function  blocks_set_instruments
function blocks_set_instruments() {

	var a, b;

	for (a = 0; a <= songs[song].enda; a += 1) {
	    if (songs[song].colamount[a] > 0) {
	        for (b = 0; b <= songs[song].collast[a]; b += 1) {
	            if (songs[song].song_exists[a, b]) {
	                songs[song].song_ins[a, b] = songs[song].instrument_list[| songs[song].song_ins[a, b]]
	                songs[song].song_ins[a, b].num_blocks++
	                if (songs[song].song_ins[a, b].user) songs[song].block_custom++
	            }
	        }
	    }
	}



}
