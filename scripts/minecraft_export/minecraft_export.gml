/// Shared sound-command planning for data-pack and command-block exports.
/// Sound Stopper is occurrence based: Minecraft can only distinguish the final
/// sound event and source, so overlapping occurrences are colored onto the
/// fewest source categories the bounded search can prove.

function minecraft_export_sources() {
	return ["ambient", "block", "hostile", "master", "music", "neutral", "player", "record", "voice", "weather"]
}

function minecraft_export_source_label(source) {
	// Keep command identifiers visible in English; use Minecraft's official
	// Simplified Chinese sound-category names in the Chinese interface.
	if (obj_controller.language != 1) return source
	switch (source) {
		case "ambient": return "环境"
		case "block": return "方块"
		case "hostile": return "敌对生物"
		case "master": return "主音量"
		case "music": return "音乐"
		case "neutral": return "友好生物"
		case "player": return "玩家"
		case "record": return "唱片机/音符盒"
		case "voice": return "复述功能/语音"
		case "weather": return "天气"
	}
	return source
}

function minecraft_export_default_allowed_sources() {
	// Master is deliberately opt-in. Music remains independently toggleable.
	return [true, true, true, false, true, true, true, true, true, true]
}

function minecraft_export_clone_array(values) {
	var result = []
	for (var i = 0; i < array_length(values); i++) array_push(result, values[i])
	return result
}

function minecraft_export_source_palette(preferred, allowed) {
	var names = minecraft_export_sources()
	if (!is_array(allowed) || array_length(allowed) != array_length(names)) {
		allowed = minecraft_export_default_allowed_sources()
	}
	var preferred_index = -1
	for (var i = 0; i < array_length(names); i++) if (names[i] == preferred) preferred_index = i
	if (preferred_index < 0) preferred_index = 7
	// Master is never used until its dedicated allowlist checkbox is ticked,
	// even if an older setting still names it as the preferred source.
	if (preferred_index == 3 && !allowed[3]) {
		preferred_index = 7
		if (!allowed[preferred_index]) for (var i = 0; i < array_length(names); i++) if (i != 3 && allowed[i]) { preferred_index = i; break }
	}
	if (!allowed[preferred_index]) {
		// Non-Master preferred sources are an explicit choice and stay usable.
		allowed[preferred_index] = true
	}
	var result = [names[preferred_index]]
	for (var i = 0; i < array_length(names); i++) {
		if (i != preferred_index && i != 3 && allowed[i]) array_push(result, names[i])
	}
	// Master is always the final fallback unless explicitly preferred.
	if (preferred_index != 3 && allowed[3]) array_push(result, "master")
	return result
}

function minecraft_export_snapped_speed(tempo) {
	// 80 score units per song tick / 20 game ticks per second = tempo * 4.
	return max(1, round(abs(tempo) * 4))
}

function minecraft_export_tempo_from_note(song_instance, tick, layer) {
	return floor(abs(song_instance.song_pit[tick, layer])) / 15
}

function minecraft_export_is_event(instrument) {
	return instance_exists(instrument) && custom_instrument_is_event(instrument.name)
}

function minecraft_export_sanitize_part(value) {
	value = string_lower(string_replace_all(string(value), "\\", "/"))
	var result = ""
	var previous_separator = false
	for (var i = 1; i <= string_length(value); i++) {
		var ch = string_char_at(value, i)
		var valid = string_pos(ch, "abcdefghijklmnopqrstuvwxyz0123456789_.-/") > 0
		if (valid) {
			result += ch
			previous_separator = false
		} else if (!previous_separator) {
			result += "_"
			previous_separator = true
		}
	}
	while (string_length(result) > 0 && string_char_at(result, 1) == "/") result = string_delete(result, 1, 1)
	while (string_length(result) > 0 && string_char_at(result, string_length(result)) == "/") result = string_delete(result, string_length(result), 1)
	return result
}

function minecraft_export_resource_location(value) {
	value = string_replace_all(string(value), "\\", "/")
	var namespace = "minecraft"
	var path = value
	var separator = string_pos(":", value)
	if (separator > 0) {
		namespace = string_copy(value, 1, separator - 1)
		path = string_copy(value, separator + 1, string_length(value))
	} else if (string_pos("minecraft/", string_lower(value)) == 1) {
		path = string_copy(value, 11, string_length(value))
	}
	namespace = minecraft_export_sanitize_part(namespace)
	path = minecraft_export_sanitize_part(path)
	if (namespace == "") namespace = "minecraft"
	if (path == "") path = "unnamed_instrument"
	return namespace + ":" + path
}

function minecraft_export_ensure_mapping(instrument, instrument_index) {
	if (!instance_exists(instrument)) return ""
	if (!variable_instance_exists(instrument, "minecraft_sound")) instrument.minecraft_sound = ""
	if (!variable_instance_exists(instrument, "minecraft_sound_manual")) instrument.minecraft_sound_manual = false
	if (minecraft_export_is_event(instrument)) {
		// Event instrument names are intentionally reserved and remain blank.
		instrument.minecraft_sound = ""
		instrument.minecraft_sound_manual = false
		return ""
	}
	if (instrument_index < obj_controller.first_custom_index) return dat_instrument(instrument_index)
	if (instrument.minecraft_sound == "" && !instrument.minecraft_sound_manual) {
		instrument.minecraft_sound = minecraft_export_resource_location(instrument.name)
	}
	return minecraft_export_resource_location(instrument.minecraft_sound)
}

function minecraft_export_effective_key(song_instance, tick, layer, instrument_index) {
	var instrument = song_instance.instrument_list[| instrument_index]
	return song_instance.song_key[tick, layer] + song_instance.song_pit[tick, layer] / 100 + instrument.key - 45
}

function minecraft_export_sound_event(song_instance, tick, layer, instrument_index) {
	var event_name = minecraft_export_ensure_mapping(song_instance.instrument_list[| instrument_index], instrument_index)
	if (event_name == "") return ""
	var key = minecraft_export_effective_key(song_instance, tick, layer, instrument_index)
	if (key < 33) event_name += "_-1"
	else if (key > 57) event_name += "_1"
	return event_name
}

function minecraft_export_pitch(key) {
	return dat_pitch(key)
}

