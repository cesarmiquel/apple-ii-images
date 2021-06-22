AC = java -jar /home/miquel/Develop/AppleII/tools/ac.jar
ACME = /usr/bin/acme
PNG2HGR = ./png2hgr

all: images

images: createimage convertimgs
	echo "Putting images in disk"
	${AC} -p images.dsk zx B 0x2000 < zx.bin

createimage:
	echo "Creating new image"
	cp dos33mst.dsk images.dsk

convertimgs:
	${PNG2HGR} zx-sample-01.png > zx.bin

clean:
	rm zx.bin
