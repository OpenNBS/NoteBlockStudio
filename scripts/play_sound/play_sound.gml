/// @description  play_sound(instrument, key, volume, pan)
/// @function  play_sound
/// @param instrument
/// @param  key
/// @param  volume
/// @param  pan
/// @param  fine pitch
function play_sound() {
	
	var argument_0 = argument[0]
	var argument_1 = argument[1]
	var argument_2 = argument[2]
	var argument_3 = argument[3]
	var argument_4 = argument[4]
	var argument_5 = 0
	if (argument_count > 5) argument_5 = argument[5]
	
	if (os_type != os_macosx) {

	var ins, key, vol, pan, newemitter, emitter, pit, keyshift
	ins = argument_0
	key = argument_1
	vol = argument_2
	pan = argument_3
	pit = argument_4

	if (!ins.loaded)
	    return 0
	emitter=audio_emitter_create()
	keyshift = key + (ins.key + (pit/100) - 78)
	audio_emitter_pitch(emitter, 0.5 * power(2, keyshift / 12))
	audio_emitter_gain(emitter, (vol / 100) * mastervol)
	if (realstereo = 0) audio_emitter_position(emitter,pan,0,0)
	else audio_emitter_position(emitter,100,0,0)

	audio_play_sound_on(emitter,ins.sound, 0, current_time)
	sounds++

	//Schedule emitter to be deleted from memory
	newemitter = ds_list_create()
	ds_list_add(newemitter,emitter) //store emitter id
	var length = audio_sound_length(ins.sound) / (1 + 3 * (os_type = os_windows)) * (1/audio_emitter_get_pitch(emitter))
	ds_list_add(newemitter, (get_timer() + length * 1000000)) //store moment at which the emitter should be removed
	ds_list_add(newemitter, argument_5)
	ds_list_add(emitters_to_remove, newemitter)
	
	} else {
	
	var ins, key, vol, pan, newemitter, emitter, pit, keyshift
	ins = argument_0
	key = argument_1
	vol = argument_2
	pan = argument_3
	pit = argument_4

	if (!ins.loaded)
	    return 0
	//emitter=audio_emitter_create()
	keyshift = key + (ins.key + (pit/100) - 78)
	var emitter_pitch = 0.5 * power(2, keyshift / 12)
	var emitter_gain = (vol / 100) * mastervol
	var emitter_x = 100
	if (realstereo = 0) emitter_x = pan

	var soundid = audio_play_sound_at(ins.sound, emitter_x, 0, 0, 100, 300, 1, false, current_time)
	audio_sound_gain(soundid, emitter_gain, 0)
	audio_sound_pitch(soundid, emitter_pitch)
	
	sounds++

	//Schedule emitter to be deleted from memory
	newemitter = ds_list_create()
	ds_list_add(newemitter,soundid) //store emitter id
	var length = audio_sound_length(ins.sound) / (1 + 3 * (os_type = os_windows)) * (1/emitter_pitch)
	ds_list_add(newemitter, (get_timer() + length * 1000000)) //store moment at which the emitter should be removed
	ds_list_add(newemitter, argument_5)
	ds_list_add(emitters_to_remove, newemitter)
	
	}

}
