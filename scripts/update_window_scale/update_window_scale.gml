function update_window_scale(){
	if (window_scale != prev_scale) {
		camera_set_view_size(cam_window, rw, rh)
		msgx = rw
		msgy = rh * 0.8
		// The high resolution textures exist to serve the interface scale, so
		// follow it unless the user has deliberately chosen the other value.
		if (!hires_manual) hires = (window_scale > 1.25)
	}
	prev_scale = window_scale
}