PLY_AKM_HARDWARE_CPC = 1
;PLY_AKM_MANAGE_SOUND_EFFECTS = 1

	;include "./music/krocket2_akm_playerconfig.asm"
	include "./music/Lookool_playerconfig.asm"
music_data
	;include "./music/krocket2_akm.asm"
	;include "./music/lookool2_akm.asm"
	include "./music/Lookool.asm"
music_data_stop
music_player
	include "./music/PlayerAkm_basm.asm"
music_player_stop
	assert PLY_AKM_USE_HOOKS == 0
	assert PLY_AKM_STOP_SOUNDS == 0

	;FAIL "Need to try various players and select the best one after compression"



	print "MUSIC DATA: ", {hex}music_data, "-", {hex}music_data_stop
	print "MUSIC CODE: ", {hex}music_player, "-", {hex}music_player_stop


