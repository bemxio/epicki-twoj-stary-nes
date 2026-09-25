import os.path

SAMPLE_PATH = "assets/bgm.dmc"
OUTPUT_PATH = "src/samples.asm"

ROM_SIZE = 240 * 1024 # 240 KB, 15 banks
BANK_AMOUNT = ROM_SIZE // (16 * 1024) # 16 KB per bank

sample_size = os.path.getsize(SAMPLE_PATH)

with open(OUTPUT_PATH, "w", encoding="utf-8") as file:
    address = 0x00000

    for bank in range(BANK_AMOUNT):
        file.write(f".segment \"BANK{bank + 1}\"\n")
        #file.write("    ; DMC sample data\n")

        remaining_bytes = min(0x3fc4, sample_size)

        while remaining_bytes > 0:
            file.write(f"    .incbin \"{SAMPLE_PATH}\", ${address:05X}, ${min(0xff1, remaining_bytes):03X} ; chunk #{address // 0xff1 + 1}\n")

            if remaining_bytes <= 0xff1:
                file.write(f"    .res {0x1000 - min(0xff1, remaining_bytes) - 6} ; padding\n\n")
            else:
                file.write("    .align 16\n")

            address += 0xff1
            remaining_bytes -= min(0xff1, remaining_bytes)

        if sample_size == 0:
            file.write(f"    .res {0x4000 - 6} ; padding\n\n")

        file.write("    ; vector table\n")
        file.write("    .word on_vblank ; NMI handler address\n")
        file.write("    .word on_reset ; reset handler address\n")
        file.write("    .word on_sample_end ; IRQ handler address\n")

        sample_size -= min(0x3fc4, sample_size)
        file.write("\n")