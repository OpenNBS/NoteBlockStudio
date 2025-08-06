function buffer_read_int_be() {
	// buffer_read_int_be()
	// Reads a 4 - byte big endian integer.

	var b1, b2, b3, b4;
	b1 = buffer_read_byte(buffer)
	b2 = buffer_read_byte(buffer)
	b3 = buffer_read_byte(buffer)
	b4 = buffer_read_byte(buffer)

	return b1 * 256 * 256 * 256 + b2 * 256 * 256 + b3 * 256 + b4



}
