function get_hotkey_menubar(action){
	switch (action) {
		case "undo": {
			return "cmd+z"
			break
		}
		case "redo": {
			return "cmd+y"
			break
		}
		case "copy": {
			return "cmd+c"
			break
		}
		case "cut": {
			return "cmd+x"
			break
		}
		case "paste": {
			return "cmd+v"
			break
		}
		case "delete": {
			return "backspace"
			break
		}
		case "select_all": {
			return "cmd+a"
			break
		}
		case "invert_selection": {
			return "cmd+i"
			break
		}
		case "action_1": {
			return "cmd+e"
			break
		}
		case "action_2": {
			return "cmd+d"
			break
		}
		case "action_3": {
			return "cmd+r"
			break
		}
		case "action_4": {
			return "cmd+f"
			break
		}
		case "action_5": {
			return "cmd+t"
			break
		}
		case "action_6": {
			return "cmd+g"
			break
		}
		case "tremolo": {
			return "control+shift+a"
			break
		}
		case "stereo": {
			return "control+shift+s"
			break
		}
		case "arpeggio": {
			return "control+shift+d"
			break
		}
		case "portamento": {
			return "control+shift+f"
			break
		}
		case "vibrato": {
			return "control+shift+g"
			break
		}
		case "stagger": {
			return "control+shift+h"
			break
		}
		case "chorus": {
			return "control+shift+j"
			break
		}
		case "volume_lfo": {
			return "control+shift+k"
			break
		}
		case "fade_in": {
			return "control+shift+q"
			break
		}
		case "fade_out": {
			return "control+shift+w"
			break
		}
		case "replace_key": {
			return "control+shift+e"
			break
		}
		case "set_velocity": {
			return "control+shift+r"
			break
		}
		case "set_panning": {
			return "control+shift+t"
			break
		}
		case "set_pitch": {
			return "control+shift+y"
			break
		}
		case "reset_properties": {
			return "control+shift+u"
			break
		}
		case "new_song": {
			return "cmd+n"
			break
		}
		case "open_song": {
			return "cmd+o"
			break
		}
		case "save_song": {
			return "cmd+s"
			break
		}
		case "exit": {
			return "cmd+q"
			break
		}
		case "ins_ctrl": {
			return "control+"
			break
		}
		case "ins_ctrl_shift": {
			return "control+shift+"
			break
		}
		case "preferences": {
			return "cmd+,"
			break
		}
		case "close_song": {
			return "cmd+w"
			break
		}
		case "": {
			return ""
			break
		}
		default: {
			return ""
			break
		}
	}
}