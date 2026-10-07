// Surface pool and draw-state helpers shared by blur and glass.
function __surface_effects_state() {
	if (!variable_global_exists("surface_effects") || is_undefined(global.surface_effects)) {
		global.surface_effects = { pool: [], clock: 0, camera: camera_create_view(0, 0, 1, 1), uniforms: {} }
	}
	return global.surface_effects
}

function __surface_effects_acquire(width, height) {
	width = max(1, ceil(width))
	height = max(1, ceil(height))
	var state = __surface_effects_state()
	state.clock++
	// Discard lost handles before GameMaker reuses their IDs.
	for (var i = array_length(state.pool) - 1; i >= 0; i--) {
		if (!surface_exists(state.pool[i].surface)) array_delete(state.pool, i, 1)
	}
	var oldest = -1
	for (var i = 0; i < array_length(state.pool); i++) {
		var entry = state.pool[i]
		if (entry.used) continue
		if (entry.width == width && entry.height == height && surface_exists(entry.surface)) {
			entry.used = true
			entry.stamp = state.clock
			return entry.surface
		}
		if (oldest == -1 || entry.stamp < state.pool[oldest].stamp) oldest = i
	}
	var surf = surface_create(width, height)
	if (!surface_exists(surf)) return -1
	var record = { surface: surf, width: width, height: height, used: true, stamp: state.clock }
	if (array_length(state.pool) >= 16 && oldest != -1) {
		if (surface_exists(state.pool[oldest].surface)) surface_free(state.pool[oldest].surface)
		state.pool[oldest] = record
	} else {
		array_push(state.pool, record)
	}
	return surf
}

function __surface_effects_release(surf) {
	if (!variable_global_exists("surface_effects") || is_undefined(global.surface_effects)) return;
	var state = global.surface_effects
	for (var i = 0; i < array_length(state.pool); i++) {
		if (state.pool[i].surface == surf) {
			state.pool[i].used = false
			return;
		}
	}
}

function __surface_effects_uniform(shader, name) {
	var cache = __surface_effects_state().uniforms
	var key = string(shader) + ":" + name
	if (!variable_struct_exists(cache, key)) variable_struct_set(cache, key, shader_get_uniform(shader, name))
	return variable_struct_get(cache, key)
}

function __surface_effects_save() {
	var state = {
		shader: shader_current(), color: draw_get_color(), alpha: draw_get_alpha(),
		world: matrix_get(matrix_world), view: matrix_get(matrix_view), projection: matrix_get(matrix_projection)
	}
	gpu_push_state()
	shader_reset()
	draw_set_color(c_white)
	draw_set_alpha(1)
	gpu_set_ztestenable(false)
	gpu_set_zwriteenable(false)
	gpu_set_alphatestenable(false)
	gpu_set_cullmode(cull_noculling)
	gpu_set_colourwriteenable(true, true, true, true)
	gpu_set_texfilter(true)
	gpu_set_texrepeat(false)
	return state
}

function __surface_effects_restore(state) {
	matrix_set(matrix_world, state.world)
	matrix_set(matrix_view, state.view)
	matrix_set(matrix_projection, state.projection)
	if (state.shader == -1) shader_reset()
	else shader_set(state.shader)
	draw_set_color(state.color)
	draw_set_alpha(state.alpha)
	gpu_pop_state()
}

function __surface_effects_target(surf) {
	if (!surface_set_target(surf)) return false
	var camera = __surface_effects_state().camera
	camera_set_view_size(camera, surface_get_width(surf), surface_get_height(surf))
	camera_apply(camera)
	matrix_set(matrix_world, matrix_build_identity())
	return true
}

// Capture a padded rectangle. Release the returned surface after drawing.
function __surface_effects_capture(source, x, y, width, height, padding) {
	if (!surface_exists(source) || width <= 0 || height <= 0) return undefined
	var sw = surface_get_width(source), sh = surface_get_height(source)
	var sx = 1, sy = 1, vx = 0, vy = 0, px = 0, py = 0
	if (source == application_surface && view_enabled && view_current >= 0) {
		var camera = view_camera[view_current]
		if (camera != -1) {
			sx = view_wport[view_current] / camera_get_view_width(camera)
			sy = view_hport[view_current] / camera_get_view_height(camera)
			vx = camera_get_view_x(camera)
			vy = camera_get_view_y(camera)
			px = view_xport[view_current]
			py = view_yport[view_current]
		}
	}
	var left = max(0, floor(px + (x - padding - vx) * sx))
	var top = max(0, floor(py + (y - padding - vy) * sy))
	var right = min(sw, ceil(px + (x + width + padding - vx) * sx))
	var bottom = min(sh, ceil(py + (y + height + padding - vy) * sy))
	if (right <= left || bottom <= top) return undefined
	var surf = __surface_effects_acquire(right - left, bottom - top)
	if (!surface_exists(surf)) return undefined
	var saved = __surface_effects_save()
	var captured = false
	if (__surface_effects_target(surf)) {
		try {
			// LTS surface_copy_part can blend into old pixels, so draw the copy ourselves.
			gpu_set_blendenable(false)
			draw_surface_part(source, left, top, right - left, bottom - top, 0, 0)
			// Backdrop colors already include the scene's transparency.
			gpu_set_colourwriteenable(false, false, false, true)
			draw_rectangle(0, 0, right - left, bottom - top, false)
			captured = true
		} catch (error) {
			show_debug_message("Backdrop capture failed: " + string(error))
		}
		surface_reset_target()
	}
	__surface_effects_restore(saved)
	if (!captured) {
		__surface_effects_release(surf)
		return undefined
	}
	return { surface: surf, x: vx + (left - px) / sx, y: vy + (top - py) / sy,
		width: (right - left) / sx, height: (bottom - top) / sy, scale_x: sx, scale_y: sy }
}

function __surface_effects_color(shader, uniform, color, alpha) {
	shader_set_uniform_f(__surface_effects_uniform(shader, uniform),
		color_get_red(color) / 255, color_get_green(color) / 255, color_get_blue(color) / 255, alpha)
}
