function update_window_scale(){
	if (window_scale != prev_scale) {
		camera_set_view_size(cam_window, rw, rh)
		msgx = rw
		msgy = rh * 0.8
	}
	prev_scale = window_scale
}