function open_midi() {
	// Parse before creating/replacing a tab or changing the current import state.
	var fn = argument[0]
	var replace = isplayer
	if (argument_count > 1) replace = argument[1]
	if (fn == "") {
		if (language != 1) fn = string(get_open_filename_ext("MIDI Sequences (*.mid)|*.midi;*.mid", "", "", "Import from MIDI"))
		else fn = string(get_open_filename_ext("MIDI Sequences (*.mid)|*.midi;*.mid", "", "", "从 MIDI 导入"))
	}
	if (fn == "" || !file_exists_lib(fn)) return 0

	var source = -1
	var parsed = undefined
	try {
		source = buffer_import(fn)
		if (source < 0) throw("Could not access MIDI file")
		parsed = midi_parse_buffer(source)
	} catch (error) {
		if (source >= 0) buffer_delete(source)
		show_debug_message("Failed to open MIDI file: " + string(error))
		message(condstr(language != 1,
			"This MIDI file could not be opened. It may be unreadable, invalid, or incomplete.\n\nYour existing songs have not been changed.",
			"无法打开此 MIDI 文件。文件可能无法读取、无效或不完整。\n\n现有歌曲未被更改。"), condstr(language != 1, "Import MIDI", "导入 MIDI"))
		return 0
	}
	buffer_delete(source)

	if (midi_import_song != noone) cancel_midi_import()
	var previous_song = songs[song]
	if (replace && !close_song(0, 1)) return 0
	var newsong = create(obj_song)
	array_push(songs, newsong)
	set_song(array_length(songs) - 1)
	reset_add()
	newsong.midifile = filename_name(fn)
	newsong.midiname = filename_name(fn)
	midi_import_song = newsong
	midi_import_previous_song = previous_song

	var fields = variable_struct_get_names(parsed)
	for (var i = 0; i < array_length(fields); i++) {
		variable_instance_set(id, fields[i], variable_struct_get(parsed, fields[i]))
	}
	window = w_midi
	sb_val[midi_sb1] = 0
	sb_val[midi_sb2] = 0
	sb_val[midi_sb3] = 0
	sb_val[midi_sb4] = 0
	for (var a = 0; a < 16; a++) {
		try {
			midi_channelins[a] = midi_ins[midi_channelpatch[a], 1]
			midi_channeloctave[a] = midi_ins[midi_channelpatch[a], 2]
		} catch (error) {
			midi_channelins[a] = -1
			midi_channeloctave[a] = 0
		}
	}
	for (var a = 0; a < midi_percamount; a++) {
		try {
			midi_percins[a] = midi_drum[midi_percnote[a], 1]
			midi_percpitch[a] = midi_drum[midi_percnote[a], 2] + 33
		} catch (error) {
			midi_percins[a] = -1
			midi_percpitch[a] = 33
		}
	}
	midi_songlength = midi_duration_cache[w_midi_tempo_changer ? 1 : 0][w_midi_removesilent ? 1 : 0]
	return 1
}

function cancel_midi_import() {
	var pending_song = midi_import_song
	var previous_song = midi_import_previous_song
	midi_import_song = noone
	midi_import_previous_song = noone
	reset_midi()
	for (var i = 0; i < array_length(songs); i++) {
		if (songs[i] != pending_song) continue
		// Only discard the untouched tab created for this import preview.
		if (songs[i].totalblocks == 0 && !songs[i].changed && songs[i].midifile != "") close_song(i, 0, true)
		break
	}
	for (var i = 0; i < array_length(songs); i++) {
		if (songs[i] == previous_song) { set_song(i); break }
	}
	w_midi_tab = 0
	text_focus = -1
	window = 0
	windowanim = 0
	windowopen = 0
	windowclose = 0
	windowalpha = 0
	windowprogress = 0
}

function midi_require_bytes(reader, count) {
	// A failed buffer read may not advance the cursor. Check before every read/skip.
	if (count < 0 || count > reader.limit - buffer_tell(reader.source)) throw("Unexpected end of MIDI data")
}

