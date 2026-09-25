; hardware registers
PPU_CTRL = $2000
PPU_MASK = $2001
PPU_STATUS = $2002
PPU_SCROLL = $2005
PPU_ADDR = $2006
PPU_DATA = $2007

OAM_ADDR = $2003
OAM_DMA = $4014

JOY1 = $4016

APU_DMC = $4010
APU_FRAME_COUNTER = $4017
APU_STATUS = $4015

MMC1_CTRL = $8000
MMC1_PRG = $E000

; memory locations
OAM_BUFFER = $0200 ; sprite data in RAM

; game constants
STARY_SPEED = 1 ; speed of Stary (player)

OGIEN_SPEED = 1 ; speed of Ogień (bullets)
OGIEN_SPAWN_CHANCE = 8 ; chance of Ogień spawning in each frame (0-255, higher is more likely)

BANK_AMOUNT = 14 ; number of banks with sample data