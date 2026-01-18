function menu_print(argument0, argument1, argument2) {
	// menu_print(obj, level, menu)
	// For debug
	var a, obj, lvl, submenu;
	obj = argument0
	lvl = argument1
	submenu = argument2
	for (a = 0; a < obj.items[submenu]; a += 1) {
	    var str;
	    str = ""
	    repeat lvl str += "  "
	    if (obj.item_str[submenu, a] = "-") {
	        str += "------------"
	        log(str)
	    } else {
	        if (obj.item_inactive[submenu, a]) str += "(inactive) "
	        if (obj.item_image[submenu, a] > -1) str += "image:" + string(obj.item_image[submenu, a]) + " "
	        if (obj.item_shortcut[submenu, a] != "") str += "shortcut:" + obj.item_shortcut[submenu, a] + " "
	        str += obj.item_str[submenu, a]
	        if (obj.item_hasmenu[submenu, a] > 0) str += " Menu: " + string(obj.item_hasmenu[submenu, a])
	        log(str)
	        if (obj.item_hasmenu[submenu, a] > 0) menu_print(obj, lvl + 1, obj.item_hasmenu[submenu, a])
	    }
	}



}
