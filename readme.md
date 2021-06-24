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
