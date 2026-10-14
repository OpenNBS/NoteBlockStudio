function menu_draw() {
	// menu_draw()
	if (ani < 1) ani += 0.1 * (30 / room_speed) * (1 / obj_controller.currspeed)
	else ani = 1
	var m, menux, menuy, noclick, o, theme, cm, menu, realpha;
	realpha = draw_get_alpha()
	theme = obj_controller.theme;
	sel = -1
	noclick = 0
	o = obj_controller;
	var rootx;
	rootx = clamp(sx - (sx + menu_wid[0] > o.rw) * menu_wid[0], 0, max(o.rw - menu_wid[0], 0))
	if (menu_span[0] <= o.rw) {
		var right_cascade_x, left_cascade_x;
		right_cascade_x = min(rootx, o.rw - menu_span[0])
		left_cascade_x = max(rootx, menu_span[0] - menu_wid[0])
		if (abs(right_cascade_x - rootx) <= abs(left_cascade_x - rootx)) rootx = right_cascade_x
		else rootx = left_cascade_x
	}
	menux[0] = rootx
	menuy[0] = sy
	for (m = 0; m < menus; m += 1) {
	    if (!menu_show[m]) continue
	    var dx, dy, i, iy, hei;
		dx = menux[m]
		dx = clamp(dx, 0, max(o.rw - menu_wid[m], 0))
	    dy = menuy[m]
		cm = floor(m * 0.5)
	    hei = menu_hei[m] * (1 - power(1 - ani, 2))
	    if (dy + hei > o.rh) dy = o.rh - hei
		menu_x[m] = dx
		menu_y[m] = dy
		menu_draw_hei[m] = hei
		var higher_menu_hovered, hm;
		higher_menu_hovered = 0
		for (hm = m + 1; hm < menus; hm += 1) {
			if (menu_show[hm] && mouse_rectangle(menu_x[hm], menu_y[hm], menu_wid[hm], menu_draw_hei[hm])) {
				higher_menu_hovered = 1
				break
			}
		}
	    iy = 8
		var glass_drawn = false
		var rectircle_shader = undefined
		var material = liquid_glass_settings("menu", o.fdark, o.menu_glass_material)
		if (theme == 3 && o.acrylic && o.liquid_glass) {
			draw_set_alpha(realpha)
			glass_drawn = draw_liquid_glass(application_surface, dx, dy, menu_wid[m] + 1, hei + 1, material)
		}
		// Keep acrylic when glass is off or unavailable
		if (!glass_drawn) {
		    if (!o.fdark) draw_theme_color()
		    else draw_set_color(197379)
		    draw_set_alpha(0.25)
		    if (theme = 3) draw_rectangle(dx + menu_wid[m] - 7, dy + hei - 7, dx + menu_wid[m] + 1, dy + hei + 1, 0)
		    draw_set_alpha(1)
		    if (o.theme != 3) draw_set_color(window_background)
		    else draw_set_color(16382457)
			//if (obj_controller.fdark && theme = 3) draw_set_color(2829099)
			if (obj_controller.fdark && theme = 3) draw_set_color(2697513)
			if (o.theme = 3) {
				draw_sprite(spr_shadowext, 0 + 5 * (obj_controller.fdark && theme = 3), dx + 4, dy + hei + 1)
				draw_sprite_ext(spr_shadowext, 1 + 5 * (obj_controller.fdark && theme = 3), dx + 9, dy + hei + 1, menu_wid[m] - 7, 1, 0, -1, 1)
				draw_sprite(spr_shadowext, 2 + 5 * (obj_controller.fdark && theme = 3), dx + menu_wid[m] + 1, dy + hei + 1)
				draw_sprite_ext(spr_shadowext, 3 + 5 * (obj_controller.fdark && theme = 3), dx + menu_wid[m] + 1, dy + 9, 1, hei - 7, 0, -1, 1)
				draw_sprite(spr_shadowext, 4 + 5 * (obj_controller.fdark && theme = 3), dx + menu_wid[m] + 1, dy + 4)
			}
			if (theme = 3 && o.acrylic) draw_surface_blur(application_surface, dx, dy, menu_wid[m] + 1, hei + 1, o.menu_blur_radius)
			if (theme = 3 && o.acrylic) draw_set_alpha(0.6)
			if (theme = 3 && o.acrylic) draw_acrylic_texture(dx, dy, menu_wid[m] + 1, hei + 1)
		    if (theme != 3) draw_rectangle(dx, dy, dx + menu_wid[m], dy + hei, 0)
			else {
				rectircle_shader = __rectircle_begin()
				draw_rectircle(dx, dy, dx + menu_wid[m] + 1, dy + hei + 1, false, material.corner_radius)
			}
		}
	    draw_set_alpha(0.25)
	    draw_theme_color()
	    if (o.theme != 3) draw_line(dx + 29, dy + 3, dx + 29, dy + hei - 3)
	    draw_set_alpha(1)
	    draw_set_color(c_white)
	    if (o.theme != 3) draw_line(dx + 30, dy + 3, dx + 30, dy + hei - 3)
	    draw_theme_color()
	    draw_set_alpha(0.25)
	    if (theme != 3) draw_rectangle(dx, dy, dx + menu_wid[m], dy + hei, 1)
	    else if (!glass_drawn) {
			draw_rectircle(dx, dy, dx + menu_wid[m] + 1, dy + hei + 1, true, material.corner_radius)
			__rectircle_end(rectircle_shader)
		}
	    draw_set_alpha(1)
	    for (i = 0; i < items[m]; i += 1) {
	        if (iy >= hei - 3) break
	        if (item_str[m, i] = "-") { // Separator
	            draw_set_alpha(0.25)
	            draw_theme_color()
	            draw_line(dx + 32, dy + iy - 2, dx + menu_wid[m] - 3, dy + iy - 2)
	            draw_set_alpha(1)
	            draw_set_color(c_white)
	            draw_line(dx + 32, dy + iy - 1, dx + menu_wid[m] - 3, dy + iy - 1)
	            iy += 6
	        } else {
	            var issel;
				var inaissel;
	            issel = (!higher_menu_hovered && mouse_rectangle(dx + 3, dy + iy - 5, menu_wid[m] - 5, 22))
	            inaissel = issel
	            if (issel) { // Close higher menus
					var press_started_here = mouse_press_in_rectangle(dx + 3, dy + iy - 5, menu_wid[m] - 5, 22)
	                var om;
	                for (om = m + 1; om < menus; om += 1) menu_show[om] = 0
	                if (ani = 1 && press_started_here) {
	                    sel = item_n[m, i]
	                    if (item_hasmenu[m, i] > 0 || item_inactive[m, i]) noclick = 1
	                }
	                selmenu = m
	                selitem = i
	            }
	            if (item_inactive[m, i]) issel = 0
	            if (item_hasmenu[m, i] > 0) {
					var submenu;
					submenu = item_hasmenu[m, i]
	                if (menu_show[submenu]) issel = 1
	                if (issel) {
	                    menu_show[submenu] = 1
						if (m = 0) {
							var right_space, left_space;
							right_space = o.rw - (dx + menu_wid[m] - 3)
							left_space = dx + 3
							menu_direction[submenu] = 1
							if (menu_span[submenu] > right_space && left_space > right_space) menu_direction[submenu] = -1
						} else {
							menu_direction[submenu] = menu_direction[m]
						}
						if (menu_direction[submenu] = 1) menux[submenu] = dx + menu_wid[m] - 3
						else menux[submenu] = dx - menu_wid[submenu] + 3
	                    menuy[submenu] = dy + iy - 8
	                }
	            }
	            draw_theme_color()
				var selection_text = c_white
	            if (issel) {
					if (o.theme != 3) {
	                draw_set_color(16684072)
	                draw_rectangle(dx + 3, dy + iy - 5, dx + menu_wid[m] - 2, dy + iy - 5 + 22, 0)
	                draw_set_color(c_white)
					} else {
					var selection_color = o.accent[5]
					var red = color_get_red(selection_color) / 255
					var green = color_get_green(selection_color) / 255
					var blue = color_get_blue(selection_color) / 255
					red = red <= 0.04045 ? red / 12.92 : power((red + 0.055) / 1.055, 2.4)
					green = green <= 0.04045 ? green / 12.92 : power((green + 0.055) / 1.055, 2.4)
					blue = blue <= 0.04045 ? blue / 12.92 : power((blue + 0.055) / 1.055, 2.4)
					var luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
					// Dark mode favors white except on very bright accents.
					var black_text = o.fdark ? luminance >= 0.5 : (luminance + 0.05) / 0.05 >= 1.05 / (luminance + 0.05)
					selection_text = black_text ? c_black : c_white
					draw_set_color(selection_color)
	                draw_rectircle(dx + 3, dy + iy - 5, dx + menu_wid[m] - 2, dy + iy - 5 + 22, false, 8)
	                draw_set_color(selection_text)
					}
	            } //else if (inaissel && !obj_controller.fdark) {
					//if (o.theme = 3) {
	                //draw_set_color(15132390)
	                //draw_rectangle(dx + 3, dy + iy - 5, dx + menu_wid[m] - 2, dy + iy - 5 + 22, 0)
	                //draw_set_color(c_black)
					//}
				//}
	            draw_set_alpha(1 - 0.5 * item_inactive[m, i])
				menu = obj_controller.menu_shown
	            draw_text_dynamic(dx + 36, dy + iy, item_str[m, i], 1)
	            if (item_shortcut[m, i] != "") {
	                draw_set_halign(fa_right)
	                draw_text_dynamic(dx + menu_wid[m] - 20, dy + iy, item_shortcut[m, i], 1)
	                draw_set_halign(fa_left)
	            }
				if (theme != 3) {
					if (item_image[m, i] > -1) draw_sprite(spr_icons, item_image[m, i], dx + 2, dy + iy - 6)
					var arrow_color = theme == 2 ? (issel ? c_black : c_white) : (issel ? c_white : c_black)
					if (item_hasmenu[m, i] > 0) draw_sprite_ext(spr_icons, icons.SUB_MENU, dx + menu_wid[m] - 24, dy + iy - 6, 1, 1, 0, arrow_color, draw_get_alpha())
				} else if (item_image[m, i] > -1 || item_hasmenu[m, i] > 0) {
					var light_icons = issel || o.fdark
					var icon_sprite = o.hires ? (light_icons ? spr_icons_d_hires : spr_icons_f_hires) : (light_icons ? spr_icons_d : spr_icons_f)
					var accent_sprite = o.hires ? spr_icons_col_hires : spr_icons_col
					var icon_scale = o.hires ? 0.25 : 1
					var icon_color = issel ? selection_text : c_white
					var accent_color = issel ? selection_text : o.accent[6 - 2 * !o.fdark]
					var arrow_color = issel ? selection_text : (o.fdark ? c_ltgray : c_gray)
					if (item_image[m, i] > -1) {
						draw_sprite_ext(icon_sprite, item_image[m, i], dx + 2, dy + iy - 6, icon_scale, icon_scale, 0, icon_color, draw_get_alpha())
						draw_sprite_ext(accent_sprite, item_image[m, i], dx + 2, dy + iy - 6, icon_scale, icon_scale, 0, accent_color, draw_get_alpha())
					}
					if (item_hasmenu[m, i] > 0) {
						draw_sprite_ext(icon_sprite, icons.SUB_MENU, dx + menu_wid[m] - 24, dy + iy - 6, icon_scale, icon_scale, 0, arrow_color, draw_get_alpha())
						draw_sprite_ext(accent_sprite, icons.SUB_MENU, dx + menu_wid[m] - 24, dy + iy - 6, icon_scale, icon_scale, 0, accent_color, draw_get_alpha())
					}
				}
	            draw_set_alpha(1)
	            iy += 22
	        }
	    }
	}
	if (nbs_mouse_check_button_released(mb_left) && ani = 1 && !noclick) {
		if (m && nbs_mouse_check_button_released(mb_left) && obj_controller.windowsound && theme = 3) with (obj_controller) play_sound(soundhide, 45, 100, 100, 0)
	    var a;
	    a = sel
	    with (obj_controller) menu_click(a)
	    instance_destroy()
	}
	draw_theme_color()
	draw_set_alpha(realpha)


}
