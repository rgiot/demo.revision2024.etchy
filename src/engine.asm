;;
; Etch a sketch engine
;
	include once "config.asm"	
	include once "engine_macros.asm"



	print "EFFECT RESOLUTION IS ",  SCREEN_HORIZONTAL_SOLUTION, "x", SCREEN_VERTICAL_RESOLUTION

	assert SCREEN_VERTICAL_RESOLUTION < 256
	assert SCREEN_HORIZONTAL_SOLUTION < 256

NB_DRAWN_PER_FRAME equ 3
TRACE_SIZE equ 2
VIEWING_DURATION equ  50*5

PEN0 equ 0x40
PEN1 equ 0x46 ;0x4b ;;;
PEN2 equ 0x5c ;0x4c
PEN3 equ 0x54

       assert TRACE_SIZE <= NB_DRAWN_PER_FRAME
       assert TRACE_SIZE > 0



module engine




;;
; Does nothing during a while
state_wait


	if ENABLE_RASTERS
		HANDLE_RASTERS (void)
	endif


	ld bc, VIEWING_DURATION + 1
.wait_count equ $-2
	dec bc
	ld (.wait_count), bc
	
	ld a, b : cp c
	ret nz

	ld hl, state_shake
	ld (start.state_routine_address), hl
	ret

;;
; Hande the clearing of the picture
state_shake

	; slow down the shaking
	ld a, 1 : inc a : and 0b11 : ld (state_shake+1), a
	
	if SIMPLE_CLEAN
		 ret nz
	else
		jr nz, .remove_pixels
	endif

	ld hl, unaligned_data.shake_table
.table_address equ $-2
	ld a, (hl)
	or a : jr z, .restart
.continue 

	ld (start.horizontal_position_value_address), a
	inc hl : ld (.table_address), hl

	if SIMPLE_CLEAN

		ld hl, 0xc000
	.start_clean_address equ $-2
		ld de, hl : inc de
		ld (hl), 0
		ld bc, 0x800-1
		ldir
		inc hl
		ld (.start_clean_address), hl

	else

.remove_pixels

		ld hl, 0xc000
	.start_clean_address equ $-2
		ld c, 0b10101010
	.clean_mask equ $-1
		ld de, 0x200
.loop_clean
			ld a, c : and (hl) : ld (hl), a : inc hl
			dec de
			ld a, d : or e : jr nz, .loop_clean
		ld (.start_clean_address), hl

	endif

;	call draw_shadows

	ld hl, (.start_clean_address)
	ld a, h : or l : ret nz ; we have no yet browsed the whole image

	ld a, 0xc0 : ld (.start_clean_address+1), a ; ensure we start at the appropriate place (0xc000)

	ld a, (.clean_mask) : xor 255 : ld (.clean_mask), a ; change the clean mask
	cp 0b10101010 : ret nz ; we have not yet done the second pass
	
	jp select_new_picture

.restart
	ld hl, unaligned_data.shake_table
	ld (.table_address), hl
	ret


select_new_picture

	ld hl, unaligned_data.pictures
.restart
	if ENABLE_SPECIFIC_ACTION_AFTER_DRAWING
		ld c, (hl) : inc hl : ld b, (hl) : inc hl
		ld a, b : or c : jr nz, .continue
	else
		ld e, (hl) : inc hl : ld d, (hl) : inc hl
		ld a, e : or d : jr nz, .continue
	endif

	ld hl, unaligned_data.pictures
	jr .restart
.continue
	if ENABLE_SPECIFIC_ACTION_AFTER_DRAWING
		ld (compute_next_point.next_state), bc
		ld e, (hl) : inc hl : ld d, (hl) : inc hl
	endif
	ld (select_new_picture+1), hl

	ex de, hl
;	jp  prepare_new_picture moved just here

;;
; setp up the various variables to be able to start a new pic
; Input: 
;  -HL: address
prepare_new_picture
	ld (compute_next_point.picture_address), hl ; save the address of the picture

	; retore various flags
	ld a, 1
	ld (compute_next_point.first_flag), a
	if SELECTED_DATA_ENCODING != DATA_ENCODING3
		ld (compute_next_point.current_repetition_counter), a
	endif


	ld bc, VIEWING_DURATION + 1 : dec bc : ld (state_wait.wait_count), bc ; XXX extra opcodes for better  crunch !!!

	;ld hl, unaligned_data.shake_table : ld (state_shake.table_address), hl
	ld hl, state_drawing : ld (start.state_routine_address), hl
	ld hl, aligned_data.trace_buffer : ld (cover_previous_trace.buffer_pointer), hl : ld (store_current_point_in_trace.buffer_pointer), hl

	ld hl, aligned_data.trace_buffer : ld de, hl : inc de : ld bc, 256 : ld (hl), 0xff : ldir

	; allow to draw the trace
	xor a : ld (state_drawing.state_drawing_draw_trace_ret_opcode_address), a

	; restore shaker stuff
	ld a, 0x2e : ld (start.horizontal_position_value_address), a
	ld hl, 0xc000 : ld (state_shake.start_clean_address), hl
	ret

