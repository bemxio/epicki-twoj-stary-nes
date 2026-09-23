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