function minecraft_export_note_duration(song_instance, tick, layer, instrument_index) {
	var instrument = song_instance.instrument_list[| instrument_index]
	if (!instrument.loaded || instrument.sound_duration <= 0) return infinity
	var keyshift = song_instance.song_key[tick, layer] + instrument.key + song_instance.song_pit[tick, layer] / 100 - 78
	var emitter_pitch = 0.5 * power(2, keyshift / 12)
	if (variable_instance_exists(instrument, "resourcepack_pitch")) emitter_pitch *= instrument.resourcepack_pitch
	return instrument.sound_duration / max(emitter_pitch, 0.000000001)
}

function minecraft_export_stopper_range(song_instance, tick, layer) {
	var start_layer = floor(song_instance.song_pit[tick, layer])
	var end_layer = panning_velocity_to_short(song_instance.song_pan[tick, layer], song_instance.song_vel[tick, layer])
	start_layer = max(0, start_layer)
	end_layer = max(start_layer, end_layer)
	return [start_layer, end_layer]
}

function minecraft_export_layer_targeted(one_based_layer, layer_range) {
	return layer_range[0] == 0 || (one_based_layer >= layer_range[0] && one_based_layer <= layer_range[1])
}

function minecraft_export_array_contains(values, wanted) {
	for (var i = 0; i < array_length(values); i++) if (values[i] == wanted) return true
	return false
}

function minecraft_export_array_remove_value(values, wanted) {
	for (var i = array_length(values) - 1; i >= 0; i--) {
		if (values[i] == wanted) array_delete(values, i, 1)
	}
}

function minecraft_export_timing(song_instance, mode, include_locked, tempo_grid, direct_tps) {
	var wall = array_create(song_instance.enda + 2, 0)
	var grid_ticks = array_create(song_instance.enda + 2, 0)
	var tempo_speed = minecraft_export_snapped_speed(song_instance.real_tempo)
	for (var tick = 0; tick <= song_instance.enda + 1; tick++) {
		if (tick > 0) {
			if (mode == "command" && !tempo_grid) wall[tick] = tick / direct_tps
			else wall[tick] = wall[tick - 1] + 4 / tempo_speed
		}
		if (tick <= song_instance.enda && (mode == "datapack" || tempo_grid) && song_instance.colamount[tick] > 0) {
			for (var layer_index = 0; layer_index <= song_instance.collast[tick]; layer_index++) {
				if (!song_instance.song_exists[tick, layer_index]) continue
				if (!include_locked && obj_controller.lockedlayer[layer_index]) continue
				var instrument_index = ds_list_find_index(song_instance.instrument_list, song_instance.song_ins[tick, layer_index])
				if (instrument_index >= 0 && song_instance.instrument_list[| instrument_index].name == "Tempo Changer") {
					tempo_speed = minecraft_export_snapped_speed(minecraft_export_tempo_from_note(song_instance, tick, layer_index))
				}
			}
		}
		// Command structures may use a 10, 5, or 2.5 redstone-tick grid.
		// direct_tps is the grid selected in the export window.
		grid_ticks[tick] = (mode == "command" && tempo_grid) ? round(wall[tick] * direct_tps) : tick
	}
	return { wall: wall, grid: grid_ticks }
}

function minecraft_export_add_unique_target(stopper, occurrence_index) {
	if (!minecraft_export_array_contains(stopper.targets, occurrence_index)) array_push(stopper.targets, occurrence_index)
}

function minecraft_export_add_risk(risks, risk_map, target, victim, stopper, lost_ticks) {
	var key = string(target) + ":" + string(victim)
	if (ds_map_exists(risk_map, key)) {
		var existing_index = risk_map[? key]
		if (lost_ticks > risks[existing_index].lost) {
			risks[existing_index].lost = max(0, lost_ticks)
			risks[existing_index].stopper = stopper
		}
		return
	}
	var risk = { target: target, victim: victim, stopper: stopper, lost: max(0, lost_ticks) }
	ds_map_add(risk_map, key, array_length(risks))
	array_push(risks, risk)
}

function minecraft_export_risk_objective(risks, colors) {
	var victims = ds_map_create()
	for (var i = 0; i < array_length(risks); i++) {
		var risk = risks[i]
		if (colors[risk.target] != colors[risk.victim]) continue
		var key = string(risk.victim)
		if (!ds_map_exists(victims, key)) ds_map_add(victims, key, risk.lost)
		else victims[? key] = max(victims[? key], risk.lost)
	}
	var lost = 0
	var victim_key = ds_map_find_first(victims)
	while (!is_undefined(victim_key)) {
		lost += victims[? victim_key]
		victim_key = ds_map_find_next(victims, victim_key)
	}
	var result = [ds_map_size(victims), lost]
	ds_map_destroy(victims)
	return result
}

function minecraft_export_lossy_subset_leaf(state) {
	state.budget.work++
	if (state.budget.work > state.budget.maximum_work || get_timer() > state.budget.deadline) {
		state.budget.limited = true
		return
	}
	var adjacency = array_create(state.play_count)
	for (var i = 0; i < state.play_count; i++) adjacency[i] = []
	for (var i = 0; i < array_length(state.risks); i++) {
		var risk = state.risks[i]
		if (ds_map_exists(state.sacrificed, risk.victim)) continue
		if (risk.target == risk.victim) return
		if (!minecraft_export_array_contains(adjacency[risk.target], risk.victim)) array_push(adjacency[risk.target], risk.victim)
		if (!minecraft_export_array_contains(adjacency[risk.victim], risk.target)) array_push(adjacency[risk.victim], risk.target)
	}
	var attempt = minecraft_export_k_color(state.component, adjacency, state.palette_count, state.budget)
	if (attempt.limited || !attempt.found) return
	state.found_at_count = true
	var objective = minecraft_export_risk_objective(state.risks, attempt.colors)
	if (minecraft_export_objective_less(objective, state.best_objective)) {
		state.best_objective = objective
		state.best_colors = attempt.colors
	}
}

function minecraft_export_lossy_subset_search(state, position, remaining) {
	if (state.budget.limited) return
	if (remaining == 0) { minecraft_export_lossy_subset_leaf(state); return }
	if (position >= array_length(state.candidates) || array_length(state.candidates) - position < remaining) return
	var victim = state.candidates[position]
	state.sacrificed[? victim] = true
	minecraft_export_lossy_subset_search(state, position + 1, remaining - 1)
	ds_map_delete(state.sacrificed, victim)
	minecraft_export_lossy_subset_search(state, position + 1, remaining)
}

