function panning_velocity_to_short(pan, vel){
	pan = (floor(pan) + 156) mod 256
	vel = (floor(vel) + 156) mod 256
	return pan + vel * 256
}