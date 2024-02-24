DATA_ENCODING1 equ 1 ; 4 bits for the length and 4 bits for the directions (1 per directions)
DATA_ENCODING2 equ 2 ; 5 bits for the length and 3 bits for the direction (u, d, l, r, ul, ur, dl, dr) <= default one
DATA_ENCODING3 equ 3 ; 4 bits lost; 4 bits for direction1


SELECTED_DATA_ENCODING equ DATA_ENCODING3

if SELECTED_DATA_ENCODING = DATA_ENCODING1 || SELECTED_DATA_ENCODING = DATA_ENCODING3
	FLAG_UP 	equ 0b0001
	FLAG_DOWN 	equ 0b0010
	FLAG_LEFT	equ 0b0100
	FLAG_RIGHT 	equ 0b1000

	FLAG_UP_LEFT equ FLAG_UP + FLAG_LEFT
	FLAG_UP_RIGHT equ FLAG_UP + FLAG_RIGHT
	FLAG_DOWN_LEFT equ FLAG_DOWN + FLAG_LEFT
	FLAG_DOWN_RIGHT equ FLAG_DOWN + FLAG_RIGHT

	IMPOSSIBLE_COMMANDS equ [0xb0000, 0xb0011, 0xb1100] ; Thes combinations are not possible at all a,nd could serve for something else
	MAX_COUNT_COMMANDS equ 0b1111 // only 4 bits are used to store the amount
else if SELECTED_DATA_ENCODING == DATA_ENCODING2
	FLAG_ENCODING = 0
	FLAG_UP setn FLAG_ENCODING
	FLAG_DOWN next FLAG_ENCODING
	FLAG_LEFT next FLAG_ENCODING
	FLAG_RIGHT next FLAG_ENCODING
	FLAG_UP_RIGHT next FLAG_ENCODING
	FLAG_UP_LEFT next FLAG_ENCODING
	FLAG_DOWN_RIGHT next FLAG_ENCODING
	FLAG_DOWN_LEFT next FLAG_ENCODING
	assert FLAG_UP == 0
	assert FLAG_DOWN_LEFT == 7

	IMPOSSIBLE_COMMANDS equ []
	MAX_COUNT_COMMANDS equ 0b11111 // only 5 bits are used to store the amount
else
	FAIL SELECTED_DATA_ENCODING, " is  not taken into account"
endif


function FLAG_TO_STR flag
	if {flag} == FLAG_UP
		return "UP"
	else if {flag} == FLAG_DOWN
		return "DOWN"
	else if {flag} == FLAG_LEFT
		return "LEFT"
	else if {flag} == FLAG_RIGHT
		return "RIGHT"

	else if {flag} == FLAG_UP_RIGHT
		return "UP+RIGHT"
	else if {flag} == FLAG_UP_LEFT
		return "UP+LEFT"
	else if {flag} == FLAG_DOWN_RIGHT
		return "DOWN+RIGHT"
	else if {flag} == FLAG_DOWN_LEFT
		return "DOWN+LEFT"
	else 
		FAIL  "ERROR in FLAG_TO_STR"
	endif
endfunction


MAX_POS_X_BYTE_RESOLUTION = 80-1
MAX_POS_X_PIXEL_RESOLUTION = 320 - 1
MAX_POS_Y = 200-1



;;
; State machine for the plotter
STATE_PREVIOUS_COMMAND = 0
STATE_PREVIOUS_COMMAND_COUNT = 0
STATE_POS_X = 0
STATE_POS_Y = 0
STATE_NB_BYTES = 0

;;
; The user expects the command encoded by `cmd`.
; Here we check if it is similar than the previous one and aggreagtate it or if it is new and we have to release the buffer
macro EXPECT_COMMAND cmd
	if STATE_PREVIOUS_COMMAND_COUNT == 0
		; nothing to do as it is the very first command
	else
		if STATE_PREVIOUS_COMMAND != {cmd} || STATE_PREVIOUS_COMMAND_COUNT == MAX_COUNT_COMMANDS
			EMIT_PREVIOUS_COMMAND (void)
		endif
		
	endif
	STATE_PREVIOUS_COMMAND_COUNT += 1
	STATE_PREVIOUS_COMMAND = {cmd}

	switch {cmd}
		case FLAG_UP 
			STATE_POS_Y -= 1
			CMD_REPR = "UP"
			break
		case FLAG_DOWN
			STATE_POS_Y +=1
			CMD_REPR = "DOWN"
			break
		case FLAG_LEFT
			STATE_POS_X -=1
			CMD_REPR = "LEFT"
			break
		case FLAG_RIGHT
			STATE_POS_X +=1
			CMD_REPR = "RIGHT"
			break
	endswitch

	if STATE_POS_Y < 0
		STATE_POS_Y = 0
		print "[WARNING] Pen Y is out of field and cap to 0"
	endif
	if STATE_POS_X < 0
		STATE_POS_X = 0
		print "[WARNING] Pen X is out of field and cap to 0"
	endif

	if STATE_POS_Y > MAX_POS_Y
		STATE_POS_Y = MAX_POS_Y
		print "[WARNING] Pen Y is out of field and cap to ", MAX_POS_Y
	endif
	if STATE_POS_X > MAX_POS_X_PIXEL_RESOLUTION
		STATE_POS_X = MAX_POS_X_PIXEL_RESOLUTION
		print "[WARNING] Pen X is out of field and cap to ", MAX_POS_X_PIXEL_RESOLUTION
	endif

	print CMD_REPR, " => (", STATE_POS_X, ", ", STATE_POS_Y, ")"
