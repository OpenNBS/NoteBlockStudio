// Set parent window of dialogs to be game window
if (os_type = os_windows || os_type = os_macosx || os_type = os_linux) widget_set_owner(string(int64(window_handle())))

// Copy defaults into sandbox to allow modification
directory_create(game_save_id)
if (os_type = os_windows) {
  if (!directory_exists(data_directory)) execute_program("Xcopy", @'/E /I "' + filename_dir(bundled_data_directory) + @'" "' + filename_dir(data_directory) + @'"', true)
  if (!directory_exists(songs_directory)) execute_program("Xcopy", @'/E /I "' + filename_dir(bundled_songs_directory) + @'" "' + filename_dir(songs_directory) + @'"', true)
  if (!directory_exists(pattern_directory)) execute_program("Xcopy", @'/E /I "' + filename_dir(bundled_pattern_directory) + @'" "' + filename_dir(pattern_directory) + @'"', true)
} if (os_type = os_macosx || os_type = os_linux || os_type = os_ios) {
  if (!directory_exists(data_directory)) execute_program("cp", @'-fR "' + filename_dir(bundled_data_directory) + @'" "' + filename_dir(data_directory) + @'"', true)
  if (!directory_exists(songs_directory)) execute_program("cp", @'-fR "' + filename_dir(bundled_songs_directory) + @'" "' + filename_dir(songs_directory) + @'"', true)
  if (!directory_exists(pattern_directory)) execute_program("cp", @'-fR "' + filename_dir(bundled_pattern_directory) + @'" "' + filename_dir(pattern_directory) + @'"', true)
}

// Maximize game window on startup
window_zoom(window_handle());

// Do everything else for create event...
control_create();