function minecraft_export_lossy_coloring(component, component_risks, play_count, palette_count, budget, initial_colors, clique_cutoff_lower_bound) {
	var victims = []
	var victim_seen = ds_map_create()
	var sacrificed = ds_map_create()
	var forced_count = 0
	for (var i = 0; i < array_length(component_risks); i++) {
		var risk = component_risks[i]
		if (!ds_map_exists(victim_seen, risk.victim)) { ds_map_add(victim_seen, risk.victim, true); array_push(victims, risk.victim) }
		if (risk.target == risk.victim && !ds_map_exists(sacrificed, risk.victim)) { ds_map_add(sacrificed, risk.victim, true); forced_count++ }
	}
	ds_map_destroy(victim_seen)
	var candidates = []
	for (var i = 0; i < array_length(victims); i++) if (!ds_map_exists(sacrificed, victims[i])) array_push(candidates, victims[i])
	var best_objective = minecraft_export_risk_objective(component_risks, initial_colors)
	var state = {
		component: component, risks: component_risks, play_count: play_count,
		palette_count: palette_count, budget: budget, sacrificed: sacrificed,
		candidates: candidates, best_colors: initial_colors,
		best_objective: best_objective, found_at_count: false
	}
	var cutoff_lower_bound = max(clique_cutoff_lower_bound, forced_count)
	// Reaching a clique/self-risk lower bound proves the primary objective even
	// if the remaining budget is only able to heuristically improve duration.
	var proven = best_objective[0] == cutoff_lower_bound
	var maximum_extra = min(array_length(candidates), max(0, best_objective[0] - forced_count))
	var minimum_extra = max(0, cutoff_lower_bound - forced_count)
	for (var extra = minimum_extra; extra <= maximum_extra; extra++) {
		state.found_at_count = false
		minecraft_export_lossy_subset_search(state, 0, extra)
		if (budget.limited) break
		if (state.found_at_count) { proven = true; break }
	}
	ds_map_destroy(sacrificed)
	return { colors: state.best_colors, objective: state.best_objective, cutoff_proven: proven }
}

function minecraft_export_objective_less(first, second) {
	return first[0] < second[0] || (first[0] == second[0] && first[1] < second[1])
}

function minecraft_export_greedy_colors(vertices, adjacency, maximum_colors) {
	var colors = array_create(array_length(adjacency), -1)
	var remaining = minecraft_export_clone_array(vertices)
	var class_sizes = array_create(max(1, maximum_colors), 0)
	while (array_length(remaining) > 0) {
		var selected_position = 0
		var selected_saturation = -1
		var selected_degree = -1
		for (var p = 0; p < array_length(remaining); p++) {
			var vertex = remaining[p]
			var used = ds_map_create()
			for (var n = 0; n < array_length(adjacency[vertex]); n++) {
				var neighbor_color = colors[adjacency[vertex][n]]
				if (neighbor_color >= 0) used[? neighbor_color] = true
			}
			var saturation = ds_map_size(used)
			ds_map_destroy(used)
			if (saturation > selected_saturation || (saturation == selected_saturation && array_length(adjacency[vertex]) > selected_degree)) {
				selected_position = p
				selected_saturation = saturation
				selected_degree = array_length(adjacency[vertex])
			}
		}
		var vertex = remaining[selected_position]
		var best_color = 0
		var best_conflicts = infinity
		var color_limit = max(1, maximum_colors)
		for (var color = 0; color < color_limit; color++) {
			var conflicts = 0
			for (var n = 0; n < array_length(adjacency[vertex]); n++) conflicts += colors[adjacency[vertex][n]] == color
			if (conflicts < best_conflicts || (conflicts == best_conflicts && class_sizes[color] < class_sizes[best_color])) {
				best_color = color
				best_conflicts = conflicts
			}
		}
		colors[vertex] = best_color
		class_sizes[best_color]++
		array_delete(remaining, selected_position, 1)
	}
	return colors
}

function minecraft_export_k_color_search(state) {
	state.work++
	if (state.work > state.maximum_work || get_timer() > state.deadline) {
		state.limited = true
		return false
	}
	var selected = -1
	var selected_saturation = -1
	var selected_degree = -1
	for (var p = 0; p < array_length(state.vertices); p++) {
		var vertex = state.vertices[p]
		if (state.colors[vertex] >= 0) continue
		var used = ds_map_create()
		for (var n = 0; n < array_length(state.adjacency[vertex]); n++) {
			var neighbor_color = state.colors[state.adjacency[vertex][n]]
			if (neighbor_color >= 0) used[? neighbor_color] = true
		}
		var saturation = ds_map_size(used)
		ds_map_destroy(used)
		if (saturation > selected_saturation || (saturation == selected_saturation && array_length(state.adjacency[vertex]) > selected_degree)) {
			selected = vertex
			selected_saturation = saturation
			selected_degree = array_length(state.adjacency[vertex])
		}
	}
	if (selected < 0) return true
	for (var color = 0; color < state.color_count; color++) {
		var valid = true
		for (var n = 0; n < array_length(state.adjacency[selected]); n++) {
			if (state.colors[state.adjacency[selected][n]] == color) { valid = false; break }
		}
		if (!valid) continue
		state.colors[selected] = color
		if (minecraft_export_k_color_search(state)) return true
		state.colors[selected] = -1
		if (state.limited) return false
	}
	return false
}

function minecraft_export_k_color(vertices, adjacency, color_count, budget) {
	var state = {
		vertices: vertices,
		adjacency: adjacency,
		colors: array_create(array_length(adjacency), -1),
		color_count: color_count,
		work: budget.work,
		maximum_work: budget.maximum_work,
		deadline: budget.deadline,
		limited: false
	}
	var found = minecraft_export_k_color_search(state)
	budget.work = state.work
	budget.limited = budget.limited || state.limited
	return { found: found, colors: state.colors, limited: state.limited }
}

function minecraft_export_connected_components(vertices, adjacency) {
	var components = []
	var seen = ds_map_create()
	for (var i = 0; i < array_length(vertices); i++) {
		var start = vertices[i]
		if (ds_map_exists(seen, start)) continue
		var stack = [start]
		var component = []
		ds_map_add(seen, start, true)
		while (array_length(stack) > 0) {
			var vertex = array_pop(stack)
			array_push(component, vertex)
			for (var n = 0; n < array_length(adjacency[vertex]); n++) {
				var neighbor = adjacency[vertex][n]
				if (!ds_map_exists(seen, neighbor)) {
					ds_map_add(seen, neighbor, true)
					array_push(stack, neighbor)
				}
			}
		}
		array_push(components, component)
	}
	ds_map_destroy(seen)
	return components
}

