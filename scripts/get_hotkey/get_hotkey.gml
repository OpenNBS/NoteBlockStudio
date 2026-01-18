function get_hotkey(action){
	switch (action) {
		case "undo": {
			if (os_type != os_macosx) return "Ctrl+Z"
			else return "⌘ Z"
			break
		}
		case "redo": {
			if (os_type != os_macosx) return "Ctrl+Y"
			else return "⌘ Y"
			break
		}
		case "copy": {
			if (os_type != os_macosx) return "Ctrl+C"
			else return "⌘ C"
			break
		}
		case "cut": {
			if (os_type != os_macosx) return "Ctrl+X"
			else return "⌘ X"
			break
		}
		case "paste": {
			if (os_type != os_macosx) return "Ctrl+V"
			else return "⌘ V"
			break
		}
		case "delete": {
			if (os_type != os_macosx) return "Delete"
			else return "⌫"
			break
		}
		case "select_all": {
			if (os_type != os_macosx) return "Ctrl+A"
			else return "⌘ A"
			break
		}
		case "invert_selection": {
			if (os_type != os_macosx) return "Ctrl+I"
			else return "⌘ I"
			break
		}
		case "action_1": {
			if (os_type != os_macosx) return "Ctrl+E"
			else return "⌘ E"
			break
		}
		case "action_2": {
			if (os_type != os_macosx) return "Ctrl+D"
			else return "⌘ D"
			break
		}
		case "action_3": {
			if (os_type != os_macosx) return "Ctrl+R"
			else return "⌘ R"
			break
		}
		case "action_4": {
			if (os_type != os_macosx) return "Ctrl+F"
			else return "⌘ F"
			break
		}
		case "action_5": {
			if (os_type != os_macosx) return "Ctrl+T"
			else return "⌘ T"
			break
		}
		case "action_6": {
			if (os_type != os_macosx) return "Ctrl+G"
			else return "⌘ G"
			break
		}
		case "tremolo": {
			if (os_type != os_macosx) return "Ctrl+Shift+A"
			else return "⌃ ⇧ A"
			break
		}
		case "stereo": {
			if (os_type != os_macosx) return "Ctrl+Shift+S"
			else return "⌃ ⇧ S"
			break
		}
		case "arpeggio": {
			if (os_type != os_macosx) return "Ctrl+Shift+D"
			else return "⌃ ⇧ D"
			break
		}
		case "portamento": {
			if (os_type != os_macosx) return "Ctrl+Shift+F"
			else return "⌃ ⇧ F"
			break
		}
		case "vibrato": {
			if (os_type != os_macosx) return "Ctrl+Shift+G"
			else return "⌃ ⇧ G"
			break
		}
		case "stagger": {
			if (os_type != os_macosx) return "Ctrl+Shift+H"
			else return "⌃ ⇧ H"
			break
		}
		case "chorus": {
			if (os_type != os_macosx) return "Ctrl+Shift+J"
			else return "⌃ ⇧ J"
			break
		}
		case "volume_lfo": {
			if (os_type != os_macosx) return "Ctrl+Shift+K"
			else return "⌃ ⇧ K"
			break
		}
		case "fade_in": {
			if (os_type != os_macosx) return "Ctrl+Shift+Q"
			else return "⌃ ⇧ Q"
			break
		}
		case "fade_out": {
			if (os_type != os_macosx) return "Ctrl+Shift+W"
			else return "⌃ ⇧ W"
			break
		}
		case "replace_key": {
			if (os_type != os_macosx) return "Ctrl+Shift+E"
			else return "⌃ ⇧ E"
			break
		}
		case "set_velocity": {
			if (os_type != os_macosx) return "Ctrl+Shift+R"
			else return "⌃ ⇧ R"
			break
		}
		case "set_panning": {
			if (os_type != os_macosx) return "Ctrl+Shift+T"
			else return "⌃ ⇧ T"
			break
		}
		case "set_pitch": {
			if (os_type != os_macosx) return "Ctrl+Shift+Y"
			else return "⌃ ⇧ Y"
			break
		}
		case "reset_properties": {
			if (os_type != os_macosx) return "Ctrl+Shift+U"
			else return "⌃ ⇧ U"
			break
		}
		case "new_song": {
			if (os_type != os_macosx) return "Ctrl+N"
			else return "⌘ N"
			break
		}
		case "open_song": {
			if (os_type != os_macosx) return "Ctrl+O"
			else return "⌘ O"
			break
		}
		case "save_song": {
			if (os_type != os_macosx) return "Ctrl+S"
			else return "⌘ S"
			break
		}
		case "exit": {
			if (os_type != os_macosx) return "Alt+F4"
			else return "⌘ Q"
			break
		}
		case "ins_ctrl": {
			if (os_type != os_macosx) return "Ctrl+"
			else return "⌃ "
			break
		}
		case "ins_ctrl_shift": {
			if (os_type != os_macosx) return "Ctrl+Shift+"
			else return "⌃ ⇧ "
			break
		}
		case "preferences": {
			if (os_type != os_macosx) return "Ctrl+P"
			else return "⌘ ,"
			break
		}
		case "close_song": {
			if (os_type != os_macosx) return "Ctrl+W"
			else return "⌘ W"
			break
		}
		case "": {
			if (os_type != os_macosx) return ""
			else return ""
			break
		}
		default: {
			return "not_found"
			break
		}
	}
}