;;
; Handle the drawing of the picture
state_drawing

.state_drawing_recover_trace
	ld a, high(aligned_data.pixel_lut_pen3) : ld (plot_current_point.lut_for_pen), a
	call cover_previous_trace ; TODO remove this call and replace it by a macro


.state_drawing_draw_before_trace
	; using repeat reduce binary of 40 bytes !

	;ld b, NB_DRAWN_PER_FRAME - TRACE_SIZE
	repeat NB_DRAWN_PER_FRAME - TRACE_SIZE
;.pixels_loop1
;	push bc
		call compute_next_point ; TODO use only one call for both of them ?
		call plot_current_point
;	pop bc
;	djnz .pixels_loop1
	endr

.state_drawing_draw_trace
	nop
.state_drawing_draw_trace_ret_opcode_address equ $-1

	ld a, high(aligned_data.pixel_lut_pen1) : ld (plot_current_point.lut_for_pen), a
	;ld b, TRACE_SIZE
	repeat TRACE_SIZE
;.pixels_loop2
;	push bc
		call compute_next_point
		call plot_current_point
		call store_current_point_in_trace
;	pop bc
;	djnz .pixels_loop2
	endr
	ret


cover_previous_trace
.save_point_variables
       ld a, (unaligned_data.y) : push af
       ld a, (unaligned_data.x_byte_delta) : push af
       ld a, (unaligned_data.x_pixel_pos) : push af

       ld hl, aligned_data.trace_buffer
.buffer_pointer equ $-2

	
       ld b, TRACE_SIZE
.loop
       ld a, (hl) : cp 0xff : jr z, .finished

.erase_points_variables
		ld a, (hl) : ld (unaligned_data.y), a : inc l
		ld a, (hl) : ld (unaligned_data.x_byte_delta), a : inc l
		ld a, (hl) : ld (unaligned_data.x_pixel_pos), a : inc l

		push hl
			call plot_current_point
		pop hl

       djnz .loop

.finished 
	ld (.buffer_pointer), hl

.restore_point_variables
       pop af : ld (unaligned_data.x_pixel_pos), a
       pop af : ld (unaligned_data.x_byte_delta), a
       pop af : ld (unaligned_data.y), a



       ret

;;
; Store the current point information in the trace buffer
store_current_point_in_trace
		ld hl, aligned_data.trace_buffer
.buffer_pointer equ $-2
/*
		ld de, unaligned_data.y
		ld a, (de) : ld (hl), a : inc l : inc de : inc de
		ld a, (de) : ld (hl), a : inc l : inc de
		ld a, (de) : ld (hl), a : inc l : inc de
*/
       ld a, (unaligned_data.y) : ld (hl), a : inc l
       ld a, (unaligned_data.x_byte_delta) : ld (hl), a : inc l
       ld a, (unaligned_data.x_pixel_pos) : ld (hl), a : inc l
       ld (.buffer_pointer), hl

       ret




;;
; cmpute the coordinate of the next point
compute_next_point
	ld hl, 0xdead
.picture_address equ $-2

	ld a, 1 ; 1 for true, 0 for false
.first_flag equ $-1
	or a : jr z, .not_first

	; This is the first command, so we read the start position
.is_first
	; reset first flag
	xor a : ld (.first_flag), a 

	; get pixel horizontal position
	ld a, (hl) : ld (unaligned_data.x_pixel_pos), a
	inc hl

	; get screen horizontal byte delta
	ld a, (hl) : ld (unaligned_data.x_byte_delta), a
	inc hl

	; get vertical position
	ld a, (hl) : ld (unaligned_data.y), a
	inc hl

	ld (.picture_address), hl
	ret


	; This is not the first command, so either repreat the previous action, either read the next command
.not_first

	if SELECTED_DATA_ENCODING != DATA_ENCODING3

	ld a, 1 ; we want to be 
.current_repetition_counter equ $-1
	dec a
	or a : jr nz, .continue_same_movement

	endif

.read_next_movement
	ld a, (hl)
	or a : jp z, .finished

	; move in the data table
	inc hl : ld (.picture_address), hl

	; store the movement
	ld b, a
	if SELECTED_DATA_ENCODING == DATA_ENCODING1
		and 0b1111
	else if SELECTED_DATA_ENCODING == DATA_ENCODING2
		and 0b111
	else if SELECTED_DATA_ENCODING == DATA_ENCODING3
		; there is stricly nothing to do as only the movement is in the file !!
	else
		fail "unhandled case"
	endif
	ld (.movement), a

	; store the amount
	ld a, b
	if SELECTED_DATA_ENCODING == DATA_ENCODING1
		srl a : srl a : srl a : srl a
	else if SELECTED_DATA_ENCODING == DATA_ENCODING2
		srl a: srl a: srl a
	else if SELECTED_DATA_ENCODING == DATA_ENCODING3
		; no concept of repetition
	else
		fail "unhandled case"
	endif
	

	if SELECTED_DATA_ENCODING != DATA_ENCODING3
