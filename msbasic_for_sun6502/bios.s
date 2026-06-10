.setcpu "65C02"
.debuginfo

.zeropage
                .org ZP_START0
READ_PTR:       .res 1
WRITE_PTR:      .res 1

.segment "INPUT_BUFFER"
INPUT_BUFFER:   .res $100

.segment "BIOS"

ACIA_DATA       = $8400
ACIA_STATUS     = $8401
ACIA_CMD        = $8402
ACIA_CTRL       = $8403
PORTA           = $8001
DDRA            = $8003
PORTB           = $8000
DDRB            = $8002

LOAD:
                rts

SAVE:
                rts

; --- Input a character from the serial interface
; On return:
;   Carry = 1 → key was pressed, A = key
;   Carry = 0 → no key available
; Modifies: flags, A
MONRDKEY:
CHRIN:
                phx
                jsr     BUFFER_SIZE
                beq     @no_keypressed     ; nothing in buffer?

                jsr     READ_BUFFER
                jsr     CHROUT             ; echo it

                pha
                jsr     BUFFER_SIZE
                cmp     #$B0               ; if mostly full, stop input
                bcs     @mostly_full

                ; BUFFER NOT FULL → Ready to receive
                lda     PORTB
                and     #%10111111         ; Clear PB6 (flow control = ready)
                sta     PORTB
                bra     @done_flow

@mostly_full:
                ; BUFFER MOSTLY FULL → Not ready
                lda     PORTB
                ora     #%01000000         ; Set PB6 (flow control = not ready)
                sta     PORTB

@done_flow:
                pla
                plx
                sec                         ; key was read
                rts

@no_keypressed:
                plx
                clc                         ; no key
                rts

; --- Output a character from A to the serial interface
; Modifies: A, flags
MONCOUT:
CHROUT:
                pha
                sta     ACIA_DATA
                lda     #$FF
@txdelay:       dec
                bne     @txdelay
                pla
                rts

; --- Initialize circular input buffer and flow control
INIT_BUFFER:
                lda READ_PTR
                sta WRITE_PTR

                lda #%11111111
                sta DDRA

                lda #%01111111              ; PB0–PB6 outputs
                sta DDRB

                lda PORTB
                and #%10111111              ; Clear PB6 = ready
                sta PORTB
                rts

; --- Write character (A) to input buffer
WRITE_BUFFER:
                ldx WRITE_PTR
                sta INPUT_BUFFER,x
                inc WRITE_PTR
                rts

; --- Read character from input buffer into A
READ_BUFFER:
                ldx READ_PTR
                lda INPUT_BUFFER,x
                inc READ_PTR
                rts

; --- Return number of unread bytes in buffer (A)
BUFFER_SIZE:
                lda WRITE_PTR
                sec
                sbc READ_PTR
                rts

; --- IRQ handler: store ACIA char to buffer, update flow if full
IRQ_HANDLER:
                pha
                phx
                lda     ACIA_STATUS
                bpl     @spurious
                and     #%00001110
                cmp     #%00001000
                bne     @error_or_noise
                lda     ACIA_DATA
                jsr     WRITE_BUFFER
                jsr     BUFFER_SIZE
                cmp     #$F0
                bcc     @not_full
                lda     PORTB
                ora     #%01000000          ; Set PB6 = not ready
                sta     PORTB
@not_full:
                plx
                pla
                rti

@error_or_noise:
                lda     ACIA_DATA
                plx
                pla
                rti

@spurious:
                plx
                pla
                rti

.include "wozmon.s"

.segment "RESETVEC"
                .word   $0F00           ; NMI vector
                .word   RESET           ; RESET vector
                .word   IRQ_HANDLER     ; IRQ vector
