; constants
.include "constants.asm"

; segments
.segment "HEADER"
    .byte "NES", $1a ; identification string
    .byte 16 ; size of PRG-ROM in 16K units
    .byte 0 ; size of CHR-ROM in 8K units (CHR-RAM)

    ; iNES Mapper 1 (MMC1, more specifically SGROM)
    .byte %00010000 ; lower nibble of mapper, mirroring, battery, trainer
    .byte %00000000 ; upper nibble of mapper, VS/Playchoice, NES 2.0

    .byte 0 ; PRG-RAM size
    .byte 0 ; TV system (0 = NTSC, 1 = PAL)
    .byte 0 ; TV system, PRG-RAM presence, bus conflicts
    .byte "siema" ; padding

.segment "ZEROPAGE"
    vblank: .res 1 ; vblank flag
    controls: .res 1 ; state of controller buttons
    seed: .res 2 ; seed for random number generation

    sample_address: .res 1 ; address of sample data in 64-byte pages
    bank_index: .res 1 ; index of current bank for sample data

    temp: .res 2 ; temporary variable

.segment "CODE"
    ; interrupt handlers
    on_reset:
        sei ; disable interrupts
        cld ; disable decimal mode

        ; disable APU IRQs
        lda #%01000000 ; mode 0 (4-step), IRQ inhibit flag enabled
        sta APU_FRAME_COUNTER ; send value to APU frame counter

        ; initalize stack pointer
        ldx #$ff ; stack address
        txs ; transfer value to stack pointer

        ; disable NMI, rendering, and DMC IRQs
        lda #0 ; value to send to appropriate registers

        sta PPU_CTRL ; send value to PPU control register
        sta PPU_MASK ; send value to PPU mask register
        sta APU_DMC ; send value to APU DMC

        bit PPU_STATUS ; clear vblank flag
        jsr wait_for_vblank ; wait for vblank to ensure PPU is ready

        ; clear internal RAM
        ldx #0 ; offset for RAM

        clear_memory:
            lda #0 ; value to clear RAM with

            sta $0000, x ; zero page
            sta $0100, x ; stack page
            ;sta $0200, x
            sta $0300, x
            sta $0400, x
            sta $0500, x
            sta $0600, x
            sta $0700, x

            lda #$ff ; needed to not display garbage
            sta OAM_BUFFER, x ; OAM buffer

            inx ; increment offset
            bne clear_memory ; loop if not done

        jsr wait_for_vblank ; wait for vblank to ensure PPU is ready

        ; copy background data to PPU
        lda PPU_STATUS ; reset address latch

        lda #<background_data ; low byte of background data address
        sta temp ; store value in temporary variable

        lda #>background_data ; high byte of background data address
        sta temp + 1 ; store value in temporary variable

        lda #$20 ; high byte of background data address in PPU memory
        sta PPU_ADDR ; send value to PPU address register

        lda #$00 ; low byte of address
        sta PPU_ADDR ; send value to PPU address register

        ldx #4 ; number of pages of background data
        ldy #0 ; offset for background data

        copy_background:
            lda (temp), y ; load byte of background data
            sta PPU_DATA ; send value to PPU data register

            iny ; increment offset
            bne copy_background ; loop if not done

            inc temp + 1 ; increment high byte of background data address

            dex ; decrement number of pages of background data
            bne copy_background ; loop if not done

        ; copy tile data to PPU
        lda PPU_STATUS ; reset address latch

        lda #<tile_data ; low byte of tile data address
        sta temp ; store value in temporary variable

        lda #>tile_data ; high byte of tile data address
        sta temp + 1 ; store value in temporary variable

        ldx #32 ; number of pages of tile data
        ldy #0 ; offset for tile data

        sty PPU_ADDR ; set low byte of PPU memory address
        sty PPU_ADDR ; set high byte of PPU memory address

        copy_tiles:
            lda (temp), y ; load byte of tile data
            sta PPU_DATA ; send value to PPU data register

            iny ; increment offset
            bne copy_tiles ; loop if not done

            inc temp + 1 ; increment high byte of tile data address

            dex ; decrement number of pages of tile data
            bne copy_tiles ; loop if not done

        ; copy palette data to PPU
        lda PPU_STATUS ; reset address latch

        lda #$3f ; high byte of palette data address in PPU memory
        sta PPU_ADDR ; send value to PPU address register

        lda #$00 ; low byte of address
        sta PPU_ADDR ; send value to PPU address register

        ldx #0 ; offset for palette data

        load_palettes:
            lda palette_data, x ; load byte of palette data
            sta PPU_DATA ; send value to PPU data register

            inx ; increment offset

            cpx #32 ; check if all bytes of palette data have been sent
            bne load_palettes ; loop if not done

        jsr reset_scroll ; reset scroll position

        ; enable interrupts
        cli

        ; set up NMI
        lda #%10110000 ; enable NMI on vblank, 8x16 sprite size, $1000 as background pattern table address
        sta PPU_CTRL ; send value to PPU control register

        ; show sprites and background
        lda #%00011110 ; enable background and sprite rendering, show both in leftmost 8 pixels
        sta PPU_MASK ; send value to PPU mask register

        ; initialize MMC1
        lda #$80 ; reset MMC1 shift register
        sta MMC1_CTRL ; send value to MMC1 control register

        lda #%01000 ; fixed first PRG-ROM bank, horizontal mirroring
        sta MMC1_CTRL ; send first bit to MMC1 control register

        .repeat 4 ; repeat 4 times to send remaining bits
            lsr a ; shift accumulator right to get next bit
            sta MMC1_CTRL ; send next bit to MMC1 control register
        .endrep

        ; set up APU
        lda #%10001000 ; IRQ enabled, loop disabled, ~9.42 kHz sample rate
        sta APU_DMC ; send value to APU DMC register

        lda #0 ; address of sample data in 64-byte pages
        sta APU_DMC + 2 ; send value to APU DMC register

        lda #$ff ; length of sample data in 16-byte units
        sta APU_DMC + 3 ; send value to APU DMC register

        ; switch to first bank of sample data
        inc bank_index ; increment bank index
        jsr switch_bank ; switch to next bank of sample data

        ; start playing first sample
        lda #%00010000 ; enable DMC channel
        sta APU_STATUS ; send value to APU status register

        ; title screen loop
        title_screen_loop:
            bit vblank ; check if vblank flag is set
            bpl title_screen_loop ; if not, loop

            ; increment seed
            clc ; clear carry flag

            lda seed ; load low byte of seed
            adc #1 ; increment low byte of seed
            sta seed ; store low byte of new seed

            lda seed + 1 ; load high byte of seed
            adc #0 ; add carry from low byte increment
            sta seed + 1 ; store high byte of new seed

            ; unset vblank flag
            lda #0 ; value for vblank flag
            sta vblank ; store value into variable

            jsr read_joystick_safe ; read controller input

            ; check if any button is pressed
            lda controls ; load controller state to accumulator
            beq title_screen_loop ; if no button is pressed, loop

            ; temporarily disable rendering
            lda #0 ; clear accumulator
            sta PPU_MASK ; send value to PPU mask register

            ; clear background memory
            lda PPU_STATUS ; reset address latch

            lda #$20 ; high byte of background data address in PPU memory
            sta PPU_ADDR ; send value to PPU address register

            lda #$00 ; low byte of address
            sta PPU_ADDR ; send value to PPU address register

            ldx #4 ; number of pages to clear
            ldy #0 ; offset for background memory

            clear_background:
                sta PPU_DATA ; send value to PPU data register

                iny ; increment offset
                bne clear_background ; loop if not done

                dex ; decrement number of pages to clear
                bne clear_background ; loop if not done

            jsr reset_scroll ; reset scroll position

            ; re-enable rendering
            lda #%00011110 ; enable background and sprite rendering, show both in leftmost 8 pixels
            sta PPU_MASK ; send value to PPU mask register

            jsr init_sprites ; initialize sprites

        ; gameplay loop
        gameplay_loop:
            bit vblank ; check if vblank flag is set
            bpl gameplay_loop ; if not, loop

            jsr read_joystick_safe ; read controller input

            ; right button check
            controller_check_right:
                lda controls ; load controller state to accumulator

                and #%00000001 ; check if button is pressed
                beq controller_check_left ; jump if it is not

                lda OAM_BUFFER + 3 ; load X position of stary to accumulator

                cmp #$e8 ; check if stary is at right edge of screen
                beq controller_check_left ; jump if true

                ; increment X position of stary
                .repeat STARY_SPEED
                    inc OAM_BUFFER + 3 ; first sprite
                    inc OAM_BUFFER + 7 ; second sprite
                    inc OAM_BUFFER + 11 ; third sprite
                .endrep

            ; left button check
            controller_check_left:
                lda controls ; load controller state to accumulator

                and #%00000010 ; check if button is pressed
                beq controller_check_down ; jump if it is not

                lda OAM_BUFFER + 3 ; load X position of stary to accumulator

                cmp #$00 ; check if stary is at left edge of screen
                beq controller_check_down ; jump if true

                ; decrement X position of stary
                .repeat STARY_SPEED
                    dec OAM_BUFFER + 3 ; first sprite
                    dec OAM_BUFFER + 7 ; second sprite
                    dec OAM_BUFFER + 11 ; third sprite
                .endrep

            ; down button check
            controller_check_down:
                lda controls ; load controller state to accumulator

                and #%00000100 ; check if button is pressed
                beq controller_check_up ; jump if it is not

                lda OAM_BUFFER ; load Y position of stary to accumulator

                cmp #$d8 ; check if stary is at bottom edge of screen
                beq controller_check_up ; jump if true

                ; increment Y position of stary
                .repeat STARY_SPEED
                    inc OAM_BUFFER ; first sprite
                    inc OAM_BUFFER + 4 ; second sprite
                    inc OAM_BUFFER + 8 ; third sprite
                .endrep

            ; up button check
            controller_check_up:
                lda controls ; load controller state to accumulator

                and #%00001000 ; check if button is pressed
                beq :+ ; jump if it is not

                lda OAM_BUFFER ; load Y position of stary to accumulator

                cmp #$08 ; check if stary is at top edge of screen
                beq :+ ; jump if true

                ; decrement Y position of stary
                .repeat STARY_SPEED
                    dec OAM_BUFFER ; first sprite
                    dec OAM_BUFFER + 4 ; second sprite
                    dec OAM_BUFFER + 8 ; third sprite
                .endrep
        :
            ; spawn ogiens
            jsr random ; generate random number

            cmp #OGIEN_SPAWN_CHANCE ; check if random number is greater than or equal to spawn chance
            bcs :+ ; jump if true

            ldx #12 ; offset for sprite data

            spawn_ogiens:
                lda OAM_BUFFER + 2, x ; load attribute byte of sprite to accumulator
                cmp #$ff ; check if sprite is not in use
                bne spawn_ogiens_next ; jump if it is

                lda #$10 ; Y position for ogien sprite
                sta OAM_BUFFER, x ; store value in OAM buffer

                lda #$06 ; tile index for ogien sprite
                sta OAM_BUFFER + 1, x ; store value in OAM buffer

                lda #$00 ; attribute byte for ogien sprite
                sta OAM_BUFFER + 2, x ; store value in OAM buffer

                jsr random ; generate random number for ogien X position
                sta OAM_BUFFER + 3, x ; store value in OAM buffer

                jmp :+ ; jump to processing ogiens

                spawn_ogiens_next:
                    clc ; clear carry flag

                    txa ; transfer offset to accumulator
                    adc #4 ; increment offset by 4 to point to next sprite
                    tax ; transfer value back to X register

                    bcc spawn_ogiens ; loop if not run out of free sprites
        :
            ; process active ogiens
            ldx #12 ; offset for sprite data

            ogiens_loop:
                lda OAM_BUFFER + 2, x ; load attribute byte of sprite to accumulator
                cmp #$ff ; check if sprite is not in use
                beq ogiens_loop_next ; jump if true

                lda OAM_BUFFER, x ; load Y position of sprite to accumulator
                cmp #$e8 ; check if sprite is offscreen
                beq ogiens_loop_offscreen ; jump if true

                jsr is_colliding ; check if ogien is colliding with stary
                bcc :+ ; proceed with ogien if not colliding

                jsr init_sprites ; reset sprites
                jmp :++ ; jump to next vblank
            :
                .repeat OGIEN_SPEED
                    inc OAM_BUFFER, x ; increment Y position of sprite
                .endrep

                jmp ogiens_loop_next ; jump to next sprite

                ogiens_loop_offscreen:
                    lda #$ff ; value to mark sprite as not in use

                    sta OAM_BUFFER, x ; store value in Y position
                    sta OAM_BUFFER + 1, x ; store value in tile index
                    sta OAM_BUFFER + 2, x ; store value in attribute byte
                    sta OAM_BUFFER + 3, x ; store value in X position

                ogiens_loop_next:
                    clc ; clear carry flag

                    txa ; transfer offset to accumulator
                    adc #4 ; increment offset by 4 to point to next sprite
                    tax ; transfer value back to X register

                    bcc ogiens_loop ; loop if not at end of sprite data
        :
            ; unset vblank flag
            lda #0 ; value for vblank flag
            sta vblank ; store value into variable

            jmp gameplay_loop ; loop back to beginning

    on_vblank:
        pha ; push accumulator onto stack

        ; set vblank flag for main loop
        lda #$80 ; value for vblank flag
        sta vblank ; store value into variable

        ; copy OAM buffer to PPU
        lda #0 ; OAM destination address
        sta OAM_ADDR ; send value to OAM address register

        lda #>OAM_BUFFER ; page number
        sta OAM_DMA ; send value to OAM DMA register

        pla ; pull accumulator from stack
        rti ; return from interrupt

    on_sample_end:
        lda sample_address ; load current sample address

        cmp #$c0 ; check if last sample in bank has been played
        bne :++ ; skip bank switching if not

        lda bank_index ; load current bank index
        cmp #BANK_AMOUNT ; check if bank index is equal to number of banks
        bne :+ ; skip resetting bank index if not

        lda #0 ; reset bank index
        sta bank_index ; store new bank index
    :
        inc bank_index ; increment bank index
        jsr switch_bank ; switch to next bank of sample data

        lda #0 ; reset sample address
        sta sample_address ; store new sample address

        jmp :++ ; skip incrementing sample address
    :
        clc ; clear carry flag

        lda sample_address ; load current sample address
        adc #$40 ; increment sample address
        sta sample_address ; store new sample address
    :
        lda sample_address ; address of sample data in 64-byte pages
        sta APU_DMC + 2 ; send value to APU DMC register

        lda #$ff ; length of sample data in 16-byte units
        sta APU_DMC + 3 ; send value to APU DMC register

        lda #%00010000 ; enable DMC channel
        sta APU_STATUS ; send value to APU status register

        rti ; return from interrupt

    ; subroutines
    .include "subroutines.asm"

.segment "RODATA"
    tile_data:
        .incbin "assets/tiles.chr" ; tile data for sprites and background

    palette_data:
        .incbin "assets/palette.pal" ; palette data for sprites and background

    background_data:
        .incbin "assets/title_screen.nam" ; background data for the title screen

    sprite_data: ; Y, tile index, attributes, X
        ; Stary
        .byte $c8, $00, %00000100, $74
	    .byte $c8, $02, %00000100, $7c
	    .byte $c8, $04, %00000100, $84

        ; Ogien
        ;.byte $08, $06, %00000000, $00

.segment "VECTORS"
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address
    .word on_sample_end ; IRQ handler address

.include "samples.asm" ; DMC sample data in switchable banks