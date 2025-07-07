.segment "CODE"
.ifdef EATER


E     = %00000001  ; PB0
RW    = %00000010  ; PB1
RS    = %00000100  ; PB2

; Wait until LCD is not busy (bit 7 = 0)
lcd_wait:
  pha
  lda #%00000000   ; Set PORTA (data) as input
  sta DDRA
lcdbusy:
  lda #RW          ; RW=1, RS=0
  sta PORTB
  lda #(RW | E)    ; E=1
  sta PORTB
  lda PORTA        ; Read busy flag (D7)
  and #%10000000
  bne lcdbusy
  lda #0
  sta PORTB        ; Clear E
  lda #%11111111   ; Set PORTA (data) as output again
  sta DDRA
  pla
  rts

LCDINIT:
  lda #%11111111
  sta DDRA         ; PORTA output
  lda #%00000000
  sta PORTB        ; Ensure control lines start low
  lda DDRB         ; Read current direction settings
  ora #%00000111   ; Set PB0, PB1, PB2 as outputs (E, RW, RS)
  sta DDRB         ; Leave all other bits (like PB6) unchanged


  jsr lcd_wait
  lda #%00111000   ; Function set: 8-bit, 2 lines, 5x8 font
  jsr lcd_instruction
  lda #%00001100   ; Display ON, cursor ON, blink OFF
  jsr lcd_instruction
  lda #%00000110   ; Entry mode: increment cursor
  jsr lcd_instruction
  lda #%00000001   ; Clear display
  jsr lcd_instruction
  rts

LCDCMD:
  jsr GETBYT
  txa
lcd_instruction:
  jsr lcd_wait
  sta PORTA        ; Send command byte to PORTA
  lda #0           ; RS=0, RW=0
  sta PORTB
  ora #E           ; E = 1
  sta PORTB
  eor #E           ; E = 0
  sta PORTB
  rts

LCDPRINT:
  jsr FRMEVL
  bit VALTYP
  bmi lcd_print
  jsr FOUT
  jsr STRLIT
lcd_print:
  jsr FREFAC
  tax
  ldy #0
lcd_print_loop:
  lda (INDEX),y
  jsr lcd_print_char
  iny
  dex
  bne lcd_print_loop
  rts

lcd_print_char:
  jsr lcd_wait
  sta PORTA        ; Put character on data bus
  lda #RS          ; RS=1, RW=0
  sta PORTB
  ora #E
  sta PORTB
  eor #E
  sta PORTB
  rts

.endif
