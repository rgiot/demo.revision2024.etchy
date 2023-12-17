# Tentative for a eatch-a-sketch 4k

Each picture is depicted by a list of commands. These commands can be hand provided or generated from converter or in realtime

Commands are provided by macros

- `START x, y` to start from a defined location
- `U <amount>`, `D <amount>`, `L <amount>`, `R <amount>` respectively for Up, Down, Left, Right `<amount>` times
- `UL <amount>`, ... for composition amount of time
- `STOP` to close the buffer


(0,0) is at top left


# Binary format

0x0000: X start position in pixel resolution
0x0001: Y start position in pixel resolution


0xnnnn : 0baaaabbbb aaaa = nb repetitions bbbb = action. if aaaa = 0, it is the end
