;;
; Krusty / Exocet / Targhan / 2024	
	

	include once "config.asm"


	if LINKED_VERSION
		NOEXPORT
		EXPORT DATA_MOVED_IN_HEADER_START
		EXPORT PEN0, PEN1, PEN2, PEN3
		EXPORT draw_frame, BINARY_START, embedded_boostrap_init
	endif

; Set to true when not generated alone


	include "inner://crtc.asm"
	include once "engine_macros.asm"


	org 0x4000
	run BINARY_START


FRAME_START
draw_frame
	ENGINE_DRAW_SHADOW (void)
	ret

embedded_boostrap_init



	ld bc, 0x7f10 
	ld hl, PEN2*256+PEN3
	out (c), c: out (c), h 
	ld c, 0x00 + 3: 
	out (c), c: out (c), l : dec c
	out (c), c: out (c), h : dec c

	ld hl, PEN0*256 + PEN1
	out (c), c: out (c), l : dec c
	out (c), c: out (c), h

	jp draw_frame
FRAME_END




BINARY_START

	if LINKED_VERSION
		ENGINE_INIT (void)
		ld bc, 0x7f00 : out (c), c : ld a, PEN0 : out (c), a
	else
		di
			ld hl, 0xc9fb : ld (0x38), hl
			ENGINE_INIT (void)
			call embedded_boostrap_init
		ld sp, $
	endif

	
	call engine.select_new_picture
	ld hl, engine.state_shake : ld (start.state_routine_address), hl ; ensure we start by cleaning screen
	ENGINE_MAIN (void)

	include "music.asm"
	include "commands.asm"
	include "engine.asm"

;	ASMCONTROLENV SET_MAX_NB_OF_PASSES=1 // :( sadly it make the system crash ...)
;picture1
;	incbin "small_connex.o"
;picture2
;	incbin "title.o"
;picture3
;	incbin "multiple.o"

;croco:
;	incbin "croco1.o"
;stonks:
	;incbin "stonks1.o"
revision: incbin "revision_logo.o"
baston: incbin "baston_multiple.o"
;baston1: incbin "baston_multiple_0.o"
;baston2: incbin "baston_multiple_1.o"
;baston3: incbin "baston_multiple_2.o"
;	ENDASMCONTROLENV

/*
	print "Memory dump of picture"
	repeat (test_picture_stop-test_picture_start), i, 0
		print {hex2}memory(test_picture + {i}), "/", {bin8}memory(test_picture + {i})
	rend
*/
BINARY_END


DATA_MOVED_IN_HEADER_START

toalign_data
.mask
	db 0b01110111
	db 0b10111011
	db 0b11011101
	db 0b11101110
.pixel_lut_pen1
.pixel0_pen1 db 0b10000000
.pixel1_pen1 db 0b01000000
.pixel2_pen1 db 0b00100000
.pixel3_pen1 db 0b00010000
.pixel_lut_pen3
.pixel0_pen3 db 0b10001000
.pixel1_pen3 db 0b01000100
.pixel2_pen3 db 0b00100010
.pixel3_pen3 db 0b00010001

unaligned_data
.pictures
	; routine to call after drawing : drawing data

	if ENABLE_SPECIFIC_ACTION_AFTER_DRAWING
		dw engine.state_wait : dw revision


		; Individaully display the three parts
		dw engine.state_wait : dw baston1
		dw engine.state_wait : dw baston2
		dw engine.state_wait : dw baston3

		dw engine.state_wait : dw revision

		; Display in fill length
		dw engine.select_new_picture : dw baston1
		dw engine.select_new_picture : dw baston2
		dw engine.state_wait : dw baston3	
	else
		dw baston
		dw revision
	endif
	dw 00

.backup_area defs 4
.shake_table
	db 0x2f, 0x2d, 0x2e, 0x2c, 0x30
	db 0x2e, 0 ; this last line must not change
.y db 0 : assert SCREEN_VERTICAL_RESOLUTION < 256
	db high(aligned_data.screen_addresses)
.x_pixel_pos equ $  ;1
.x_byte_delta equ $ + 1 ;1

if ENABLE_RASTERS

.rasters_table
	defs RASTERS_HEIGHT, 0x54
endif
DATA_END


	assert DATA_END-DATA_MOVED_IN_HEADER_START < 90, "Too many data to fit in the AMSDOS header"


aligned_data equ ($+4+1+1+2+256) & 0xff00
aligned_data.mask equ aligned_data + 0*256
aligned_data.pixel_lut_pen1 equ aligned_data + 1*256
aligned_data.pixel_lut_pen3 equ aligned_data + 2*256
aligned_data.screen_addresses equ aligned_data + 3*256
aligned_data.trace_buffer equ aligned_data + 5*256
VERY_LASTE_BYTE equ aligned_data + 6*256


	print "UNCRUNHED VERSION FROM ", {hex}BINARY_START, " TO ", {hex}BINARY_END, " FOR ", (BINARY_END-BINARY_START)/1024, " Kbi"

	print "HEADER DATA LENGTH ", DATA_END-DATA_MOVED_IN_HEADER_START

	assert VERY_LASTE_BYTE< 0x8000, "0x8000 area is supposed to contains uncrunched data"




	if LINKED_VERSION
		SAVE "etch.o", BINARY_START, BINARY_END-BINARY_START ; Here data are missing, they will be included within the header. As well as frame drawing
		SAVE "etch_frame.o", FRAME_START, FRAME_END-FRAME_START ; Frame drawing code
		SAVE "etch_header.o", DATA_MOVED_IN_HEADER_START, DATA_END-DATA_MOVED_IN_HEADER_START ; Data that are included within the header
	else
		SAVE "ETCH.BIN", FRAME_START, DATA_END-FRAME_START, AMSDOS ; Here we save a file that contains everything and works properly
		SAVE "ETCH.BIN", FRAME_START, DATA_END-FRAME_START, DSK, "etch.dsk" ; Here we save a file that contains everything and works properly
	endif