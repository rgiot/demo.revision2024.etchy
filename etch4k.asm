
	if 0
		buildsna
		bankset 0
	endif
	
	org 0x1000
	RUN $

	BREAKPOINT

BINARY_START
ADDRESS equ 0x4000

	di
	ld hl, 0xc9fb : ld (0x38), hl
	ei
	ld ix, crunched_data
	ld de, ADDRESS
	call shrinkler_decrunch
	jp ADDRESS

crunched_data
	incbin "etch.shrink"
	include "./Shrinkler4.6NoParityContext/Z80/deshrink_np.asm"

	assert $<ADDRESS

BINARY_END

	print "CRUNHED VERSION FROM ", {hex}BINARY_START, " TO ", {hex}BINARY_END, " FOR ", (BINARY_END-BINARY_START)/1024, " Kbi"