.continue_same_movement
	ld (.current_repetition_counter), a ; store the counter (either after decrement or because it is a new one)
	endif

	ld a, 0
.movement equ $-1
	if SELECTED_DATA_ENCODING == DATA_ENCODING1 || SELECTED_DATA_ENCODING == DATA_ENCODING3
		bit 0, a : call nz, .handle_up
		bit 1, a : call nz, .handle_down
		bit 2, a : call nz, .handle_left
		bit 3, a : call nz, .handle_right
	else if SELECTED_DATA_ENCODING == DATA_ENCODING2
		cp FLAG_UP : call z, .handle_up
		cp FLAG_UP_LEFT : call  z, .handle_up
		cp FLAG_UP_RIGHT : call z, .handle_up
		cp FLAG_DOWN : call z, .handle_down
		cp FLAG_DOWN_LEFT : call z, .handle_down
		cp FLAG_DOWN_RIGHT : call z, .handle_down
		cp FLAG_LEFT : call z, .handle_left
		cp FLAG_UP_LEFT : call z, .handle_left
		cp FLAG_DOWN_LEFT : call z, .handle_left
		cp FLAG_RIGHT : call z, .handle_right		
		cp FLAG_UP_RIGHT : call z, .handle_right		
		cp FLAG_DOWN_RIGHT : call z, .handle_right		
	else
		fail "unhandled case"
	endif
	ret
.finished
	; deactivate trace drawing (state wait does a bit of drawing)
	ld a, opcode(ret)
	ld (state_drawing.state_drawing_draw_trace_ret_opcode_address), a

	ld hl, state_wait
	if ENABLE_SPECIFIC_ACTION_AFTER_DRAWING
.next_state equ $-2
	endif
	ld (start.state_routine_address), hl
	ret

.handle_up
	exa
		ld a, (unaligned_data.y) ; get y position
		if ENGINE_HANDLE_VIEW_PORT
			or a : jr z, .handle_exit_common ; leave if impossible to decrease
		endif
		dec a : ld (unaligned_data.y), a ; store updated position
.handle_exit_common
	exa
	ret

.handle_down
	exa
		ld a, (unaligned_data.y) ; get y position
		if ENGINE_HANDLE_VIEW_PORT
			cp MAX_POS_Y : jr z, .handle_exit_common
		endif
		inc a : ld (unaligned_data.y), a
		jr .handle_exit_common

.handle_left
	exa
		ld a, (unaligned_data.x_pixel_pos)
		or a : jr z, .handle_left_previous_byte
.handle_left_previous_pixel
		dec a : ld (unaligned_data.x_pixel_pos), a
		jr .handle_exit_common
.handle_left_previous_byte
		ld a, (unaligned_data.x_byte_delta)
		if ENGINE_HANDLE_VIEW_PORT
			or a : jr z, .handle_exit_common ; no change can be done
		endif
.handle_left_previous_byte_possible
		dec a : ld (unaligned_data.x_byte_delta), a
		ld a, 3 : ld (unaligned_data.x_pixel_pos), a
		jr .handle_exit_common

.handle_right
	exa
		ld a, (unaligned_data.x_pixel_pos)
		cp 3 : jr z, .handle_right_next_byte
.handle_right_next_pixel
		inc a : ld (unaligned_data.x_pixel_pos), a
		jr .handle_exit_common
.handle_right_next_byte
		ld a, (unaligned_data.x_byte_delta)
		if ENGINE_HANDLE_VIEW_PORT
			CP MAX_POS_X_BYTE_RESOLUTION : jr z, .handle_exit_common ; no change can be done
		endif
.handle_right_next_byte_possible
		inc a : ld (unaligned_data.x_byte_delta), a
		xor a : ld (unaligned_data.x_pixel_pos), a
		jr .handle_exit_common

;;
; plot the current point (one pixel only) with selected ink
; Modified : HL, DE, B
plot_current_point
; get line address
	ld hl, (unaligned_data.y)
	ld e, (hl) : inc h : ld d, (hl)
; get column delta
	ld hl, (unaligned_data.x_byte_delta)
	add hl, de ; <= HL = screen address at the right byte
; get pixel position
	ld a, (unaligned_data.x_pixel_pos)
; mask the current byte to keep only the other pielx
	ld d, high(aligned_data.mask) 
	ld e, a
	ld a, (de) : and (hl) : ld (hl), a
; inject the new pixel
	ld d, high(aligned_data.pixel_lut_pen1)
.lut_for_pen equ $-1
	ld a, (de) ; get pixel value
	or (hl) : ld (hl), a ; merge it
	ret





endmodule

