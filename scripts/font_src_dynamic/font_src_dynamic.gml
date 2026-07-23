/// @description Initialise lazy Source Han Sans runtime fonts.
function font_src_dynamic_init() {
	var o = obj_controller

	// Included files are emitted lower-case by this GameMaker runtime.
	o.src_dynamic_normal_path = bundled_data_directory + "fonts/sourcehansanssc-normal.otf"
	o.src_dynamic_medium_path = bundled_data_directory + "fonts/sourcehansanssc-medium.otf"
	o.src_dynamic_available = os_browser = browser_not_a_browser
		&& file_exists(o.src_dynamic_normal_path)
		&& file_exists(o.src_dynamic_medium_path)

	// Keep these sizes and weights in sync with the existing fnt_src_* assets.
	o.src_dynamic_sizes = [
		[9, 9, 8, 8, 18, 11, 11, 10],
		[18, 18, 16, 16, 36, 22, 22, 20]
	]
	o.src_dynamic_medium = [false, true, false, false, true, false, true, false]
	o.src_dynamic_baked_glyphs = ds_map_create()
	o.src_dynamic_handles = ds_map_create()
	o.src_dynamic_glyph_states = ds_map_create()
	o.src_dynamic_queue = ds_queue_create()
	o.src_dynamic_glyphs_per_step = 8
	o.src_dynamic_step_budget_us = 500
	o.src_dynamic_texture_page_size = 1024
	o.src_dynamic_initialized = true

	if (!o.src_dynamic_available) {
		log("Dynamic Source Han fonts unavailable; using baked fnt_src_* assets")
	}
}

/// @description Report whether a baked fnt_src_* asset contains a character.
function font_src_baked_has_glyph(baked_font, char) {
	var o = obj_controller

	// font_get_info() exposes the already-baked glyph table. Cache the struct so
	// repeated text only performs a property lookup and never scans the font.
	if (!ds_map_exists(o.src_dynamic_baked_glyphs, baked_font)) {
		var info = font_get_info(baked_font)
		if (!is_struct(info) || !variable_struct_exists(info, "glyphs")) {
			// If metadata is unavailable, keep the existing baked behaviour instead
			// of replacing every Source Han character with a runtime font.
			o.src_dynamic_baked_glyphs[? baked_font] = undefined
			return true
		}
		o.src_dynamic_baked_glyphs[? baked_font] = info.glyphs
	}

	var glyphs = o.src_dynamic_baked_glyphs[? baked_font]
	if (is_undefined(glyphs)) return true
	return variable_struct_exists(glyphs, char)
}

/// @description Select an existing fnt_src_* asset without redundant state changes.
function font_src_baked_select(type, baked_font) {
	var o = obj_controller
	o.currentfont = type
	if (draw_get_font() != baked_font) draw_set_font(baked_font)
}

/// @description Return the runtime-font key for a semantic font type and resolution.
function font_src_dynamic_key(type, is_hires) {
	var o = obj_controller
	var size = o.src_dynamic_sizes[is_hires][type]
	return condstr(o.src_dynamic_medium[type], "medium_", "normal_") + string(size)
}

/// @description Queue a Source Han glyph and report whether it is ready to draw.
function font_src_dynamic_request(type, char_code, force_lores = false) {
	var o = obj_controller
	if (!o.src_dynamic_initialized || !o.src_dynamic_available) return false

	var is_hires = o.hires * !force_lores * (o.theme = 3)
	var font_key = font_src_dynamic_key(type, is_hires)
	var glyph_key = font_key + ":" + string(char_code)

	if (ds_map_exists(o.src_dynamic_glyph_states, glyph_key)) {
		return o.src_dynamic_glyph_states[? glyph_key] = 1
	}

	var size = o.src_dynamic_sizes[is_hires][type]
	var medium = o.src_dynamic_medium[type]
	o.src_dynamic_glyph_states[? glyph_key] = 0
	ds_queue_enqueue(o.src_dynamic_queue, [font_key, size, medium, char_code, glyph_key])
	return false
}

