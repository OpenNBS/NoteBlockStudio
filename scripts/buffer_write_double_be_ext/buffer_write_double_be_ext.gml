function buffer_write_double_be_ext(buffer, file) {
	// buffer_write_double_be(val)
	// Writes a big endian double to the buffer

	var tmpbuf, a, b, c, d, e, f, g, h;
	tmpbuf = buffer_create(8, buffer_fixed, 1)
	buffer_write(tmpbuf, buffer_f64, file)
	buffer_seek(tmpbuf, 0, 0)
	a = buffer_read(tmpbuf, buffer_s8)
	b = buffer_read(tmpbuf, buffer_s8)
	c = buffer_read(tmpbuf, buffer_s8)
	d = buffer_read(tmpbuf, buffer_s8)
	e = buffer_read(tmpbuf, buffer_s8)
	f = buffer_read(tmpbuf, buffer_s8)
	g = buffer_read(tmpbuf, buffer_s8)
	h = buffer_read(tmpbuf, buffer_s8)
	buffer_delete(tmpbuf)

	buffer_write(buffer, buffer_s8, h)
	buffer_write(buffer, buffer_s8, g)
	buffer_write(buffer, buffer_s8, f)
	buffer_write(buffer, buffer_s8, e)
	buffer_write(buffer, buffer_s8, d)
	buffer_write(buffer, buffer_s8, c)
	buffer_write(buffer, buffer_s8, b)
	buffer_write(buffer, buffer_s8, a)



}
