function buffer_write_short_be(argument0) {
	// buffer_write_short_be(val)
	// Writes a big endian short to the buffer

	var tmpbuf, a, b;
	tmpbuf = buffer_create(2, buffer_fixed, 1)
	buffer_write(tmpbuf, buffer_s16, argument0)
	buffer_seek(tmpbuf, 0, 0)
	a = buffer_read(tmpbuf, buffer_s8)
	b = buffer_read(tmpbuf, buffer_s8)
	buffer_delete(tmpbuf)

	buffer_write_byte(b)
	buffer_write_byte(a)



}