/// @description Select baked Source Han first, then a warmed runtime fallback if needed.
function font_src_dynamic_select(type, char, char_code, force_lores = false) {
	var o = obj_controller
	if (!variable_instance_exists(o, "src_dynamic_initialized") || !o.src_dynamic_initialized) {
		draw_theme_font(type, 1, force_lores)
		return false
	}

	var is_hires = o.hires * !force_lores * (o.theme = 3)
	var baked_font = o.font_table[is_hires][type][2]

	// Existing fnt_src_* assets remain the normal non-ASCII path. Only characters
	// missing from that exact baked asset are queued for the runtime OTF.
	if (font_src_baked_has_glyph(baked_font, char)) {
		font_src_baked_select(type, baked_font)
		return false
	}

	var font_key = font_src_dynamic_key(type, is_hires)

	if (font_src_dynamic_request(type, char_code, force_lores)
		&& ds_map_exists(o.src_dynamic_handles, font_key)) {
		var font = o.src_dynamic_handles[? font_key]
		if (font != -1 && font_exists(font)) {
			o.currentfont = type
			if (draw_get_font() != font) draw_set_font(font)
			return true
		}
	}

	// Preserve the current fnt_src_* font while the runtime glyph is pending.
	font_src_baked_select(type, baked_font)
	return false
}

/// @description Warm a bounded number of queued Source Han glyphs outside Draw.
function font_src_dynamic_step() {
	var o = obj_controller
	if (!o.src_dynamic_initialized || !o.src_dynamic_available) return;

	var started = get_timer()
	var processed = 0
	while (!ds_queue_empty(o.src_dynamic_queue) && processed < o.src_dynamic_glyphs_per_step) {
		var request = ds_queue_dequeue(o.src_dynamic_queue)
		var font_key = request[0]
		var size = request[1]
		var medium = request[2]
		var char_code = request[3]
		var glyph_key = request[4]

		// Ignore stale duplicate work if the state has already changed.
		if (!ds_map_exists(o.src_dynamic_glyph_states, glyph_key)
			|| o.src_dynamic_glyph_states[? glyph_key] != 0) {
			continue
		}

		var font = -1
		if (ds_map_exists(o.src_dynamic_handles, font_key)) {
			font = o.src_dynamic_handles[? font_key]
		} else {
			var old_page_size = font_texture_page_size
			font_texture_page_size = o.src_dynamic_texture_page_size
			font = font_add(
				medium ? o.src_dynamic_medium_path : o.src_dynamic_normal_path,
				size,
				false,
				false,
				32,
				127
			)
			font_texture_page_size = old_page_size
			o.src_dynamic_handles[? font_key] = font
			if (font = -1) log("Failed to load dynamic Source Han font", font_key)
		}

		if (font != -1 && font_exists(font)) {
			font_cache_glyph(font, char_code)
			o.src_dynamic_glyph_states[? glyph_key] = 1
		} else {
			o.src_dynamic_glyph_states[? glyph_key] = -1
		}

		processed += 1
		if (get_timer() - started >= o.src_dynamic_step_budget_us) break;
	}
}

/// @description Delete runtime Source Han fonts and their tracking containers.
function font_src_dynamic_shutdown() {
	var o = obj_controller
	if (!variable_instance_exists(o, "src_dynamic_initialized") || !o.src_dynamic_initialized) return;

	var handle_count = ds_map_size(o.src_dynamic_handles)
	if (handle_count > 0) {
		var key = ds_map_find_first(o.src_dynamic_handles)
		repeat (handle_count) {
			var font = o.src_dynamic_handles[? key]
			if (font != -1 && font_exists(font)) font_delete(font)
			key = ds_map_find_next(o.src_dynamic_handles, key)
		}
	}

	ds_queue_destroy(o.src_dynamic_queue)
	ds_map_destroy(o.src_dynamic_glyph_states)
	ds_map_destroy(o.src_dynamic_handles)
	ds_map_destroy(o.src_dynamic_baked_glyphs)
	o.src_dynamic_initialized = false
}
