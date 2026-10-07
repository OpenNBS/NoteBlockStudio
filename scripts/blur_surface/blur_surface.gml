/// Blur between two caller-owned surfaces during Draw. Returns success.
/// Radius is in source pixels (3 sigma); zero copies. Input/output use straight alpha.
function blur_surface(source, destination, blur_radius) {
	if (!surface_exists(source) || !surface_exists(destination) || source == destination) return false
	if (!shader_is_compiled(sh_surface_blur)) return false
	var sw = surface_get_width(source), sh = surface_get_height(source)
	var radius = max(0, blur_radius)
	var state = __surface_effects_save()
	gpu_set_blendenable(false)
	var current = -1, work = -1, success = false
	try {
		if (radius == 0) {
			success = __blur_surface_pass(source, destination, 2, 0, 0, 0)
		} else {
			// Prefilter large blurs so the working kernel stays small.
			var reduction = min(1, 6 / radius)
			var ww = max(1, ceil(sw * reduction)), wh = max(1, ceil(sh * reduction))
			var cw = sw, ch = sh, input = source, first = true
			do {
				cw = max(ww, ceil(cw / 2))
				ch = max(wh, ceil(ch / 2))
				work = __surface_effects_acquire(cw, ch)
				if (!surface_exists(work)) break
				if (!__blur_surface_pass(input, work, 0,
					cw < surface_get_width(input) ? 0.25 / cw : 0,
					ch < surface_get_height(input) ? 0.25 / ch : 0, first ? 1 : 0)) break
				if (current != -1) __surface_effects_release(current)
				current = work
				work = -1
				input = current
				first = false
			} until (cw == ww && ch == wh)
			if (current != -1 && work == -1 && surface_get_width(current) == ww && surface_get_height(current) == wh) {
				work = __surface_effects_acquire(ww, wh)
				if (surface_exists(work)) {
					success = __blur_surface_pass(current, work, 1, radius / (6 * sw), 0, 0)
					if (success) success = __blur_surface_pass(work, current, 1, 0, radius / (6 * sh), 0)
					if (success) success = __blur_surface_pass(current, destination, 2, 0, 0, 2)
				}
			}
		}
	} catch (error) {
		show_debug_message("Blur rendering failed: " + string(error))
		success = false
	}
	if (current != -1) __surface_effects_release(current)
	if (work != -1) __surface_effects_release(work)
	__surface_effects_restore(state)
	return success
}

// One downsample, blur, or copy pass.
function __blur_surface_pass(source, destination, mode, step_x, step_y, alpha_mode) {
	if (!__surface_effects_target(destination)) return false
	var success = false
	try {
		shader_set(sh_surface_blur)
		shader_set_uniform_f(__surface_effects_uniform(sh_surface_blur, "u_mode"), mode)
		shader_set_uniform_f(__surface_effects_uniform(sh_surface_blur, "u_step"), step_x, step_y)
		shader_set_uniform_f(__surface_effects_uniform(sh_surface_blur, "u_alpha_mode"), alpha_mode)
		shader_set_uniform_f(__surface_effects_uniform(sh_surface_blur, "u_texel"), 1 / surface_get_width(source), 1 / surface_get_height(source))
		draw_surface_stretched(source, 0, 0, surface_get_width(destination), surface_get_height(destination))
		success = true
	} catch (error) {
		show_debug_message("Blur pass failed: " + string(error))
	}
	surface_reset_target()
	return success
}
