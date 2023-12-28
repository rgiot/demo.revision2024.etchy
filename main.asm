	org 0x4000
	run $



	include "inner://crtc.asm"

BINARY_START

	di
		ld hl, 0xc9fb : ld (0x38), hl
		call engine.init
	ei
	ld sp, $

	
	call engine.select_new_picture
	jp engine.start

	include "commands.asm"
	include "engine.asm"

;	include "test_picture.asm"
picture1
	include "convert/small_connex.asm"
picture2
	include "convert/title.asm"
picture3
	include "convert/multiple.asm"

/*
	print "Memory dump of picture"
	repeat (test_picture_stop-test_picture_start), i, 0
		print {hex2}memory(test_picture + {i}), "/", {bin8}memory(test_picture + {i})
	rend
*/


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
	dw picture1
	dw picture2
	dw picture3
	dw 00
.backup_area defs 4
.shake_table
	db 0x2f, 0x2d, 0x2e, 0x2c, 0x30
	db 0x2e, 0 ; this last line must not change
.y db 0 : assert SCREEN_VERTICAL_RESOLUTION < 256
	db high(aligned_data.screen_addresses)
.x_pixel_pos equ $  ;1
.x_byte_delta equ $ + 1 ;1
BINARY_END



aligned_data equ ($+4+1+1+2+256) & 0xff00
.mask equ aligned_data + 0*256
.pixel_lut_pen1 equ aligned_data + 1*256
.pixel_lut_pen3 equ aligned_data + 2*256
.screen_addresses equ aligned_data + 3*256
.trace_buffer equ aligned_data + 5*256
VERY_LASTE_BYTE equ aligned_data + 6*256


	print "UNCRUNHED VERSION FROM ", {hex}BINARY_START, " TO ", {hex}BINARY_END, " FOR ", (BINARY_END-BINARY_START)/1024, " Kbi"


	assert VERY_LASTE_BYTE< 0x8000, "0x8000 area is supposed to contains uncrunched data"




	SAVE "etch.o", BINARY_START, BINARY_END-BINARY_START