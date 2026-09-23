wait_for_vblank:
    bit PPU_STATUS ; read PPU status register
    bpl wait_for_vblank ; loop until vblank flag is set

    rts ; return from subroutine