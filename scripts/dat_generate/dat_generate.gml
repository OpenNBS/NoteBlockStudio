function dat_generate(functionpath, functiondir, objective, plan) {
	var o = obj_controller
	var song_instance = o.songs[o.song]
	var speed_objective = objective + "_s"
	var occupied = array_create(song_instance.enda + 1, false)

	for (var tick = 0; tick <= song_instance.enda; tick++) {
		var rows = plan.rows_by_tick[tick]
		// The final source column still owns stop/loop termination even when its
		// only Sound Stopper is a natural no-op.
		if (array_length(rows) == 0 && tick != song_instance.enda) continue
		occupied[tick] = true
		var text = ""
		for (var r = 0; r < array_length(rows); r++) {
			var row = rows[r]
			if (row.kind == "tempo") text += "scoreboard players set @s " + speed_objective + " " + string(row.speed) + br
			else text += row.command + br
			if (row.kind == "play" && o.dat_visualizer) text += dat_generate_visualizer(row, tick)
		}
		if (tick < song_instance.enda) {
			text += "scoreboard players set @s " + objective + "_t " + string(tick)
		} else if (o.dat_enablelooping) {
			text += "scoreboard players set @s " + objective + " " + string(song_instance.loopstart * 80) + br
			text += "scoreboard players set @s " + objective + "_t " + string(song_instance.loopstart - 1) + br
			text += "scoreboard players set @s " + speed_objective + " " + string(minecraft_export_snapped_speed(minecraft_export_tempo_at_tick(song_instance, song_instance.loopstart, o.dat_includelocked)))
		} else {
			text += "function " + functionpath + "stop"
		}
		dat_writefile(text, functiondir + "notes/" + string(tick) + ".mcfunction")
	}

	// Every leaf uses only a lower score bound plus last-played-tick. This lets
	// one 20 TPS invocation dispatch every crossed song column at high tempos.
	var length = song_instance.enda
	var steps = floor(log2(max(1, length))) + 1
	var pow = power(2, steps)
	for (var step = 0; step < steps; step++) {
		var searchrange = floor(pow / power(2, step))
		var segments = floor(pow / searchrange)
		for (var segment = 0; segment < segments; segment++) {
			var half = floor(searchrange / 2)
			var lower = searchrange * segment
			var min1 = lower
			var max1 = lower + half - 1
			var min2 = lower + half
			var max2 = lower + searchrange - 1
			if (min1 > length) break
			var text = ""
			if (step == steps - 1) {
				if (occupied[min1]) text += "execute as @s[scores={" + objective + "=" + string(min1 * 80) + "..," + objective + "_t=.." + string(min1 - 1) + "}] run function " + functionpath + "notes/" + string(min1) + br
				if (min2 <= length && occupied[min2]) text += "execute as @s[scores={" + objective + "=" + string(min2 * 80) + "..," + objective + "_t=.." + string(min2 - 1) + "}] run function " + functionpath + "notes/" + string(min2) + br
			} else {
				var first1 = -1, last1 = -1
				for (var i = min1; i <= min(max1, length); i++) if (occupied[i]) { if (first1 < 0) first1 = i; last1 = i }
				if (first1 >= 0) text += "execute as @s[scores={" + objective + "=" + string(first1 * 80) + "..," + objective + "_t=.." + string(last1 - 1) + "}] run function " + functionpath + "tree/" + string(min1) + "_" + string(max1) + br
				var first2 = -1, last2 = -1
				for (var i = min2; i <= min(max2, length); i++) if (occupied[i]) { if (first2 < 0) first2 = i; last2 = i }
				if (first2 >= 0) text += "execute as @s[scores={" + objective + "=" + string(first2 * 80) + "..," + objective + "_t=.." + string(last2 - 1) + "}] run function " + functionpath + "tree/" + string(min2) + "_" + string(max2) + br
			}
			if (text != "") dat_writefile(text, functiondir + "tree/" + string(min1) + "_" + string(max2) + ".mcfunction")
		}
	}
}

function minecraft_export_tempo_at_tick(song_instance, wanted_tick, include_locked) {
	var current_tempo = song_instance.real_tempo
	for (var tick = 0; tick <= min(wanted_tick, song_instance.enda); tick++) {
		if (song_instance.colamount[tick] <= 0) continue
		for (var layer_index = 0; layer_index <= song_instance.collast[tick]; layer_index++) {
			if (!song_instance.song_exists[tick, layer_index]) continue
			if (!include_locked && obj_controller.lockedlayer[layer_index]) continue
			var instrument_index = ds_list_find_index(song_instance.instrument_list, song_instance.song_ins[tick, layer_index])
			if (instrument_index >= 0 && song_instance.instrument_list[| instrument_index].name == "Tempo Changer") current_tempo = minecraft_export_tempo_from_note(song_instance, tick, layer_index)
		}
	}
	return current_tempo
}

