function draw_song_tabs() {
	var count = array_length(songs)
	if (count < 2 || fullscreen) {
		if (window == w_dragtab) window = 0
		tabdrag = false
		draggingtab = -1
		tab_press_song = noone
		tab_close_song = noone
		tab_front_song = noone
		for (var i = 0; i < count; i++) songs[i].tab_draw_x = -1
		return
	}

	var span = max(1, min(179, (rw - 44) / count))
	var tabwidth = span + 1
	if (count != tab_layout_count || span != tab_layout_span) {
		// Reflow when tabs open, close, or the window resizes.
		tab_layout_count = count
		tab_layout_span = span
		if (window == w_dragtab) window = 0
		tabdrag = false
		draggingtab = -1
		tab_press_song = noone
		tab_close_song = noone
		tab_front_song = noone
		for (var i = 0; i < count; i++) songs[i].tab_draw_x = -1
	}
	var pointer_x = nbs_mouse_x()
	var held = nbs_mouse_check_button(mb_left)
	var released = nbs_mouse_check_button_released(mb_left)
	var was_dragging = tabdrag
	var press_index = -1
	var front_index = -1
	for (var i = 0; i < count; i++) {
		var item = songs[i]
		if (item.tab_draw_x < 0) {
			item.tab_draw_x = 7 + i * span
			item.tab_target_x = item.tab_draw_x
			item.tab_from_x = item.tab_draw_x
			item.tab_progress = 1
		}
		if (item == tab_press_song) press_index = i
		if (item == tab_front_song) front_index = i
	}
	if (front_index < 0) tab_front_song = noone
	if (tabdrag && (front_index < 0 || window != w_dragtab || (!held && !released) || keyboard_check_pressed(vk_escape))) {
		tabdrag = false
		draggingtab = -1
		tab_press_song = noone
		tab_close_song = noone
		if (window == w_dragtab) window = 0
	}

	var hovered = -1
	var close_hovered = -1
	var close_y = theme == 3 ? 29 : 31 - 5 * (theme == 1 || theme == 2) + 3 * (theme != 0)
	var close_width = theme == 3 ? 30 : 16
	var close_height = theme == 3 ? 22 : 15
	var close_inset = theme == 3 ? 35 : 21
	if (window == 0 && !was_dragging) {
		for (var i = 0; i < count; i++) {
			var item = songs[i]
			if (mouse_rectangle(item.tab_draw_x - 1, 26, span - 1, 24 + 5 * (theme == 3))) hovered = i
			if (mouse_rectangle(item.tab_draw_x + span - close_inset, close_y, close_width, close_height)) close_hovered = i
		}
		if (front_index >= 0) {
			var front_x = songs[front_index].tab_draw_x
			if (mouse_rectangle(front_x - 1, 26, span - 1, 24 + 5 * (theme == 3))) {
				hovered = front_index
				close_hovered = -1
			}
			if (mouse_rectangle(front_x + span - close_inset, close_y, close_width, close_height)) close_hovered = front_index
		}
		if (nbs_mouse_check_button_pressed(mb_left)) {
			tab_press_song = noone
			tab_close_song = noone
			var clicked = close_hovered >= 0 ? close_hovered : hovered
			if (clicked >= 0) {
				set_song(clicked)
				if (close_hovered >= 0) tab_close_song = songs[clicked]
				else {
					tab_press_song = songs[clicked]
					press_index = clicked
					tab_press_x = pointer_x
					tab_grab_offset = pointer_x - songs[clicked].tab_draw_x
				}
			}
		}
		if (held && press_index >= 0 && tab_press_song == songs[press_index] && abs(pointer_x - tab_press_x) >= 4) {
			tabdrag = true
			draggingtab = press_index
			tab_front_song = songs[press_index]
			front_index = press_index
			window = w_dragtab
		}
	}

	var finished_drag = false
	if (tabdrag) {
		draggingtab = front_index
		var dragged = songs[draggingtab]
		dragged.tab_draw_x = clamp(pointer_x - tab_grab_offset, 7, 7 + (count - 1) * span)
		// The gap follows the nearest slot, independent of the grab point.
		tabdest = clamp(round((dragged.tab_draw_x - 7) / span), 0, count - 1)
		dragged.tab_target_x = dragged.tab_draw_x
		dragged.tab_from_x = dragged.tab_draw_x
		dragged.tab_progress = 1
		curs = cr_drag
		if (released) {
			var selected_song = songs[song]
			if (tabdest != draggingtab) {
				array_delete(songs, draggingtab, 1)
				array_insert(songs, tabdest, dragged)
				for (var i = 0; i < count; i++) if (songs[i] == selected_song) song = i
			}
			front_index = tabdest
			tabdrag = false
			draggingtab = -1
			window = 0
			finished_drag = true
		}
	}

	var close_index = -1
	if (window == 0 && !tabdrag && !was_dragging && !finished_drag) {
		if (released && close_hovered >= 0 && tab_close_song == songs[close_hovered]) close_index = close_hovered
		if (hovered >= 0 && nbs_mouse_check_button_released(mb_right)) {
			menutab = hovered
			if (language != 1) show_menu_ext("songtab", pointer_x, nbs_mouse_y(), icon(icons.NEW) + get_hotkey("new_song") + "$New song|-|" + icon(icons.DELETE) + get_hotkey("close_song") + "$Close song|" + inactive(count <= 1) + "Close other songs|" + inactive(hovered == count - 1) + "Close songs to the right")
			else show_menu_ext("songtab", pointer_x, nbs_mouse_y(), icon(icons.NEW) + get_hotkey("new_song") + "$新文件|-|" + icon(icons.DELETE) + get_hotkey("close_song") + "$关闭歌曲|" + inactive(count <= 1) + "关闭其他歌曲|" + inactive(hovered == count - 1) + "关闭右侧歌曲")
		}
	}
	if (!held) {
		tab_press_song = noone
		tab_close_song = noone
	}

	var elapsed = clamp(delta_time / 1000000, 0, 0.05)
	for (var i = 0; i < count; i++) {
		if (tabdrag && i == draggingtab) continue
		var item = songs[i]
		var slot = i
		if (tabdrag) {
			if (i > draggingtab && i <= tabdest) slot--
			if (i < draggingtab && i >= tabdest) slot++
		}
		var target = 7 + slot * span
		if (item.tab_target_x != target) {
			item.tab_from_x = item.tab_draw_x
			item.tab_target_x = target
			item.tab_progress = 0
		}
		if (item.tab_progress < 1) {
			var duration = item == tab_front_song ? 0.22 : 0.18
			item.tab_progress = min(1, item.tab_progress + elapsed / duration)
			var eased = 1 - power(1 - item.tab_progress, 3)
			item.tab_draw_x = lerp(item.tab_from_x, target, eased)
		}
	}

	if (!tabdrag && front_index >= 0 && songs[front_index].tab_progress == 1) {
		tab_front_song = noone
		front_index = -1
	}

	draw_set_alpha(1)
	draw_set_halign(fa_left)
	if (theme != 3) draw_sprite_ext(spr_songtab, 9 + 10 * theme, 0, 24 - 5 * (theme == 1 || theme == 2), rw / 4, 1, 0, c_white, 1)
	for (var i = 0; i < count; i++) {
		if (i == front_index) continue
		var item = songs[i]
		var hover = (i == hovered && window == 0 && !finished_drag)
		if (hover && held && (item == tab_press_song || item == tab_close_song)) hover = 2
		var close_hover = i == close_hovered && window == 0 && !finished_drag
		if (close_hover && held && item == tab_close_song) close_hover = 2
		draw_song_tab(item, item.tab_draw_x, tabwidth, hover, close_hover)
	}
	var new_x = 7 + count * span
	var new_hover = window == 0 && !tabdrag && !was_dragging && !finished_drag && mouse_rectangle(new_x - 1, 26, 30, 24 + 5 * (theme == 3))
	var new_clicked = new_hover && mouse_rectangle_click(new_x - 1, 26, 30, 24 + 5 * (theme == 3))
	if (theme != 3) {
		var top = 24 - 5 * (theme == 1 || theme == 2)
		var frame = 3 * new_hover + 10 * theme
		draw_sprite_ext(spr_songtab, frame, new_x - 2, top, 1, 1, 0, c_white, 1)
		draw_sprite_ext(spr_songtab, frame + 1, new_x + 2, top, 27 / 4, 1, 0, c_white, 1)
		draw_sprite_ext(spr_songtab, frame + 2, new_x + 28, top, 1, 1, 0, c_white, 1)
	} else {
		var mica = wpaperexist && acrylic && can_draw_mica
		if (new_hover) {
			draw_set_color((mica ? !fdark : fdark) ? 2960685 : 15329769)
			if (mica) draw_set_alpha(0.1)
			draw_rectircle(new_x, 26, new_x + 31, 57, false)
			draw_set_alpha(1)
		}
		draw_sprite_ext(spr_newtab, 0, new_x + 9, 34, 1, 1, 0, -1 + !fdark, 1)
	}

	if (theme == 3) {
		draw_set_alpha(0.5)
		for (var i = 0; i < count; i++) {
			if (i != front_index) draw_separator(songs[i].tab_draw_x + span + 1, 32)
		}
		draw_set_alpha(1)
	}
	if (front_index >= 0) {
		var item = songs[front_index]
		var hover = front_index == hovered && window == 0 && !finished_drag
		if (hover && held && (item == tab_press_song || item == tab_close_song)) hover = 2
		var close_hover = front_index == close_hovered && window == 0 && !finished_drag
		if (close_hover && held && item == tab_close_song) close_hover = 2
		draw_song_tab(item, item.tab_draw_x, tabwidth, hover, close_hover, true)
		if (theme == 3) {
			draw_set_alpha(0.5)
			draw_separator(item.tab_draw_x + span + 1, 32)
			draw_set_alpha(1)
		}
	}

	if (theme == 3) {
		draw_theme_color()
		if (wpaperexist && acrylic && can_draw_mica) draw_set_alpha(0.8)
		draw_line(0, 58, rw, 58)
		draw_set_alpha(1)
	}
	if (close_index >= 0) close_song(close_index)
	else if (new_clicked) new_song()
}
