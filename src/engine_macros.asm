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
	BREAKPOINT
	xor a
	ld hl, music_data
	call PLY_AKM_Init

	;call engine.draw_shadows

endm


macro ENGINE_DRAW_CORNERS
if ENABLE_ROUND_CORNERS
	if False
		; top left
		ld bc, 0b00111100*256 + 0b01111000
		ld hl, SCREEN_MEMORY_ADDRESS : ld (hl), b
		ld hl, SCREEN_MEMORY_ADDRESS + 0x800 : ld (hl), c

		; bottom left
		ld bc, 0b00001100*256 + 0b00001000
		ld hl, SCREEN_MEMORY_ADDRESS + 24*80 + 7*0x800 : ld (hl), b
		ld hl, SCREEN_MEMORY_ADDRESS + 24*80 + 6*0x800 : ld (hl), c

		; top right
		ld bc, 0b11000011*256 + 0b11100001
		ld hl, SCREEN_MEMORY_ADDRESS + 79 : ld (hl), b
		ld hl, SCREEN_MEMORY_ADDRESS + 79 + 0x800 : ld (hl), c

		; bottom right
		ld bc, 0b11000011*256 + 0b11100001
		ld hl, SCREEN_MEMORY_ADDRESS + 24*80 + 7*0x800 + 79 : ld (hl), b
		ld hl, SCREEN_MEMORY_ADDRESS + 24*80 + 6*0x800 + 79 : ld (hl), c
	else
		ld de, 0x800	


		; bottom left
		ld bc, 0b00001100*256 + 0b00001000
		ld hl, SCREEN_MEMORY_ADDRESS + 24*80 + 6*0x800 : ld (hl), c
		add hl, de : ld (hl), b

		; top left
		ld bc, 0b00111100*256 + 0b01111000
		ld hl, SCREEN_MEMORY_ADDRESS : ld (hl), b
		add hl, de : ld (hl), c

		; top right
		ld bc, 0b11000011*256 + 0b11100001
		ld hl, SCREEN_MEMORY_ADDRESS + 79 : ld (hl), b
		add hl, de : ld (hl), c


		; bottom right
		;ld bc, 0b11000011*256 + 0b11100001
		ld hl, SCREEN_MEMORY_ADDRESS + 24*80 + 6*0x800 + 79 : ld (hl), c
		add hl, de : ld (hl), b
	endif

endif
endm

macro ENGINE_DRAW_SHADOW

	if SHADOW_IN_GREY
		SHADOW1 = 0b00001010; + 0b01010101
		SHADOW2 = 0b00000101; + 0b10101010 
	else if SHADOW_IN_PEN_COLOR
		SHADOW1 = 0b11110000
		SHADOW2 = 0b11110000
	else
		SHADOW1 = 0b00001010 + 0b01010101
		SHADOW2 = 0b00000101 + 0b10101010 
	endif

	; horizontal shadow
	ld a, SHADOW1  ; red/black
	ld hl, SCREEN_MEMORY_ADDRESS ;+ 24*80 + 6*0x800
	ld de, hl : inc de
	ld bc, 80-1
	ld (hl), a
	ldir
	
	if ENABLE_DOUBLE_SHADOW
		if SHADOW_IN_GREY
			ld a, SHADOW2  ; black/red rra failed :()
		else if !SHADOW_IN_PEN_COLOR
			ld a, SHADOW2  ; black/red
		endif
		ld hl, SCREEN_MEMORY_ADDRESS	+ 0x800 ; + 24*80 + 6*0x800
		ld de, hl : inc de
		ld bc, 80-1
		ld (hl), a
		ldir


		if SHADOW_IN_PEN_COLOR ; we double it
			ld hl, SCREEN_MEMORY_ADDRESS	+ 0x800 ;+ 24*80 + 4*0x800 
			ld de, hl : inc de
			ld bc, 80-1
			ld (hl), a
			ldir
			ld hl, SCREEN_MEMORY_ADDRESS	+ 0x800 + 0x800 ;24*80 + 3*0x800 
			ld de, hl : inc de
			ld bc, 80-1
			ld (hl), a
		ldir

		endif

	endif
	


	; vertical shadow
	if ENABLE_DOUBLE_SHADOW
		if SHADOW_IN_GREY
			SHADOW1 = 0b00000010 + 0b00000000
			SHADOW2 = 0b00000001 + 0b00000000
		else if SHADOW_IN_PEN_COLOR
			SHAWDOW1 = 00110000
			SHAWDOW1 = 00110000
		else
			SHADOW1 = 0b00000010 + 0b00010001
			SHADOW2 = 0b00000001 + 0b00100010
		endif

		if ENABLE_ROUND_CORNERS
			ld b, 25*8/2 - 1 - 2
			ld hl, SCREEN_MEMORY_ADDRESS + 80-1 + 0x800 + 0x800 + 0x800
		else
			ld b, 25*8/2 - 1 
			ld hl, SCREEN_MEMORY_ADDRESS + 80-1 ;+ 0x800 ;+ 0x800
		endif
	else
		SHADOW1 = 0b00000001
		SHADOW2 = 0b00010001
		ld b, 25*8/2 - 1
		ld hl, SCREEN_MEMORY_ADDRESS + 80-1 ;+ 0x800
	endif


	ld de, 0xc050 
.shadow_loop
			ld a, SHADOW1 : ld (hl), a
			ld a,8 
			add h 
			ld h,a 
			jr nc, .endbc261
			add hl,de
.endbc261			

			ld a, SHADOW2  : ld (hl), a
			ld a,8 
			add h 
			ld h,a 
			jr nc, .endbc262
			add hl,de
.endbc262			
	djnz .shadow_loop

	/*
			 ld a, SHADOW1 : ld (de), a

	if ENABLE_DOUBLE_SHADOW
				 			ex de, hl 

				ld a,8 
				add h 
				ld h,a 
				jr nc, .endbc263
				ld bc,#c050
				add hl,bc 
.endbc263			
			 ex de, hl

			 ld a, SHADOW2 : ld (de), a

	endif
*/



	ENGINE_DRAW_CORNERS (void)

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


	call draw_frame

	call engine.state_shake ;engine.state_drawing
.state_routine_address equ $-2
	call PLY_AKM_Play ; XXX no interrupt must happens but the whole 4k disable interrupts




	jp .frame_loop
endm