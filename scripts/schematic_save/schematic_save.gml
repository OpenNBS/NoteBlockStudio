function schematic_save(argument0, argument1) {
	// schematic_save(id, filename)
	//  id          Schematic to save
	//  filename    Direct or relative path to new .schematic file

	// Saves the given schematic into a .schematic file.
	// Will overwrite the file if it exists.
	// Schematic file format:
	//      https://minecraft.wiki/w/Schematic

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com

	var sch, filen;
	sch = argument0;
	filen = argument1;

	var file, a, b, c, d, t;
	//file = external_call(global.dll_OpenFileWrite, "temp");
	file = buffer_create(8, buffer_grow, 1)
	var c = 0
	// Write NBT tags
	nbt_tag_compound(file, "Schematic") {
	    nbt_tag_short(file, "Length", sch.xsize);
	    nbt_tag_short(file, "Width", sch.ysize);
	    nbt_tag_short(file, "Height", sch.zsize);
	    nbt_tag_string(file, "Materials", "Alpha");
	    nbt_tag_list(file, "Entities", 10, 0);
	    nbt_tag_list(file, "TileEntities", 10, sch_exp_totalnoteblocks);
		var d = 0
		for (a = 0; a < sch_exp_polyphony; a ++) {
			for (b = 0; b <= sch_exp_range_end - sch_exp_range_start; b ++) {
				if nblocknote[a, b] != 0 {
					nbt_tag_string(file, "id", "minecraft:noteblock")
					nbt_tag_int(file, "x", noteblockx[a, b])
					nbt_tag_int(file, "y", noteblocky[a, b])
					nbt_tag_int(file, "z", noteblockz[a, b])
					nbt_tag_byte(file, "note", nblockkey[a, b])
					nbt_tag_end(file)
					d++
				}
			}
		} 
		log("Total NBT TileEntity groups = " + string(d))
	    nbt_tag_byte_array(file, "Blocks", sch.xsize * sch.ysize * sch.zsize) {
	        for (c = 0; c < sch.zsize; c += 1) {
	            for (a = 0; a < sch.xsize; a += 1) {
	                for (b = sch.ysize - 1; b >= 0; b -= 1) {
	                    t = a * sch.xysize * sch.zsize + b + c * sch.xysize;
	                    buffer_write(file, buffer_s8, sch.block[t div sch.dsize, t mod sch.dsize]);
	                }
	            }
	        }
	    }
	    nbt_tag_byte_array(file, "Data", sch.xsize * sch.ysize * sch.zsize) {
	        for (c = 0; c < sch.zsize; c += 1) {
	            for (a = 0; a < sch.xsize; a += 1) {
	                for (b = sch.ysize - 1; b >= 0; b -= 1) {
	                    t = a * sch.xysize * sch.zsize + b + c * sch.xysize;
	                    buffer_write(file, buffer_s8, sch.data[t div sch.dsize, t mod sch.dsize]);
	                }
	            }
	        }
	    }
	    nbt_tag_end(file);
	}
	//external_call(global.dll_CloseFile, file);
	buffer_save(file, temp_file)
	log ("buffer size " + string(buffer_get_size(file)))
	buffer_delete(file)

	// Compress using Gzip and clean up
	gzzip(temp_file, filen)
	file_delete(temp_file);


}
