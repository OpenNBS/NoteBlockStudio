function draw_sound_stopper_guide(_x, _start_layer, _end_layer, _editor_left, _editor_top, _editor_right, _editor_bottom, _first_visible_layer) {
	var _visible_start = _first_visible_layer + 1
	var _visible_end = _visible_start + floor((_editor_bottom - _editor_top) / 32) - 1
	var _draw_start = max(_start_layer, _visible_start)
	var _draw_end = min(_end_layer, _visible_end)
	if (_draw_start > _draw_end) return;

	// draw_sprite_ext uses the sprite origin, so convert to its top-left corner before clipping.
	var _sprite_left = _x - 1 - sprite_get_xoffset(spr_wall)
	var _source_left = max(0, _editor_left - _sprite_left)
	var _source_right = min(sprite_get_width(spr_wall), _editor_right - _sprite_left)
	if (_source_left >= _source_right) return;

	var _previous_alpha = draw_get_alpha()
	draw_set_alpha(1)
	draw_sprite_part_ext(
		spr_wall,
		(theme = 2 || (theme = 3 && fdark)),
		_source_left,
		0,
		_source_right - _source_left,
		1,
		_sprite_left + _source_left,
		_editor_top + 32 * (_draw_start - _visible_start),
		1,
		32 * (_draw_end - _draw_start + 1),
		-1,
		1
	)
	draw_set_alpha(_previous_alpha)
}
