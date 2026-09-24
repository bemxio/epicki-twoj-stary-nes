.segment "BANK1"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $00000, $FF1 ; chunk #1
    .align 16
    .incbin "assets/bgm.dmc", $00FF1, $FF1 ; chunk #2
    .align 16
    .incbin "assets/bgm.dmc", $01FE2, $FF1 ; chunk #3
    .align 16
    .incbin "assets/bgm.dmc", $02FD3, $FF1 ; chunk #4
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK2"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $03FC4, $FF1 ; chunk #5
    .align 16
    .incbin "assets/bgm.dmc", $04FB5, $FF1 ; chunk #6
    .align 16
    .incbin "assets/bgm.dmc", $05FA6, $FF1 ; chunk #7
    .align 16
    .incbin "assets/bgm.dmc", $06F97, $FF1 ; chunk #8
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK3"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $07F88, $FF1 ; chunk #9
    .align 16
    .incbin "assets/bgm.dmc", $08F79, $FF1 ; chunk #10
    .align 16
    .incbin "assets/bgm.dmc", $09F6A, $FF1 ; chunk #11
    .align 16
    .incbin "assets/bgm.dmc", $0AF5B, $FF1 ; chunk #12
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK4"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $0BF4C, $FF1 ; chunk #13
    .align 16
    .incbin "assets/bgm.dmc", $0CF3D, $FF1 ; chunk #14
    .align 16
    .incbin "assets/bgm.dmc", $0DF2E, $FF1 ; chunk #15
    .align 16
    .incbin "assets/bgm.dmc", $0EF1F, $FF1 ; chunk #16
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK5"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $0FF10, $FF1 ; chunk #17
    .align 16
    .incbin "assets/bgm.dmc", $10F01, $FF1 ; chunk #18
    .align 16
    .incbin "assets/bgm.dmc", $11EF2, $FF1 ; chunk #19
    .align 16
    .incbin "assets/bgm.dmc", $12EE3, $FF1 ; chunk #20
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK6"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $13ED4, $FF1 ; chunk #21
    .align 16
    .incbin "assets/bgm.dmc", $14EC5, $FF1 ; chunk #22
    .align 16
    .incbin "assets/bgm.dmc", $15EB6, $FF1 ; chunk #23
    .align 16
    .incbin "assets/bgm.dmc", $16EA7, $FF1 ; chunk #24
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK7"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $17E98, $FF1 ; chunk #25
    .align 16
    .incbin "assets/bgm.dmc", $18E89, $FF1 ; chunk #26
    .align 16
    .incbin "assets/bgm.dmc", $19E7A, $FF1 ; chunk #27
    .align 16
    .incbin "assets/bgm.dmc", $1AE6B, $FF1 ; chunk #28
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address
