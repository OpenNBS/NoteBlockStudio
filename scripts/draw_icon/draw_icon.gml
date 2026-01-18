function draw_icon() {
	// draw_icon(i, xx, yy, str[, locked[, pressed]])
	var i, a, xx, yy, str, locked, pressed, iswindow;
	i = argument[0]
	xx = argument[1]
	yy = argument[2]
	str = argument[3]
	locked = 0
	pressed = 0
	iswindow = 0
	var dark = ((theme == 3 && fdark) || (isplayer && blackout))
	if (argument_count > 4)
	    locked = argument[4]
	if (argument_count > 5)
	    pressed = argument[5]
	if (argument_count > 6)
		iswindow = argument[6]
	if (window = 0) popup_set(xx, yy, 25, 25, str)
	else if (iswindow) popup_set_window(xx, yy, 25, 25, str)
	a = (mouse_rectangle(xx, yy, 25, 25) && (window = 0 || iswindow) && locked = 0 && sb_drag = -1)
	a += ((mouse_check_button(mb_left) || mouse_check_button_released(mb_left)) && a)
	if (pressed = 1) {
	    if (hires && theme = 3) draw_sprite_ext(spr_frame1_hires, 2 + dark * 3 - (a = 1) * dark, xx, yy, 0.25, 0.25, 0, -1, draw_get_alpha())
	    else draw_sprite(spr_frame1, 2 + 3 * theme + dark * 3 - (a = 1) * dark, xx, yy)
		if (theme = 3) draw_sprite_ext(spr_tabsel, 1 + 2 * hires, xx + 5, yy + 23, 1 - 0.75 * hires, 1 - 0.75 * hires, 0, accent[4], (!dropmode) + dropalpha * (dropmode))
	} else {
	    if (hires && theme = 3) draw_sprite_ext(spr_frame1_hires, a + dark * 3, xx, yy, 0.25, 0.25, 0, -1, draw_get_alpha())
	    else draw_sprite(spr_frame1, a + 3 * theme + dark * 3, xx, yy)
	}
	if (theme != 3) {
		draw_sprite_ext(spr_icons, i - locked * (i != 43), xx + (a = 2 || pressed = 1), yy + (a = 2 || pressed = 1), 1, 1, 0, -1, 0.5 + 0.5 * (i != 43 || !locked))
	} else {
		if (!hires) {
			if (!dark) draw_sprite_ext(spr_icons_f, i - locked * (i != 43), xx + 25 * 0.1 * (a = 2), yy + 23 * 0.1 * (a = 2), 1 - 0.2 * (a = 2), 1 - 0.2 * (a = 2), 0, -1, (!dropmode - 0.5 * (i = 43 && locked)) + dropalpha * (dropmode))
			else draw_sprite_ext(spr_icons_d, i - locked * (i != 43), xx + 25 * 0.1 * (a = 2), yy + 23 * 0.1 * (a = 2), 1 - 0.2 * (a = 2), 1 - 0.2 * (a = 2), 0, -1, (!dropmode - 0.5 * (i = 43 && locked)) + dropalpha * (dropmode))
			draw_sprite_ext(spr_icons_col, i - locked * (i != 43), xx + 25 * 0.1 * (a = 2), yy + 23 * 0.1 * (a = 2), 1 - 0.2 * (a = 2), 1 - 0.2 * (a = 2), 0, accent[6 - 2 * !fdark], (!dropmode - 0.5 * (i = 43 && locked)) + dropalpha * (dropmode))
		} else {
			if (!dark) draw_sprite_ext(spr_icons_f_hires, i - locked * (i != 43), xx + 25 * 0.1 * (a = 2), yy + 23 * 0.1 * (a = 2), (1 - 0.2 * (a = 2)) * 0.25, (1 - 0.2 * (a = 2)) * 0.25, 0, -1, (!dropmode - 0.5 * (i = 43 && locked)) + dropalpha * (dropmode))
			else draw_sprite_ext(spr_icons_d_hires, i - locked * (i != 43), xx + 25 * 0.1 * (a = 2), yy + 23 * 0.1 * (a = 2), (1 - 0.2 * (a = 2)) * 0.25, (1 - 0.2 * (a = 2)) * 0.25, 0, -1, (!dropmode - 0.5 * (i = 43 && locked)) + dropalpha * (dropmode))
			draw_sprite_ext(spr_icons_col_hires, i - locked * (i != 43), xx + 25 * 0.1 * (a = 2), yy + 23 * 0.1 * (a = 2), (1 - 0.2 * (a = 2)) * 0.25, (1 - 0.2 * (a = 2)) * 0.25, 0, accent[6 - 2 * !fdark], (!dropmode - 0.5 * (i = 43 && locked)) + dropalpha * (dropmode))
		}
	}
	// Repeat trigger when holding fast-forward and rewind
	if (i = 7 || i = 8) return (a = 2)
	return (a && mouse_check_button_released(mb_left) && aa = 0)



}
