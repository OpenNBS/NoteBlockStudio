/*
* Provided as a replacement to blur_scripts.gml, which belongs to
* the Realtime Blur extension by Foxy Of Jungle:
* https://marketplace.yoyogames.com/assets/9540/blur-realtime-performance
* 
* Since it's a paid extension, the source code cannot be published
* to the repository, so the extension files must be added manually
* to the project folder after cloning.
* 
* Note Block Studio will work just fine without the extension, but
* the transparency effects for the Fluent theme will be missing the
* blur effect.
*/

function sprite_create_blur_alt(sprite, downamount, width, height, blurradius, quality, directions) {
	// Returns a sprite index
	try {
		//return sprite_create_blur(sprite, downamount, width, height, blurradius, quality, directions);
		return blur_sprite_create(sprite, 0, BLUR_TYPE.GAUSSIAN, width, height, blurradius, downamount)
	} catch (exc) {
		return sprite;
	}
}

function draw_surface_blur_alt(surface, x, y, w, h, downamount) {
	try {
		if (true) {
			var scale_factor = 0.25
			obj_controller.blur_temp_surface = surface_create(w * obj_controller.window_scale, h * obj_controller.window_scale)
			obj_controller.blur_area_id = blur_area_create()
			var temp_tex_filter = gpu_get_tex_filter()
			surface_set_target(obj_controller.blur_temp_surface)
			draw_surface_part(surface, x * obj_controller.window_scale, y * obj_controller.window_scale, w * obj_controller.window_scale, h * obj_controller.window_scale, 0, 0)
			//draw_surface_blur(obj_controller.blur_temp_surface, 0, 0, w * obj_controller.window_scale, h * obj_controller.window_scale, downamount * (1 / obj_controller.window_scale));
			blur_area_draw(obj_controller.blur_area_id, obj_controller.blur_temp_surface, BLUR_TYPE.GAUSSIAN, 0, 0, w * obj_controller.window_scale, h * obj_controller.window_scale, 0, 0, scale_factor * downamount * obj_controller.window_scale)
			surface_reset_target()
			surface_set_target(surface)
			gpu_set_tex_filter(true)
			draw_rectangle_color(x, y, x + w - 1, y + h - 1, 0, 0, 0, 0, 0)
			draw_surface_stretched(obj_controller.blur_temp_surface, x, y, w, h)
			gpu_set_tex_filter(temp_tex_filter)
			surface_reset_target()
			surface_free(obj_controller.blur_temp_surface)
			blur_area_destroy(obj_controller.blur_area_id)
		}
	} catch (exc) {
		if (surface_get_target() != application_surface) surface_reset_target()
		if (surface_exists(obj_controller.blur_temp_surface)) surface_free(obj_controller.blur_temp_surface)
		if (blur_area_exists(obj_controller.blur_area_id)) blur_area_destroy(obj_controller.blur_area_id)
		//if (surface_exists(obj_controller.blur_temp_surface_scaled)) surface_free(obj_controller.blur_temp_surface_scaled)
		return;
	}
}

// NB: sprite_blur_clear and sprite_draw_blur were suppressed
// from this script as they aren't currently used.
