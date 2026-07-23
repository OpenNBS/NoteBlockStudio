/// wav_load_buffer(fname) → sound ID (or −1 on failure)
function wav_load_buffer(_fname)
{
    var _src = buffer_load(_fname);
    if (_src == -1) {
        log("Failed to load: " + _fname);
        return -1;
    }

    var _size = buffer_get_size(_src);

    // 🔒 Clone into fixed-size buffer to avoid `buffer_grow` error
    var _buf = buffer_create(_size, buffer_fixed, 1);
    if (_buf == -1) {
        log("Failed to create fixed buffer.");
        buffer_delete(_src);
        return -1;
    }

    // ✅ Copy byte-for-byte
    for (var i = 0; i < _size; ++i) {
        buffer_poke(_buf, i, buffer_u8, buffer_peek(_src, i, buffer_u8));
    }

    buffer_delete(_src); // remove the grow buffer

    // RIFF / WAVE sanity check
    if (buffer_peek(_buf, 0, buffer_u32) != $46464952) {
        log("Invalid RIFF header.");
        buffer_delete(_buf);
        return -1;
    }
    if (buffer_peek(_buf, 8, buffer_u32) != $45564157) {
        log("Invalid WAVE format.");
        buffer_delete(_buf);
        return -1;
    }

    var pos   = 12; // start of first chunk
    var size  = buffer_get_size(_buf);
    var fmt_found  = false, data_found = false;
    var bits = 0, channels = 0, rate = 0;
    var data_ofs = 0, data_sz = 0;

    while (pos + 8 <= size)
    {
        var cid   = buffer_peek(_buf, pos,     buffer_u32);
        var csize = buffer_peek(_buf, pos + 4, buffer_u32);
        var body  = pos + 8;

        // "fmt "
        if (cid == $20746D66) {
            if (csize < 16) {
                log("fmt chunk too small.");
                break;
            }
            channels = buffer_peek(_buf, body + 2,  buffer_u16);
            rate     = buffer_peek(_buf, body + 4,  buffer_u32);
            bits     = buffer_peek(_buf, body + 14, buffer_u16);
            fmt_found = true;
        }
        // "data"
        else if (cid == $61746164) {
            data_ofs   = body;
            data_sz    = csize;
            data_found = true;
            break;
        }

        // advance to next chunk (with word alignment)
        pos = body + csize + (csize & 1);
    }

    if (!fmt_found) {
        log("Missing 'fmt ' chunk.");
        buffer_delete(_buf);
        return -1;
    }
    if (!data_found) {
        log("Missing 'data' chunk.");
        buffer_delete(_buf);
        return -1;
    }

    var fmt = (bits == 8)  ? buffer_u8  :
              ((bits == 16) ? buffer_s16 : -1);
    if (fmt == -1) {
        message("Unsupported bit depth: " + string(bits) + ", please use 8 bit or 16 bit.");
        buffer_delete(_buf);
        return -1;
    }

    var ch_fmt = (channels == 1) ? audio_mono :
                 ((channels == 2) ? audio_stereo : -1);
    if (ch_fmt == -1) {
        log("Unsupported channel count: " + string(channels));
        buffer_delete(_buf);
        return -1;
    }

    var bytes_per_frame = (bits div 8) * channels;
    if (rate <= 0) {
        log("Invalid sample rate: " + string(rate));
        buffer_delete(_buf);
        return -1;
    }

    // buffer_peek() returns integer values in this runtime, so cast before division.
    global.__temp_audio_duration__ = real(data_sz) / real(rate * bytes_per_frame);

    // GameMaker expects the buffer length in bytes, not sample frames.
    // Passing the frame count truncated 16-bit stereo WAVs to one quarter.
    var snd = audio_create_buffer_sound(_buf, fmt, rate, data_ofs, data_sz, ch_fmt);
    //buffer_delete(_buf);
	global.__temp_audio_buffer__ = _buf;
    return snd;
}
