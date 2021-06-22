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
