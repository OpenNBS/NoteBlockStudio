var o = obj_controller;

var ev_type = async_load[? "event_type"];

if (ev_type == "DiscordReady" || ready || o.presence)
{
	log("[NekoPresence] date: " + string(date_current_datetime()));
	np_setpresence_timestamps(date_current_datetime(), 0, false);
	np_setpresence_more("Note Block Studio", "", false);
	ready = true;
	
	//np_setpresence() should ALWAYS come the last!!
	//if (o.presencewindow = 1) np_setpresence(condstr(o.filename = "", "Unsaved song") + filename_name(o.filename), time_str(o.marker_pos / o.tempo) + " / " + time_str(o.enda / o.tempo), "note", "");
	//else np_setpresence(condstr(o.filename = "", "Unsaved song") + filename_name(o.filename), string_copy(time_str(o.marker_pos / o.tempo), 0, 8) + " / " + string_copy(time_str(o.enda / o.tempo), 0, 8), "note", "");
	
	// passing a URL will add this sprite asynchronously via *internets*
	sprite_add(np_get_avatar_url(async_load[? "user_id"], async_load[? "avatar"]), 1, false, false, 0, 0);
} else {
	show_error("NekoPresence error:\n" + json_encode(async_load), true)
}