endm


;;
; Really emit the data for the previous command.
; In the final version we can choose to implement various ways and keep the one that compress the best
macro EMIT_PREVIOUS_COMMAND
	assert STATE_PREVIOUS_COMMAND_COUNT > 0
	
	if SELECTED_DATA_ENCODING == DATA_ENCODING1
		EMIT_PREVIOUS_COMMAND_ONE_BYTE_REPETITION_AND_COMMAND1 (void)
	else if SELECTED_DATA_ENCODING == DATA_ENCODING2
		EMIT_PREVIOUS_COMMAND_ONE_BYTE_REPETITION_AND_COMMAND2 (void)
	else if SELECTED_DATA_ENCODING == DATA_ENCODING3
		EMIT_PREVIOUS_COMMAND_ONE_BYTE_SEVERAL_TIMES (void)
	else
		fail "case not handled"
	endif
	
	STATE_PREVIOUS_COMMAND_COUNT = 0
endm


;;
; aaaabbbb
; aaaa encodes the repetition
; bbbb encodes the command (one bit to activate a direction)
macro EMIT_PREVIOUS_COMMAND_ONE_BYTE_REPETITION_AND_COMMAND1
	print "EMIT ", FLAG_TO_STR(STATE_PREVIOUS_COMMAND), " ", STATE_PREVIOUS_COMMAND_COUNT, " times"
	assert STATE_PREVIOUS_COMMAND < 16
	db (STATE_PREVIOUS_COMMAND_COUNT << 4) + STATE_PREVIOUS_COMMAND
endm


macro EMIT_PREVIOUS_COMMAND_ONE_BYTE_SEVERAL_TIMES
	repeat STATE_PREVIOUS_COMMAND_COUNT
		db STATE_PREVIOUS_COMMAND
	rend
endm

;;
; aaaaabbb
; aaaaa encodes the repetition
; bbb encodes the command (8 possibilities)
macro EMIT_PREVIOUS_COMMAND_ONE_BYTE_REPETITION_AND_COMMAND2
	print "EMIT ", FLAG_TO_STR(STATE_PREVIOUS_COMMAND), " ", STATE_PREVIOUS_COMMAND_COUNT, " times"
	assert STATE_PREVIOUS_COMMAND < 8
	db (STATE_PREVIOUS_COMMAND_COUNT << 3) + STATE_PREVIOUS_COMMAND
endm

macro EXPECT_COMMAND_N_TIMES cmd, n
	repeat {n}
		EXPECT_COMMAND {cmd}
	rend
endm

macro U amount
	EXPECT_COMMAND_N_TIMES FLAG_UP, {amount}
endm
macro D amount
	EXPECT_COMMAND_N_TIMES FLAG_DOWN, {amount}
endm
macro L amount
	EXPECT_COMMAND_N_TIMES FLAG_LEFT, {amount}
endm
macro R amount
	EXPECT_COMMAND_N_TIMES FLAG_RIGHT, {amount}
endm

macro UL amount
	EXPECT_COMMAND_N_TIMES FLAG_UP_LEFT, {amount}
endm
macro UR amount
	EXPECT_COMMAND_N_TIMES FLAG_UP_RIGHT, {amount}
endm

macro DL amount
	EXPECT_COMMAND_N_TIMES FLAG_DOWN_LEFT, {amount}
endm
macro DR amount
	EXPECT_COMMAND_N_TIMES FLAG_DOWN_RIGHT, {amount}
endm


macro LU amount
	UL {amount}
endm
macro RU amount
	UR {amount}
endm
/* This one is completly invalid
macro LD amount
	DL {amount}
endm
*/
macro RD amount
	DR {amount}
endm


;;
; Setup the start position of the beam
macro START x, y

	STATE_POS_X = {x}
	STATE_POS_Y = {y}
	STATE_START_ADDRESS = $

	// We have 4 pixels per byte.
	// To avoid 16bits real time computation, the covnersion is alrady done (same data space/let code space)
@POSX_BYTE = STATE_POS_X >> 2
@POSX_PIXEL = STATE_POS_X & 0b11

	db @POSX_PIXEL
	db @POSX_BYTE : assert @POSX_BYTE < 256
	db STATE_POS_Y : assert STATE_POS_Y < 256

	print "START at ({x}, {y}) => {@POSX_BYTE} ", @POSX_BYTE, "{@POSX_PIXEL} ", @POSX_PIXEL

endm

;;
; Ensure the latest commands are generated
macro STOP

	if STATE_PREVIOUS_COMMAND_COUNT != 0
		EMIT_PREVIOUS_COMMAND (void)
	endif
	db 0

	STATE_STOP_ADDRESS = $
	STATE_NB_BYTES = STATE_STOP_ADDRESS - STATE_START_ADDRESS

	assert STATE_NB_BYTES < 0x4000, "The allocated buffer of 0x4000 for the uncrunched image is too small for ", STATE_NB_BYTES, " bytes of commands"

	print "Image generated in ", STATE_NB_BYTES, " bytes"
endm