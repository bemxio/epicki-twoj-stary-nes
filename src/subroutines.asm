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