// Set parent window of dialogs to be game window
if (os_type = os_windows || os_type = os_macosx || os_type = os_linux) widget_set_owner(string(int64(window_handle())))

// Copy user-editable defaults into the save directory.
directory_create(game_save_id)
// Linux keeps these bundled files; other desktop targets remove legacy saved copies.
var platform_data_needs_sync = (os_type == os_linux && (
	   !file_exists(data_directory + "changelog.txt")
	|| !file_exists(data_directory + "credits.txt")
	|| !file_exists(data_directory + "extranotes.zip")
	|| !file_exists(data_directory + "instrumenttextures.zip")
)) || (os_type != os_linux && (
	   file_exists(data_directory + "changelog.txt")
	|| file_exists(data_directory + "credits.txt")
	|| file_exists(data_directory + "extranotes.zip")
	|| file_exists(data_directory + "instrumenttextures.zip")
))
var copy_data = !directory_exists(data_directory)
             || !directory_exists(sounds_directory)
             || (os_type = os_windows && !file_exists(data_directory + "wallpaper.bat"))
			 || platform_data_needs_sync
var copy_songs = (os_type != os_macosx && !directory_exists(songs_directory))
var copy_patterns = (os_type != os_macosx && !directory_exists(pattern_directory))

if (copy_data || copy_songs || copy_patterns) copy_bundled_files(copy_data, copy_songs, copy_patterns)

// Old releases prefer DLLs in AppData over their own bundled copies.
// Remove only known application libraries so downgrades load the matching DLLs.
remove_legacy_copied_libraries()

// Do everything else for create event...
control_create();
