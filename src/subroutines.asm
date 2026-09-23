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

init_sprites:
    ; copy stary sprite data to OAM buffer
    ldx #0 ; offset for sprite data

    init_sprites_copy:
        lda sprite_data, x ; load byte of sprite data
        sta OAM_BUFFER, x ; store value in OAM buffer

        inx ; increment offset

        cpx #12 ; check if all bytes of sprite data have been sent
        bne init_sprites_copy ; loop if not done

    ; clear remaining OAM buffer space
    init_sprites_clear:
        lda #$ff ; value to mark sprite as not in use
        sta OAM_BUFFER, x ; store value in OAM buffer

        inx ; increment offset

        cpx #64 ; check if all bytes of OAM buffer have been cleared
        bne init_sprites_clear ; loop if not done

    ; copy OAM buffer to PPU
    lda #0 ; OAM destination address
    sta OAM_ADDR ; send value to OAM address register

    lda #>OAM_BUFFER ; page number
    sta OAM_DMA ; send value to OAM DMA register

    rts ; return from subroutine