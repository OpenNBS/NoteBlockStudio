function open_url(url) {
  if (string_copy(url, 0, 7) == "assets/") url = program_directory + url;
  if (os_type = os_windows) execute_shell("cmd", @'explorer "' + url + @'"');
  else if (os_type == os_macosx) execute_shell("open", @'"' + url + @'"');
  else if (os_type == os_linux) execute_shell("xdg-open", @'"' + url + @'"');
}
