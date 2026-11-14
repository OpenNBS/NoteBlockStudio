/// Draw a continuous-corner rectangle using the current color and alpha.
function draw_rectircle(x1, y1, x2, y2, outline = false, corner_radius = 16) {
	var left = min(x1, x2), top = min(y1, y2)
	var width = abs(x2 - x1), height = abs(y2 - y1)
	if (width <= 0 || height <= 0) return;
	if (!shader_is_compiled(sh_rectircle)) {
		draw_roundrect(left, top, left + width, top + height, outline)
		return;
	}
	var state = __rectircle_state()
	var previous_shader = undefined
	if (state.depth == 0 || shader_current() != sh_rectircle) previous_shader = __rectircle_begin()
	try {
		var radius = clamp(corner_radius, 0, min(width, height) * 0.5)
		shader_set_uniform_f(state.rect, left, top, width, height)
		shader_set_uniform_f(state.shape, radius, outline ? 1 : 0)
		// The skipped center is beyond the outline's antialiasing band.
		var inset = 1.5 + radius * 0.16
		var right = left + width, bottom = top + height
		draw_primitive_begin(pr_trianglestrip)
		if (outline && width > inset * 2 && height > inset * 2) {
			draw_vertex(left - 0.5, top - 0.5)
			draw_vertex(left + inset, top + inset)
			draw_vertex(right + 0.5, top - 0.5)
			draw_vertex(right - inset, top + inset)
			draw_vertex(right + 0.5, bottom + 0.5)
			draw_vertex(right - inset, bottom - inset)
			draw_vertex(left - 0.5, bottom + 0.5)
			draw_vertex(left + inset, bottom - inset)
			draw_vertex(left - 0.5, top - 0.5)
			draw_vertex(left + inset, top + inset)
		} else {
			draw_vertex(left - 0.5, top - 0.5)
			draw_vertex(right + 0.5, top - 0.5)
			draw_vertex(left - 0.5, bottom + 0.5)
			draw_vertex(right + 0.5, bottom + 0.5)
		}
		draw_primitive_end()
	} catch (error) {
		show_debug_message("Rectircle rendering failed: " + string(error))
	}
	__rectircle_end(previous_shader)
}

function __rectircle_state() {
	static state = {
		rect: shader_get_uniform(sh_rectircle, "u_rect"),
		shape: shader_get_uniform(sh_rectircle, "u_shape"),
		depth: 0
	}
	return state
}

// Share setup across consecutive rectircles; keep other drawing outside this scope.
function __rectircle_begin() {
	if (!shader_is_compiled(sh_rectircle)) return undefined
	var previous_shader = shader_current()
	gpu_push_state()
	gpu_set_ztestenable(false)
	gpu_set_zwriteenable(false)
	gpu_set_alphatestenable(false)
	gpu_set_cullmode(cull_noculling)
	gpu_set_colourwriteenable(true, true, true, true)
	if (previous_shader != sh_rectircle) shader_set(sh_rectircle)
	var state = __rectircle_state()
	state.depth++
	return previous_shader
}

function __rectircle_end(previous_shader) {
	if (is_undefined(previous_shader)) return;
	if (previous_shader == -1) shader_reset()
	else if (previous_shader != sh_rectircle) shader_set(previous_shader)
	gpu_pop_state()
	var state = __rectircle_state()
	state.depth--
}
