function remove_emitters() {
	
	if (os_type != os_macosx) {
	
	//Called from control_draw every frame
	//Removes emitters from memory to prevent memory leaking
	var pos, arr, emitterid, timetoremove

	for(pos = 0; pos < ds_list_size(emitters_to_remove); pos++){
		arr = ds_list_find_value(emitters_to_remove,pos)
	
		emitterid = ds_list_find_value(arr,0)
		timetoremove = ds_list_find_value(arr,1)
	
		if(get_timer() >= timetoremove){
			ds_list_delete(emitters_to_remove,pos)
			audio_emitter_free(emitterid)
			//log("freeing emitter with id " + string(emitterid))
			sounds--
		}
	}

	} else {
	
	//Called from control_draw every frame
	//Removes emitters from memory to prevent memory leaking
	var pos, arr, emitterid, timetoremove

	for(pos = 0; pos < ds_list_size(emitters_to_remove); pos++){
		arr = ds_list_find_value(emitters_to_remove,pos)
	
		emitterid = ds_list_find_value(arr,0)
		timetoremove = ds_list_find_value(arr,1)
	
		if(get_timer() >= timetoremove){
			ds_list_delete(emitters_to_remove,pos)
			//audio_emitter_free(emitterid)
			audio_stop_sound(emitterid)
			//log("freeing emitter with id " + string(emitterid))
			sounds--
		}
	}
	
	}

}

function remove_emitters_all() {
	var layerid = 0
	var layerto = 0
	if (argument_count > 0) layerid = argument[0]
	if (argument_count > 1) layerto = argument[1]
	if (layerid < 0) layerid = 0
	if (layerto < layerid) layerto = layerid
	
	if (os_type != os_macosx) {
	
		var pos, arr, emitterid, timetoremove
	
		for (var i = 0; i < 3; i++) {

			for(pos = 0; pos < ds_list_size(emitters_to_remove); pos++){
				arr = ds_list_find_value(emitters_to_remove,pos)
	
				emitterid = ds_list_find_value(arr,0)
				timetoremove = ds_list_find_value(arr,1)
				soundlayer = ds_list_find_value(arr, 2)
	
				if(layerid = 0 || (soundlayer >= layerid && soundlayer <= layerto)){
					ds_list_delete(emitters_to_remove,pos)
					audio_emitter_gain(emitterid, 0)
					audio_emitter_free(emitterid)
					//log("freeing emitter with id " + string(emitterid))
					sounds--
				}
			}
	
		}

	} else {
	
		var pos, arr, emitterid, timetoremove, soundlayer
	
		for (var i = 0; i < 3; i++) {

			for(pos = 0; pos < ds_list_size(emitters_to_remove); pos++){
				arr = ds_list_find_value(emitters_to_remove,pos)
	
				emitterid = ds_list_find_value(arr,0)
				timetoremove = ds_list_find_value(arr,1)
				soundlayer = ds_list_find_value(arr, 2)
		
				if(layerid = 0 || (soundlayer >= layerid && soundlayer <= layerto)){
					ds_list_delete(emitters_to_remove,pos)
					//audio_emitter_free(emitterid)
					audio_stop_sound(emitterid)
					//log("freeing emitter with id " + string(emitterid))
					sounds--
				}
			}
	
		}
	
	}
}
