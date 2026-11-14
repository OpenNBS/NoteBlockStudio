/// Bake the wallpaper blur once, during Draw.
function wallpaper_prepare() {
	if (!wallpaper_prepare_pending || !wpaperexist || !sprite_exists(wpaper)) return;
	wallpaper_prepare_pending = false
	var scale = min(720 / sprite_get_height(wpaper), 4096 / sprite_get_width(wpaper))
	var width = max(1, round(sprite_get_width(wpaper) * scale))
	var height = max(1, round(sprite_get_height(wpaper) * scale))
	var source = -1, destination = -1, resized = -1, blurred = -1
	var state = __surface_effects_save()
	try {
		source = surface_create(width, height)
		destination = surface_create(width, height)
		if (surface_exists(source) && surface_exists(destination) && __surface_effects_target(source)) {
			var drawn = false
			try {
				gpu_set_blendenable(false)
				draw_clear_alpha(c_black, 0)
				draw_sprite_stretched(wpaper, 0, 0, 0, width, height)
				drawn = true
			} catch (draw_error) {
				show_debug_message("Wallpaper drawing failed: " + string(draw_error))
			}
			surface_reset_target()
			if (drawn) {
				resized = sprite_create_from_surface(source, 0, 0, width, height, false, false, 0, 0)
				if (blur_surface(source, destination, wallpaper_blur_radius)) {
					blurred = sprite_create_from_surface(destination, 0, 0, width, height, false, false, 0, 0)
				}
			}
		}
	} catch (error) {
		show_debug_message("Wallpaper preparation failed: " + string(error))
	}
	__surface_effects_restore(state)
	if (surface_exists(source)) surface_free(source)
	if (surface_exists(destination)) surface_free(destination)
	if (sprite_exists(resized)) {
		sprite_delete(wpaper)
		wpaper = resized
	}
	if (sprite_exists(wpaperblur) && wpaperblur != wpaper) sprite_delete(wpaperblur)
	wpaperblur = blurred
	// Keep the original if blur failed.
}