function minecraft_export_greedy_clique_lower_bound(vertices, adjacency) {
	if (array_length(vertices) == 0) return 0
	var best = 1
	var starts = minecraft_export_clone_array(vertices)
	// A handful of high-degree starts finds the important reverse-stop cliques
	// without turning this lower-bound shortcut into its own UI bottleneck.
	var start_limit = min(12, array_length(starts))
	for (var pass = 0; pass < start_limit; pass++) {
		var start_position = 0
		for (var i = 1; i < array_length(starts); i++) {
			if (array_length(adjacency[starts[i]]) > array_length(adjacency[starts[start_position]])) start_position = i
		}
		var start = starts[start_position]
		array_delete(starts, start_position, 1)
		var candidates = minecraft_export_clone_array(adjacency[start])
		var clique_size = 1
		while (array_length(candidates) > 0) {
			var candidate_map = ds_map_create()
			for (var i = 0; i < array_length(candidates); i++) ds_map_add(candidate_map, candidates[i], true)
			var selected_position = 0
			var selected_intersections = -1
			var selected_degree = -1
			for (var i = 0; i < array_length(candidates); i++) {
				var vertex = candidates[i]
				var intersections = 0
				for (var n = 0; n < array_length(adjacency[vertex]); n++) intersections += ds_map_exists(candidate_map, adjacency[vertex][n])
				if (intersections > selected_intersections || (intersections == selected_intersections && array_length(adjacency[vertex]) > selected_degree)) {
					selected_position = i
					selected_intersections = intersections
					selected_degree = array_length(adjacency[vertex])
				}
			}
			var selected = candidates[selected_position]
			ds_map_destroy(candidate_map)
			clique_size++
			var selected_neighbors = ds_map_create()
			for (var n = 0; n < array_length(adjacency[selected]); n++) ds_map_add(selected_neighbors, adjacency[selected][n], true)
			var next_candidates = []
			for (var i = 0; i < array_length(candidates); i++) {
				var candidate = candidates[i]
				if (candidate != selected && ds_map_exists(selected_neighbors, candidate)) array_push(next_candidates, candidate)
			}
			ds_map_destroy(selected_neighbors)
			candidates = next_candidates
		}
		best = max(best, clique_size)
	}
	return best
}

function minecraft_export_assign_colors(play_count, risks, palette_count, full_search = true) {
	var adjacency = array_create(play_count)
	for (var i = 0; i < play_count; i++) adjacency[i] = []
	var risk_vertices = []
	var risk_seen = ds_map_create()
	var self_risk_vertices = ds_map_create()
	var self_risk = false
	for (var i = 0; i < array_length(risks); i++) {
		var risk = risks[i]
		if (!ds_map_exists(risk_seen, risk.target)) { ds_map_add(risk_seen, risk.target, true); array_push(risk_vertices, risk.target) }
		if (!ds_map_exists(risk_seen, risk.victim)) { ds_map_add(risk_seen, risk.victim, true); array_push(risk_vertices, risk.victim) }
		if (risk.target == risk.victim) { self_risk = true; self_risk_vertices[? risk.target] = true }
		else {
			if (!minecraft_export_array_contains(adjacency[risk.target], risk.victim)) array_push(adjacency[risk.target], risk.victim)
			if (!minecraft_export_array_contains(adjacency[risk.victim], risk.target)) array_push(adjacency[risk.victim], risk.target)
		}
	}
	ds_map_destroy(risk_seen)
	var colors = array_create(play_count, 0)
	var exact = !self_risk
	var minimum_proven = !self_risk
	var cutoff_proven = true
	var required = 1
	var budget = {
		work: 0,
		maximum_work: full_search ? 150000 : 20000,
		deadline: get_timer() + (full_search ? 1500000 : 200000),
		limited: false
	}
	var components = minecraft_export_connected_components(risk_vertices, adjacency)
	for (var c = 0; c < array_length(components); c++) {
		var component = components[c]
		var component_map = ds_map_create()
		for (var i = 0; i < array_length(component); i++) ds_map_add(component_map, component[i], true)
		var component_risks = []
		for (var i = 0; i < array_length(risks); i++) {
			if (ds_map_exists(component_map, risks[i].target) && ds_map_exists(component_map, risks[i].victim)) array_push(component_risks, risks[i])
		}
		ds_map_destroy(component_map)
		var component_self_risk = false
		for (var i = 0; i < array_length(component); i++) component_self_risk = component_self_risk || ds_map_exists(self_risk_vertices, component[i])
		var unrestricted = minecraft_export_greedy_colors(component, adjacency, array_length(component))
		var upper = 1
		for (var i = 0; i < array_length(component); i++) upper = max(upper, unrestricted[component[i]] + 1)
		var selected = unrestricted
		var component_required = upper
		var proven = upper <= 2
		if (!component_self_risk && upper > 1) {
			for (var k = 1; k < upper; k++) {
				var attempt = minecraft_export_k_color(component, adjacency, k, budget)
				if (attempt.limited) { proven = false; break }
				if (attempt.found) { selected = attempt.colors; component_required = k; proven = true; break }
				if (k == upper - 1) proven = true
			}
		}
		if (component_required > palette_count || component_self_risk) {
			exact = false
			selected = minecraft_export_greedy_colors(component, adjacency, palette_count)
			// Choose the smallest set of voices that may be sacrificed, then
			// prefer the coloring with the lowest conservative lost duration.
			// The shared work/deadline budget keeps this safe for the UI thread.
			var clique_cutoff_lower_bound = max(0, minecraft_export_greedy_clique_lower_bound(component, adjacency) - palette_count)
			var lossy = minecraft_export_lossy_coloring(component, component_risks, play_count, palette_count, budget, selected, clique_cutoff_lower_bound)
			selected = lossy.colors
			cutoff_proven = cutoff_proven && lossy.cutoff_proven
		}
		for (var i = 0; i < array_length(component); i++) colors[component[i]] = selected[component[i]]
		required = max(required, component_required)
		minimum_proven = minimum_proven && proven
	}
	ds_map_destroy(self_risk_vertices)
	var objective = minecraft_export_risk_objective(risks, colors)
	return {
		colors: colors,
		exact: exact && objective[0] == 0,
		required: required,
		minimum_proven: minimum_proven,
		cutoff_proven: cutoff_proven,
		search_limited: budget.limited,
		cutoffs: objective[0],
		lost_ticks: objective[1]
	}
}

