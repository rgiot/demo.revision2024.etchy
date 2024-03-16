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
	include "Lookool_playerconfig.asm"
Music
music_data
	include "Lookool.asm"
MusicEnd
	;include "krocket2_akm.asm"
Player
music_player
	ifdef BASM
		print "INCLUDE BASM MODIFIED PLAYER"
		include "PlayerAkm_basm.asm"
	else
		print "INCLUDE RASM ORIGINAL PLAYER"
		include "PlayerAkm.asm"
	endif
PlayerEnd
	assert PLY_AKM_USE_HOOKS == 0
	assert PLY_AKM_STOP_SOUNDS == 0


        print "Music: ", {hex}(Music)
        print "Player: ", {hex}(Player)
        print "End: ", {hex}(PlayerEnd)
        print "Size of music: ", {hex}(MusicEnd - Music)
        print "Size of player: ", {hex}(PlayerEnd - Player)
        IFDEF PLY_AKM_Rom
                print "Size of ROM buffer: ", {hex}(PLY_AKM_ROM_BufferSize)
        ENDIF
        print "Total: ", {hex}((PlayerEnd - Player) + (MusicEnd - Music))
