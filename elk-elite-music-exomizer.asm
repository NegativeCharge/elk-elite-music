OSBYTE                  = $FFF4 
SHEILA_COUNTER          = $FE06
SHEILA_MISC_CONTROL     = $FE07

GUARD &89
ORG &79

.zp_start
.track_start            SKIP 2
INCLUDE "lib/exomizer.h.asm"
.zp_end

ORG &3000
GUARD &6000

.start

.jumptable
    jmp init_tune1      ; &3000
    jmp init_tune2      ; &3003
    jmp poll_track      ; &3006

.init_tune1
    ldx #<tune_data1_start
    stx track_start
    ldy #>tune_data1_start
    sty track_start+1
    jmp DRIVER_INIT

.init_tune2
    ldx #<tune_data2_start
    stx track_start
    ldy #>tune_data2_start
    sty track_start+1
    jmp DRIVER_INIT

.poll_track
    jmp DRIVER_PLAY

INCLUDE "drivers/exomizer.asm"

.tune_data1_start
    INCBIN "music/00_Elite_Theme.exo"
.tune_data1_end

PRINT "EXOMIZER"
PRINT "--------"
PRINT ""
PRINT "      Tune 1 size is ",P%-tune_data1_start,"bytes"

.tune_data2_start
    INCBIN "music/01_Blue_Danube.exo"
.tune_data2_end

PRINT "      Tune 2 size is ",P%-tune_data2_start,"bytes"

H%=P%
ALIGN 256
PRINT "           Alignment lost ",(P%-H%),"bytes"

.end

PRINT "           Total size is ",(end-start),"bytes"
PRINT ""

SAVE "DRIVER", start, end, start
PUTFILE ".\BOOT","!BOOT",&FFFF
PUTBASIC "player.bas","PLAYER"