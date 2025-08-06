function buffer_read_short_be() {
	// buffer_read_short_be()
	// Reads a 2 byte big endian short integer.

	var b1, b2;
	b1 = buffer_read_byte()
	b2 = buffer_read_byte()
	return b1 * 256 + b2
       



}
