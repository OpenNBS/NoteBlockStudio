function draw_set_accent(rr, rg, rb){
	var rgb
	if (rr > rg && rr > rb) hiacc = rr
	else if (rg > rr && rg > rb) hiacc = rg
	else hiacc = rb
	accent[0] = make_color_rgb(rr * 0.7, rg * 0.7, rb * 0.7)
	accent[1] = make_color_rgb(rr * 0.8, rg * 0.8, rb * 0.8)
	accent[2] = make_color_rgb(rr * 0.9, rg * 0.9, rb * 0.9)
	accent[3] = make_color_rgb(rr, rg, rb)
	accent[4] = make_color_rgb(rr + (hiacc - rr) * 0.1, rg + (hiacc - rg) * 0.1, rb + (hiacc - rb) * 0.1)
	accent[5] = make_color_rgb(rr + (hiacc - rr) * 0.1 * 2, rg + (hiacc - rg) * 0.1 * 2, rb + (hiacc - rb) * 0.1 * 2)
	accent[6] = make_color_rgb(rr + (hiacc - rr) * 0.1 * 3, rg + (hiacc - rg) * 0.1 * 2, rb + (hiacc - rb) * 0.1 * 3)
	accent[7] = make_color_rgb(rr + (hiacc - rr) * 0.1 * 5, rg + (hiacc - rg) * 0.1 * 5, rb + (hiacc - rb) * 0.1 * 5)
	accent[8] = make_color_rgb(rr * 0.5, rg * 0.5, rb * 0.5)
}