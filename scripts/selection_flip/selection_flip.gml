function selection_flip(flipVertically){
	//if flipVertical is true, well, it'll flip the selection vertically. Otherwise, horizontally.

	var row, column, current_song, str;

	var old_ins, old_key, old_vel, old_pan, old_pit, old_exists;
	
	current_song = songs[song];

	str = current_song.selection_code;

	// expand all the column properites before flipping
	for (var i = 0; i < current_song.selection_l; i++) {
				
		for (var j = current_song.selection_colfirst[i]; j < current_song.selection_h; j++) {
			if (j < 0 || current_song.selection_exists[i, j]) continue;
					
			current_song.selection_colfirst[i] = -1
			current_song.selection_collast[i] = -1
			current_song.selection_exists[i, j] = 0
			current_song.selection_ins[i, j] = 0
			current_song.selection_key[i, j] = 0
			current_song.selection_vel[i, j] = 0
			current_song.selection_pan[i, j] = 0
			current_song.selection_pit[i, j] = 0
		}
	}
	
	
	
	if (flipVertically)
	// vertical flip
	for (column = 0; column < current_song.selection_l; column++) {
	    for (row = 0; row < current_song.selection_h / 2; row++) {
			var target_row = current_song.selection_h - row - 1;
			
			old_ins    = current_song.selection_ins[column, row];
			old_key    = current_song.selection_key[column, row];
			old_vel    = current_song.selection_vel[column, row];
			old_pan    = current_song.selection_pan[column, row];
			old_pit	   = current_song.selection_pit[column, row];
			old_exists = current_song.selection_exists[column,row];
					
			current_song.selection_ins[column, row] = current_song.selection_ins[column, target_row];
			current_song.selection_ins[column, target_row] = old_ins;
					
			current_song.selection_key[column, row] = current_song.selection_key[column, target_row];
			current_song.selection_key[column, target_row] = old_key;
					
			current_song.selection_vel[column, row] = current_song.selection_vel[column, target_row];
			current_song.selection_vel[column, target_row] = old_vel;
					
			current_song.selection_pan[column, row] = current_song.selection_pan[column, target_row];
			current_song.selection_pan[column, target_row] = old_pan;
					
			current_song.selection_pit[column, row] = current_song.selection_pit[column, target_row];
			current_song.selection_pit[column, target_row] = old_pit;

			current_song.selection_exists[column, row] = current_song.selection_exists[column, target_row];
			current_song.selection_exists[column, target_row] = old_exists;
	    }
	}
	else
	// horizontal flip
	for (column = 0; column < current_song.selection_l / 2; column++) {
	    for (row = 0; row < current_song.selection_h; row++) {
			var target_column =  current_song.selection_l - column - 1;
					
			old_ins    = current_song.selection_ins[column, row];
			old_key    = current_song.selection_key[column, row];
			old_vel    = current_song.selection_vel[column, row];
			old_pan    = current_song.selection_pan[column, row];
			old_pit    = current_song.selection_pit[column, row];
			old_exists = current_song.selection_exists[column, row];
					
			current_song.selection_ins[column, row] = current_song.selection_ins[target_column, row];
			current_song.selection_ins[target_column, row] = old_ins;
					
			current_song.selection_key[column, row] = current_song.selection_key[target_column, row];
			current_song.selection_key[target_column, row] = old_key;
					
			current_song.selection_vel[column, row] = current_song.selection_vel[target_column, row];
			current_song.selection_vel[target_column, row] = old_vel;
					
			current_song.selection_pan[column, row] = current_song.selection_pan[target_column, row];
			current_song.selection_pan[target_column, row] = old_pan;
					
			current_song.selection_pit[column, row] = current_song.selection_pit[target_column, row];
			current_song.selection_pit[target_column, row] = old_pit;
			
			current_song.selection_exists[column, row] = current_song.selection_exists[target_column, row];
			current_song.selection_exists[target_column, row] = old_exists;
	    }
	}

	// find the fist row number in the columns
	for (var i = 0; i < current_song.selection_l; i++) {
		for (var j = 0; j < current_song.selection_h; j++) {
			if (current_song.selection_exists[i,j]) {
				current_song.selection_colfirst[i] = j;
				break;
			}
		}
	}

	// find the last row number in the columns
	for (var i = current_song.selection_l; i >= 0; i--) {
		for (var j = current_song.selection_h; j >= 0; j--) {
			if (current_song.selection_exists[i,j]) {
				current_song.selection_collast[i] = j;
				break;
			}
		}
	}
	
	selection_trim();
	
	selection_code_update();
	history_set(h_selectchange, current_song.selection_x, current_song.selection_y, current_song.selection_code, current_song.selection_x, current_song.selection_y, str);
}