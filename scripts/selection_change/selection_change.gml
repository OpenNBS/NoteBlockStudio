function selection_change(argument0, argument1, argument2) {
	// selection_change(property, amount)
	// Change a property in the selection, which can be the key, velocity, panning or pitch (1-4).
	// If 'add' is true, the value will be added to the property rather than changing it.
	var a, b, str, property, amount, val, add;
	property = argument0
	amount = argument1
	add = argument2
	str = songs[song].selection_code
	if (songs[song].selected = 0) return 0
	for (a = 0; a < songs[song].selection_l; a += 1) {
	    if (songs[song].selection_colfirst[a] > -1) {
	        for (b = songs[song].selection_colfirst[a]; b <= songs[song].selection_collast[a]; b += 1) {
	            if (songs[song].selection_exists[a, b]) {
					switch property {
						case m_key: {
							if (add) {
								val = songs[song].selection_key[a, b]
								val += amount
							} else {
								val = amount
							}
							if (val >= 0 && val <= 87) songs[song].selection_key[a, b] = val
							break
						}
						case m_vel: {
							if (add) {
								val = songs[song].selection_vel[a, b]
								val += amount
							} else {
								val = amount
							}
							if (val >= 0 && val <= 100) songs[song].selection_vel[a, b] = val
							break
						}
						case m_pan: {
							if (add) {
								val = songs[song].selection_pan[a, b]
								val += amount
							} else {
								val = amount
							}
							if (val >= 0 && val <= 200) songs[song].selection_pan[a, b] = val
							break
						}
						case m_pit: {
							if (add) {
								val = songs[song].selection_pit[a, b]
								val += amount
							} else {
								val = amount
							}
							if (val >= -1200 && val <= 1200) songs[song].selection_pit[a, b] = val
							break
						}
					}
	            }
	        }
	    }
	}
	selection_code_update()
	history_set(h_selectchange, songs[song].selection_x, songs[song].selection_y, songs[song].selection_code, songs[song].selection_x, songs[song].selection_y, str)



}
