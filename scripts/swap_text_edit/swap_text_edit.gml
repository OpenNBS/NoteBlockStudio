function swap_text_edit(argument0, argument1) {
	// swap_text_edit(id1, id2)
	// Invalidates two text edit boxes after their backing values are swapped.
	// The next draw reloads each box from its authoritative value instead of
	// turning an uninitialized, off-screen box into an initialized empty one.

	var id1, id2
	id1 = argument0
	id2 = argument1

	text_exists[id1] = 0
	text_exists[id2] = 0


}
