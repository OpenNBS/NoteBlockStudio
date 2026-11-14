#define np_get_avatar_url

if (!is_string(argument0) || !is_string(argument1) || !string_length(argument0) || !string_length(argument1)) return "";
return "https://cdn.discordapp.com/avatars/" + argument0 + "/" + argument1 + ".png";
