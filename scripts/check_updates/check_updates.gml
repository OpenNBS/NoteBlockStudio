function check_updates() {
	// check_updates()
	// Handles the update checking
	// update values:
	// -1: unable to check for update
	// 0: checking
	// 1: update found
	// 2: up to date
	// 4: downloading update

	if (async_load[? "id"] = update_http) {
		
		// CHECK RECEIVED DATA:
		// show_debug_message(async_load[? "result"])
		// show_debug_message(async_load[? "status"])
		// show_debug_message(async_load[? "http_status"])
		
		var status = async_load[? "status"];
		
		if (status == -1) { // error
			update = -1
			return;
		}
		
		else if (status == 0) { // success
			
			if (async_load[? "http_status"] != 200) { // other status codes (403 - rate limit, etc.)
				update = -1;
				return;
			}
			
			else {
				update_http = -1;
			
			    var res = async_load[? "result"];
				res = json_parse(res);

				var release = -1;
				if (check_prerelease) {
					// Get first (latest) release on list, whether it's a release OR pre-release
					release = res[0];
				} else {
					release = res;
				}
			
				if (release != -1) {
					var new_version = release.tag_name;
					if (string_char_at(new_version, 1) == "v") new_version = string_delete(new_version, 1, 1);
					var version_order = update_compare_versions(new_version, version);
					if (is_undefined(version_order)) {
						update = -1;
					} else if (version_order <= 0) {
						update = 2;
					} else {
						if (question(condstr(language != 1, "Version " + new_version + " is available! Do you want to download it?", "版本 " + new_version + " 可用！是否现在下载？"), condstr(language != 1, "Update available!", "更新可用！"))) {
							if (os_type = os_windows) {
								var download_url = release.assets[0].browser_download_url;
								update_download = http_get_file(download_url, update_file);
								update = 4;
							} else if (os_type == os_macosx && macos_install_channel == "testflight") {
								open_url("https://testflight.apple.com/join/hg58hwbM")
								update = 1;
							} else {
								open_url("https://github.com/OpenNBS/NoteBlockStudio/releases")
								update = 1;
							}
						} else {
							update = 1;
						}
					}
				} else update = -1;
			
			}
		}
	}
}

function update_version_identifiers(value) {
	var parts = []
	while (true) {
		var dot = string_pos(".", value)
		if (dot == 0) {
			array_push(parts, value)
			return parts
		}
		array_push(parts, string_copy(value, 1, dot - 1))
		value = string_delete(value, 1, dot)
	}
}

function update_parse_version(value) {
	if (string_char_at(value, 1) == "v") value = string_delete(value, 1, 1)
	var build = string_pos("+", value)
	if (build > 0) value = string_copy(value, 1, build - 1)
	var dash = string_pos("-", value)
	var prerelease = []
	if (dash > 0) {
		prerelease = update_version_identifiers(string_delete(value, 1, dash))
		value = string_copy(value, 1, dash - 1)
		for (var i = 0; i < array_length(prerelease); i++) {
			if (prerelease[i] == "") return undefined
		}
	}
	var core = update_version_identifiers(value)
	if (array_length(core) != 3) return undefined
	for (var i = 0; i < 3; i++) {
		if (core[i] == "" || string_digits(core[i]) != core[i]) return undefined
		core[i] = real(core[i])
	}
	return { core: core, prerelease: prerelease }
}

function update_compare_versions(candidate, installed) {
	// SemVer ordering: numeric core, stable above prerelease, numeric suffixes
	// compared numerically (beta.10 > beta.6). Build metadata has no precedence.
	var newer = update_parse_version(candidate)
	var older = update_parse_version(installed)
	if (is_undefined(newer) || is_undefined(older)) return undefined
	for (var i = 0; i < 3; i++) {
		if (newer.core[i] != older.core[i]) return sign(newer.core[i] - older.core[i])
	}
	var new_count = array_length(newer.prerelease)
	var old_count = array_length(older.prerelease)
	if (new_count == 0 || old_count == 0) return sign(old_count) - sign(new_count)
	for (var i = 0; i < min(new_count, old_count); i++) {
		var new_part = newer.prerelease[i]
		var old_part = older.prerelease[i]
		if (new_part == old_part) continue
		var new_numeric = string_digits(new_part) == new_part
		var old_numeric = string_digits(old_part) == old_part
		if (new_numeric && old_numeric) return sign(real(new_part) - real(old_part))
		if (new_numeric != old_numeric) return new_numeric ? -1 : 1
		return new_part > old_part ? 1 : -1
	}
	return sign(new_count - old_count)
}
