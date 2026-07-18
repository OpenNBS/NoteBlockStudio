function draw_layericon(argument0, argument1, argument2, argument3, argument4, argument5) {
	// draw_icon(i, xx, yy, str, locked, pressed)
	var i, a, xx, yy, str, locked, pressed, color;
	i = argument0
	xx = argument1
	yy = argument2
	str = argument3
	locked = argument4
	pressed = argument5
	color = c_black
	if (theme = 2 || (theme = 3)) color = c_white

	popup_set(xx, yy, 16, 16, str)
	a = (mouse_rectangle(xx, yy, 16, 16) && window = 0 && locked = 0 && sb_drag = -1)
	if (a && mouse_check_button_pressed(mb_left)) mousepress_layericon = i
	
	var mouse_in_prev = (mouse_xprev >= xx && mouse_yprev >= yy && mouse_xprev < xx + 16 && mouse_yprev < yy + 16)
	var owns_press = (mousepress_layericon = i)
	var mouse_entered = (owns_press && mouse_check_button(mb_left) && (!mouse_in_prev && a))
	
	a += ((mouse_check_button(mb_left) || mouse_check_button_released(mb_left)) && a && owns_press)
	if (pressed = 1) {
	    if (!hires || theme != 3) draw_sprite(spr_frame4, 2 + 3 * theme, xx, yy)
	    else draw_sprite_ext(spr_frame4_hires, 2, xx, yy, 0.25, 0.25, 0, -1, draw_get_alpha())
	} else {
	    if (!hires || theme != 3) draw_sprite(spr_frame4, a + 3 * theme, xx, yy)
	    else draw_sprite_ext(spr_frame4_hires, a, xx, yy, 0.25, 0.25, 0, -1, draw_get_alpha())
	}
	if(theme != 3) {
	draw_sprite_ext(spr_layericons, i - locked, xx + (a = 2 || pressed = 1), yy + (a = 2 || pressed = 1), 1, 1, 0, color, 0.7)
	} else {
	if (!hires || theme != 3) {
		draw_sprite_ext(spr_layericons_f, i - locked + 9 * (!fdark), xx + (a = 2 || pressed = 1), yy + (a = 2 || pressed = 1), 1, 1, 0, color, 1)
		draw_sprite_ext(spr_layericons_f, i - locked + 18, xx + (a = 2 || pressed = 1), yy + (a = 2 || pressed = 1), 1, 1, 0, accent[6 - 2 * !fdark], 1)
	} else {
		draw_sprite_ext(spr_layericons_f_hires, i - locked + 9 * (!fdark), xx + (a = 2 || pressed = 1), yy + (a = 2 || pressed = 1), 0.25, 0.25, 0, color, 1)
		draw_sprite_ext(spr_layericons_f_hires, i - locked + 18, xx + (a = 2 || pressed = 1), yy + (a = 2 || pressed = 1), 0.25, 0.25, 0, accent[6 - 2 * !fdark], 1)
	}
	}
	return (mouse_entered || (owns_press && a && mouse_check_button_pressed(mb_left)))


}
