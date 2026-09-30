function update_window() {
	// update_window()

	var ww = window_get_width()
	var hh = window_get_height()
	if (window_width != ww || window_height != hh) {
    
	    if (ww <= 0 || hh <= 0)
	        return 0
    
	    // macOS changes the backing size when crossing displays with different DPI.
	    // Writing that size/position back can move the window across the boundary again.
	    // Linux also needs the window manager to own geometry during a resize.
	    if (os_type != os_linux && os_type != os_macosx) {
		    display_reset(0, false)
		    window_set_rectangle(window_get_x(), window_get_y(), ww, hh)
	    }
		show_debug_message("Updated render size to " + string(ww) + " x " + string(hh))
	    surface_resize(application_surface, ww, hh)
	
		camera_set_view_pos(cam_window, 0, 0) 
	    camera_set_view_size(cam_window, ww * (1 / window_scale), hh * (1 / window_scale))
		view_set_wport(0, ww);
		view_set_hport(0, hh);
    
	    window_width = ww
	    window_height = hh
	}



}