function minecraft_export_build_plan(mode, preferred_source, allowed_sources, include_locked, include_out_of_range, nearby, tempo_grid, direct_tps, looping, compress_layers, full_search = true) {
	var controller = obj_controller
	var song_instance = controller.songs[controller.song]
	// Exports build this plan from obj_dummy2; calculate the layer mask in the
	// controller's scope instead of reading song/lockedlayer from the caller.
	with (controller) calculate_locked_layers()
	var palette = minecraft_export_source_palette(preferred_source, allowed_sources)
	var timing = minecraft_export_timing(song_instance, mode, include_locked, tempo_grid, direct_tps)
	var occurrences = []
	var stoppers = []
	var play_at = []
	var stopper_at = []
	var omitted = []
	var occupied_ticks = []
	for (var tick = 0; tick <= song_instance.enda; tick++) {
		if (song_instance.colamount[tick] <= 0) continue
		array_push(occupied_ticks, tick)
		play_at[tick] = array_create(song_instance.collast[tick] + 1, -1)
		stopper_at[tick] = array_create(song_instance.collast[tick] + 1, -1)
		for (var layer_index = 0; layer_index <= song_instance.collast[tick]; layer_index++) {
			if (!song_instance.song_exists[tick, layer_index]) continue
			if (!include_locked && controller.lockedlayer[layer_index]) continue
			var instrument_index = ds_list_find_index(song_instance.instrument_list, song_instance.song_ins[tick, layer_index])
			if (instrument_index < 0) continue
			var instrument = song_instance.instrument_list[| instrument_index]
			if (instrument.name == "Sound Stopper") {
				var stopper = { tick: tick, layer: layer_index, layer_range: minecraft_export_stopper_range(song_instance, tick, layer_index), instrument: instrument_index, targets: [], snapshots: [] }
				stopper_at[tick, layer_index] = array_length(stoppers)
				array_push(stoppers, stopper)
				continue
			}
			if (minecraft_export_is_event(instrument)) continue
			var key = minecraft_export_effective_key(song_instance, tick, layer_index, instrument_index)
			if (!((key >= 33 && key <= 57) || (include_out_of_range && key >= 9 && key <= 81))) continue
			var event_name = minecraft_export_sound_event(song_instance, tick, layer_index, instrument_index)
			if (event_name == "") continue
			var occurrence = {
				index: array_length(occurrences), tick: tick, layer: layer_index,
				instrument: instrument_index, key: key, event: event_name,
				duration: minecraft_export_note_duration(song_instance, tick, layer_index, instrument_index)
			}
			play_at[tick, layer_index] = occurrence.index
			array_push(occurrences, occurrence)
			array_push(omitted, false)
		}
	}

	// Command blocks sharing a physical redstone batch are unordered. Omit a
	// play that the intended NBS order starts and stops inside that same batch.
	if (mode == "command") {
		var batch = -1
		var local_active = []
		for (var occupied_position = 0; occupied_position < array_length(occupied_ticks); occupied_position++) {
			var tick = occupied_ticks[occupied_position]
			if (timing.grid[tick] != batch) { batch = timing.grid[tick]; local_active = [] }
			for (var layer_index = 0; layer_index <= song_instance.collast[tick]; layer_index++) {
					if (is_array(play_at[tick]) && play_at[tick, layer_index] >= 0) array_push(local_active, play_at[tick, layer_index])
					else if (is_array(stopper_at[tick]) && stopper_at[tick, layer_index] >= 0) {
						var stop_range = stoppers[stopper_at[tick, layer_index]].layer_range
						for (var i = array_length(local_active) - 1; i >= 0; i--) {
							var occurrence = occurrences[local_active[i]]
							if (minecraft_export_layer_targeted(occurrence.layer + 1, stop_range)) {
							omitted[occurrence.index] = true
							array_delete(local_active, i, 1)
						}
					}
				}
			}
		}
	}

	var active = []
	var expiry = array_create(array_length(occurrences), -1)
	var loop_start = 0
	if (mode == "datapack") loop_start = song_instance.loopstart
	var phases = looping ? 3 : 1
	var wall_span = timing.wall[song_instance.enda + 1] - timing.wall[loop_start]
	for (var phase = 0; phase < phases; phase++) {
		var start_tick = (phase == 0) ? 0 : loop_start
		var wall_offset = (phase == 0) ? 0 : timing.wall[song_instance.enda + 1] + (phase - 1) * wall_span
		var occupied_position = 0
		while (occupied_position < array_length(occupied_ticks) && occupied_ticks[occupied_position] < start_tick) occupied_position++
		while (occupied_position < array_length(occupied_ticks)) {
			var source_tick = occupied_ticks[occupied_position]
			var batch_key = (mode == "command") ? timing.grid[source_tick] : source_tick
			var batch_end_position = occupied_position
			if (mode == "command") while (batch_end_position + 1 < array_length(occupied_ticks) && timing.grid[occupied_ticks[batch_end_position + 1]] == batch_key) batch_end_position++
			var batch_snapshots = []
			for (var batch_position = occupied_position; batch_position <= batch_end_position; batch_position++) {
				var source_tick = occupied_ticks[batch_position]
				var now = wall_offset + timing.wall[source_tick] - timing.wall[start_tick]
				for (var i = array_length(active) - 1; i >= 0; i--) {
					if (expiry[active[i]] <= now) array_delete(active, i, 1)
				}
				for (var layer_index = 0; layer_index <= song_instance.collast[source_tick]; layer_index++) {
						if (is_array(play_at[source_tick]) && play_at[source_tick, layer_index] >= 0) {
						var play_index = play_at[source_tick, layer_index]
						if (omitted[play_index]) continue
						if (!minecraft_export_array_contains(active, play_index)) array_push(active, play_index)
						expiry[play_index] = (occurrences[play_index].duration == infinity) ? infinity : now + occurrences[play_index].duration
						} else if (is_array(stopper_at[source_tick]) && stopper_at[source_tick, layer_index] >= 0) {
							var stopper = stoppers[stopper_at[source_tick, layer_index]]
						var before = minecraft_export_clone_array(active)
						var targets = []
						for (var i = 0; i < array_length(before); i++) {
							var occurrence = occurrences[before[i]]
								if (minecraft_export_layer_targeted(occurrence.layer + 1, stopper.layer_range)) {
								array_push(targets, occurrence.index)
								minecraft_export_add_unique_target(stopper, occurrence.index)
							}
						}
						var snapshot = { stopper: stopper, active: before, targets: targets, absolute_tick: source_tick + phase * (song_instance.enda + 1 - loop_start) }
						array_push(batch_snapshots, snapshot)
						array_push(stopper.snapshots, snapshot)
						for (var i = 0; i < array_length(targets); i++) minecraft_export_array_remove_value(active, targets[i])
					}
				}
			}
			if (mode == "command") {
				for (var s = 0; s < array_length(batch_snapshots); s++) {
					var snapshot = batch_snapshots[s]
					snapshot.survivors = minecraft_export_clone_array(active)
				}
			}
			occupied_position = batch_end_position + 1
		}
	}

	// A stopper emits one static set of event/source pairs on every loop. Build
	// conflicts against the union of targets it can have in any simulated phase,
	// including first-pass versus steady-state loop differences.
	var risks = []
	var risk_map = ds_map_create()
	for (var s = 0; s < array_length(stoppers); s++) {
		var stopper = stoppers[s]
		for (var p = 0; p < array_length(stopper.snapshots); p++) {
			var snapshot = stopper.snapshots[p]
			var possible_victims = (mode == "command") ? snapshot.survivors : snapshot.active
			for (var t = 0; t < array_length(stopper.targets); t++) {
				var target = stopper.targets[t]
				for (var v = 0; v < array_length(possible_victims); v++) {
					var victim = possible_victims[v]
					if (mode == "datapack" && minecraft_export_array_contains(snapshot.targets, victim)) continue
					if (occurrences[target].event == occurrences[victim].event) {
						minecraft_export_add_risk(risks, risk_map, target, victim, stopper, song_instance.enda + 1 - stopper.tick)
					}
				}
			}
		}
	}
	ds_map_destroy(risk_map)

	var assignment = minecraft_export_assign_colors(array_length(occurrences), risks, array_length(palette), full_search)
	var rows = []
	var rows_by_tick = array_create(song_instance.enda + 1)
	var rows_by_grid = array_create(timing.grid[song_instance.enda] + 1)
	for (var i = 0; i < array_length(rows_by_tick); i++) rows_by_tick[i] = []
	for (var i = 0; i < array_length(rows_by_grid); i++) rows_by_grid[i] = []
	var target_selector = (mode == "command" || nearby) ? "@a" : "@s"
	for (var tick = 0; tick <= song_instance.enda; tick++) {
		if (song_instance.colamount[tick] <= 0) continue
		for (var layer_index = 0; layer_index <= song_instance.collast[tick]; layer_index++) {
				if (is_array(play_at[tick]) && play_at[tick, layer_index] >= 0) {
				var play_index = play_at[tick, layer_index]
				if (omitted[play_index]) continue
				var occurrence = occurrences[play_index]
				var source = palette[assignment.colors[play_index]]
				var command = ""
				if (mode == "command") {
					command = "playsound " + occurrence.event + " " + source + " @a ~ ~ ~ 3 " + minecraft_export_pitch(occurrence.key)
				} else {
					var volume = song_instance.layervol[occurrence.layer] / 100 / 100 * song_instance.song_vel[tick, occurrence.layer]
					var stereo = (song_instance.layerstereo[occurrence.layer] + song_instance.song_pan[tick, occurrence.layer]) / 2
					var position = abs(stereo - 100) / 100 * 2
					if (nearby) command = "execute at @s run playsound " + occurrence.event + " " + source + " @a ~ ~ ~ " + string(obj_controller.dat_radiusvalue) + " " + minecraft_export_pitch(occurrence.key)
					else command = "playsound " + occurrence.event + " " + source + " @s ^" + string(position) + " ^ ^ " + string(volume) + " " + minecraft_export_pitch(occurrence.key) + " 1"
				}
					var row = { index: array_length(rows), kind: "play", tick: tick, layer: occurrence.layer, instrument: occurrence.instrument, command: command, event: occurrence.event, source: source }
					array_push(rows, row); array_push(rows_by_tick[tick], row); array_push(rows_by_grid[timing.grid[tick]], row)
				} else if (is_array(stopper_at[tick]) && stopper_at[tick, layer_index] >= 0) {
					var stopper = stoppers[stopper_at[tick, layer_index]]
				var pairs = ds_map_create()
				for (var i = 0; i < array_length(stopper.targets); i++) {
					var target = stopper.targets[i]
					var source = palette[assignment.colors[target]]
					var pair = occurrences[target].event + "|" + source
					if (!ds_map_exists(pairs, pair)) {
						ds_map_add(pairs, pair, true)
						var command = "stopsound " + target_selector + " " + source + " " + occurrences[target].event
							var row = { index: array_length(rows), kind: "stop", tick: tick, layer: stopper.layer, instrument: stopper.instrument, command: command, event: occurrences[target].event, source: source }
						array_push(rows, row); array_push(rows_by_tick[tick], row); array_push(rows_by_grid[timing.grid[tick]], row)
					}
				}
				ds_map_destroy(pairs)
			} else if (mode == "datapack" && song_instance.song_exists[tick, layer_index]) {
				var instrument_index = ds_list_find_index(song_instance.instrument_list, song_instance.song_ins[tick, layer_index])
				if (instrument_index >= 0 && song_instance.instrument_list[| instrument_index].name == "Tempo Changer" && (include_locked || !controller.lockedlayer[layer_index])) {
					var row = { index: array_length(rows), kind: "tempo", tick: tick, layer: layer_index, instrument: instrument_index, command: "", speed: minecraft_export_snapped_speed(minecraft_export_tempo_from_note(song_instance, tick, layer_index)) }
					array_push(rows, row); array_push(rows_by_tick[tick], row)
				}
			}
		}
	}

	var slots_by_grid = array_create(array_length(rows_by_grid))
	var maximum_slots = 0
	for (var grid_tick = 0; grid_tick < array_length(rows_by_grid); grid_tick++) {
		var grid_rows = rows_by_grid[grid_tick]
		if (compress_layers) slots_by_grid[grid_tick] = minecraft_export_clone_array(grid_rows)
		else {
			var base_count = 0
			for (var i = 0; i < array_length(grid_rows); i++) base_count = max(base_count, grid_rows[i].layer + 1)
			var slots = array_create(base_count, undefined)
			var overflow = []
			for (var i = 0; i < array_length(grid_rows); i++) {
				var row = grid_rows[i]
				if (is_undefined(slots[row.layer])) slots[row.layer] = row
				else array_push(overflow, row)
			}
			for (var i = 0; i < array_length(overflow); i++) array_push(slots, overflow[i])
			slots_by_grid[grid_tick] = slots
		}
		maximum_slots = max(maximum_slots, array_length(slots_by_grid[grid_tick]))
	}
	var used_sources = 0
	for (var i = 0; i < array_length(occurrences); i++) if (!omitted[i]) used_sources = max(used_sources, assignment.colors[i] + 1)
	var stopper_commands = 0
	var last_command_grid = 0
	for (var i = 0; i < array_length(rows); i++) {
		if (rows[i].kind == "stop") stopper_commands++
		if (rows[i].kind != "tempo") last_command_grid = max(last_command_grid, timing.grid[rows[i].tick])
	}
	var ignored_stoppers = 0
	for (var i = 0; i < array_length(stoppers); i++) ignored_stoppers += array_length(stoppers[i].targets) == 0
	var omitted_count = 0
	for (var i = 0; i < array_length(omitted); i++) omitted_count += omitted[i]
	return {
		mode: mode, palette: palette, occurrences: occurrences, rows: rows, risks: risks, colors: assignment.colors,
		rows_by_tick: rows_by_tick, rows_by_grid: rows_by_grid,
		slots_by_grid: slots_by_grid, timing: timing,
		last_grid: timing.grid[song_instance.enda], last_command_grid: last_command_grid, maximum_slots: maximum_slots,
		exact: assignment.exact, required_sources: assignment.required,
		minimum_proven: assignment.minimum_proven, search_limited: assignment.search_limited,
		cutoff_proven: assignment.cutoff_proven,
		used_sources: used_sources, cutoff_count: assignment.cutoffs,
		lost_ticks: assignment.lost_ticks, stopper_commands: stopper_commands,
		ignored_stoppers: ignored_stoppers, omitted_count: omitted_count
	}
}

