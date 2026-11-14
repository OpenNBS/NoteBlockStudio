/// Draw a blurred backdrop during Draw. Returns success.
/// Uses view coordinates for application_surface, pixels for other surfaces.
function draw_surface_blur(source, x, y, width, height, blur_radius = 12) {
	var capture = __surface_effects_capture(source, x, y, width, height, max(0, blur_radius) + 2)
	if (is_undefined(capture)) return false
	var output = __surface_effects_acquire(surface_get_width(capture.surface), surface_get_height(capture.surface))
	var success = false
	if (surface_exists(output)) {
		success = blur_surface(capture.surface, output, max(0, blur_radius) * max(capture.scale_x, capture.scale_y))
		if (success) {
			var state = __surface_effects_save()
			try {
				gpu_set_blendenable(true)
				gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha)
				var left = max(x, capture.x), top = max(y, capture.y)
				var right = min(x + width, capture.x + capture.width), bottom = min(y + height, capture.y + capture.height)
				if (right > left && bottom > top) {
					draw_surface_part_ext(output, (left - capture.x) * capture.scale_x, (top - capture.y) * capture.scale_y,
						(right - left) * capture.scale_x, (bottom - top) * capture.scale_y,
						left, top, 1 / capture.scale_x, 1 / capture.scale_y, c_white, state.alpha)
				}
			} catch (error) {
				show_debug_message("Backdrop blur drawing failed: " + string(error))
				success = false
			}
			__surface_effects_restore(state)
		}
		__surface_effects_release(output)
	}
	__surface_effects_release(capture.surface)
	return success
}
