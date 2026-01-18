var song_tab_offset = 0
if (array_length(obj_controller.songs) > 1 && !obj_controller.fullscreen) {
	song_tab_offset = 40
}
x1 = -2
if (!obj_controller.fullscreen && obj_controller.show_layers) {
	x1 = 264
}
if (obj_controller.fullscreen) {
	y1 = -2
} else {
	y1 = 52 + song_tab_offset
}
draw_set_alpha(alpha)
if (!obj_controller.fdark) draw_set_color(obj_controller.accent[0])
else draw_set_color(obj_controller.accent[6])
//draw_rectangle(x1 + 2 + 32 * xn, y1 + 34 + 32 * yn, x1 + 2 + 32 * xn + 31, y1 + 34 + 32 * yn + 31, 0)
draw_roundrect_ext(x1 + 2 + 32 * xn - (0.5 - alpha) * 20, y1 + 34 + 32 * yn - (0.5 - alpha) * 20, x1 + 2 + 32 * xn + 30 + (0.5 - alpha) * 18, y1 + 34 + 32 * yn + 30 + (0.5 - alpha) * 20, (0.5 - alpha) * 20, (0.5 - alpha) * 20, 1)
alpha -= 0.06 * (30 / (room_speed * obj_controller.currspeed))
if (alpha <= 0) instance_destroy()