function draw_icon_customins(xx, yy, ins, alpha, large, scale) {
	var display, num1, num2, color1, color2;
	display = (ins + 1) % 100
	num1 = floor(display / 10)
	num2 = display % 10
	color1 = make_color_hsv((ins * 16) % 256, 192, 255)
	color2 = make_color_hsv((ins * 16) % 256, 255, 128)
	if (large) {
		if (hires && theme = 3) gpu_set_texfilter(false)
		draw_sprite_ext(spr_instrumenticons, first_custom_index, xx, yy, 1, 1, 0, color1, alpha)
		if (songs[song].instrument_list[| ins + first_custom_index].name == "Tempo Changer") {
			draw_sprite_ext(spr_tempo_changer_label_mc, 0, xx + 3, yy + 3, 1, 1, 0, color2, alpha)
			draw_sprite_ext(spr_tempo_changer_label_mc, 0, xx + 2, yy + 2, 1, 1, 0, -1, alpha)
		} else {
			draw_sprite_ext(spr_numbers_mc, num1, xx + 3, yy + 5, 1, 1, 0, color2, alpha)
			draw_sprite_ext(spr_numbers_mc, num2, xx + 9, yy + 5, 1, 1, 0, color2, alpha)
			draw_sprite_ext(spr_numbers_mc, num1, xx + 2, yy + 4, 1, 1, 0, -1, alpha)
			draw_sprite_ext(spr_numbers_mc, num2, xx + 8, yy + 4, 1, 1, 0, -1, alpha)
		}
		if (hires && theme = 3) gpu_set_texfilter(true)
	} else {
		if(theme != 3) {
			draw_sprite_ext(spr_icons, icons.CUSTOM_INS_OVERLAY, xx, yy, 1, 1, 0, color1, 1)
		} else {
			if (!hires) {
				if (!fdark) draw_sprite_ext(spr_icons_f, icons.CUSTOM_INS_OVERLAY, xx + 25 * ((1 - scale) / 2), yy + 23 * ((1 - scale) / 2), scale, scale, 0, color1, 1)
				else draw_sprite_ext(spr_icons_d, icons.CUSTOM_INS_OVERLAY, xx + 25 * ((1 - scale) / 2), yy + 23 * ((1 - scale) / 2), scale, scale, 0, color1, 1)
			} else {
				if (!fdark) draw_sprite_ext(spr_icons_f_hires, icons.CUSTOM_INS_OVERLAY, xx + 25 * ((1 - scale) / 2), yy + 23 * ((1 - scale) / 2), scale * 0.25, scale * 0.25, 0, color1, 1)
				else draw_sprite_ext(spr_icons_d_hires, icons.CUSTOM_INS_OVERLAY, xx + 25 * ((1 - scale) / 2), yy + 23 * ((1 - scale) / 2), scale * 0.25, scale * 0.25, 0, color1, 1)
			}
		}
		if (hires && theme = 3) gpu_set_texfilter(false)
		if (songs[song].instrument_list[| ins + first_custom_index].name == "Tempo Changer") {
			draw_sprite_ext(spr_tempo_changer_label, 0, xx + 12, yy + 12, 1, 1, 0, color2, 1)
			draw_sprite(spr_tempo_changer_label, 0, xx + 11, yy + 11)
		} else {
			draw_sprite_ext(spr_numbers, num1, xx + 12, yy + 13, 1, 1, 0, color2, 1)
			draw_sprite_ext(spr_numbers, num2, xx + 16, yy + 13, 1, 1, 0, color2, 1)
			draw_sprite(spr_numbers, num1, xx + 11, yy + 12)
			draw_sprite(spr_numbers, num2, xx + 15, yy + 12)
		}
		if (hires && theme = 3) gpu_set_texfilter(true)
	}
}