function dat_generate_visualizer(row, tick) {
	var o = obj_controller
	var song_instance = o.songs[o.song]
	var layer_index = row.layer
	var key = minecraft_export_effective_key(song_instance, tick, layer_index, row.instrument)
	var blockvolume = song_instance.layervol[layer_index] / 100 / 100 * song_instance.song_vel[tick, layer_index]
	var stereo = (song_instance.layerstereo[layer_index] + song_instance.song_pan[tick, layer_index]) / 2
	var blockposition = abs(stereo - 100) / 100
	var team_number = string(row.instrument + 1)
	var block_id = block_get_namespaced_id(o.sch_exp_ins_block[row.instrument])
	var prefix = "summon minecraft:falling_block "
	var tags = o.dat_glow ? "Tags:[\"nbs\",\"nbs_" + team_number + "\"],Glowing:1," : ""
	var text = ""
	switch (o.dat_vis_type) {
		case "Arc": text += prefix + string((key - 45) * -1 + real(o.dat_xval)) + " " + string(o.dat_yval) + " " + string(row.instrument * 2 + real(o.dat_zval)) + " {BlockState:{Name:\"minecraft:" + block_id + "\"}," + tags + "Time:-120,DropItem:0,Motion:[0.0d,1.0d,1.0d]}" + br; break
		case "Fall": text += prefix + string(key - 45 + real(o.dat_xval)) + " " + string(o.dat_yval) + " " + string(row.instrument * 2 + real(o.dat_zval)) + " {BlockState:{Name:\"minecraft:" + block_id + "\"}," + tags + "Time:-80,DropItem:0,Motion:[0.0d,-1.3d,0.0d]}" + br; break
		case "Piano Roll": text += prefix + string((key - 45) * -1 + real(o.dat_xval)) + " " + string(o.dat_yval) + " " + string(real(o.dat_zval)) + " {BlockState:{Name:\"minecraft:" + block_id + "\"}," + tags + "Time:-50,DropItem:0,NoGravity:1,Motion:[0.0d,0.0d,2.5d]}" + br; break
		case "Rise": text += prefix + string(key - 45 + real(o.dat_xval)) + " " + string(o.dat_yval) + " " + string(row.instrument * 2 + real(o.dat_zval)) + " {BlockState:{Name:\"minecraft:" + block_id + "\"}," + tags + "Time:-50,DropItem:0,Glowing:1,NoGravity:1,Motion:[0.0d,1.0d,0.0d]}" + br; break
		case "Bounce": text += prefix + team_number + " " + string(o.dat_yval) + " " + string(row.instrument * 2 + real(o.dat_zval)) + " {BlockState:{Name:\"minecraft:" + block_id + "\"}," + tags + "Time:-80,DropItem:0,Motion:[0.0d,1.3d,0.0d]}" + br; break
		case "Fountain": text += prefix + team_number + " " + string(o.dat_yval) + " " + string(row.instrument * 2 + real(o.dat_zval)) + " {BlockState:{Name:\"minecraft:" + block_id + "\"}," + tags + "Time:-80,DropItem:0,Motion:[" + (key > 45 ? "0.5d" : "-0.5d") + ",1.5d,0.0d]}" + br; break
		case "Rittai Onkyou":
			text += prefix + string(blockposition * 48) + " 90 " + string(blockvolume * 48) + " {Tags:[\"nbs\"],BlockState:{Name:\"minecraft:" + block_id + "\"},Time:-80,DropItem:0,Motion:[0.0d,-1.3d,0.0d]}" + br
			text += prefix + string(blockposition * 48) + " 90 " + string(blockvolume * 48 - 1) + " {Tags:[\"nbs\"],BlockState:{Name:\"minecraft:note_block\"},Time:-80,DropItem:0,Motion:[0.0d,-1.3d,0.0d]}" + br
			text += "particle minecraft:note " + string(blockposition * 48) + " 90 " + string(blockvolume * 48 - 2) + " 0 0 0 1 1 force @p" + br
	}
	if (o.dat_glow && o.dat_vis_type != "Rittai Onkyou") text += "team join nbs_" + team_number + " @e[tag=nbs_" + team_number + "]" + br
	return text
}
