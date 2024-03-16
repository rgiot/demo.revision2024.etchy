        ;Uncomment this to build a SNApshot, handy for testing (RASM feature).
        buildsna
        bankset 0

        org #100

        di
        ld hl,#c9fb
        ld (#38),hl
        ld sp,#38

        ld hl,Music
        xor a
        ;ld a,1
        call PLY_AKM_Init

        ;Puts some markers to see the CPU.
        ;ld a,255
        ;ld hl,#c000 + 5 * #50
        ;ld (hl),a
        ;ld hl,#c000 + 6 * #50
        ;ld (hl),a
        ;ld hl,#c000 + 7 * #50
        ;ld (hl),a
        ;ld hl,#c000 + 8 * #50
        ;ld (hl),a
        ;ld hl,#c000 + 9 * #50
        ;ld (hl),a
        ;ld hl,#c000 + 10 * #50
        ;ld (hl),a

Sync:   ld b,#f5
        in a,(c)
        rra
        jr nc,Sync + 2

        ei
        nop
        halt
        halt

        ;If 25 hz.
        ;halt
        ;halt
        ;halt
        ;halt
        ;halt
        ;halt

FrameCounter: ld hl,0
        ld de,32
        or a
        sbc hl,de
        jr nz,FC_Not
        nop
FC_Not:
        ld hl,(FrameCounter + 1)
        inc hl
        ld (FrameCounter + 1),hl

        di

        ld b,90
        djnz $

        ld bc,#7f10
        out (c),c
        ld a,#4b
        out (c),a

        call PLY_AKM_Play

        ld bc,#7f10
        out (c),c
        ld a,#55
        out (c),a
        ei
        nop
        halt
        di
        ld a,#54
        out (c),a

        jr Sync



        org #413f
Music:

        include "Lookool.asm"
        include "Lookool_playerconfig.asm"

        ;include "testMusic/Bactron.asm"

MusicEnd:


        ;org #c000
Player:
        ;PLY_AKM_Rom = 1
        PLY_AKM_ROM_Buffer = #c000
        ;PLY_AKM_ROM_Buffer = #a000


        include "PlayerAkm.asm"
PlayerEnd:

        print "Music: ", {hex}(Music)
        print "Player: ", {hex}(Player)
        print "End: ", {hex}(PlayerEnd)
        print "Size of music: ", {hex}(MusicEnd - Music)
        print "Size of player: ", {hex}(PlayerEnd - Player)
        IFDEF PLY_AKM_Rom
                print "Size of ROM buffer: ", {hex}(PLY_AKM_ROM_BufferSize)
        ENDIF
        print "Total: ", {hex}((PlayerEnd - Player) + (MusicEnd - Music))
