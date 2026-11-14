function mode_action(argument0) {
	// mode_action(num)
	// Runs a particular action according to the currently selected edit mode

	var num = argument0
	songs[song].changed = 1
	switch editmode {
		case m_key: {
			switch num {
				case 1: selection_changekey(12) break
				case 2: selection_changekey(-12) break
				case 3: selection_changekey(1) break
				case 4: selection_changekey(-1) break
			}
			break
		}
		case m_vel: {
			switch num {
				case 1: selection_changevel(10) break
				case 2: selection_changevel(-10) break
				case 3: selection_changevel(1) break
				case 4: selection_changevel(-1) break
				case 5: window = w_setvelocity break
				case 6: selection_setvel(100) break
			}
			break
		}
		case m_pan: {
			switch num {
				case 1: selection_changepan(10) break
				case 2: selection_changepan(-10) break
				case 3: selection_changepan(1) break
				case 4: selection_changepan(-1) break
				case 5: window = w_setpanning break
				case 6: selection_setpan(100) break
			}
			break
		}
		case m_pit: {
			switch num {
				case 1: selection_changepit(10) break
				case 2: selection_changepit(-10) break
				case 3: selection_changepit(1) break
				case 4: selection_changepit(-1) break
				case 5: window = w_setpitch break
				case 6: selection_setpit(0) break
			}
			break
		}
	}


}
