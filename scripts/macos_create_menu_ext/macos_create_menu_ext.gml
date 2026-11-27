function macos_create_menu_ext(argument0, argument1, argument2) {
	// macos_create_menu_ext(name, x, y, str)
	// name  name of menu
	// x, y   position
	// str   obj contents
	//          |   new item
	//          -   separator
	//          \   start submenu
	//          /   end submenu
	//          ^!  prefix, inactive item
	//          x~  prefix, displays image x in the sprite
	//          x$  prefix, shortcut x
	// Returns the number of the item clicked, -1 for cancelled.

	//menu_shown = argument0
	//if (!isplayer) playing = 0
	//window += w_menu

	var obj, str, submenu, n, index, submenu_name, title;
	obj = create(obj_menu)
	obj.name = argument1
	obj.sx = 0
	obj.sy = 0
	obj.menus = 1
	obj.items[0] = 0
	obj.ani = 0
	obj.sel = -1
	submenu = 0
	submenu_name = ""
	n = 0
	index = 0
	title = argument0
	//wmenu = 2
	//if (windowsound && theme = 3) play_sound(soundshow, 45, 100, 100, 0)
	macos_menu_create(title)

	str = string_replace_all(argument2 + "|", "||", "|")
	while (str != "") {
	    var p, itemstr;
	    p = string_pos("|", str)
	    itemstr = string_copy(str, 1, p - 1)
	    str = string_delete(str, 1, p)
	    if (itemstr = "\\") { // New menu
	        obj.item_hasmenu[submenu, obj.items[submenu] - 1] = obj.menus
	        obj.menu_parent[obj.menus] = submenu
	        obj.items[obj.menus] = 0
	        submenu = obj.menus
			submenu_name = obj.name + "_" + string(n - 1)
	        obj.menus += 1
	    } else if (itemstr = "/") { // Return to current menus parent
	        submenu = obj.menu_parent[submenu]
	    } else {
	        // Check inactive
	        p = string_pos("^!", itemstr)
	        obj.item_inactive[submenu, obj.items[submenu]] = (p > 0)
	        itemstr = string_replace(itemstr, "^!", "")
	        // Check sprite
	        p = string_pos("~", itemstr)
	        if (p > 0) obj.item_image[submenu, obj.items[submenu]] = string_copy(itemstr, 1, p - 1)
	        else obj.item_image[submenu, obj.items[submenu]] = -1
	        itemstr = string_delete(itemstr, 1, p)
	        // Check shortcut
	        p = string_pos("$", itemstr)
	        obj.item_shortcut[submenu, obj.items[submenu]] = string_copy(itemstr, 1, p - 1)
	        itemstr = string_delete(itemstr, 1, p)
        
	        obj.item_n[submenu, obj.items[submenu]] = n
	        obj.item_str[submenu, obj.items[submenu]] = itemstr
	        obj.item_hasmenu[submenu, obj.items[submenu]] = 0
        
	        if (itemstr != "-") {
				var temp_title = title
				var temp_itemstr = itemstr
				var temp_shortcut = obj.item_shortcut[submenu, obj.items[submenu]]
				var temp_uid = obj.name + "_" + string(n)
				var temp_icon = ""
				if (submenu == 0) {
					macos_menu_add_item(temp_title, temp_itemstr, temp_shortcut, temp_uid)
					//log ("parent: " + title + " content: " + itemstr + " shortcut: " + obj.item_shortcut[submenu, obj.items[submenu]] + " uid: " + obj.name + "_" + string(n))
				}
				else {
					temp_title = submenu_name
					macos_menu_add_subitem(temp_title, temp_itemstr, temp_shortcut, temp_uid)
					//log ("parent: " + submenu_name + " content: " + itemstr + " shortcut: " + obj.item_shortcut[submenu, obj.items[submenu]] + " uid: " + obj.name + "_" + string(n))
				}
				if (obj.item_inactive[submenu, obj.items[submenu]]) macos_menu_set_enabled(temp_uid, 0)
				if (obj.item_image[submenu, obj.items[submenu]] != -1) {
					temp_icon = obj.item_image[submenu, obj.items[submenu]]
					macos_menu_set_icon(temp_uid, temp_icon)
				}
				n += 1
			} else {
				if (submenu == 0) macos_menu_add_separator(title, -1)
				else macos_submenu_add_separator(submenu_name, -1)
			}
	        obj.items[submenu] += 1
	    }
	}
	instance_destroy(obj)
}