function midi_read_byte(reader) {
	midi_require_bytes(reader, 1)
	return buffer_read(reader.source, buffer_u8)
}

function midi_read_be(reader, count) {
	midi_require_bytes(reader, count)
	var value = 0
	repeat (count) value = value * 256 + buffer_read(reader.source, buffer_u8)
	// Preserve floating-point tempo calculations in this runtime.
	return value / 1.0
}

function midi_read_varlen(reader) {
	var value = 0
	repeat (4) {
		var byte = midi_read_byte(reader)
		value = (value << 7) | (byte & $7F)
		if (byte < $80) return value
	}
	throw("Invalid MIDI variable-length quantity")
}

function midi_read_text(reader, count) {
	midi_require_bytes(reader, count)
	var value = ""
	repeat (count) value += chr(buffer_read(reader.source, buffer_u8))
	return value
}

function midi_skip_bytes(reader, count) {
	midi_require_bytes(reader, count)
	buffer_seek(reader.source, buffer_seek_relative, count)
}

function midi_parse_buffer(source) {
	var file_size = buffer_get_size(source)
	var reader = {source: source, limit: file_size}
	if (midi_read_text(reader, 4) != "MThd") throw("Invalid MIDI header")
	var header_length = midi_read_be(reader, 4)
	if (header_length < 6) throw("Invalid MIDI header length")
	midi_require_bytes(reader, header_length)
	var format = midi_read_be(reader, 2)
	if (format > 2) throw("Unsupported MIDI format")
	var tracks = midi_read_be(reader, 2)
	var division = midi_read_be(reader, 2)
	midi_skip_bytes(reader, header_length - 6)
	if (tracks == 0 || tracks > (file_size - buffer_tell(source)) div 8) throw("Invalid MIDI track count")
	if (division == 0) throw("Invalid MIDI time division")
	if ((division & $8000) != 0) {
		var frame_rate = 256 - (division >> 8)
		if ((frame_rate != 24 && frame_rate != 25 && frame_rate != 29 && frame_rate != 30) || (division & $FF) == 0) throw("Invalid SMPTE time division")
	}

	var parsed = {
		midi_copyright: "", midi_tempo: division, midi_tracks: tracks,
		midi_micsecqn: 0, midi_minpos: -1, midi_maxpos: 0,
		midi_songlength: 0, midi_duration_cache: [[0, 0], [0, 0]],
		midi_trackname: array_create(tracks, ""),
		midi_trackamount: array_create(tracks, 0),
		midi_tracklength: array_create(tracks, 0),
		midi_eventx: [], midi_eventnote: [], midi_eventvel: [], midi_eventchannel: [],
		midi_eventpatch: [], midi_eventpart: [], midi_eventuntil: [],
		midi_channels: 0, midi_channelpatch: array_create(16, 0),
		midi_channelins: array_create(16, 0), midi_channeloctave: array_create(16, 0),
		midi_parts: [], midi_part_lookup: {},
		midi_percamount: 0, midi_percnote: [], midi_percins: [], midi_percpitch: [],
		midi_tempo_changers: 0, midi_tempo_changer_x: [-1], midi_tempo_changer_tempo: [-1]
	}
	with (parsed) {
		var track = 0
		while (track < tracks) {
			reader.limit = file_size
			var chunk_type = midi_read_text(reader, 4)
			var chunk_length = midi_read_be(reader, 4)
			midi_require_bytes(reader, chunk_length)
			if (chunk_type != "MTrk") {
				midi_skip_bytes(reader, chunk_length)
				continue
			}
			if (chunk_length == 0) throw("Empty MIDI track")
			reader.limit = buffer_tell(source) + chunk_length
			var pos = 0
			var running_status = -1
			while (buffer_tell(source) < reader.limit) {
				pos += midi_read_varlen(reader)
				var event = midi_read_byte(reader)
				if (event < $80) {
					if (running_status < 0) throw("MIDI data without running status")
					event = running_status
					buffer_seek(source, buffer_seek_relative, -1)
				}
				if (event == $FF) {
					running_status = -1
					var meta = midi_read_byte(reader)
					if (meta >= $80) throw("Invalid MIDI meta event")
					var length = midi_read_varlen(reader)
					midi_require_bytes(reader, length)
					if (meta == $2) midi_copyright = midi_read_text(reader, length)
					else if (meta == $3) midi_trackname[track] = midi_read_text(reader, length)
					else if (meta == $51) {
						if (length < 3) throw("Incomplete MIDI tempo event")
						var tempo_value = midi_read_be(reader, 3)
						if (tempo_value == 0) throw("Invalid MIDI tempo")
						midi_tempo_changer_x[midi_tempo_changers] = pos
						midi_tempo_changer_tempo[midi_tempo_changers] = 60000000 / tempo_value
						midi_tempo_changers++
						if (midi_micsecqn == 0) midi_micsecqn = tempo_value
						midi_skip_bytes(reader, length - 3)
					} else {
						midi_skip_bytes(reader, length)
					}
					if (meta == $2F) {
						midi_skip_bytes(reader, reader.limit - buffer_tell(source))
						break
					}
				} else if (event == $F0 || event == $F7) {
					running_status = -1
					midi_skip_bytes(reader, midi_read_varlen(reader))
				} else if (event == $F8 || event == $FA || event == $FB || event == $FC) {
					// Preserve support for standalone real-time events in older files.
					continue
				} else {
					if (event >= $F0) throw("Unknown MIDI event")
					running_status = event
					var eventtype = event >> 4
					var channel = event & $F
					var data1 = midi_read_byte(reader)
					var data2 = 0
					if (eventtype != $C && eventtype != $D) data2 = midi_read_byte(reader)
					if (data1 >= $80 || data2 >= $80) throw("Invalid MIDI event data")
					switch (eventtype) {
						case $8: midi_set_until(channel, track, pos, data1, data2); break
						case $9:
							if (data2 > 0) midi_add_note(channel, track, pos, data1, data2)
							else midi_set_until(channel, track, pos, data1, data2)
							break
						case $C: midi_channelpatch[channel] = data1; break
					}
				}
			}
			track++
		}
		cache_midi_durations()
	}
	return parsed
}

