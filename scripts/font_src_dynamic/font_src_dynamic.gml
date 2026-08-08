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
	o.src_dynamic_text_cache = ds_map_create()
	o.src_dynamic_layout_cache = ds_map_create()
	o.src_dynamic_truncate_cache = ds_map_create()
	o.src_dynamic_text_cache_order = ds_queue_create()
	o.src_dynamic_layout_cache_order = ds_queue_create()
	o.src_dynamic_truncate_cache_order = ds_queue_create()
	o.src_dynamic_text_cache_limit = 256
	o.src_dynamic_layout_cache_limit = 512
	o.src_dynamic_truncate_cache_limit = 256
	o.src_dynamic_cache_tick = 0
	o.src_dynamic_cache_frame = 0
	o.src_dynamic_cache_max_age = 1800
	o.src_dynamic_cache_prune_interval = 600
	o.src_dynamic_layout_revision = 0
	o.src_dynamic_glyphs_per_step = 8
	o.src_dynamic_step_budget_us = 500
	o.src_dynamic_texture_page_size = 1024
	o.src_dynamic_initialized = true

	if (!o.src_dynamic_available) {
		log("Dynamic Source Han fonts unavailable; using baked fnt_src_* assets")
	}
}

/// @description Update the age metadata of a cached text entry.
function text_dynamic_cache_touch(entry) {
	var o = obj_controller
	o.src_dynamic_cache_tick += 1
	entry.last_used = o.src_dynamic_cache_tick
	entry.last_frame = o.src_dynamic_cache_frame
}

/// @description Insert into a bounded cache using constant-time FIFO eviction.
function text_dynamic_cache_store(cache, order, limit, key, entry) {
	text_dynamic_cache_touch(entry)
	entry.cache_token = entry.last_used
	while (ds_map_size(cache) >= limit && !ds_queue_empty(order)) {
		var oldest = ds_queue_dequeue(order)
		var oldest_key = oldest[0]
		if (ds_map_exists(cache, oldest_key)) {
			var oldest_entry = cache[? oldest_key]
			if (oldest_entry.cache_token = oldest[1]) ds_map_delete(cache, oldest_key)
		}
	}
	// Keep the cache bounded even if an order queue was externally cleared.
	if (ds_map_size(cache) >= limit) ds_map_delete(cache, ds_map_find_first(cache))
	cache[? key] = entry
	ds_queue_enqueue(order, [key, entry.cache_token])
}

/// @description Remove cached text that has not been used recently.
function text_dynamic_cache_prune(cache, order, minimum_frame) {
	var count = ds_map_size(cache)
	var key, next_key, entry
	if (count > 0) {
		key = ds_map_find_first(cache)
		repeat (count) {
			next_key = ds_map_find_next(cache, key)
			entry = cache[? key]
			if (entry.last_frame < minimum_frame) ds_map_delete(cache, key)
			key = next_key
		}
	}

	// Drop stale queue records left behind by expiration or cache invalidation.
	ds_queue_clear(order)
	count = ds_map_size(cache)
	if (count <= 0) return;
	key = ds_map_find_first(cache)
	repeat (count) {
		entry = cache[? key]
		ds_queue_enqueue(order, [key, entry.cache_token])
		key = ds_map_find_next(cache, key)
	}
}

/// @description Age bounded text caches without scanning them every frame.
function text_dynamic_cache_step() {
	var o = obj_controller
	if (!variable_instance_exists(o, "src_dynamic_initialized") || !o.src_dynamic_initialized) return;

	o.src_dynamic_cache_frame += 1
	if (o.src_dynamic_cache_frame mod o.src_dynamic_cache_prune_interval != 0) return;

	var minimum_frame = o.src_dynamic_cache_frame - o.src_dynamic_cache_max_age
	text_dynamic_cache_prune(o.src_dynamic_layout_cache, o.src_dynamic_layout_cache_order, minimum_frame)
	text_dynamic_cache_prune(o.src_dynamic_truncate_cache, o.src_dynamic_truncate_cache_order, minimum_frame)
	text_dynamic_cache_prune(o.src_dynamic_text_cache, o.src_dynamic_text_cache_order, minimum_frame)
}

/// @description Return a cached display-composed string entry.
function text_dynamic_text_get(text) {
	var o = obj_controller
	var can_cache = variable_instance_exists(o, "src_dynamic_initialized") && o.src_dynamic_initialized
	if (can_cache && ds_map_exists(o.src_dynamic_text_cache, text)) {
		var cached = o.src_dynamic_text_cache[? text]
		text_dynamic_cache_touch(cached)
		return cached
	}

	var entry = {
		text: string_compose_display(text),
		length: -1,
		chars: undefined,
		codes: undefined,
		categories: undefined,
		last_used: 0,
		last_frame: 0,
		cache_token: 0
	}
	if (can_cache) {
		text_dynamic_cache_store(o.src_dynamic_text_cache, o.src_dynamic_text_cache_order,
			o.src_dynamic_text_cache_limit, text, entry)
	}
	return entry
}

