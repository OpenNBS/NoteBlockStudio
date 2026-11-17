/// @description Return 1 for dakuten, 2 for handakuten, or 0 for another character.
function unicode_kana_mark_type(char_code) {
	if (char_code = $3099 || char_code = $309B || char_code = $FF9E) return 1
	if (char_code = $309A || char_code = $309C || char_code = $FF9F) return 2
	return 0
}
