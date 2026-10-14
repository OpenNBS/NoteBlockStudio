function draw_dragvalue() {
	// draw_dragvalue(id, x, y, val, sensitivity[, lock])
	var i, xx, yy, v, m, ma, mi, s, lock, str;
	i = argument[0]
	xx = argument[1]
	yy = argument[2]
	v = argument[3]
	s = argument[4]
	lock = 0
	if (argument_count > 5)
	    lock = argument[5]
	str = string_format(v, 0, 0)
	m = mouse_rectangle(xx - 8, yy - 4, string_width_dynamic(str) + 16, string_height_dynamic(str) + 4) * (!instance_exists(obj_menu))
	if (v < 20 || i > 1) {
	    if (lock = 0) {
	        draw_text_dynamic(xx, yy, str)
	    } else {
	        draw_set_color(c_white)
	        draw_text_dynamic(xx + 1, yy + 1, str)
	        draw_set_color(8421504)
	        draw_text_dynamic(xx, yy, str)
	    }
	} else {
	    if (language != 1) draw_text_dynamic(xx, yy, "No limit")
	    else draw_text_dynamic(xx, yy, "无限")
	}
	if (lock) return v
	if (w_isdragging = 0) {
	    if (m) curs = cr_size_ns
	    if (m && nbs_mouse_check_button_pressed(mb_left)) {
	        w_isdragging = i
	        w_dragvalue = 0
	    }
	} else if (w_isdragging = i) {
	    w_dragvalue += 0.1 * (mouse_yprev - nbs_mouse_y()) / s
	    v += floor(w_dragvalue)
	    w_dragvalue -= floor(w_dragvalue)
	    curs = cr_size_ns
	}
	return v




}