/// @description Lazily split a composed display string into reusable glyph data.
function text_dynamic_text_parse(entry) {
	if (entry.length >= 0) return entry;

	var length = string_length(entry.text)
	entry.length = length
	entry.chars = array_create(length)
	entry.codes = array_create(length)
	entry.categories = array_create(length)
	for (var i = 0; i < length; i += 1) {
		var char = string_char_at(entry.text, i + 1)
		var char_code = ord(char)
		entry.chars[i] = char
		entry.codes[i] = char_code
		entry.categories[i] = is_nonascii(char_code)
	}
	return entry
}

/// @description Resolve and measure a parsed string for one font configuration.
function text_dynamic_layout_get(text_entry, type, force_lores = false) {
	var o = obj_controller
	text_entry = text_dynamic_text_parse(text_entry)

	var can_cache = variable_instance_exists(o, "src_dynamic_initialized") && o.src_dynamic_initialized
	var is_fluent = (o.theme = 3)
	var is_hires = o.hires * !force_lores * is_fluent
	var revision = can_cache ? o.src_dynamic_layout_revision : 0
	var key = string(type) + ":" + string(is_fluent) + ":" + string(is_hires)
		+ ":" + string(revision) + ":" + string(text_entry.text)
	if (can_cache && ds_map_exists(o.src_dynamic_layout_cache, key)) {
		var cached = o.src_dynamic_layout_cache[? key]
		// Validate the exact values as string() can round numeric key components.
		if (cached.type = type && cached.is_fluent = is_fluent
			&& cached.is_hires = is_hires && cached.revision = revision
			&& cached.text_entry.text = text_entry.text) {
			text_dynamic_cache_touch(cached)
			return cached
		}
		ds_map_delete(o.src_dynamic_layout_cache, key)
	}

	var length = text_entry.length
	var fonts = array_create(length)
	var widths = array_create(length)
	var dynamic_fonts = array_create(length)
	var line_widths = [0]
	var line = 0
	var line_width = 0
	var max_width = 0
	var category_prev = -2
	var selected_font = draw_get_font()
	for (var i = 0; i < length; i += 1) {
		var char = text_entry.chars[i]
		var char_code = text_entry.codes[i]
		var category = text_entry.categories[i]
		var uses_dynamic_font = false
		if (category = 1) {
			uses_dynamic_font = font_src_dynamic_select(type, char, char_code, force_lores)
			selected_font = draw_get_font()
		} else if (category != category_prev) {
			draw_theme_font(type, category, force_lores)
			selected_font = draw_get_font()
		}

		var char_width = string_width(char)
		fonts[i] = selected_font
		widths[i] = char_width
		dynamic_fonts[i] = uses_dynamic_font
		line_widths[line] += char_width
		line_width += char_width / (1 + is_hires + 2 * (is_hires && category != 1))
		if (char = "\n") {
			if (line_width >= max_width) max_width = line_width
			line_width = 0
			line += 1
			array_push(line_widths, 0)
		}
		category_prev = category
	}
	if (line_width >= max_width) max_width = line_width

	var layout = {
		text_entry: text_entry,
		length: length,
		fonts: fonts,
		widths: widths,
		dynamic_fonts: dynamic_fonts,
		line_widths: line_widths,
		max_width: max_width,
		type: type,
		is_fluent: is_fluent,
		is_hires: is_hires,
		revision: revision,
		last_used: 0,
		last_frame: 0,
		cache_token: 0
	}
	if (can_cache) {
		text_dynamic_cache_store(o.src_dynamic_layout_cache, o.src_dynamic_layout_cache_order,
			o.src_dynamic_layout_cache_limit, key, layout)
	}
	return layout
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
	var layout_changed = false
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
			layout_changed = true
		} else {
			o.src_dynamic_glyph_states[? glyph_key] = -1
		}

		processed += 1
		if (get_timer() - started >= o.src_dynamic_step_budget_us) break;
	}
	if (layout_changed) {
		o.src_dynamic_layout_revision += 1
		ds_map_clear(o.src_dynamic_layout_cache)
		ds_map_clear(o.src_dynamic_truncate_cache)
		ds_queue_clear(o.src_dynamic_layout_cache_order)
		ds_queue_clear(o.src_dynamic_truncate_cache_order)
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
	ds_queue_destroy(o.src_dynamic_truncate_cache_order)
	ds_queue_destroy(o.src_dynamic_layout_cache_order)
	ds_queue_destroy(o.src_dynamic_text_cache_order)
	ds_map_destroy(o.src_dynamic_truncate_cache)
	ds_map_destroy(o.src_dynamic_layout_cache)
	ds_map_destroy(o.src_dynamic_text_cache)
	ds_map_destroy(o.src_dynamic_glyph_states)
	ds_map_destroy(o.src_dynamic_handles)
	ds_map_destroy(o.src_dynamic_baked_glyphs)
	o.src_dynamic_initialized = false
}