function minecraft_export_plan_repeaters(plan) {
	var rep = 0
	var repeaters = 0
	var step = (obj_controller.sch_exp_tempo == 0) ? 1 : ((obj_controller.sch_exp_tempo == 1) ? 2 : 4)
	for (var grid_tick = 0; grid_tick <= plan.last_command_grid; grid_tick++) {
		rep += step
		if (array_length(plan.rows_by_grid[grid_tick]) > 0 || rep >= 4) {
			repeaters++
			rep = 0
		}
	}
	return repeaters
}

function minecraft_export_track_channel(row, song_instance) {
	if (row.kind != "play") return 4
	var layer_index = row.layer
	var tick = row.tick
	var pan = (song_instance.layerstereo[layer_index] == 100) ? song_instance.song_pan[tick, layer_index] : (song_instance.layerstereo[layer_index] + song_instance.song_pan[tick, layer_index]) / 2
	var volume = song_instance.layervol[layer_index] / 100 * song_instance.song_vel[tick, layer_index]
	var pan_volume = (pan - 100) * volume + 100
	if ((((pan > 80 && pan < 120) || (pan > 0 && pan <= 80)) && volume > 0 && volume <= 0.2) || pan_volume >= 180) return 0
	if ((((pan > 80 && pan < 120) || (pan > 0 && pan <= 80)) && volume > 0.2 && volume <= 0.4) || (pan_volume >= 160 && pan_volume < 180)) return 1
	if ((((pan > 80 && pan < 120) || (pan > 0 && pan <= 80)) && volume > 0.4 && volume <= 0.6) || (pan_volume >= 140 && pan_volume < 160)) return 2
	if ((((pan > 80 && pan < 120 && volume <= 0.8) || (pan > 0 && pan <= 80)) && volume > 0.6) || (pan_volume >= 120 && pan_volume < 140)) return 3
	if (pan > 80 && pan < 120 && volume > 0.8) return 4
	if ((((pan > 80 && pan < 120 && volume <= 0.8) || (pan > 120 && pan <= 200)) && volume > 0.6) || (pan_volume > 60 && pan_volume <= 80)) return 5
	if ((((pan > 80 && pan < 120) || (pan > 120 && pan <= 200)) && volume > 0.4 && volume <= 0.6) || (pan_volume > 40 && pan_volume <= 60)) return 6
	if ((((pan > 80 && pan < 120) || (pan > 120 && pan <= 200)) && volume > 0.2 && volume <= 0.4) || (pan_volume > 20 && pan_volume <= 40)) return 7
	return 8
}

