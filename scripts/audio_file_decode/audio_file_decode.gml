function audio_file_decode(argument0, argument1) {
	// audio_file_decode(src, dest)

	execute_program(current_directory + "ffmpeg.exe", "-y -i \"" + argument0 + 
        "\" -f s16le -acodec pcm_s16le -ar 44100 -ac 2 \"" +
        argument1 + "\"", 1)
	return 1



}
