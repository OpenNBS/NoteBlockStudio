function draw_area(argument0, argument1, argument2, argument3) {
	// draw_area(x1, y1, x2, y2)
	var x1, y1, x2, y2, prevcolor;
	x1 = argument0
	y1 = argument1
	x2 = argument2
	y2 = argument3
	prevcolor = draw_get_color()
	if (!hires || theme != 3) {
		draw_sprite(spr_interface1, 0 + 8 * theme + 8 * (theme = 3 && fdark), x1, y1)
		draw_sprite_ext(spr_interface1, 1 + 8 * theme + 8 * (theme = 3 && fdark), x1, y1 + 2, 1, (y2 - y1 - 4) / 2, 0, -1, draw_get_alpha())
		draw_sprite(spr_interface1, 2 + 8 * theme + 8 * (theme = 3 && fdark), x1, y2 - 2)
		draw_sprite_ext(spr_interface1, 3 + 8 * theme + 8 * (theme = 3 && fdark), x1 + 2, y2 - 2, (x2 - x1 - 4) / 2, 1, 0, -1, draw_get_alpha())
		draw_sprite(spr_interface1, 4 + 8 * theme + 8 * (theme = 3 && fdark), x2 - 2, y2 - 2)
		draw_sprite_ext(spr_interface1, 5 + 8 * theme + 8 * (theme = 3 && fdark), x2 - 2, y1 + 2, 1, (y2 - y1 - 4) / 2, 0, -1, draw_get_alpha())
		draw_sprite(spr_interface1, 6 + 8 * theme + 8 * (theme = 3 && fdark), x2 - 2, y1)
		draw_sprite_ext(spr_interface1, 7 + 8 * theme + 8 * (theme = 3 && fdark), x1 + 2, y1, (x2 - x1 - 4) / 2, 1, 0, -1, draw_get_alpha())
	} else {
		draw_set_color(10855845)
		if (fdark) draw_set_color(11974326)
		draw_rectircle(x1, y1, x2, y2, true, 8)
	}
	draw_set_color(prevcolor)



}