function minecraft_export_prepare_track_plan(plan) {
	if (variable_struct_exists(plan, "track_rows_by_grid")) return plan
	var song_instance = obj_controller.songs[obj_controller.song]
	plan.track_rows_by_grid = array_create(array_length(plan.rows_by_grid))
	plan.track_maximum_slots = 0
	for (var grid_tick = 0; grid_tick < array_length(plan.rows_by_grid); grid_tick++) {
		var channels = array_create(9)
		for (var channel = 0; channel < 9; channel++) channels[channel] = []
		var grid_rows = plan.rows_by_grid[grid_tick]
		for (var i = 0; i < array_length(grid_rows); i++) {
			var channel = minecraft_export_track_channel(grid_rows[i], song_instance)
			array_push(channels[channel], grid_rows[i])
		}
		for (var channel = 0; channel < 9; channel++) plan.track_maximum_slots = max(plan.track_maximum_slots, array_length(channels[channel]))
		plan.track_rows_by_grid[grid_tick] = channels
	}
	return plan
}

function minecraft_export_command_tps() {
	return (obj_controller.sch_exp_tempo == 0) ? 10 : ((obj_controller.sch_exp_tempo == 1) ? 5 : 2.5)
}

function minecraft_export_get_schematic_plan(force = false) {
	var controller = obj_controller
	var signature = string(controller.song) + ":" + string(controller.sch_exp_includelocked) + ":" + string(controller.sch_exp_compress) + ":" + string(controller.sch_command_tempo_grid) + ":" + string(controller.sch_exp_tempo) + ":" + controller.sch_command_source + ":" + string(controller.sch_command_allowed_sources)
	if (force || !is_struct(controller.sch_command_plan) || controller.sch_command_plan_signature != signature) {
		controller.sch_command_plan = minecraft_export_build_plan(
			"command", controller.sch_command_source, controller.sch_command_allowed_sources,
			controller.sch_exp_includelocked, true, true, controller.sch_command_tempo_grid,
			minecraft_export_command_tps(), controller.sch_exp_layout == 0 && controller.sch_exp_loop,
			controller.sch_exp_compress, force
		)
		controller.sch_command_plan_signature = signature
	}
	return controller.sch_command_plan
}

