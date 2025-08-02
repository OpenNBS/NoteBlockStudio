/// directory_copy(src, dst)  → 0 on success, -1 on any error
function directory_copy(src, dst)
{
    var sep = (os_type == os_windows) ? "\\" : "/";

    // ---------- copy a single file ----------
    if (file_exists(src))
        return file_copy(src, dst) ? 0 : -1;

    // ---------- copy a directory ----------
    if (!directory_exists(src))
        return -1;

    if (!directory_exists(dst))
        if (!directory_create(dst)) return -1;

    // Grab *all* entries – non-Windows ignores the attr flag
    var entry = file_find_first(src + sep + "*", 0);   // 0 == fa_anyfile
    while (entry != "")
    {
        var sub_src = entry;                                    // already includes full path
        var sub_dst = dst + sep + filename_name(entry);

        if (directory_exists(sub_src))
        {
            if (directory_copy(sub_src, sub_dst) < 0) {
                file_find_close();
                return -1;
            }
        }
        else    // regular file
        {
            if (!file_copy(sub_src, sub_dst)) {
                file_find_close();
                return -1;
            }
        }
        entry = file_find_next();
    }
    file_find_close();
    return 0;
}