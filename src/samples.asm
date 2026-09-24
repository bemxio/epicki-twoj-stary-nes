.segment "BANK1"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $0000, $0FF1 ; chunk #1
    .align 16 ; align to 4K boundary
    .incbin "assets/bgm.dmc", $0FF1, $0FF1 ; chunk #2
    .align 16
    .incbin "assets/bgm.dmc", $1FE2, $0FF1 ; chunk #3
    .align 16
    .incbin "assets/bgm.dmc", $2FD3, $0FF1 ; chunk #4
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK2"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $3FC4, $0FF1 ; chunk #5
    .align 16 ; align to 4K boundary
    .incbin "assets/bgm.dmc", $4FB5, $0FF1 ; chunk #6
    .align 16
    .incbin "assets/bgm.dmc", $5FA6, $0FF1 ; chunk #7
    .align 16
    .incbin "assets/bgm.dmc", $6F97, $0FF1 ; chunk #8
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK3"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $7F88, $0FF1 ; chunk #9
    .align 16 ; align to 4K boundary
    .incbin "assets/bgm.dmc", $8F79, $0FF1 ; chunk #10
    .align 16
    .incbin "assets/bgm.dmc", $9F6A, $0FF1 ; chunk #11
    .align 16
    .incbin "assets/bgm.dmc", $AF5B, $0FF1 ; chunk #12
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK4"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $BF4C, $0FF1 ; chunk #13
    .align 16 ; align to 4K boundary
    .incbin "assets/bgm.dmc", $CF3D, $0FF1 ; chunk #14
    .align 16
    .incbin "assets/bgm.dmc", $DF2E, $0FF1 ; chunk #15
    .align 16
    .incbin "assets/bgm.dmc", $EF1F, $0FF1 ; chunk #16
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK5"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $FF10, $0FF1 ; chunk #17
    .align 16 ; align to 4K boundary
    .incbin "assets/bgm.dmc", $10F01, $0FF1 ; chunk #18
    .align 16
    .incbin "assets/bgm.dmc", $11EF2, $0FF1 ; chunk #19
    .align 16
    .incbin "assets/bgm.dmc", $12EE3, $0FF1 ; chunk #20
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK6"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $13ED4, $0FF1 ; chunk #21
    .align 16 ; align to 4K boundary
    .incbin "assets/bgm.dmc", $14EC5, $0FF1 ; chunk #22
    .align 16
    .incbin "assets/bgm.dmc", $15EB6, $0FF1 ; chunk #23
    .align 16
    .incbin "assets/bgm.dmc", $16EA7, $0FF1 ; chunk #24
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address

.segment "BANK7"
    ; DMC sample data
    .incbin "assets/bgm.dmc", $17E98, $0FF1 ; chunk #25
    .align 16 ; align to 4K boundary
    .incbin "assets/bgm.dmc", $18E89, $0FF1 ; chunk #26
    .align 16
    .incbin "assets/bgm.dmc", $19E7A, $0FF1 ; chunk #27
    .align 16
    .incbin "assets/bgm.dmc", $1AE6B, $0FF1 ; chunk #28
    .res 9 ; padding

    ; vector table
    .word on_vblank ; NMI handler address
    .word on_reset ; reset handler address