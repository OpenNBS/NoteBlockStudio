/// @description Return a precomposed Japanese kana, or -1 if the pair has none.
function unicode_compose_kana(base_code, mark_code) {
	var mark_type = unicode_kana_mark_type(mark_code)
	if (mark_type = 0) return -1
	base_code = unicode_halfwidth_kana_base(base_code)

	if (mark_type = 1) {
		// Hiragana: vu, k/s rows, t row, and iteration mark.
		if (base_code = $3046) return $3094
		if (base_code >= $304B && base_code <= $305D && (base_code - $304B) mod 2 = 0) return base_code + 1
		if (base_code = $305F || base_code = $3061 || base_code = $3064 || base_code = $3066 || base_code = $3068) return base_code + 1
		if (base_code = $309D) return $309E

		// Katakana: vu, k/s rows, t row, historical w row, and iteration mark.
		if (base_code = $30A6) return $30F4
		if (base_code >= $30AB && base_code <= $30BD && (base_code - $30AB) mod 2 = 0) return base_code + 1
		if (base_code = $30BF || base_code = $30C1 || base_code = $30C4 || base_code = $30C6 || base_code = $30C8) return base_code + 1
		if (base_code >= $30EF && base_code <= $30F2) return $30F7 + (base_code - $30EF)
		if (base_code = $30FD) return $30FE
	}

	// The h rows use +1 for dakuten and +2 for handakuten.
	if (base_code >= $306F && base_code <= $307B && (base_code - $306F) mod 3 = 0) return base_code + mark_type
	if (base_code >= $30CF && base_code <= $30DB && (base_code - $30CF) mod 3 = 0) return base_code + mark_type
	return -1
}
