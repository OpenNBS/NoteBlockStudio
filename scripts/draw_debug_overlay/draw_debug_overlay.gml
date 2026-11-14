function draw_debug_overlay(){
	var str, cwindow;
	var prevalpha = draw_get_alpha()
	var xx = 4
	var yy = rh - 4 - !isplayer * 25
	switch (window) {
	    case w_menu: cwindow = "w_menu" break
		case w_releasemouse: cwindow = "w_releasemouse" break
		case w_mididevices: cwindow = "w_mididevices" break
		case w_insbox: cwindow = "w_insbox" break
		case w_dragvol: cwindow = "w_dragvol" break
		case w_dragstereo: cwindow = "w_dragstereo" break
		case w_dragsection_end: cwindow = "w_dragsection_end" break
		case w_dragsection_start: cwindow = "w_dragsection_star" break
		case w_dragselection: cwindow = "w_dragselection" break
		case w_dragmarker: cwindow = "w_dragmarker" break
		case w_dragtempo: cwindow = "w_dragtempo" break
		case w_drag: cwindow = "w_drag" break
		case w_changelist: cwindow = "w_changelist" break
		case w_update: cwindow = "w_update" break
		case w_minecraft: cwindow = "w_minecraft" break
		case w_schematic_export: cwindow = "w_schematic_export" break
		case w_branch_export: cwindow = "w_branch_export" break
		case w_datapack_export: cwindow = "w_datapack_export" break
		case w_mp3_export: cwindow = "w_mp3_export" break
		case w_checkupdates: cwindow = "w_checkupdates" break
		case w_about: cwindow = "w_about" break
		case w_songinfoedit: cwindow = "w_songinfoedit" break
		case w_songinfo: cwindow = "w_songinfo" break
		case w_midi_exp: cwindow = "w_midi_exp" break
		case w_associate: cwindow = "w_associate" break
		case w_properties: cwindow = "w_properties" break
		case w_stats: cwindow = "w_stats" break
		case w_midi: cwindow = "w_midi" break
		case w_schematic: cwindow = "w_schematic" break
		case w_instruments: cwindow = "w_instruments" break
		case w_preferences: cwindow = "w_preferences" break
		case w_greeting: cwindow = "w_greeting" break
		case w_clip_editor: cwindow = "w_clip_editor" break
		case w_stereo: cwindow = "w_stereo" break
		case w_arpeggio: cwindow = "w_arpeggio" break
		case w_tremolo: cwindow = "w_tremolo" break
		case w_stagger: cwindow = "w_stagger" break
		case w_portamento: cwindow = "w_portamento" break
		case w_saveoptions: cwindow = "w_saveoptions" break
		case w_setvelocity: cwindow = "w_setvelocity" break
		case w_setpanning: cwindow = "w_setpanning" break
		case w_setpitch: cwindow = "w_setpitch" break
		case w_settempo: cwindow = "w_settempo" break
		case w_tempotapper: cwindow = "w_tempotapper" break
		case w_setaccent: cwindow = "w_setaccent" break
		default: cwindow = string(window) break
	}
	yy = draw_debug_overlay_stack(xx, yy, "Note Block Studio v" + version)
	yy = draw_debug_overlay_stack(xx, yy, string(fps) + " FPS (" + string_format(fps / game_get_speed(gamespeed_fps) * 100, 1, 0) + "%) ")
	yy = draw_debug_overlay_stack(xx, yy, "Window: " + string(cwindow))
	yy = draw_debug_overlay_stack(xx, yy, os_info[? condstr(os_type = os_windows, "video_adapter_description", "gl_renderer_string")])
	yy = draw_debug_overlay_stack(xx, yy, "Display: " + string(window_width) + "x" + string(window_height))
	yy = draw_debug_overlay_stack(xx, yy, "Executing in: " + output_format)
	draw_set_alpha(prevalpha)
}

function draw_debug_overlay_stack(x, y, str){
	draw_theme_font(0, 0)
	draw_set_alpha(0.5)
	draw_set_color(0)
	draw_rectangle(x - 4, y - 12, x + string_width_dynamic(str) + 4, y + 4, 0)
	y -= 10
	draw_set_alpha(1)
	draw_set_color(c_white)
	if (!hires || theme != 3) draw_text(x, y, str)
	else draw_text_transformed(x, y, str, 0.25, 0.25, 0)
	y -= 7
	return y
}