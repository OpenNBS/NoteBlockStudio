function selection_to_array_ext(){
	// Generate a selection code array based from the current selections
		
	var a, b, ca, cb;
	
	if (selected = 0) return []
	ca = 0
	
	var _selection_l = selection_l
	var _selection_h = selection_h
	var _selection_colfirst = selection_colfirst
	var _selection_exists = selection_exists
	var _selection_ins = selection_ins
	var _selection_key = selection_key
	var _selection_vel = selection_vel
	var _selection_pan = selection_pan
	var _selection_pit = selection_pit
	
	var ret = []
	var at = 0
	for (a = 0; a < _selection_l; a += 1) {
		if (_selection_colfirst[a] > -1) {
			array_grow_then_set(ret, at++, ca)
			ca = 0
			cb = 0
			for (b = 0; b < _selection_h; b += 1) {
				if (_selection_exists[a, b]) {
					array_grow_then_set(ret, at++, cb)
					array_grow_then_set(ret, at++, ds_list_find_index(instrument_list, _selection_ins[a, b]))
					array_grow_then_set(ret, at++, _selection_key[a, b])
					array_grow_then_set(ret, at++, _selection_vel[a, b])
					array_grow_then_set(ret, at++, _selection_pan[a, b])
					array_grow_then_set(ret, at++, _selection_pit[a, b])
					cb = 0
				}
				cb += 1
			}
			array_grow_then_set(ret, at++, -1)
		}
		ca += 1
	}
	array_resize(ret, at)

	return ret
}