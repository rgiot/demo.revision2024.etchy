
	include "etch_a_sketch.sym"


	ENABLE_CROSSWORDS equ false
	
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
	ld b, 13
.loop
		ld a, (hl)
		inc hl
		call 0xbb5a
	djnz .loop


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




	if ENABLE_CROSSWORDS

message 
	db 0x1c, 3, 1, 1 ; color
	db 0x1c, 2, 1, 1 ; color
	db 15, 3  ; Set pen
	db 0x1f, 14, 5 
	db "T"
	db 10, 8 , "A"
	db 10, 8 , "R"
	db 10, 8 , "G"
	db 10, 8 , "H"
	db 0x1f, 14, 11; Locate
	db "N"

	db 0x1f, 19, 11, "X"
	db 10, 8, "O"
	db 10, 8, "C"
	db 10, 8, "E"
	db 10, 8, "T"

	db 0x1f, 23, 14, "KRUSTY"

	db 15, 2  ; Set pen

	db 0x1f, 11, 10, "J VAIS PE-TELECRAN"

	db 0x1f, 26, 11, "E"
	db 10, 8, "V"
	db 10, 8, "I"
	db 10, 8, "S"
	db 10, 8, "I"
	db 10, 8, "O"
	db 10, 8, "N"
	db 10
	db 10, 8, "2"
	db 10, 8, "0"
	db 10, 8, "2"
	db 10, 8, "4K"

   else
message 
	db 15, 3  ; Set pen
	db 0x1f, int((40-8)/2), 26/2, "DESHRINK"

   endif


;	db 10,13
;	db 15, 3 ; Set pen
;	db 0x1f, 1, 20 ; Locate
;	db "J VAIS PE-TELECRAN", 10, 13
;	db "EXOCET"
;	db 10
;	db "A"
;	db "KRUSTY", 10, 13
;	db "REVISION 2024"
	db 255

deshrink_start
	include "deshrink.asm" ; nothing can be put after because of the buffer
deshrink_stop
	assert $+0x400<ADDRESS ; Remember there is a buffer there
BOOTSTRAP_END

BINARY_LEN equ BOOTSTRAP_END-BOOTSTRAP_START





	print "CRUNHED VERSION FROM ", {hex}BOOTSTRAP_START, " TO ", {hex}BOOTSTRAP_END, " FOR ", (BINARY_LEN)/1024, " Kbi"


	print "DESCHRINKLER ROUTINE SIZE", (deshrink_stop-deshrink_start)

	save "bootstrap.o", BOOTSTRAP_START, BOOTSTRAP_END-BOOTSTRAP_START
