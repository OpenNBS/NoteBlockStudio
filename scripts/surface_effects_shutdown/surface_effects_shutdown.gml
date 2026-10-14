/// Free the effect surfaces and camera.
function surface_effects_shutdown() {
	if (!variable_global_exists("surface_effects") || is_undefined(global.surface_effects)) return;
	var state = global.surface_effects
	for (var i = 0; i < array_length(state.pool); i++) {
		if (surface_exists(state.pool[i].surface)) surface_free(state.pool[i].surface)
	}
	camera_destroy(state.camera)
	global.surface_effects = undefined
}
