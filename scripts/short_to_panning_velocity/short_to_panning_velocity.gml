function short_to_panning_velocity(val){
	var vel = floor(val / 256)
	var pan = val - (vel * 256)
	vel = (vel + 100) mod 256
	pan = (pan + 100) mod 256
	return [pan, vel]
}