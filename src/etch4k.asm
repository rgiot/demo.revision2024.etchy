
	include "bootstrap.sym"
	include "etch_a_sketch.sym"


;;
; forge the header manually to include some data outside of the main binary content
; See:
; - https://thecheshirec.at/2023/10/23/mettre-du-code-dans-un-header-amdos/ 
; - https://www.cpcwiki.eu/index.php/AMSDOS_Memory_Map
; - https://www.cpcwiki.eu/index.php?title=AMSDOS_Header
; - https://www.pouet.net/prod.php?which=96142

PEN0 equ 0x40
PEN1 equ 0x4b
PEN2 equ 0x4c
PEN3 equ 0x54

	org 0x0000
BINARY_START

AMSDOS_HEADER
; Standard expected content
	org 0x00 : .user 	: db 0
	org 0x01 : .fname 	: db "ETCH4K  "
	org 0x09 : .ext 	: db "   "
	org 0x12 : .ftype 	: db 2
	org 0x13 : .buffer	: dw 0x4000  ; Am I really supposed to do that ?
	org 0x15 : .load 	: dw LOAD_ADDRESS
	org 0x17 : .first   : db 0xff    ; I am pretty sure it is useless. to set it up or not does not fix the bug
	org 0x18 : .len1 	: dw BINARY_LEN
	org 0x1a : .entry 	: dw LOAD_ADDRESS

; First area of usefull content
; Here, we include the code that uncompresses everything
	org 0x1c : .free1

	; XXX here we have no idea of PC value
	; Kill the system
	di
	ld sp, 0x4000
	ld hl, 0xc9fb : ld (0x38), hl

	; Do some init
	ld bc, 0x7f10 : ld hl, PEN0*256 + PEN2
	xor a
	out (c), c : out (c), l
	out (c), a : out (c), h


	; Install the demo code
	ld ix, crunched_data 	; the real content of the file, outside of the header
	ld de, ADDRESS 			; the address where the demo is loaded
	push de ; put ADDRESS on the stack; it will be used as a return of shrinkler decrunch
	jp shrinkler_decrunch ; the uncruncher is in the real content of the file

	assert $<=0x40
.remaining1 = 0x40-$
	PRINT "THERE ARE ", .remaining1, " REMAINING BYTES in header"


	org 0x40 : .len2 	: dw BINARY_LEN : db 0
	
	; Compute the checksum of the start of the header
.CHECKSUM = 0
	.ADR = 0
	while .ADR < 0x43
		.CHECKSUM = (.CHECKSUM + peek(.ADR)) AND 0xffff
		.ADR += 1
	wend
.check 	org 0x43 : dw .CHECKSUM

	print 'CHECKSUM value: ', {hex}.CHECKSUM


;  :( sadly this seems to not be available

; Extra available data
	org 0x46 : .free2
	; include compressed data (here we only earn 1 byte ...)
;	incshrinkler "etch_header.o"

	defb "LOST DATA - LOST DATA - LOST DATA - "
	defb "LOST DATA - LOST DATA"

	print {hex}$
	assert $<=128

.remaining2 = 128-$
	PRINT "THERE ARE ", .remaining1, " + ", .remaining2, " REMAINING BYTES in header"

	defs 128-$ ; Ensure 128 bytes are taken

	assert $ == 128

AMSDOS_FILE_CONTENT
	incbin "bootstrap.o"
BINARY_END



	PRINT "FINAL SIZE", $
	PRINT "REMAINING BYTES: ", 4*1024-$


	; 1946