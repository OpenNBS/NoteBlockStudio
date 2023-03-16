function macros() {
#macro gm_runtime_version "2022.6.1.40"
#macro version_date "2022.10.01"
#macro version "3.10.0"
#macro is_prerelease 0 // remember to change to 0 in the release!
#macro nbs_version 5
#macro pat_version 1

#macro link_github "https://github.com/OpenNBS/OpenNoteBlockStudio"
#macro link_report "https://github.com/OpenNBS/OpenNoteBlockStudio/issues/new/choose"
#macro link_releases "https://api.github.com/repos/OpenNBS/OpenNoteBlockStudio/releases"
#macro link_latest "https://api.github.com/repos/OpenNBS/OpenNoteBlockStudio/releases/latest"
#macro link_changelog "https://opennbs.org/changelog"
#macro link_website "https://opennbs.org/"
#macro link_discord "https://discord.gg/sKPGjyVcyy"

#macro file_directory		game_save_id
#macro data_directory		working_directory + "Data\\"
#macro sounds_directory		data_directory + "Sounds\\"
#macro songs_directory		working_directory + "Songs\\"
#macro pattern_directory	working_directory + "Patterns\\"
#macro log_file				file_directory + "log.txt"
#macro temp_file			file_directory + "tmp.file"
#macro update_file			file_directory + "Minecraft Note Block Studio Installer.exe"
#macro settings_file		file_directory + "settings.ini"
#macro settings_dev_file	file_directory + "settings_dev.ini"
#macro backup_file			file_directory + "backup.nbs"

#macro h_stereoize 12
#macro h_swaplayer 11
#macro h_removelayer 10
#macro h_addlayer 9
#macro h_select 8
#macro h_selectpaste 7
#macro h_selectmove 6
#macro h_selectchange 5
#macro h_selectremove 4
#macro h_selectadd 3
#macro h_changeblock 2
#macro h_removeblock 1
#macro h_addblock 0

#macro m_key 0
#macro m_vel 1
#macro m_pan 2
#macro m_pit 3

#macro w_menu 100
#macro w_releasemouse 29
#macro w_mididevices 28
#macro w_insbox 42
#macro w_dragvol 27
#macro w_dragstereo 41
#macro w_dragsection_end 26
#macro w_dragsection_start 25
#macro w_dragselection 24
#macro w_dragmarker 23
#macro w_dragtempo 22
#macro w_drag 21
#macro w_changelist 17
#macro w_update 16
#macro w_minecraft 15
#macro w_schematic_export 14
#macro w_branch_export 40
#macro w_datapack_export 30
#macro w_mp3_export 31
#macro w_checkupdates 13
#macro w_about 12
#macro w_songinfoedit 11
#macro w_songinfo 10
#macro w_midi_exp 9
#macro w_associate 8
#macro w_properties 7
#macro w_stats 6
#macro w_midi 5
#macro w_schematic 4
#macro w_instruments 3
#macro w_preferences 2
#macro w_greeting 1
#macro w_clip_editor 19
#macro w_stereo 20
#macro w_arpeggio 32
#macro w_tremolo 33
#macro w_stagger 34
#macro w_portamento 35
#macro w_saveoptions 36
#macro w_setvelocity 37
#macro w_setpanning 38
#macro w_setpitch 39
#macro w_settempo 43
#macro w_tempotapper 44
#macro w_setaccent 45
#macro w_track_export 46

#macro br "\r\n"

#macro c_dark 1644825

#macro font_main 0
#macro font_main_bold 1
#macro font_small 2
#macro font_small_bold 3
#macro font_info_big 4
#macro font_info_med 5
#macro font_info_med_bold 6
#macro font_med 7

#macro format_mp3 "MP3"
#macro format_wav "WAV"
#macro format_ogg "OGG"
#macro format_aiff "AIFF"
#macro format_flac "FLAC"

}