// Cache both options once per file: [tempo changes off/on][leading silence kept/removed].
function cache_midi_durations() {
	midi_duration_cache = [[0, 0], [0, 0]]
	var division = midi_tempo & $7FFF
	if (division <= 0 || midi_maxpos <= 0 || midi_micsecqn <= 0) return
	var trim_start = max(0, midi_minpos)
	// Use the same initial tempo as the importer before the first change.
	var seconds_per_tick = midi_micsecqn / division / 1000000
	var full = midi_maxpos * seconds_per_tick
	var trimmed = max(0, midi_maxpos - trim_start) * seconds_per_tick
	midi_duration_cache = [[full, trimmed], [full, trimmed]]
	if (midi_tempo_changers <= 0 || (midi_tempo & $8000) != 0) return

	// Tracks are read separately, so their tempo events may be out of time order.
	// Keep file order for equal positions, matching the importer's last-event-wins rule.
	var changes = []
	for (var i = 0; i < midi_tempo_changers; i++) {
		if (midi_tempo_changer_tempo[i] > 0) {
			array_push(changes, [midi_tempo_changer_x[i], 60 / midi_tempo_changer_tempo[i] / division, i])
		}
	}
	array_sort(changes, function(left, right) {
		if (left[0] != right[0]) return left[0] - right[0]
		return left[2] - right[2]
	})
	full = 0
	trimmed = 0
	var previous_tick = 0
	for (var i = 0; i <= array_length(changes); i++) {
		var next_tick = midi_maxpos
		if (i < array_length(changes)) next_tick = clamp(changes[i][0], 0, midi_maxpos)
		full += (next_tick - previous_tick) * seconds_per_tick
		trimmed += max(0, next_tick - max(previous_tick, trim_start)) * seconds_per_tick
		previous_tick = next_tick
		if (next_tick >= midi_maxpos) break
		seconds_per_tick = changes[i][1]
	}
	midi_duration_cache[1] = [full, trimmed]
}
