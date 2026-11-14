/// @description Convert a half-width kana base when it has a voicing mark.
function unicode_halfwidth_kana_base(char_code) {
	if (char_code = $FF66) return $30F2
	if (char_code = $FF73) return $30A6
	if (char_code >= $FF76 && char_code <= $FF7A) return $30AB + 2 * (char_code - $FF76)
	if (char_code >= $FF7B && char_code <= $FF7F) return $30B5 + 2 * (char_code - $FF7B)
	if (char_code >= $FF80 && char_code <= $FF84) {
		var index = char_code - $FF80
		return $30BF + 2 * index + (index >= 2)
	}
	if (char_code >= $FF8A && char_code <= $FF8E) return $30CF + 3 * (char_code - $FF8A)
	if (char_code = $FF9C) return $30EF
	return char_code
}
