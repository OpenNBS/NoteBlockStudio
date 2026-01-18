function draw_text_edit(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {
	/*


	    CALL:
	        draw_text_edit(id, def, x, y, w, h, singleline, readonly)

	    INFO:
	        Draws text on the screen that, unlike draw_text, can be edited, selected and copied.

	            Use draw_set_font() to change the font of the text like you would normally.
	            Use draw_set_color() to change the color of the text (does not affect selection colors.)
	            This script does not react to draw_set_halign() nor draw_set_valign()!

	    ARGUMENTS:
	        id =                    An unique ID for the text, it must be equal or larger than 0.
	        def =                   The default string for the text when first loaded.
	        x1, y1, x2, y2 =        The rectangle the text is contained within. If the text exceeds
	                                this box, words / letters will automatically jump to the next line.
	        singleline =            If true, this text is limited to one line. New lines cannot be added through
	        readonly =              Whether this text is read only.

	    RETURNS:
	        The edited text.

	    WRITTEN BY:
	        David "Davve" Norgren
	        http://www.stuffbydavid.com
	        Credit would be appreciated if used


	*/

	{
	    var i, w, h, xx, yy, def, singleline, readonly, maxchars, filterchars, replacechar;
	    var col_normal, col_selected, col_selection, col_marker;
	    var a, b, c, l, p, t, lh, ly, ww, hh, str, init, keys, menu, limit, key_press, realmpos, realspos, realepos, deletetext, inserttext;
    
	    i = argument0
	    def = string(argument1)
	    xx = argument2
	    yy = argument3
	    w = argument4
	    h = argument5
	    singleline = argument6
	    readonly = argument7
		var had = 0
    
	    // Colors
	    col_normal = draw_get_color()
	    col_selected = c_white
	    if (theme != 3) col_selection = make_color_rgb(51, 153, 255)
	    else col_selection = accent[3]
	    col_marker = c_black
	    if (theme = 2 || (theme = 3 && fdark)) col_marker = c_white
    
	    maxchars = 0
	    filterchars = ""
	    replacechar = ""
    
	    // Load lines from string
	    if (text_exists[i]) init = (text_laststr[i] != text_str[i])
	    else init = 1
	    if (init) {
	        if (text_exists[i]) def = text_str[i]
	        text_exists[i] = 1
	        text_start[i] = 0
	        text_lines[i] = 0
	        text_lastwidth[i] = 0
	        text_chars[i] = 0
	        text_sline = 0 text_spos = 0
	        text_eline = 0 text_epos = 0
	        text_mline = 0 text_mpos = 0
	        text_cline = 0 text_cpos = 0
	        def = string_replace_all(def, "\r\n", "\n")
	        if (maxchars > 0) def = string_copy(def, 1, maxchars)
	        if (singleline) def = string_replace_all(def, "\n", " ")
	        text_str[i] = def
	        def += "\n"
	        while (def != "") {  // Fetch lines
	            text_line[i, text_lines[i]] = string_copy(def, 1, string_pos("\n", def) - 1)
	            if (replacechar != "") text_line[i, text_lines[i]] = string_length(text_line[i, text_lines[i]]) * replacechar
	            text_line_wrap[i, text_lines[i]] = false
	            text_line_single[i, text_lines[i]] = false
	            text_lines[i] += 1
	            def = string_delete(def, 1, string_pos("\n", def))
	        }
	    }
    
	    deletetext = 0
	    inserttext = ""
	    lh = string_height_dynamic(" ")
	    mouseover = (mouse_x >= xx && mouse_x < xx + w && mouse_y >= yy && mouse_y < yy + h)
    
	    if (text_focus = i) {
	        if (text_lastfocus != i || text_mline >= text_lines[i]) {
	            text_marker = current_time
	            text_eline = text_lines[i] - 1 text_epos = string_length(text_line[i, text_lines[i] - 1])
	            text_sline = text_eline text_spos = text_epos
	            // text_sline = 0 text_spos = 0  // Uncomment to have all text selected upon focus
	            text_mline = text_eline text_mpos = text_epos
	            text_cline = text_sline text_cpos = text_spos
	        }
	        // Automatic key presses
	        keys[0] = vk_enter keys[1] = vk_backspace keys[2] = vk_delete keys[3] = ord("V") keys[4] = vk_right keys[5] = vk_left keys[6] = vk_up keys[7] = vk_down
	        for (a = 0; a < 8; a += 1) {
	            key_press[keys[a]] = 0
	            if (keyboard_check(keys[a])) {
	                if (current_time - text_key_delay[a] > 30) {
	                    key_press[keys[a]] = 1
	                    text_key_delay[a] = current_time + 500 * keyboard_check_pressed(keys[a]) // 500 msec if first press, otherwise 30
	                }
	            } else text_key_delay[a] = 0
	        }
        
	        if (!readonly) deletetext = key_press[vk_backspace] - key_press[vk_delete] // 0 = Do nothing, 1 = Erase to left, -1 = Erase to right, 2 = Delete selected
	        if (mouse_check_button_pressed(mb_left) && !keyboard_check(vk_shift)) text_focus = -1
	        if (keyboard_check(vk_anykey) && !readonly && ord(keyboard_string) != 127 && !check_ctrl()) inserttext = keyboard_string
	        keyboard_string = ""
        
	        // Controls
	        if (!singleline) {
	            text_start[i] += mouse_wheel_down() - mouse_wheel_up()  // Mousewheel to scroll
	            if (key_press[vk_enter] && !readonly) inserttext = "\n"  // Enter for linebreak
	        }
	        if (key_press[vk_right] || key_press[vk_left] || (key_press[vk_up] && text_mline > 0) || (key_press[vk_down] && text_mline < text_lines[i] - 1)) {  // Arrow keys to move marker
	            if (key_press[vk_right] || key_press[vk_left]) {
	                text_mpos += (key_press[vk_right] - key_press[vk_left])
	                if (text_mpos = string_length(text_line[i, text_mline]) + 1) {  // Move marker right
	                    if (text_mline < text_lines[i] - 1) {
	                        text_mline += 1
	                        text_mpos = 0
	                    } else text_mpos -= 1
	                }
	                if (text_mpos < 0) {  // Move marker left
	                    if (text_mline > 0) {
	                        text_mline -= 1
	                        text_mpos = string_length(text_line[i, text_mline])
	                    } else text_mpos += 1
	                }
	            }
	            if (key_press[vk_up] || key_press[vk_down]) {  // Move marker up / down
	                a = string_width_dynamic(string_copy(text_line[i, text_mline], 1, text_mpos))
	                ww = 0
	                text_mline += key_press[vk_down] - key_press[vk_up]
	                for (text_mpos = 0; text_mpos <= string_length(text_line[i, text_mline]); text_mpos += 1) {
	                    ww += string_width_dynamic(string_char_at(text_line[i, text_mline], text_mpos))
	                    if (ww > a) break
	                }
	            }
	            if (!keyboard_check(vk_shift)) {
	                text_cline = text_mline
	                text_cpos = text_mpos
	            }
	            text_sline = text_mline text_spos = text_mpos
	            text_eline = text_mline text_epos = text_mpos
	            text_marker = current_time
	        }
	        menu = -1
	        if (check_ctrl()) {  // Ctrl commands
	            if (!readonly && keyboard_check_pressed(ord("X"))) menu = 0
	            if (keyboard_check_pressed(ord("C"))) menu = 1
	            if (!readonly && key_press[ord("V")]) menu = 2
	            if (keyboard_check_pressed(ord("A"))) menu = 4
	        }
	        if (menu = 0 || menu = 1) {  // Cut / Copy text
	            str = ""
	            if (text_sline = text_eline) {  // Get text on single line
	                str = string_copy(text_line[i, text_sline], text_spos + 1, text_epos - text_spos)
	            } else for (l = text_sline; l <= text_eline; l += 1) {  // Get selected text
	                if (l = text_sline) str += string_delete(text_line[i, l], 1, text_spos)
	                else if (l = text_eline) str += string_copy(text_line[i, l], 1, text_epos)
	                else str += text_line[i, l]
	                if (l < text_eline) {
	                    if (!text_line_wrap[i, l + 1] && !text_line_single[i, l]) str += "\n"
	                }
	            }
	            if (str != "") if (os_type = os_windows) clipboard_set_text(str) else text_clipboard = str
	            if (menu = 0) deletetext = 2
	        } else if (menu = 2) {  // Paste text
	            if (os_type = os_windows) inserttext = clipboard_get_text() else inserttext = text_clipboard
	            inserttext = string_replace_all(inserttext, "\r\n", "\n")
	        } else if (menu = 3) {  // Delete text
	            deletetext = 2
	        } else if (menu = 4) {  // Select all text
	            text_sline = 0 text_spos = 0
	            text_eline = text_lines[i] - 1
	            text_epos = string_length(text_line[i, text_eline])
	            text_mline = text_eline text_mpos = text_epos
	            text_cline = 0 text_cpos = 0
	        }
        
	        // Filter
	        if (filterchars != "" && inserttext != "") {
	            str = ""
	            for (a = 1; a <= string_length(inserttext); a += 1) {
	                c = string_char_at(inserttext, a)
	                str += (string_pos(c, filterchars) > 0) * c
	            }
	            inserttext = str
	        }
        
	        // Delete
	        if (deletetext != 0 || inserttext != "") {
	            realspos = text_spos  // Find real positions in total string
	            realepos = text_epos
	            for (a = 0; a < text_eline; a += 1) {
	                b = string_length(text_line[i, a]) + (!text_line_wrap[i, a + 1] && !text_line_single[i, a])
	                realepos += b
	                if (a < text_sline) realspos += b
	            }
	            if (text_sline != text_eline || text_spos != text_epos) {  // Several characters
	                if (text_sline = text_eline) {  // Same line, just do string_delete
	                    text_line[i, text_sline] = string_delete(text_line[i, text_sline], text_spos + 1, text_epos - text_spos)
	                } else {  // Delete all lines between the two points
	                    text_line[i, text_sline] = string_copy(text_line[i, text_sline], 1, text_spos) + string_delete(text_line[i, text_eline], 1, text_epos)
	                    text_lines[i] -= text_eline - text_sline
	                    for (l = text_sline + 1; l < text_lines[i]; l += 1) {
	                        text_line[i, l] = text_line[i, l + (text_eline - text_sline)]
	                        text_line_wrap[i, l] = text_line_wrap[i, l + (text_eline - text_sline)]
	                        text_line_single[i, l] = text_line_single[i, l + (text_eline - text_sline)]
	                    }
	                }
	                text_str[i] = string_delete(text_str[i], realspos + 1, realepos - realspos)
	            } else if (deletetext < 2) {  // Single character
	                if (deletetext = 1) {  // Delete to the left (Backspace)
	                    if (text_spos > 0) {  // In middle of line, just do string_delete
	                        text_line[i, text_sline] = string_delete(text_line[i, text_sline], text_spos, 1)
	                        text_spos -= 1
	                    } else if (text_sline > 0) {  // Else, move up
	                        text_sline -= 1
	                        text_spos = string_length(text_line[i, text_sline])
	                        if (text_line_wrap[i, text_sline + 1]) {  // If wrapped, delete, otherwise just jump up
	                            text_spos -= 1
	                            text_line[i, text_sline] = string_copy(text_line[i, text_sline], 1, text_spos)
	                        }
	                        text_line[i, text_sline] = text_line[i, text_sline] + text_line[i, text_sline + 1]
	                        text_lines[i] -= 1
	                        for (l = text_sline + 1; l < text_lines[i]; l += 1) {
	                            text_line[i, l] = text_line[i, l + 1]
	                            text_line_wrap[i, l] = text_line_wrap[i, l + 1]
	                            text_line_single[i, l] = text_line_single[i, l + 1]
	                        }
	                    }
	                    text_str[i] = string_delete(text_str[i], realspos, 1)
	                } else if (deletetext = -1) {  // Delete to right (Delete)
	                    if (text_spos < string_length(text_line[i, text_sline])) {
	                        text_line[i, text_sline] = string_delete(text_line[i, text_sline], text_spos + 1, 1)
	                    } else if (text_sline < text_lines[i] - 1) {
	                        if (text_line_wrap[i, text_sline + 1]) { 
	                            text_line[i, text_sline + 1] = string_delete(text_line[i, text_sline + 1], 1, 1)  // If wrapped, delete below
	                        } else {
	                            text_line[i, text_sline] += text_line[i, text_sline + 1]
	                            text_lines[i] -= 1
	                            for (l = text_sline + 1; l < text_lines[i]; l += 1) {
	                                text_line[i, l] = text_line[i, l + 1]
	                                text_line_wrap[i, l] = text_line_wrap[i, l + 1]
	                                text_line_single[i, l] = text_line_single[i, l + 1]
	                            }
	                        }
	                    }
	                    text_str[i] = string_delete(text_str[i], realspos + 1, 1)
	                }
	            }
	            text_cline = text_sline text_cpos = text_spos
	            text_mline = text_sline text_mpos = text_spos
	            text_eline = text_sline text_epos = text_spos
	        }
        
        
	        // Insert text
	        if (maxchars > 0) {  // Check max limit
	            a = maxchars - string_length(text_str[i])
	            if (string_length(inserttext) > a) inserttext = string_copy(inserttext, 1, a)
	        }
	        if (inserttext != "") {
	            text_marker = current_time
	            if (singleline) inserttext = string_replace_all(inserttext, "\n", " ")
	            realmpos = text_mpos  // Get real position in total string
	            for (a = 0; a < text_mline; a += 1) realmpos += string_length(text_line[i, a]) + (!text_line_wrap[i, a + 1] && !text_line_single[i, a])
	            text_str[i] = string_copy(text_str[i], 1, realmpos) + inserttext + string_delete(text_str[i], 1, realmpos)
	            if (string_pos("\n", inserttext) > 0) {  // Add text with multiple lines (Paste or linebreak)
	                inserttext += "\n"
	                a = text_line[i, text_mline]
	                b = -1
	                while (inserttext != "") {  // Parse
	                    b += 1
	                    str[b] = string_copy(inserttext, 1, string_pos("\n", inserttext) - 1)
	                    if (replacechar != "") str[b] = string_length(str[b]) * replacechar
	                    inserttext = string_delete(inserttext, 1, string_pos("\n", inserttext))
	                }
	                text_lines[i] += b
	                for (l = text_lines[i] - 1; l >= text_mline + b; l -= 1) {  // Push up
	                    text_line[i, l] = text_line[i, l - b]
	                    text_line_wrap[i, l] = text_line_wrap[i, l - b]
	                    text_line_single[i, l] = text_line_single[i, l - b]
	                }
	                for (l = 0; l <= b; l += 1) {  // Insert
	                    if (l = 0) {
	                        text_line[i, text_mline + l] = string_copy(a, 1, text_mpos) + str[l]  // First
	                        text_line_single[i, text_mline + l] = false
	                    } else if (l = b) {
	                        text_line[i, text_mline + l] = str[l] + string_delete(a, 1, text_mpos)  // Last
	                        text_line_wrap[i, text_mline + l] = false
	                    } else text_line[i, text_mline + l] = str[l]  // Middle
	                }
	                text_mline += b
	                text_mpos = string_length(str[b])
	                inserttext = " "
	            } else {  // Simple insert
	                if (replacechar != "") inserttext = string_length(inserttext) * replacechar
	                // Apparently, string_insert doesn't support å, ä, ö, é, è, í etc.
	                text_line[i, text_sline] = string_copy(text_line[i, text_sline], 1, text_mpos) + inserttext + string_delete(text_line[i, text_sline], 1, text_mpos)
	                text_mpos += string_length(inserttext)
	            }
	            text_cline = text_mline text_cpos = text_mpos
	            text_sline = text_mline text_spos = text_mpos
	            text_eline = text_mline text_epos = text_mpos
	        }
        
	        // Move screen if text is edited or marker is moved
	        if (inserttext != "" || deletetext != 0 || key_press[vk_left] || key_press[vk_right] || key_press[vk_up] || key_press[vk_down]) {
	            if (singleline) {
	                if (text_mpos < text_start[i]) text_start[i] = text_mpos  // Move screen left
	                if (text_mpos > text_start[i] + text_chars[i] - 1) text_start[i] = text_mpos - text_chars[i]  // Move screen right
	            } else {
	                if (text_mline < text_start[i]) text_start[i] = text_mline  // Move screen up
	                if (text_mline >= text_start[i] + floor(h / lh)) text_start[i] = text_mline - floor(h / lh) + 1  // Move screen down
	            }
	        }
        
	        // Handle selecting
	        if (!mouse_check_button(mb_left)) text_select = -1
	        if (text_select = i) {  // Move up/down if dragging outside of box
	            text_marker = current_time
	            if (singleline) {
	                if (mouse_x < xx) text_start[i] -= 1
	                if (mouse_x > xx + w && text_start[i] < string_length(text_line[i, 0]) - text_chars[i]) text_start[i] += 1
	            } else {
	                if (mouse_y < yy) text_start[i] -= 1
	                if (mouse_y > yy + h) text_start[i] += 1
	            }
	        }
	        if (text_click > 0) {
	            if (text_mline = text_cline) {
	                text_sline = text_mline
	                text_eline = text_mline
	                if (text_mpos >= text_cpos) {
	                    text_spos = text_cpos
	                    text_epos = text_mpos
	                } else {
	                    text_spos = text_mpos
	                    text_epos = text_cpos
	                }
	            }
	            if (text_mline > text_cline) {
	                text_sline = text_cline
	                text_spos = text_cpos
	                text_eline = text_mline
	                text_epos = text_mpos
	            }
	            if (text_mline < text_cline) {
	                text_sline = text_mline
	                text_spos = text_mpos
	                text_eline = text_cline
	                text_epos = text_cpos
	            }
	        }
	        text_lastfocus = text_focus
	    }
    
	    if (singleline) {  // Calculate the amount of characters visible
			// Avoid negative start character
	        text_start[i] = max(0, text_start[i])
	        // Find minimum position
	        ww = 0
	        for (a = string_length(text_line[i, 0]); a >= 0; a--) {
	            ww += string_width_dynamic(string_char_at(text_line[i, 0], a))
	            b = a
	            if (ww > w) break
	        }
	        text_start[i] = min(b, text_start[i])
	        // Calculate visible
	        ww = 0
	        text_chars[i] = 0
	        for (a = text_start[i] + 1; a <= string_length(text_line[i, 0]); a++) {
	            ww += string_width_dynamic(string_char_at(text_line[i, 0], a))
	            if (ww > w) break
	            text_chars[i]++
	        }
	    } else {  // Wordwrapping
	        if (text_lastwidth[i] != w || inserttext != "" || deletetext != 0) {  // Detect box width or line length changes.
	            for (l = 1; l < text_lines[i]; l += 1) {  // Move words up?
	                ww = string_width_dynamic(text_line[i, l - 1])
	                if (!text_line_wrap[i, l] || ww > w) continue
	                if (text_line_single[i, l - 1]) {  // Single - worded line
	                    for (p = 1; p <= string_length(text_line[i, l]); p += 1) {  // Try to add remaining letters
	                        if (ww + string_width_dynamic(string_copy(text_line[i, l], 1, p)) > w) break
	                        a = string_char_at(text_line[i, l], p + 1)
	                        if (a = " " || a = " - ") {
	                            p += 1
	                            text_line_single[l - 1] = false
	                            break
	                        }
	                        if (p = string_length(text_line[i, l]) && !text_line_single[i, l]) text_line_single[i, l - 1] = false
	                    }
	                    if (p = 1) continue  // Cannot move up
	                    a = string_length(text_line[i, l - 1])  // Move markers if affected
	                    if (text_mline = l && text_mpos <= p) {text_mline -= 1 text_mpos += a}
	                    if (text_cline = l && text_cpos <= p) {text_cline -= 1 text_cpos += a}
	                    if (text_eline = l && text_epos <= p) {text_eline -= 1 text_epos += a}
	                    if (text_sline = l && text_spos <= p) {text_sline -= 1 text_spos += a}
	                    if (text_mline = l) text_mpos -= p
	                    if (text_cline = l) text_cpos -= p
	                    if (text_eline = l) text_epos -= p
	                    if (text_sline = l) text_spos -= p
	                    text_line[i, l - 1] += string_copy(text_line[i, l], 1, p)
	                    text_line[i, l] = string_delete(text_line[i, l], 1, p)
	                }
	                while (text_line[i, l] != "") {  // Try to add words
	                    p = string_pos(" ", text_line[i, l])
	                    if (p = 0) p = string_pos(" - ", text_line[i, l])
	                    if (p = 0) p = string_length(text_line[i, l])
	                    if (ww + string_width_dynamic(string_copy(text_line[i, l], 1, p - 1)) > w) break
	                    a = string_length(text_line[i, l - 1])  // Move markers if affected
	                    if (text_mline = l && text_mpos <= p) {text_mline -= 1 text_mpos += a}
	                    if (text_cline = l && text_cpos <= p) {text_cline -= 1 text_cpos += a}
	                    if (text_eline = l && text_epos <= p) {text_eline -= 1 text_epos += a}
	                    if (text_sline = l && text_spos <= p) {text_sline -= 1 text_spos += a}
	                    if (text_mline = l) text_mpos -= p
	                    if (text_cline = l) text_cpos -= p
	                    if (text_eline = l) text_epos -= p
	                    if (text_sline = l) text_spos -= p
	                    text_line[i, l - 1] += string_copy(text_line[i, l], 1, p)
	                    text_line[i, l] = string_delete(text_line[i, l], 1, p)
	                }
                
	                if (text_line[i, l] = "") { // Remove empty line
	                    text_lines[i] -= 1
	                    for (a = l; a < text_lines[i]; a += 1) {
	                        text_line[i, a] = text_line[i, a + 1]
	                        text_line_wrap[i, a] = text_line_wrap[i, a + 1]
	                        text_line_single[i, a] = text_line_single[i, a + 1]
	                        if (text_mline = a + 1) text_mline -= 1  // Move markers if affected
	                        if (text_cline = a + 1) text_cline -= 1
	                        if (text_eline = a + 1) text_eline -= 1
	                        if (text_sline = a + 1) text_sline -= 1
	                    }
	                    l -= 1
	                }
	            }
	            for (l = 0; l < text_lines[i]; l += 1) {  // Move words down?
	                if (string_width_dynamic(text_line[i, l]) > w) {
	                    text_line_single[i, l] = false
	                    for (p = string_length(text_line[i, l]); p > 1; p -= 1) {  // Look for words
	                        a = string_char_at(text_line[i, l], p)
	                        if (a = " " || a = " - ") {
	                            if (string_width_dynamic(string_copy(text_line[i, l], 1, p - 1)) < w) break
	                        }
	                    }
	                    if (p = 1) {  // Single - word line found
	                        text_line_single[i, l] = true
	                        for (p = string_length(text_line[i, l]) - 1; p > 1; p -= 1) {
	                            if (string_width_dynamic(string_copy(text_line[i, l], 1, p)) < w) break
	                        }
	                    }
	                    if (p = 0) continue  // Cannot be wrapped            
	                    if (l = text_lines[i] - 1) a = true
	                    else a=!text_line_wrap[i, l + 1]
	                    if (a) {  // Create new line for wrapped text
	                        for (b = text_lines[i]; b > l; b -= 1) {  // Push
	                            text_line[i, b] = text_line[i, b - 1]
	                            text_line_wrap[i, b] = text_line_wrap[i, b - 1]
	                            text_line_single[i, b] = text_line_single[i, b - 1]
	                            if (text_mline = b) text_mline += 1  // Move markers if affected
	                            if (text_cline = b) text_cline += 1
	                            if (text_eline = b) text_eline += 1
	                            if (text_sline = b) text_sline += 1
	                        }
	                        text_lines[i] += 1
	                        text_line[i, l + 1] = string_delete(text_line[i, l], 1, p)
	                        text_line_wrap[i, l + 1] = true
	                        text_line_single[i, l + 1] = false
	                    } else {
	                        text_line[i, l + 1] = string_delete(text_line[i, l], 1, p) + text_line[i, l + 1]  // Add to existing
	                    }
	                    // Move markers if affected
	                    a = string_length(text_line[i, l]) - p
	                    if (text_mline = l + 1) text_mpos += a
	                    if (text_cline = l + 1) text_cpos += a
	                    if (text_eline = l + 1) text_epos += a
	                    if (text_sline = l + 1) text_spos += a
	                    if (text_mline = l && text_mpos >= p) {text_mline += 1 text_mpos -= p}
	                    if (text_cline = l && text_cpos >= p) {text_cline += 1 text_cpos -= p}
	                    if (text_eline = l && text_epos >= p) {text_eline += 1 text_epos -= p}
	                    if (text_sline = l && text_spos >= p) {text_sline += 1 text_spos -= p}
	                    text_line[i, l] = string_copy(text_line[i, l], 1, p)
	                }
	            }
	            if (text_mline < text_start[i]) text_start[i] = text_mline  // Move screen up
	            if (text_mline >= text_start[i] + floor(h / lh)) text_start[i] = text_mline - floor(h / lh) + 1  // Move screen down
	        }
	        text_start[i] = max(0, min(text_start[i], text_lines[i] - floor(h / lh)))
	    }
    
	    // Draw text and selection
	    draw_set_halign(fa_left)
	    draw_set_valign(fa_top)
	    for (l = text_start[i]*!singleline; l < text_lines[i]; l += 1) {
	        ly = l - text_start[i]*!singleline  // Current line y value
	        if ((ly + 1) * lh > h) break  // Exit if beyond box
	        if (window = 0 || i < 400) && ((mouseover && text_select = -1) || text_select = i) {
	            if (l = text_lines[i] - 1) hh = h - ly * lh
	            else hh = lh
	            if ((mouse_x >= xx || text_select = i) &&
	                (mouse_x < xx + w || text_select = i) &&
	                (mouse_y >= yy + ly * lh || (text_select = i && ly = 0)) &&
	                (mouse_y < yy + ly * lh + hh || (text_select = i && ((ly + 1) * lh > h || l = text_lines[i] - 1)))) {  // Cursor is inside line
	                if (mouse_check_button(mb_left)) {
	                    text_select = i
	                    ww = 0
	                    for (a = text_start[i] * singleline; a < string_length(text_line[i, l]); a += 1) {  // Find character over mouse
	                        b = string_width_dynamic(string_char_at(text_line[i, l], a + 1))
	                        ww += b
	                        if (mouse_x < xx + ww - b / 2) break
	                    }
	                    text_mline = l
	                    text_mpos = a
	                    if (mouse_check_button_pressed(mb_left)) {
	                        if (text_cline = text_mline && text_cpos = text_mpos) {  // Double click, word select
	                            if (current_time - text_click < 500) {
	                                text_sline = text_mline text_spos = max(1, text_mpos - 1)
	                                text_eline = text_mline text_epos = max(1, text_mpos)
	                                while (1) {  // Look left / up for start position
	                                    c = string_char_at(text_line[i, text_sline], text_spos)
	                                    if (c = " " || c = ", " || c = "(" || c = ")" || c = "[" || c = "]" || c = " + ") break
	                                    text_spos -= 1
	                                    if (text_spos <= 0) {  // Jump up a line if it's a single word
	                                        if (text_sline = 0) break
	                                        if (!text_line_single[i, text_sline - 1]) break
	                                        text_sline -= 1
	                                        text_spos = string_length(text_line[i, text_sline])
	                                    }
	                                    if (text_spos <= 0) break
	                                }
	                                while (1) {  // Look right / down for end position
	                                    c = string_char_at(text_line[i, text_eline], text_epos)
	                                    if (c = " " || c = ", " || c = "(" || c = ")" || c = "[" || c = "]" || c = " + ") break
	                                    text_epos += 1
	                                    if (text_epos >= string_length(text_line[i, text_eline])) {
	                                        if (text_eline = text_lines[i] - 1) break
	                                        if (!text_line_single[i, text_eline]) break
	                                        text_eline += 1
	                                        text_epos = 0
	                                    }
	                                    if (text_epos >= string_length(text_line[i, text_eline])) break
	                                }
	                                text_mline = text_eline
	                                text_mpos = text_epos
	                                text_click = 0
	                                mouse_clear(mb_left)
	                            } else {  // Remove selection if clicking after word select
	                                text_click = current_time
	                                text_sline = text_mline text_spos = text_mpos
	                                text_eline = text_mline text_epos = text_mpos
	                            }
	                        } else {
	                            text_click = current_time
	                            if (!keyboard_check(vk_shift) || text_lastfocus != i) {  // Drag selection if shift is held
	                                text_sline = text_mline text_spos = text_mpos
	                                text_eline = text_mline text_epos = text_mpos
	                                text_cline = text_mline text_cpos = text_mpos
	                            }
	                        }
	                        text_marker = current_time
	                        text_focus = i
	                        text_lastfocus = i
	                    }
	                }
	            }
	        }
	        if (singleline) {
	            if (text_focus = i && text_spos != text_epos) {
	                str[0] = string_copy(string_copy(text_line[i, 0], 1, text_spos), text_start[i] + 1, text_chars[i])
	                str[1] = string_copy(string_copy(text_line[i, 0], text_spos + 1, text_epos - text_spos), (text_start[i] + 1) - text_spos, text_chars[i] - max(0, text_spos - (text_start[i])))
	                str[2] = string_copy(string_delete(text_line[i, 0], 1, text_epos), 1, (text_start[i] + text_chars[i]) - text_epos)
	                if (str[0] != "") {  // Text before or outside selection
	                    draw_set_color(col_normal)
	                    draw_text_dynamic(xx, yy, str[0])
	                }
	                if (str[1] != "") {  // Selected text
	                    draw_set_color(col_selection)
	                    draw_rectangle(min(xx + w, xx + string_width_dynamic(str[0])), yy, min(xx + w, xx + string_width_dynamic(str[0] + str[1])), yy + lh, 0)
	                    draw_set_color(col_selected)
	                    draw_text_dynamic(xx + string_width_dynamic(str[0]), yy, str[1])
	                }
	                if (str[2] != "") {  // Text after selection
	                    draw_set_color(col_normal)
	                    draw_text_dynamic(xx + string_width_dynamic(str[0] + str[1]), yy, str[2])
	                }
	            } else { // Unselected
	                draw_set_color(col_normal)
	                draw_text_dynamic(xx, yy, string_copy(text_line[i, 0], text_start[i] + 1, text_chars[i]))
	            }
	        } else {
	            if (text_focus = i && (text_sline != text_eline || text_spos != text_epos)) {  // This line is selected
	                for (a = 0; a < 3; a += 1) str[a] = ""
	                if (text_sline = l && text_eline = l) {  // Same line
	                    str[0] = string_copy(text_line[i, l], 1, text_spos)
	                    str[1] = string_copy(text_line[i, l], text_spos + 1, text_epos - text_spos)
	                    str[2] = string_delete(text_line[i, l], 1, text_epos)
	                } else if (text_sline = l) {  // Beginning line
	                    str[0] = string_copy(text_line[i, l], 1, text_spos)
	                    str[1] = string_delete(text_line[i, l], 1, text_spos)
	                } else if (text_eline = l) {  // Ending line
	                    str[1] = string_copy(text_line[i, l], 1, text_epos)
	                    str[2] = string_delete(text_line[i, l], 1, text_epos)
	                } else if (text_sline < l && text_eline > l) {  // Between
	                    str[1] = text_line[i, l]
	                } else {  // Outside
	                    str[0] = text_line[i, l]
	                }
	                if (str[0] != "") {  // Text before or outside selection
	                    draw_set_color(col_normal)
	                    draw_text_dynamic(xx, yy + ly * lh, str[0])
	                }
	                if (str[1] != "") {  // Selected text
	                    draw_set_color(col_selection)
	                    draw_rectangle(min(xx + w, xx + string_width_dynamic(str[0])), yy + ly * lh, min(xx + w, xx + string_width_dynamic(str[0] + str[1])), yy + (ly + 1) * lh, 0)
	                    draw_set_color(col_selected)
	                    draw_text_dynamic(xx + string_width_dynamic(str[0]), yy + ly * lh, str[1])
	                }
	                if (str[2] != "") {  // Text after selection
	                    draw_set_color(col_normal)
	                    draw_text_dynamic(xx + string_width_dynamic(str[0] + str[1]), yy + ly * lh, str[2])
	                }
	            } else { // Unselected line
	                draw_set_color(col_normal)
	                draw_text_dynamic(xx, yy + ly * lh, text_line[i, l])
	            }
	        }
	    }
    
	    // Marker
	    if (text_focus = i && !readonly) {
	        a = string_width_dynamic(string_copy(text_line[i, text_mline], 1, text_mpos))
	        b = (text_mline - text_start[i]) * lh
	        if (singleline) {
	            //a -= string_width_dynamic(string_copy(text_line[i, text_mline], 1, text_start[i]))
	            //b = 0
	        }
	        if (a >= 0 && a <= w && b >= 0 && b + lh <= h && (current_time - text_marker) mod 1000 < 500) {
	            draw_set_color(col_marker)
	            draw_line(xx + a, yy + b, xx + a, yy + b + lh)
	        }
	    }
    
	    // Set cursor
		for (var f = 0; f < array_length(text_mouseover); f += 1) {
			if (text_mouseover[f] = i) had = 1
		}
	    if (mouseover) {
	        if (!had) array_push(text_mouseover, i)
	        if !(window div w_menu) curs = cr_beam
	    } else if (had && array_length(text_mouseover) < 1) {
	        text_mouseover = []
	        if !(window div w_menu) curs = cr_default
	    }
    
	    text_lastwidth[i] = w
	    text_laststr[i] = text_str[i]
	    draw_set_color(col_normal)
	    return text_str[i]
	}



}
