
	NOEXPORT
	EXPORT LOAD_ADDRESS, ADDRESS, BINARY_LEN
	EXPORT crunched_data, shrinkler_decrunch

LOAD_ADDRESS equ 0x1000 ; Address of the bootstrap code
ADDRESS equ 0x4000 		; Address of the true 4k


	; kill the system, uncompress the 4k and launch it
	org LOAD_ADDRESS
BINARY_START


	; real code is in the header
	ld hl,(&BE7D) ; get amsdos buffer address
	ld de, 0x55 + 0x1c : add hl, de ; HL = address of the data & code in header
	jp hl 

crunched_data
	LZSHRINKLER
		incbin "etch.o"
		incbin "etch_header.o"
	LZCLOSE

deshrink_start
	include "inner://deshrink.asm" ; nothing can be put after because of the buffer
deshrink_stop
	assert $+0x400<ADDRESS ; Remember there is a buffer there
BINARY_END

BINARY_LEN equ BINARY_END-BINARY_START





	print "CRUNHED VERSION FROM ", {hex}BINARY_START, " TO ", {hex}BINARY_END, " FOR ", (BINARY_LEN)/1024, " Kbi"


	print "DESCHRINKLER ROUTINE SIZE", (deshrink_stop-deshrink_start)

	save "bootstrap.o", BINARY_START, BINARY_END-BINARY_START
