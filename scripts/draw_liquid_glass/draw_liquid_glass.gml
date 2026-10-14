/// Draw glass below text/icons. Can use partial material settings and returns success.
/// Uses view coordinates for application_surface, pixels for other surfaces.
function draw_liquid_glass(source, x, y, width, height, material = undefined) {
	if (width <= 0 || height <= 0 || !surface_exists(source) || !shader_is_compiled(sh_liquid_glass)) return false
	var m = liquid_glass_settings("regular", false, material)
	var alpha = clamp(m.alpha, 0, 1) * draw_get_alpha()
	if (alpha <= 0) return true
	var blur_radius = max(0, m.blur_radius)
	var padding = max(blur_radius + abs(m.inner_refraction_amount) + abs(m.outer_refraction_amount) + abs(m.edge_refraction_amount) + abs(m.aberration_amount) + 2,
		max(0, m.shadow_softness) * 3 + max(abs(m.shadow_offset_x), abs(m.shadow_offset_y)) + 2)
	var capture = __surface_effects_capture(source, x, y, width, height, padding)
	if (is_undefined(capture)) return false
	var blurred = -1, success = false
	var state = __surface_effects_save()
	try {
		var background = capture.surface
		if (blur_radius > 0 && m.blur_opacity > 0) {
			blurred = __surface_effects_acquire(surface_get_width(background), surface_get_height(background))
			if (surface_exists(blurred) && blur_surface(background, blurred, blur_radius * max(capture.scale_x, capture.scale_y))) background = blurred
		}
		shader_set(sh_liquid_glass)
		var sampler = shader_get_sampler_index(sh_liquid_glass, "u_blurred")
		texture_set_stage(sampler, surface_get_texture(background))
		gpu_set_texfilter_ext(sampler, true)
		gpu_set_texrepeat_ext(sampler, false)
		gpu_set_blendenable(true)
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha)
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_size"), capture.width, capture.height)
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_texel"), 1 / surface_get_width(capture.surface), 1 / surface_get_height(capture.surface))
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_rect"), x - capture.x, y - capture.y, width, height)
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_shape"), max(0, m.corner_radius),
			max(1 / min(capture.scale_x, capture.scale_y), m.edge_softness), clamp(m.blur_opacity, 0, 1), alpha)
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_edge_refraction"), m.edge_refraction_amount,
			max(0, m.edge_refraction_width))
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_refraction"), m.inner_refraction_amount,
			max(0.01, m.inner_refraction_height), m.outer_refraction_amount, max(0.01, m.outer_refraction_height))
		__surface_effects_color(sh_liquid_glass, "u_tint", m.tint_color, clamp(m.tint_opacity, 0, 1))
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_color"), max(0, m.saturation), m.brightness, clamp(m.adaptive_tint, 0, 1), 0)
		__surface_effects_color(sh_liquid_glass, "u_highlight", m.highlight_color, max(0, m.highlight_intensity))
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_light"), lengthdir_x(1, m.highlight_angle), lengthdir_y(1, m.highlight_angle),
			max(0.01, m.highlight_width), clamp(m.highlight_spread, 0, 1))
		__surface_effects_color(sh_liquid_glass, "u_shadow", m.shadow_color, clamp(m.shadow_opacity, 0, 1))
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_shadow_shape"), m.shadow_offset_x, m.shadow_offset_y,
			max(0.01, m.shadow_softness), clamp(m.rim_shadow_opacity, 0, 1))
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_rim_width"), max(0.01, m.rim_shadow_width))
		shader_set_uniform_f(__surface_effects_uniform(sh_liquid_glass, "u_aberration"), m.aberration_amount, max(0.01, m.aberration_height),
			lengthdir_x(1, m.aberration_angle), lengthdir_y(1, m.aberration_angle))
		draw_surface_stretched(capture.surface, capture.x, capture.y, capture.width, capture.height)
		success = true
	} catch (error) {
		show_debug_message("Liquid Glass rendering failed: " + string(error))
	}
	__surface_effects_restore(state)
	__surface_effects_release(capture.surface)
	if (blurred != -1) __surface_effects_release(blurred)
	return success
}
