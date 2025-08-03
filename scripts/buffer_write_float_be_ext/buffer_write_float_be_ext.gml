function buffer_write_float_be_ext(buffer, file) {
	// buffer_write_float_be(val)
	// Writes a big endian float to the buffer

	var tmpbuf, a, b, c, d;
	tmpbuf = buffer_create(4, buffer_fixed, 1)
	buffer_write(tmpbuf, buffer_f32, file)
	buffer_seek(tmpbuf, 0, 0)
	a = buffer_read(tmpbuf, buffer_s8)
	b = buffer_read(tmpbuf, buffer_s8)
	c = buffer_read(tmpbuf, buffer_s8)
	d = buffer_read(tmpbuf, buffer_s8)
	buffer_delete(tmpbuf)

	buffer_write(buffer, buffer_s8, d)
	buffer_write(buffer, buffer_s8, c)
	buffer_write(buffer, buffer_s8, b)
	buffer_write(buffer, buffer_s8, a)



}
