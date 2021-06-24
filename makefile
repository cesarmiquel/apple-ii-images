AC = java -jar /home/miquel/Develop/AppleII/tools/ac.jar
ACME = /usr/bin/acme
PNG2HGR = ./png2hgr

all: images

images: createimage convertimgs
	echo "Putting images in disk"
	${AC} -p images.dsk zx B 0x2000 < zx.bin
	${AC} -p images.dsk pirate B 0x2000 < pirate.bin
	${AC} -p images.dsk sander B 0x2000 < sanderfocus.bin

createimage:
	echo "Creating new image"
	cp dos33mst.dsk images.dsk

convertimgs:
	${PNG2HGR} zx-sample-01.png > zx.bin
	${PNG2HGR} pirate.png > pirate.bin
	${PNG2HGR} sanderfocus.png > sanderfocus.bin

clean:
	rm zx.bin
