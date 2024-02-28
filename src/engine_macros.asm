;;
; Initialize the various tables and variables needed for the project
macro ENGINE_INIT
	if !LINKED_VERSION
			ld bc, 0x7f10 : ld hl, PEN0*256 + PEN2
			xor a
			out (c), c : out (c), l
			out (c), a : out (c), h
	endif


.copy_data_in_aligned_area
	ld hl, toalign_data
	ld de, aligned_data.mask : ld bc, 4 : ldir
	ld de, aligned_data.pixel_lut_pen1 : ld bc, 4 : ldir
	ld de, aligned_data.pixel_lut_pen3 : ld bc, 4 : ldir
	
.init_screen_table
	ld de, SCREEN_MEMORY_ADDRESS
	if !LINKED_VERSION
		push de ; <============================== save
	endif
	ld hl, aligned_data.screen_addresses
	; ld b, 256 XXX b is already 0 = 256
.init_screen_table_loop
		push bc
			ld (hl), e : inc h : ld (hl), d : dec h : inc l
			ex de, hl 

				ld a,8 
				add h 
				ld h,a 
				jr nc, .endbc26
				ld bc,#c050
				add hl,bc 
.endbc26			
			 ex de, hl
		pop bc
	djnz .init_screen_table_loop

	; TODO remove if already done by system
.clear_screen
	;ld hl, SCREEN_MEMORY_ADDRESS : 
	if !LINKED_VERSION
		pop hl ; ==============================> restore
		ld de, hl : inc de
		ld bc, 0x4000-1
		ld (hl), 0
		ldir
	endif

.select_screen
	if !LINKED_VERSION
		ld hl, SCREEN_CRTC_ADDRESS
		ld bc, 0xbc00 + 12
		out (c), c : inc b: out (c), h : dec b : inc c
		out (c), c : inc b: out (c), l
	endif

.init_music
	xor a
	ld hl, music_data
	call PLY_AKM_Init

	call engine.draw_shadows

endm



macro ENGINE_MAIN

start
.frame_loop
	ld b, 0xf5
.vsync_loop
	in a, (c)
	rra : jr nc, .vsync_loop


;; no compensation because we are in the vbl
.set_horizontal_position
	ld bc, 0xbc00 + CRTC_REG_HORIZONTAL_SYNC_POSITION
	ld a,  0x2e
.horizontal_position_value_address equ $-1
	out (c), c : inc b : out (c), a


.set_color
		ld bc, 0x7f00
		ld hl, PEN0*256 + PEN1
		out (c), c: out (c), h : inc c
		out (c), c: out (c), l : inc c
		ld hl, PEN2*256+PEN3
		out (c), c: out (c), h : inc c
		out (c), c: out (c), l

	call engine.state_drawing
.state_routine_address equ $-2
	call PLY_AKM_Play ; XXX no interrupt must happens but the whole 4k disable interrupts



	jr .frame_loop
endm