PLY_AKM_HARDWARE_CPC = 1
;PLY_AKM_MANAGE_SOUND_EFFECTS = 1

	;include "./music/krocket2_akm_playerconfig.asm"
	include "./music/lookool2_akm_playerconfig.asm"
music_data
	;include "./music/krocket2_akm.asm"
	include "./music/lookool2_akm.asm"
music_player
	include "./music/PlayerAkm_basm.asm"

	assert PLY_AKM_USE_HOOKS == 0
	assert PLY_AKM_STOP_SOUNDS == 0

	;FAIL "Need to try various players and select the best one after compression"