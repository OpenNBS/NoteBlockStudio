/// @description Compose modern Hangul and Japanese kana before measuring or drawing.
function string_compose_display(text) {
	var length = string_length(text)
	if (length < 2) return text

	var output = undefined
	var pos = 1
	while (pos <= length) {
		var char_code = string_ord_at(text, pos)
		var composed = -1
		var consumed = 1

		// Unicode algorithmic Hangul composition: L + V (+ T).
		if (char_code >= $1100 && char_code <= $1112 && pos < length) {
			var vowel_code = string_ord_at(text, pos + 1)
			if (vowel_code >= $1161 && vowel_code <= $1175) {
				composed = $AC00 + ((char_code - $1100) * 21 + (vowel_code - $1161)) * 28
				consumed = 2
				if (pos + 2 <= length) {
					var trailing_code = string_ord_at(text, pos + 2)
					if (trailing_code >= $11A8 && trailing_code <= $11C2) {
						composed += trailing_code - $11A7
						consumed = 3
					}
				}
			}
		}

		// Also compose an existing LV syllable followed by a trailing Jamo.
		if (composed = -1 && char_code >= $AC00 && char_code <= $D7A3
			&& (char_code - $AC00) mod 28 = 0 && pos < length) {
			var trailing_code_lv = string_ord_at(text, pos + 1)
			if (trailing_code_lv >= $11A8 && trailing_code_lv <= $11C2) {
				composed = char_code + trailing_code_lv - $11A7
				consumed = 2
			}
		}

		// Compose common kana + dakuten/handakuten sequences.
		if (composed = -1 && pos < length) {
			composed = unicode_compose_kana(char_code, string_ord_at(text, pos + 1))
			if (composed != -1) consumed = 2
		}

		if (composed != -1) {
			if (is_undefined(output)) {
				output = []
				if (pos > 1) array_push(output, string_copy(text, 1, pos - 1))
			}
			array_push(output, chr(composed))
			pos += consumed
			continue
		}

		if (!is_undefined(output)) array_push(output, string_char_at(text, pos))
		pos += 1
	}

	if (is_undefined(output)) return text
	return string_concat_ext(output)
}
