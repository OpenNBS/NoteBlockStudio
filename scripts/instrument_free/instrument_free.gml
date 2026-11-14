/// @description  instrument_free()
/// @function  instrument_free
function instrument_free() {

	audio_free_buffer_sound(sound)
	buffer_delete(sound_buffer)

	loaded = false
	sound_duration = 0



}
