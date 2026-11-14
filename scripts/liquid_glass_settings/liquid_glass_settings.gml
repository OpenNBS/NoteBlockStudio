/// Presets: regular, clear, menu. Overrides replace individual fields.
/// Sizes use view units; edge_refraction_width uses render pixels. Angles use GML degrees.
/// blur_opacity below 1 mixes the sharp background back in.
function liquid_glass_settings(preset = "regular", dark = false, overrides = undefined) {
	var clear = (preset == "clear")
	var menu = (preset == "menu")
	var settings = {
		corner_radius: menu ? 16 : 10, edge_softness: 1,
		edge_refraction_amount: menu ? -8 : 0, edge_refraction_width: 1,
		blur_radius: menu ? 4 : 0, blur_opacity: 1,
		inner_refraction_amount: menu ? 10 : 5, inner_refraction_height: menu ? 32 : 12,
		outer_refraction_amount: -2, outer_refraction_height: menu ? 5 : 3,
		highlight_color: c_white, highlight_angle: 135,
		highlight_intensity: dark ? 0.38 : 0.55, highlight_width: 1.3, highlight_spread: 0.45,
		shadow_color: c_black, shadow_opacity: clear ? 0.12 : 0.22,
		shadow_softness: 10, shadow_offset_x: 0, shadow_offset_y: 4,
		rim_shadow_opacity: 0.1, rim_shadow_width: 1.5,
		tint_color: menu ? (dark ? 2697513 : 16382457) : (dark ? make_color_rgb(28, 30, 34) : make_color_rgb(248, 249, 252)),
		tint_opacity: menu ? 0.6 : (clear ? 0.04 : (dark ? 0.28 : 0.18)),
		adaptive_tint: (clear || menu) ? 0 : 0.18,
		saturation: menu ? 1 : 1.08, brightness: 0,
		aberration_amount: 0.2, aberration_height: 6, aberration_angle: 0,
		alpha: 1
	}
	if (is_struct(overrides)) {
		var names = variable_struct_get_names(settings)
		for (var i = 0; i < array_length(names); i++) {
			if (variable_struct_exists(overrides, names[i])) {
				variable_struct_set(settings, names[i], variable_struct_get(overrides, names[i]))
			}
		}
	}
	return settings
}
