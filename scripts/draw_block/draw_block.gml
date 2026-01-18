function draw_block(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8) {
	// draw_block(x, y, ins, key, pan, vel, pit, alpha, selalpha)
	var xx, yy, ins, key, pan, vel, pit, alpha, salpha, index, iscustom, sprite, frame, ins, display, num1, num2, color1, color2;
	xx = argument0
	yy = argument1
	ins = argument2
	key = argument3
	pan = argument4
	vel = argument5
	pit = argument6
	alpha = argument7
	salpha = argument8
	
	var x1 = -2
	var y1 = -2
	if (!fullscreen && show_layers) {
		x1 = 264
	}
	if (fullscreen) {
		y1 = -2
	} else {
		y1 = 52 + song_tab_offset
	}

	index = ds_list_find_index(songs[song].instrument_list, ins)
	var insname = songs[song].instrument_list[| index].name

	//If index isnt found, don't draw
	if(index = -1)return;
	
	iscustom = (index >= first_custom_index)
	if (iscustom) {
		frame = (index - first_custom_index) % 18 + first_custom_index
	} else {
		frame = index
	}

	if (use_colors) {
		if (use_shapes) {
			sprite = spr_block_color_shape
		} else {
			sprite = spr_block_color
		}
	} else {
		if (use_shapes) {
			sprite = spr_block_shape
		} else {
			sprite = spr_block
			frame = 1
		}
	}
	//if (hires && theme = 3) gpu_set_texfilter(false)
	draw_sprite_ext(sprite, frame, xx, yy, 1, 1, 0, -1, alpha)
	//if (hires && theme = 3) gpu_set_texfilter(true)
	draw_set_alpha(1)
	if (use_icons) {
		if (iscustom) {
			draw_icon_customins(xx + 16, yy + 16, index - first_custom_index, alpha, true, 1)
		} else {
			if (hires && theme = 3) gpu_set_texfilter(false)
			draw_sprite_ext(spr_instrumenticons, index, xx + 16, yy + 16, 1, 1, 0, -1, alpha)
			if (hires && theme = 3) gpu_set_texfilter(true)
		}
	}

	//Draw a red or blue tint in the block when the pitch is off
	if (!isplayer) {
		if (pit < 0) {
			draw_set_color(c_red)
			draw_set_alpha(min(0.5, (-pit / 100) * alpha * 0.25))
			draw_rectangle(xx, yy, xx + 31, yy + 31, false)
		} else if (pit > 0) {
			draw_set_color(c_blue)
			draw_set_alpha(min(0.5, (pit / 100) * alpha * 0.25))
			draw_rectangle(xx, yy, xx + 31, yy + 31, false)
		}

		if (show_incompatible && (ins.user || key < 33 || key > 57)) {
		    draw_set_color(c_red)
		    draw_set_alpha(1)
		    draw_rectangle(xx + 1, yy + 1, xx + 31, yy + 31, 1)
		}
	}
	draw_set_color(c_white)
	if (salpha > 0) {
	    draw_sprite_ext(spr_block_sel, 0, xx, yy, 1, 1, 0, -1, salpha)
	    draw_set_alpha(1)
	} else {
	    draw_set_alpha(alpha + 0.25)
	}
	if (show_numbers) {
		if (insname == "Tempo Changer") {
			if (!hires || obj_controller.theme != 3) {
				draw_text(xx + 16 - 8 * (use_icons), yy + 16, string(abs(pit)) + " BPM")
			} else {
				draw_text_transformed(xx + 16 - 8 * (use_icons), yy + 16, string(abs(pit)) + " BPM", 0.25, 0.25, 0)
			}
		} else if (insname == "Sound Stopper") {
			if (!hires || obj_controller.theme != 3) {
				draw_text(xx + 16 - 8 * (use_icons), yy + 16, string(abs(pit)) + "-" + string(panning_velocity_to_short(pan, vel)))
			} else {
				draw_text_transformed(xx + 16 - 8 * (use_icons), yy + 16, string(abs(pit)) + "-" + string(panning_velocity_to_short(pan, vel)), 0.25, 0.25, 0)
			}
			if (!isplayer && xx > x1 + 2 && abs(pit) <= panning_velocity_to_short(pan, vel)) {
				if (theme = 0 || theme = 1 || (theme = 3 && !fdark)) draw_sprite_ext(spr_wall, 2, xx - 1, y1 + 2 + 32 * (abs(pit) - songs[song].startb), 1, 32 * (panning_velocity_to_short(pan, vel) - abs(pit) + 1), 0, -1, 1)
				if (theme = 2 || (theme = 3 && fdark)) draw_sprite_ext(spr_wall, 3, xx - 1, y1 + 2 + 32 * (abs(pit) - songs[song].startb), 1, 32 * (panning_velocity_to_short(pan, vel) - abs(pit) + 1), 0, -1, 1)
			}
		} else {
			if (!hires || obj_controller.theme != 3) {
				if (editmode == 0) draw_text(xx + 16 - 8 * (use_icons), yy + 16, condstr(key < 33, " < ") + condstr(key > 57, " > ") + condstr(key > 32 && key < 58, string(key - 33)))
				else if (editmode == 1) draw_text(xx + 16 - 8 * (use_icons), yy + 16, string_format(vel, 1, 0))
				else if (editmode == 2) draw_text(xx + 16 - 8 * (use_icons), yy + 16, condstr(pan < 100, "L ") + condstr(pan > 100, "R ") + string_format(abs(pan - 100), 1, 0))
				else if (editmode == 3) draw_text(xx + 16 - 8 * (use_icons), yy + 16, condstr(pit > 0, "+") + string_format(pit, 1, 0))
			} else {
				if (editmode == 0) draw_text_transformed(xx + 16 - 8 * (use_icons), yy + 16, condstr(key < 33, " < ") + condstr(key > 57, " > ") + condstr(key > 32 && key < 58, string(key - 33)), 0.25, 0.25, 0)
				else if (editmode == 1) draw_text_transformed(xx + 16 - 8 * (use_icons), yy + 16, string_format(vel, 1, 0), 0.25, 0.25, 0)
				else if (editmode == 2) draw_text_transformed(xx + 16 - 8 * (use_icons), yy + 16, condstr(pan < 100, "L ") + condstr(pan > 100, "R ") + string_format(abs(pan - 100), 1, 0), 0.25, 0.25, 0)
				else if (editmode == 3) draw_text_transformed(xx + 16 - 8 * (use_icons), yy + 16, condstr(pit > 0, "+") + string_format(pit, 1, 0), 0.25, 0.25, 0)
			}
		}
	}
	if(theme=2) draw_set_color(c_white)
	else draw_set_color(c_yellow)
	if (!hires || obj_controller.theme != 3) draw_text(xx + 16, yy + 4, get_keyname(key, show_octaves))
	else draw_text_transformed(xx + 16, yy + 4, get_keyname(key, show_octaves), 0.25, 0.25, 0)



}
