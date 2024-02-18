;;
; Etch a sketch engine
;

SCREEN_VERTICAL_RESOLUTION equ 25*8
SCREEN_HORIZONTAL_SOLUTION equ 40*4

SCREEN_MEMORY_ADDRESS equ 0xc000
SCREEN_CRTC_ADDRESS equ 0x3000

	print "EFFECT RESOLUTION IS ",  SCREEN_HORIZONTAL_SOLUTION, "x", SCREEN_VERTICAL_RESOLUTION

	assert SCREEN_VERTICAL_RESOLUTION < 256
	assert SCREEN_HORIZONTAL_SOLUTION < 256

NB_DRAWN_PER_FRAME equ 6
TRACE_SIZE equ 3
VIEWING_DURATION equ 5 ; 50*5

PEN0 equ 0x40
PEN1 equ 0x4b
PEN2 equ 0x4c
PEN3 equ 0x54

       assert TRACE_SIZE <= NB_DRAWN_PER_FRAME
       assert TRACE_SIZE > 0



module engine

start
.frame_loop
	ld b, 0xf5
.vsync_loop
	in a, (c)
	rra : jr nc, .vsync_loop


;; no compensation because we are in the vbl
.set_horizontal_position
	ld bc, 0xbc00 + CRTC_REG_HORIZONTAL_SYNC_POSITION
	ld a,  0x2e
.horizontal_position_value_address equ $-1
	out (c), c : inc b : out (c), a

.set_color
	ld bc, 0x7f00 : ld hl, PEN0*256 + PEN1 : ld de, PEN2*256+PEN3
	out (c), c: out (c), h : inc c
	out (c), c: out (c), l : inc c
	out (c), c: out (c), d : inc c
	out (c), c: out (c), e


	halt : halt
	ld bc, 0x7f10 : out (c), c : ld bc, 0x7f4b : out (c), c
	call state_drawing
.state_routine_address equ $-2
	ld bc, 0x7f10 : out (c), c : ld bc, 0x7f00 + PEN2 : out (c), c


	jp .frame_loop



;;
; Does nothing during a while
state_wait
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
	ld a, 1 : inc a : and 0b11 : ld (state_shake+1), a : ret nz

	ld hl, unaligned_data.shake_table
.table_address equ $-2
	ld a, (hl)
	or a : jr z, .restart
.continue 

	ld (start.horizontal_position_value_address), a
	inc hl : ld (.table_address), hl


	ld hl, 0xc000
.start_clean_address equ $-2
	ld de, hl : inc de
	ld (hl), 0
	ld bc, 0x800-1
	ldir
	inc hl
	ld (.start_clean_address), hl

	ld a, h : or l : ret nz

	call select_new_picture


	ret
.restart
	ld hl, unaligned_data.shake_table
	ld (.table_address), hl
	ret


select_new_picture
	ld hl, unaligned_data.pictures
.restart
	ld e, (hl) : inc hl : ld d, (hl) : inc hl
	ld (select_new_picture+1), hl

	ld a, d : or e : jr nz, .continue
	ld hl, unaligned_data.pictures
	jr .restart
.continue

	ex de, hl
	call prepare_new_picture
	ret


;;
; Handle the drawing of the picture
state_drawing
.state_drawing_recover_trace
	ld a, high(aligned_data.pixel_lut_pen3) : ld (plot_current_point.lut_for_pen), a
	call cover_previous_trace


.state_drawing_draw_before_trace
	; using repeat reduce binary of 40 bytes !

	;ld b, NB_DRAWN_PER_FRAME - TRACE_SIZE
	repeat NB_DRAWN_PER_FRAME - TRACE_SIZE
;.pixels_loop1
;	push bc
		call compute_next_point
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
; setp up the various variables to be able to start a new pic
; Input: 
;  -HL: address
prepare_new_picture
	ld (compute_next_point.picture_address), hl ; save the address of the picture

	; retore various flags
	ld a, 1
	ld (compute_next_point.first_flag), a
	ld (compute_next_point.current_repetition_counter), a


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

	ld a, 1 ; we want to be 
.current_repetition_counter equ $-1
	dec a
	or a : jr nz, .continue_same_movement

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
	else
		fail "unhandled case"
	endif
	
.continue_same_movement
	ld (.current_repetition_counter), a ; store the counter (either after decrement or because it is a new one)


	ld a, 0
.movement equ $-1
	if SELECTED_DATA_ENCODING == DATA_ENCODING1
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
	ld (start.state_routine_address), hl
	ret

.handle_up
	exa
		ld a, (unaligned_data.y) ; get y position
		or a : jr z, .handle_exit_common ; leave if impossible to decrease
		dec a : ld (unaligned_data.y), a ; store updated position
.handle_exit_common
	exa
	ret

.handle_down
	exa
		ld a, (unaligned_data.y) ; get y position
		cp MAX_POS_Y : jr z, .handle_exit_common
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
		or a : jr z, .handle_exit_common ; no change can be done
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
		CP MAX_POS_X_BYTE_RESOLUTION : jr z, .handle_exit_common ; no change can be done
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


;;
; Initialize the various tables and variables needed for the project
init
.copy_data_in_aligned_area
	ld hl, toalign_data
	ld de, aligned_data.mask : ld bc, 4 : ldir
	ld de, aligned_data.pixel_lut_pen1 : ld bc, 4 : ldir
	ld de, aligned_data.pixel_lut_pen3 : ld bc, 4 : ldir
	
.init_screen_table
	ld de, SCREEN_MEMORY_ADDRESS
	ld hl, aligned_data.screen_addresses
	; ld b, 256 XXX b is already 0 = 256
.init_screen_table_loop
		push bc
			ld (hl), e : inc h : ld (hl), d : dec h : inc l
			ex de, hl 

				ld a,8 
				add h 
				ld h,a 
				jr nc, .endbc26
				ld bc,#c050
				add hl,bc 
.endbc26			
			 ex de, hl
		pop bc
	djnz .init_screen_table_loop

	; TODO remove if already done by system
.clear_screen
	ld hl, SCREEN_MEMORY_ADDRESS : ld de, hl : inc de
	ld bc, 0x4000-1
	ld (hl), 0
	ldir

.select_screen
	ld hl, SCREEN_CRTC_ADDRESS
	ld bc, 0xbc00 + 12
	out (c), c : inc b: out (c), h : dec b : inc c
	out (c), c : inc b: out (c), l

	ret



endmodule

