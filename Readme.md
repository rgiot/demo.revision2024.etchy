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

- `sna` is a target to make a quick build that test if everything workds properly. It generates a snapshot but also update the etch4k.dsk file
- `etch4k` is a target to make a slower build that compresses the demo and checks if it fits in 4k. It generates a snapshot but also update the etch4k.dsk file


### To build the compressed version

```
.\tools
```

This is veeeerrrrryyy loooong to assemble, even on a beast.
My assembler is fucking slow on the macro interpretation side and everything relies on hundred of thousands of tiny macro use. 
I am not sure to be able to improve that during the project.
This is the reason why I individually assemble each image.

### To cleanup the folder

```
.\tools\bndbuild.exe distclean
```

## How to convert an image

```
./tools/convert IMG1.PNG IMG2.PNG data.asm
```

## How to test

From a snapshot: use winape emulator http://www.winape.net/
From a dsk: 

 - use winape emulator or Ace-DL http://www.roudoudou.com/ACE-DL/
 - type `RUN"ETCH4K` and wait a while during uncrunch of the demo


## Current Limitations

- OSCC + My Flat TV does not like the screen erasing part. SCreen is black. Need to be able to disable taht at last minute if revision people have the same issue