function minecraft_export_summary(plan) {
	var result_quality
	if (plan.exact) result_quality = plan.minimum_proven ? "minimum sources proven" : "bounded source minimum"
	else result_quality = plan.cutoff_proven ? "minimum cutoff count proven" : "bounded cutoff result"
	return string(plan.used_sources) + "/" + string(array_length(plan.palette)) + " sources; " + string(plan.stopper_commands) + " stop commands; " + string(plan.cutoff_count) + " accidental cutoffs (" + result_quality + ")"
}

function minecraft_export_log_report(plan, preferred_source, export_kind) {
	log("Minecraft sound export report", export_kind)
	log("Minecraft sound export summary", minecraft_export_summary(plan))
	log("Minecraft sound export preferred source", preferred_source)
	log("Minecraft sound export ignored no-op Sound Stoppers", plan.ignored_stoppers)
	log("Minecraft sound export omitted unordered same-batch plays", plan.omitted_count)
	if (plan.search_limited) log("Minecraft sound export source optimization reached its safety limit; the exported assignment remains valid but its reported minimum may be bounded.")
	var seen_victims = ds_map_create()
	for (var i = 0; i < array_length(plan.risks); i++) {
		var risk = plan.risks[i]
		if (plan.colors[risk.target] != plan.colors[risk.victim]) continue
		if (ds_map_exists(seen_victims, risk.victim)) continue
		ds_map_add(seen_victims, risk.victim, true)
		var victim = plan.occurrences[risk.victim]
		var detail = "stopper tick " + string(risk.stopper.tick) + " layer " + string(risk.stopper.layer + 1)
		detail += "; victim tick " + string(victim.tick) + " layer " + string(victim.layer + 1) + "; " + victim.event
		log("Minecraft sound export accidental cutoff", detail)
	}
	ds_map_destroy(seen_victims)
}

function minecraft_export_draw_source_allowlist(x, y, allowed, preferred) {
	var names = minecraft_export_sources()
	var changed = false
	draw_theme_font(font_main_bold)
	draw_text_dynamic(x, y, condstr(obj_controller.language != 1, "Allowed Sound Stopper sources", "允许声音抑制器使用的声源"))
	draw_theme_font(font_main)
	for (var i = 0; i < array_length(names); i++) {
		var column = i mod 2
		var row = floor(i / 2)
		var label = minecraft_export_source_label(names[i])
		if (names[i] == "master") label += condstr(obj_controller.language != 1, " (opt-in)", "（需单独启用）")
		if (draw_checkbox(x + column * 180, y + 24 + row * 23, allowed[i], label, condstr(obj_controller.language != 1, "Allow the allocator to place song sounds on this Minecraft volume category.", "允许分配器将歌曲声音放在此 Minecraft 音量类别。"), false, true)) { allowed[i] = !allowed[i]; changed = true }
	}
	if (draw_button2(x, y + 148, 112, condstr(obj_controller.language != 1, "Default (no Master)", "默认（不含主音量）"), false, 1)) {
		for (var i = 0; i < array_length(names); i++) allowed[i] = names[i] != "master"
		changed = true
	}
	if (draw_button2(x + 120, y + 148, 72, condstr(obj_controller.language != 1, "All", "全选"), false, 1)) {
		for (var i = 0; i < array_length(names); i++) allowed[i] = true
		changed = true
	}
	if (draw_button2(x + 200, y + 148, 110, condstr(obj_controller.language != 1, "Preferred only", "仅首选声源"), false, 1)) {
		for (var i = 0; i < array_length(names); i++) allowed[i] = names[i] == preferred
		changed = true
	}
	var preferred_index = 0
	for (var i = 0; i < array_length(names); i++) if (names[i] == preferred) preferred_index = i
	if (!allowed[preferred_index]) {
		draw_set_color(c_red)
		var warning = (preferred == "master")
		? condstr(obj_controller.language != 1, "Master is disabled; another allowed source will be preferred.", "主音量类别已禁用；将优先使用其他允许的声源。")
			: condstr(obj_controller.language != 1, "Preferred source is disabled; it will be enabled during export.", "首选声源已禁用；导出时会启用。")
		draw_text_dynamic(x, y + 184, warning)
		draw_theme_color()
	}
	if (changed) obj_controller.sch_command_plan = undefined
	return allowed
}

function minecraft_export_draw_schematic_sound_settings(x, y) {
	var controller = obj_controller
	var names = minecraft_export_sources()
	draw_theme_font(font_main_bold)
	draw_text_dynamic(x, y, condstr(controller.language != 1, "Preferred sound source", "首选声源"))
	draw_theme_font(font_small)
	for (var i = 0; i < array_length(names); i++) {
		var column = i mod 5
		var row = floor(i / 5)
		if (draw_radiobox(x + column * 100, y + 22 + row * 20, controller.sch_command_source == names[i], minecraft_export_source_label(names[i]), condstr(controller.language != 1, "Use this Minecraft volume category first.", "优先使用此 Minecraft 音量类别。"))) controller.sch_command_source = names[i]
	}
	draw_theme_font(font_main)
	controller.sch_command_allowed_sources = minecraft_export_draw_source_allowlist(x, y + 66, controller.sch_command_allowed_sources, controller.sch_command_source)
	draw_theme_font(font_small)
	draw_text_dynamic(x, y + 270, condstr(controller.language != 1, "Source assignment is calculated when Export is pressed.", "声源分配将在按下导出时计算。"))
	draw_text_dynamic(x, y + 287, condstr(controller.language != 1, "No-op Sound Stoppers are ignored. Custom mappings are edited in Instrument Settings.", "无目标的声音抑制器会被忽略。自定义映射可在乐器设置中编辑。"))
	draw_theme_font(font_main)
}
