function update_window() {
	// update_window()

	if (window_width != window_get_width() || window_height != window_get_height()) {
	    var ww, hh, xx, yy;
	    ww = window_get_width()
	    hh = window_get_height()
    
	    if (ww <= 0 || hh <= 0)
	        return 0
    
	    xx = window_get_x()
	    yy = window_get_y()
	    display_reset(0, false)
	    if (!macos_is_retina()) window_set_rectangle(xx, yy, ww, hh)
	    else window_set_rectangle(xx, yy, ww / 2, hh / 2)
		show_debug_message("Set window size to " + string(ww) + " x " + string(hh))
	    surface_resize(application_surface, ww, hh)
	
		camera_set_view_pos(cam_window, 0, 0) 
	    camera_set_view_size(cam_window, ww * (1 / window_scale), hh * (1 / window_scale))
		view_set_wport(0, ww);
		view_set_hport(0, hh);
    
	    window_width = ww
	    window_height = hh
	}



}
