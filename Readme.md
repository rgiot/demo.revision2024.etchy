# Tentative for a eatch-a-sketch 4k

## Beam tracing

Each picture is depicted by a list of commands. These commands can be hand provided (courage) or generated from converter (so this has some limitations) or in realtime (not at the moment)

Commands are provided by macros

- `START x, y` to start from a defined location
- `U <amount>`, `D <amount>`, `L <amount>`, `R <amount>` respectively for Up, Down, Left, Right `<amount>` times
- `UL <amount>`, ... for composition amount of time
- `STOP` to close the buffer


(0,0) is at top left


## Binary format

0x0000: X start position in pixel resolution inside the start byte
0x0001: X start position in byte  resolution
0x0002: Y start position in pixel resolution


0xnnnn : 0baaaabbbb aaaa = nb repetitions bbbb = action. if aaaa = 0, it is the end


## How to build the demo

`bndbuild.yml` is the configuration file that describes how to construct the demo. See <https://cpcsdk.github.io/rust.cpclib/bndbuild/> for more documentation.

- `sna` is a target to make a quick build that test if everything workds properly. It generates a snapshot
- `etch4k` is a target to make a slower build that compresses the demo and checks if it fits in 4k. It generates a snapshot but also update the etch4k.dsk file


### To build the compressed version

```
.\tools
```

This is veeeerrrrryyy loooong to assemble, even on a beast.
My assembler is fucking slow on the macro interpretation side and everything relies on hundred of thousands of tiny macro use. 
I am not sure to be able to improve that during the project.
This is the reason why I individually assemble each image.


From scratch it takes 52min on my powerfull Linux machine.
if there is no path computation but all code to assemble it takes <1min.

### To cleanup the folder

```
.\tools\bndbuild.exe distclean
```

BUT be prepared to WAIT A LOT after to rebuild everything

## How to add  an image

Take inspiration to these rules in `bndbuild.yml` to understand how to add an image to convert.

These lines generate `small_connex.asm` from one PNG file

```yaml
- tgt: small_connex.asm
  dep: convert/small_connex.png
  cmd: extern ./tools/convert --euclidean convert/small_connex.png small_connex.asm
- tgt: small_connex.o
  dep: small_connex.asm
  cmd: basm -I src small_connex.asm -o small_connex.o
```


These lines generate  multiple.asm` from several png file

```yaml

- tgt: multiple.asm
  dep: convert/puzzle1.png convert/puzzle2.png convert/puzzle3.png
  cmd: extern ./tools/convert --euclidean convert/puzzle1.png convert/puzzle2.png convert/puzzle3.png multiple.asm
- tgt: multiple.o
  dep: multiple.asm
  cmd: basm -I src multiple.asm -o multiple.o
```


In `src\main.asm` the list of pictures to draw is set up this way

```z80
picture1
	incbin "small_connex.o"
picture2
	incbin "title.o"
picture3
	incbin "multiple.o"
```
so just give a label and use `incbin "file.o` to include the picture stored in file.o

The display order is also set up in  `src\main.asm` 

```z80
unaligned_data
.pictures
	dw picture1
	dw picture2
	dw picture3
	dw 00
```

just add ` dw new_label` to include a new image in the list

## How to test

You can test with :
- http://www.winape.net/ : use gui to select files
- http://www.roudoudou.com/ACE-DL/ (version after Valentine day, previous are buggy with SNA generated for this project) : use drag'n drop to select files

For the compressed version type `RUN"ETCH4K` and wait a while during uncrunch of the demo.
uncompressed version is way faster to start


## Current Limitations

- OSCC + My Flat TV does not like the screen erasing part. SCreen is black. Need to be able to disable taht at last minute if revision people have the same issue