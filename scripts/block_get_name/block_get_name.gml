function block_get_name(argument0, argument1) {
	// block_get_name(val, data)
	// Returns the name of the block with the given value and data.

	var val, data, color;
	val = argument0
	data = argument1
	color = ""

	if (val = 35 || val = 95 || val = 159 || val = 160 || val = 171 || val = 172) {
	    switch (data) {
	        case 1: color = "Orange" break
	        case 2: color = "Magenta" break
	        case 3: color = "Light Blue" break
	        case 4: color = "Yellow" break
	        case 5: color = "Lime" break
	        case 6: color = "Pink" break
	        case 7: color = "Gray" break
	        case 8: color = "Light Gray" break
	        case 9: color = "Cyan" break
	        case 10: color = "Purple" break
	        case 11: color = "Blue" break
	        case 12: color = "Brown" break
	        case 13: color = "Green" break
	        case 14: color = "Red" break
	        case 15: color = "Black" break
	        default: color = "White" break
	    }
	}

	switch (val) {
	    case 0: return "Air"
	    case 1: return "Stone"
	    case 2: return "Grass Block"
	    case 3: return "Dirt"
	    case 4: return "Cobblestone"
	    case 5: return "Wood Planks"
	    case 7: return "Bedrock"
	    case 12: return "Sand"
	    case 13: return "Gravel"
	    case 14: return "Gold Ore"
	    case 15: return "Iron Ore"
	    case 16: return "Coal Ore"
	    case 17: return "Wood"
	    case 18: return "Leaves"
	    case 19: return "Sponge"
	    case 20: return "Glass"
	    case 21: return "Lapis Lazuli Ore"
	    case 22: return "Lapis Lazuli Block"
	    case 23: return "Dispenser"
	    case 24: return "Sandstone"
	    case 25: return "Note Block"
	    case 26: return "Bed"
	    case 27: return "Powered Rail"
	    case 28: return "Detector Rail"
	    case 29: return "Sticky Piston"
	    case 30: return "Cobweb"
	    case 33: return "Piston"
	    case 35: return color + " Wool"
	    case 41: return "Block of Gold"
	    case 42: return "Block of Iron"
	    case 45: return "Bricks"
	    case 46: return "TNT"
	    case 47: return "Bookshelf"
	    case 48: return "Moss stone"
	    case 49: return "Obsidian"
	    case 52: return "Monster Spawner"
	    case 54: return "Chest"
	    case 56: return "Diamond Ore"
	    case 57: return "Block of Diamond"
	    case 58: return "Crafting Table"
	    case 60: return "Farmland"
	    case 61: return "Furnace"
	    case 62: return "Burning Furnace"
	    case 73: return "Redstone Ore"
	    case 74: return "Glowing Redstone Ore"
	    case 78: return "Snow"
	    case 79: return "Ice"
	    case 80: return "Snow"
	    case 82: return "Clay"
	    case 86: return "Pumpkin"
	    case 87: return "Netherrack"
	    case 88: return "Soul Sand"
	    case 89: return "Glowstone"
	    case 91: return "Jack - o'Lantern"
	    case 92: return "Cake"
	    case 95: return color + " Stained Glass"
	    case 97: return "Monster Egg"
	    case 98: return "Stone Bricks"
	    case 99: return "Brown Mushroom"
	    case 100: return "Red Mushroom"
	    case 103: return "Melon"
	    case 110: return "Mycelium"
	    case 112: return "Nether Brick"
	    case 121: return "End Stone"
	    case 123: return "Redstone Lamp (inactive)"
	    case 124: return "Redstone Lamp (active)"
	    case 126: return "Wooden Slab"
	    case 129: return "Emerald Ore"
	    case 133: return "Block of Emerald"
	    case 137: return "Command Block"
	    case 138: return "Beacon"
	    case 151: return "Daylight Sensor"
	    case 152: return "Block of Redstone"
	    case 153: return "Nether Quartz Ore"
	    case 155: return "Block of Quartz"
	    case 159: return color + " Terracotta"
	    case 161: return "Leaves (Acacia / Dark Oak)"
	    case 162: return "Wood (Acacia / Dark Oak)"
	    case 165: return "Slime Block"
	    case 168: return "Prismarine"
	    case 169: return "Sea Lantern"
	    case 170: return "Hay Bale"
	    case 172: return "Terracotta"
	    case 173: return "Block of Coal"
	    case 174: return "Packed Ice"
	    case 179: return "Red Sandstone"
	    case 201: return "Purpur Block"
	    case 202: return "Purpur Pillar"
	    case 206: return "End Bricks"
	    case 208: return "Grass Path"
	    case 210: return "Repeating Command Block"
	    case 211: return "Chain Command Block"
	    case 212: return "Frosted Ice"
	    case 213: return "Magma Block"
	    case 214: return "Nether Wart Block"
	    case 215: return "Red Nether Brick"
	    case 216: return "Bone Block"
	    case 251: return "Concrete"
	    case 252: return "Concrete Powder"
	    case -316: return "Heavy Core"
	    case -340: return "Copper Block"
	    case -341: return "Exposed Copper Block"
	    case -342: return "Weathered Copper Block"
	    case -343: return "Oxidized Copper Block"
	    case -344: return "Waxed Copper Block"
	    case -345: return "Waxed Exposed Copper Block"
	    case -346: return "Waxed Weathered Copper Block"
	    case -446: return "Waxed Oxidized Copper Block"
	}

	return ""



}
