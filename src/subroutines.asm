wait_for_vblank:
    bit PPU_STATUS ; read PPU status register
    bpl wait_for_vblank ; loop until vblank flag is set

    rts ; return from subroutine

read_joystick: ; https://www.nesdev.org/wiki/Controller_reading_code#Basic_Example
    lda #1 ; controller port latch bit
    sta JOY1 ; send value to controller port

    sta controls ; store accumulator in controls

    lsr ; reset accumulator
    sta JOY1 ; send value to controller port

    read_joystick_loop:
        lda JOY1 ; read value from controller port

        lsr ; shift value right to get next button state
        rol controls ; rotate bits left in controls

        bcc read_joystick_loop ; loop until all button states have been read

    rts ; return from subroutine

random: ; https://www.nesdev.org/wiki/Random_number_generator#Simple
    lda #8 ; iteration count (generates 8 bits)
    sta temp ; store value in variable

	lda seed ; low byte of seed
:
	asl ; arithmetic shift left low byte of seed

	rol seed + 1 ; rotate high byte of seed left
	bcc :+ ; jump to next part if bit 7 is 0

	eor #$39 ; apply XOR feedback whenever 1 bit is shifted out
:
	dec temp ; decrement iteration count
	bne :-- ; loop until 8 bits have been generated

	sta seed ; store low byte of new seed
	cmp #0 ; reload flags

	rts ; return from subroutine

is_colliding:
    ; stary.x + stary.w >= ogien.x
    lda OAM_BUFFER + 3 ; load X position of stary
    clc ; clear carry flag
    adc #24 ; add width of stary to X position

    cmp OAM_BUFFER + 3, x ; compare with X position of ogien
    bcc :+ ; if stary's right edge is left of ogien's left edge, no collision

    ; stary.y + stary.h >= ogien.y
    lda OAM_BUFFER ; load Y position of stary
    clc ; clear carry flag
    adc #16 ; add height of stary to Y position

    cmp OAM_BUFFER, x ; compare with Y position of ogien
    bcc :+ ; if stary's bottom edge is above ogien's top edge, no collision

    ; ogien.x + ogien.w >= stary.x
    lda OAM_BUFFER + 3, x ; load X position of ogien
    clc ; clear carry flag
    adc #8 ; add width of ogien to X position

    cmp OAM_BUFFER + 3 ; compare with X position of stary
    bcc :+ ; if ogien's right edge is left of stary's left edge, no collision

    ; ogien.y + ogien.h >= stary.y
    lda OAM_BUFFER, x ; load Y position of ogien
    clc ; clear carry flag
    adc #16 ; add height of ogien to Y position

    cmp OAM_BUFFER ; compare with Y position of stary
    bcc :+ ; if ogien's bottom edge is above stary's top edge, no collision

    sec ; set carry flag to indicate collision
:
    rts ; return from subroutine