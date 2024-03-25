ENABLE_MUSIC equ 1
ENABLE_SPECIFIC_ACTION_AFTER_DRAWING equ 0
ENABLE_DOUBLE_SHADOW equ 1
ENABLE_ROUND_CORNERS equ 1
ENABLE_RASTERS equ 0 ; unficniehd code/no time to do it

RASTERS_HEIGHT equ 25*8 - 3

SHADOW_IN_GREY equ 0
SHADOW_IN_PEN_COLOR equ 1


	assert SHADOW_IN_GREY + SHADOW_IN_PEN_COLOR == 1

SCREEN_VERTICAL_RESOLUTION equ 25*8
SCREEN_HORIZONTAL_SOLUTION equ 40*4

SCREEN_MEMORY_ADDRESS equ 0xc000
SCREEN_CRTC_ADDRESS equ 0x3000

SIMPLE_CLEAN equ 0


ENGINE_HANDLE_VIEW_PORT equ 0 ; set to 0 to disable code that check if pen goes outside of screen


FINAL equ true