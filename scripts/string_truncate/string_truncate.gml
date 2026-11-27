function string_truncate(str, maxwidth, truncate_start = false) {
	// string_truncate(str, maxwidth)
	// Truncates a string to maxwidth and adds ellipses (...) at the end or start
	var o = obj_controller
	var currentfont = o.currentfont
	var is_fluent = (o.theme = 3)
	var is_hires = o.hires * is_fluent
	var can_cache = variable_instance_exists(o, "src_dynamic_initialized") && o.src_dynamic_initialized
	var revision = can_cache ? o.src_dynamic_layout_revision : 0
	var key = string(currentfont) + ":" + string(is_fluent) + ":" + string(is_hires)
		+ ":" + string(revision) + ":" + string(maxwidth)
		+ ":" + string(truncate_start) + ":" + string(is_string(str)) + ":" + string(str)
	if (can_cache && ds_map_exists(o.src_dynamic_truncate_cache, key)) {
		var cached = o.src_dynamic_truncate_cache[? key]
		// Validate exact inputs in case string() rounded a numeric key component.
		if (cached.currentfont = currentfont && cached.is_fluent = is_fluent
			&& cached.is_hires = is_hires && cached.revision = revision
			&& cached.maxwidth = maxwidth && cached.truncate_start = truncate_start
			&& cached.source_is_string = is_string(str) && cached.source = str) {
			text_dynamic_cache_touch(o.src_dynamic_truncate_cache, o.src_dynamic_truncate_cache_order,
				o.src_dynamic_truncate_cache_limit, key, cached)
			draw_theme_font(currentfont)
			return cached.result
		}
		ds_map_delete(o.src_dynamic_truncate_cache, key)
	}

	var result = str
	if (string_width_dynamic(str) > maxwidth) {
		if (truncate_start) {
			result = "..." + string_maxwidth(str, maxwidth, true)
		} else {
			result = string_maxwidth(str, maxwidth) + "..."
		}
	}
	if (can_cache) {
		var entry = {
			result: result,
			currentfont: currentfont,
			is_fluent: is_fluent,
			is_hires: is_hires,
			revision: revision,
			maxwidth: maxwidth,
			truncate_start: truncate_start,
			source_is_string: is_string(str),
			source: str,
			last_used: 0,
			last_frame: 0,
			cache_token: 0
		}
		text_dynamic_cache_store(o.src_dynamic_truncate_cache, o.src_dynamic_truncate_cache_order,
			o.src_dynamic_truncate_cache_limit, key, entry)
	}
	return result
}
