function schematic_start() {
	// schematic_start()

	// Initializes DLLs. Must be called in a game start before using any other schematic functions.

	// By David "Davve" Norgren for GMschematic - www.stuffbydavid.com
	
	if (os_type == os_windows) {

		global.path_gmbinfile = bundled_data_directory + "gmbinaryfile.dll";

		// All of this seems to be replacable with buffer_read or buffer_write scripts / GMS2 stuff. Will replace later.
		// Note: Already replaced

		global.dll_OpenFileRead = external_define(global.path_gmbinfile, "GMBINOpenFileRead", dll_stdcall, ty_real, 1, ty_string);
		global.dll_OpenFileWrite = external_define(global.path_gmbinfile, "GMBINOpenFileWrite", dll_stdcall, ty_real, 1, ty_string);
		global.dll_CloseFile = external_define(global.path_gmbinfile, "GMBINCloseFile", dll_stdcall, ty_real, 1, ty_real);
		global.dll_GetPosition = external_define(global.path_gmbinfile, "GMBINGetPosition", dll_stdcall, ty_real, 1, ty_real);
		global.dll_SetPosition = external_define(global.path_gmbinfile, "GMBINSetPosition", dll_stdcall, ty_real, 2, ty_real, ty_real);
		global.dll_ReadByte = external_define(global.path_gmbinfile, "GMBINReadByte", dll_stdcall, ty_real, 1, ty_real);
		global.dll_ReadUByte = external_define(global.path_gmbinfile, "GMBINReadUByte", dll_stdcall, ty_real, 1, ty_real);
		global.dll_ReadShort = external_define(global.path_gmbinfile, "GMBINReadShortBE", dll_stdcall, ty_real, 1, ty_real);
		global.dll_ReadInt = external_define(global.path_gmbinfile, "GMBINReadIntBE", dll_stdcall, ty_real, 1, ty_real);
		global.dll_ReadFloat = external_define(global.path_gmbinfile, "GMBINReadFloatBE", dll_stdcall, ty_real, 1, ty_real);
		global.dll_ReadDouble = external_define(global.path_gmbinfile, "GMBINReadDoubleBE", dll_stdcall, ty_real, 1, ty_real);
		global.dll_WriteByte = external_define(global.path_gmbinfile, "GMBINWriteByte", dll_stdcall, ty_real, 2, ty_real, ty_real);
		global.dll_WriteInt = external_define(global.path_gmbinfile, "GMBINWriteIntBE", dll_stdcall, ty_real, 2, ty_real, ty_real);
		global.dll_WriteShort = external_define(global.path_gmbinfile, "GMBINWriteShortBE", dll_stdcall, ty_real, 2, ty_real, ty_real);
		global.dll_WriteFloat = external_define(global.path_gmbinfile, "GMBINWriteFloatBE", dll_stdcall, ty_real, 2, ty_real, ty_real);
		global.dll_WriteDouble = external_define(global.path_gmbinfile, "GMBINWriteDoubleBE", dll_stdcall, ty_real, 2, ty_real, ty_real);

	}

}
