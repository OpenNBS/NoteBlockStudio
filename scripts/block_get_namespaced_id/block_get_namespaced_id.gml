function block_get_namespaced_id(argument0, argument1=0) {
	// block_get_namespaced_id(val, data)
	// Returns the namespaced ID of the block with the given value and data.

	var val, data, color;
	val = argument0
	data = argument1
	color = ""

	if (val = 35 || val = 95 || val = 159 || val = 160 || val = 171 || val = 172 || val = 251 || val = 252) {
	    switch (data) {
	        case 1: color = "orange_" break
	        case 2: color = "magenta_" break
	        case 3: color = "light_blue_" break
	        case 4: color = "yellow_" break
	        case 5: color = "lime_" break
	        case 6: color = "pink_" break
	        case 7: color = "gray_" break
	        case 8: color = "light_gray_" break
	        case 9: color = "cyan_" break
	        case 10: color = "purple_" break
	        case 11: color = "blue_" break
	        case 12: color = "brown_" break
	        case 13: color = "green_" break
	        case 14: color = "red_" break
	        case 15: color = "black_" break
	        default: color = "white_" break
	    }
	}

	switch (val) {
	    case 0: return "air"
	    case 1: return "stone"
	    case 2: return "grass_block"
	    case 3: return "dirt"
	    case 4: return "cobblestone"
	    case 5: return "oak_planks"
	    case 7: return "bedrock"
	    case 12: return "sand"
	    case 13: return "gravel"
	    case 14: return "gold_ore"
	    case 15: return "iron_ore"
	    case 16: return "coal_ore"
	    case 17: return "oak_log"
	    case 18: return "oak_leaves"
	    case 19: return "sponge"
	    case 20: return "glass"
	    case 21: return "lapis_ore"
	    case 22: return "lapis_block"
	    case 23: return "dispenser"
	    case 24: return "sandstone"
	    case 25: return "note_block"
	    case 26: return "bed"
	    case 27: return "golden_rail"
	    case 28: return "detector_rail"
	    case 29: return "sticky_piston"
	    case 30: return "cobweb"
	    case 33: return "piston"
	    case 35: return color + "wool"
	    case 41: return "gold_block"
	    case 42: return "iron_block"
	    case 45: return "brick_block"
	    case 46: return "tnt"
	    case 47: return "bookshelf"
	    case 48: return "mossy_cobblestone"
	    case 49: return "obsidian"
	    case 52: return "mob_spawner"
	    case 54: return "chest"
	    case 56: return "diamond_ore"
	    case 57: return "diamond_block"
	    case 58: return "crafting_table"
	    case 60: return "farmland"
	    case 61: return "furnace"
	    case 62: return "lit_furnace"
	    case 73: return "redstone_ore"
	    case 74: return "lit_redstone_ore"
	    case 78: return "snow_layer"
	    case 79: return "ice"
	    case 80: return "snow"
	    case 82: return "clay"
	    case 86: return "pumpkin"
	    case 87: return "netherrack"
	    case 88: return "soul_sand"
	    case 89: return "glowstone"
	    case 91: return "jack_o_lantern"
	    case 92: return "cake"
	    case 95: return color + "stained_glass"
	    case 97: return "infested_stone"
	    case 98: return "stone_bricks"
	    case 99: return "brown_mushroom_block"
	    case 100: return "red_mushroom_block"
	    case 103: return "melon"
	    case 110: return "mycelium"
	    case 112: return "nether_brick"
	    case 121: return "end_stone"
	    case 123: return "redstone_lamp"
	    case 124: return "lit_redstone_lamp"
	    case 126: return "oak_slab"
	    case 129: return "emerald_ore"
	    case 133: return "emerald_block"
	    case 137: return "command_block"
	    case 138: return "beacon"
	    case 151: return "daylight_detector"
	    case 152: return "redstone_block"
	    case 153: return "quartz_ore"
	    case 155: return "quartz_block"
	    case 159: return color + "terracotta"
	    case 160: return color + "stained_glass_pane"
	    case 161: return "dark_oak_leaves"
	    case 162: return "dark_oak_log"
	    case 165: return "slime_block"
	    case 168: return "prismarine"
	    case 169: return "sea_lantern"
	    case 170: return "hay_block"
	    case 171: return color + "carpet"
	    case 172: return "terracotta"
	    case 173: return "coal_block"
	    case 174: return "packed_ice"
	    case 179: return "red_sandstone"
	    case 201: return "purpur_block"
	    case 202: return "purpur_pillar"
	    case 206: return "end_bricks"
	    case 208: return "grass_path"
	    case 210: return "repeating_command_block"
	    case 211: return "chain_command_block"
	    case 212: return "frosted_ice"
	    case 213: return "magma"
	    case 214: return "nether_wart_block"
	    case 215: return "red_nether_brick"
	    case 216: return "bone_block"
	    case 251: return color + "concrete"
	    case 252: return color + "concrete_powder"
	    case -316: return "heavy_core"
	    case -340: return "copper_block"
	    case -341: return "exposed_copper"
	    case -342: return "weathered_copper"
	    case -343: return "oxidized_copper"
	    case -344: return "waxed_copper_block"
	    case -345: return "waxed_exposed_copper"
	    case -346: return "waxed_weathered_copper"
	    case -446: return "waxed_oxidized_copper"
	}

	return ""



}
