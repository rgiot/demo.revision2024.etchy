
	include "etch_a_sketch.sym"
	
	NOEXPORT
	EXPORT LOAD_ADDRESS, ADDRESS, FRAME_ADDRESS, BINARY_LEN
	EXPORT crunched_data, crunched_frame, shrinkler_decrunch

LOAD_ADDRESS equ 0x1000 ; Address of the bootstrap code
ADDRESS equ BINARY_START 		; Address of the true 4k
FRAME_ADDRESS equ draw_frame

	; kill the system, uncompress the 4k and launch it
	org LOAD_ADDRESS
BOOTSTRAP_START

	ld hl, message
.loop
	ld a, (hl) : or a : jr z, .end
	inc hl
	call 0xbb5a
	jr .loop
	
.end


	; real code is in the header
	ld hl,(&BE7D) ; get amsdos buffer address
	ld de, 0x55 + 0x1c : add hl, de ; HL = address of the data & code in header
	jp hl 


crunched_frame
	LZSHRINKLER
		incbin "etch_frame.o"
	LZCLOSE

crunched_data
	LZSHRINKLER
		incbin "etch.o"
		incbin "etch_header.o"
	LZCLOSE

message 
	db 10,13
	db 15, 3 ; Set pen
	db 0x1f, 1, 20 ; Locate
	db "J VAIS PE-TELECRAN", 10, 13
	db "EXOCET - KRUSTY - TARGHAN", 10, 13
	db "REVISION 2024"
	db 0

deshrink_start
	include "deshrink.asm" ; nothing can be put after because of the buffer
deshrink_stop
	assert $+0x400<ADDRESS ; Remember there is a buffer there
BOOTSTRAP_END

BINARY_LEN equ BOOTSTRAP_END-BOOTSTRAP_START





	print "CRUNHED VERSION FROM ", {hex}BOOTSTRAP_START, " TO ", {hex}BOOTSTRAP_END, " FOR ", (BINARY_LEN)/1024, " Kbi"


	print "DESCHRINKLER ROUTINE SIZE", (deshrink_stop-deshrink_start)

	save "bootstrap.o", BOOTSTRAP_START, BOOTSTRAP_END-BOOTSTRAP_START
