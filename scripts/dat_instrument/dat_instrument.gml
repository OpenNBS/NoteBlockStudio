function dat_instrument(argument0) {
	//dat_instrument()
	//returns right minecraft id

	var instrumentnumber = argument0
	var str = "minecraft:block.note_block."
	var ins
	if instrumentnumber < 16 {
		switch (instrumentnumber) {
		    case 0:
		        return str + "harp"
		    case 1:
		        return str + "bass"
			case 2:
				 return str + "basedrum"
			case 3:
				 return str + "snare"
			case 4:
				return str + "hat"
			case 5:
				return str + "guitar"
			case 6:
				return str + "flute"
			case 7:
				return str + "bell"
			case 8:
				return str + "chime"
			case 9:
				return str + "xylophone"	
			case 10:
				return str + "iron_xylophone"	
			case 11:
				return str + "cow_bell"	
			case 12:
				return str + "didgeridoo"	
			case 13:
				return str + "bit"	
			case 14:
				return str + "banjo"	
			case 15:
				return str + "pling"
		}
	}
	if instrumentnumber >= 16 {
		ins = ds_list_find_value(other.songs[other.song].instrument_list,instrumentnumber)
		return string("minecraft:"+ins.name)
	}


}
