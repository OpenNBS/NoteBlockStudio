/// directory_copy(src, dst) → 0 on success, –1 on any error
function directory_copy(src, dst)
{
    var sep = (os_type == os_windows) ? "\\" : "/";

    // -------- single file --------
    if (file_exists(src))
        return file_copy(src, dst) ? 0 : -1;

    // -------- verify src folder --------
    if (!directory_exists(src)) return -1;
    if (!directory_exists(dst) && !directory_create(dst)) return -1;

    // -------- collect *files* --------
    var file  = [];
    var files = 0;
    var entry = file_find_first(src + sep + "*.*", 0);            // regular files
	show_debug_message("first entry: " + entry)
    while (entry != "")
    {
        file[files++] = entry;
        entry = file_find_next();
		show_debug_message("entry: " + entry)
    }
    file_find_close();

    // -------- collect *sub-directories* --------
    entry = file_find_first(src + sep + "*", fa_directory);        // folders
	show_debug_message("first entry: " + entry)
    while (entry != "")
    {
        if (entry != "." && entry != "..") file[files++] = entry;
        entry = file_find_next();
		show_debug_message("entry: " + entry)
    }
    file_find_close();

    // -------- copy everything --------
    var i = 0, from, to;
    repeat (files)
    {
        entry = file[i++];
        from  = src + sep + entry;
        to    = dst + sep + entry;

        if (file_exists(from))                         // it’s a real file
		{
			if (!file_copy(from, to)) return -1;
		}
		else                                           // must be a directory
		{
			if (directory_copy(from, to) < 0) return -1;
		}
    }
    return 0;
}