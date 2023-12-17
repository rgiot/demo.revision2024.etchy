	org 0x4000
	run $

BINARY_START

	di
		ld hl, 0xc9fb
		ld (0x38), hl
	ei

	call engine.init
	ld hl, test_picture : call engine.prepare_new_picture
	call engine.start
	jp $


	include "commands.asm"
	include "engine.asm"

test_picture
test_picture_start
	include "test_picture.asm"
test_picture_stop

	print "Memory dump of picture"
	repeat (test_picture_stop-test_picture_start), i, 0
		print {hex2}memory(test_picture + {i}), "/", {bin8}memory(test_picture + {i})
	rend

data
; Read a 16bits number here provides the address in the table for this vertical position
.y db 0 : assert SCREEN_VERTICAL_RESOLUTION < 256
	db high(.screen_addresses)
.x_pixel_pos db 0
	db 0
.x_byte_delta db 0
	db 0
	; 256 bytes for low byte of address followed by 256 bytes for hight byte of address
	align 256
.screen_addresses defs 256 + 256 ; TODO do not allocate when assembling
	align 256
.pixel_lut_pen1
.pixel0_pen1 db 0b10000000
.pixel1_pen1 db 0b01000000
.pixel2_pen1 db 0b00100000
.pixel3_pen1 db 0b00010000

BINARY_END


	print "UNCRUNHED VERSION FROM ", {hex}BINARY_START, " TO ", {hex}BINARY_END, " FOR ", (BINARY_END-BINARY_START)/1024, " Kbi"