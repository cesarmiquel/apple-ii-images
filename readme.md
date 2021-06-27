# Readme

This repo has images created for the Apple II. It uses Deater's tool `png2hgr` tool to convert a PNG file to an image that can be `bload`ed. Here is how to create an image:

1. Create 280x192 indexed file in Gimp
2. Make sure you import tha `hgr.pal` palette file provided by Deater.
3. Export your file to a PNG
4. Run the `png2hgr` like so: `png2hgr file.png > file.bin`
5. Use AppleCommander to add the file to a disk image with `ac -p images.dsk file B 0x2000 < file.bin`

To load the image in the emulator do:

```
hgr
bload file,A$2000
```

And you should see the image on the screen.

I've created a makefile which puts the images in Dos33 disks.


## Links

- [BMP Viewer for the Apple II](https://github.com/cybernesto/VBMP) - Viewer that can display a BMP file directly from a DOS 3.3 file
- [Rgb2Hires](https://github.com/Pixinn/Rgb2Hires) - Rgb2Hires is a set of tools to help converting a modern RGB image (JPEG, PNG) to the HIRES format for Apple II computers ; either as a binary export or an assembly listing. The color of the RGB imlage can be approximative: Rgb2Hires will match them with the nearest HIRES color.
- [Double High Resolution Graphics (DHGR) - Pushing Limits](http://lukazi.blogspot.com/2017/03/double-high-resolution-graphics-dhgr.html) - In depth article on DHGR
- [HIRES Graphics on Apple II](https://www.xtof.info/hires-graphics-apple-ii.html)
- [What determines the color of every 8th pixel on the Apple II?](https://retrocomputing.stackexchange.com/questions/6271/what-determines-the-color-of-every-8th-pixel-on-the-apple-ii) - Some very nice answers in stackexchange about HGR on the Apple II.
- [#Apple II //e HGR Font 6502 Assembly Language Tutorial](https://github.com/Michaelangel007/apple2_hgr_font_tutorial) - A **very** thorough tutorian on "6502 font blitting" (blitting text characters on the HGR screen)
- [Assembly Hi-Res Graphics, question about color patterns that seem to violate the "rules"](https://groups.google.com/g/comp.sys.apple2.programmer/c/vxtFo6QEYGg) - A thread in Google Groups about HGR and DHGR.

From that thread here are some notes:

```
bit #
0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7

color bit color bit
| |
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
|_| |_| |_| |_____| |_| |_| |_|

0 1 2 3 4 5 6


every 2 bytes starting on an even number ($2000.2001) gives seven pixels.
As you can see, pixel #3 uses a bit from byte $2000 and byte 2001 to form a pixel.

if any two bits are consecutive (except the color bit) you get two white pixels.
with color bit clear, each group of bits will show violet or green.
with color bit set, each group of bits will show blue or orange.

color bit clear
bits-color
00 - black
10 - violet
01 - green
11 - white

color bit set
00 - black
10 - blue
01 - orange
11 - white


To get the value in each byte
even byte ($2000,2002,2004 etc...)
bit # value #
0 _ $1
1 |_ $2
2 _ $4
3 |_ $8
4 _ $10
5 |_ $20
6 _ $40
7 | $80 - color bit
|
bit#| value# - odd bytes ($2001,2003 etc...)
0 |_ $1
1 _ $2
2 |_ $4
3 _ $8
4 |_ $10
5 _ $20
6 |_ $40
7 $80 - color bit


Using the chart directly above, you can add the values that make up each pixel

For each column or pixels - add put a 0 or 1 into each group of bits according to the color chart

for pixel#0
so for a violet pixel - bit#0=1 & bit#1=0 from the color chart above - for a total of $1
for a green pixel - bit#0=0 & bit#1=1 for a total of $2
for a blue pixel - bit#0=1 & bit#1=0 equals 1 plus the value of the color bit $80 = $81
for an orange pixel - bit#0=0 & bit#1=1 equals 2 plus the color bit = $82


for pixel#1
violet - bit#2=1 & bit#3=0 = 4
green - bit#2=0 & bit#3=1 = 8
blue - bit#2=1 & bit#3=0 equals 4 + colorbit = $84
orange - bit#2=0 & bit+3=1 equals 8 + colorbit = $88

for two consecutive blue pixels you would add
a blue pixel in pixel#0 equals $1 + a blue pixel in pixel#1 equals $4 + color bit = $85


now you should be able to see how I added up the values for a blue line

2000:$81
2000:$85
2000:$95
2000:$D5
2001:82
2001:8a
2001:aa

and $2002.2003 would be the same values for a blue line

$2002:81
$2002:85
$2002:95
$2002:D5
$2003:82
$2003:8a
$2003:aa



Vertical Lines have an unorthodox way as well and count from 0-$C0 (0-191)

$2000: Line #0
$2400: Line #1
$2800: Line #2


but instead of using lines this way, use the calculator in ROM @$F417

enter this routine in and enter the starting row# you want in $301 and it will display the starting address for that row.

300:A9 00 A2 20 86 E6 20 17 F4 A5 27 A6 26 20 41 F9 4C 8E FD 00

301:0
300G
2000

301:1
300G
2400

301:2
300G
2800
...

301:BF
300G
3FD0
```

## Credits

- sanderfocus.png comes from [this Tweet](https://twitter.com/SanderFocus/status/1405093188407369732) from artist [Sander van den Borne](https://sanderfocus.nl/)
- pirate comes from [this ZX artist](https://zxart.ee/eng/authors/m/moroz1999/crystal-kingdom-dizzy-sprites/) 

## Apendix

Two awesome little programs to investigate HGR from the Google Groups thread:

```
0900:A9 0C 2C 54 C0 2C 50 C0
0908:2C 53 C0 2C 57 C0 A2 00
0910:86 FD 86 FF 86 E2 86 FA
0918:86 26 A9 20 85 27 85 E6
0920:BD F8 09 F0 3C 9D D0 06
0928:E8 D0 F5 A5 FD 29 01 AA
0930:9D 52 C0 A5 FD 49 01 85
0938:FD 18 90 40 49 80 18 90
0940:34 C6 FF 10 24 E6 FF A5
0948:FF C9 28 B0 F4 90 1A C6
0950:E2 A5 E2 C9 FF D0 12 E6
0958:E2 A5 E2 C9 C0 B0 F0 90
0960:08 A9 14 85 FF A9 60 85
0968:E2 A0 00 A2 00 A5 E2 20
0970:11 F4 20 C1 0A 85 FC 85
0978:FB 20 1E 0A A5 FB 49 FF
0980:85 FB 20 C7 0A AD 00 C0
0988:10 F2 8D 10 C0 29 7F A2
0990:1F DD CC 0A F0 05 CA 10
0998:F8 30 E1 A9 09 48 BD EC
09A0:0A 48 A5 FC 20 C7 0A 60
09A8:A9 FF D0 C9 A9 00 F0 C5
09B0:A2 FF D0 36 38 B0 02 C9
09B8:80 2A 18 90 B8 09 01 4A
09C0:90 B3 09 80 B0 AF 0A A2
09C8:4A 18 90 A9 A2 01 D0 1A
09D0:A2 02 D0 16 A2 04 D0 12
09D8:A2 08 D0 0E A2 10 D0 0A
09E0:A2 20 D0 06 A2 40 D0 02
09E8:A2 80 86 FE 45 FE 18 90
09F0:84 85 FA A5 FA 18 90 F6
09F8:A0 A0 A0 A0 A0 A0 A0 A0
0A00:A0 A0 A0 A0 D3 C1 D6 C5
0A08:BA BF BF A0 B7 B6 B5 B4
0A10:B3 B2 B1 B0 A0 31 32 33
0A18:34 35 36 37 38 00 A9 00
0A20:85 24 A9 14 20 5B FB A9
0A28:D8 20 ED FD A5 FF 20 D3
0A30:FD A9 A0 20 ED FD A9 D9
0A38:20 ED FD A5 E2 20 D3 FD
0A40:A9 A0 20 ED FD A9 A4 20
0A48:ED FD A5 27 20 D3 FD A5
0A50:26 18 65 FF 20 DA FD A9
0A58:BA 20 ED FD A5 FC 20 DA
0A60:FD A9 A0 20 ED FD A2 08
0A68:A5 FC 85 FE 06 FE 6A CA
0A70:D0 FA 85 FE 48 A2 08 A5
0A78:FE 20 B6 0A 66 FE CA D0
0A80:F6 A9 FE 20 ED FD A2 08
0A88:A5 FC A8 20 B6 0A 98 4A
0A90:CA D0 F7 A9 A4 20 ED FD
0A98:68 20 DA FD A5 FA 48 4A
0AA0:4A 4A 4A 20 A7 0A 68 29
0AA8:0F 09 30 C9 3A 90 02 E9
0AB0:39 9D E1 06 E8 60 29 01
0AB8:F0 02 A9 81 49 B0 4C ED
0AC0:FD A4 FF B1 26 85 FC A4
0AC8:FF 91 26 60 1B 0D 08 15
0AD0:0B 0A 49 4A 4B 4C 09 31
0AD8:32 33 34 35 36 37 38 20
0AE0:39 30 60 7E 2C 3C 2E 3E
0AE8:5B 5D 3D 2D A6 2A 40 44
0AF0:4E 56 4E 40 56 44 60 CB
0AF8:CF D3 D7 DB DF E3 E7 3B
0B00:A7 AB AF AF C5 B3 C7 BC
0B08:B6 BE F0 F2

Here is the source assembly:
(Requires ca65 to assemble + link)


; HGR Byte Inspector
; Michael Pohoreski
; Version 12
;
; Keys:
;
; ESC Quit
; CR Toggle fullscreen
;
; <- Move cursor left
; -> Move cursor right
; Up Move cursor up
; Down Move cursor down
;
; I Move cursor up
; J Move cursor left
; K Move cursor right
; L Move cursor down
; TAB Center cursor
;
; 1 Toggle bit 0
; 2 Toggle bit 1
; 3 Toggle bit 2
; 4 Toggle bit 3
; 5 Toggle bit 4
; 6 Toggle bit 5
; 7 Toggle bit 6
; 8 Toggle bit 7 (high bit)
; SPC Toggle high bit of byte (bit 7)
; 9 Set byte to $FF
; 0 Clear byte to $00
; ` Flip all bits
; ~ Flip all bits
;
; , Shift byte left (with zero)
; . Shift byte right (with one )
; < Shift byte left (with zero)
; > Shift byte right (with one )
; [ Rotate byte left
; ] Rotate byte right
;
; = Save cursor byte
; - Restore saved byte


; Force APPLE 'text' to have high bit on
; Will display as NORMAL characters
.macro APPLE text
.repeat .strlen(text), I
.byte .strat(text, I) | $80
.endrep
.endmacro


; Force ASCII 'text' to be control chars: $00..$1F
; Will display as INVERSE characters
.macro CTRL text
.repeat .strlen(text), I
.byte .strat(text, I) & $1F
.endrep
.endmacro


; Force ASCII 'text' to be control chars: $00..$3F
; Will display as INVERSE characters
.macro INV text
.repeat .strlen(text), I
.byte .strat(text, I) & $3F
.endrep
.endmacro

GBASL = $26
GBASH = $27
CH = $24 ; text cursor column
CV = $25 ; text cursor row
ROW_20 = $0550 ; VTAB 21 TEXT address
ROW_21 = $06D0 ; VTAB 22 TEXT address
ROW_22 = $0750 ; VTAB 23 TEXT address
ROW_23 = $07D0 ; VTAB 24 TEXT address

HPOSN = $F411 ; A=row, Y,X=col update GBASL GBASH
TABV = $FB5B ; A=row, ALL STA $25, JMP $FC22
VTAB = $FC22 ; $25=row //e LDA $25, STA$28
HOME = $FC58
COUT = $FDED
PR_HEX = $FDD3
PRBYTE = $FDDA

KEYBOARD = $C000
KEYSTROBE = $C010
TXTCLR = $C050 ; Mode Graphics
MIXCLR = $C052 ; Full screen
MIXSET = $C053 ; Split screen
PAGE1 = $C054
HIRES = $C057 ; Mode HGR

cursor_row = $E2 ; used by Applesoft HGR.row
cursor_org = $FA ; When cursor is saved
cursor_tmp = $FB ; Flashing cursor byte
cursor_val = $FC ; Current byte under cursor
flags = $FD ;
temp = $FE
cursor_col = $FF
FLAG_FULL = $01 ; == $1 -> $C052 MIXCLR
; ; == $0 -> $C053 MIXSET
HGRPAGE = $E6 ; used by Applesoft HGR.page

__MAIN= $0900
.word __MAIN ; 2 byte BLOAD address
.word __END - __MAIN ; 2 byte BLOAD size
.org __MAIN ; .org must come after header else offsets are wrong

HgrByte:
LDA #12 ; Version
BIT PAGE1 ; Page 1
BIT TXTCLR ; not text, but graphics
BIT MIXSET ; Split screen text/graphics
BIT HIRES ; HGR, no GR

LDX #0 ; also used by PrintFooter
STX flags
STX cursor_col
STX cursor_row
STX cursor_org
STX GBASL
LDA #$20
STA GBASH
STA HGRPAGE
PrintFooter:
LDA TextFooter, X
BEQ _Center ; Default to center of screen
STA ROW_21,X ; 4 line text window, 2nd row
INX
BNE PrintFooter ; (almost) always

; Funcs that JMP to GetByte before GotKey()
; Funcs that JMP to PutByte after GotKey()
_Screen: ; Toggle mixed/full screen
LDA flags ; A = %????_????
AND #FLAG_FULL ; A = %0000_000f
TAX ; f=0 f=1
STA MIXCLR,X ; C052 C053
LDA flags ; FULL MIX
EOR #FLAG_FULL ; mode is based on old leading edge
STA flags ; not new trailing edge
CLC
BCC FlashByte ; always
_HighBit:
EOR #$80
CLC
BCC PutByte
_MoveL: DEC cursor_col
BPL GetByte
_MoveR: INC cursor_col
LDA cursor_col
CMP #40
BCS _MoveL
BCC GetByte ; always

_MoveU: DEC cursor_row
LDA cursor_row
CMP #$FF
BNE GetByte ; INTENTIONAL fall into if Y < 0
_MoveD: INC cursor_row
LDA cursor_row
CMP #192
BCS _MoveU
BCC GetByte ; always
_Center:
LDA #40/2
STA cursor_col
LDA #192/2
STA cursor_row ; intentional fall into GetByte

GetByte: ; Cursor position changed
LDY #0 ; Update pointer to screen
LDX #0
LDA cursor_row
JSR HPOSN ; A=row, Y,X=col X->E0 Y->E1
JSR GetCursorByte
PutByte:
STA cursor_val ; current value
STA cursor_tmp ; flashing cursor
JSR DrawStatus
FlashByte:
LDA cursor_tmp
EOR #$FF
STA cursor_tmp
JSR SetCursorByte
GetKey:
LDA KEYBOARD
BPL FlashByte
STA KEYSTROBE
AND #$7F ; Force ASCII
LDX #nKeys-1
FindKey:
CMP aKeys, X
BEQ GotKey
DEX
BPL FindKey
BadKey:
BMI FlashByte

GotKey:
; If code doesn't fit withing +/-127 bytes
; LDA aFuncHi, X
LDA #>HgrByte ; FuncAddressHi
PHA
LDA aFuncLo, X ; FuncAddressLo
PHA
LDA cursor_val ; Last displayed byte may be cursor_tmp
JSR SetCursorByte ; restore current val in case cursor moves
; Also pre-load for ROL/R SHL/R
_Exit: RTS ; And call function assigned to key
; To BRUN under DOS.3 change above RTS to
; RTS
;_Exit: JMP $3D0 ; DOS 3.3 Warmstart vector

; Functions starting with _ are invoked via keys
_ByteFF:
LDA #$FF
BNE PutByte ; always
_Byte00:
LDA #$00
BEQ PutByte ; always
_FlipByte:
LDX #$FF
BNE TogBit
_SHL1: SEC ; Force C=1 via ROL
BCS _Rol1
_Rol: CMP #$80 ; C=a A=%abcd_efgh
_Rol1: ROL ; C=b A=%bcde_fgha C<-bit7, bit0<-C
CLC ; force branch always
BCC PutByte

_SHR1: ORA #$01 ; Force C=1 via ROR (SHR, OR #$80)
; Intentional fall into _Ror
; Using LSR instead of ROR to save a byte
; 8 Byte version
; CLC
; ROR
; BCC PutByte
; ORA #$80
; BCS PutByte
_Ror: LSR ; C=h A=%0abc_defg 0->bit7, bit0->C
BCC PutByte
ORA #$80
BCS PutByte ; always

_ShiftL:ASL ; C=a A=%bcde_fgh0
.byte $A2 ; skip next LSR instruction; LDX dummy imm val
_ShiftR:LSR ; C=h A=%0abc_defg
CLC
BCC PutByte ; always

_Bit0: LDX #%00000001
BNE TogBit ; always
_Bit1: LDX #%00000010
BNE TogBit ; always
_Bit2: LDX #%00000100
BNE TogBit ; always
_Bit3: LDX #%00001000
BNE TogBit ; always
_Bit4: LDX #%00010000
BNE TogBit ; always
_Bit5: LDX #%00100000
BNE TogBit ; always
_Bit6: LDX #%01000000
BNE TogBit ; always
_Bit7: LDX #%10000000 ; intentional fall into

; common _Bit# code
TogBit: STX temp
EOR temp
GotoPutByte:
CLC ; code is too far to directly branch
BCC PutByte ; to PutByte, use as trampoline
_SaveByte:
STA cursor_org ; intentional fall into
_LoadByte:
LDA cursor_org
CLC
BCC GotoPutByte ; always

TextFooter:
; "X=## Y=## $=####:## %%%%%%%%~%%%%%%%%"
APPLE " SAVE:?? 76543210 "
INV "12345678" ;1-8 INVERSE
.byte $00

DrawStatus:
LDA #0 ; Cursor.X = 0
STA CH
LDA #20 ; Cursor.Y = Top of 4 line split TEXT/HGR window
JSR TABV ; update CV
PrintStatus:
LDA #'X'+$80 ; X=## Y=## $=####:##
JSR COUT
LDA cursor_col
JSR PR_HEX
LDA #' '+$80
JSR COUT
LDA #'Y'+$80
JSR COUT
LDA cursor_row
JSR PR_HEX
LDA #' '+$80
JSR COUT
LDA #'$'+$80
JSR COUT
LDA GBASH
JSR PR_HEX
LDA GBASL
CLC
ADC cursor_col
JSR PRBYTE
LDA #':'+$80
JSR COUT
LDA cursor_val
JSR PRBYTE
LDA #' '+$80
JSR COUT

ReverseByte:
LDX #8
LDA cursor_val
STA temp
ReverseBit:
ASL temp
ROR
DEX
BNE ReverseBit
STA temp

PHA ; save reverse byte

LDX #8
PrintBitsNormal:
LDA temp
JSR Bit2Asc
ROR temp
DEX
BNE PrintBitsNormal

LDA #'~'+$80
JSR COUT

LDX #8
LDA cursor_val
PrintBitsReverse:
TAY
JSR Bit2Asc
TYA
LSR
DEX
BNE PrintBitsReverse

LDA #'$'+$80
JSR COUT
PLA ; restore reverse byte
JSR PRBYTE

LDA cursor_org ; X=0
PHA
LSR
LSR
LSR
LSR
JSR NibToInvTxt
PLA
; Display nibble as inverse text
; 0 -> '0' $30
; 9 -> '9' $39
; A -> ^A $01
; F -> ^F $06
NibToInvTxt:
AND #$F
ORA #'0'+$00 ; ASCII: +$80
CMP #'9'+$01 ; ASCII: +$81
BCC PrintSave
SBC #$39 ; C=1, $3A ':' -> $01 'A', $3F '?' -> $06
PrintSave:
STA ROW_21+17,X
INX
RTS

Bit2Asc:
AND #$01 ; 0 -> B0
BEQ FlipBit
LDA #$81 ; 1 -> 31
FlipBit:
EOR #$B0
JMP COUT

; A = byte
GetCursorByte:
LDY cursor_col
LDA (GBASL),Y
STA cursor_val
SetCursorByte:
LDY cursor_col
STA (GBASL),Y
RTS

; Keys are searched in reverse order
; Sorted by least used to most used
aKeys:
CTRL "[" ; _Exit ESC Quit
CTRL "M" ; _Screen RET Toggle fullscreen

CTRL "H" ; _MoveL <- Ctrl-H $08
CTRL "U" ; _MoveR -> Ctrl-U $15
CTRL "K" ; _MoveU Up Ctrl-K $0B
CTRL "J" ; _MoveD Down Ctrl-J $0A

.byte "I" ; _MoveU Move cursor Up
.byte "J" ; _MoveL Move cursor Left
.byte "K" ; _MoveD Move cursor Down
.byte "L" ; _MoveR Move cursor Right
CTRL "I" ; _Center Center cursor

.byte "1" ; _Bit0 Toggle bit 0
.byte "2" ; _Bit1 Toggle bit 1
.byte "3" ; _Bit2 Toggle bit 2
.byte "4" ; _Bit3 Toggle bit 3
.byte "5" ; _Bit4 Toggle bit 4
.byte "6" ; _Bit5 Toggle bit 5
.byte "7" ; _Bit6 Toggle bit 6
.byte "8" ; _Bit7 Toggle bit 7

.byte " " ; _HighBit Toggle high bit of byte (bit 7)
.byte "9" ; _ByteFF Set byte to FF
.byte "0" ; _Byte00 Set byte to 00
.byte "`" ; _FlipByte Toggle all bits
.byte "~" ; _FlipByte

.byte "," ; _ShiftL (with zero)
.byte "<" ; _ShiftL (with one )
.byte "." ; _ShiftR (with zero)
.byte ">" ; _ShiftR (with one )
.byte "[" ; _Rol
.byte "]" ; _Ror

.byte "=" ; _SaveByte Save current byte to temporary
.byte "-" ; _LoadByte Load temporary to current byte
eKeys:
nKeys = eKeys - aKeys ;

; Table of function pointers
; *Note*: Must match aKeys order!
aFuncLo:
.byte <_Exit -1 ; ESC
.byte <_Screen -1 ; RET

.byte <_MoveL -1 ; <-
.byte <_MoveR -1 ; ->
.byte <_MoveU -1 ; UP
.byte <_MoveD -1 ; DN

.byte <_MoveU -1 ; 'I'
.byte <_MoveL -1 ; 'J'
.byte <_MoveD -1 ; 'K'
.byte <_MoveR -1 ; 'L'
.byte <_Center -1 ; Ctrl-I

.byte <_Bit0 -1 ; '1'
.byte <_Bit1 -1 ; '2'
.byte <_Bit2 -1 ; '3'
.byte <_Bit3 -1 ; '4'
.byte <_Bit4 -1 ; '5'
.byte <_Bit5 -1 ; '6'
.byte <_Bit6 -1 ; '7'
.byte <_Bit7 -1 ; '8'

.byte <_HighBit -1 ; SPC
.byte <_ByteFF -1 ; '9'
.byte <_Byte00 -1 ; '0'
.byte <_FlipByte-1 ; '`'
.byte <_FlipByte-1 ; '~' not a dup mistake

.byte <_ShiftL -1 ; `,`
.byte <_SHL1 -1 ; `<`
.byte <_ShiftR -1 ; `.`
.byte <_SHR1 -1 ; `>`
.byte <_Rol -1 ; '['
.byte <_Ror -1 ; ']

.byte <_SaveByte-1 ; '='
.byte <_LoadByte-1 ; '-'
__END:
```

- [HGRBYTE inspector](https://github.com/Michaelangel007/apple2_hgrbyte)
```
Or just use my HGRBYTE inspector and you can toggle, shift, rotate, set, clear the bits to yours hearts content AND see the corresponding hex values, both normal and reversed bits & bytes. :-)

You can find a DSK image up on GitHub.
https://github.com/Michaelangel007/apple2_hgrbyte

(Assembly source code will be posted later this week.)

Keys

ESC Quit
G Toggle fullscreen

I Move cursor up
J Move cursor left
K Move cursor right
L Move cursor down

^I Move cursor to col 0
^J Move cursor to col 39
^K Move cursor to row 0
^L Move cursor to row 191
RET Center cursor

0..9 "Append" hex nibble to cursor byte
A..F

! Toggle bit 0
@ Toggle bit 1
# Toggle bit 2
$ Toggle bit 3
% Toggle bit 4
^ Toggle bit 5
& Toggle bit 6
* Toggle bit 7 (high bit)
SPC Toggle high bit of byte (bit 7)
( Set byte to $FF (Shift-9)
) Clear byte to $00 (Shift-0)
` Flip all bits
~ Flip all bits

, Shift byte left (with zero)
. Shift byte right (with one )
< Shift byte left (with zero)
> Shift byte right (with one )
[ Rotate byte left
] Rotate byte right

- Save cursor byte to temporary
= Set cursor byte from temporary


If you want to try the new Version 16 immediately:

0900:A9 10 2C 54 C0 2C 50 C0
0908:2C 53 C0 2C 57 C0 A2 00
0910:86 FD 86 FF 86 E2 86 FA
0918:86 26 A9 20 85 27 85 E6
0920:BD 16 0A F0 4A 9D D0 06
0928:E8 D0 F5 A5 FD 29 01 AA
0930:9D 52 C0 A5 FD 49 01 85
0938:FD 80 4F 49 80 80 44 C6
0940:FF 10 34 E6 FF A5 FF C9
0948:28 90 2C A9 27 2C A9 00
0950:85 FF 10 23 C6 E2 A5 E2
0958:C9 FF D0 1B E6 E2 A5 E2
0960:C9 C0 90 13 A9 BF 2C A9
0968:00 85 E2 69 01 D0 08 A9
0970:14 85 FF A9 60 85 E2 A0
0978:00 A2 00 A5 E2 20 11 F4
0980:20 DF 0A 85 FC 85 FB 20
0988:3C 0A 20 EA 0A AD 00 C0
0990:10 F8 8D 10 C0 29 7F 85
0998:F9 C9 30 90 04 C9 3A 90
09A0:5F C9 41 90 04 C9 47 90
09A8:57 A2 22 CA 30 DC DD F3
09B0:0A D0 F8 A9 09 48 BD 15
09B8:0B 48 A5 FC 20 E5 0A A2
09C0:00 60 A9 FF D0 BD A9 00
09C8:F0 B9 A2 FF D0 25 C9 80
09D0:2A 80 B0 09 01 4A 90 AB
09D8:09 80 B0 A7 0A A2 4A 80
09E0:A2 E8 E8 E8 E8 E8 E8 E8
09E8:E8 A8 38 A9 00 2A CA D0
09F0:FC AA 98 86 FE 45 FE 80
09F8:8A 85 FA A5 FA 18 90 F7
0A00:A0 03 06 FC 88 10 FB A5
0A08:F9 C9 41 90 02 E9 07 29
0A10:0F 18 65 FC 90 E1 A0 A0
0A18:A0 A0 A0 A0 A0 A0 A0 A0
0A20:A0 A0 D3 C1 D6 C5 BA BF
0A28:BF A0 B7 B6 B5 B4 B3 B2
0A30:B1 B0 A0 31 32 33 34 35
0A38:36 37 38 00 A9 00 85 24
0A40:A9 14 20 5B FB A9 D8 20
0A48:ED FD A5 FF 20 D3 FD A9
0A50:A0 20 ED FD A9 D9 20 ED
0A58:FD A5 E2 20 D3 FD A9 A0
0A60:20 ED FD A9 A4 20 ED FD
0A68:A5 27 20 D3 FD A5 26 18
0A70:65 FF 20 DA FD A9 BA 20
0A78:ED FD A5 FC 20 DA FD A9
0A80:A0 20 ED FD A2 08 A5 FC
0A88:85 FE 06 FE 6A CA D0 FA
0A90:85 FE 48 A2 08 A5 FE 20
0A98:D4 0A 66 FE CA D0 F6 A9
0AA0:FE 20 ED FD A2 08 A5 FC
0AA8:A8 20 D4 0A 98 4A CA D0
0AB0:F7 A9 A4 20 ED FD 68 20
0AB8:DA FD A5 FA 48 4A 4A 4A
0AC0:4A 20 C5 0A 68 29 0F 09
0AC8:30 C9 3A 90 02 E9 39 9D
0AD0:E1 06 E8 60 29 01 F0 02
0AD8:A9 81 49 B0 4C ED FD A4
0AE0:FF B1 26 85 FC A4 FF 91
0AE8:26 60 A5 FB 49 FF 85 FB
0AF0:4C E5 0A 1B 47 08 15 09
0AF8:0A 0B 0C 0D 49 4A 4B 4C
0B00:21 40 23 24 25 5E 26 2A
0B08:20 28 29 60 7E 2C 3C 2E
0B10:3E 5B 5D 2D 3D C0 2A 3E
0B18:42 66 4D 63 4A 6E 53 3E
0B20:5B 42 E7 E6 E5 E4 E3 E2
0B28:E1 E0 3A C1 C5 C9 C9 DB
0B30:CF DD D2 CD D4 F8 FA
```


- [This one comes from Retrocomputing Stackxchange](https://retrocomputing.stackexchange.com/questions/6271/what-determines-the-color-of-every-8th-pixel-on-the-apple-ii) - It edits the bytes in $00 and $01 and fills the hires screen with them. The bits are shown, and the keys to toggle the bits are printed above them. So 7 to 0 toggle the bits in byte 0, and H to A toggle the bits in byte 1. Ctrl-A to Ctrl-H set the bytes to hires colours 0 to 7, Space swaps the bytes, and Esc exits. Then if you like you can change $00 or $01 and restart with 8000G.

```
8000:20 2F FB 20 B7 80 20 E2 F3 A9 00 A8 85 02 A9 20
8010:85 03 A2 20 A5 00 91 02 C8 A5 01 91 02 C8 D0 F4
8020:E6 03 CA D0 EF 86 24 A9 15 85 25 A5 00 20 92 80
8030:A5 01 20 92 80 AD 00 C0 10 FB 8D 10 C0 C9 9B D0
8040:03 4C 2F FB C9 89 B0 16 29 0F 0A AA F0 02 CA CA
8050:BD DD 80 85 00 E8 BD DD 80 85 01 4C 09 80 C9 A0
8060:D0 0B A5 00 A6 01 85 01 86 00 4C 09 80 C9 D9 B0
8070:C4 C9 B8 08 29 0F A8 90 01 88 A9 01 88 30 03 0A
8080:D0 FA 28 B0 06 45 00 85 00 90 04 45 01 85 01 4C
8090:09 80 85 04 A9 80 AA 25 04 F0 04 A9 B1 D0 02 A9
80A0:B0 20 ED FD 8A 4A D0 EE A9 A0 20 ED FD A5 04 20
80B0:DA FD A9 A0 4C ED FD A2 00 A0 17 BD C6 80 20 ED
80C0:FD E8 88 D0 F6 60 8D 8D B7 B6 B5 B4 B3 B2 B1 B0
80D0:A0 A0 A0 A0 C8 C7 C6 C5 C4 C3 C2 C1 8D 00 00 2A
80E0:55 55 2A 7F 7F 80 80 AA D5 D5 AA FF FF
0:58 B1
8000G
```
