function selection_flip(flipVertically){
	//if flipVertical is true, well, it'll flip the selection vertically. Otherwise, horizontally.

	var row, column, current_song, str, target_column, target_row, outerloop_count, innerloop_count;

	var old_ins, old_key, old_vel, old_pan, old_pit, old_exists;
	
	current_song = songs[song];

	str = current_song.selection_code;

	// expand all the column properites before flipping
	for (var i = 0; i < current_song.selection_l; i++) {
				
		for (var j = current_song.selection_colfirst[i]; j < current_song.selection_h; j++) {
			if (j < 0 || current_song.selection_exists[i, j]) continue;
					
			current_song.selection_colfirst[i] = -1;
			current_song.selection_collast[i] = -1;
			current_song.selection_exists[i, j] = 0;
			current_song.selection_ins[i, j] = 0;
			current_song.selection_key[i, j] = 0;
			current_song.selection_vel[i, j] = 0;
			current_song.selection_pan[i, j] = 0;
			current_song.selection_pit[i, j] = 0;
		}
	}
	
	
	// if flipVertically, set the loop count values to do a vertical flip
	if (flipVertically) {
		outerloop_count = current_song.selection_l;
		innerloop_count = current_song.selection_h / 2;
	} else {
		// otherwise, set the loop count values to do a horizontal flip
		outerloop_count = current_song.selection_l / 2;
		innerloop_count = current_song.selection_h;
	}

	for (column = 0; column < outerloop_count; column++) {
	    for (row = 0; row < innerloop_count; row++) {
			
			// same logic, but for the target row and column you want to move the value
			if (flipVertically) {
				target_row    = current_song.selection_h - row - 1;
				target_column = column;
			} else {
				target_row    = row;
				target_column = current_song.selection_l - column - 1;
			}
			
			old_ins    = current_song.selection_ins[column, row];
			old_key    = current_song.selection_key[column, row];
			old_vel    = current_song.selection_vel[column, row];
			old_pan    = current_song.selection_pan[column, row];
			old_pit	   = current_song.selection_pit[column, row];
			old_exists = current_song.selection_exists[column,row];
					
			current_song.selection_ins[column, row] = current_song.selection_ins[target_column, target_row];
			current_song.selection_ins[target_column, target_row] = old_ins;
					
			current_song.selection_key[column, row] = current_song.selection_key[target_column, target_row];
			current_song.selection_key[target_column, target_row] = old_key;
					
			current_song.selection_vel[column, row] = current_song.selection_vel[target_column, target_row];
			current_song.selection_vel[target_column, target_row] = old_vel;
					
			current_song.selection_pan[column, row] = current_song.selection_pan[target_column, target_row];
			current_song.selection_pan[target_column, target_row] = old_pan;
					
			current_song.selection_pit[column, row] = current_song.selection_pit[target_column, target_row];
			current_song.selection_pit[target_column, target_row] = old_pit;

			current_song.selection_exists[column, row] = current_song.selection_exists[target_column, target_row];
			current_song.selection_exists[target_column, target_row] = old_exists;
	    }
	}

	// find the first row number in the columns
	for (var i = 0; i < current_song.selection_l; i++) {
		for (var j = 0; j < current_song.selection_h; j++) {
			if (current_song.selection_exists[i,j]) {
				current_song.selection_colfirst[i] = j;
				break;
			}
		}
	}

	// find the last row number in the columns
	for (var i = current_song.selection_l - 1; i >= 0; i--) {
		for (var j = current_song.selection_h - 1; j >= 0; j--) {
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