	ifndef BASM
		BUILDSNA
		BANKSET 0
	endif

	org 0x4000
	run $


	ld hl, 0xc9fb : ld (0x38), hl
	xor a
	ld hl, music_data
	call PLY_AKM_Init
loop
	ld b, 0xf5 : in a, (c) : rra : jr nc, $-3

	di
	call PLY_AKM_Play
	ei : nop
	halt
	jp loop


PLY_AKM_HARDWARE_CPC = 1
;PLY_AKM_MANAGE_SOUND_EFFECTS = 1

	;include "krocket2_akm_playerconfig.asm"
	include "lookool_akm_playerconfig.asm"
music_data
	include "lookool_akm.asm"
	;include "krocket2_akm.asm"
music_player
	ifdef BASM
		include "PlayerAkm_basm.asm"
	else
		include "PlayerAkm_original.asm"
	endif

	assert PLY_AKM_USE_HOOKS == 0
	assert PLY_AKM_STOP_SOUNDS == 0